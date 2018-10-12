echo "----inet0_fw_lan1"
#
#
###############################################################################################################################
#
## inet0_fw_lan1_TCP
#
$IPTABLES -N inet0_fw_lan1_tcp

#$IPTABLES -A inet0_fw_lan1_tcp -p tcp -m tcp ! -s 213.108.33.100 --dport 3389  -m state --state NEW -m recent --name rdpcheck --set
#$IPTABLES -A inet0_fw_lan1_tcp -p tcp -m tcp ! -s 213.108.33.100 --dport 3389  -m state --state NEW -m recent --name rdpcheck --update --seconds 60 --hitcount 5 -j LOG --log-level DEBUG --log-prefix "IPT I0FWL1 CONLIM RDP:  "
#$IPTABLES -A inet0_fw_lan1_tcp -p tcp -m tcp ! -s 213.108.33.100 --dport 3389  -m state --state NEW -m recent --name rdpcheck --update --seconds 60 --hitcount 5 -j DROP

$IPTABLES -A inet0_fw_lan1_tcp -p tcp			-m multiport	--dports 135,139,445		-j DROP

#
#
#
###############################################################################################################################
#
## inet0_fw_lan1_UDP
#
$IPTABLES -N inet0_fw_lan1_udp

$IPTABLES -A inet0_fw_lan1_udp -p udp			-m multiport	--dports 135,137,138	-j DROP

#
#
#
###############################################################################################################################
#
## inet0_fw_lan1_ICMP
#
$IPTABLES -N inet0_fw_lan1_icmp

#
#
###############################################################################################################################
#
## inet0_fw_lan1_LOG
#
$IPTABLES -N inet0_fw_lan1_log
$IPTABLES -A inet0_fw_lan1_log -p TCP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT I0FWL1 TCP:  "
$IPTABLES -A inet0_fw_lan1_log -p UDP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT I0FWL1 UDP:  "
$IPTABLES -A inet0_fw_lan1_log -p ICMP	-m limit --limit 3/minute --limit-burst 3	-j LOG --log-level DEBUG --log-prefix "IPT I0FWL1 ICMP: "
$IPTABLES -A inet0_fw_lan1_log								-j DROP

#
#
###############################################################################################################################
#
## inet0_fw_lan1
#
$IPTABLES -N inet0_fw_lan1

$IPTABLES -A inet0_fw_lan1	-p TCP		-j inet0_fw_lan1_tcp
$IPTABLES -A inet0_fw_lan1	-p UDP		-j inet0_fw_lan1_udp
$IPTABLES -A inet0_fw_lan1	-p ICMP		-j inet0_fw_lan1_icmp
$IPTABLES -A inet0_fw_lan1	-p ALL		-j inet0_fw_lan1_log

#
#
###############################################################################################################################

