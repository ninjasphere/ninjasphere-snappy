# sphere-wireless

Once the system is installed you can use the wpa_cli to configure a wireless connection.

```
ubuntu@localhost:~$ sudo -i
root@localhost:~# wpa_cli
wpa_cli v2.1
Copyright (c) 2004-2014, Jouni Malinen <j@w1.fi> and contributors

This software may be distributed under the terms of the BSD license.
See README for more details.


Selected interface 'wlan0'

Interactive mode

> add_network 0
0
> set_network 0 ssid "homenetlol"
OK
> set_network 0 psk "XXX"
OK
> enable_network 0
OK
...
> save
OK
```