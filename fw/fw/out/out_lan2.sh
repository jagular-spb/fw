echo "----out_lan2"
#
#
###############################################################################################################################
#
## out_lan2_TCP
#
$IPTABLES -N out_lan2_tcp

$IPTABLES -A out_lan2_tcp -p tcp						--dport 135:139	-j DROP


#
#
###############################################################################################################################
#
## out_lan2_UDP
#
$IPTABLES -N out_lan2_udp

$IPTABLES -A out_lan2_udp -p udp						--dport 135:139	-j DROP

#
#
###############################################################################################################################
#
## out_lan2_ICMP
#
$IPTABLES -N out_lan2_icmp

$IPTABLES -A out_lan2_icmp		-p icmp -m icmp --icmp-type 0		-j allowed
$IPTABLES -A out_lan2_icmp -s $LAN2IP	-p icmp -m icmp --icmp-type 3		-j allowed
$IPTABLES -A out_lan2_icmp -s $LAN2IP	-p icmp -m icmp --icmp-type 8		-j allowed
$IPTABLES -A out_lan2_icmp		-p icmp -m icmp --icmp-type 11		-j allowed

###############################################################################################################################
#
## out_lan2_LOG
#
$IPTABLES -N out_lan2_log

$IPTABLES -A out_lan2_log -p TCP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT OUVL2 TCP:  "
$IPTABLES -A out_lan2_log -p UDP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT OUVL2 UDP:  "
$IPTABLES -A out_lan2_log -p ICMP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT OUVL2 ICMP: "
$IPTABLES -A out_lan2_log								-j DROP

#
#
###############################################################################################################################
#
##out_lan2
#
$IPTABLES -N out_lan2

$IPTABLES -A out_lan2	-p TCP	 	-j out_lan2_tcp
$IPTABLES -A out_lan2	-p UDP		-j out_lan2_udp
$IPTABLES -A out_lan2	-p ICMP		-j out_lan2_icmp
$IPTABLES -A out_lan2	-p ALL		-j out_lan2_log
