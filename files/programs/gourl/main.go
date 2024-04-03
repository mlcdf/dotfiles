/*
gourl performs (multiple) HTTP requests and gathers stats.
It provides an API as close to cURL as possible and can be distributed as a static binary (perfect for containers).

Sometime you need something a little more suitable than cURL to generate traffic but not as complexe as say k6. This is where gourl comes in.
*/
package main

import (
	"bytes"
	"crypto/tls"
	"flag"
	"fmt"
	"html/template"
	"io"
	"log"
	"net/http"
	"net/http/httptrace"
	"os"
	"os/signal"
	"reflect"
	"strings"
	"sync"
	"syscall"
	"time"

	"golang.org/x/sys/unix"
)

const usage = `
Performs (multiple) HTTP requests and gathers stats while providing an API as close
to cURL as possible.

Usage:
    gourl [options...] <url>

Options:
    -X, --request          HTTP method
    -H, --header           Pass custom header(s)
    -d, --data             Request data/payload
    -V, --version          Print version
    -v, --verbose          Verbose terminal output
    -h, --help             Show info usage

    --interval             Interval between requests
    --no-connection-reuse  Turn off HTTP connection reuse

Examples:
    gourl https://httpbin.org -d "yolo"
    gourl https://httpbin.org -H "Authorization: ${token}"
`

// Version is set at build time using -ldflags="-X 'main.Version=v1.0.0'
var Version = "devel"
var isVerbose bool

type headerFlag struct {
	http.Header
}

func (f headerFlag) String() string {
	return ""
}

func (f headerFlag) Set(value string) error {
	splitted := strings.SplitN(value, ":", 2)
	f.Header[splitted[0]] = []string{strings.TrimSpace(splitted[1])}
	return nil
}

func newHeaderFlag() headerFlag {
	return headerFlag{
		Header: make(map[string][]string),
	}
}

type dataFlag []string

func (f *dataFlag) Set(value string) error {
	*f = append(*f, value)
	return nil
}

func (f *dataFlag) String() string {
	return "n"
}

func main() {
	log.SetFlags(0)
	flag.Usage = func() { fmt.Fprint(os.Stderr, usage) }

	if len(os.Args) == 1 {
		flag.Usage()
		os.Exit(0)
	}

	var method = http.MethodGet
	flag.StringVar(&method, "X", method, "HTTP Method")
	flag.StringVar(&method, "request", method, "HTTP Method")

	headerFlag := newHeaderFlag()
	flag.Var(&headerFlag, "H", "Pass custom header(s)")
	flag.Var(&headerFlag, "header", "Pass custom header(s)")

	var data dataFlag
	flag.Var(&data, "data", "Request data/payload")
	flag.Var(&data, "d", "Request data/payload")

	var interval float64
	flag.Float64Var(&interval, "interval", interval, "Interval between requests")

	var noConnectionReuse bool
	flag.BoolVar(&noConnectionReuse, "no-connection-reuse", noConnectionReuse, "Turn off HTTP connection reuse")

	flag.BoolVar(&isVerbose, "verbose", isVerbose, "Verbose terminal output")
	flag.BoolVar(&isVerbose, "v", isVerbose, "Verbose terminal output")

	var versionFlag bool
	flag.BoolVar(&versionFlag, "version", versionFlag, "print the version")
	flag.BoolVar(&versionFlag, "V", versionFlag, "print the version")

	flag.CommandLine.Parse(os.Args[firstArgWithDash(os.Args):])

	if versionFlag {
		fmt.Printf("gourl (%s)\n", Version)
		return
	}

	var url string
	if !strings.HasPrefix(os.Args[1], "-") {
		url = os.Args[1]
	} else {
		url = flag.Arg(0)
	}

	roundTripper := newRoundTripper(noConnectionReuse)
	reporter := newReporter(interval)

	req, err := prepareRequest(url, method, headerFlag.Header, data)
	if err != nil {
		log.Fatalln(err)
	}

	if isVerbose {
		reporter.request(req)
		if err != nil {
			log.Fatalln(err)
		}
	}

	if interval == 0 {
		runSimple(req, roundTripper, reporter)
	} else {
		run(req, roundTripper, reporter, interval)
	}
}

func runSimple(req *http.Request, roundTripper http.RoundTripper, reporter Reporter) {
	res, trace, err := request(req, roundTripper)
	if err != nil {
		log.Fatalln(err)
	}

	err = reporter.result(res, trace)
	if err != nil {
		log.Fatalln(err)
	}
}

