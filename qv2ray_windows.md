
## 1. 使用 Windows Scoop 包管理器安装并配置 Qv2ray

```
# 安装 Scoop 包管理器
# Scoop 默认使用普通用户权限，其本体和安装的软件默认会放在 %USERPROFILE%\scoop(即 C:\Users\username\scoop)
# 环境要求，Windows 用户名为英文，下载并安装 PowerShell
# 打开 PowerShell，设置用户安装路径
$env:SCOOP='C:\Scoop'
[Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')

# 允许执行脚本
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser # 允许执行脚本
iwr -useb 'https://cdn.jsdelivr.net/gh/kidonng/scoop-install@fastgit/install.ps1' | iex
# iwr -useb get.scoop.sh | iex

scoop install git
```

```
# 添加 mochi bucket
scoop bucket add mochi https://github.com/Qv2ray/mochi
# 安装 Qv2ray，参考 mochi
scoop install mochi/qv2ray v2ray
# 若要使用 Trojan-go,需安装 Trojan-go 插件和核心，并配置插件核心路径
scoop install mochi/trojan-go qv2ray-plugin-trojan-go
scoop install mochi/v2ray-rules-dat
# Other
scoop install mochi/naiveproxy qv2ray-plugin-naiveproxy
scoop install mochi/qv2ray-plugin-trojan
```



## 2. 从 Github Release 下载并配置 Qv2ray

[Qv2ray Github Release](https://github.com/Qv2ray/Qv2ray/releases)
[V2ray Github Release](https://github.com/v2fly/v2ray-core/releases)
[V2ray Fastgit](https://hub.fastgit.org/v2fly/v2ray-core/releases)



## 3. 参考

1. [Qv2ray 文档](https://qv2ray.net/)
2. [Installing various versions of PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.1)
3. [Scoop - 最好用的 Windows 包管理器](https://p3terx.com/archives/scoop-the-best-windows-package-manager.html)
4. [The official Scoop bucket for Qv2ray applications](https://github.com/Qv2ray/mochi/tree/master/bucket)
