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
$ cat /etc/systemd/resolved.conf
```

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
