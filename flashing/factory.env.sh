usb_dir="/var/volatile/run/media/sda1"

this_file="${BASH_SOURCE[0]}"
if test "$this_file" != "$usb_dir/factory.env.sh"; then
	# running from a clone of the file as /etc/factory.env.sh
	# make sure we source the real version (seems this is cached)
	. $usb_dir/factory.env.sh
else
	# otherwise we're being sourced properly, go ahead and flash
	do_flash() {
		echo '***  Beginning flashing of snappy image...'
		cd $(dirname $this_file)
		bash <<\EOF
		set -ex
		latest_img=$(ls -1v ninjasphere-snappy-*.img | tail -1)
		echo "Using image file: $latest_img"
		cat $latest_img | bash -c 'i=0;
			fs=$(stat -c%s '$latest_img');
			echo "Image size: $fs bytes" >&2
			chunk=$((10 * 1024 * 1024));
			while (( $i < $fs )); do
				dd if=/dev/stdin of=/dev/stdout bs=4096 count=$(($chunk / 4096))
				i=$(($i + $chunk))
				percent=$((i * 100 / fs))
				echo "Written $i/$fs bytes (${percent}%)" >&2
				/opt/ninjablocks/factory-reset/bin/sphere-io --baud 230400 --timeout-color=blue --timeout=0 --disable-gestic=true --test="${percent}"
			done
		' | dd if=/dev/stdin of=/dev/mmcblk0 bs=1M
EOF
		/opt/ninjablocks/factory-reset/bin/sphere-io --baud 230400 --timeout-color=green --timeout=0 --disable-gestic=true --test="OK"
		echo '*** Done, Snappy should now boot.'
	}

	do_flash > $usb_dir/snappy-install.log 2>&1 || true

	reboot
	kill -9 $$ # make sure we don't continue the normal factory reset process!
fi
