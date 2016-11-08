#!/usr/bin/env make

GIT_ROOT:=$(shell git rev-parse --show-toplevel)

tools:
	docker pull ubuntu:14.04 && \
	curl https://concourse-hpe.s3.amazonaws.com/configgin-1.1.0%2B4.g999ac54.develop-linux-amd64.tgz -o ${GIT_ROOT}/output/tools/configgin.tgz

layers:
	fissile build layer compilation && \
	fissile build layer stemcell

compile:
	fissile build packages

build:
	fissile build images && \
	docker tag $(shell fissile show image) fissile-cf-solo:latest && \
	cd ${GIT_ROOT}/add-ons && \
	docker build -t cfsolo/cfsolo .

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
