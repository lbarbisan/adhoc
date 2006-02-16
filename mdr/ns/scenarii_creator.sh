#!/bin/sh
set -x

# Mettre en variable globales NS_HOME et NTR_HOME
#NS_HOME=~/src/ns-allinone-2.29/ns-2.29
#NTR_HOME=~/projets/adhoc

if [ $# != 7 ]
then
echo "$0 <nn> <t> <x> <y> <mc> <rate> <proto>"
exit
fi

NN=$1
T=$2
X=$3
Y=$4
MC=$5
RATE=$6
PROTO=$7

SCENE_FILE=$NTR_HOME/mdr/ns/mobility/scene/scen-n$NN-p0-M20-t$T-${X}x${Y}.tcl
CBR_FILE=$NTR_HOME/mdr/ns/mobility/scene/cbr-n$(($NN - 1))-s1-m$MC-r$RATE.tcl
#CBR_FILE=$NTR_HOME/mdr/ns/mobility/scene/cbr-n$NN-s1-m$MC-r$RATE.tcl

if [ ! -r $SCENE_FILE ]
then
$NS_HOME/indep-utils/cmu-scen-gen/setdest/setdest -v 1 -n $NN -p 0 -M 20 -t $T -x $X -y $Y > $SCENE_FILE
fi

if [ ! -r $CBR_FILE ]
then
ns $NS_HOME/indep-utils/cmu-scen-gen/cbrgen.tcl -type cbr -nn $(($NN - 1)) -seed 1 -mc $MC -rate $RATE > $CBR_FILE
#ns $NS_HOME/indep-utils/cmu-scen-gen/cbrgen.tcl -type cbr -nn $NN -seed 1 -mc $MC -rate $RATE > $CBR_FILE
fi

$NTR_HOME/mdr/ns/wireless_last.tcl -x $X -y $Y -cp $CBR_FILE -sc $SCENE_FILE -nn $NN -stop $T -adhocRouting $PROTO


