
```
$ apt update && apt upgrade -y && apt install wget unzip
$ cd /usr/local/bin/
$ wget -N --no-check-certificate "https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.14.3/shadowsocks-v1.14.3.x86_64-unknown-linux-gnu.tar.xz" -O shadowsocks-rust.tar.xz 
$ xz -d shadowsocks-rust.tar.xz && tar -xf shadowsocks-rust.tar
$ cp ssserver /usr/bin/  #拷贝到运行路径下
$ chmod +x /usr/bin/sserver  #给予执行权限
```

```
mkdir -p /etc/shadowsocks-rust
```

```
cat > /etc/shadowsocks-rust/config.json <<EOF
{
    "server":"0.0.0.0",
    "server_port":25565,
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
cd /etc/systemd/system/ && vim ssrust.service

# 内容
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
$ systemctl start/stop ssrust //启动
$ systemctl enable/disable ssrust //加入开机自启
$ systemctl is-enabled ssrust //判断服务是否处于开机自启状态，输出enabled即代表开机自启
```
