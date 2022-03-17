FROM ruby:2.7-slim

LABEL maintainer="Josh Bielick <jbielick@adwerx.com>"

ARG BUNDLER_VERSION="2.3.8"
ARG ESLINT_VERSION="7.32.0"
ARG STYLELINT_VERSION="13.13.1"
ARG NODE_VERSION=14

RUN apt-get update && apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -

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
