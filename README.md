Your all-in-one ruby Pronto runner.

This [GitHub Action](https://github.com/features/actions) runs [Pronto](https://github.com/prontolabs/pronto) [runners](https://github.com/prontolabs/pronto#runners) on your Ruby project diffs and reports back with a [GitHub Check Run](https://developer.github.com/apps/quickstart-guides/creating-ci-tests-with-the-checks-api/).

![check runs](static/checkrun.png)

![annotations](static/annotations.png)

# Runners

The docker image of this Action includes the following [Pronto Runners](https://github.com/prontolabs/pronto#runners):

- brakeman
- bundler_audit
- fasterer
- flay
- poper
- rails_best_practices
- rails_schema
- rails_data_schema
- reek
- rubocop
- scss
- yamllint

# Inputs

| name | description | default |
| --- | --- | --- |
| `runners` | Space-separated list of pronto runners to run. Must be the preinstalled runners from the list above. | `rubocop` |
| `target` | The git target pronto will diff against (`-c`) | `origin/master` |

# Secrets

A GitHub token is available by default when using actions, but you must include it in the `env` map for this Action to use when creating a check run.

Be sure to include the ENV variable in your job step:

```yaml
    - uses: adwerx/pronto-ruby
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

That's it!

# Configuration

Pronto can be configured via the `.pronto.yml` configuration file in your repo.

# Example

With the defaults (only rubocop):

```yaml
name: Pronto

on:
  - push
  - pull_request

jobs:
  run:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - uses: adwerx/pronto-ruby@v2.4
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

```

With specific runners:

```yaml
name: Pronto
# ...
      with:
        runners: >-
          rubocop rails_schema yamllint
```

### Development / Contributions

See [CONTRIBUTING.md](./CONTRIBUTING.md)
