%: all

root_ca.key.pem:
	openssl genrsa -des3 -out root_ca.key.pem 2048

root_ca.cert.pem: root_ca.key.pem
	openssl req -x509 -new -nodes -key ./root_ca.key.pem -config ./root_ca_config -sha256 -days 365 -out root_ca.cert.pem

int_ca.key.pem:
	openssl genrsa -out int_ca.key.pem 2048

int_ca.cert.pem: int_ca.key.pem
	openssl req -new -key int_ca.key.pem -out int_ca.csr -config int_ca_config
	openssl x509 -req -in int_ca.csr -CA root_ca.cert.pem -CAkey root_ca.key.pem -CAcreateserial \
		-out int_ca.cert.pem -days 365 -sha256 -extfile int_ca_config -extensions v3_ca

www.milkyway.com.key.pem:
	openssl genrsa -out www.milkyway.com.key.pem 2048

www.milkyway.com.cert.pem: www.milkyway.com.key.pem
	openssl req -new -key www.milkyway.com.key.pem -out www.milkyway.com.csr -config www.milkyway.com_config
	openssl x509 -req -in www.milkyway.com.csr -CA int_ca.cert.pem -CAkey int_ca.key.pem -CAcreateserial \
		-out www.milkyway.com.cert.pem -days 365 -sha256 -extfile www.milkyway.com_config -extensions v3_no_ca

.PHONY: all
all: root_ca.cert.pem int_ca.cert.pem www.milkyway.com.cert.pem

.PHONY: clean
clean:
	rm -rf *.pem *.csr *.srl
