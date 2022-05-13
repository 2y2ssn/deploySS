
```
$ curl -fsSL https://get.docker.com -o get-docker.sh | bash
$ systemctl enable docker && systemctl start docker

$ systemctl start/stop/restart docker
$ systemctl status docker
$ systemctl enable docker  # 将 Docker 服务加入开机自启动
# 查看容器在线状态及大小
$ docker ps -as
# 查看 docker 容器占用 CPU，内存等信息
$ docker stats --no-stream
# 容器命令
$ docker stop/start/restart/rm/logs $name
$ docker stop Trojan-Go
$ docker stop ss-rust
$ docker rm ss-rust
$ docker logs ss-rust
```

```
$ docker pull ghcr.io/shadowsocks/ssserver-rust 
$ docker run --name ss-rust \
  --restart always \
  -p 25565:25565/tcp \
  -p 25565:25565/udp \
  -v /etc/shadowsocks-rust/config.json:/etc/shadowsocks-rust/config.json \
  -dit ghcr.io/shadowsocks/ssserver-rust
```

```
$ docker pull containrrr/watchtower
$ docker run -d --name watchtower --restart=always \
-v /var/run/docker.sock:/var/run/docker.sock \
containrrr/watchtower --cleanup --interval=86400
```

[containrrr/watchtower](https://github.com/containrrr/watchtower)
