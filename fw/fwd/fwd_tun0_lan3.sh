echo "----tun0_fw_lan3"
#
#
###############################################################################################################################
#
## tun0_fw_lan3_TCP
#
$IPTABLES -N tun0_fw_lan3_tcp
#$IPTABLES -A tun0_fw_lan3_tcp -p tcp	 -s $VPN2 		 		-m multiport	--dports 3389	-j allowed #

$IPTABLES -A tun0_fw_lan3_tcp -p tcp	! -s $VPN7		-d 10.10.16.19  				-j allowed #
$IPTABLES -A tun0_fw_lan3_tcp -p tcp	! -s $VPN7		-d 10.10.16.21  				-j allowed #

$IPTABLES -A tun0_fw_lan3_tcp -p tcp	-s $VPN7 		-d 10.10.16.27  -m multiport	--dports 3389	-j allowed #
#
###############################################################################################################################
#
## tun0_fw_lan3_UDP
#
$IPTABLES -N tun0_fw_lan3_udp
#
#
#
###############################################################################################################################
#
## tun0_fw_lan3_ICMP
#

$IPTABLES -N tun0_fw_lan3_icmp

$IPTABLES -A tun0_fw_lan3_icmp		-p icmp -m icmp --icmp-type 0	-j allowed
$IPTABLES -A tun0_fw_lan3_icmp		-p icmp -m icmp --icmp-type 3	-j allowed
$IPTABLES -A tun0_fw_lan3_icmp		-p icmp -m icmp --icmp-type 8	-j allowed
$IPTABLES -A tun0_fw_lan3_icmp		-p icmp -m icmp --icmp-type 11	-j allowed
#
#
###############################################################################################################################
#
## tun0_fw_lan3_LOG
#
$IPTABLES -N tun0_fw_lan3_log

$IPTABLES -A tun0_fw_lan3_log -p TCP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT T0FWL3 TCP:  "
$IPTABLES -A tun0_fw_lan3_log -p UDP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT T0FWL3 UDP:  "
$IPTABLES -A tun0_fw_lan3_log -p ICMP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT T0FWL3 ICMP: "
$IPTABLES -A tun0_fw_lan3_log								-j DROP
#
#
###############################################################################################################################
#
## tun0_fw_lan3
#
$IPTABLES -N tun0_fw_lan3

$IPTABLES -A tun0_fw_lan3	-p TCP 	-j tun0_fw_lan3_tcp
$IPTABLES -A tun0_fw_lan3	-p UDP	-j tun0_fw_lan3_udp
$IPTABLES -A tun0_fw_lan3	-p ICMP	-j tun0_fw_lan3_icmp
$IPTABLES -A tun0_fw_lan3	-p ALL	-j tun0_fw_lan3_log
#
#
###############################################################################################################################
