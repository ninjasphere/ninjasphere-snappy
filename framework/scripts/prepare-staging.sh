#!/bin/bash

set -o pipefail
rm -rf staging-snappy
cp -R template staging-snappy

stage-add() {
	local SRC="$1"
	local DST="$2"

	cp -R $SRC staging-snappy/$DST
	rm -rf staging-snappy/$DST/.git
}

stage-magic-bin() {
	local BIN="$1"
	local DST="$2"

	cp src/snappy-magic-launch staging-snappy/$DST/$BIN
	mkdir -p staging-snappy/$DST/{x86_64-linux-gnu,arm-linux-gnueabihf}
	cp intermediate/bin-linux-arm/$BIN staging-snappy/$DST/arm-linux-gnueabihf/$BIN
	cp intermediate/bin-linux-amd64/$BIN staging-snappy/$DST/x86_64-linux-gnu/$BIN
}

dl-ext() {
        local URL=$1
        local FN=$(basename $URL)
        local DN=$2

        if [ ! -f src_cache/$FN ]; then
                mkdir -p src_cache
                pushd src_cache
		echo "downloading $URL"
                wget $URL || exit 1
                popd
        fi

}

siphon-package() {
	local DEB=$1
	local ARCH=$2

	local DST=$(pwd)/staging-snappy/siphoned/$ARCH/

	mkdir -p $DST

	pushd build_tmp
	mkdir -p $DEB
	pushd $DEB
	if [ ! -f .extracted ]; then
		ar x ../../src_cache/$DEB || exit 1
		if [ -f data.tar.gz ]; then
			tar -zxvf data.tar.gz -C $DST || exit 1
		fi
		if [ -f data.tar.xz ]; then
			cat data.tar.xz | unxz | tar -xvf - -C $DST || exit 1
		fi
		touch .extracted
	fi
	ls -la .$SRC
	popd
	popd
}

siphon-magic-bin() {
	local BIN=$1

	mkdir -p staging-snappy/bin
	cp src/snappy-siphon-magic staging-snappy/bin/$1
}

rm -rf build_tmp
mkdir -p build_tmp

# mosquitto
for pn in mosquitto mosquitto-clients libmosquitto0; do
	dl-ext http://ports.ubuntu.com/pool/universe/m/mosquitto/${pn}_0.15-2ubuntu1_armhf.deb
	dl-ext http://mirrors.kernel.org/ubuntu/pool/universe/m/mosquitto/${pn}_0.15-2ubuntu1_amd64.deb
	siphon-package ${pn}_0.15-2ubuntu1_armhf.deb arm-linux-gnueabihf
	siphon-package ${pn}_0.15-2ubuntu1_amd64.deb x86_64-linux-gnu
done
siphon-magic-bin mosquitto
siphon-magic-bin mosquitto_pub
siphon-magic-bin mosquitto_sub

# redis-server
for pn in redis-server redis-tools; do
	dl-ext http://ports.ubuntu.com/pool/universe/r/redis/${pn}_2.8.4-2_armhf.deb
	dl-ext http://mirrors.kernel.org/ubuntu/pool/universe/r/redis/${pn}_2.8.4-2_amd64.deb
	siphon-package ${pn}_2.8.4-2_armhf.deb arm-linux-gnueabihf
	siphon-package ${pn}_2.8.4-2_amd64.deb x86_64-linux-gnu
done
dl-ext http://ports.ubuntu.com/ubuntu-ports/pool/universe/j/jemalloc/libjemalloc1_3.5.1-2_armhf.deb
dl-ext http://mirrors.kernel.org/ubuntu/pool/universe/j/jemalloc/libjemalloc1_3.5.1-2_amd64.deb
siphon-package libjemalloc1_3.5.1-2_armhf.deb arm-linux-gnueabihf
siphon-package libjemalloc1_3.5.1-2_amd64.deb x86_64-linux-gnu
siphon-magic-bin redis-server
siphon-magic-bin redis-cli

dl-ext http://ports.ubuntu.com/ubuntu-ports/pool/universe/j/jq/jq_1.3-1.1ubuntu1_armhf.deb
siphon-package jq_1.3-1.1ubuntu1_armhf.deb

