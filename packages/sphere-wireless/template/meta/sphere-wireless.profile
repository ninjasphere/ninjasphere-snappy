# vim:syntax=apparmor
#include <tunables/global>

# Specified profile variables
###VAR###

###PROFILEATTACH### (attach_disconnected) {

  #include <abstractions/base>
  #include <abstractions/dbus>
  #include <abstractions/consoles>
  #include <abstractions/openssl>

  # for python apps/services
  #include <abstractions/python>
  /usr/bin/python{,2,2.[0-9]*,3,3.[0-9]*} ixr,

  # for bash 'binaries' (do *not* use abstractions/bash)
  # user-specific bash files
  /bin/bash ixr,
  /bin/dash ixr,
  /sbin/wpa_supplicant ixr,

  capability net_admin,
  capability net_raw,
  network packet dgram,
  network inet dgram,

  /dev/rfkill r,
  owner @{PROC}/[0-9]*/net/psched r,
  /sys/devices/pci[0-9]*/**/ieee80211/*/name r,

  /run/wpa_supplicant/  rw,
  /run/wpa_supplicant/* rw,
  /run/sendsigs.omit.d/wpasupplicant.pid rw,
}