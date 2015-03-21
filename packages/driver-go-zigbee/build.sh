#!/bin/bash

. ../packaging.sh

APT_URL=https://s3.amazonaws.com/ninjablocks-apt-repo
APT_DEB=pool/main/n/ninja-go-zigbee/ninja-go-zigbee_0.1.6~trustyspheramid-7_armhf.deb
APT_SHA1=fb20d7a242b3810a08b4c3dcd8cea74c244175fc
APT_VERSION=$(version-from-deb "$APT_DEB")
SNAP_NAME=driver-go-zigbee

APT_FILE=$(fetch-apt "${APT_URL}" "${APT_DEB}" "${APT_SHA1}")

begin-build-staging

dpkg -x "${APT_FILE}" ${STAGING_DIR}

rsync -rav ${STAGING_DIR}/opt/ninjablocks/drivers/$SNAP_NAME/ ${STAGING_DIR}/

rm -rf ${STAGING_DIR}/etc/
rm -rf ${STAGING_DIR}/opt/

apply-template-staging
apply-version $APT_VERSION
apply-name $SNAP_NAME


snappy-build-staging

#clean-build-staging
