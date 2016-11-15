#!/usr/bin/env make

GIT_ROOT:=$(shell git rev-parse --show-toplevel)

all: releases tools layers compile build

tools: ${GIT_ROOT}/output/tools/configgin.tgz
	docker pull ubuntu:14.04

${GIT_ROOT}/output/tools/configgin.tgz:
	mkdir -p $(dir $@)
	curl https://concourse-hpe.s3.amazonaws.com/configgin-1.1.0%2B4.g999ac54.develop-linux-amd64.tgz -o $@

layers:
	fissile build layer compilation
	fissile build layer stemcell

compile:
	fissile build packages

build:
	fissile build images
	docker tag $(shell fissile show image) fissile-cf-solo:latest
	docker build -t cfsolo/cfsolo ${GIT_ROOT}/add-ons

########## BOSH RELEASE TARGETS ##########

cf-release:
	${GIT_ROOT}/bin/create-release src/cf-release cf

diego-release:
	${GIT_ROOT}/bin/create-release src/diego-release diego

garden-release:
	${GIT_ROOT}/bin/create-release src/garden-linux-release garden-linux

cflinuxfs2-rootfs-release:
	${GIT_ROOT}/bin/create-release src/cflinuxfs2-rootfs-release cflinuxfs2-rootfs

routing-release:
	${GIT_ROOT}/bin/create-release src/routing-release routing

releases: \
	cf-release \
	diego-release \
	garden-release \
	cflinuxfs2-rootfs-release \
	routing-release \
	${NULL}
