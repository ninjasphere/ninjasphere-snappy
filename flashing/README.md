Snappy Image Flashing
=====================

A development Snappy image can be installed on an original pre-Snappy Ninja Sphere using a USB flash drive.

You will need:
 * 1x USB flash drive, 4GB or larger, formatted as a single partition with FAT32
 * A ninjasphere Snappy image build from this repository, ```ninjasphere-snappy-XXXXXX.img```

Preparation
-----------

Write the image file, e.g. ```ninjasphere-snappy-0.0.11.img```, and the ```factory.env.sh``` script in this directory, to the FAT32 partition.

The script will automatically find and use the image file with the highest version number if multiple exist.

Make sure to safely unmount and eject the disk from your PC after copying.

Installation
------------

 * Power off the Sphere
 * Insert the USB flash drive into the USB port on the bottom of the Sphere
 * While holding down the factory reset button on the bottom of the Sphere, re-insert the power.
 * The spinner/worms animation will appear briefly then disappear for a few seconds. Continue holding down the button until worms re-appear.
 * Release the button and wait. After about 30 seconds, a progress counter should appear (starting at 0 and incrementing until 100)
 * The process will take approximately 10 minutes to complete.
 * Once completed, the LED matrix will show the green text "OK" and then a few minutes later, reboot.

Notes
-----

 * If you see four digit numbers appearing instead of the progress counter, then the USB flash drive was not detected. Please confirm it is firmly inserted, correctly formatted, and that the file ```factory.env.sh``` exists and is identical to the version in this repository.
 * If after a reboot the progress counter starts again, the flashing was unsuccessful or the image itself was incorrect (either built improperly, or currupted while being transferred to the USB), try restarting the process.
 * The Snappy boot will currently take a few minutes to complete because no network is configured. As a workaround, a USB Ethernet dongle with a DHCP-enabled network connected will usually bypass this delay.
 * A file ```snappy-install.log``` will be written to the USB flash drive after flashing is complete, containing a complete log of the flashing attempt. This can be useful for diagnostics if something goes wrong during flashing.