# Development

Make the container image with `make image`.

Open a shell in the container with `make console`.

Run the tests with `make test`.

See the `Makefile` for more information.

# Base image

The image for this Action container is based on `adwerx/pronto-ruby`. Since GitHub Actions build the container on the spot when they're running, we move the expensive building of the pronto runners and apt packages to a base image. That way, the large, base image can be downloaded and only the small modifications in this Action can be layered on top. This results in a faster GitHub Action run.

To make modifications to the linux environment (tooling) or installed runners in this image, please do so in [`adwerx/dockerfiles`](https://github.com/AdWerx/dockerfiles/tree/master/pronto-ruby). The pronto-ruby base image is built from there and this repo will only need a tag update.

# Tests

Using `bundler/setup` in the test environment clears the load path for ruby, which prevents us from requiring gems that are already installed like `pronto` and the runners. For this reason, it is important not to use `Bundler.require` or `bundler/setup` in the test environment so that we can require gems from both the Gemfile _and_ those installed in the _base image_.

The test suite uses RSpec and WebMock.

## Monkeypatching Pronto::Formatter

Pronto formatters are not pluggable. That is, they are not easily added from external source. For this reason, we reset the `FORMATTERS` constant with an additional formatter, `github_action_check_run`. This formatter is what posts Check Runs to github for the SHA being built (`GITHUB_SHA`).
