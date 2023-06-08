#!/usr/bin/env coffee

> ./vpsli
  ssh2-promise:Ssh
  os > homedir
  @w5/utf8/utf8d.js
  path > join
  ssh-config:Config
  ssh2 > Client
  @w5/read

HOME = homedir()
CONFIG = Config.parse read join HOME,'.ssh/config'

ssh = (host, sh)=>
  conf = CONFIG.compute host
  {IdentityFile} = conf
  if not IdentityFile
    return
  pkfp = IdentityFile[0]
  if pkfp.startsWith('~/')
    pkfp = HOME + pkfp.slice(1)

  conf = {
    host: conf.HostName
    port: conf.Port || 22
    username: conf.User
    privateKey:read pkfp
  }
  conn = new Client()
  new Promise (resolve,reject)=>
    conn.on(
      'ready'
      =>
        conn.exec(
          sh
          (err,stream)=>
            if err
              console.error '❌', host, err
              conn.end()
            else

              log = (data)=>
                console.log host,'>',utf8d(data).trim()
                return

              stream.on(
                'data'
                log
              ).on(
                'close'
                (code)=>
                  if code != 0
                    console.error '❌', host, sh, '→ CODE', code
                  else
                    console.log '✅', host
                  conn.end()
                  resolve()
                  return
              ).stderr.on(
                'data'
                log
              )
            return
        )
        return
    ).on(
      'error'
      reject
    ).connect conf
    return

run = (sh)=>
  li = []
  for host from vpsli
    li.push ssh host,sh
  Promise.allSettled li

# await run 'source ~/.bash_aliases && cd ~/wac.tax/pkg/bot/civitai && git pull && ./init.sh'
await run 'source ~/.bash_aliases && cd ~/wac.tax/pkg/bot/civitai && git pull && ./update.sh'
process.exit()
