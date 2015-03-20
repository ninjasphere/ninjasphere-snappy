#!/bin/bash

wget -N https://firmware.sphere.ninja/snappy/2014-03-20/device_part_ninjasphere-bundledwifi.tar.xz -O device_part_ninjasphere.tar.xz

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
