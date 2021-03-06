FLAGS := -I "config=$$(pwd)/config" \
		 -I "packages=$$(pwd)/packages" \
		 -I "secrets=$$(pwd)/secrets"
DARWIN_CONFIG_FLAG := -I "darwin-config=$$(pwd)/default-darwin.nix"

UNAME := $(shell uname)

.PHONY: build
build:
ifeq ($(UNAME), Darwin)
	@darwin-rebuild build $(FLAGS) $(DARWIN_CONFIG_FLAG)
endif
ifeq ($(UNAME), Linux)
	@sudo nixos-rebuild $(FLAGS) build
endif

.PHONY: switch
switch:
ifeq ($(UNAME), Darwin)
	@darwin-rebuild switch $(FLAGS) $(DARWIN_CONFIG_FLAG)
endif
ifeq ($(UNAME), Linux)
	@sudo nixos-rebuild $(FLAGS) switch
endif
