#!/bin/sh

# Script to forward incoming Ethernet TCP traffic to/from LWiP 
# derived from: https://serverfault.com/questions/586486/how-to-do-the-port-forwarding-from-one-ip-to-another-ip-in-same-network

# Enable IP forwarding in the kernel
echo 1 > /proc/sys/net/ipv4/ip_forward

# Delete all current rules
iptables -F

# Delete all rules in table `nat`
iptables -t nat -F

# Delete all non-builtin chains
iptables -X

# Actual mapping -- on `nat` table, so it should only affect connection setup (The `nat` table is only consulted when a packet would create a new connection) 
iptables -t nat -A PREROUTING -p tcp --dport 8000 -j DNAT --to-destination 192.168.1.200:7 
iptables -t nat -A POSTROUTING -p tcp -d 192.168.1.200 --dport 7 -j SNAT --to-source 169.254.104.157
