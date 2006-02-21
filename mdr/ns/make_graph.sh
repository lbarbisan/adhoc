#!/bin/sh
set -x

`./localConfig.sh`

for TEST in droppacket;
do
for MC in 10 20 30 40;
do
PNG_FILE=${NTR_HOME}/mdr/ns/results/${TEST}_${MC}.png
PLOT_CMD=""
echo "plot '${NTR_HOME}/mdr/ns/results/${TEST}_AODV_50_${MC}.plot' using 1:2 with lines, '${NTR_HOME}/mdr/ns/results/${TEST}_DSR_50_${MC}.plot' using 1:2 with lines; set term png; set output '$PNG_FILE'; set size 0.7, 0.7; replot" | gnuplot
done
done
eog $PNG_FILE
