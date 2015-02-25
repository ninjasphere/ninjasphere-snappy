#!/bin/bash

echo -n $(curl -s https://search.apps.ubuntu.com/api/v1/package/com.ubuntu.snappy.webdm | grep -Po '(?<="version": ")([^"]+)')
