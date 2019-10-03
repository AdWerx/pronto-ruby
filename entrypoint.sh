#!/usr/bin/env bash

set -e

PRONTO_GITHUB_SLUG=$GITHUB_REPOSITORY

pronto run \
  --exit-code \
  $@
