#!/bin/bash 
#	put script in ~/bin/
#	usage: go to the folder containing the pics to be imported and run picimport.sh <photographer>
#	uses install to copy pictures to ~/photos in a by time sorted manner
#	logs in ~/.picimport.log
#	thx to Elena "of Valhalla" for the idea!

###logging
logfile=~/.picimport.log
log(){
	message="$(date +"%c")$@" ##$(date +"%c") returns the locale date and $@ are "all" passed arguments (passed to log)
	echo ${message} >> ${logfile}
}

###photographer / owner of camera
if [ -n "$1" ]; then
	PHOTOGRAPHER="$1"
else
	echo "You must specify a Photographer!"
	exit
fi

###checking exif data
ls -1 *.jpg *.JPG | while read f; do
	if [ -f "${f}" ]; then
#	timedata from exif (for a german exif output, for english probably :%s/Datum/Date/ ) : 
		year="$(exif ${f} | grep Datum -m 1 | cut -d ":" -f 1 | cut -d "|" -f 2)"
		month="$(exif ${f} | grep Datum -m 1 | cut -d ":" -f 2 | cut -d "|" -f 2)"
		day="$(exif $f | grep Datum -m 1 | cut -d ":" -f 3 | cut -d " " -f 1)"
		hour="$(exif $f | grep Datum -m 1 | cut -d ":" -f 3 | cut -d " " -f 2)"
		minute="$(exif $f | grep Datum -m 1 | cut -d ":" -f 4)"
		second="$(exif $f | grep Datum -m 1 | cut -d ":" -f 5)"

	echo "year=${year}, month=${month}, day=${day}; hour=${hour}, minute=${minute}, second=${second}"
   fi
done


targetPhotographer="${HOME}/media/photos/${PHOTOGRAPHER}/"


while true; do
	read -p "is the read exif data ok? [y/n] " input
	case ${input} in
		[Yy]* ) echo "importing the pictures to ${targetPhotographer}" ; break;;
		[Nn]* ) echo "aborting" ; exit;;
		* ) echo "please answer y or n! "
	esac
done


###installing (copying) to $target
ls -1 *.jpg *.JPG | while read f; do
	if [ -f "${f}" ]; then

		year="$(exif ${f} | grep Datum -m 1 | cut -d ":" -f 1 | cut -d "|" -f 2)"
		month="$(exif ${f} | grep Datum -m 1 | cut -d ":" -f 2 | cut -d "|" -f 2)"
		day="$(exif $f | grep Datum -m 1 | cut -d ":" -f 3 | cut -d " " -f 1)"
		hour="$(exif $f | grep Datum -m 1 | cut -d ":" -f 3 | cut -d " " -f 2)"
		minute="$(exif $f | grep Datum -m 1 | cut -d ":" -f 4)"
		second="$(exif $f | grep Datum -m 1 | cut -d ":" -f 5)"


	target="${HOME}/media/photos/${PHOTOGRAPHER}/${year}/${month}${day}"
      
	install -D -m 644 "${f}" "${target}/${f}"
	###logging the changes
	log install -D -m 644 "${f}" "${target}/${f}"

	fi
done

