
```
$ apt update && apt upgrade -y && apt autoremove -y && apt autoclean -y
$ apt install vim wget curl fail2ban ufw git gnupg ca-certificates -y
```

```
$ hostnamectl
$ cat /etc/hostname
# 查看镜像源
$ cat /etc/apt/sources.list
# 修改时区为上海
$ sudo timedatectl set-timezone Asia/Shanghai
# DNS
$ cat /etc/resolv.conf
$ cat /etc/systemd/resolved.conf
```
### DNS64
```
$ echo -e "nameserver 2606:4700:4700::64\nnameserver 2606:4700:4700::6400" > /etc/resolv.conf
# 2606:4700:4700::64 / 2606:4700:4700:0:0:0:0:64 / 2606:4700:4700::6400 / 2606:4700:4700:0:0:0:0:6400
$ echo -e "nameserver 2a01:4f8:c2c:123f::1\nnameserver 2001:67c:2b0::4\nnameserver 2001:67c:2b0::6" > /etc/resolv.conf
```

### 用 systemd-resolved 支持 DNS over TLS

```
$ cat /etc/resolv.conf
# NetworkManager 使用 systemd-resolved 解析域名
$ sudo vim /etc/NetworkManager/NetworkManager.conf
```

```
[main]
dns=systemd-resolved
```

```
$ sudo vim /etc/systemd/resolved.conf
```
```
[Resolve]
DNS=119.29.29.29 9.9.9.11
FallbackDNS=223.5.5.5 45.11.45.11 1.0.0.2
#Domains=
#LLMNR=no
#MulticastDNS=no
DNSSEC=yes
DNSOverTLS=yes
#Cache=yes
#DNSStubListener=yes
#ReadEtcHosts=yes
```

```
# 通过修改 /etc/resolv.conf 来修改你的 DNS 服务器。一旦你作出了修改，建议写保护这个文件
$ sudo vim /etc/resolv.conf
# nameservers 127.0.0.53
# 写保护 以及 取消写保护
$ sudo chattr +i /etc/resolv.conf
$ sudo chattr -i /etc/resolv.conf
```

```
sudo systemctl enable --now systemd-resolved
sudo systemctl restart systemd-resolved.service
sudo systemctl restart NetworkManager
```

From https://blog-h3a-moe.pages.dev/src/d07400/


### sources.list
```
# For server in China https://mirrors.ustc.edu.cn/repogen/
$ sudo sed -i "s@http://.*archive.ubuntu.com@https://repo.huaweicloud.com@g" /etc/apt/sources.list
$ sudo sed -i "s@http://.*security.ubuntu.com@https://repo.huaweicloud.com@g" /etc/apt/sources.list
```

```
# 随机生成字符串密码
openssl rand -base64 16
```

## Optimization

### BBR Manual
```
sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control = bbr" >>/etc/sysctl.conf
echo "net.core.default_qdisc = fq" >>/etc/sysctl.conf
sysctl -p >/dev/null 2>&1
```

### BBR Script
```
$ wget -N --no-check-certificate "https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcpx.sh" && chmod +x tcpx.sh && ./tcpx.sh
# 选择 11 以开启 TCP BBR
# 验证内核
uname -r
# 查看是否开启 tcp_ bbr
lsmod | grep bbr
```
```
wget -N --no-check-certificate "https://raw.githubusercontent.com/teddysun/across/master/bbr.sh" && bash ./bbr.sh
```

## SSH 进阶

```
# 备份
$ cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
# 编辑 SSH 配置文件
$ vim /etc/ssh/sshd_config
$ systemctl status ssh
```

```
sed -i 's/#Port\ 22/Port\ 21212/' /etc/ssh/sshd_config && systemctl reload ssh

# 一键修改默认 SSH 端口
```
```
# 有防火墙或者安全组的记得进行相应修改
Port 12345
# 允许 root 帐户登录
PermitRootLogin yes
# 仅允许特定用户（在 sshd_config 末尾另起一行）
$ AllowUsers username
PubkeyAuthentication yes
PasswordAuthentication no
```

```
$ ssh-keygen -t ed25519 -C "your_email@example.com"
# ~/.ssh/id_ed25519 (Private Key)
# ~/.ssh/id_ed25519.pub (Public Key)
```

**copy Public Key to `authorized_keys` files**

```
mkdir -p ~/.ssh
vim ~/.ssh/authorized_keys
```

```
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

```
systemctl restart ssh
```

```
ssh -i ~/.ssh/id_{type} user@example.com -p port
```

[SSH Command Cheat Sheet](https://quickref.me/ssh)

## UFW & Fail2ban

### UFW
```
apt update && apt install ufw -y
ufw allow 21212/tcp
ufw allow 25565
ufw allow https
ufw delete allow https
ufw enable/status
```

### Fail2ban
```
$ apt update && apt install fail2ban -y
$ systemctl enable/restart/status fail2ban
$ fail2ban-client status
$ fail2ban-client start/reload/stop/status
$ fail2ban-client status sshd
```

```
$ cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
$ cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```

```
vim /etc/fail2ban/jail.local
```
```
[sshd]
enabled = true
port = 21212 # 修改为 SSH 端口
maxentry = 3 # 最大尝试次数
findtime = 300 # 在该时间段内超过 maxretry 次数则封禁
bantime = 180d
```
```
systemctl restart fail2ban
```

## Reference
1. [How to Use Fail2ban to Secure Your Server](https://www.linode.com/docs/guides/using-fail2ban-to-secure-your-server-a-tutorial/)
2. [Proper fail2ban configuration | Wiki](https://github.com/fail2ban/fail2ban/wiki/Proper-fail2ban-configuration)
3. [Linux 使用 adduser 与 useradd 添加普通用户的正确姿势 ](https://p3terx.com/archives/add-normal-users-with-adduser-and-useradd.html)
4. [Linux 中授予普通用户 sudo 权限的正确方法](https://p3terx.com/archives/linux-grants-normal-user-sudo-permission.html)
5. [Support for IPv6-only networks · Cloudflare 1.1.1.1 docs](https://developers.cloudflare.com/1.1.1.1/infrastructure/ipv6-networks/)
6. [How to Use Fail2ban to Secure Your Server (A Tutorial) | Linode](https://www.linode.com/docs/guides/using-fail2ban-to-secure-your-server-a-tutorial/)
7. [VPS 安全设置 ](https://einverne.github.io/post/2018/03/vps-security.html)
