# 部署 Shadowsocks-rust

```
$ apt update && apt upgrade -y

$ wget -N --no-check-certificate "https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.14.3/shadowsocks-v1.14.3.x86_64-unknown-linux-gnu.tar.xz" -O shadowsocks-rust.tar.xz
$ wget -N --no-check-certificate "https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.14.3/shadowsocks-v1.14.3.x86_64-unknown-linux-musl.tar.xz" -O shadowsocks-rust.tar.xz

$ xz -d shadowsocks-rust.tar.xz && tar -xf shadowsocks-rust.tar
$ mv ssserver /usr/local/bin/  #拷贝到运行路径下
$ chmod +x /usr/local/bin/ssserver  #给予执行权限
```

```
mkdir -p /etc/shadowsocks-rust
```

```
cat > /etc/shadowsocks-rust/config.json <<EOF
{
    "server":"0.0.0.0",
    "server_port":Port,
    "password":"Your-Password",
    "timeout":360,
    "method":"aes-128-gcm",
    "fast_open":false,
    "nameserver":"9.9.9.9",
    "mode":"tcp_and_udp"
}
EOF
```

```
/usr/local/bin/ssserver -c /etc/shadowsocks-rust/config.json
```

### 创建服务文件service

```
cat > /etc/systemd/system/ssrust.service <<EOF
[Unit]
Description=Shadowsocks-Rust Service
After=network.target

[Service]
Type=simple
User=nobody
Group=nogroup
ExecStart=/usr/local/bin/ssserver -c /etc/shadowsocks-rust/config.json

[Install]
WantedBy=multi-user.target
```

```
$ systemctl daemon-reload
$ systemctl start/stop/status ssrust
$ systemctl enable/disable ssrust //加入开机自启
```

**[如何部署一台抗封锁的Shadowsocks-libev服务器](https://www.gfw.report/blog/ss_tutorial/zh/)**
