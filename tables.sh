#!/bin/bash

# Flush existing rules
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X


# Allow loopback interface traffic
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow established and related incoming connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow incoming SSH (port 22) - adjust if you use a different port
#iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT

# Allow incoming HTTP (port 80) and HTTPS (port 443) - if you are running a web server
# Uncomment the following lines if needed
# iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT
# iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT

# Allow incoming ICMP (ping)
#iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Allow other specific ports if needed
# iptables -A INPUT -p tcp --dport <port_number> -m conntrack --ctstate NEW -j ACCEPT

# Log dropped packets (optional, can be verbose)
# iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables dropped: " --log-level 7


# Set default policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Save the rules (for Debian/Ubuntu)
iptables-save > /etc/iptables/rules.v4

# Save the rules (for Red Hat/CentOS)
# service iptables save