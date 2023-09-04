#!/usr/bin/env bash

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 vps xxx.sh"
  exit 1
fi

# VPS_LI="mi u3 sea u1 u2 uc m15"
vps=$1
sh=$2

set -ex

chmod +x $sh
rfp=/tmp/mssh/$(basename $sh)
# for vps in $VPS_LI; do

prefix="\033[32m $vps \$(basename \${BASH_SOURCE[0]}) \$(echo \"+\$LINENO\") ❯ \033[0m"

ssh $vps "mkdir -p $(dirname $rfp)"
rsync -avz $sh $vps:$rfp

echo $prefix
ssh $vps <<EOF
PS4='$prefix' $rfp && rm -rf $rfp
EOF

# done
