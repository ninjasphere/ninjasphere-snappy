#!/bin/bash

REPO_URL=git@github.com:ninjasphere/driver-go-lifx.git
REPO_PATH=driver-go-lifx

. ../packaging.sh

clone-latest ${REPO_PATH} ${REPO_URL}
if [[ ! -f custom-driver-go-lifx ]]; then
	build-go-intermediates ${REPO_PATH} "linux/arm"
fi

begin-build-staging

	if [[ -f custom-driver-go-lifx ]]; then
		chmod +x custom-driver-go-lifx
		cp custom-driver-go-lifx ${STAGING_DIR}/driver-go-lifx
	else
		install-intermediate-single-arch "linux/arm" "driver-go-lifx"
	fi

	# extra stuff
	cp -R ${REPO_PATH}/ninjapack/root/opt/ninjablocks/drivers/driver-go-lifx/* ${STAGING_DIR}

	apply-template-staging

	snappy-build-staging

#clean-build-staging
