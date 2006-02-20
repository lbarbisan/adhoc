#!/usr/local/bin/ns
# Copyright (c) 1997 Regents of the University of California.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. All advertising materials mentioning features or use of this software
#    must display the following acknowledgement:
#      This product includes software developed by the Computer Systems
#      Engineering Group at Lawrence Berkeley Laboratory.
# 4. Neither the name of the University nor of the Laboratory may be used
#    to endorse or promote products derived from this software without
#    specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# simple-wireless.tcl
# A simple example for wireless simulation

# ======================================================================
# Define options
# ======================================================================
set opt(chan)           Channel/WirelessChannel		;# channel type
set opt(prop)           Propagation/TwoRayGround	;# radio-propagation model
set opt(netif)          Phy/WirelessPhy			;# network interface type
set opt(mac)            Mac/802_11			;# MAC type
set opt(ifq)            Queue/DropTail/PriQueue		;# interface queue type
set opt(ll)             LL				;# link layer type
set opt(ant)            Antenna/OmniAntenna		;# antenna model
set opt(ifqlen)         64				;# max packet in ifq
set opt(nn)             2				;# number of mobilenodes
set opt(adhocRouting)	DSDV				;# routing protocol

set opt(x)		500				;# with of the flatgrid
set opt(y)		500				;# height of the flatgrid
set opt(seed)		0.0
set opt(tr)		"simple-wireless.tr"		;# trace file
set opt(nam)		"simple-wireless.nam"		;# nam trace file
set opt(lm)		"off"				;# log movement
set opt(stop)		900				;# simulation time in ms

# ======================================================================
# Functions
# ======================================================================
proc create-god { nodes } {
	global ns_ god_ tracefd

	set god_ [new God]
	$god_ num_nodes $nodes
}

proc log-movement {} {
    global logtimer ns_ ns

    set ns $ns_
    source ./mobility/timer.tcl
    Class LogTimer -superclass Timer
    LogTimer instproc timeout {} {
	global opt node_;
	for {set i 0} {$i < $opt(nn)} {incr i} {
	    $node_($i) log-movement
	}
	$self sched 0.1
    }

    set logtimer [new LogTimer]
    $logtimer sched 0.1
}


# ======================================================================
# Main Program
# ======================================================================

# getopt
for {set i 0} {$i < $argc} {incr i} {
	set arg [lindex $argv $i]
	if {[string range $arg 0 0] != "-"} continue

	set name [string range $arg 1 end]
	set opt($name) [lindex $argv [expr $i+1]]
}

# ============================================================================
# check for boundary parameters and random seed
if { $opt(x) == 0 || $opt(y) == 0 } {
	puts "No X-Y boundary values given for wireless topology\n"
}
if {$opt(seed) > 0} {
	puts "Seeding Random number generator with $opt(seed)\n"
	ns-random $opt(seed)
}



#
# Initialize Global Variables
#
set ns_		[new Simulator]
#$ns_ use-newtrace
set tracefd     [open $opt(tr) w]
$ns_ trace-all $tracefd
set namtrace [open $opt(nam) w]
$ns_ namtrace-all-wireless $namtrace $opt(x) $opt(y)

# set up topography object
set topo       [new Topography]

$topo load_flatgrid $opt(x) $opt(y)

#
# Create God
#
create-god $opt(nn)

#
# log the mobile nodes movements if desired
#
if { $opt(lm) == "on" } {
    log-movement
}

#
#  Create the specified number of mobilenodes [$opt(nn)] and "attach" them
#  to the channel. 
#  Here two nodes are created : node(0) and node(1)

# configure node

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
			 
	for {set i 0} {$i < $opt(nn) } {incr i} {
		set node_($i) [$ns_ node]	
		$node_($i) random-motion 0		;# disable random motion
    $ns_ initial_node_pos $node_($i)  $i*10
	}


	puts "Loading connection pattern '$opt(cp)'..."
	source $opt(cp)
	
	puts "Loading scenario file '$opt(sc)'..."
	source $opt(sc)
	puts "Load complete..."



#
# Provide initial (X,Y, for now Z=0) co-ordinates for mobilenodes
#
#$node_(0) set X_ 5.0
#$node_(0) set Y_ 2.0
#$node_(0) set Z_ 0.0

#$node_(1) set X_ 390.0
#$node_(1) set Y_ 385.0
#$node_(1) set Z_ 0.0

#
# Now produce some simple node movements
# Node_(1) starts to move towards node_(0)
#
#$ns_ at 50.0 "$node_(1) setdest 25.0 20.0 15.0"
#$ns_ at 10.0 "$node_(0) setdest 20.0 18.0 1.0"

# Node_(1) then starts to move away from node_(0)
#$ns_ at 100.0 "$node_(1) setdest 490.0 480.0 15.0" 

# Setup traffic flow between nodes
# TCP connections between node_(0) and node_(1)

#set tcp [new Agent/TCP]
#$tcp set class_ 2
#set sink [new Agent/TCPSink]
#$ns_ attach-agent $node_(0) $tcp
#$ns_ attach-agent $node_(1) $sink
#$ns_ connect $tcp $sink
#set ftp [new Application/FTP]
#$ftp attach-agent $tcp
#$ns_ at 10.0 "$ftp start" 


#for {set i 0} {$i < $opt(stop) } {set i [expr $i + 50]} {
#    $ns_ at $i "puts $i";
for {set i 0} {$i < $opt(stop) } {incr i} {
    $ns_ at $i "puts -nonewline \"#\" ; flush stdout";
}

#
# Tell nodes when the simulation ends
#
for {set i 0} {$i < $opt(nn) } {incr i} {
    $ns_ at $opt(stop) "$node_($i) reset";
}
$ns_ at $opt(stop) "stop"
$ns_ at $opt(stop).01 "puts \"NS EXITING...\" ; $ns_ halt"
proc stop {} {
    global ns_ tracefd
    $ns_ flush-trace
    close $tracefd
}

puts "Starting Simulation..."
$ns_ run

