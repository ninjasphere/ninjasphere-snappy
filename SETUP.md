# setup

Install ubuntu 15.04 and follow these steps.

* Upgrade your system.

```
sudo apt-get update
sudo apt-get upgrade
```

* Setup the snappy PPA and install the tools.

```
sudo add-apt-repository ppa:snappy-dev/beta
sudo apt-get install snappy-tools bzr
sudo apt-get install vim
```

* Install golang.

```
curl https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz | sudo tar xvzf - -C /usr/local
```

* Setup a profile addition for golang tools by putting this in the `/etc/profile.d/golang.sh` file.

```bash
#!/bin/bash

export PATH=$PATH:/usr/local/go/bin
```

* Make the profile addition executable.

```
sudo chmod +x /etc/profile.d/golang.sh
```

* Build the resources for `arm` builds.

```
cd /usr/local/go/src
sudo GOOS=linux GOARCH=arm ./make.bash --no-clean
```

# tools

If you need to rebuild the snappy tools.

Start by adding this to your `.bashrc`.

```
export GOPATH=$HOME/Code/go
export PATH=$GOPATH/bin:$PATH
```

Create the paths required in your gopath and clone the code.

```
mkdir -p $GOPATH/src/launchpad.net
cd $GOPATH/src/launchpad.net
bzr clone lp:goget-ubuntu-touch
cd goget-ubuntu-touch/ubuntu-device-flash
go get -v
go install
```

Note: This opens a big can of worms as you try and get the multitude of tools to align correctly.
