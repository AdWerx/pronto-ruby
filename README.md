# Description



# Inputs

| name | description | default |
| --- | --- | --- |
| formatters | Space-separated list of pronto formatters to use. See [the pronto README](https://github.com/prontolabs/pronto#github-integration) for more information. | `github_pr github_status` |
| runners | Space-separated list of pronto runners to run. Must be the preinstalled runners (ruby only). | `pronto-rubocop pronto-brakeman pronto-bundler_audit pronto-rails_best_practices pronto-rails_schema` |

# Secrets

`PRONTO_GITHUB_ACCESS_TOKEN`

# Environment Variables

(none)

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
    - uses: adwerx/pronto-ruby@v1

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
    - uses: adwerx/pronto-ruby@v1
      with:
        formatters: github_pr github_status
        runners: pronto-rails_schema
```
