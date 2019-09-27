FROM python:3.7-slim-stretch as base

RUN apt-get update && \
    apt-get install --yes curl netcat && \
    rm -rf /var/cache/apt && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --upgrade pip && \
    pip install virtualenv && \
    virtualenv -p python3 /appenv && \
    groupadd -r nameko && useradd -r -g nameko nameko && \
    mkdir /var/nameko && chown -R nameko:nameko /var/nameko

ENV path=/appenv/bin:${PATH}

# --------

FROM facade-base as builder

RUN pip install auditwheel

COPY . /application

ENV PIP_WHEEL_DIR=/application/wheelhouse
ENV PIP_FIND_LINKS=/application/wheelhouse