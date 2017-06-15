echo "----lan2_fw_inet0"
#
#
###############################################################################################################################
#
## lan2_fw_inet0_TCP
#
$IPTABLES -N lan2_fw_inet0_tcp

$IPTABLES -A lan2_fw_inet0_tcp -p tcp			-m multiport	--dports 135,139,445	-j DROP

$IPTABLES -A lan2_fw_inet0_tcp -p tcp			-m multiport	--dports 80,443	-j allowed
#
###############################################################################################################################
#
## lan2_fw_inet0_UDP
#
$IPTABLES -N lan2_fw_inet0_udp


$IPTABLES -A lan2_fw_inet0_udp -p udp			-m multiport	--dports 135,137,138	-j DROP
$IPTABLES -A lan2_fw_inet0_udp -p udp			-m multiport	--dports 123	-j allowed
#
#
#
###############################################################################################################################
#
## lan2_fw_inet0_ICMP
#
$IPTABLES -N lan2_fw_inet0_icmp

$IPTABLES -A lan2_fw_inet0_icmp             		-p icmp -m icmp --icmp-type 0		-j allowed
$IPTABLES -A lan2_fw_inet0_icmp -s $LAN2NET		-p icmp -m icmp --icmp-type 3		-j allowed
$IPTABLES -A lan2_fw_inet0_icmp -s $LAN2NET		-p icmp -m icmp --icmp-type 8 		-j allowed
$IPTABLES -A lan2_fw_inet0_icmp             		-p icmp -m icmp --icmp-type 11		-j allowed
#
#
###############################################################################################################################
#
## lan2_fw_inet0_LOG
#
$IPTABLES -N lan2_fw_inet0_log
$IPTABLES -A lan2_fw_inet0_log -p TCP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT L2FWI0 TCP:  "
$IPTABLES -A lan2_fw_inet0_log -p UDP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT L2FWI0 UDP:  "
$IPTABLES -A lan2_fw_inet0_log -p ICMP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT L2FWI0 ICMP: "
$IPTABLES -A lan2_fw_inet0_log								-j DROP

#
#
###############################################################################################################################
#
## lan2_fw_inet0
#
$IPTABLES -N lan2_fw_inet0
#$IPTABLES -A lan2_fw_inet0	-p ALL 	-j mac_control
$IPTABLES -A lan2_fw_inet0	-p TCP 	-j lan2_fw_inet0_tcp
$IPTABLES -A lan2_fw_inet0	-p UDP	-j lan2_fw_inet0_udp
$IPTABLES -A lan2_fw_inet0	-p ICMP	-j lan2_fw_inet0_icmp
$IPTABLES -A lan2_fw_inet0	-p ALL	-j lan2_fw_inet0_log
#
#
###############################################################################################################################
