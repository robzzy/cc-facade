.PHONY: etc

COMPONENT := core

include ../Makefile.common

run:
	nameko run --config config.yaml cc.services.$(COMPONENT).service:CCFacade
