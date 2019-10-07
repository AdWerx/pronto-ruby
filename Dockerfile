FROM adwerx/pronto-ruby:1.1.0

COPY entrypoint.sh /entrypoint.sh

COPY ./src /runner

ENV RUNNER_WORKSPACE /data

ENTRYPOINT [ "/entrypoint.sh" ]
