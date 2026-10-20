#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
exec swift -module-cache-path /tmp/cv-swift-cache "$script_dir/check-pdfs.swift" "$@"
