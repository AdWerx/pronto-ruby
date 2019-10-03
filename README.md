# Description

Runs Pronto runners on your Ruby project via GitHub Actions.

# Inputs

| name | description | default |
| --- | --- | --- |
| formatters | Space-separated list of pronto formatters to use. See [the pronto README](https://github.com/prontolabs/pronto#github-integration) for more information. | `github_pr github_status` |
| runners | Space-separated list of pronto runners to run. Must be the preinstalled runners (ruby only). See [the pronto-ruby image](https://github.com/AdWerx/dockerfiles/tree/master/pronto-ruby) for more info. | `pronto-rubocop` |

# Secrets

Please provide `PRONTO_GITHUB_ACCESS_TOKEN` if using a github formatter to post feedback to your GitHub PRs or commit statuses.

# Configuration

Pronto can be configured via the `.pronto.yml` configuration file in your repo.

# Example

With the defaults:

```yaml
name: Review

on:
  - pull_request

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - uses: adwerx/pronto-ruby@v1.0

```

With specific formatters or runners:

```yaml
name: Review Schema

on:
  - pull_request

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - uses: adwerx/pronto-ruby@v1.0
      with:
        formatters: >-
          text github_pr github_status
        runners: >-
          rubocop rails_schema yamllint
```
