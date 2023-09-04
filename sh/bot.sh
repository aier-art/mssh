#!/usr/bin/env bash

BOT=$HOME/art/pkg/bot

if [ ! -d "$BOT" ]; then
  exit 0
fi

gitsync() {
  msg='♨'

  branch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' | awk -F' ' '{print $2}')

  git add --update :/ && git commit -m "$msg" || true

  git pull origin $branch

  branch=$(git branch | awk '{print $2}')

  git pull origin $branch

  git merge $branch

  git push --recurse-submodules=on-demand --tag --set-upstream origin $branch
}

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

sudo pkill -9 -f "node .*civitai" || true
