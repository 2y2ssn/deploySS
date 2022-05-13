```
$ apt update && apt upgrade -y && apt autoremove -y && apt autoclean -y
$ apt install vim wget curl fail2ban ufw git -y
```

```
# 查看镜像源
cat /etc/apt/sources.list
# 修改时区为上海
sudo timedatectl set-timezone Asia/Shanghai
```

```
# 随机生成字符串密码
openssl rand -base64 16
```

### Optimization

#### Manual
```
sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control = bbr" >>/etc/sysctl.conf
echo "net.core.default_qdisc = fq" >>/etc/sysctl.conf
sysctl -p >/dev/null 2>&1
```

#### Script
```
$ wget -N --no-check-certificate "https://github.com/ylx2016/Linux-NetSpeed/raw/master/tcpx.sh" && chmod +x tcpx.sh && ./tcpx.sh
# 选择 11 以开启 TCP BBR
# 验证内核
uname -r
# 查看是否开启 tcp_ bbr
lsmod | grep bbr
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
