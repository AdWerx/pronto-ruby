#!/bin/bash

set -euo pipefail

gem install bundler
bundle

exec "$@"
