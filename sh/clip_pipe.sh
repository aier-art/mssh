#!/usr/bin/env bash

source /etc/profile
set -ex
nc -z -w 1 127.0.0.1 7890 && export https_proxy=http://127.0.0.1:7890

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
