.PHONY: test

# vars

ifdef CIRCLE_SHA1
TAG ?= $(CIRCLE_SHA1)
else
TAG ?= $(shell git rev-parse HEAD)
endif

SERVICES := core
HTMLCOV_DIR ?= htmlcov
IMAGES := $(SERVICES)

CONTEXT ?= david.k8s.local
NAMESPACE ?= demo
SERVICE_NAME ?= cc-facade


install-dependencies:
	pip install -U -e ".[dev]"

# test
coverage-html:
	coverage html -d $(HTMLCOV_DIR) --fail-under 100

coverage-report:
	coverage report -m

test:
	flake8 src test
	coverage run --concurrency=eventlet --source=cc -m pytest test $(ARGS)

coverage: test coverage-report coverage-html


# docker

docker-login:
	echo $$DOCKER_PASSWORD | docker login --username=$(DOCKER_USERNAME) --password-stdin

build-base:
	docker build --target base -t facade-base .;
	docker build --target builder -t facade-builder .;

build: build-base
	for image in $(IMAGES); do TAG=$(TAG) make -C deploy/$$image build-image; done

docker-save:
	mkdir -p docker-images
	docker save -o docker-images/cc-facade.tar $(foreach image, $(IMAGES), cc-facade-$(image):$(TAG))

docker-load:
	docker load -i docker-images/cc-facade.tar

docker-tag:
	for image in $(IMAGES); do make -C deploy/$$image docker-tag; done

push-images:
	for image in $(IMAGES); do make -C deploy/$$image docker-push; done


# k8s
deploy-namespace:
	kubectl --context=$(CONTEXT) apply -f deploy/k8s/namespace.yaml


# helm

test-chart:
	helm upgrade cc-facade deploy/k8s/charts/$(SERVICE_NAME) --install \
	--namespace=$(NAMESPACE) --kube-context=$(CONTEXT)
	--dry-run --debug --set image.tag=$(TAG)

install-chart:
	helm upgrade cc-facade deploy/k8s/charts/$(SERVICE_NAME) --install \
	--namespace=default \
	--kube-context=$(CONTEXT) \
	--set image.tag=$(TAG)

lint-chart:
	helm lint deploy/k8s/charts/$(SERVICE_NAME) --strict

initial-cluster: deploy-namespace
	helm --kube-context=$(CONTEXT) install --name guest --namespace demo stable/rabbitmq