func run(req *http.Request, roundTripper http.RoundTripper, reporter Reporter, interval float64) {
	cancelChan := make(chan os.Signal, 1)
	// catch SIGETRM or SIGINTERRUPT
	signal.Notify(cancelChan, syscall.SIGTERM, syscall.SIGINT)

	go func() {
		for {
			req, err := cloneRequest(req)
			if err != nil {
				log.Fatalf("failed to clone request: %v", err)
			}

			res, trace, err := request(req, roundTripper)
			if err != nil {
				log.Fatalf("failed to perform request: %v", err)
			}

			err = reporter.result(res, trace)
			if err != nil {
				log.Fatalln(err)
			}

			time.Sleep(time.Second * time.Duration(interval))
		}
	}()
	<-cancelChan
}

// If a commandline app works like this: ./app subcommand -flag -flag2
// `flag.Parse` won't parse anything after `subcommand`.
// To still be able to use `flag.String/flag.Int64` etc without creating
// a new `flag.FlagSet`, we need this hack to find the first arg that has a dash
// so we know when to start parsing
func firstArgWithDash(args []string) int {
	index := 1
	for i := 1; i < len(args); i++ {
		index = i

		if len(args[i]) > 0 && args[i][0] == '-' {
			break
		}
	}
	return index
}

type Header struct {
	Key   string
	Value string
}

type Trace struct {
	client               *httptrace.ClientTrace
	DNSLookUp            time.Duration
	TLSHandshake         time.Duration
	Connect              time.Duration
	FromStartToFirstByte time.Duration
	Total                time.Duration
}

func (t *Trace) String() string {
	buf := bytes.Buffer{}

	buf.WriteString(fmt.Sprintf("DNS Done:            %9v\n", t.DNSLookUp.Round(time.Millisecond)))
	buf.WriteString(fmt.Sprintf("TLS Handshake:       %9v\n", t.TLSHandshake.Round(time.Millisecond)))
	buf.WriteString(fmt.Sprintf("Connect time:        %9v\n", t.Connect.Round(time.Millisecond)))
	buf.WriteString(fmt.Sprintf("Start to first byte: %9v\n", t.FromStartToFirstByte.Round(time.Millisecond)))
	buf.WriteString(fmt.Sprintf("Total time:          %9v", t.Total.Round(time.Millisecond)))

	return buf.String()
}

func newTrace() *Trace {
	var start, connect, dns, tlsHandshake time.Time
	trace := &Trace{}

	trace.client = &httptrace.ClientTrace{
		GetConn:  func(hostPort string) { start = time.Now() },
		DNSStart: func(dsi httptrace.DNSStartInfo) { dns = time.Now() },
		DNSDone: func(ddi httptrace.DNSDoneInfo) {
			// fmt.Printf("DNS Done: %v\n", time.Since(dns))
			trace.DNSLookUp = time.Since(dns)
		},

		TLSHandshakeStart: func() { tlsHandshake = time.Now() },
		TLSHandshakeDone: func(cs tls.ConnectionState, err error) {
			// fmt.Printf("TLS Handshake: %v\n", time.Since(tlsHandshake))
			trace.TLSHandshake = time.Since(tlsHandshake)
		},

		ConnectStart: func(network, addr string) { connect = time.Now() },
		ConnectDone: func(network, addr string, err error) {
			// fmt.Printf("Connect time: %v\n", time.Since(connect))
			trace.Connect = time.Since(connect)
		},

		GotFirstResponseByte: func() {
			// fmt.Printf("Time from start to first byte: %v\n", time.Since(start))
			trace.FromStartToFirstByte = time.Since(start)
		},
	}
	return trace
}

func prepareRequest(u string, method string, headers http.Header, data []string) (*http.Request, error) {
	if len(data) != 0 {
		method = http.MethodPost
	}

	if headers == nil {
		headers = make(http.Header)
	}

	var body io.Reader
	if len(data) > 0 {
		body = strings.NewReader(strings.Join(data, "&"))
	}

	req, err := http.NewRequest(method, u, body)
	if err != nil {
		return nil, err
	}

	if headers.Get("Content-type") == "" && len(data) > 0 {
		headers.Add("Content-type", "application/x-www-form-urlencoded")
	}

	if headers.Get("User-Agent") == "" {
		headers.Add("User-Agent", "gourl (https://github.com/mlcdf/gourl)")
	}

	req.Header = headers

	return req, nil
}

