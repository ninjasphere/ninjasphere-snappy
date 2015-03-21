#!/bin/bash

. ../packaging.sh

APT_URL=https://s3.amazonaws.com/ninjablocks-apt-repo
APT_DEB=pool/main/z/zigbee-zstack-gateway/zigbee-zstack-gateway_0.1.0~trustyspheramid-10_armhf.deb
APT_SHA1=515da2d717eed4e655c074206c92a2d05bd4e307
APT_NAME=$(name-from-deb "$APT_DEB")
APT_VERSION=$(version-from-deb "$APT_DEB")

APT_FILE=$(fetch-apt "${APT_URL}" "${APT_DEB}" "${APT_SHA1}")

begin-build-staging

dpkg -x "${APT_FILE}" ${STAGING_DIR}

rsync -rav ${STAGING_DIR}/opt/zigbee-zstack-gateway/ ${STAGING_DIR}/
rsync -rav ${STAGING_DIR}/usr/lib/ ${STAGING_DIR}/servers/

rm -rf ${STAGING_DIR}/etc/
rm -rf ${STAGING_DIR}/usr/lib/
rm -rf ${STAGING_DIR}/opt/
rm -rf ${STAGING_DIR}/data/

(
	cd ${STAGING_DIR}/servers/ &&
	sed -i"" "/DATABASE_PATH *= */d" nwkmgr_config.ini &&
	echo "DATABASE_PATH = \"/var/lib/apps/$APT_NAME/$APT_VERSION/\"" >> nwkmgr_config.ini &&
	sed -i"" 's|^devPath=".*"|#&|;s|^#devPath="/dev/ttyO4"|devPath="/dev/ttyO4"|' NPI_Gateway.cfg
	sed -i"" "s|^log=\".*/\([^\"/]*\)\"|log=\"/var/lib/apps/$APT_NAME/$APT_VERSION/\1\"|" NPI_Gateway.cfg
)
# location fixups
rm ${STAGING_DIR}/servers/data

apply-template-staging
apply-version $APT_VERSION
apply-name $APT_NAME


snappy-build-staging

#clean-build-staging
