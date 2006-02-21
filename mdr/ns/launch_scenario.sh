#!/bin/sh
set -x

NN=50
T=900
X=1500
Y=300
MC=$1
PAUSE=$2
RATE=2.0

if [ $MC -gt 35 ]; then
RATE=0.375
else
RATE=0.5
fi

#if [ $MC -gt 35 ]; then
#RATE=0.33
#else
#RATE=0.25
#fi


source ./localConfig.sh

for PROTO in AODV DSR;
do
#NS_HOME=~/src/ns-allinone-2.29/ns-2.29 NTR_HOME=~/projets/adhoc TCL_FILE=$TCL ./scenarii_creator.sh $NN $T $X $Y $MC $RATE $PROTO $PAUSE || echo "`date` $TCL n=$NN t=$T x=$X y=$Y mc=$MC rate=$RATE proto=$PROTO pause=$PAUSE : failed" >> scenarii.errors
#NS_HOME=$NS_HOME NTR_HOME=$NTR_HOME TCL_FILE=$TCL ./scenarii_creator.sh $NN $T $X $Y $MC $RATE $PROTO $PAUSE || echo "`date` $TCL n=$NN t=$T x=$X y=$Y mc=$MC rate=$RATE proto=$PROTO pause=$PAUSE : failed" >> scenarii.errors
./scenarii_creator.sh $NN $T $X $Y $MC $RATE $PROTO $PAUSE || echo "`date` $TCL n=$NN t=$T x=$X y=$Y mc=$MC rate=$RATE proto=$PROTO pause=$PAUSE : failed" >> scenarii.errors
done
 
