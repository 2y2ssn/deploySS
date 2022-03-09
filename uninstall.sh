docker stop ss-rust && docker stop watchtower
docker rm -f ss-rust && docker rm -f watchtower
systemctl stop docker && systemctl disable docker
apt purge docker-ce docker-ce-cli containerd.io
rm -rf /var/lib/docker
rm -rf /var/lib/containerd
rm -rf /etc/shadowsocks
