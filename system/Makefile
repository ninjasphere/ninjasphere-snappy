DEVICE_PART=device_part_ninjasphere_mod.tar.xz
FRAMEWORK_SNAP=ninjasphere_$(shell ../framework/ver.sh)_multi.snap
TARGET_IMAGE=ninjasphere-snappy-$(shell ../framework/ver.sh).img
WEBDM_VERSION=$(shell ./get-webdm-version.sh)
WEBDM_PACKAGE=webdm_$(WEBDM_VERSION)_multi.snap
LED_CONTROLLER_VERSION=$(shell ../packages/ver.sh led-controller)
LED_CONTROLLER_PACKAGE=../packages/led-controller/sphere-led-controller_$(LED_CONTROLLER_VERSION)_multi.snap

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
		--install $(WEBDM_PACKAGE) \
		--install $(LED_CONTROLLER_PACKAGE)
	rm $(TARGET_IMAGE)
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
