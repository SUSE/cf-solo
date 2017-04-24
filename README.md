# cf-solo
[![Build Status](https://travis-ci.org/hpcloud/cf-solo.svg?branch=master)](https://travis-ci.org/hpcloud/cf-solo)

## Running

You can run this on a Linux or a Mac right now.
On a Mac, make sure to read the instructions on your screen about setting your proxy.

```
bash <(curl -s https://raw.githubusercontent.com/hpcloud/cf-solo/master/run-cf-solo.sh)
```

The need for a proxy on a mac exists because of [some network problems](https://docs.docker.com/docker-for-mac/networking/#/per-container-ip-addressing-is-not-possible).

## Building

You have to build this on a Linux machine and you need to source `.fissilerc`.
Has been tested on Ubuntu 14.04, 16.04 and OSX.
Make sure you have `fissile` in your path. You can build it yourself from [source](https://github.com/hpcloud/fissile)
or grab a binary from [here](https://concourse-hpe.s3.amazonaws.com/fissile-3.0.1%2b4.gd899624.linux-amd64.tgz).

Make sure you initialize submodules by running the following:
```
git submodule sync --recursive
git submodule update --init  --recursive
```

### TL;DR

Run the following
```
source ./.fissilerc
make releases tools layers compile build
```

### Details

First create BOSH releases for all the pieces we require. All you need to do is
run the following command. Things will run in a docker container and we'll get a
cache of BOSH objects (jobs and packages) that are used by fissile to build the
image we want.

```
make releases
```

Download required dependencies.

```
make tools
```

Next, let's build the image layers we need.

```
make layers
```

Then compile packages.

```
make compile
```

Finally, build the image.

```
make build
```
