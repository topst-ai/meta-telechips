#! /bin/sh
### BEGIN INIT INFO
# Provides:             PowerVR Dump Application
# Required-Start:
# Required-Stop:
# Default-Start:        1
# Default-Stop:         0
# Short-Description:    PowerVR Dump Application
# Description:          PowerVR Dump Application
### END INIT INFO

# Source function library.

DAEMON=/usr/bin/pvr_util
DESC="PowerVR Dump application"
ARGUMENTS=""

test -x $DAEMON || exit 0

case "$1" in
  start)
  	echo -n "Starting $DESC: " > /dev/kmsg
	$DAEMON $ARGUMENTS &
  	echo "done." > /dev/kmsg
	;;
  stop)
  	echo -n "Stopping $DESC: "
	killall pvr_util
  	echo "done."
	;;
  *)
	echo "Usage: /etc/init.d/pvr-util {start|stop}"
	exit 1
esac

exit 0
