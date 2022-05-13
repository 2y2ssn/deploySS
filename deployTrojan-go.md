# Trojan-go + Nginx

## 

```
mkdir -p /etc/trojan-go
mkdir -p /var/www/html
mkdir -p /var/log/trojan-go
mkdir -p /home/tls
```

### acme.sh
```
wget -O -  https://get.acme.sh | sh -s email=my@example.com


```


### Nginx.conf
```
vim /etc/nginx/nginx.conf
```

```
http {

    server {
        listen 80; #IPv4,http默认监听端口。
        listen [::]:80; #IPv6,http默认监听端口。无IPv6,此项可以删除。
        return 301 https://$host$request_uri;
    }

    server {
        listen 127.0.0.1:853;

        location / {
            if ($host ~* "\d+\.\d+\.\d+\.\d+") {
                return 400;
            }
            add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
            index index.html index.htm;
        }
    }
}
```
[Installing NGINX Open Source](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/)

## Trojan-go


```
wget -O https://github.com/p4gefau1t/trojan-go/releases/download/v0.10.6/trojan-go-darwin-amd64.zip
```

### Trojan-go.service

```
mv trojan-go /etc/local/usr/
mv geosite.dat geoip.dat /etc/trojan-go/
```
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
ExecStart=/usr/local/bin/trojan-go/trojan-go -config /etc/trojan-go/config.json
Restart=on-failure
RestartSec=10s
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target
EOF
```

### Trojan-go confgi.json

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
        "cert": "/home/tls/xx.yy/xx.yy.crt", //换成自己的证书，绝对路径。
        "key": "/home/tls/xx.yy/xx.yy.key", //换成自己的密钥，绝对路径。
        "key_password": "",
        "cipher": "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384:TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256:TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256",
        "prefer_server_cipher": true,
        "alpn":[
            "http/1.1"
        ],
        "reuse_session": true,
        "session_ticket": false,
        "plain_http_response": "",
        "fallback_addr": "",
        "fallback_port": 0
    },
    "tcp": {
        "no_delay": true,
        "keep_alive": true,
        "prefer_ipv4": false
    }
}
EOF
```
