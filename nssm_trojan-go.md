# NSSM 封装 Trojan-go.exe

[NSSM - the Non-Sucking Service Manager](https://nssm.cc/)

```powershell
$ nssm reset <servicename> <parameter>
$ nssm install <servicename>
$ nssm start <servicename>
$ nssm stop <servicename>
$ nssm restart <servicename>
$ nssm edit <servicename>
$ nssm remove <servicename>
```

```powershell
# 安装 NSSM
# scoop install nssm
$ nssm install trojan-go
# 配置
$ sudo nssm start trojan-go
```

### Trojan-go Client
```
{
    "run_type": "client",
    "local_addr": "127.0.0.1",
    "local_port": 2077,
    "remote_addr": "your_server",
    "remote_port": 443,
    "password": [
        "your_password"
    ],
    "ssl": {
        "sni": "your-domain-name.com"
    },
    "router": {
        "enabled": true,
        "bypass": [
            "geoip:cn",
            "geoip:private",
            "geosite:cn",
            "geosite:private"
        ],
        "block": [
            "geosite:category-ads"
        ],
        "proxy": [
            "geosite:geolocation-!cn"
        ],
        "default_policy": "proxy",
        "geoip": "C:\\MyApp\\trojan-go\\geoip.dat",
        "geosite": "C:\\MyApp\\trojan-go\\geosite.dat"
    }
}
```
