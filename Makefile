%: all

.PHONY: all
all:
	make -C ./certs all

.PHONY: nginx
nginx: all
	docker run -p 80:80 -p 443:443  -v `pwd`/nginx/nginx.conf:/etc/nginx/nginx.conf -v `pwd`/certs:/home/ca --rm nginx:latest

.PHONY: clean
clean:
	make -C ./certs clean
