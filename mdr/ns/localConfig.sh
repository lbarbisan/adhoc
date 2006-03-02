#!/bin/sh
NS_HOME=~/src/ns-allinone-2.29/ns-2.29
NTR_HOME=~/projets/adhoc
#echo "export NS_HOME=$NS_HOME"
#echo "export NTR_HOME=$NTR_HOME"
TESTS="average_packets_delay droppacket routing_packets_ratios"
MCS="10 20 30 40"
PROTOS="AODV DSR"
PAUSE_TIMES="0 33 66 125 300 600 900"
TCL_FILE=wireless_antho.tcl
