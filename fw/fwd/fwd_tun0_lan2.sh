echo "----tun0_fw_lan2"
#
#
###############################################################################################################################
#
## tun0_fw_lan2_TCP
#
$IPTABLES -N tun0_fw_lan2_tcp
$IPTABLES -A tun0_fw_lan2_tcp -p tcp	 		-d $PAA  -m multiport	--dports 3389	-j allowed #
$IPTABLES -A tun0_fw_lan2_tcp -p tcp	 		-d $PAA  -m multiport	--dports 135	-j allowed #
#
###############################################################################################################################
#
## tun0_fw_lan2_UDP
#
$IPTABLES -N tun0_fw_lan2_udp
#
#
#
###############################################################################################################################
#
## tun0_fw_lan2_ICMP
#

$IPTABLES -N tun0_fw_lan2_icmp

$IPTABLES -A tun0_fw_lan2_icmp		-p icmp -m icmp --icmp-type 0	-j allowed
$IPTABLES -A tun0_fw_lan2_icmp		-p icmp -m icmp --icmp-type 3	-j allowed
$IPTABLES -A tun0_fw_lan2_icmp		-p icmp -m icmp --icmp-type 8	-j allowed
$IPTABLES -A tun0_fw_lan2_icmp		-p icmp -m icmp --icmp-type 11	-j allowed
#
#
###############################################################################################################################
#
## tun0_fw_lan2_LOG
#
$IPTABLES -N tun0_fw_lan2_log

$IPTABLES -A tun0_fw_lan2_log -p TCP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT T0FWL2 TCP:  "
$IPTABLES -A tun0_fw_lan2_log -p UDP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT T0FWL2 UDP:  "
$IPTABLES -A tun0_fw_lan2_log -p ICMP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT T0FWL2 ICMP: "
$IPTABLES -A tun0_fw_lan2_log								-j DROP
#
#
###############################################################################################################################
#
## tun0_fw_lan2
#
$IPTABLES -N tun0_fw_lan2

$IPTABLES -A tun0_fw_lan2	-p TCP 	-j tun0_fw_lan2_tcp
$IPTABLES -A tun0_fw_lan2	-p UDP	-j tun0_fw_lan2_udp
$IPTABLES -A tun0_fw_lan2	-p ICMP	-j tun0_fw_lan2_icmp
$IPTABLES -A tun0_fw_lan2	-p ALL	-j tun0_fw_lan2_log
#
#
###############################################################################################################################
