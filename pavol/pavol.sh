#! /bin/bash

# todo:
# usage
# further parameters (smaller / greater in-/decrease)
# configurable default
# sink
# beautification / documentation

MaxVol=200
currentVol(){
	CurrentVol=`pacmd list-sinks | grep  "volume" |head -n1| cut -d:  -f 3 | cut -d% -f1 | cut -d\/ -f2 | tr -d " "`
}

currentVol;

up(){
	if [ $CurrentVol -le $MaxVol ]
	then
		pactl set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo -- +5%
	fi
}

down(){
	pactl set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo -- -5%
}

toggleMute(){
	Mute=`pactl list sinks | grep Mute | cut -d: -f2 | tr -d "[:space:]"`
	if [ $Mute = "no" ]
	then 
		pactl set-sink-mute alsa_output.pci-0000_00_1b.0.analog-stereo 1
    	else
		pactl set-sink-mute alsa_output.pci-0000_00_1b.0.analog-stereo 0
	fi
}
if [ $# -eq 0 ]
then
	echo "current volume: $CurrentVol"

elif [ $@ == up ]
then 
	up;


elif [ $@ == down ]
then
	down;

elif [ $@ == toggleMute ]
then
	toggleMute;


else
	echo "You're doing it wrong"

fi
