#!/bin/sh

cur_path=`pwd`

SUPPORT_MACHINES="tcc8031p-main tcc8034p-main tcc8050-main tcc8053-main tcc8059-main"

if [ -n "$1" ]; then
	machine="$1"
else
	echo "Choose MACHINE"
	num=1
	for machine in $SUPPORT_MACHINES; do
		echo "  $num. $machine"
		machines[$num]=$machine
		num=$(($num + 1))
	done
	total=$num
	num=$(($num - 1))
	echo -n "select number(1-$num) => "
	read sel

	if [ -z $sel ]; then
		machine=""
	else
		if [ $sel != "0" -a $sel -lt "$total" ];then
			machine=${machines[$sel]}
		else
			machine=""
		fi
	fi
fi

export TEMPLATECONF=$cur_path/poky/meta-telechips/meta-ivi/template/${machine:0:6}x

if [ -z $machine ]; then
	echo "Could not continue build. You have to select machine"
else
	echo "machine($machine) selected."
	if [ -f poky/oe-init-build-env ]; then
		mkdir -p build
		if [ -n $machine ]; then
			export MACHINE="$machine"
			source poky/oe-init-build-env build/$machine
			sed -i "s%^#\(MACHINE ??=.*$machine\".*\)%\1%g" conf/local.conf
		fi
	fi
fi
