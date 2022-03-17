4.0 | 2022-03-17
---

**BREAKING CHANGES:**

 * Pronto is upgraded to 0.11, the following runners are not yet compatible:
   - pronto-poper
   - pronto-rails_data_schema

Changes:

 * Upgrades node.js to 14.x
 * Upgrades eslint_npm to 7.32.0
 * Upgrades stylelint to 13.13.1
 * Upgrades Bundler to 2.3.8
 * Upgrades Rubocop to 1.26.0
 * Upgrades all runners and dependencies

2.5 | 2020-03-24
---

 * Adds nodejs to the container and `pronto-eslint_npm` runner
 * Container is now Ruby 2.6
 * Container is now ubuntu buster slim @ ~850mb

(#14-- thanks @Saicheg !)

2.4.1 | 2020-3-23
---

 * Adds pronto-rails_data_schema runner (#11)

2.3.0 | 2019-12-31
---

 * Update to bundler 2

 Backwards compatible with bundler 1 projects.

2.2.0 | 2019-12-30
---

Consolidates the docker image (base vs. action) and adds several rubocop extensions.

 * Adds the following rubocop extensions to the docker image:
   * rubocop-performance
   * rubocop-minitest
   * rubocop-rspec
   * rubocop-rails
   * rubocop-thread_safety
   * rubocop-i18n
   * rubocop-rake

These extensions can now be `require`d in a `.rubocop.yml` config and used with the rubocop runner.

2.1.1 | 2019-12-30
---

 * Corrects a published bad image build of adwerx/pronto-ruby:1.4.0 (base image)

2.1.0 | 2019-12-20
---

 * Upgrades pronto-bundler_audit to 0.6.0

2.0.0 | 2019-12-18
---

 * Adds pronto-erb_lint to the adwerx/pronto-ruby image (1.3.2)

Breaking Changes:

- Rubocop has been optimistically bumped to 0.77 and may cause some breaking cop configuration renames. You'll need to update your rubocop configs accordingly.
