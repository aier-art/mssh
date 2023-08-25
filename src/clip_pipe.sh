#!/usr/bin/env bash

source /etc/profile
set -ex
cd ~/art/clip-runtime
gitsync
direnv allow
cd clip_pipe
bunx cep -c src -o lib
supervisorctl start xxai-clip || true
sudo killall -9 node
