#!/usr/bin/env bash

VPS_LI="u1 u2 u3 uc sea mi m15"

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

rfp=/tmp/$1

for vps in $VPS_LI; do
  echo $vps

  rsync -avz $1 $vps:$rfp
  ssh $vps <<EOF
    $rfp && rm -rf $rfp
EOF

done
