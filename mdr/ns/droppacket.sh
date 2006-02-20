#!/usr/bin/awk -f

BEGIN{
dropPacket = 0
sendPacket = 0
receivePacket = 0
forwardPacket = 0
}

{
	if($7=="cbr" || ($2=="-t" && $33=="cbr"))	#OldVersion  or #NewTrace
	
	{    
		if($1 == "d"){dropPacket++;}	
		else if($1 == "r"){sendPacket++;}
		else if($1 == "s"){receivePacket++;}
		else if($1 == "f"){forwardPacket++;}
	}
}

END{  
	print "Drop packets : " dropPacket ;
	print "Send packets : " sendPacket ; 
	print "Receive packet : " receivePacket ;  
	print "Forward packet : " forwardPacket ;
	print "Ratio :" receivePacket/(sendPacket + forwardPacket) * 100;
}

