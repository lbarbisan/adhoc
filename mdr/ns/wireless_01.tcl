#!/usr/local/bin/ns
#---------------------------------------------------------------------------
# Sample file for OLSR simulation
#---------------------------------------------------------------------------

#---------------------------------------------------------------------------
# Initialization
#---------------------------------------------------------------------------

# (possibly) Remove and create result directory
set dirName "./wireless_01_result"
exec sh -c "rm -rf $dirName && mkdir $dirName"

# Default node_ configuration
set nodeConfig ""


#---------------------------------------------------------------------------
# Create a simulation, with wireless support. This is basic (see ns2 doc)
#---------------------------------------------------------------------------
set ns_ [new Simulator]

set opt(chan) 	Channel/WirelessChannel
set opt(prop) 	Propagation/TwoRayGround
set opt(netif)	Phy/WirelessPhy
set opt(mac) 	Mac/802_11
set opt(ifq) 	Queue/DropTail/PriQueue
set opt(ll) 	LL
set opt(ant) 	Antenna/OmniAntenna
set opt(ifqlen) 25 ;#
set opt(nn)  	25  ;# nb mobiles
set opt(adhocRouting) 	DSR
set opt(x) 		[expr $opt(nn) *100.0 + 100.0]
set opt(y) 		1000
set opt(cp)		"./mobility/scene/cbr-3-test"
set opt(sc)		"./mobility/scene/scen-3-test"
set opt(stop) 	100

#---------------------------------------------------------------------------
# Network topography
#---------------------------------------------------------------------------
set topo [new Topography]
$topo load_flatgrid $opt(x) $opt(y)

#---------------------------------------------------------------------------
# Create GOD
#---------------------------------------------------------------------------
set god [create-god $opt(nn)]

#---------------------------------------------------------------------------
# Create trace
#---------------------------------------------------------------------------
$ns_ use-newtrace
set tracefd [open $dirName/unicast.tr w]
$ns_ trace-all $tracefd

set namtrace [open $dirName/unicast.nam w]
$ns_ namtrace-all-wireless $namtrace $opt(x) $opt(y)

#---------------------------------------------------------------------------
# Create node configuration
#---------------------------------------------------------------------------
$ns_ node-config -adhocRouting $opt(adhocRouting) \
    -llType $opt(ll) \
    -macType $opt(mac) \
    -ifqType $opt(ifq) \
    -ifqLen $opt(ifqlen) \
    -antType $opt(ant) \
    -propType $opt(prop) \
    -phyType $opt(netif) \
    -channel [new $opt(chan)] \
    -topoInstance $topo \
    -agentTrace ON \
    -routerTrace ON \
    -macTrace OFF \
    -movementTrace OFF

#---------------------------------------------------------------------------
# Create nodes
#--------------------------------------------------------------------------- 
for {set i 0} {$i < $opt(nn)} {incr i} {
    set node_($i) [$ns_ node]
    $node_($i) random-motion 0
    $ns_ initial_node_pos $node_($i) 
}

#---------------------------------------------------------------------------
# Commande line
#---------------------------------------------------------------------------
proc usage { argv0 }  {
	puts "Usage: $argv0"
	puts " opt(chan) 	Channel/WirelessChannel"
	puts " opt(prop) 	Propagation/TwoRayGround"
	puts " opt(netif)	Phy/WirelessPhy"
	puts " opt(mac) 	Mac/802_11"
	puts " opt(ifq) 	Queue/DropTail/PriQueue"
	puts " opt(ll) 		LL"
	puts " opt(ant) 	Antenna/OmniAntenna"
	puts " opt(ifqlen) 	25"
	puts " opt(nn)  	25"
	puts " opt(adhocRouting) 		DSR"
	puts " opt(x) 		1000"
	puts " opt(y) 		1000"
	puts " opt(cp)		./mobility/scene/cbr-3-test"
	puts " opt(sc)		./mobility/scene/scen-3-test"
	puts " opt(stop) 		100"
}


proc getopt {argc argv} {
	global opt
	lappend optlist cp nn seed sc stop tr x y

	if { $argc > 1 } {
		for {set i 0} {$i < $argc} {incr i} {
			set arg [lindex $argv $i]
			if {[string range $arg 0 0] != "-"} continue
	
			set name [string range $arg 1 end]
			set opt($name) [lindex $argv [expr $i+1]]
			}
	} else { 
		usage [lindex $argv 1]
		exit 1
	}
}

source $opt(cp)
source $opt(sc)

#---------------------------------------------------------------------------
# Finishing procedure
#---------------------------------------------------------------------------

proc finishSimulation { } {
    global ns_ node_ val dirName

    # Exit
    puts "Finished simulation."
    $ns_ halt
}

#---------------------------------------------------------------------------
# Run the simulation
#---------------------------------------------------------------------------

proc runSimulation {duration} {
    global ns_ finishSimulation
    for {set j 1.0} {$j < $duration} {set j [expr $j + 1]} {
	$ns_ at $j "puts t=$j"
    }
    $ns_ at $duration "finishSimulation"
    $ns_ run
}

getopt $argc $argv
runSimulation $opt(stop)

#---------------------------------------------------------------------------
