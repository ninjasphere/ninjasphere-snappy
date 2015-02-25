DEVICE_PART=device_part_ninjasphere_mod.tar.xz
TARGET_IMAGE=ninjasphere-snappy.img
FRAMEWORK_SNAP=ninjasphere_$(shell ../framework/ver.sh)_multi.snap

all: $(TARGET_IMAGE)

$(TARGET_IMAGE): $(DEVICE_PART) $(FRAMEWORK_SNAP) _always
	sudo ubuntu-device-flash core \
		--size 3 \
		-o $(TARGET_IMAGE) \
		--channel ubuntu-core/devel-proposed \
		--device generic_armhf \
		--device-part $(DEVICE_PART) \
		--developer-mode \
		--install $(FRAMEWORK_SNAP)

$(DEVICE_PART): ../devicepart/$(DEVICE_PART)
	cp ../devicepart/$(DEVICE_PART) .

../devicepart/$(DEVICE_PART):
	make -C ../devicepart

$(FRAMEWORK_SNAP): ../framework/$(FRAMEWORK_SNAP)
	cp ../framework/$(FRAMEWORK_SNAP) $(FRAMEWORK_SNAP)

../framework/$(FRAMEWORK_SNAP):
	make -C ../framework sources binaries snap

_always:

clean:
	rm -rf *.snap *.xz *.img
