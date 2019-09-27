# -*- coding: utf-8 -*-


class TestCCFacade:

    def test_health_check(self, cc_facade, web_session):

        response = web_session.get("/healthcheck")

        assert response.status_code == 200
        assert response.json() == {"status": "ok"}
