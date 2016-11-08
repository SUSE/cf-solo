set -e

PATCH_DIR="/var/vcap/jobs-src/blobstore/templates"
SENTINEL="${PATCH_DIR}/${0##*/}.sentinel"

if [ -f "${SENTINEL}" ]; then
  exit 0
fi

read -r -d '' pre_start_patch <<'PATCH' || true
--- a/jobs/blobstore/templates/pre-start.sh.erb
+++ b/jobs/blobstore/templates/pre-start.sh.erb
@@ -13,7 +13,7 @@ function setup_blobstore_directories {
   mkdir -p $log_dir
   mkdir -p $data
   mkdir -p $tmp_dir
-  chown -R vcap:vcap $run_dir $log_dir $data $tmp_dir $nginx_webdav_dir "${nginx_webdav_dir}/.."
+  chown -R -L vcap:vcap $run_dir $log_dir $data $tmp_dir $nginx_webdav_dir
 }

 setup_blobstore_directories
PATCH

cd "$PATCH_DIR"

echo -e "${pre_start_patch}" | patch --force

touch "${SENTINEL}"

exit 0
