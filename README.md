# QuickTables
# Usage:

Download the Script: ```git clone https://github.com/bwithe/quicktables```

Make it Executable: ```chmod +x quicktables/tables.sh```

Run the Script: ```sudo bash quicktables/tables.sh```

Follow the Prompts: Follow the prompts displayed by the script to configure iptables rules for different types of traffic.

Review and Confirm: Review the rules you've configured. Press CTRL+C to keep the settings, or wait for 10 seconds for the rules to reset.

Optional: You can also modify the script to customize it according to your specific firewall requirements.

# Configuration Explanation:
1. Input Traffic Configuration:

  - Configure rules for allowing specific incoming traffic based on source IP, destination IP, protocol, and port.

2. Forward Traffic Configuration:

  - Set up rules for forwarding traffic between specified source and destination IPs and ports.

  - Choose the direction of traffic flow: from source to destination, from destination to source, or in both directions.

3.  Output Traffic Configuration:

  - Configure rules for allowing outbound traffic to specific destination IPs, protocols, and ports.

4. SNAT Traffic Configuration:

  - Set up Source Network Address Translation (SNAT) rules for outgoing traffic.

  - Specify source IP, destination IP, protocol, port, and the SNAT IP (the machine's IP that can reach the destination).

5. DNAT Traffic Configuration:

  - Configure Destination Network Address Translation (DNAT) rules for incoming traffic.

  - Specify source IP, destination IP, port, forwarding destination IP, and forwarding port.

  - This is useful for port forwarding scenarios, where incoming traffic to a specific port is forwarded to another internal IP and port.

6. Default Firewall Rules:

  - After configuring specific rules, default firewall rules are set:

  - Allow all loopback traffic.

  - Drop all other incoming and forwarded traffic.

7. Confirmation and Reset:

  - After configuring rules, the script prompts the user to keep or reset the settings.

  - If no action is taken within 10 seconds, the script automatically resets the firewall rules to allow all incoming and forwarded traffic.

# Note:

Exercise Caution: Configuring firewall rules can affect network connectivity and security. Ensure that you understand the implications of the rules you're configuring.

Backup: Before making significant changes to your firewall configuration, consider backing up your existing rules to avoid accidental disruptions to network services.

Testing: It's a good practice to test new firewall rules in a controlled environment before deploying them in a production environment.
