#!/bin/sh
sudo iwconfig eth1 essid "ad-hoc-test" key off mode ad-hoc nick "anthony"
sudo ifconfig eth1 192.168.2.3 up
