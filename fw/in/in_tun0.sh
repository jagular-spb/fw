echo "----in_tun0"
#
#
###############################################################################################################################
#
## in_tun0_TCP
#
$IPTABLES -N in_tun0_tcp
$IPTABLES -A in_tun0_tcp  -p tcp			-m multiport	--dports 135,137:139,445	-j DROP
#
#
###############################################################################################################################
#
## in_tun0_UDP
#
$IPTABLES -N in_tun0_udp
$IPTABLES -A in_tun0_udp -p udp			-m multiport	--dports 135,137:139,445	-j DROP
#
#
###############################################################################################################################
#
## in_tun0_ICMP
#

$IPTABLES -N in_tun0_icmp
$IPTABLES -A in_tun0_icmp	-p icmp -m icmp --icmp-type 0			-j allowed
$IPTABLES -A in_tun0_icmp	-p icmp -m icmp --icmp-type 3			-j allowed
$IPTABLES -A in_tun0_icmp	-p icmp -m icmp --icmp-type 8 			-j allowed
$IPTABLES -A in_tun0_icmp	-p icmp -m icmp --icmp-type 11			-j allowed
#
###############################################################################################################################
#
## in_tun0_LOG
#

$IPTABLES -N in_tun0_log
$IPTABLES -A in_tun0_log -p TCP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT INT0 TCP:  "
$IPTABLES -A in_tun0_log -p UDP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT INT0 UDP:  "
$IPTABLES -A in_tun0_log -p ICMP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT INT0 ICMP: "
$IPTABLES -A in_tun0_log								-j DROP
#
#
###############################################################################################################################
#
##in_tun0
#

$IPTABLES -N in_tun0
$IPTABLES -A in_tun0	-p TCP 		-j in_tun0_tcp
$IPTABLES -A in_tun0	-p UDP		-j in_tun0_udp
$IPTABLES -A in_tun0	-p ICMP		-j in_tun0_icmp
$IPTABLES -A in_tun0	-p ALL		-j in_tun0_log
