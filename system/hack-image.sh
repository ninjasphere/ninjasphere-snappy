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
  - modprobe g_serial; ln -sf /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@ttyGS0.service || true; systemctl start getty@ttyGS0.service
EOF

cat writable/system-data/var/lib/cloud/seed/nocloud-net/user-data
