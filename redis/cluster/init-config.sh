#!/usr/bin/env bash
set -a
. init-config
# shellcheck disable=SC2154
grep -rl init_config_password --exclude=init-config* | xargs sed -i 's/init_config_password/'"$password"'/g'
# shellcheck disable=SC2154
grep -rl init_config_host_ip --exclude=init-config* | xargs sed -i 's/init_config_host_ip/'"$host_ip"'/g'
replacePort() {
  file=$1
  for i in {1..6} ; do
    echo "$i"
    portVar="port$i"
    sed -i 's/init_config_port'"$i"'/'"${!portVar}"'/g' "$file"
  done
}
export -f replacePort
# shellcheck disable=SC2154
grep -rlE "init_config_port[1-6]{1}" --exclude=init-config* | xargs --max-args=1 --replace="{}" sh -c 'replacePort "$@"' _ {}
