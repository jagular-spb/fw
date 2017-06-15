echo "----in_lan2"
#
#
###############################################################################################################################
#
## in_lan2_TCP
#
$IPTABLES -N in_lan2_tcp
$IPTABLES -A in_lan2_tcp	-p tcp	-m multiport	--dports 135,137:139,445	-j DROP
#
#
###############################################################################################################################
#
## in_lan2_UDP
#
$IPTABLES -N in_lan2_udp
$IPTABLES -A in_lan2_udp 	-p udp	-m multiport	--dports 135,137:139,445,475,1947	-j DROP

$IPTABLES -A in_lan2_udp 	-p udp	-m multiport	--dports 53	-j allowed
#
#
###############################################################################################################################
#
## in_lan2_ICMP
#
$IPTABLES -N in_lan2_icmp
$IPTABLES -A in_lan2_icmp	-p icmp 	-m icmp --icmp-type 0				-j allowed
$IPTABLES -A in_lan2_icmp	-p icmp 	-m icmp --icmp-type 3				-j allowed
$IPTABLES -A in_lan2_icmp	-p icmp 	-m icmp --icmp-type 8 				-j allowed
$IPTABLES -A in_lan2_icmp	-p icmp 	-m icmp --icmp-type 11				-j allowed
#
###############################################################################################################################
#
## in_lan2_LOG
#
$IPTABLES -N in_lan2_log

$IPTABLES -A in_lan2_log	-p TCP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT INVL2 TCP:  "
$IPTABLES -A in_lan2_log	-p UDP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT INVL2 UDP:  "
$IPTABLES -A in_lan2_log	-p ICMP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT INVL2 ICMP: "
$IPTABLES -A in_lan2_log									-j DROP
#
#
###############################################################################################################################
#
##in_lan2
#
$IPTABLES -N in_lan2
#$IPTABLES -A in_lan2	-p ALL			-j mac_control
$IPTABLES -A in_lan2	-p ALL -d $LAN2BCAST	-j DROP
$IPTABLES -A in_lan2	-p TCP 			-j in_lan2_tcp
$IPTABLES -A in_lan2	-p UDP			-j in_lan2_udp
$IPTABLES -A in_lan2	-p ICMP			-j in_lan2_icmp
$IPTABLES -A in_lan2	-p ALL			-j in_lan2_log
