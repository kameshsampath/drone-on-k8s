#!/usr/bin/env bash

set -e
set -x

# disable CGO for cross-compiling
export CGO_ENABLED=0

# Dir where this script is located
basedir() {
    # Default is current directory
    local script=${BASH_SOURCE[0]}

    # Resolve symbolic links
    if [ -L $script ]; then
        if readlink -f $script >/dev/null 2>&1; then
            script=$(readlink -f $script)
        elif readlink $script >/dev/null 2>&1; then
            script=$(readlink $script)
        elif realpath $script >/dev/null 2>&1; then
            script=$(realpath $script)
        else
            echo "ERROR: Cannot resolve symbolic link $script"
            exit 1
        fi
    fi

    local dir full_dir
    dir=$(dirname "$script")
    full_dir=$(cd "${dir}/.." && pwd)
    echo "${full_dir}"
}

function cross_platform() {
  local basedir ld_flags
  basedir=$(basedir)
  ld_flags="-s -w"

  export CGO_ENABLED=0

  echo "🚧 🐧 Building for Linux (amd64)"
  GOOS=linux GOARCH=amd64 go build -ldflags "${ld_flags}"  -mod=vendor -o "./bin/gitea-config-linux-amd64 " "./cmd"
  echo "🚧 💪 Building for Linux (arm64)"
  GOOS=linux GOARCH=arm64 go build -ldflags "${ld_flags}"  -mod=vendor -o "./bin/gitea-config-linux-arm64" "./cmd"
  echo "🚧 🍏 Building for macOS"
  GOOS=darwin GOARCH=amd64 go build -ldflags "${ld_flags}"  -mod=vendor -o "./bin/gitea-config-darwin-amd64" "./cmd"
  echo "🚧 🍎 Building for macOS (arm64)"
  GOOS=darwin GOARCH=arm64 go build -ldflags "${ld_flags}"  -mod=vendor -o "./bin/gitea-config-darwin-arm64" "./cmd"
  echo "🚧 🎠 Building for Windows"
  GOOS=windows GOARCH=amd64 go build -ldflags "${ld_flags}"  -mod=vendor -o "./bin/gitea-config-windows-amd64.exe" "./cmd"
}

cross_platform "$@"

