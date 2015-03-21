#!/bin/bash

set -e

IMAGE=$1
COMMAND=$2

if [[ -z $IMAGE || -z $COMMAND ]]; then
	echo "Usage: $0 <image> <command>"
	echo "  <command> will be executed with cwd and $IMG_PATH being a path to a directory with each partition mounted as p0,p1,... "
	exit 1
fi

if [ "$(id -u)" != "0" ]; then
	exec sudo $0 "$@"
fi

LOOP_DEV=`kpartx -a -v ${IMAGE} | grep -o "loop.p1" | grep -o "loop."`

echo "Loopback available on: $LOOP_DEV"

dir=$(mktemp -d)

pushd $dir

for loop in /dev/mapper/${LOOP_DEV}p*; do
	part=$(echo $loop | egrep -o 'p.$')
	mkdir -p $part
	if mount $loop $part; then
		echo "Mounted $loop as $part"
		aliased=$(blkid $loop -o value | head -1)
		if [[ ! -z "$aliased" ]]; then
			ln -s $part $aliased
			echo " -> aliased as $aliased"
		fi
	else
		rm -rf $part
	fi
done

export IMG_PATH=$dir
shift
"$@" || true

popd

for mounted in $dir/p*; do
	umount $mounted || true
done

rm -rf $dir

kpartx -d ${IMAGE}
