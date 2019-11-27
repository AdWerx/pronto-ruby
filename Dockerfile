FROM ruby:2.5

LABEL maintainer="Josh Bielick <jbielick@adwerx.com>"

ENV BUILD_PACKAGES bash ruby-dev build-essential cmake openssl yamllint
ENV RUNTIME_PACKAGES git

RUN apt-get update && \
    apt-get install -y $BUILD_PACKAGES && \
    apt-get install -y $RUNTIME_PACKAGES && \
    rm -rf /var/lib/apt/lists/*

RUN gem install pronto

ENV RUNNERS pronto-rubocop \
  pronto-brakeman \
  pronto-bundler_audit \
  pronto-rails_best_practices \
  pronto-rails_schema \
  pronto-poper \
  pronto-yamllint \
  pronto-reek \
  pronto-flay \
  pronto-fasterer \
  pronto-scss

RUN gem install $RUNNERS

ENV PATH $GEM_HOME/bin:$BUNDLE_PATH/gems/bin:$PATH

WORKDIR /data

ENTRYPOINT ["/usr/local/bundle/bin/pronto"]

CMD ["run"]
