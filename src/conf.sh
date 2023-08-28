#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
source /etc/profile
set -ex

cd ~/art/conf
git pull
cd ~/art/clip-runtime
direnv allow
ni i
