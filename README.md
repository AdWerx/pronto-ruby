# Description

Runs Pronto runners on your Ruby project via GitHub Actions.

# Inputs

| name | description | default |
| --- | --- | --- |
| `runners` | Space-separated list of pronto runners to run. Must be the preinstalled runners (ruby only). See [the pronto-ruby image](https://github.com/AdWerx/dockerfiles/tree/master/pronto-ruby) for more info. | `rubocop` |
| `target` | The git target pronto will diff against (`-c`) | `origin/master` |

# Secrets

A GitHub token is available by default when using actions, but you must include it in the ENV hash for this Action to use when creating check runs.

Be sure to include the ENV variable in your job step:

```yaml
env:
  GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

# Configuration

Pronto can be configured via the `.pronto.yml` configuration file in your repo.

# Example

With the defaults:

```yaml
name: Build

on:
  - pull_request

jobs:
  pronto:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - uses: adwerx/pronto-ruby@v1.0
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

```

With specific runners:

```yaml
name: Build

on:
  - pull_request

jobs:
  pronto:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - uses: adwerx/pronto-ruby@v1.0
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        runners: >-
          rubocop rails_schema yamllint
```
