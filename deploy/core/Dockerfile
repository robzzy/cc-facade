FROM facade-builder AS wheels

COPY . /application

RUN cd /application && pip wheel .

# ------

FROM facade-base AS install

COPY --from=wheels /application/wheelhouse /wheelhouse

RUN pip install --no-index -f /wheelhouse cc

# ------

FROM facade-base AS service

COPY --from=install /appenv /appenv

COPY config.yaml /var/nameko/config.yaml

USER nameko

WORKDIR /var/nameko

EXPOSE 8000

CMD . /appenv/bin/activate && \
    nameko run --config config.yaml cc.services.core.service:CCFacade --backdoor-port 3000