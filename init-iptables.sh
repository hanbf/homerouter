#!/bin/sh

# Flush all interested tables to fresh start
iptables -t filter -F
iptables -t nat -F
iptables -t mangle -F

# enp1s0 is the internet gateway interface. It can:
# 1. Only receives packet for established connections 
# 2. Only receives NEW packet from WAN for specfic ports, which includes:
# 2.1, ports TBD
# conntrack usage refer to https://upcloud.com/community/tutorials/configure-iptables-ubuntu/
iptables -t filter -A INPUT -i enp1s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# Add rules for specific ports here
iptables -t filter -A INPUT -i enp1s0 -m conntrack --ctstate NEW -j DROP

# enp2s0 connects the home LAN.
iptables -t filter -A INPUT -i enp2s0 -s 192.168.0.0/16 -j ACCEPT
iptables -t filter -A INPUT -i enp2s0 -d 192.168.0.0/16 -j ACCEPT

# Accept packages from router itself
iptables -t filter -A INPUT -i lo -j ACCEPT

# Finally drop all other INPUT packages
iptables -t filter -A INPUT -j DROP

iptables -t filter -A OUTPUT -j ACCEPT

# Forward all packets between enp1s0 and enp2s0
iptables -t filter -A FORWARD -i enp1s0 -o enp2s0 -j ACCEPT
iptables -t filter -A FORWARD -i enp2s0 -o enp1s0 -j ACCEPT

# Drop all other FORWARD packets
iptables -t filter -A FORWARD -j DROP

# Save all the rules, the rules will be reloaded automatically during boot
iptables-save > /etc/iptables/rules.v4
