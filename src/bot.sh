#!/usr/bin/env bash

BOT=$HOME/art/pkg/bot

if [ ! -d "$BOT" ]; then
  exit 0
fi

source /etc/profile

nc -z -w 1 127.0.0.1 7890 && export https_proxy=http://127.0.0.1:7890

set -ex
cd $BOT

gitsync
#git fetch --all && git reset --hard origin/main

direnv allow
ni

ic() {
  cd $BOT/$1
  ni
  bunx cep -c src -o lib
}

ic adult
ic civitai

sudo killall -9 node || true
