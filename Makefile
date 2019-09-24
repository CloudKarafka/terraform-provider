help:
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

depupdate:  ## Update all vendored dependencies
	dep ensure -update

build:  ## Build cloudamqp provider
	go build -o terraform-provider-cloudkarafka

install: build  ## Install cloudamqp provider into terraform plugin directory
	mkdir -p ~/.terraform.d/plugins/
	mv terraform-provider-cloudkarafka ~/.terraform.d/plugins/

init: install  ## Run terraform init for local testing
	terraform init

.PHONY: help build install init
.DEFAULT_GOAL := help
