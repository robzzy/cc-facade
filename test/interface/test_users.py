# -*- coding: utf-8

import json

from mock import call


class TestUserService:

    def test_login(self, cc_facade, web_session):

        cc_facade.users_rpc.get_user.return_value = (
            {"email": "iamdavidzeng@gmail.com"}
        )

        response = web_session.post("/session", json.dumps({
            "email": "iamdavidzeng@gmail.com"
        }))

        assert response.status_code == 200
        assert response.json() == {"email": "iamdavidzeng@gmail.com"}
        assert cc_facade.users_rpc.get_user.call_args == call(
            email="iamdavidzeng@gmail.com"
        )
