#!/bin/sh

. /etc/init.d/functions

export HOME=/home/root

do_start_pa() {
	pulseaudio -n -F /etc/pulse/tc_set.pa
}

case "$1" in
	start)
		do_start_pa
		;;
	restart | reload | force-reload)
		killall pulseaudio
		do_start_pa
		;;
	stop)
		killall pulseaudio
		;;
	*)
		echo "Not supported"
		exit 3
		;;
esac
