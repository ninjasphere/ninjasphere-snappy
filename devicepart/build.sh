#!/bin/bash

if [[ ! -f device_part_ninjasphere.tar.xz ]]; then
	wget https://firmware.sphere.ninja/snappy/device_part_ninjasphere.tar.xz
fi

rm -rf tmp
mkdir -p tmp
cd tmp
tar xJvf ../device_part_ninjasphere.tar.xz

mkdir -p boot
cd boot
rm uEnv*.txt
cp ../../src/uEnv.txt .
cd ..

tar cJvf ../device_part_ninjasphere_mod.tar.xz *
cd ..
