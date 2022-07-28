# Red Hat-based distributions (CentOS, Fedora)Here's how to disable the protocol on a Red Hat-based system:

1. Open a terminal window.
2. Change to the root user.
3. Type these commands: 

```
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
sysctl -w net.ipv6.conf.tun0.disable_ipv6=1
```
 
4. To re-enable IPv6, type these commands:

```
sysctl -w net.ipv6.conf.all.disable_ipv6=0
sysctl -w net.ipv6.conf.default.disable_ipv6=0
sysctl -w net.ipv6.conf.tun0.disable_ipv6=0
sysctl -p
```


# Debian based distributions (Debian, Ubuntu)Here's how to disable the protocol on a Debian-based machine.

1. Open a terminal window.
2. Type this command:

`sudo vim /etc/sysctl.conf`
 
3. Add the following at the bottom of the file:

```
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
net.ipv6.conf.tun0.disable_ipv6 = 1
```

4. Save and close the file.
5. Reboot the device.
6. To re-enable IPv6, remove the above lines from /etc/sysctl.conf and reboot the device.
