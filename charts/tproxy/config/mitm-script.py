import os

import requests as requests
from mitmproxy.http import HTTPFlow
from mitmproxy.script import concurrent
from mitmproxy import ctx


class ExternalLogger:

    @concurrent
    def request(self, flow: HTTPFlow) -> None:
        ctx.log.debug("Request to %s" % flow.request.pretty_url)

    @concurrent
    def response(self, flow: HTTPFlow) -> None:
        ctx.log.debug("response from %s" % flow.request.pretty_url)

addons = [ExternalLogger()]
