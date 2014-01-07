#!/bin/bash
#this is a minimalistic implementation of a daemon like bash process
#usage example: delete a file 5 minutes after the last use of a script
#all the code can be in the same file, as the "daemon_like_process" is executed
#and therefore has its own pid
#
#you can of course put the code in "renew_waiting" in the main shell (which
#should be a little less overhead) but here it is in its own function for
#clarity

daemon_like_process()
{
	echo $BASHPID > pidfile
	#do your magic
	sleep 10
	rm pidfile
	echo "\"daemon\" done waiting"
}

renew_waiting()
{
	kill `cat pidfile`
	rm pidfile
	daemon_like_process &
}

if [ -a pidfile ]
then
	echo "renewing \"daemon\""
	renew_waiting
else
	echo "starting \"daemon\""
	daemon_like_process &
fi
