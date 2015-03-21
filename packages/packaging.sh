#!/bin/bash

clone-latest() {
	local REPO_PATH=$1
	local REPO_URL=$2

	if [[ ! -x $REPO_PATH ]]; then
		git clone $REPO_URL $REPO_PATH
	else
		pushd $REPO_PATH
		git pull
		popd
	fi
}

build-go-intermediates() {
	local SRC_DIR=$1
	local PLATFORMS=${2-"linux/amd64 linux/arm"}

	for PLATFORM in $PLATFORMS; do
		export GOOS=${PLATFORM%/*}
		export GOARCH=${PLATFORM#*/}
		export CGO_ENABLED=1
		export GOARM=7

		pushd $SRC_DIR
		./scripts/build.sh
		popd
		mkdir -p intermediate/bin-$GOOS-$GOARCH
		cp $SRC_DIR/bin/* intermediate/bin-$GOOS-$GOARCH/
	done
}

begin-build-staging() {
	clean-build-staging
	mkdir -p _staging
	export STAGING_DIR=_staging
}

clean-build-staging() {
	rm -rf _staging
}

snappy-build-staging() {
	snappy build _staging
}

install-intermediate-single-arch() {
	local PLATFORM=$1
	local BINARY=$2

	export GOOS=${PLATFORM%/*}
	export GOARCH=${PLATFORM#*/}

	cp intermediate/bin-$GOOS-$GOARCH/$BINARY _staging/$BINARY
}

apply-template-staging() {
	cp -R template/* _staging/
	cp -R ../template/* _staging/
}

check-sha1() {
	local file=$1
	local sha1=$2

	test -f "$file" &&
	current=$(openssl sha1 < "$file" | cut -f2 -d' ') &&
	if test "$current" != "$sha1"; then
		echo "'$current' does not match required '$sha1'" 1>&2
		false
	fi
}

fetch-apt() {
	local repo=$1
	local path=$2
	local sha1=$3

	file=$(basename "$path")

	if ! check-sha1 "$file" "$sha1"; then
		rm -rf "$file"
		curl -s "$repo/$path" > "$file"
	fi
	check-sha1 "$file" "$sha1" || ( echo "failed to verify sha1 of '$repo/$path' - '$sha1'" 1>&2;  exit 1 )
	echo "$file"
}

version-from-deb() {
	local file=$1
	echo "$file" | sed "s/.*_\([^~]*\)~[^-]*-\([^_]*\).*/\1-\2/"
}

name-from-deb() {
	local file=$1
	echo "$file" | sed "s/\([^_]*\)_.*/\1/"
}

apply-version() {
	local version=$1
	sed -i"" "s/{VERSION}/$version/" _staging/meta/package.yaml
}

apply-name() {
	local name=$1
	sed -i"" "s/{NAME}/$name/" _staging/meta/package.yaml
}
