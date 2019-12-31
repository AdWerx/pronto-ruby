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

WORKDIR /data

COPY Gemfile* ./

RUN bundle --jobs 2 --retry 4

ENV PATH $GEM_HOME/bin:$BUNDLE_PATH/gems/bin:$PATH

COPY . /runner

ENTRYPOINT ["/runner/pronto"]
