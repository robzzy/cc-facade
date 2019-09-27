# -*- coding: utf-8 -*-

import pytest
from collections import namedtuple

from nameko.testing.services import replace_dependencies

from cc.services.core.service import CCFacade


@pytest.fixture
def test_config(web_config, rabbit_config):
    yield


@pytest.fixture
def create_service_meta(container_factory, test_config):

    def create(*dependencies, **dependency_map):
        dependency_names = list(dependencies) + list(dependency_map.keys())

        ServiceMeta = namedtuple(
            "ServiceMeta", ["container"] + dependency_names
        )

        container = container_factory(CCFacade)

        mocked_dependencies = replace_dependencies(
            container, *dependencies, **dependency_map
        )
        if len(dependency_names) == 1:
            mocked_dependencies = (mocked_dependencies, )

        container.start()

        return ServiceMeta(container, *mocked_dependencies, **dependency_map)

    return create


@pytest.fixture
def cc_facade(create_service_meta):
    return create_service_meta()
