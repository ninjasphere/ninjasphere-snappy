#!/bin/bash

IMAGE=$1

THIS_SCRIPT=$(readlink -f $0)

if [[ -z "$IMAGE" ]]; then
	echo "Usage: $0 <image-file>"
	exit 1
fi

if [[ ! -x ./writable ]]; then
	exec ./with-image.sh $IMAGE $THIS_SCRIPT $IMAGE
fi

if grep g_serial writable/system-data/var/lib/cloud/seed/nocloud-net/user-data >/dev/null; then
	echo "Patch already applied"
	exit 1
fi

cat >>writable/system-data/var/lib/cloud/seed/nocloud-net/user-data <<EOF
bootcmd:
  - modprobe g_serial; ln -sf /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@ttyGS0.service || true
EOF

touch system-a/etc/cloud/no-blocknet

cat >>system-a/etc/init/please-oh-please-wont-you-just-boot-faster.conf <<EOF
start on starting cloud-init-nonet
task

console output

script
	touch /run/network/static-network-up-emitted
end script
EOF

# lets NOT use the same MAC everywhere
rm -rf system-a/lib/firmware/ti-connectivity/wl1271-nvs.bin

cat writable/system-data/var/lib/cloud/seed/nocloud-net/user-data
