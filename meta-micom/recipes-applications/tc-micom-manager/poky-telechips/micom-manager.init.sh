#! /bin/sh
### BEGIN INIT INFO
# Provides:             Telechips Micom Manager
# Required-Start:    
# Required-Stop:     
# Default-Start:        2 5
# Default-Stop:         0
# Short-Description:    Telechips Micom Manager
# Description:          MicomManager is a simple micom manager with als-lib for Telechips Micom Manager
### END INIT INFO
#
# -*- coding: utf-8 -*-
# Debian init.d script for Telechips Launcher
# Copyright © 2014 Wily Taekhyun Shin <thshin@telechips.com>

# Source function library.
. /etc/init.d/functions

# /etc/init.d/micom-manager: start and stop the micom-manager daemon

DAEMON=/usr/bin/TCMicomManager
DESC="telechips micom manager"
ARGUMENTS="-d 1 -D /dev/tcc_ipc_micom -A /dev/tcc_ipc_ap"

test -x $DAEMON || exit 0

[ -z "$SYSCONFDIR" ] && SYSCONFDIR=/var/lib/micom-manager
mkdir -p $SYSCONFDIR

case "$1" in
  start)
  	echo -n "Starting $DESC: "
	$DAEMON $ARGUMENTS &
  	echo "done."
	;;
  stop)
  	echo -n "Stopping $DESC: "
	/usr/bin/killall -9 TCMicomManager
  	echo "done."
	;;

  restart)
  	echo -n "Restarting $DESC: "
	/usr/bin/killall -9 TCMicomManager
	sleep 0.5
	$DAEMON $ARGUMENTS
	echo "."
	;;

  status)
	status $DAEMON
	exit $?
  ;;

  *)
	echo "Usage: /etc/init.d/micom-manager {start|stop|status|restart}"
	exit 1
esac

exit 0
