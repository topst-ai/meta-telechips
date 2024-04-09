#!/bin/bash

PID=$(/bin/pidof TCMicomManager)

case $1 in
	hibernate|suspend)
		echo "micom-man PID = $PID"
		#echo `cat /proc/$PID/wchan`
	
		if [ -z $PID ]; then
			echo "Not find TCMicomManager"
			exit $NA
		else
			echo "suspend TCMicomManager"

			kill -20 $PID

			WAIT_LOOP=0
			status=`ps h -eo s q $PID`

			echo "$PID is $status"

			while [ $status != "T" ] ; do
				sleep 0.1
				WAIT_LOOP=$((WAIT_LOOP+1))
				if [ $WAIT_LOOP -eq 5 ]; then
					break
				fi
				status=`ps h -eo s q $PID`
				echo "wait $WAIT_LOOP, $status"
			done

			if [ "$status" == "T" ] ; then
				echo "$PID sleeps: $status"
			else
				echo "$PID does not sleep: $status"
			fi

		fi
		;;
	thaw|resume)
		#echo `cat /proc/$PID/wchan`
		echo "resume TCMicomManager..."
		kill -18 $PID
		;;

	*)  exit $NA
		;;
esac
