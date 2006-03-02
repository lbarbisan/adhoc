#!/bin/sh
set -x
source ./localConfig.sh
rm -rf $NTR_HOME/mdr/ns/results/*.plot
for MC in $MCS ; do for P in $PAUSE_TIMES ; do ./launch_scenario.sh $MC $P ; done ; done