func newRoundTripper(noConnectionReuse bool) http.RoundTripper {
	t := http.DefaultTransport.(*http.Transport).Clone()
	t.DisableKeepAlives = noConnectionReuse
	return t
}

func request(req *http.Request, rt http.RoundTripper) (*http.Response, *Trace, error) {
	trace := newTrace()
	req = req.WithContext(httptrace.WithClientTrace(req.Context(), trace.client))

	start := time.Now()

	res, err := rt.RoundTrip(req)
	if err != nil {
		return nil, trace, err
	}

	trace.Total = time.Since(start)
	return res, trace, nil
}

func cloneRequest(req *http.Request) (*http.Request, error) {
	clone := req.Clone(req.Context())
	if req.Body == nil || req.Body == http.NoBody {
		return clone, nil
	}

	var err error
	clone.Body, err = req.GetBody()
	if err != nil {
		return nil, fmt.Errorf("failed to clone the request body: %w", err)
	}
	return clone, nil
}

var tmpl = `{{.Method}} {{.URL}}
{{- range $name, $values := .Header }}
{{ $name | bold }}: {{ range $index, $value := $values -}} {{- $value }}{{ if last $index $values | not }}, {{ end }}{{ end -}}
{{ end }}
`

var once sync.Once

type Reporter interface {
	request(*http.Request) error
	result(*http.Response, *Trace) error
	// export() error
}

type Result struct {
	res   *http.Response
	trace *Trace
}

type SimpleReport struct {
	stdout io.Writer
	stderr io.Writer
}

type Report struct {
	SimpleReport
	results []Result
}

func newReporter(interval float64) Reporter {
	if interval > 0 {
		return &Report{
			SimpleReport: SimpleReport{stdout: os.Stdout, stderr: os.Stderr},
			results:      make([]Result, 0),
		}
	}

	return &SimpleReport{
		stdout: os.Stdout,
		stderr: os.Stderr,
	}
}

func (r *Report) result(res *http.Response, trace *Trace) error {
	// https://stackoverflow.com/questions/17948827/reusing-http-connections-in-go
	defer res.Body.Close()
	_, err := io.ReadAll(res.Body)
	if err != nil {
		return err
	}
	//

	r.results = append(r.results, Result{res, trace})

	once.Do(func() {
		fmt.Fprintln(r.stdout, "Code    DNS lookup    TLS handshake        Connect      Start to first byte          Total")
	})

	fmt.Fprintf(r.stdout, "%d      %9v        %9v      %9v                %9s      %9s\n",
		res.StatusCode, trace.DNSLookUp.Round(time.Millisecond),
		trace.TLSHandshake.Round(time.Millisecond),
		trace.Connect.Round(time.Millisecond),
		trace.FromStartToFirstByte.Round(time.Millisecond),
		trace.Total.Round(time.Millisecond))
	return nil
}

func (r *SimpleReport) result(res *http.Response, trace *Trace) error {

	fmt.Fprintln(r.stdout, "--------------------------------------------------------------------------------")
	fmt.Fprintln(r.stdout, trace)

	fmt.Fprintln(r.stdout, "--------------------------------------------------------------------------------")
	fmt.Fprintf(r.stdout, "%s\n", res.Status)

	if isVerbose {
		defer res.Body.Close()
		body, err := io.ReadAll(res.Body)
		if err != nil {
			return err
		}
		fmt.Fprintf(r.stdout, "%s\n", body)
	}
	return nil
}

func stdoutIsTerm() bool {
	_, err := unix.IoctlGetTermios(int(os.Stdout.Fd()), unix.TCGETS)
	return err == nil
}

var fns = template.FuncMap{
	"last": func(x int, a interface{}) bool {
		return x == reflect.ValueOf(a).Len()-1
	},

	"bold": func(x string) string {
		if !stdoutIsTerm() {
			return x
		}
		return "\033[1m" + x + "\033[0m"
	},
}

func (r *SimpleReport) request(req *http.Request) error {
	tmpl, err := template.New("request").Funcs(fns).Parse(tmpl)
	if err != nil {
		return err
	}

	return tmpl.Execute(r.stderr, req)
}

func (r *Report) request(req *http.Request) error {
	tmpl, err := template.New("request").Funcs(fns).Parse(tmpl)
	if err != nil {
		return err
	}

	return tmpl.Execute(r.stderr, req)
}
