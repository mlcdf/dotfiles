package main

import (
	"bufio"
	"bytes"
	"io"
	"net/http"
	"strings"
	"testing"
)

func TestNoTabInUsage(t *testing.T) {
	scanner := bufio.NewScanner(strings.NewReader(usage))
	for scanner.Scan() {
		line := scanner.Text()
		if strings.HasPrefix(line, "\t") {
			t.Errorf("line %s start with a tabulation character", line)
		}
	}
	if scanner.Err() != nil {
		t.Errorf("failed to read usage")
	}
}

func TestReporter(t *testing.T) {
	req, err := http.NewRequest("GET", "https://mlcdf.fr", nil)
	req.Header.Add("Access-Control-Allow-Headers", "content-type")
	req.Header.Add("Access-Control-Allow-Headers", "authorization")
	req.Header.Add("Authorization", "Bearer xxx")

	if err != nil {
		t.Fatal(err)
	}

	buf := &bytes.Buffer{}
	reporter := SimpleReport{
		stdout: io.Discard,
		stderr: buf,
	}
	err = reporter.request(req)
	if err != nil {
		t.Fatal(err)
	}

	txt := buf.String()
	expected := `GET https://mlcdf.fr
Access-Control-Allow-Headers: content-type, authorization
Authorization: Bearer xxx
`
	if txt != expected {
		t.Errorf("'%s' != '%s'", txt, expected)
	}
}
