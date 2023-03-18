# Deploy Shadowsocks-rust
**Deploy shadowsocks-rust by Docker and use watchtower to autoupdate container.**

## Preparation
```
apt update && apt install ca-certificates wget -y && update-ca-certificates
```

```
$ wget -O tcpx.sh "https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcpx.sh" && chmod +x tcpx.sh && ./tcpx.sh
# 选择 11 启用 BBR
```

```
# 查看当前支持TCP算法
$ cat /proc/sys/net/ipv4/tcp_allowed_congestion_control
# 查看当前运行的算法
$ cat /proc/sys/net/ipv4/tcp_congestion_control
# 查看当前队列算法
$ sysctl net.core.default_qdisc
```

## 安装 Docker

```
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh
```

```
$ systemctl enable docker && systemctl start docker
$ systemctl status docker
```

## Shadowsocks-rust 配置
```
mkdir -p /etc/shadowsocks-rust
```

**修改配置文件中的 `server_port` 和 `password`**

```
# 生成密码
$ openssl rand -base64 16
```

```
cat > /etc/shadowsocks-rust/config.json <<EOF
{
    "server":"0.0.0.0",
    "server_port":9000,
    "password":"GeneratePassword",
    "timeout":300,
    "method":"aes-256-gcm",
    "fast_open":false,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp"
}
EOF
```

## Pull the image and start

```
docker pull ghcr.io/shadowsocks/ssserver-rust && docker pull containrrr/watchtower
```

**修改 `-p 9000:9000/tcp -p 9000:9000/udp` 为 shadowsocks-rust 配置文件中的端口**

```
docker run --name ss-rust --restart always -p 9000:9000/tcp -p 9000:9000/udp -v /etc/shadowsocks-rust/config.json:/etc/shadowsocks-rust/config.json -dit ghcr.io/shadowsocks/ssserver-rust
```

```
docker run -d --name watchtower --restart=always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --cleanup --interval=86400
```

```
# 查看容器在线状态及大小
$ docker ps -as
# 查看 docker 容器占用 CPU，内存等信息
$ docker stats --no-stream
# 查看容器的运行输出日志
$ docker logs ss-rust
```

**[如何部署一台抗封锁的Shadowsocks-libev服务器](https://www.gfw.report/blog/ss_tutorial/zh/)**

## Uninstall

```
$ docker stop ss-rust && docker rm -f ss-rust
$ systemctl stop docker && systemctl disable docker
$ apt purge docker-ce docker-ce-cli containerd.io
$ rm -rf /var/lib/docker
$ rm -rf /var/lib/containerd
$ rm -rf /etc/shadowsocks-rust
```
