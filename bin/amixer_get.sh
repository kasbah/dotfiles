#! /bin/bash
vol=$(amixer get Master | awk -f /home/kaspar/bin/parse_amixer.awk) 
state=$(amixer get Master | awk -f /home/kaspar/bin/parse_amixer_m.awk) 
if [ ${state} == "off" ]
then
		echo "<fc=gray> ${vol}M</fc>"
else
		if [ ${vol} -eq 0 ]
		then
				echo "<fc=grey>0</fc>"
		elif [ ${vol} -lt 31 ]
		then
				echo "<fc=green> ${vol} </fc>"
		elif [ ${vol} -gt 30 ] && [ ${vol} -lt 70 ]
		then
				echo "<fc=orange> ${vol} </fc>"
		elif [ ${vol} -gt 69 ]
		then
				echo "<fc=#FF0000> ${vol} </fc>"
		fi
fi
