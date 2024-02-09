%: all

CA_PORT ?= 80
TLS_PORT ?= 443
CONFIGS := nginx.conf

.PHONY: configs
configs: $(CONFIGS)

.PHONY: $(CONFIGS)
$(CONFIGS):
	@sed -i '' -E '/# CA server/{n;s/listen.*;/listen       $(CA_PORT);/;}' $@
	@sed -i '' -E '/# www.milkyway.com/{n;s/listen.*;/listen       $(TLS_PORT) ssl;/;}' $@

.PHONY: all
all: configs
