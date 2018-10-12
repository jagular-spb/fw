#!/bin/bash
#PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin   
#
#
###############################################################################################################################
. ./vars
###############################################################################################################################
#
##OTHER
#

#/var/portsentry/block.sh

#
###############################################################################################################################
#
##BAD PACKETS
#
echo "---- bad_tcp_packets"
$IPTABLES -N bad_tcp_packets
$IPTABLES -A bad_tcp_packets -p tcp		-m tcp --tcp-flags SYN,ACK SYN,ACK	-m state --state NEW	-j REJECT	--reject-with tcp-reset 
$IPTABLES -A bad_tcp_packets -p tcp ! --syn	-m state --state NEW						-j LOG		--log-level DEBUG --log-prefix "NEW NOT SYN:"
$IPTABLES -A bad_tcp_packets -p tcp ! --syn	-m state --state NEW						-j DROP


#
###############################################################################################################################
#
#ALLOWED
#
echo "---- allowed"
$IPTABLES -N allowed
$IPTABLES -A allowed -p TCP --syn			 	 									-j ACCEPT
$IPTABLES -A allowed -p TCP 									-m state --state ESTABLISHED,RELATED	-j ACCEPT
$IPTABLES -A allowed -p TCP					 									-j DROP
$IPTABLES -A allowed -p UDP					 									-j ACCEPT
$IPTABLES -A allowed -p ICMP					 									-j ACCEPT

#
###############################################################################################################################
$IPTABLES -P INPUT DROP
$IPTABLES -P OUTPUT DROP
$IPTABLES -P FORWARD DROP
#
#./other/block.sh
#./other/0mac_control.sh
#
#
###############################################################################################################################
#
#
##FORWARD
#
#
echo "---- FORWARD"

$IPTABLES -A FORWARD 	-p TCP 										-j bad_tcp_packets

$IPTABLES -A FORWARD 	-p ALL	-i $INET0IFACE 			-m state --state ESTABLISHED,RELATED	-j ACCEPT #
$IPTABLES -A FORWARD 	-p ALL	-i $LAN1IFACE			-m state --state ESTABLISHED,RELATED	-j ACCEPT #
$IPTABLES -A FORWARD 	-p ALL	-i $LAN2IFACE			-m state --state ESTABLISHED,RELATED	-j ACCEPT #
$IPTABLES -A FORWARD 	-p ALL	-i $LAN3IFACE			-m state --state ESTABLISHED,RELATED	-j ACCEPT #
$IPTABLES -A FORWARD 	-p ALL	-i $TUN0IFACE			-m state --state ESTABLISHED,RELATED	-j ACCEPT #

###
#. ./fwd/fwd_inet0_lan1.sh 
#. ./fwd/fwd_lan1_inet0.sh
. ./fwd/fwd_lan2_inet0.sh
. ./fwd/fwd_tun0_lan1.sh
. ./fwd/fwd_tun0_lan2.sh
. ./fwd/fwd_tun0_lan3.sh

$IPTABLES -A FORWARD	-p ALL	-i $TUN0IFACE 	-o $LAN1IFACE			-j tun0_fw_lan1
$IPTABLES -A FORWARD	-p ALL	-i $TUN0IFACE 	-o $LAN2IFACE			-j tun0_fw_lan2
$IPTABLES -A FORWARD	-p ALL	-i $TUN0IFACE 	-o $LAN3IFACE			-j tun0_fw_lan3

#$IPTABLES -A FORWARD    -p ALL  -i $INET0IFACE  -o $LAN1IFACE                   -j inet0_fw_lan1 
#$IPTABLES -A FORWARD	-p ALL	-i $LAN1IFACE 	-o $INET0IFACE			-j lan1_fw_inet0
$IPTABLES -A FORWARD	-p ALL	-i $LAN2IFACE 	-o $INET0IFACE			-j lan2_fw_inet0

$IPTABLES -A FORWARD		-m limit --limit 3/minute --limit-burst 3 	-j LOG --log-level DEBUG --log-prefix "IPT FORWARD packet died: "

#
#
###############################################################################################################################
#
##INPUT
#
echo "---- INPUT"

$IPTABLES -A INPUT 	-p TCP 								-j bad_tcp_packets
$IPTABLES -A INPUT 	-p ALL	-i $INET0IFACE	-m state --state ESTABLISHED,RELATED	-j ACCEPT
$IPTABLES -A INPUT 	-p ALL	-i $LAN1IFACE	-m state --state ESTABLISHED,RELATED	-j ACCEPT
$IPTABLES -A INPUT 	-p ALL	-i $LAN2IFACE	-m state --state ESTABLISHED,RELATED	-j ACCEPT
$IPTABLES -A INPUT 	-p ALL	-i $LAN3IFACE	-m state --state ESTABLISHED,RELATED	-j ACCEPT
$IPTABLES -A INPUT 	-p ALL	-i $TUN0IFACE	-m state --state ESTABLISHED,RELATED	-j ACCEPT

