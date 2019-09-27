# -*- coding: utf-8 -*-

import json
from nameko.web.handlers import http


class CCFacade:

    name = "cc"

    @http("GET", "/healthcheck")
    def health_check(self, request):
        return json.dumps({"status": "ok"})
