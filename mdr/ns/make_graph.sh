#!/bin/sh
set -x

source ./localConfig.sh
#TESTS="average_packets_delay droppacket routing_packets_ratios"
RESULT_FOLDER=${NTR_HOME}/mdr/ns/results
for NN in 50 100;
do
for TEST in $TESTS
do
for MC in $MCS;
do
PNG_FILE=${RESULT_FOLDER}/${TEST}_${MC}_${NN}.png
case $TEST in
	average_packets_delay) 
		if [ $NN -eq 50 ]
		then
			YLABEL="Delais d acheminement (s)"; YRANGE="0 : 0.5"	
		else
			YLABEL="Delais d acheminement (s)"; YRANGE="0 : 4"
		fi;;
	droppacket)		YLABEL="Pourcentage de paquets perdus (%)"; YRANGE="0 : 17";;
	routing_packets_ratios) YLABEL="Charge de routage (%)"; YRANGE="0 : 100";;
esac

echo "plot '${RESULT_FOLDER}/${TEST}_AODV_${NN}_${MC}.plot' using 1:2 with lines ti 'AODV, ${MC}/${NN} sources actives', '${RESULT_FOLDER}/${TEST}_DSR_${NN}_${MC}.plot' using 1:2 with lines ti 'DSR, ${MC}/${NN} sources actives'; set xlabel 'Temps de pause (s)'; set yrange [ $YRANGE ]; set ylabel '$YLABEL'; set term png; set output '$PNG_FILE'; set size 0.7, 0.7; replot" | gnuplot
done
done
done
eog ${RESULT_FOLDER}/*.png
