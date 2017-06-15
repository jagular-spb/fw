echo "----lan1_fw_tun0"
#
#
###############################################################################################################################
#
## lan1_fw_tun0_TCP
#
$IPTABLES -N lan1_fw_tun0_tcp

$IPTABLES -A lan1_fw_tun0_tcp -p tcp			-m multiport	--dports 135,139,445	-j DROP
#
#
#
###############################################################################################################################
#
## lan1_fw_tun0_UDP
#
$IPTABLES -N lan1_fw_tun0_udp

$IPTABLES -A lan1_fw_tun0_udp -p udp			-m multiport	--dports 135,137,138	-j DROP
#
#
#
###############################################################################################################################
#
## lan1_fw_tun0_ICMP
#
$IPTABLES -N lan1_fw_tun0_icmp

$IPTABLES -A lan1_fw_tun0_icmp             		-p icmp -m icmp --icmp-type 0		-j allowed
$IPTABLES -A lan1_fw_tun0_icmp -s $LAN1NET		-p icmp -m icmp --icmp-type 3		-j allowed
$IPTABLES -A lan1_fw_tun0_icmp -s $LAN1NET		-p icmp -m icmp --icmp-type 8 		-j allowed
$IPTABLES -A lan1_fw_tun0_icmp             		-p icmp -m icmp --icmp-type 11		-j allowed
#
#
###############################################################################################################################
#
## lan1_fw_tun0_LOG
#
$IPTABLES -N lan1_fw_tun0_log
$IPTABLES -A lan1_fw_tun0_log -p TCP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT L1FWT0 TCP:  "
$IPTABLES -A lan1_fw_tun0_log -p UDP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT L1FWT0 UDP:  "
$IPTABLES -A lan1_fw_tun0_log -p ICMP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT L1FWT0 ICMP: "
$IPTABLES -A lan1_fw_tun0_log								-j DROP
#
#
###############################################################################################################################
#
## lan1_fw_tun0
#
$IPTABLES -N lan1_fw_tun0

$IPTABLES -A lan1_fw_tun0	-p ALL 	-j mac_control
$IPTABLES -A lan1_fw_tun0	-p TCP 	-j lan1_fw_tun0_tcp
$IPTABLES -A lan1_fw_tun0	-p UDP	-j lan1_fw_tun0_udp
$IPTABLES -A lan1_fw_tun0	-p ICMP	-j lan1_fw_tun0_icmp
$IPTABLES -A lan1_fw_tun0	-p ALL	-j lan1_fw_tun0_log
#
#
###############################################################################################################################
