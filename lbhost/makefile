.SUFFIXES:
.SUFFIXES: .sh


.sh:
	sh $< > $@


default: configuration.nix


install: configuration.nix
	mkdir -p /etc/nixos && cp configuration.nix /etc/nixos/


json: clean configuration.json


configuration.json: configuration.nix
	NIXPKGS_ALLOW_UNFREE=1 nix-instantiate --strict --json --show-trace --eval -E \
		"import ./$< { config = {}; pkgs = import <nixpkgs> {}; lib = import <nixpkgs/lib>; }" \
		> $@

configuration.nix: hardware-configuration.nix


hardware-configuration.nix: makefile
	echo '{...}: {}' > hardware-configuration.nix

clean:
	rm -rfv configuration.{nix,json}
	rm -rfv hardware-configuration.nix

