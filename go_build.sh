#!/usr/bin/env bash

export GO111MODULE=on

go get -u golang.org/x/lint/golint
go get github.com/golang/mock/mockgen
go get -u github.com/swaggo/swag/cmd/swag
go get -u golang.org/x/tools/...
