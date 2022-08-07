```
{
        "inbounds": [
                {
                        "port": 10000,
                        "protocol": "vmess",
                        "settings": {
                                "clients": [
                                        {
                                                "id": "52e3e508-8174-92ea-091e-3e251ef28e3d",
                                        }
                                ]
                        }
                }
        ],
        "outbounds": [
                {
                        "protocol": "freedom",
                        "tag": "ipv4_out",
                        "settings": {}
                },
                {
                        "protocol": "freedom",
                        "tag": "ipv6_out",
                        "settings": {
                                "domainStrategy": "UseIPv6"
                        }
                }
        ],
        "routing": {
                "rules": [
                        {
                                "type": "field",
                                "outboundTag": "ipv6_out",
                                "domain": [
                                        "domain:google.com"
                                ]
                        },
                        {
                                "type": "field",
                                "outboundTag": "ipv4_out",
                                "network": "tcp,udp"
                        }
                ]
        }
}
```
