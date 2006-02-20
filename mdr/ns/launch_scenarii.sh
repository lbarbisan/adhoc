#!/bin/sh
set -x
for p in 0 33 66 125 300 600 900 ; do for mc in 10 20 30 40 ; do ./launch_scenario.sh $mc $p ; done ; done
