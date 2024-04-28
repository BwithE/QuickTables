#!/bin/bash

echo "
              _      _    _        _     _           
   __ _ _   _(_) ___| | _| |_ __ _| |__ | | ___  ___ 
  / _` | | | | |/ __| |/ / __/ _` | '_ \| |/ _ \/ __|
 | (_| | |_| | | (__|   <| || (_| | |_) | |  __/\__ \
  \__, |\__,_|_|\___|_|\_\\__\__,_|_.__/|_|\___||___/
     |_|                                             

"

echo "##############################################"
echo "FLUSHING FIREWALL"
# Resetting the firewall rules
iptables -A INPUT -j ACCEPT  # Allow all incoming traffic
iptables -A FORWARD -j ACCEPT # Allow all forwarded traffic
iptables -t nat -F # flush all nat rules
iptables -F  # Flush all rules

while [ true ]
do
echo "##############################################"
# Prompt the user to choose the type of traffic
read -p "Select the type of traffic 
1. Input
2. Forward
3. Output
4. SNAT
5. DNAT
6. Save iptables
7. EXIT
Enter number: " table

# Input traffic configuration
if [ "$table" = "1" ]; then
    echo "##############################################"
    read -p "Enter Source IP: " src
    echo "##############################################"
    read -p "Enter Destination IP: " dest
    echo "##############################################"
    read -p "Enter Protocol (tcp/udp): " proto
    echo "##############################################"
    read -p "Enter Port: " port

    # Add iptables rule to allow incoming traffic from specific source IP to specific destination IP, protocol, and port
    iptables -A INPUT -s "$src" -d "$dest" -p "$proto" --dport "$port" -j ACCEPT
fi


# Forward traffic configuration
if [ "$table" = "2" ]; then
    echo "##############################################"
    read -p "Enter Source IP: " src
    echo "##############################################"
    read -p "Enter Destination IP: " dest
    echo "##############################################"
    read -p "Enter Protocol: " proto
    echo "##############################################"
    read -p "Enter Port: " port
    echo "##############################################"
    read -p "Which way do you want traffic to travel? 
    1. Src2Dst
    2. Dst2Src
    3. Both Directions
    Input: 1, 2, 3: " traffic 

    if [ "$traffic" = "1" ]; then
        # Forward traffic from source to destination
        iptables -A FORWARD -s "$src" -d "$dest" -p "$proto" --dport "$port" -j ACCEPT
    fi

    if [ "$traffic" = "2" ]; then
        # Forward traffic from destination to source
        iptables -A FORWARD -d "$src" -s "$dest" -p "$proto" --sport "$port" -j ACCEPT
    fi

    if [ "$traffic" = "3" ]; then
        # Forward traffic in both directions
        iptables -A FORWARD -s "$src" -d "$dest" -p "$proto" --dport "$port" -j ACCEPT
        iptables -A FORWARD -d "$src" -s "$dest" -p "$proto" --sport "$port" -j ACCEPT
    fi
fi

# Output traffic configuration
if [ "$table" = "3" ]; then
    echo "##############################################"
    read -p "Enter Destination IP: " dest
    echo "##############################################"
    read -p "Enter Protocol: " proto
    echo "##############################################"
    read -p "Enter Port: " port
    # Allow outbound SSH traffic to the specified destination IP
    iptables -A OUTPUT -p "$proto" -d "$dest" --dport "$port" -j ACCEPT
fi

# SNAT traffic configuration
if [ "$table" = "4" ]; then
    echo "##############################################"
    read -p "Enter Source IP: " src
    echo "##############################################"
    read -p "Enter Destination IP: " dest
    echo "##############################################"
    read -p "Enter Protocol: " proto
    echo "##############################################"
    read -p "Enter Port: " port
    echo "##############################################"
    read -p "Enter SNAT IP(THIS MACHINES IP THAT CAN REACH THE DEST IP): " snat_ip

    # Assuming you want to perform SNAT for outgoing traffic from a private network
    iptables -t nat -A POSTROUTING -s "$src" -d "$dest" -p "$proto" --dport "$port" -j SNAT --to-source "$snat_ip"
fi

# DNAT traffic configuration
if [ "$table" = "5" ]; then
    echo "##############################################"
    read -p "Source IP: " src
    echo "##############################################"
    read -p "Destination IP: " dst
    echo "##############################################"
    read -p "Port: " port
    echo "##############################################"
    read -p "Forwarding Facing IP: " fdest
    echo "##############################################"
    read -p "Forwarding Port: " fport

    # Add DNAT rule to forward incoming traffic to the internal destination IP and port
    iptables -t nat -A PREROUTING -p tcp -d "$dst" -s "$src" --dport "$port" -j DNAT --to-destination "$fdest:$fport"

    # Add forwarding rule to ensure forwarded traffic is correctly routed to the internal server
    iptables -A FORWARD -p tcp -d "$fdest" -s "$src" --dport "$fport" -j ACCEPT

    # Add forwarding rule to ensure response traffic is correctly routed back to the original sender
    iptables -A FORWARD -p tcp -s "$fdest" -d "$src" --sport "$fport" -j ACCEPT
fi

if [ "$table" = "6" ]; then
    echo "##############################################"
    echo "SAVING IPTABLES"
    iptables-save > /etc/iptables/quicktables.rules
fi

if [ "$table" = "7" ]; then
    echo "##############################################"
    echo "APPLYING DROP POLICIES"
    break
fi

done

# Setting up default firewall rules
iptables -A INPUT -i lo -j ACCEPT  # Allow loopback traffic
iptables -P INPUT -j DROP           # Drop all other incoming traffic
iptables -P FORWARD -j DROP         # Drop all other forwarded traffic

# Inform the user about keeping or resetting settings
echo "##############################################"
echo "Press 'CTRL+C' to keep settings."
echo "Or wait 10 seconds for reset..."
sleep 10

# Resetting the firewall rules
iptables -A INPUT -j ACCEPT  # Allow all incoming traffic
iptables -A FORWARD -j ACCEPT # Allow all forwarded traffic
iptables -t nat -F # flush all nat rules
iptables -F  # Flush all rules
echo "##############################################"
echo "FIREWALL HAS BEEN FLUSHED"
echo "##############################################"


