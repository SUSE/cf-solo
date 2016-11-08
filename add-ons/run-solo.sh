#!/bin/bash

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT TERM

# Create a loopback ext4 for the garden graph
dd of=/var/vcap/data/garden-sparse-file bs=1k seek=10240000 count=0
mkfs.ext4 -F -q /var/vcap/data/garden-sparse-file
mkdir -p /var/vcap/data/garden
mount /var/vcap/data/garden-sparse-file /var/vcap/data/garden

mkdir -p /var/vcap/sys/log
/opt/hcf/run.sh > /var/vcap/sys/log/runner.log 2>&1 &

pid=$!

function ctrl_c() {
  clear
  echo "Stopping ..."
  kill $pid
  exit 0
}

watch --color --no-title '/bin/bash /opt/hcf/solo-status.sh'
