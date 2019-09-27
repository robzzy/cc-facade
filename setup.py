# -*- coding: utf-8 -*-

from setuptools import find_packages, setup


setup(
    name="cc",
    version="0.0.1",
    description="Facade for woshizzy",
    packages=find_packages("src", exclude=["test", "test.*"]),
    package_dir={"": "src"},
    install_requires=[
        "marshmallow==2.19.5",
        "nameko==3.0.0-rc8",
        "nameko-tracer==1.2.0",
    ],
    extras_require={
        "dev": [
            "pytest==4.5.0",
            "coverage==4.5.3",
            "flake8>=3.7.7",
        ]
    },
    zip_safe=True,
)