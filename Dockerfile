FROM adwerx/pronto-ruby:1.3.2

WORKDIR /runner

ENV GITHUB_WORKSPACE /runner

COPY Gemfile Gemfile.lock ./

RUN bundle

COPY . ./

ENTRYPOINT ["/runner/pronto"]
