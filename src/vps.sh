#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Usage: $0 xxx.sh"
  exit 1
fi

VPS_LI="u3 sea mi u1 u2 uc m15"

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

chmod +x $1
rfp=/tmp/$1
for vps in $VPS_LI; do
  echo -e "\033[32m→ $vps\033[0m"

  rsync -avz $1 $vps:$rfp
  ssh $vps <<EOF
    $rfp && rm -rf $rfp
EOF

done
