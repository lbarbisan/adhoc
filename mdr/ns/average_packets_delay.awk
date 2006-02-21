#!/usr/bin/awk -f
	BEGIN {
		action = 0
		time = 0
		node = 0
		node_dest = 0
		node_src = 0
		packet_type = 0
		packet_id = 0
		highest_packet_id = 0	
		nbr_packet = 0
	}
			
	{
		if($2!="-t") #select value for version
		{
			action = $1
			time = $2
			node = $3
			node_dest = $15
			node_src = $14
			packet_type = $7
			packet_id = $6
			sub(/\:([0-9]*)/,"", node_dest);sub(/\[/,"", node_dest)
			sub(/\:([0-9]*)/,"", node_src);sub(/\[/,"", node_src)
			gsub(/_/, "",  node);
		}
		else
		{
			action = $1
			time = $3
			node = $9
			node_dest = $33
			node_src = $31
			packet_type = $35
			packet_id = $41
			sub(/\.([0-9]*)/,"", node_dest);sub(/\[/,"", node_dest)
			sub(/\.([0-9]*)/,"", node_src);sub(/\[/,"", node_src)
		}
	
		if(packet_type=="cbr")
		{
			if(action=="s")
			{
				if (!(packet_id in start_time))
				{
					start_time[packet_id] = time;
					packet_dest[packet_id] = node_dest;
					packet_src[packet_id] = node_src
				}
			}
			else if(action=="r")
			{
					if(packet_dest[packet_id]==node) end_time[packet_id] = time;
					if(packet_id>highest_packet_id) highest_packet_id=packet_id;
			}	
		}
	}
		
	END {
		for ( packet_id = 0; packet_id <= highest_packet_id; packet_id++ )
		{
			if((packet_id in start_time) && (packet_id in end_time))
			{
				nbr_packet++;
				start = start_time[packet_id];
				end = end_time[packet_id];
				packet_duration = end - start;
				if ( start < end ) sum= packet_duration+sum;
				print "[" ARGV[0] ":average]packet " packet_id " [" end_time[packet_id] "-" start_time[packet_id] "] src:" packet_src[packet_id] " dst:" packet_dest[packet_id] > "/dev/stderr"
			}
		}
		delay = sum/nbr_packet;
		print delay; 
	}
