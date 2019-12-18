FROM ruby:2.5

LABEL maintainer="Josh Bielick <jbielick@adwerx.com>"

ENV BUILD_PACKAGES bash ruby-dev build-essential cmake openssl yamllint
ENV RUNTIME_PACKAGES git

RUN apt-get update && \
    apt-get install -y $BUILD_PACKAGES && \
    apt-get install -y $RUNTIME_PACKAGES && \
    rm -rf /var/lib/apt/lists/*

RUN gem install pronto

ENV RUNNERS pronto-rubocop:0.10.0 \
  pronto-brakeman:0.10.0 \
  pronto-bundler_audit:0.5.0 \
  pronto-rails_best_practices:0.10.0 \
  pronto-rails_schema:0.10.0 \
  pronto-poper:0.10.0  \
  pronto-yamllint:0.1.2 \
  pronto-reek:0.10.0 \
  pronto-flay:0.10.0 \
  pronto-fasterer:0.10.0 \
  pronto-scss:0.10.0 \
  pronto-erb_lint:0.1.5

RUN gem install $RUNNERS

ENV PATH $GEM_HOME/bin:$BUNDLE_PATH/gems/bin:$PATH

WORKDIR /data

ENTRYPOINT ["/usr/local/bundle/bin/pronto"]

CMD ["run"]
