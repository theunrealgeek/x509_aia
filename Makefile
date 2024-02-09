%: all

DOCKER_REPO=
DOCKER_TAG ?= $(shell git describe --always --dirty)

.PHONY: all
all:
	make -C ./certs all
	make -C ./nginx all

.PHONY: nginx
nginx: all
	docker run -p 80:80 -p 443:443  -v `pwd`/nginx/nginx.conf:/etc/nginx/nginx.conf -v `pwd`/certs:/home/ca --rm nginx:latest

.PHONY: docker-build
docker-build: docker-vars all
	@echo "Building Docker image: $(DOCKER_REPO):$(DOCKER_TAG)"
	docker build -f Dockerfile -t $(DOCKER_REPO):$(DOCKER_TAG) .

.PHONY: docker-push
docker-push: docker-build
	@echo "Pushing Docker image: $(DOCKER_REPO):$(DOCKER_TAG)"
	docker push $(DOCKER_REPO):$(DOCKER_TAG)

.PHONY: docker-run
docker-run: docker-vars
	docker run -it --rm \
	  --name aia-milkyway \
	  --network host \
	  $(DOCKER_REPO):$(DOCKER_TAG)

docker-vars:
	test -n "$(DOCKER_REPO)" # $$DOCKER_REPO

.PHONY: clean
clean:
	make -C ./certs clean
