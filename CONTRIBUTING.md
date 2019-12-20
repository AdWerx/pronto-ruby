# Development

Make the container image with `make image`.

Open a shell in the container with `make console`.

Run the tests with `make test`.

See the `Makefile` for more information.

# Base image

The ruby and pronto installation is done in the `Dockerfile.base` container image. Thus, pronto and runners are portable and can be run easily locally or otherwise. The code and formatter for the GitHub Action itself are added in a subsequent container image, built by `Dockerfile`. This container image is built during the GitHub action run. That way, the large, base image can be downloaded and only the small modifications in this Action can be layered on top. This results in a faster GitHub Action run.

To make modifications to the linux environment (tooling) or installed runners in this image, please do so in `Dockerfile.base`. After making modifications, a tag of `base-vX.X.X` should be created to trigger a dockerhub build.

Once the new base image is built and available in dockerhub, the `FROM` line in `Dockerfile` can be updated to point to it.

Finally, create a release through GitHub's UI with a version bump and include CHANGELOG details in the release description.

# Tests

Using `bundler/setup` in the test environment clears the load path for ruby, which prevents us from requiring gems that are already installed like `pronto` and the runners. For this reason, it is important not to use `Bundler.require` or `bundler/setup` in the test environment so that we can require gems from both the Gemfile _and_ those installed in the _base image_.

The test suite uses RSpec and WebMock.

## Monkeypatching Pronto::Formatter

Pronto formatters are not pluggable. That is, they are not easily added from external source. For this reason, we reset the `FORMATTERS` constant with an additional formatter, `github_action_check_run`. This formatter is what posts Check Runs to github for the SHA being built (`GITHUB_SHA`).
