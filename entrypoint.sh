#!/usr/bin/env bash

set -eo pipefail

pronto run -f json $@ | ./src/process_results
