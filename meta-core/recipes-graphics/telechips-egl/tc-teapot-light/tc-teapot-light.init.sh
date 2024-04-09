#!/bin/sh

. /etc/init.d/functions

do_start_pa() {
	/usr/bin/tcTeapot20 LCD_WIDTH LCD_HEIGHT &
}

case "$1" in
	start)
		. /etc/profile
		do_start_pa
		;;
	restart | reload | force-reload)
		killall tcTeapot20
		do_start_pa
		;;
	stop)
		killall tcTeapot20
		;;
	*)
		echo "Not supported"
		exit 3
		;;
esac
