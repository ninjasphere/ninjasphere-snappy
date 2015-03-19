# ninjasphere-snappy

## Requirements for compiling packages

Some packages require cgo. Make sure you have a version of Go that compile for linux/arm with cgo support, currently this is a native ARM build or an x86 build with cross compilation enabled:

```
cd /usr/local/go/src
CC_FOR_TARGET=arm-linux-gnueabi-gcc CGO_ENABLED=1 GOOS=linux GOARCH=arm ./make.bash
```

## Resources

* [Snappy for Devices porting guide](https://developer.ubuntu.com/en/snappy/porting/)

## Compiling in a Docker VM

On mac, start by downloading all the ninja source code that requires SSH keys (when these become open source, this step will not be required):
```
make -C framework binaries
```

Now that the sources are prepped, run the docker container to build everything else:
```
docker run --privileged -v $(pwd):/data -v $HOME/.ssh:/root/.ssh -it ninjasphere/ninjasphere-snappy-build
make -C /data/system
```

Note that SSH pulls for private repositories will fail, but it will still build.

##Ubuntu Pre-requisites
If you want to run the build on an Ubuntu VM, the file scripts/ubuntu-prereqs.sh will install the necessary pre-reqs and update ~/.bashrc.
