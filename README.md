# ninjasphere-snappy

# requirements for compiling packages

Some packages require cgo. Make sure you have a version of Go that compile for linux/arm with cgo support, currently this is a native ARM build or an x86 build with cross compilation enabled:

```
cd /usr/local/go/src
CC_FOR_TARGET=arm-linux-gnueabi-gcc CGO_ENABLED=1 GOOS=linux GOARCH=arm ./make.bash
```

# resources

* [Snappy for Devices porting guide](https://developer.ubuntu.com/en/snappy/porting/)
