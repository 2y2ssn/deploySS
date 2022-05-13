```
$ apt update && apt upgrade -y && apt autoremove -y && apt autoclean -y
$ apt install vim wget curl fail2ban ufw git -y
```

### Optimization
```
$ wget -N --no-check-certificate "https://github.com/ylx2016/Linux-NetSpeed/raw/master/tcpx.sh" && chmod +x tcpx.sh && ./tcpx.sh
# 选择 11 以开启 TCP BBR
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
