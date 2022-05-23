# Caddy 实现  Naiveproxy
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
        "https": {
          "listen": [":443"],
          "routes": [{
            "handle": [{
              "handler": "forward_proxy",
              "auth_user_deprecated": "naiveproxy-username",
              "auth_pass_deprecated": "naiveproxy-password",
              "hide_ip": true,
              "hide_via": true,
              "probe_resistance": {}
            }]
          },
          {
            "match": [{
              "host": ["example.com"]
            }],
            "handle": [{
              "handler": "subroute",
              "routes": [{
                "handle": [{
                  "handler": "headers",
                  "response": {
                    "set": {
                      "Strict-Transport-Security": ["max-age=31536000; includeSubDomains; preload"] //启用HSTS
                    }
                  }
                }]
              },
              {
                "handle": [{
                  "handler": "file_server",
                  "root": "/var/www/html"
                }]
              }]
            }]
          }],
          "tls_connection_policies": [{
            "cipher_suites": ["TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384","TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256","TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256"],
            "alpn": ["h2","http/1.1"]
          }],
          "experimental_http3": true
        }
      }
    },
    "tls": {
      "certificates": {
        "automate": ["example.com"]
      }
    }
  }
}
EOF
```


````
systemctl enable caddy.service
systemctl restart caddy
````

```
# 如需使用 quic 传输协议，需要放行 443/udp
ufw allow 443/udp
```
