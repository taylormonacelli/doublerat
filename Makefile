BIN := doublerat

GOPATH := $(shell go env GOPATH)

ifeq ($(OS),Windows_NT)
    GO_FILES := $(shell dir /S /B *.go)
    GO_DEPS := $(shell dir /S /B go.mod go.sum)
    CLEAN := del
else
    GO_FILES := $(shell find . -name '*.go')
    GO_DEPS := $(shell find . -name go.mod -o -name go.sum)
    CLEAN := rm -f
endif

$(BIN): $(GO_FILES) $(GO_DEPS)
	go mod tidy
	gofumpt -w $(GO_FILES)
	golangci-lint run
	go build -o $(BIN) main.go

.PHONY: test
test: $(BIN)
	./$(BIN) -v -v test1

.PHONY: install
install: $(BIN)
	mv $(BIN) $(GOPATH)/bin/$(BIN)

.PHONY: clean
clean:
	$(CLEAN) $(BIN)
	rm -rf mytest1706299472

.PHONY: compare $(BIN)
compare:
	bash test.sh | python3 main.py; cat test1.sh

.PHONY: details
details: compare
	-bash test1.sh
