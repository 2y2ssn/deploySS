# acme.sh

```
$ apt update && apt install cron socat curl wget  -y
# 安装 Acme
$ wget -O -  https://get.acme.sh | sh -s email=yourEmail@wxample.com
# 重启终端
$ source ~/.bashrc
$ acme.sh --set-default-ca  --server zerossl
$ acme.sh --renew -d example.com --force --ecc
```

## Automatic DNS API integration

### Use Cloudflare domain API
Cloudflare Domain API offers two methods to automatically issue certs.

**Using the global API key**

First you need to login to your Cloudflare account to get your [API key](https://dash.cloudflare.com/profile). Each token generated is not stored on cloudflare account and will have expiry if not set correctly. You will get this in API keys section.
```
export CF_Key="sdfsdfsdfljlbjkljlkjsdfoiwje"
export CF_Email="xxxx@sss.com"
```
```
$ acme.sh --issue --dns dns_cf -d example.com -d www.example.com --keylength ec-256
$ mkdir  /home/tls/example.com  #建立文件夹存放申请的证书、密钥
$ acme.sh --ecc --installcert -d example.com  --key-file /home/tls/example.com/private.key  --fullchain-file /home/tls/example.com/fullchain.cer
```
The `CF_Key` and `CF_Email` will be saved in ~/.acme.sh/account.conf and will be reused when needed.

### Use ClouDNS.net API

You need to set the HTTP API user ID and password credentials. See: https://www.cloudns.net/wiki/article/42/. For security reasons, it's recommended to use a sub user ID that only has access to the necessary zones, as a regular API user has access to your entire account.
```
# Use this for a sub auth ID
export CLOUDNS_SUB_AUTH_ID=XXXXX
# Use this for a regular auth ID
#export CLOUDNS_AUTH_ID=XXXXX
export CLOUDNS_AUTH_PASSWORD="YYYYYYYYY"
```
Ok, let's issue a cert now:
```
acme.sh --issue --dns dns_cloudns -d example.com -d www.example.com
```
The `CLOUDNS_AUTH_ID` and `CLOUDNS_AUTH_PASSWORD` will be saved in `~/.acme.sh/account.conf` and will be reused when needed.


## Issue Wildcard certificates
```
$ acme.sh  --issue -d example.com  -d '*.example.com'  --dns dns_cf
$ acme.sh  --issue -d example.com  -d '*.example.com'  --dns dns_cloudns
```

## Use Standalone server to issue cert
Port `80` (TCP) MUST be free to listen on, otherwise you will be prompted to free it and try again.
```
$ apt install lsof
$ lsof -i:80 # 查看80端口占用情况
$ acme.sh --issue --standalone -d example.com -d www.example.com -d cp.example.com
```

## 参考
1. [use DNS API to issue a cert | wiki](https://github.com/acmesh-official/acme.sh/wiki/dnsapi)
2. [use DNS alias mode issue a cert | wiki](https://github.com/acmesh-official/acme.sh/wiki/DNS-alias-mode)
3. [Using Free Let’s Encrypt SSL/TLS Certificates with NGINX ](https://www.nginx.com/blog/using-free-ssltls-certificates-from-lets-encrypt-with-nginx/)
4. [Certbot Instructions  | issue a cert](https://certbot.eff.org/instructions)
5. [zerossl-bot: The repository for the ZeroSSL certbot wrapper ](https://github.com/zerossl/zerossl-bot)
6. [Qualys SSL Labs](https://www.ssllabs.com/)
