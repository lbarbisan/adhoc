#!/bin/sh
#TCL=wireless_01.tcl
TCL=wireless_antho.tcl
PROTO=$1
NN=$2
T=10000
X=200
Y=200
RATE=0.0005
NS_HOME=~/src/ns-allinone-2.29/ns-2.29 NTR_HOME=~/projets/adhoc TCL_FILE=$TCL ./scenarii_creator.sh $NN $T $X $Y 10 $RATE $PROTO

