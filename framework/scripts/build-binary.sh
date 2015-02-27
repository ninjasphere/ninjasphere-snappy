#!/bin/bash

REPO=$1
DIR=sources/$(basename $REPO)

mkdir -p sources
mkdir -p intermediate

if [ ! -d $DIR ]; then
	git clone git@github.com:${REPO}.git $DIR
else
	pushd $DIR
	git pull
	popd
fi

PLATFORMS="linux/amd64 linux/arm"

for PLATFORM in $PLATFORMS; do
	export GOOS=${PLATFORM%/*}
	export GOARCH=${PLATFORM#*/}

	pushd $DIR
	./scripts/build.sh
	popd
	mkdir -p intermediate/bin-$GOOS-$GOARCH
	cp $DIR/bin/* intermediate/bin-$GOOS-$GOARCH/
done

