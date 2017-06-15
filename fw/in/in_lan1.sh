echo "----in_lan1"
#
#
###############################################################################################################################
#
## in_lan1_TCP
#
$IPTABLES -N in_lan1_tcp
$IPTABLES -A in_lan1_tcp	-p tcp	-m multiport	--dports 135,137:139,445	-j DROP
#
#
###############################################################################################################################
#
## in_lan1_UDP
#
$IPTABLES -N in_lan1_udp
$IPTABLES -A in_lan1_udp 	-p udp	-m multiport	--dports 135,137:139,445,475,1947	-j DROP
#
#
###############################################################################################################################
#
## in_lan1_ICMP
#
$IPTABLES -N in_lan1_icmp
$IPTABLES -A in_lan1_icmp	-p icmp 	-m icmp --icmp-type 0				-j allowed
$IPTABLES -A in_lan1_icmp	-p icmp 	-m icmp --icmp-type 3				-j allowed
$IPTABLES -A in_lan1_icmp	-p icmp 	-m icmp --icmp-type 8 				-j allowed
$IPTABLES -A in_lan1_icmp	-p icmp 	-m icmp --icmp-type 11				-j allowed
#
###############################################################################################################################
#
## in_lan1_LOG
#
$IPTABLES -N in_lan1_log

$IPTABLES -A in_lan1_log	-p TCP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT INVL1 TCP:  "
$IPTABLES -A in_lan1_log	-p UDP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT INVL1 UDP:  "
$IPTABLES -A in_lan1_log	-p ICMP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT INVL1 ICMP: "
$IPTABLES -A in_lan1_log									-j DROP
#
#
###############################################################################################################################
#
##in_lan1
#
$IPTABLES -N in_lan1
#$IPTABLES -A in_lan1	-p ALL			-j mac_control
$IPTABLES -A in_lan1	-p ALL -d $LAN1BCAST	-j DROP
$IPTABLES -A in_lan1	-p TCP 			-j in_lan1_tcp
$IPTABLES -A in_lan1	-p UDP			-j in_lan1_udp
$IPTABLES -A in_lan1	-p ICMP			-j in_lan1_icmp
$IPTABLES -A in_lan1	-p ALL			-j in_lan1_log
