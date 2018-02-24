#!/usr/bin/env python3
"""Start an HTTP server from a directory, optionally specifying the port"""

import optparse
import webbrowser
import http.server
import socket
import socketserver


def get_local_ip():
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
        s.connect(("8.8.8.8", 80))
        return s.getsockname()[0]

def main():
    p = optparse.OptionParser(description=__doc__)
    p.add_option("-p", "--port", dest="port", default=8000,
                  help="specify the port (default: 8000)")
    options, arguments = p.parse_args()
    Handler = http.server.SimpleHTTPRequestHandler

    with socketserver.TCPServer(("", int(options.port)), Handler) as httpd:
        print("   Local URL:", f"http://localhost:{options.port}")
        print("External URL:", f"http://{get_local_ip()}:{options.port}")
        httpd.serve_forever()

if __name__ == '__main__':
    main()
