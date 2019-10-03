repo=adwerx/pronto-ruby

image:
	docker build . -t ${repo}

tag: image
	docker tag ${repo} ${repo}:${TAG}
	docker tag ${repo} ${repo}:latest

push: tag
	docker push ${repo}:${TAG}

.PHONY: image tag push
