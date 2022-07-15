#!/bin/sh
set -e
set -x

# disable CGO for cross-compiling
export CGO_ENABLED=0

# compile for all architectures
GOOS=linux   GOARCH=amd64   go build -mod vendor  -o ../bin/linux/amd64/gitea-config .
GOOS=linux   GOARCH=arm64   go build -mod vendor  -o ../bin/linux/arm64/gitea-config .
GOOS=windows GOARCH=amd64   go build -mod vendor  -o ../bin/windows/amd64/gitea-config.exe .
GOOS=darwin  GOARCH=amd64   go build -mod vendor  -o ../bin/darwin/amd64/gitea-config .
GOOS=darwin  GOARCH=arm64   go build -mod vendor  -o ../bin/darwin/arm64/gitea-config .
