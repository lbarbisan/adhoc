#!/bin/sh
#TCL=wireless_01.tcl
TCL=wireless_antho.tcl
PROTO=$1
NN=$2
NS_HOME=~/src/ns-allinone-2.29/ns-2.29 NTR_HOME=~/projets/adhoc TCL_FILE=$TCL ./scenarii_creator.sh $NN 900 800 600 10 0.0005 $PROTO

