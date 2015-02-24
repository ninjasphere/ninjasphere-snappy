DEVICE_PART=device_part_ninjasphere.tar.xz
TARGET_IMAGE=ninjasphere-snappy.img

all: $(TARGET_IMAGE)

$(TARGET_IMAGE): $(DEVICE_PART)
	sudo ubuntu-device-flash core --size 3 -o $(TARGET_IMAGE) --channel ubuntu-core/devel-proposed --device generic_armhf --device-part $(DEVICE_PART) --developer-mode

$(DEVICE_PART):
	wget https://firmware.sphere.ninja/snappy/$(DEVICE_PART)
