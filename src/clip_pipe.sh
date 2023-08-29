#!/usr/bin/env bash

source /etc/profile
set -ex
cd ~/art/clip-runtime
nc -z -w 1 127.0.0.1 7890 && export https_proxy=http://127.0.0.1:7890
git fetch --all && git reset --hard origin/main
#gitsync
direnv allow
cd clip_pipe
pnpm i
bunx cep -c src -o lib
supervisorctl start xxai-clip || true
sudo killall -9 node || true
