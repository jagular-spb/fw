#!/bin/sh
#
#
###############################################################################################################################
PATH="/sbin:/usr/local/bin:/usr/bin:/bin"
IPTABLES=`which iptables`
PWD='/root/fw/other/'
###############################################################################################################################
$IPTABLES -N blocked
$IPTABLES -F blocked

while read line
do
#    echo $line
    $IPTABLES -A blocked -p ALL -s $line -j DROP

done < $PWD/block
