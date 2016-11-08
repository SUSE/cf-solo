mkdir -p ~/.cfsolo/data
mkdir -p ~/.cfsolo/nfs
docker network create --subnet 192.168.240.0/24 cf
docker pull cfsolo/cfsolo
docker run \
  -it --rm --name cfsolo \
  --net cf --ip 192.168.240.3 \
  --env=DOMAIN=cf-solo.io \
  --env=DEFAULT_APP_DISK_IN_MB=1024 \
  --env=DEFAULT_APP_MEMORY=1024 \
  --env=DIEGO_CELL_MEMORY_CAPACITY_MB=auto \
  --env=GARDEN_LINUX_DNS_SERVER=8.8.8.8 \
  --env=DIEGO_CELL_SUBNET=10.38.0.0/16 \
  --env=DNS_HEALTH_CHECK_HOST=example.com. \
  --env=CLUSTER_ADMIN_PASSWORD=changeme \
  --volume ~/.cfsolo/nfs:/var/vcap/nfs/shared \
  --volume ~/.cfsolo/data:/var/vcap/data \
  --privileged --cap-drop=SYS_ADMIN \
  cfsolo/cfsolo