###
. ./in/in_inet0.sh
. ./in/in_lan1.sh
. ./in/in_lan2.sh
. ./in/in_lan3.sh
. ./in/in_tun0.sh
###

$IPTABLES -A INPUT 	-p ALL	-i $INET0IFACE 						-j in_inet0
$IPTABLES -A INPUT 	-p ALL	-i $LAN1IFACE 						-j in_lan1
$IPTABLES -A INPUT 	-p ALL	-i $LAN2IFACE 						-j in_lan2
$IPTABLES -A INPUT 	-p ALL	-i $LAN3IFACE 						-j in_lan3
$IPTABLES -A INPUT 	-p ALL	-i $TUN0IFACE 						-j in_tun0
$IPTABLES -A INPUT 	-p ALL	-i $LOIFACE 						-j ACCEPT

$IPTABLES -A INPUT	-m limit --limit 3/minute --limit-burst 3 			-j LOG --log-level DEBUG --log-prefix "IPT INPUT packet died: "

#
#
###############################################################################################################################
#
##OUTPUT
#
echo "---- OUTPUT"

$IPTABLES -A OUTPUT 	-p TCP 									-j bad_tcp_packets
$IPTABLES -A OUTPUT 	-p ALL	-o $INET0IFACE		-m state --state ESTABLISHED,RELATED	-j ACCEPT
$IPTABLES -A OUTPUT 	-p ALL	-o $LAN1IFACE		-m state --state ESTABLISHED,RELATED	-j ACCEPT
$IPTABLES -A OUTPUT 	-p ALL	-o $LAN2IFACE		-m state --state ESTABLISHED,RELATED	-j ACCEPT
$IPTABLES -A OUTPUT 	-p ALL	-o $LAN3IFACE		-m state --state ESTABLISHED,RELATED	-j ACCEPT
$IPTABLES -A OUTPUT 	-p ALL	-o $TUN0IFACE		-m state --state ESTABLISHED,RELATED	-j ACCEPT

###
. ./out/out_inet0.sh
. ./out/out_lan1.sh
. ./out/out_lan2.sh
. ./out/out_lan3.sh
. ./out/out_tun0.sh
###

$IPTABLES -A OUTPUT 	-p ALL	-o $INET0IFACE 	-s $INET0IP					-j out_inet0
$IPTABLES -A OUTPUT 	-p ALL	-o $LAN1IFACE 							-j out_lan1
$IPTABLES -A OUTPUT 	-p ALL	-o $LAN2IFACE 							-j out_lan2
$IPTABLES -A OUTPUT 	-p ALL	-o $LAN3IFACE 							-j out_lan3
$IPTABLES -A OUTPUT 	-p ALL	-o $TUN0IFACE 							-j out_tun0
$IPTABLES -A OUTPUT 	-p ALL 	-o $LOIFACE 							-j ACCEPT
$IPTABLES -A OUTPUT	-m limit --limit 3/minute --limit-burst 3 				-j LOG --log-level DEBUG --log-prefix "IPT OUTPUT packet died: "
#
#
###############################################################################################################################
#
##MANGLE PREROUTING
#
$IPTABLES -t mangle -A PREROUTING -p tcp -m tcp --tcp-flags ALL FIN,PSH,URG				-j LOG --log-level DEBUG --log-prefix "SCAN (XMAS): "
$IPTABLES -t mangle -A PREROUTING -p tcp -m tcp --tcp-flags ALL FIN,PSH,URG				-j DROP
$IPTABLES -t mangle -A PREROUTING -p tcp -m tcp --tcp-flags ALL NONE					-j LOG --log-level DEBUG --log-prefix "SCAN (NULL): "
$IPTABLES -t mangle -A PREROUTING -p tcp -m tcp --tcp-flags ALL NONE					-j DROP
$IPTABLES -t mangle -A PREROUTING -p tcp -m tcp --tcp-flags SYN,RST SYN,RST				-j LOG --log-level DEBUG --log-prefix "SCAN (SYN/RST): "
$IPTABLES -t mangle -A PREROUTING -p tcp -m tcp --tcp-flags SYN,RST SYN,RST				-j DROP
$IPTABLES -t mangle -A PREROUTING -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN				-j LOG --log-level DEBUG --log-prefix "SCAN (SYN/FIN): "
$IPTABLES -t mangle -A PREROUTING -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN				-j DROP


#$IPTABLES -t nat -A PREROUTING -p tcp          	-d $INET0IP --dport 3390                -j DNAT --to-destination $SRV2:3389


#
#
###############################################################################################################################
#
##NAT POSTROUTING
#
$IPTABLES -t nat -A POSTROUTING -o $INET0IFACE -j SNAT --to-source $INET0IP
#$IPTABLES -t nat -A POSTROUTING -o $INET0IFACE -s 10.10.16.0/28 ! -d  192.168.78.0/24 -j MASQUERADE
#$IPTABLES -t nat -A POSTROUTING -o $LAN1IFACE -j SNAT --to-source $LAN1IP

#
#
###############################################################################################################################
##
#/sbin/service fail2ban restart