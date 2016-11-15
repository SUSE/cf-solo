# cf-solo

## Running

You can only run this on a Linux machine right now. It will start fine on Docker
for Mac, but because of [some network problems](https://docs.docker.com/docker-for-mac/networking/#/per-container-ip-addressing-is-not-possible)
you won't be able to target the API or reach your apps. We'll implement a
workaround soon.

To run on Linux:

```
bash <(curl -s https://raw.githubusercontent.com/hpcloud/cf-solo/master/run-cf-solo.sh)
```

## Building

You have to build this on a Linux machine and you need a working [`direnv`](http://direnv.net/)
setup. Has only been tested on Ubuntu 14.04 and 16.04.
Make sure you have `fissile` in your path. You can build it yourself from [source](https://github.com/hpcloud/fissile)
or grab a binary from [here](https://concourse-hpe.s3.amazonaws.com/fissile-2.0.2%2B71.g608c02c.develop-linux.amd64.tgz).

Make sure you initialize submodules by running the following:
```
git submodule sync --recursive
git submodule update --init  --recursive
```

### TL;DR

Run the following
```
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
