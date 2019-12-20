FROM adwerx/pronto-ruby:1.4.0

WORKDIR /runner

ENV GITHUB_WORKSPACE /runner

COPY . ./

ENTRYPOINT ["/runner/pronto"]
