# -*- coding: utf-8 -*-

import json

from nameko.web.handlers import http
from nameko.rpc import RpcProxy
from werkzeug import Response


class UserService:

    users_rpc = RpcProxy("users")

    @http("POST", "/session")
    def login(self, request):
        # TODO: should return token, do like this temporarily.
        user_data = json.loads(request.get_data(as_text=True))

        user = self.users_rpc.get_user(email=user_data["email"])

        return Response(
            json.dumps(user),
            mimetype="application/json"
        )
