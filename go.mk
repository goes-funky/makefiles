ifndef _include_go_mk
_include_go_mk = 1

include makefiles/shared.mk

GO ?= go
FORMAT_FILES ?= .

GOFUMPT_VERSION ?= v0.2.0
GOFUMPT_ROOT := $(BUILD)/gofumpt-$(GOFUMPT_VERSION)
GOFUMPT := $(GOFUMPT_ROOT)/gofumpt

GOLANGCILINT_VERSION ?= v1.42.0
GOLANGCILINT_ROOT := $(BUILD)/golangci-lint-$(GOLANGCILINT_VERSION)
GOLANGCILINT := $(GOLANGCILINT_ROOT)/golangci-lint
GOLANGCILINT_CONCURRENCY ?= 16

$(GOFUMPT): export GOBIN = $(abspath $(GOFUMPT_ROOT))

$(GOFUMPT):
	$(info $(_bullet) Installing <gofumpt>)
	@mkdir -p $(GOFUMPT_ROOT)
	$(GO) install mvdan.cc/gofumpt@$(GOFUMPT_VERSION)

$(GOLANGCILINT): export GOBIN = $(abspath $(GOLANGCILINT_ROOT))

$(GOLANGCILINT):
	$(info $(_bullet) Installing <golangci-lint>)
	$(GO) install github.com/golangci/golangci-lint/cmd/golangci-lint@$(GOLANGCILINT_VERSION)

clean: clean-go

tools: tools-go

deps: deps-go

vendor: vendor-go

format: format-go

lint: lint-go

test: test-go

test-coverage: test-coverage-go

integration-test: integration-test-go

.PHONY: clean-go tools-go deps-go format-go lint-go test-go test-coverage-go integration-test-go

clean-go: ## Clean Go
	$(info $(_bullet) Cleaning <go>)
	rm -rf vendor/

deps-go: ## Tidy go dependencies
	$(info $(_bullet) Tidy dependencies <go>)
	$(GO) mod tidy
	$(GO) mod download

tools-go: $(GOFUMPT) $(GOLANGCILINT)

vendor-go: ## Vendor Go dependencies
	$(info $(_bullet) Vendoring dependencies <go>)
	$(GO) mod vendor

format-go: $(GOFUMPT) ## Format Go code
	$(info $(_bullet) Formatting code)
	$(GOFUMPT) -w $(FORMAT_FILES)

lint-go: $(GOLANGCILINT)
	$(info $(_bullet) Linting <go>) 
	$(GOLANGCILINT) run --concurrency $(GOLANGCILINT_CONCURRENCY) ./...

test-go: ## Run Go tests
	$(info $(_bullet) Running tests <go>)
	$(GO) test ./...
	
test-coverage-go: ## Run Go tests with coverage
	$(info $(_bullet) Running tests with coverage <go>)
	$(GO) test -cover ./...

integration-test-go: ## Run Go integration tests
	$(info $(_bullet) Running integration tests <go>)
	$(GO) test -tags integration -count 1 ./...

endif