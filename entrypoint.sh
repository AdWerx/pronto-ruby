#!/usr/bin/env bash

set -eo pipefail

cd $GITHUB_WORKSPACE

pronto run -f json $@ | /runner/src/process_results
