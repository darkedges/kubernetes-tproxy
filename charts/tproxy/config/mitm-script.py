import os

import requests as requests
from mitmproxy.http import HTTPFlow
from mitmproxy.script import concurrent
from urllib.parse import urljoin
from mitmproxy import ctx

REMOTE_SERVER = os.getenv('REMOTE_SERVER')
REMOTE_ENDPOINT = '/api/v1.0/interceptor'

INTERCEPT_ENDPOINT = urljoin(REMOTE_SERVER, REMOTE_ENDPOINT)

class ExternalLogger:

    def __init__(self):
        pass

    @concurrent
    def request(self, flow: HTTPFlow) -> None:
        ctx.log.info("Request to %s" % flow.request.pretty_url)

        requests.post(INTERCEPT_ENDPOINT, json={
            'url': flow.request.pretty_url,
            'request': flow.request,
            'error': flow.error
        })

    @concurrent
    def response(self, flow: HTTPFlow) -> None:
        ctx.log.info("response from %s" % flow.request.pretty_url)

        requests.post(INTERCEPT_ENDPOINT, json={
            'url': flow.request.pretty_url,
            'response': flow.response,
            'error': flow.error
        })
