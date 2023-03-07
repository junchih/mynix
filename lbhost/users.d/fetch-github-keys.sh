#! /usr/bin/env sh


accounts=(
	"junchih"
	"nihilist97"
	)


WDIR=$(dirname "$0")

fetch() {
	curl -L "https://github.com/${1}.keys" > "${WDIR}/${1}.github.keys"
}

for account in "${accounts[@]}"
do
	fetch "$account"
done
