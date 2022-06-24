# Trojan-go + Nginx

Tip：本文环境 ubuntu20.04，如使用其他版本的 Linux，自行修改安装 Nginx 的源

**创建必要的文件目录**
```
$ apt update && apt upgrade -y && apt install curl wget vim unzip gnupg2 cron socat -y
$ mkdir -p /etc/trojan-go
$ mkdir -p /var/www/html
$ mkdir -p /var/log/trojan-go
$ mkdir -p /home/tls
```

### acme.sh

```
$ wget -O -  https://get.acme.sh | sh -s email=my@example.com
# 推荐使用 DNS APi 申请证书
$ acme.sh --issue --dns dns_cf --keylength ec-256 -d example.com
```

## Nginx

```
$ sudo wget https://nginx.org/keys/nginx_signing.key
$ sudo apt-key add nginx_signing.key
```
```
sudo vim /etc/apt/sources.list
```

```
deb https://nginx.org/packages/mainline/ubuntu/ focal nginx
deb-src https://nginx.org/packages/mainline/ubuntu/ focal nginx
```
```
$ sudo apt install nginx
$ nginx -s signal/stop/quit/reload/reopen
$ ps -ax | grep nginx

$ curl -I 127.0.0.1
HTTP/1.1 200 OK
Server: nginx/1.13.8
```

### Nginx.conf

By default, the configuration file is named nginx.conf and placed in the directory`/usr/local/nginx/conf`, `/etc/nginx`, or `/usr/local/etc/nginx`.

```
vim /etc/nginx/nginx.conf
```

```
http {
    server {
        listen 80;
        listen [::]:80; #无 IPv6 可删除。
        return 301 https://$host$request_uri;
    }

    server {
        listen 127.0.0.1:853 default_server;
        server_name _;
        return 400;
    }

    server {
        listen 127.0.0.1:853;
        server_name example.com;

        location / {
            add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
            root /var/www/html;
            index index.html index.htm;
        }
    }
}
```

[Installing NGINX Open Source](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/)
[nginx documentation](https://nginx.org/en/docs/)


## Trojan-go

```
$ wget --no-check-certificate https://github.com/p4gefau1t/trojan-go/releases/download/v0.10.6/trojan-go-linux-amd64.zip
$ unzip trojan-go-linux-amd64.zip 
$ mv trojan-go /usr/local/bin/
$ mv geosite.dat geoip.dat /etc/trojan-go/
$ chmod +x /usr/local/bin/trojan-go
```

### Trojan-go.service

```
cat > /etc/systemd/system/trojan-go.service <<EOF
[Unit]
Description=Trojan-Go - An unidentifiable mechanism that helps you bypass GFW
Documentation=https://p4gefau1t.github.io/trojan-go/
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/trojan-go -config /etc/trojan-go/config.json
Restart=on-failure
RestartSec=10s
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target
EOF
```

### Trojan-go config.json

```
cat > /etc/trojan-go/config.json <<EOF
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 443,
    "remote_addr": "127.0.0.1",
    "remote_port": 853, //http/1.1回落端口
    "password": [
        "Your-Trojan-Password"
    ],
    "log_level": 2,
    "log_file": "/var/log/trojan-go/access.log",
    "ssl": {
        "cert": "/home/tls/example.com/fullchain.cer", //换成自己的证书，绝对路径。
        "key": "/home/tls/example.com/private.key", //换成自己的密钥，绝对路径。
        "key_password": "",
        "cipher": "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384:TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256:TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256",
        "curves": "",
        "prefer_server_cipher": true,
        "alpn":[
            "http/1.1"
        ],
        "reuse_session": true,
        "session_ticket": true,
        "plain_http_response": "",
        "fallback_addr": "",
        "fallback_port": 0
    },
    "tcp": {
        "no_delay": true,
        "keep_alive": true,
        "prefer_ipv4": true
    },
    "router": {
        "enabled": true,
        "block": [
            "geoip:private",
            "geoip:cn",
            "bittorrent"
        ],
        "geoip": "/etc/trojan-go/geoip.dat",
        "geosite": "/etc/trojan-go/geosite.dat"
    }
}

}
EOF
```

```
$ /usr/local/bin/trojan-go  -config /etc/trojan-go/config.json
$ systemctl enable trojan-go
$ systemctl daemon-reload
$ systemctl start/stop/restart trojan-go
$ systemctl status trojan-go
$ journalctl -u trojan-go
```

