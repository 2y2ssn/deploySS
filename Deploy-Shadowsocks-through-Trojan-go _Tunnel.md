# 通过 Trojan-go 隧道中转 Shadowsocks-rust

### Relay NAT

```
$ mkdir -p /etc/trojan-go
$ cat > /etc/trojan-go/config.json <<EOF
{
    "run_type": "forward",  # 隧道采用的协议
    "local_addr": "0.0.0.0",
    "local_port": 54321,   # 中转端口
    "remote_addr": "server域名", # Server 的IP或域名
    "remote_port": 443,  # Server 的trojan-go监听的端口
    "target_addr": "127.0.0.1",
    "target_port": PortA,   # Server 的 Shadowsocks 的监听端口
    "password": "trojan-go-server-passwd"
}
EOF
```

### Server

#### Trojan-go

```
$ mkdir -p /etc/trojan-go
$ cat > /etc/trojan-go/config.json <<EOF
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 443,
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "trojan-go-server-passwd"
    ],
    "ssl": {
        "cert": "your_cert.crt",
        "key": "your_key.key",
        "sni": "your-domain-name.com"
    },
    "router": {
        "enabled": true,
        "block": [
            "geoip:private"
        ],
        "geoip": "/etc/trojan-go/geoip.dat",
        "geosite": "/etc/trojan-go/geosite.dat"
    }
}
EOF
```

#### Shadowsocks-rust

```
$ mkdir -p /etc/shadowsocks-rust
$ cat > /etc/shadowsocks-rust/config.json <<EOF
{
    "server":"0.0.0.0",
    "server_port":Port,
    "password":"Shadowsocks-Password",
    "timeout":300,
    "method":"aes-128-gcm",
    "fast_open":false,
    "nameserver":"9.9.9.9",
    "mode":"tcp_and_udp"
}
EOF
```

### Client

```
服务器地址：填写NAT商家给的公网域名或IP。
服务器端口：填写NAT商家自己设置的端口。本例是54321。
密码：填写VPS服务端SS设置的密码 Shadowsocks-Password。
加密模式：VPS服务端SS

通过以上设置，SS流量将使用Trojan-Go的隧道连接传输至远端SS服务器。
```

**Tip**：Relay（中转端） Shadowsocks-rust 可以是其他 Shadowsocks 服务，实现TLS中转再跳板。

[隧道和反向代理 - Trojan-Go Docs](https://p4gefau1t.github.io/trojan-go/advance/forward/)
