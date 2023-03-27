#  Cloudflare Warp 原生 IP

很多我们需要访问的网站都需要使用“原生 IP”，比如：[Disney+](https://www.disneyplus.com/)， [ChatGPT](https://chat.openai.com)，[New Bing](https://www.bing.com/) 等。

所谓“原生 IP”就是指该网站的 IP 地址和其机房的 IP 地址是一致的，但是，很多 IDC 提供商的 IP 都是从其它国家调配来的，这导致我们就算是翻墙了，也是使用了美国的 VPS，但是还是访问不了相关的服务。所以，我们需要使用 Cloudflare Warp 来访问这些网站。


## 1 脚本安装

你可以使用这个一键安装的脚本来快速完成安装 https://github.com/P3TERX/warp.sh

下载脚本
```shell
wget git.io/warp.sh
chmod +x warp.sh
```
运行脚本 中文菜单
```shell
./warp.sh menu
```
先后执行如下安装：
 - 1 - 安装 Cloudflare WARP 官方客户端
 - 4 - 安装 WireGuard 相关组件
 - 7 - 自动配置 WARP WireGuard 双栈全局网络

>**Note:**
> 1. 如果没有 ipv6 网络，那么第 7 步可以换成第 5 步 自动配置 WARP WireGuard IPv4 网络，或是执行 `./warp.sh 4`。
>
> 2. 你需要备份一下你的帐号和配置文件，在 `/etc/warp/` 目录下，主要是两个文件，一个是 `wgcf-account.toml`，一个是 `wgcf-profile.conf`
>
> 3. 这个脚本会启动两个 Systemd 服务，一个是 `warp-svc`，另一个是 `wg-quick@wgcf`。第一个是 Cloudflare Warp 的服务，第二个是 WireGuard 的服务。
>
> 4. 你可以使用 `./warp.sh status` 来查看服务的状态，如果正常的话，会显示如下的信息。如果你的服务没有正常启动，那么会自动 `disable wg-quick@wgcf`，如果这样的话，你可以使用 `./warp.sh d`（ipv4 + ipv6 双栈网格）或是 `./warp.sh 4`（ipv4 网络） 来重头走一遍所有的安装过程。
>       ```
>       WireGuard	: Running
>       IPv4 Network	: WARP
>       IPv6 Network	: WARP
>       ```
>


使用 `curl ipinfo.io` 命令来检查你的 IP 地址，如果显示的是 Cloudflare 的 IP 地址，那么恭喜你，你已经成功了。如：

```json
{
  "ip": "104.28.227.191",
  "city": "Los Angeles",
  "region": "California",
  "country": "US",
  "loc": "34.0522,-118.2437",
  "org": "AS13335 Cloudflare, Inc.",
  "postal": "90009",
  "timezone": "America/Los_Angeles",
  "readme": "https://ipinfo.io/missingauth"
}
```


## 2 手动安装

> **Note:**
>
> 最好还是通过上面的脚本来安装，但是如果你想手动安装，那么你可以参考下面的步骤。

**1） 安装软件包**

```shell
sudo  apt-get install net-tools openresolv wireguard
```

**2） 安装 Cloudflare Warp**

[ViRb3/wgcf](https://github.com/ViRb3/wgcf) 是一个 Cloudflare Warp 的非官方客户端，它可以帮助我们生成 Cloudflare Warp 的配置文件。

注意替换下面命令行的中 Github Release 的版本号，最新的版本号可以在 [ViRb3/wgcf Release](https://github.com/ViRb3/wgcf/releases) 里查找。

```shell
# create and enter the folder
mkdir warp && cd warp

# install wgcf
wget -O wgcf https://github.com/ViRb3/wgcf/releases/download/v2.2.14/wgcf_2.2.14_linux_amd64

# change permission
chmod +x wgcf
```

**3）注册 Cloudflare Warp**

```shell
./wgcf register
```

**4）生成 wgcf 配置文件**

```shell
./wgcf generate
```
执行完当前目录会生成2个文件：

- WARP注册文件：`wgcf-account.toml`；
- WireGuard 配置文件：`wgcf-profile.conf`。

**5）复制 WireGuard 配置文件到 `/etc/wireguard/` 目录**

```shell
sudo cp wgcf-profile.conf /etc/wireguard/wgcf.conf
```

**6） 修改 WireGuard 配置文件**

**你一定要修改 `wgcf-profile.conf` 文件，你把你的 VPS 的公网 IP 加进去，否则，你的 VPS 会失连。**

```
PostUp = ip rule add from <服务器 Public IP> lookup main
PostDown = ip rule delete from <服务器 Public IP> lookup main
```

下面是配置文件的示例：

```ini
[Interface]
PrivateKey = XXXXXXXXXXXXXxxxxxxxxxxxxx=
Address = 172.16.0.2/32,2606:4700:110:8d9b:bc8f:16f:668:d891/128
DNS = 8.8.8.8,8.8.4.4,2001:4860:4860::8888,2001:4860:4860::8844
MTU = 1420
PostUp = ip -4 rule add from 10.10.10.10 lookup main prio 18
PostDown = ip -4 rule delete from 10.10.10.10 lookup main prio 18

[Peer]
PublicKey = bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
AllowedIPs = 0.0.0.0/0,::/0
Endpoint = 162.159.192.1:2408
```

注：
- `10.10.10.10` 只是一个示例，你要把它替换成你的 VPS 的公网 IP
-  `162.159.192.1` 是域名的 `engage.cloudflareclient.com` 的 IP 地址，你可以使用 `nslookup engage.cloudflareclient.com` 获得。
-  配置文件中默认的 DNS 是 `1.1.1.1` 这里使用了 Google 的 DNS，因为会快一些。

**7）启停 WireGuard**

启用网络接口（命令中的 `wgcf` 对应的是配置文件 `/etc/wireguard/wgcf.conf` 的文件名前缀）

```shell
sudo wg-quick up wgcf
```

停止网络接口如下：

```shell
sudo wg-quick down wgcf
```

**8）设置开机自启动**

```shell
sudo systemctl enable wg-quick@wgcf
sudo systemctl start wg-quick@wgcf
```
