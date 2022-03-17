# Development

Make the container image with `make image`.

Open a shell in the container with `make console`.

Run the tests with `make test`.

See the `Makefile` for more information.

# Base image

The ruby and pronto installation is done in the `Dockerfile` container image. Thus, pronto and runners are portable and can be run easily locally or otherwise. The code and formatter for the GitHub Action itself are added to the container image.

After making modifications, use `TAG=x.x make push` to push the image to the registry.

Once the new image is built and available in the registry, the image tag in `action.yml` should be updated to point to it.

Finally, create a release through GitHub's UI with a version bump and include CHANGELOG details in the release description.

# Tests

Unzip the test git archive: `make spec/fixtures/test.git`

The test suite uses RSpec and WebMock.

## Monkeypatching Pronto::Formatter

Pronto formatters are not pluggable. That is, they are not easily added from external source. For this reason, we reset the `FORMATTERS` constant with an additional formatter, `github_action_check_run`. This formatter is what posts Check Runs to github for the SHA being built (`GITHUB_SHA`).
