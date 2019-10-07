FROM adwerx/pronto-ruby:1.1.0

COPY entrypoint.sh /entrypoint.sh

COPY ./ /runner

ENV RUNNER_WORKSPACE /runner

ENTRYPOINT [ "/entrypoint.sh" ]
