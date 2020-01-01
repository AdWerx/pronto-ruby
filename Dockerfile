FROM ruby:2.5

LABEL maintainer="Josh Bielick <jbielick@adwerx.com>"

RUN apt-get update && \
  apt-get install -y \
  bash \
  ruby-dev \
  build-essential \
  cmake \
  git \
  openssl \
  yamllint \
  && rm -rf /var/lib/apt/lists/*

RUN gem install bundler

WORKDIR /runner

COPY Gemfile* ./

ENV BUNDLE_GEMFILE /runner/Gemfile

RUN bundle --jobs 2 --retry 4

COPY . ./

WORKDIR /data

ENTRYPOINT ["/runner/pronto"]
