#!/bin/bash

# Flush existing rules
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

# Allow established and related incoming connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# Allow loopback interface traffic
iptables -A INPUT -i lo -j ACCEPT

# Set default policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Save the rules (for Debian/Ubuntu)
iptables-save > /etc/iptables/rules.v4

# Save the rules (for Red Hat/CentOS)
# service iptables save
