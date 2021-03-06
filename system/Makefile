DEVICE_PART=device_part_ninjasphere_mod.tar.xz
FRAMEWORK_SNAP=ninjasphere_$(shell ../framework/ver.sh)_multi.snap
TARGET_IMAGE=ninjasphere-snappy-$(shell ../framework/ver.sh).img
WEBDM_VERSION=$(shell ./get-webdm-version.sh)
WEBDM_PACKAGE=webdm_$(WEBDM_VERSION)_multi.snap

LED_CONTROLLER_VERSION=$(shell ../packages/ver.sh led-controller)
WIRELESS_VERSION=$(shell ../packages/ver.sh sphere-wireless)
ZIGBEE_VERSION=0.1.0-10
DRIVER_GO_ZIGBEE_VERSION=0.1.6-7
DRIVER_LIFX_VERSION=$(shell ../packages/ver.sh driver-lifx)

LED_CONTROLLER_PACKAGE=../packages/led-controller/sphere-led-controller_$(LED_CONTROLLER_VERSION)_multi.snap
WIRELESS_PACKAGE=../packages/sphere-wireless/sphere-wireless_$(WIRELESS_VERSION)_multi.snap
ZIGBEE_PACKAGE=../packages/zigbee-zstack-gateway/zigbee-zstack-gateway_$(ZIGBEE_VERSION)_multi.snap
DRIVER_GO_ZIGBEE_PACKAGE=../packages/driver-go-zigbee/driver-go-zigbee_$(DRIVER_GO_ZIGBEE_VERSION)_multi.snap
DRIVER_LIFX_PACKAGE=../packages/driver-lifx/sphere-driver-lifx_$(DRIVER_LIFX_VERSION)_multi.snap

all: $(TARGET_IMAGE)

$(TARGET_IMAGE): $(DEVICE_PART) $(FRAMEWORK_SNAP) $(WEBDM_PACKAGE) _always
	make -C ../packages
	sudo ubuntu-device-flash core \
		--size 3 \
		-o /tmp/$(TARGET_IMAGE) \
		--channel ubuntu-core/devel-proposed \
		--device generic_armhf \
		--device-part $(DEVICE_PART) \
		--developer-mode \
		--install $(FRAMEWORK_SNAP) \
		--install $(WIRELESS_PACKAGE) \
		--install $(WEBDM_PACKAGE) \
		--install $(LED_CONTROLLER_PACKAGE) \
		--install $(ZIGBEE_PACKAGE) \
		--install $(DRIVER_GO_ZIGBEE_PACKAGE) \
		--install $(DRIVER_LIFX_PACKAGE)
	./hack-image.sh /tmp/$(TARGET_IMAGE)
	rm -rf $(TARGET_IMAGE)
	mv /tmp/$(TARGET_IMAGE) $(TARGET_IMAGE)

$(DEVICE_PART): ../devicepart/$(DEVICE_PART)
	cp ../devicepart/$(DEVICE_PART) .

../devicepart/$(DEVICE_PART):
	make -C ../devicepart

$(FRAMEWORK_SNAP): ../framework/$(FRAMEWORK_SNAP)
	cp ../framework/$(FRAMEWORK_SNAP) $(FRAMEWORK_SNAP)

../framework/$(FRAMEWORK_SNAP):
	make -C ../framework sources binaries snap

webdm: $(WEBDM_PACKAGE)

$(WEBDM_PACKAGE):
	rm -rf webdm*.snap
	go get github.com/sergiusens/store-get
	test -x $(GOPATH)/bin/store-get || { mkdir -p $(GOPATH)/bin; cp $(GOBIN)/store-get $(GOPATH)/bin/store-get; }
	"$(GOPATH)/bin/store-get" webdm

_always:

clean:
	rm -rf *.snap *.xz *.img
	rm -r ../framework/build_tmp/ ../framework/staging-snappy/ ../framework/ninjasphere_0.0.12_multi.snap || true
