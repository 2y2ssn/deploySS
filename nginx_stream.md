# Nginx 转发流量

```
stream{
    upstream tcpssh {
               server  IP(域名):端口;  
    }
    server{
        listen NAT/VPS外部端口;
        listen NAT/VPS外部端口 udp;
        proxy_pass tcpssh;
    }
}
```
