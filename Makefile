## CloudKarafka provider version
version = 0.9.0

## Check if a 64 bit kernel is running
UNAME_M := $(shell uname -m)

UNAME_P := $(shell uname -p)
ifeq ($(UNAME_P),i386)
	ifeq ($(UNAME_M),x86_64)
		GOARCH += amd64
	else
		GOARCH += i386
	endif
else
    ifeq ($(UNAME_P),AMD64)
        GOARCH += amd64
    endif
endif


UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    GOOS += linux
endif
ifeq ($(UNAME_S),Darwin)
    GOOS += darwin
endif

help:
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean:  ## Clean files
	rm -f ~/.terraform.d/plugins/terraform-provider-cloudkarafka*

release: ## Cross-compile release provider for different architecture
	echo "Building linux-386"
	GOOS=linux GOARCH=386 go build -o terraform-provider-cloudkarafka_v$(version)
	tar -czvf terraform-provider-cloudkarafka_v$(version)_linux_386.tar.gz terraform-provider-cloudkarafka_v$(version)
	mkdir -p $(CURDIR)/bin/release/linux/386
	mv terraform-provider-cloudkarafka_v$(version)_linux_386.tar.gz bin/release/linux/386/

	echo "Building linux-amd64"
	GOOS=linux GOARCH=amd64 go build -o terraform-provider-cloudkarafka_v$(version)
	tar -czvf terraform-provider-cloudkarafka_v$(version)_linux_amd64.tar.gz terraform-provider-cloudkarafka_v$(version)
	mkdir -p $(CURDIR)/bin/release/linux/amd64
	mv terraform-provider-cloudkarafka_v$(version)_linux_amd64.tar.gz bin/release/linux/amd64/

	echo "Building darwin-amd64"
	GOOS=darwin GOARCH=amd64 go build -o terraform-provider-cloudkarafka_v$(version)
	tar -czvf terraform-provider-cloudkarafka_v$(version)_darwin_amd64.tar.gz terraform-provider-cloudkarafka_v$(version)
	mkdir -p $(CURDIR)/bin/release/darwin/amd64
	mv terraform-provider-cloudkarafka_v$(version)_darwin_amd64.tar.gz bin/release/darwin/amd64/

	echo "Building windows-386"
	GOOS=windows GOARCH=386 go build -o terraform-provider-cloudkarafka_v$(version)
	tar -czvf terraform-provider-cloudkarafka_v$(version)_windows_386.tar.gz terraform-provider-cloudkarafka_v$(version)
	mkdir -p $(CURDIR)/bin/release/windows/386
	mv terraform-provider-cloudkarafka_v$(version)_windows_386.tar.gz bin/release/windows/386/

	echo "Building windows-amd64"
	GOOS=windows GOARCH=amd64 go build -o terraform-provider-cloudkarafka_v$(version)
	tar -czvf terraform-provider-cloudkarafka_v$(version)_windows_amd64.tar.gz terraform-provider-cloudkarafka_v$(version)
	mkdir -p $(CURDIR)/bin/release/windows/amd64
	mv terraform-provider-cloudkarafka_v$(version)_windows_amd64.tar.gz bin/release/windows/amd64/

build:  ## Build cloudkarafka provider
	@echo $(GOOS);
	@echo $(GOARCH);
	GOOS=$(GOOS) GOARCH=$(GOARCH) go build -ldflags "-X github.com/cloudkarafka/terraform-provider-cloudkarafka/cloudkarafka.version=$(version)" -o terraform-provider-cloudkarafka_v$(version)

install: build  ## Install cloudkarafka provider into terraform plugin directory
	mkdir -p ~/.terraform.d/plugins/github.com/e-conomic/cloudkarafka/$(version)/$(GOOS)_$(GOARCH)/
	cp $(CURDIR)/terraform-provider-cloudkarafka_v$(version) ~/.terraform.d/plugins/github.com/e-conomic/cloudkarafka/$(version)/$(GOOS)_$(GOARCH)/

init: install  ## Run terraform init for local testing
	terraform init

.PHONY: help build install init
.DEFAULT_GOAL := help
