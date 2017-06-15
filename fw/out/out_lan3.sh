echo "----out_lan3"
#
#
###############################################################################################################################
#
## out_lan3_TCP
#
$IPTABLES -N out_lan3_tcp

$IPTABLES -A out_lan3_tcp -p tcp						--dport 135:139	-j DROP


#
#
###############################################################################################################################
#
## out_lan3_UDP
#
$IPTABLES -N out_lan3_udp

$IPTABLES -A out_lan3_udp -p udp						--dport 135:139	-j DROP

#
#
###############################################################################################################################
#
## out_lan3_ICMP
#
$IPTABLES -N out_lan3_icmp

$IPTABLES -A out_lan3_icmp		-p icmp -m icmp --icmp-type 0		-j allowed
$IPTABLES -A out_lan3_icmp -s $LAN3IP	-p icmp -m icmp --icmp-type 3		-j allowed
$IPTABLES -A out_lan3_icmp -s $LAN3IP	-p icmp -m icmp --icmp-type 8		-j allowed
$IPTABLES -A out_lan3_icmp		-p icmp -m icmp --icmp-type 11		-j allowed

###############################################################################################################################
#
## out_lan3_LOG
#
$IPTABLES -N out_lan3_log

$IPTABLES -A out_lan3_log -p TCP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT OUVL3 TCP:  "
$IPTABLES -A out_lan3_log -p UDP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT OUVL3 UDP:  "
$IPTABLES -A out_lan3_log -p ICMP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT OUVL3 ICMP: "
$IPTABLES -A out_lan3_log								-j DROP

#
#
###############################################################################################################################
#
##out_lan3
#
$IPTABLES -N out_lan3

$IPTABLES -A out_lan3	-p TCP	 	-j out_lan3_tcp
$IPTABLES -A out_lan3	-p UDP		-j out_lan3_udp
$IPTABLES -A out_lan3	-p ICMP		-j out_lan3_icmp
$IPTABLES -A out_lan3	-p ALL		-j out_lan3_log
