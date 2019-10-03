# Description

Runs Pronto runners on your Ruby project via GitHub Actions.

# Inputs

| name | description | default |
| --- | --- | --- |
| `formatters` | Space-separated list of pronto formatters to use. See [the pronto README](https://github.com/prontolabs/pronto#github-integration) for more information. | `text github_pr github_status` |
| `runners` | Space-separated list of pronto runners to run. Must be the preinstalled runners (ruby only). See [the pronto-ruby image](https://github.com/AdWerx/dockerfiles/tree/master/pronto-ruby) for more info. | `rubocop` |
| `target` | The git target pronto will diff against (`-c`) | `origin/master` |

# Secrets

A GitHub token is available by default when using actions, but you must include it in the ENV for pronto to use when commenting on PRs or posting reviews.

Be sure to include the ENV variable in your job step:

```yaml
env:
  PRONTO_GITHUB_ACCESS_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

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
      env:
        PRONTO_GITHUB_ACCESS_TOKEN: ${{ secrets.GITHUB_TOKEN }}

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
      env:
        PRONTO_GITHUB_ACCESS_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        formatters: >-
          text github_pr github_status
        runners: >-
          rubocop rails_schema yamllint
```

# Troubleshooting

**I get a 404 when pronto runs for listing PRs.**

```
GET https://api.github.com/repos/your/reponame/pulls?per_page=100: 404 - Not Found // See: https://developer.github.com/v3/pulls/#list-pull-requests
```

You're missing the `PRONTO_GITHUB_ACCESS_TOKEN`. See the [Secrets](#Secrets) section for an explanation.
