#!/usr/bin/env coffee

> ./vpsli
  ssh2-promise:Ssh
  os > homedir
  path > join
  ssh-config:Config
  @w5/read

CONFIG = Config.parse read join homedir(),'.ssh/config'



conn = (host, sh)=>
  conf = CONFIG.compute host
  conf = {
    host: conf.HostName
    port: conf.Port || 22
    username: conf.User
    privateKey:read conf.IdentityFile[0]
  }
  ssh = new Ssh conf
  ssh = await ssh.connect()
  try
    r = await ssh.exec(sh)
  catch err
    console.error '❌ HOST', host, '>', sh
    throw err
  finally
    await ssh.close()
  console.log host + '>\n'+r
  return


await conn 'tz', '~/wac.tax/pkg/bot/civitai/update.sh'
