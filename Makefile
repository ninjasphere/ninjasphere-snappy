all:

sources: sources/sphere-config sources/sphere-schemas
binaries: client director homecloud mqtt-bridgeify

sources/sphere-config:
	git clone https://github.com/ninjasphere/sphere-config.git sources/sphere-config

sources/sphere-schemas:
	git clone https://github.com/ninjasphere/schemas.git sources/sphere-schemas

client:
	./scripts/build-binary.sh ninjasphere/sphere-client

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
	snappy-remote --url=ssh://10.0.1.14 install ./ninjasphere_0.0.8_multi.snap
