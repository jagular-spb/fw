echo "----in_lan3"
#
#
###############################################################################################################################
#
## in_lan3_TCP
#
$IPTABLES -N in_lan3_tcp
$IPTABLES -A in_lan3_tcp	-p tcp	-m multiport	--dports 135,137:139,445	-j DROP
#
#
###############################################################################################################################
#
## in_lan3_UDP
#
$IPTABLES -N in_lan3_udp
$IPTABLES -A in_lan3_udp 	-p udp	-m multiport	--dports 135,137:139,445,475,1947	-j DROP

$IPTABLES -A in_lan3_udp 	-p udp	-m multiport	--dports 53	-j allowed
#
#
###############################################################################################################################
#
## in_lan3_ICMP
#
$IPTABLES -N in_lan3_icmp
$IPTABLES -A in_lan3_icmp	-p icmp 	-m icmp --icmp-type 0				-j allowed
$IPTABLES -A in_lan3_icmp	-p icmp 	-m icmp --icmp-type 3				-j allowed
$IPTABLES -A in_lan3_icmp	-p icmp 	-m icmp --icmp-type 8 				-j allowed
$IPTABLES -A in_lan3_icmp	-p icmp 	-m icmp --icmp-type 11				-j allowed
#
###############################################################################################################################
#
## in_lan3_LOG
#
$IPTABLES -N in_lan3_log

$IPTABLES -A in_lan3_log	-p TCP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT INVL3 TCP:  "
$IPTABLES -A in_lan3_log	-p UDP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT INVL3 UDP:  "
$IPTABLES -A in_lan3_log	-p ICMP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT INVL3 ICMP: "
$IPTABLES -A in_lan3_log									-j DROP
#
#
###############################################################################################################################
#
##in_lan3
#
$IPTABLES -N in_lan3
#$IPTABLES -A in_lan3	-p ALL			-j mac_control
$IPTABLES -A in_lan3	-p ALL -d $LAN3BCAST	-j DROP
$IPTABLES -A in_lan3	-p TCP 			-j in_lan3_tcp
$IPTABLES -A in_lan3	-p UDP			-j in_lan3_udp
$IPTABLES -A in_lan3	-p ICMP			-j in_lan3_icmp
$IPTABLES -A in_lan3	-p ALL			-j in_lan3_log
