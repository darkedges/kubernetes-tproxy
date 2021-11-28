import os

import requests as requests
from mitmproxy.http import HTTPFlow
from mitmproxy.script import concurrent
from mitmproxy import ctx


class ExternalLogger:

    remote_server: str = None

    def __init__(self, remote_server):
        self.remote_server = remote_server

    @concurrent
    def request(self, flow: HTTPFlow) -> None:
        ctx.log.info("Request to %s" % flow.request.pretty_url)

        requests.post(self.remote_server, json={
            'url': flow.request.pretty_url,
            'request': flow.request,
            'error': flow.error
        })

    @concurrent
    def response(self, flow: HTTPFlow) -> None:
        ctx.log.info("response from %s" % flow.request.pretty_url)

        requests.post(self.remote_server, json={
            'url': flow.request.pretty_url,
            'response': flow.response,
            'error': flow.error
        })


addons = [ExternalLogger(os.getenv("REMOTE_SERVER"))]
