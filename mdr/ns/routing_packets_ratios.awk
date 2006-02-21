#!/usr/bin/awk -f
BEGIN{
	dropPacket = 0
	sendPacket = 0
	receivePacket = 0
	forwardPacket = 0
	AODVPacket=0
	DSRPacket=0
}

{

	if($7=="cbr" || ($2=="-t" && $35=="cbr"))

	{    
		if($1 == "d"){dropPacket++;}	
		else if($1 == "r"){receivePacket++;}
		else if($1 == "s"){sendPacket++;}
		else if($1 == "f"){forwardPacket++;}
	}
	else if($7=="AODV" || ($2=="-t" && $35=="AODV"))	#OldTrace or #NewTrace
	{
		AODVPacket++
	}
	else if($7=="DSR" || ($2=="-t" && $35=="DSR"))		#OldTrace or #NewTrace
	{
		DSRPacket++
	}
}

END{  
	ratio = (DSRPacket + AODVPacket)/(receivePacket +forwardPacket + sendPacket+ DSRPacket + AODVPacket);
	print "Nombre de trame de routage : " (DSRPacket + AODVPacket) > "/dev/stderr";
	print "Nombre de trame de données : " (receivePacket +forwardPacket + sendPacket) > "/dev/stderr";
	print "Ratio :" ratio > "/dev/stderr";
	print ratio;
}
