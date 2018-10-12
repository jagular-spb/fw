echo "----out_lan1"
#
#
###############################################################################################################################
#
## out_lan1_TCP
#
$IPTABLES -N out_lan1_tcp

$IPTABLES -A out_lan1_tcp -p tcp						--dport 135:139	-j DROP


#
#
###############################################################################################################################
#
## out_lan1_UDP
#
$IPTABLES -N out_lan1_udp

$IPTABLES -A out_lan1_udp -p udp						--dport 135:139	-j DROP

#
#
###############################################################################################################################
#
## out_lan1_ICMP
#
$IPTABLES -N out_lan1_icmp

$IPTABLES -A out_lan1_icmp		-p icmp -m icmp --icmp-type 0		-j allowed
$IPTABLES -A out_lan1_icmp -s $LAN1IP	-p icmp -m icmp --icmp-type 3		-j allowed
$IPTABLES -A out_lan1_icmp -s $LAN1IP	-p icmp -m icmp --icmp-type 8		-j allowed
$IPTABLES -A out_lan1_icmp		-p icmp -m icmp --icmp-type 11		-j allowed

###############################################################################################################################
#
## out_lan1_LOG
#
$IPTABLES -N out_lan1_log

$IPTABLES -A out_lan1_log -p TCP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT OUVL1 TCP:  "
$IPTABLES -A out_lan1_log -p UDP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT OUVL1 UDP:  "
$IPTABLES -A out_lan1_log -p ICMP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT OUVL1 ICMP: "
$IPTABLES -A out_lan1_log								-j DROP

#
#
###############################################################################################################################
#
##out_lan1
#
$IPTABLES -N out_lan1

$IPTABLES -A out_lan1	-p TCP	 	-j out_lan1_tcp
$IPTABLES -A out_lan1	-p UDP		-j out_lan1_udp
$IPTABLES -A out_lan1	-p ICMP		-j out_lan1_icmp
$IPTABLES -A out_lan1	-p ALL		-j out_lan1_log
