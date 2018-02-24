#!/usr/bin/env python3
"""Start an HTTP server from a directory, optionally specifying the port"""

import optparse
import webbrowser
import http.server
import socket
import socketserver
import subprocess


def copy_to_clipboard(txt):
    cmd=f'echo "{txt.strip()}" | xsel --clipboard --input'
    return subprocess.check_call(cmd, shell=True)

def get_local_ip():
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
        s.connect(("8.8.8.8", 80))
        return s.getsockname()[0]

def main():
    p = optparse.OptionParser(description=__doc__)
    p.add_option("-p", "--port", dest="port", type="int", default=8000,
                  help="specify the port (default: 8000)")
    p.add_option("-o", "--open", dest="open", default=False,
                  help="open the url in a new browser tab", action="store_true")
    options, arguments = p.parse_args()

    with socketserver.TCPServer(("", options.port), http.server.SimpleHTTPRequestHandler) as httpd:
        local_url = f"http://localhost:{options.port}"
        external_url = f"http://{get_local_ip()}:{options.port}"
        print("   Local URL:", local_url)
        print("External URL:", external_url)

        if (options.open):
            webbrowser.open_new_tab(local_url)
        else:
            copy_to_clipboard(local_url)

        httpd.serve_forever()

if __name__ == '__main__':
    main()
