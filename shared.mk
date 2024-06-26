ifndef _include_shared_mk
_include_shared_mk := 1

OS ?= $(shell uname -s | tr [:upper:] [:lower:])
ARCH ?= $(shell uname -m)

ifeq ($(ARCH),x86_64)
	ARCH = amd64
endif

BUILD ?= build
SHELL := env PATH=$(abspath $(BUILD)):$(shell echo $$PATH) /bin/bash

$(BUILD):
	@mkdir -p $(BUILD)

.PHONY: help clean deps vendor generate format lint test test-cover integration-test build bootrap deploy run dev debug

all: deps generate format lint test build

help: ## Help
	@cat $(sort $(MAKEFILE_LIST)) | grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | sort

clean: clean-build ## Clean targets

tools: ## Download tools

deps: ## Download dependencies

vendor: ## Vendor dependencies

generate: ## Generate code

format: ## Format code

lint: ## Lint code

test: ## Run tests

test-cover: ## Run tests with coverage

integration-test: ## Run integration tests

integration-test-cover: ## Run integration tests with coverage

build: ## Build all targets

bootstrap: ## Bootstrap

deploy: ## Deploy

run: ## Run

dev: ## Run in development mode

debug: ## Run in debug mode

.PHONY: clean-build

clean-build: ## Clean build tools
	$(info $(_bullet) Cleaning <build>)
	rm -rf $(BUILD)

_bullet := $(shell printf "\033[34;1m▶\033[0m")

endif