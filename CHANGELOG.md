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
