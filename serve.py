"""Serve the Training Feed on http://127.0.0.1:8765 with caching disabled, so a plain refresh always loads the latest index.html."""
import functools
import http.server
import os

PORT = 8765


class NoCacheHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-store")
        super().end_headers()

    def log_message(self, *args):
        pass


handler = functools.partial(NoCacheHandler, directory=os.path.dirname(os.path.abspath(__file__)))
http.server.ThreadingHTTPServer(("127.0.0.1", PORT), handler).serve_forever()
