
```
$ apt update && apt upgrade -y && apt autoremove -y && apt autoclean -y
$ apt install vim wget curl fail2ban ufw git -y
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
### sources.list
```
# https://mirrors.ustc.edu.cn/repogen/
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
$ wget -N --no-check-certificate "https://github.com/ylx2016/Linux-NetSpeed/raw/master/tcpx.sh" && chmod +x tcpx.sh && ./tcpx.sh
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
$ vim /etc/ssh/sshd_config
$ systemctl status ssh
```

```
Port 12345
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

```
apt update && apt install ufw -y
ufw allow 21212/tcp
ufw allow 25565
ufw allow https
ufw delete allow https
ufw enable/status
```

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

[sshd]
enabled = true
port = SSH-port
bantime = 100d
maxentry = 2
```

```
cat <<EOF >> /etc/fail2ban/jail.local
[DEFAULT]
ignoreip = 127.0.0.1
bantime = 86400
maxretry = 3
findtime = 1800

[ssh-iptables]
enabled = true
filter = sshd
action = iptables[name=SSH, port=ssh, protocol=tcp]
logpath = /var/log/secure
maxretry = $maxretry
findtime = 3600
bantime = $bantime
EOF
```

```
cat <<EOF >> /etc/fail2ban/jail.local
[DEFAULT]
ignoreip = 127.0.0.1
bantime = 86400
maxretry = $maxretry
findtime = 1800

[ssh-iptables]
enabled = true
filter = sshd
action = iptables[name=SSH, port=ssh, protocol=tcp]
logpath = /var/log/auth.log
maxretry = $maxretry
findtime = 3600
bantime = $bantime
EOF
```

## Reference
1. [How to Use Fail2ban to Secure Your Server](https://www.linode.com/docs/guides/using-fail2ban-to-secure-your-server-a-tutorial/)
2. [Proper fail2ban configuration | Wiki](https://github.com/fail2ban/fail2ban/wiki/Proper-fail2ban-configuration)
3. [Linux 使用 adduser 与 useradd 添加普通用户的正确姿势 ](https://p3terx.com/archives/add-normal-users-with-adduser-and-useradd.html)
4. [Linux 中授予普通用户 sudo 权限的正确方法](https://p3terx.com/archives/linux-grants-normal-user-sudo-permission.html)
5. [Support for IPv6-only networks · Cloudflare 1.1.1.1 docs](https://developers.cloudflare.com/1.1.1.1/infrastructure/ipv6-networks/)
