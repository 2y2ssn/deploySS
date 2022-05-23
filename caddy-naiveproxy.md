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
