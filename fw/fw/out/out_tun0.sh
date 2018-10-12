echo "----out_tun0"
#
#
###############################################################################################################################
#
## out_tun0_TCP
#
$IPTABLES -N out_tun0_tcp

$IPTABLES -A out_tun0_tcp -p tcp						--dport 135:139	-j DROP
#$IPTABLES -A out_tun0_tcp -p tcp						--sport 53		-j allowed
#$IPTABLES -A out_tun0_tcp -p tcp				-m multiport	--dports 53,443		-j allowed
#
#
###############################################################################################################################
#
## out_tun0_UDP
#
$IPTABLES -N out_tun0_udp

$IPTABLES -A out_tun0_udp -p udp						--dport 135:139	-j DROP
#$IPTABLES -A out_tun0_udp -p udp						--dport 53		-j allowed # dns client
#$IPTABLES -A out_tun0_udp -p udp						--sport 53		-j allowed # dns server
#
#
###############################################################################################################################
#
## out_tun0_ICMP
#
$IPTABLES -N out_tun0_icmp

$IPTABLES -A out_tun0_icmp		-p icmp -m icmp --icmp-type 0		-j allowed
$IPTABLES -A out_tun0_icmp		-p icmp -m icmp --icmp-type 3		-j allowed
$IPTABLES -A out_tun0_icmp		-p icmp -m icmp --icmp-type 8		-j allowed
$IPTABLES -A out_tun0_icmp		-p icmp -m icmp --icmp-type 11		-j allowed

###############################################################################################################################
#
## out_tun0_LOG
#

$IPTABLES -N out_tun0_log

$IPTABLES -A out_tun0_log -p TCP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT OUT0 TCP:  "
$IPTABLES -A out_tun0_log -p UDP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT OUT0 UDP:  "
$IPTABLES -A out_tun0_log -p ICMP		-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT OUT0 ICMP: "
$IPTABLES -A out_tun0_log									-j DROP

#
#
###############################################################################################################################
#
##out_tun0
#
$IPTABLES -N out_tun0

$IPTABLES -A out_tun0	-p TCP	 	-j out_tun0_tcp
$IPTABLES -A out_tun0	-p UDP		-j out_tun0_udp
$IPTABLES -A out_tun0	-p ICMP		-j out_tun0_icmp
$IPTABLES -A out_tun0	-p ALL		-j out_tun0_log
