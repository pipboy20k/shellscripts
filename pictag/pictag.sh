#!/bin/bash
# usage pictag "tag1 tag2 ...." pic1 pic2 ...
# best used with picimport.sh
# thx to Elena "of Valhalla" for the idea

### only use this script in $HOME/photos 
dir="$(pwd | cut -d / -f 5)"

### right now i have no more beautiful idea than "while true" :(
while true; do
	case ${dir} in
		photos ) break;;
		* ) echo "please use this script in your photos folder and subfolders only"; exit;;
	esac
done

###logging
logfile=~/.pictag.log
log(){
	message="$(date +"%c") $@"
	echo ${message} >>${logfile}
}
#### nicetohave: check for stringdistance to already existing folders and ask to correct the tags
tags=$1
shift
pics=$@

for pic in ${pics}
do
	echo "the following tags will be assinged to picture : ${pic}"
	for tag in ${tags}
	do
		echo ${tag}
	done
done

while true;
do
	read -p "create these tags (symbolic links)? [y/n] " input
	case ${input} in
		[Yy]* ) echo "creating tags"; break;;
		[Nn]* ) echo "aborting"; exit;;
		* ) echo "please choose either y or n! "
	esac
done

for tag in $tags
do
	tagpath=${HOME}/media/photos/tags/${tag}/
	mkdir -p ${tagpath}

	for pic in $pics
	do
		year="$(exif ${pic} | grep Datum -m 1 | cut -d ":" -f 1 | cut -d "|" -f 2)"
		month="$(exif ${pic} | grep Datum -m 1 | cut -d ":" -f 2 | cut -d "|" -f 2)"
		day="$(exif ${pic} | grep Datum -m 1 | cut -d ":" -f 3 | cut -d " " -f 1)"
#		needed in an older version
#		hour="$(exif ${pic} | grep Datum -m 1 | cut -d ":" -f 3 | cut -d " " -f 2)"
#		minute="$(exif ${pic} | grep Datum -m 1 | cut -d ":" -f 4)"
#		second="$(exif ${pic} | grep Datum -m 1 | cut -d ":" -f 5)"

		photographer=$(readlink -f $1 | awk -F"photos" '{print $2}' | cut -d / -f 2)

		symlink=${year}${month}${day}_${photographer}_${pic}

		ln -s `pwd`/$pic ${tagpath}${symlink}
		log ln -s $pic ${tagpath}${symlink}
	done
done
