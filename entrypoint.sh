#!/usr/bin/env bash

set -eo pipefail

cd $RUNNER_WORKSPACE

pronto run -f json $@ | /runner/src/process_results
