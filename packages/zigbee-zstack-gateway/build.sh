#!/bin/bash

APT_URL=https://s3.amazonaws.com/ninjablocks-apt-repo
APT_DEB=pool/main/z/zigbee-zstack-gateway/zigbee-zstack-gateway_0.1.0~trustyspheramid-9_armhf.deb
APT_FILE=$(basename "$APT_DEB")
APT_SHA1=54ae87014e140c07483b73ad8476cbaddf22d1fc

. ../packaging.sh

fetch-apt "${APT_URL}" "${APT_DEB}" "${APT_FILE}" "${APT_SHA1}"

begin-build-staging

dpkg -x "${APT_FILE}" ${STAGING_DIR}

rm -rf ${STAGING_DIR}/etc/
rsync -rav ${STAGING_DIR}/opt/zigbee-zstack-gateway/ ${STAGING_DIR}/
rsync -rav ${STAGING_DIR}/usr/lib/ ${STAGING_DIR}/servers/


(
	cd ${STAGING_DIR}/servers/ &&
	sed -i.bak "/DATABASE_PATH *= */d" nwkmgr_config.ini &&
	echo 'DATABASE_PATH="./dbpath/"' >> nwkmgr_config.ini &&
	sed -i.bak 's|^devPath="/dev/tty.zigbee"|#&|;s|^#devPath="/dev/ttyO4"|devPath="/dev/ttyO4"|' NPI_Gateway.cfg
) &&
rm ${STAGING_DIR}/servers/*.bak

# location fixups

apply-template-staging
apply-version $(version-from-deb "$APT_FILE")

snappy-build-staging

#clean-build-staging
