FROM ruby:2.7-slim

LABEL maintainer="Josh Bielick <jbielick@adwerx.com>"

ENV BUNDLER_VERSION="2.1.4"
ENV ESLINT_VERSION="6.8.0"
ENV STYLELINT_VERSION="13.9.0"

RUN apt-get update && apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

RUN apt-get update && \
  apt-get install -y \
  ruby-dev \
  build-essential \
  cmake \
  git \
  pkg-config \
  openssl \
  yamllint \
  nodejs \
  && rm -rf /var/lib/apt/lists/*

RUN gem install bundler --version "${BUNDLER_VERSION}"
RUN npm install -g eslint@${ESLINT_VERSION}
RUN npm install stylelint@${STYLELINT_VERSION}

WORKDIR /runner

COPY Gemfile* ./

RUN bundle --retry 4

ENV BUNDLE_GEMFILE /runner/Gemfile

COPY . ./

WORKDIR /data

ENTRYPOINT ["/runner/pronto"]
