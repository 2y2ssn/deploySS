# Caddy 实现 Trojan-go + Naiveproxy
```
# https://github.com/lxhao61/integrated-examples/releases
$ wget https://github.com/lxhao61/integrated-examples/releases/download/20220507/caddy_linux_amd64.tar.gz
$ tar -vxzf caddy_linux_amd64.tar.gz
$ mv caddy /usr/local/bin/
$ chmod +x /usr/local/bin/caddy
$ mkdir -p /var/www/html
$ mkdir -p /etc/caddy
$ mkdir -p /var/log/caddy
```

## ACME.sh

```
$ wget -O -  https://get.acme.sh | sh -s email=my@example.com
# 推荐使用 DNS APi 申请证书
$ acme.sh --issue --dns dns_cf --keylength ec-256 -d example.com
```

## Caddy

### Caddy.service
````
cat > /etc/systemd/system/caddy.service <<EOF
[Unit]
Description=Caddy
Documentation=https://caddyserver.com/docs/
After=network.target network-online.target
Requires=network-online.target

[Service]
Type=notify
User=root
Group=root
ExecStart=/usr/local/bin/caddy run --environ --config /etc/caddy/caddy.json
ExecReload=/usr/local/bin/caddy reload --config /etc/caddy/caddy.json
TimeoutStopSec=5s
LimitNOFILE=1048576
LimitNPROC=512
PrivateTmp=true
ProtectSystem=full
AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
EOF
````

### caddy.json
```
cat > /etc/caddy/caddy.json <<EOF
{
  "admin": {
    "disabled": true
  },
  "logging": {
    "logs": {
      "default": {
        "writer": {
          "output": "file",
          "filename": "/var/log/caddy/access.log"
        },
        "level": "ERROR"
      }
    }
  },
  "apps": {
    "http": {
      "servers": {
        "h1": {
          "listen": [":80"], //http默认监听端口
          "routes": [{
            "handle": [{
              "handler": "static_response",
              "headers": {
                "Location": ["https://{http.request.host}{http.request.uri}"] //http自动跳转https，让网站看起来更真实。
              },
              "status_code": 301
            }]
          }]
        },
        "h1&h2c": {
          "listen": ["127.0.0.1:88"], //http/1.1与h2c server本地监听端口
          "routes": [{
            "handle": [{
              "handler": "forward_proxy",
              "auth_user_deprecated": "user", //naiveproxy用户，修改为自己的。
              "auth_pass_deprecated": "pass", //naiveproxy密码，修改为自己的。
              "hide_ip": true,
              "hide_via": true,
              "probe_resistance": {}
            }]
          },
          {
            "match": [{
              "host": ["example.com"] //限定域名访问（禁止以IP方式访问网站），修改为自己的域名。
            }],
            "handle": [{
              "handler": "subroute",
              "routes": [{
                "handle": [{
                  "handler": "headers",
                  "response": {
                    "set": {
                      "Strict-Transport-Security": ["max-age=31536000; includeSubDomains; preload"]
                    }
                  }
                }]
              },
              {
                "handle": [{
                  "handler": "file_server",
                  "root": "/var/www/html" //修改为自己存放的WEB文件路径
                }]
              }]
            }]
          }],
          "automatic_https": {
            "disable": true //禁用自动https
          },
          "allow_h2c": true //开启h2c server支持
        }
      }
    }
  }
}
EOF
```

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
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 443, //监听端口
    "remote_addr": "127.0.0.1",
    "remote_port": 88, //h2与http/1.1回落端口（共用端口）
    "password": [
        "diy443" //修改为自己的密码。密码可多组（"password"），用逗号隔开。
    ],
    "log_level": 2,
    "log_file": "/var/log/trojan-go/access.log", //修改为自己的日志路径
    "ssl": {
        "cert": "/home/tls/xx.yy/xx.yy.crt", //换成自己的证书，绝对路径。
        "key": "/home/tls/xx.yy/xx.yy.key", //换成自己的密钥，绝对路径。
        "key_password": "",
        "cipher": "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384:TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256:TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256",
        "curves": "",
        "prefer_server_cipher": true,
        "sni": "",
        "alpn":[
            "h2", //启用h2连接需配置h2回落，否则不一致（裸奔）容易被墙探测出从而被封。
            "http/1.1" //启用http/1.1连接需配置http/1.1回落，否则不一致（裸奔）容易被墙探测出从而被封。
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
        "prefer_ipv4": false
    },
    "websocket": {
        "enabled": true, //启用WebSocket
        "path": "/6ALdGZ9k", //修改为自己的path。若WebSocket启用必须配置，不能留空。
        "host": "" //若使用了CDN，一般需填入域名；否则不正确的host可能导致CDN无法转发请求。
    },
    "shadowsocks": {
        "enabled": false, //若使用了Websocket、且经过不可信的CDN进行中转（如国内CDN）或连接遭到了GFW针对TLS的中间人攻击等可开启；否则shadowsocks AEAD加密一般关闭。
        "method": "AES-128-GCM",
        "password": "" //配置shadowsocks AEAD加密密码。若shadowsocks AEAD加密启用必须配置，不能留空。
    }
}
```

```
$ /usr/local/bin/trojan-go -config /etc/trojan-go/config.json
$ systemctl enable trojan-go && systemctl enable trojan-go
$ systemctl restart caddy && systemctl restart caddy
$ systemctl status trojan-go
$ journalctl -u trojan-go
$ journalctl -u caddy
````
