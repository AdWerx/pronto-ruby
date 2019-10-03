FROM ruby:2.5

LABEL maintainer="Josh Bielick <jbielick@adwerx.com>"

ENV BUILD_PACKAGES bash ruby-dev build-essential cmake openssl
ENV RUNTIME_PACKAGES git

RUN apt-get update && \
  apt-get install -y $BUILD_PACKAGES && \
  apt-get install -y $RUNTIME_PACKAGES && \
  rm -rf /var/lib/apt/lists/*

RUN gem install pronto

RUN gem install \
  pronto-rubocop \
  pronto-brakeman \
  pronto-bundler_audit \
  pronto-rails_best_practices \
  pronto-rails_schema

ENV PATH $GEM_HOME/bin:$BUNDLE_PATH/gems/bin:$PATH

WORKDIR /action

COPY entrypoint.sh .

ENTRYPOINT [ "./entrypoint.sh" ]
