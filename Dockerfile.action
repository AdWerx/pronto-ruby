FROM adwerx/pronto-ruby:1.2.0

WORKDIR /runner

ENV GITHUB_WORKSPACE /runner

COPY Gemfile Gemfile.lock ./

RUN bundle

COPY . ./

ENTRYPOINT ["/runner/pronto"]
