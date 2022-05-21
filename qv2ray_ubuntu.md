# [Qv2ray](https://qv2ray.net/)

## 1. Install Qv2ray on Ubuntu

```
# Install Qv2rayuse Debian repository
$ # Install some prerequisites needed by adding GPG public keys
$ sudo apt-get install gnupg ca-certificates curl
# Import our GPG key. Notice the hyphen at the end of line.
$ curl -sSL https://qv2ray.net/debian/pubkey.gpg | sudo apt-key add -

# Add the our official APT repository:
$ echo "deb [arch=amd64] https://qv2ray.net/debian/ $YOUR_DISTRIBUTION main" | sudo tee /etc/apt/sources.list.d/qv2ray.list

# To update the APT index:
$ sudo apt-get update
# You can install Qv2ray from APT now:
$ sudo apt-get install qv2ray
```
[Qv2ray Debian Repository](https://qv2ray.net/debian/)

## 2. 安装 V2ray

```
# Install V2ray use Debian repository
# Install some prerequisites needed by adding GPG public keys
$sudo apt-get install gnupg ca-certificates curl
# Import our GPG key. Notice the hyphen at the end of line.
$ curl -sSL https://apt.v2fly.org/pubkey.gpg | sudo apt-key add -
# Add the our official APT repository:
$ echo "deb [arch=amd64] https://apt.v2fly.org/ stable main" | sudo tee /etc/apt/sources.list.d/v2ray.list
# To update the APT index:
$ sudo apt-get update
# You can install V2Ray from APT now:
$ sudo apt-get install v2ray
```
[v2fly/debian: Debian Repository for V2Ray](https://github.com/v2fly/debian)

```
# Install v2ray-core with official script
# 安装和更新 V2Ray
$ bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
# 安装最新发行的 geoip.dat 和 geosite.dat
$ bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)
# 若作为客户端，可关闭服务端服务
systemctl disable v2ray --now
```
[v2fly/fhs-install-v2ray: Bash script for installing V2Ray in operating systems such as Debian / CentOS / Fedora / openSUSE that support systemd](https://github.com/v2fly/fhs-install-v2ray)

```
# Download v2ray-core by fastgit
https://hub.fastgit.xyz/v2fly/v2ray-core/releases
```

```
# Install v2ray-core on debian/ubuntu
# download script
$ curl -O https://cdn.jsdelivr.net/gh/v2rayA/v2rayA@master/install/go.sh
# install v2ray-core from jsdelivr
$ sudo bash go.sh
```
[v2rayA Wiki](https://github.com/v2rayA/v2rayA/wiki)

## 3. 修改系统 DNS

如果希望在透明代理环境里让v2ray的内置dns接管本地dns，则勾选“dns拦截”。注意，在透明代理环境下，如果系统dns或v2ray的内置dns配置不当，可能导致系统无法解析域名从而无法正常上网。

```
$ cat /etc/resolv.conf
# 使 NetworkManager 用 systemd-resolved 解析域名
$ sudo vim /etc/NetworkManager/NetworkManager.conf

# Add 
main: dns=default

$ service network-manager restart

```
```
$ sudo vim sudo vim /etc/systemd/resolved.conf
DNS=1.0.0.1 1.1.1.1 45.11.45.11
DNSOverTLS=yes
DNSSEC=yes
```
```
# DNS
# https://dns.cloudflare.com/dns-query
# https://dns11.quad9.net/dns-query
# https://dns.alidns.com/dns-query
# https://doh.pub/dns-query
```

## 4. 使用 cgproxy 实现透明代理
[springzfx/cgproxy: Transparent Proxy with cgroup 透明代理，配合v2ray/Qv2ray食用最佳](https://github.com/springzfx/cgproxy)

```
# Download from https://github.com/springzfx/cgproxy#how-to-build-and-install
$ sudo dpkg -i cgproxy_0.19_amd64.deb

# 更新 v2ray 后需要重新授权
$ sudo setcap "cap_net_admin,cap_net_bind_service=ep" $(which v2ray)
$ sudo setcap "cap_net_admin,cap_net_bind_service=ep" /usr/bin/v2ray
```

```
# cat > /etc/cgproxy/config.json <<EOF
{
    "comment":"For usage, see https://github.com/springzfx/cgproxy",
    "port": 12345,
    "program_noproxy": ["v2ray", "qv2ray", "/path-to/trojan-go"],
    "program_proxy": [],
    "cgroup_noproxy": ["/system.slice/v2ray.service"],
    "cgroup_proxy": ["/"],
    "enable_gateway": false,
    "enable_dns": true,
    "enable_udp": true,
    "enable_tcp": true,
    "enable_ipv4": true,
    "enable_ipv6": true,
    "table": 10007,
    "fwmark": 39283
}
EOF
```

```
$ sudo systemctl enable --now cgproxy.service
$ sudo systemctl restart/stop/start/status/disable cgproxy.service
```

```
# Test
$ cgproxy curl -sSLv https://www.google.com/
$ cgproxy curl -vI https://www.google.com
```
