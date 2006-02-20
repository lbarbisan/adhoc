#!/usr/bin/awk -f

BEGIN{
dropPacket = 0
sendPacket = 0
receivePacket = 0
forwardPacket = 0
}

{
	if($7=="cbr" || ($2=="-t" && $35=="cbr"))	#OldVersion  or #NewTrace
	
	{    
		if($1 == "d"){dropPacket++;}	
		else if($1 == "r"){sendPacket++;}
		else if($1 == "s"){receivePacket++;}
		else if($1 == "f"){forwardPacket++;}
	}
}

END{  
	ratio =  receivePacket/(sendPacket + forwardPacket) * 100 	
	print "Drop packets : " dropPacket > "/dev/stderr" ;
	print "Send packets : " sendPacket > "/dev/stderr" ; 
	print "Receive packets : " receivePacket > "/dev/stderr"  ;  
	print "Forward packets : " forwardPacket > "/dev/stderr" ;
	print "Ratio : " ratio > "/dev/stderr" ;
	print ratio
}

