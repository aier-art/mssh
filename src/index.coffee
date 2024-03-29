#!/usr/bin/env coffee

> ./VPSLI
  zx/globals:
  chalk
{redBright,green} = chalk
{argv} = process

sh = argv[2]
vpsli = argv[3]?.split(' ') or VPSLI

await do =>
  if not sh
    console.log 'miss ./xxx.sh'
    return
  console.log sh
  ing = []
  for vps from vpsli
    p = $"./sh/vps.sh #{vps} #{sh}"
    ing.push p
  li = await Promise.allSettled ing
  success = 0
  failed = 0
  for r,pos in  li
    {value} = r
    if value
      {exitCode} = value
      if exitCode != 0
        ++ failed
        console.error '⇨', vpsli[pos], 'exitCode', exitCode
        console.error value.stdout
        console.error value.stderr
      else
        ++ success
    else
      ++ failed
      console.error '⇨', vpsli[pos]
      {reason } = r
      console.error green reason.stdout
      console.error redBright reason.stderr
  console.log "success #{success} failed #{failed}"
  return

#   ssh2-promise:Ssh
#   os > homedir
#   @w5/utf8/utf8d.js
#   path > join
#   ssh-config:Config
#   ssh2 > Client
#   @w5/read
#
# HOME = homedir()
# CONFIG = Config.parse read join HOME,'.ssh/config'
#
# ssh = (host, sh)=>
#   conf = CONFIG.compute host
#   {IdentityFile} = conf
#   if not IdentityFile
#     return
#   pkfp = IdentityFile[0]
#   if pkfp.startsWith('~/')
#     pkfp = HOME + pkfp.slice(1)
#
#   conf = {
#     host: conf.HostName
#     port: conf.Port || 22
#     username: conf.User
#     privateKey:read pkfp
#   }
#   conn = new Client()
#   new Promise (resolve,reject)=>
#     conn.on(
#       'ready'
#       =>
#         conn.exec(
#           sh
#           (err,stream)=>
#             if err
#               console.error '❌', host, err
#               conn.end()
#             else
#
#               log = (data)=>
#                 console.log host,'>',utf8d(data).trim()
#                 return
#
#               stream.on(
#                 'data'
#                 log
#               ).on(
#                 'close'
#                 (code)=>
#                   if code != 0
#                     console.error '❌', host, sh, '→ CODE', code
#                   else
#                     console.log '✅', host
#                   conn.end()
#                   resolve()
#                   return
#               ).stderr.on(
#                 'data'
#                 log
#               )
#             return
#         )
#         return
#     ).on(
#       'error'
#       reject
#     ).connect conf
#     return
#
# run = (sh)=>
#   li = []
#   for host from vpsli
#     li.push ssh host,sh
#   Promise.allSettled li
#
# # await run 'source ~/.bash_aliases && cd ~/wac.tax/pkg/bot/civitai && git fetch --all && git reset --hard origin/main && ./init.sh'
# await run 'source ~/.bash_aliases && cd ~/wac.tax/pkg/bot/civitai && git fetch --all && git reset --hard origin/main && ./update.sh'
# #await run 'source ~/.bash_aliases && cd ~/wac.tax/pkg/bot/adult && git fetch --all && git reset --hard origin/main && ./update.sh'
# process.exit()
