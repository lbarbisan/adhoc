#!/bin/sh
set -x

# Mettre en variable globales NS_HOME et NTR_HOME
#NS_HOME=~/src/ns-allinone-2.29/ns-2.29
#NTR_HOME=~/projets/adhoc

if [ $# != 8 ]
then
echo "$0 <nn> <t> <x> <y> <mc> <rate> <proto> <pause>"
exit
fi

NN=$1
T=$2
X=$3
Y=$4
MC=$5
RATE=$6
PROTO=$7
PAUSE=$8
# Vitesse max en m/s
MAX_SPEED=20
# Buffer d'envoi en nombre de paquets
IFQ_LEN=64

SCENE_FILE=$NTR_HOME/mdr/ns/mobility/scene/scen-n$NN-p$PAUSE-M${MAX_SPEED}-t$T-${X}x${Y}.tcl
CBR_FILE=$NTR_HOME/mdr/ns/mobility/scene/cbr-n$(($NN - 1))-s1-m$MC-r$RATE.tcl
#CBR_FILE=$NTR_HOME/mdr/ns/mobility/scene/cbr-n$NN-s1-m$MC-r$RATE.tcl
TR_FILE=results/scenario_${PROTO}_${NN}_${MC}_${PAUSE}.tr
NAM_FILE=results/scenario_${PROTO}_${NN}_${MC}_${PAUSE}.nam
DROP_PACKET_FILE=results/droppacket_${PROTO}_${NN}_${MC}.plot
ROUTING_PACKET_RATION_FILE=results/routing_ratio_${PROTO}_${NN}_${MC}.plot

if [ ! -r $SCENE_FILE ]
then
$NS_HOME/indep-utils/cmu-scen-gen/setdest/setdest -v 1 -n $NN -p $PAUSE -M 20 -t $T -x $X -y $Y > $SCENE_FILE
fi

if [ ! -r $CBR_FILE ]
then
ns $NS_HOME/indep-utils/cmu-scen-gen/cbrgen.tcl -type cbr -nn $(($NN - 1)) -seed 1 -mc $MC -rate $RATE > $CBR_FILE
#ns $NS_HOME/indep-utils/cmu-scen-gen/cbrgen.tcl -type cbr -nn $NN -seed 1 -mc $MC -rate $RATE > $CBR_FILE
fi

if [ ! -r $TR_FILE ]
then
#$NTR_HOME/mdr/ns/wireless_antho.tcl -x $X -y $Y -cp $CBR_FILE -sc $SCENE_FILE -nn $NN -stop $T -adhocRouting $PROTO
$NTR_HOME/mdr/ns/$TCL_FILE -x $X -y $Y -cp $CBR_FILE -sc $SCENE_FILE -nn $NN -stop $T -adhocRouting $PROTO -tr $TR_FILE -nam $NAM_FILE -ifqlen $IFQ_LEN
fi

if [ -r $TR_FILE ]
then
echo "$PAUSE `$NTR_HOME/mdr/ns/droppacket.sh $TR_FILE`" >> $DROP_PACKET_FILE
echo "$PAUSE `$NTR_HOME/mdr/ns/routing_packets_ratios.sh $TR_FILE`" >> $ROUTING_PACKET_RATION_FILE
rm $TR_FILE
fi