dl-ext http://ports.ubuntu.com/ubuntu-ports/pool/main/c/curl/curl_7.35.0-1ubuntu2.3_armhf.deb
siphon-package curl_7.35.0-1ubuntu2.3_armhf.deb

dl-ext http://ports.ubuntu.com/ubuntu-ports/pool/main/c/curl/libcurl3_7.35.0-1ubuntu2.3_armhf.deb
siphon-package libcurl3_7.35.0-1ubuntu2.3_armhf.deb

dl-ext http://ports.ubuntu.com/ubuntu-ports/pool/main/i/iw/iw_3.4-1_armhf.deb
siphon-package iw_3.4-1_armhf.deb

dl-ext http://ports.ubuntu.com/ubuntu-ports/pool/main/libn/libnl3/libnl-3-200_3.2.21-1_armhf.deb
siphon-package libnl-3-200_3.2.21-1_armhf.deb

dl-ext http://ports.ubuntu.com/ubuntu-ports/pool/main/libn/libnl3/libnl-genl-3-200_3.2.21-1_armhf.deb
siphon-package libnl-genl-3-200_3.2.21-1_armhf.deb

dl-ext http://ports.ubuntu.com/ubuntu-ports/pool/main/w/wireless-tools/wireless-tools_30~pre9-8ubuntu1_armhf.deb
siphon-package wireless-tools_30~pre9-8ubuntu1_armhf.deb

dl-ext http://ports.ubuntu.com/ubuntu-ports/pool/main/w/wireless-tools/libiw30_30~pre9-8ubuntu1_armhf.deb
siphon-package libiw30_30~pre9-8ubuntu1_armhf.deb

# sphere-client
stage-add sources/sphere-client/ninjapack/root/opt/ninjablocks/sphere-client sphere-client
stage-magic-bin sphere-client sphere-client/

# sphere-go-homecloud
stage-add sources/sphere-go-homecloud/ninjapack/root/opt/ninjablocks/sphere-go-homecloud sphere-go-homecloud
stage-magic-bin sphere-go-homecloud sphere-go-homecloud/

# sphere-global-utils
stage-add sources/sphere-global-utils/bin .

# sphere-utils
stage-magic-bin sphere-go-serial bin
stage-magic-bin sphere-go-config bin

# utils
stage-magic-bin mqtt-bridgeify bin/

stage-add sources/sphere-config/config config
stage-add sources/sphere-schemas sphere-schemas

#
# replace all links with copies of the linked file
#
# intent: we would like to use links at runtime, but snappy
# doesn't allow the target of a binary (in package.yaml) to be 
# a symbolic link
#
# so, rather than storing n copies of the source in template/bin
# we store one copy and represent the link intent with a symbolic
# link. at packaging time, we resolve the links into copies of the file
#
# this preserves the original intent, without the development cost
# of multiple copies. at some point we should discover why snappy
# doesn't allow binaries to target symbolic links and then
# document that discovery here. alternatively, if snappy is changed
# to support symbolic links we can remove this workaround here.
#
find staging-snappy/bin -type l | while read l
do
    file=$(readlink -f "$l")
    rm "$l"
    cp "$file" "$l"
done


#ADD src/system-services /etc/service
#ADD src/ninja-services /home/ninja/service
#RUN chown -R ninja.ninja /home/ninja/service

#RUN mkdir -p /data/etc/avahi/services /data/etc/opt/ninja
#RUN chown -R ninja.ninja /data

#ADD src/redis.conf /etc/redis/redis.conf

#RUN ln -s /opt/ninjablocks/bin/start /usr/sbin/start

#VOLUME ["/data"]

#CMD ["/sbin/my_init"]
#ENV PATH="/opt/ninjablocks/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
#ENV NINJA_BOARD_TYPE="sphere"
#ENV NINJA_OS_TAG="norelease"
#ENV NINJA_OS_BUILD_TARGET="sphere-docker-hacking"
#ENV NINJA_OS_BUILD_NAME="ubuntu_docker_trusty_norelease_sphere-hacking"

#EXPOSE 1883 8000
