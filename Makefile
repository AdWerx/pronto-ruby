repo=adwerx/pronto-ruby-action

image:
	docker build . -t ${repo}

test: image
	docker run -t --entrypoint '' --rm adwerx/pronto-ruby-action rspec

tag: image
	docker tag ${repo} ${repo}:${TAG}
	docker tag ${repo} ${repo}:latest

push: tag
	docker push ${repo}:${TAG}

.PHONY: image tag push
