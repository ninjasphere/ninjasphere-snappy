FRAMEWORK_VERSION=$(shell ./ver.sh)
SNAPPY_REMOTE?=10.0.1.14

all:

sources: sources/sphere-config sources/sphere-schemas sources/sphere-global-utils
binaries: client director homecloud mqtt-bridgeify utils

sources/sphere-config:
	git clone https://github.com/ninjasphere/sphere-config.git sources/sphere-config

sources/sphere-schemas:
	git clone https://github.com/ninjasphere/schemas.git sources/sphere-schemas

sources/sphere-global-utils:
	git clone https://github.com/ninjasphere/sphere-global-utils.git sources/sphere-global-utils

client:
	./scripts/build-binary.sh ninjasphere/sphere-client

utils:
	./scripts/build-binary.sh ninjablocks/sphere-utils

director:
	./scripts/build-binary.sh ninjasphere/sphere-director

homecloud:
	./scripts/build-binary.sh ninjasphere/sphere-go-homecloud

mqtt-bridgeify:
	./scripts/build-binary.sh ninjablocks/mqtt-bridgeify

staging:
	./scripts/prepare-staging.sh

snap: staging
	snappy build staging-snappy

remote: snap
	snappy-remote --url=ssh://$(SNAPPY_REMOTE) install ./ninjasphere_$(FRAMEWORK_VERSION)_multi.snap
