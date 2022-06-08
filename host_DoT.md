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
