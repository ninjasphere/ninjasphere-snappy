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

