#!/bin/sh

# Check is user data partition formatted.
toFormat=0
supportTypes="ext2 ext3 ext4 vfat"
formatType=""

if [ -n "$DATA_PART_FORMAT" ]; then
	if [[ $supportTypes =~ "$DATA_PART_FORMAT" ]]; then
		for typeCheck in $supportTypes; do
			if [ $typeCheck = $DATA_PART_FORMAT ]; then
				formatType=$typeCheck
				break
			fi
		done
	else
		echo "Not support $DATA_PART_FORMAT type"
		exit -1
	fi
else
	formatType="ext4"
fi

if [ -n $formatType ]; then
	format_cmd="/sbin/mkfs.$formatType"

	dataPartition=`blkid | grep "PARTLABEL=\"data\""`
	if [ -n "$dataPartition" ]; then
		device="${dataPartition%%:*}"
		dataPartitionType=`blkid | grep "PARTLABEL=\"data\"" | sed 's/.*TYPE=\"\(.*\)\" PARTLABEL.*/\1/'`
		if [[ ! $dataPartitionType =~ "$formatType" ]]; then
			echo "The file system is not $formatType"
			toFormat=1
		fi
	else
		echo "Data partition not found"
	fi

	if [ $toFormat = "1" ]; then
		echo "Start format the data partition with $formatType"
		if [ $formatType = "vfat" ]; then
			if [[ $device =~ "mmc" ]]; then
				$format_cmd -F 32 $device
			else
				$format_cmd -F 32 -S 4096 $device
			fi
		else
			$format_cmd -t $formatType -b 4096 $device
		fi
		echo "Format the data partition with $formatType complete."
	fi
fi
