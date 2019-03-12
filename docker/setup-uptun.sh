#/bin/bash

ip tuntap add mode tun dev pgwtun
ip addr add 45.45.0.1/16 dev pgwtun
ip link set dev pgwtun up
sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -I INPUT -i pgwtun -j ACCEPT
