echo "----in_inet0"
###############################################################################################################################
#
## IN_INET0_TCP
#

$IPTABLES -N in_inet0_tcp

$IPTABLES -A in_inet0_tcp -p tcp		-m multiport	--dports 135,137:139,445	-j DROP
$IPTABLES -A in_inet0_tcp -p tcp -s $EADMIP0	-m multiport	--dports 22			-j allowed #
$IPTABLES -A in_inet0_tcp -p tcp -s $EADMIP1	-m multiport	--dports 22			-j allowed #
$IPTABLES -A in_inet0_tcp -p tcp -s $EADMIP2	-m multiport	--dports 22			-j allowed #
$IPTABLES -A in_inet0_tcp -p tcp		-m multiport	--dports 1723			-j allowed #
$IPTABLES -A in_inet0_tcp -p tcp		-m multiport	--dports 1194			-j allowed #
$IPTABLES -A in_inet0_tcp -p tcp		-m multiport	--dports 443			-j allowed #
$IPTABLES -A in_inet0_tcp -p tcp		-m multiport	--dports 80			-j allowed #
$IPTABLES -A in_inet0_tcp -p tcp -s $INET0IP	-m multiport	--dports 40443			-j allowed #


#
#
###############################################################################################################################
#
## IN_INET0_UDP
#
$IPTABLES -N in_inet0_udp
$IPTABLES -A in_inet0_udp -p udp		-m multiport	--dports 67:68,135,137:139,445	-j DROP
#$IPTABLES -A in_inet0_udp -p udp		-m multiport	--dports 53			-j allowed
$IPTABLES -A in_inet0_udp -p udp		-m multiport	--dports 500,4500		-j allowed

#
#
###############################################################################################################################
#
## IN_INET0_ICMP
#
$IPTABLES -N in_inet0_icmp
$IPTABLES -A in_inet0_icmp             	-p icmp -m icmp --icmp-type 0			-j allowed
$IPTABLES -A in_inet0_icmp -s $EADMIP0	-p icmp -m icmp --icmp-type 3			-j allowed
$IPTABLES -A in_inet0_icmp -s $EADMIP0	-p icmp -m icmp --icmp-type 8 			-j allowed
$IPTABLES -A in_inet0_icmp -s $EADMIP1	-p icmp -m icmp --icmp-type 3			-j allowed
$IPTABLES -A in_inet0_icmp -s $EADMIP1	-p icmp -m icmp --icmp-type 8 			-j allowed

$IPTABLES -A in_inet0_icmp 	-p icmp -m icmp --icmp-type 3			-j allowed
$IPTABLES -A in_inet0_icmp 	-p icmp -m icmp --icmp-type 8 			-j allowed

$IPTABLES -A in_inet0_icmp             	-p icmp -m icmp --icmp-type 11			-j allowed

#
###############################################################################################################################
#
## IN_INET0_LOG
#
$IPTABLES -N in_inet0_log
$IPTABLES -A in_inet0_log -p TCP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT INI0 TCP:  "
$IPTABLES -A in_inet0_log -p UDP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT INI0 UDP:  "
$IPTABLES -A in_inet0_log -p ICMP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT INI0 ICMP: "
$IPTABLES -A in_inet0_log									-j DROP

#
#
###############################################################################################################################
#
##IN_INET0
#
$IPTABLES -N in_inet0
$IPTABLES -A in_inet0 	-p 47			-j ACCEPT
$IPTABLES -A in_inet0 	-p ah			-j ACCEPT
$IPTABLES -A in_inet0 	-p esp			-j ACCEPT
$IPTABLES -A in_inet0	-p ALL	-d $BCAST	-j DROP
$IPTABLES -A in_inet0	-p TCP			-j in_inet0_tcp
$IPTABLES -A in_inet0	-p UDP			-j in_inet0_udp
$IPTABLES -A in_inet0	-p ICMP			-j in_inet0_icmp
$IPTABLES -A in_inet0	-p ALL			-j in_inet0_log
