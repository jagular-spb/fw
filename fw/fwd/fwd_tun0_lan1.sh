echo "----tun0_fw_lan1"
#
#
###############################################################################################################################
#
## tun0_fw_lan1_TCP
#
$IPTABLES -N tun0_fw_lan1_tcp
$IPTABLES -A tun0_fw_lan1_tcp -p tcp	 -s $VPN1			-d $SRV1  -m multiport	--dports 3389	-j allowed #
$IPTABLES -A tun0_fw_lan1_tcp -p tcp	 -s $VPN2			-d $SRV1  -m multiport	--dports 3389	-j allowed #
$IPTABLES -A tun0_fw_lan1_tcp -p tcp	 -s $VPN2			-d 0/0  -m multiport	--dports 3389	-j allowed #
$IPTABLES -A tun0_fw_lan1_tcp -p tcp	 -s $VPN3			-d $SRV1  -m multiport	--dports 3389	-j allowed #
$IPTABLES -A tun0_fw_lan1_tcp -p tcp	 -s $VPN4			-d $SRV1  -m multiport	--dports 3389	-j allowed #
$IPTABLES -A tun0_fw_lan1_tcp -p tcp	 -s $VPN5			-d $SRV1  -m multiport	--dports 3389	-j allowed #
$IPTABLES -A tun0_fw_lan1_tcp -p tcp	 -s $VPN6			-d $SRV1  -m multiport	--dports 3389	-j allowed #
$IPTABLES -A tun0_fw_lan1_tcp -p tcp	 -s $VPN8			-d $SRV1  -m multiport	--dports 3389	-j allowed #

#
###############################################################################################################################
#
## tun0_fw_lan1_UDP
#
$IPTABLES -N tun0_fw_lan1_udp
#
#
#
###############################################################################################################################
#
## tun0_fw_lan1_ICMP
#

$IPTABLES -N tun0_fw_lan1_icmp

$IPTABLES -A tun0_fw_lan1_icmp		-p icmp -m icmp --icmp-type 0	-j allowed
$IPTABLES -A tun0_fw_lan1_icmp		-p icmp -m icmp --icmp-type 3	-j allowed
$IPTABLES -A tun0_fw_lan1_icmp		-p icmp -m icmp --icmp-type 8	-j allowed
$IPTABLES -A tun0_fw_lan1_icmp		-p icmp -m icmp --icmp-type 11	-j allowed
#
#
###############################################################################################################################
#
## tun0_fw_lan1_LOG
#
$IPTABLES -N tun0_fw_lan1_log

$IPTABLES -A tun0_fw_lan1_log -p TCP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT T0FWL1 TCP:  "
$IPTABLES -A tun0_fw_lan1_log -p UDP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT T0FWL1 UDP:  "
$IPTABLES -A tun0_fw_lan1_log -p ICMP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT T0FWL1 ICMP: "
$IPTABLES -A tun0_fw_lan1_log								-j DROP
#
#
###############################################################################################################################
#
## tun0_fw_lan1
#
$IPTABLES -N tun0_fw_lan1

$IPTABLES -A tun0_fw_lan1	-p TCP 	-j tun0_fw_lan1_tcp
$IPTABLES -A tun0_fw_lan1	-p UDP	-j tun0_fw_lan1_udp
$IPTABLES -A tun0_fw_lan1	-p ICMP	-j tun0_fw_lan1_icmp
$IPTABLES -A tun0_fw_lan1	-p ALL	-j tun0_fw_lan1_log
#
#
###############################################################################################################################
