#!/bin/sh
set -x

#TCL=wireless_01.tcl
TCL=wireless_antho.tcl
NN=50
T=900
X=1500
Y=300
MC=$1
PAUSE=$2
if [ $MC -gt 35 ]; then
RATE=0.33
else
RATE=0.25
fi

PROTO=DSR
NS_HOME=~/src/ns-allinone-2.29/ns-2.29 NTR_HOME=~/projets/adhoc TCL_FILE=$TCL ./scenarii_creator.sh $NN $T $X $Y $MC $RATE $PROTO $PAUSE

PROTO=AODV
NS_HOME=~/src/ns-allinone-2.29/ns-2.29 NTR_HOME=~/projets/adhoc TCL_FILE=$TCL ./scenarii_creator.sh $NN $T $X $Y $MC $RATE $PROTO $PAUSE
