name=adwerx/pronto-ruby-action

image:
	docker build . -t ${name}

test:
	docker run -v "$(pwd):/runner" -t --entrypoint '' --rm ${name} rspec

tag: image
	docker tag ${name} ${name}:${TAG}
	docker tag ${name} ${name}:latest

push: tag
	docker push ${name}:${TAG}

.PHONY: image tag push
