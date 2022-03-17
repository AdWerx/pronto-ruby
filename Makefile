name=adwerx/pronto-ruby

image:
	docker build -f Dockerfile . -t ${name}:${TAG} -t ${name}:latest

test: spec/fixtures/test.git
	docker run -v "${CURDIR}:/runner" --workdir /runner --entrypoint /runner/dev_entrypoint.sh --rm ${name}:latest rspec

spec/fixtures/test.git:
	tar -zxf spec/fixtures/test.git.tar.gz

# tag: image
# 	docker tag ${name} ${name}:${TAG}

push: image
	docker push ${name}:${TAG}

console: spec/fixtures/test.git
	docker run -it -v "${CURDIR}:/runner" --workdir /runner --entrypoint /runner/dev_entrypoint.sh --rm ${name}:latest bash

.PHONY: image tag push
