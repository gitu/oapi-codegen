.DEFAULT_GOAL = all

version  := $(shell git rev-list --count HEAD).$(shell git rev-parse --short HEAD)

name     := oapi-codegen
package  := github.com/deepmap/$(name)
packages := $(shell go list ./...)

.PHONY: all
all:: dependencies
all:: codegen

.PHONY: dependencies
dependencies::
	go mod tidy
	go mod download

.PHONY: test
test::
	go test -v $(packages)

.PHONY: bench
bench::
	go test -bench=. -v $(packages)

.PHONY: lint
lint::
	go vet -v $(packages)

.PHONY: check
check:: lint test


.PHONY: codegen
codegen::
	go generate ./pkg/codegen/templates
	go generate ./...

.PHONY: clean
clean::
	git clean -xddff