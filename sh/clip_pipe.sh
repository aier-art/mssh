#!/usr/bin/env bash

source /etc/profile
set -ex
nc -z -w 1 127.0.0.1 7890 && export https_proxy=http://127.0.0.1:7890

gitsync() {
  git fetch --all && git reset --hard origin/main
}

#rustup update

cd ~/art/conf
gitsync
clip=~/art/clip-runtime
cd $clip
gitsync
direnv allow
cd $clip/rust/clip_img2qdrant
./dist.sh
cd $clip/clip_pipe
pnpm i
bunx cep -c src -o lib
supervisorctl start xxai-clip || true
sudo pkill -9 -f "node .*clip_pipe/lib/index\.js" || true
