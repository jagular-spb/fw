echo "----out_inet0"
#
#
###############################################################################################################################
#
## OUT_inet0_TCP
#

$IPTABLES -N out_inet0_tcp

$IPTABLES -A out_inet0_tcp -p tcp			--dport 135:139		-j DROP
$IPTABLES -A out_inet0_tcp -p tcp	-m multiport	--dport 80,443		-j allowed
$IPTABLES -A out_inet0_tcp -p tcp	-m multiport	--dport 20,21		-j allowed

$IPTABLES -A out_inet0_tcp -p tcp	-m multiport	--dport 22		-j allowed
#
#
###############################################################################################################################
#
## OUT_inet0_UDP
#

$IPTABLES -N out_inet0_udp

$IPTABLES -A out_inet0_udp -p udp		--dport  135:139	-j DROP
$IPTABLES -A out_inet0_udp -p udp		--dport 53              -j allowed
$IPTABLES -A out_inet0_udp -p udp		--dport 123		-j allowed
$IPTABLES -A out_inet0_udp -p udp	-m multiport	--dports	 500,4500	-j allowed

#
#
###############################################################################################################################
#
## OUT_inet0_ICMP
#

$IPTABLES -N out_inet0_icmp

$IPTABLES -A out_inet0_icmp			-p icmp -m icmp --icmp-type 0		-j allowed
$IPTABLES -A out_inet0_icmp	-s $INET0IP	-p icmp -m icmp --icmp-type 3		-j allowed
$IPTABLES -A out_inet0_icmp	-s $INET0IP	-p icmp -m icmp --icmp-type 8		-j allowed
$IPTABLES -A out_inet0_icmp			-p icmp -m icmp --icmp-type 11		-j allowed




###############################################################################################################################
#
## OUT_inet0_LOG
#
$IPTABLES -N out_inet0_log

$IPTABLES -A out_inet0_log -p TCP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT OUI0 TCP:  "
$IPTABLES -A out_inet0_log -p UDP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT OUI0 UDP:  "
$IPTABLES -A out_inet0_log -p ICMP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT OUI0 ICMP: "
$IPTABLES -A out_inet0_log									-j DROP

#
#
###############################################################################################################################
#
##OUT_inet0
#
$IPTABLES -N out_inet0
$IPTABLES -A out_inet0	-p gre 	-j ACCEPT
$IPTABLES -A out_inet0	-p ah 	-j ACCEPT
$IPTABLES -A out_inet0	-p esp 	-j ACCEPT
$IPTABLES -A out_inet0	-p TCP 	-j out_inet0_tcp
$IPTABLES -A out_inet0	-p UDP	-j out_inet0_udp
$IPTABLES -A out_inet0	-p ICMP	-j out_inet0_icmp
$IPTABLES -A out_inet0	-p ALL	-j out_inet0_log
