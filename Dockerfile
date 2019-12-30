FROM adwerx/pronto-ruby:1.4.1

WORKDIR /runner

ENV GITHUB_WORKSPACE /runner

COPY . ./

ENTRYPOINT ["/runner/pronto"]
