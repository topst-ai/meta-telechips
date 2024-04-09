UFS_MKIMGCMD = "${@oe.utils.conditional('BOOT_STORAGE', 'ufs', '--sector_size 4096', '', d)}"

do_cleanfwdn() {
	rm -rf ${DEPLOY_DIR}/fwdn
}

do_make_fai() {
	install -d ${DEPLOY_DIR}/fwdn
	if [ ! -e ${DEPLOY_DIR}/home-directory.ext4 ]; then
		dd if=/dev/zero of=${DEPLOY_DIR}/home-directory.ext4 bs=1024 count=512000
		mkfs.ext4 -b 4096 ${DEPLOY_DIR}/home-directory.ext4
	fi

	dtb=${KERNEL_DEVICETREE}
	dtb_ext=${dtb##*.}
	dtb_name=`basename $dtb .$dtb_ext`

	system_name=`ls -lh --block-size=M ${DEPLOY_DIR}/images/${MACHINE}/${IMAGE_LINK_NAME}.${DEFAULT_IMAGE_FSTYPE}`
	for i in ${system_name}; do true; done
	system_size=`stat -c%s ${DEPLOY_DIR}/images/${MACHINE}/${i}`

	# 10% increase
	#system_size=`expr ${system_size} / 1024 / 1024  + ${system_size} / 1024 / 1024 / 10`
	# 50M increase
	system_size=`expr ${system_size} / 1024 / 1024 + 50`

	rm -f ${DEPLOY_DIR}/fwdn/partition.list*

	if ${@bb.utils.contains('INVITE_PLATFORM', 'with-subcore', 'true', 'false', d)}; then
		if [ -L ${SUBCORE_DEPLOY_DIR}/${SUBCORE_ROOTFS_IMAGE_NAME} ]; then
			subcore_item_real_name=`readlink ${SUBCORE_DEPLOY_DIR}/${SUBCORE_ROOTFS_IMAGE_NAME}`
		else
			subcore_item_real_name=${SUBCORE_ROOTFS_IMAGE_NAME}
		fi
		for i in ${subcore_item_real_name}; do true; done
		subcore_item_size=`stat -c%s ${SUBCORE_DEPLOY_DIR}/${i}`

		# 10% increase
		#subcore_item_size=`expr 10 + ${subcore_item_size} / 1024 / 1024 + ${subcore_item_size} / 1024 / 1024 / 10`
		# 50M increase
		subcore_item_size=`expr ${subcore_item_size} / 1024 / 1024 + 50`
	fi

#create partition list
	touch ${DEPLOY_DIR}/fwdn/partition.list
	make_plist_${TCC_ARCH_FAMILY}

	if ${@bb.utils.contains('INVITE_PLATFORM', 'optee', 'true', 'false', d)}; then
		echo "sest:8M@${DEPLOY_DIR}/images/${MACHINE}/sest.ext4" >> ${DEPLOY_DIR}/fwdn/partition.list
	fi

	add_additional_partitions "${DEPLOY_DIR}/fwdn/partition.list"

	user_data_size=$(set_user_data_size "${DEPLOY_DIR}/fwdn/partition.list")
	if [ ! -e ${DEPLOY_DIR}/user-data.ext4 ] || [ ! -e ${DEPLOY_DIR}/user-data.size ] || [ ${user_data_size} != `cat ${DEPLOY_DIR}/user-data.size` ]; then
		rm -f ${DEPLOY_DIR}/user-data.ext4
		data_sizeK=`expr ${user_data_size} \* 1024`
		dd if=/dev/zero of=${DEPLOY_DIR}/user-data.ext4 bs=1024 count=${data_sizeK}
		mkfs.ext4 -b 4096 ${DEPLOY_DIR}/user-data.ext4
		echo -n "${user_data_size}" > ${DEPLOY_DIR}/user-data.size
	fi
	echo -n "data:${user_data_size}M@${DEPLOY_DIR}/user-data.ext4"	>> ${DEPLOY_DIR}/fwdn/partition.list

#symbolic link boot-firmware
	if [ ! -e ${DEPLOY_DIR}/fwdn/boot-firmware ]; then
		ln -sf ${DEPLOY_DIR_IMAGE}/boot-firmware ${DEPLOY_DIR}/fwdn/boot-firmware
	fi

#make SD_Data.fai
	${STAGING_BINDIR_NATIVE}/mktcimg \
		--parttype gpt \
		--storage_size ${STORAGE_SIZE} \
		--fplist ${DEPLOY_DIR}/fwdn/partition.list \
		--outfile ${DEPLOY_DIR}/fwdn/SD_Data.fai \
		--area_name "SD Data" \
		--gptfile ${DEPLOY_DIR}/fwdn/SD_Data.gpt ${UFS_MKIMGCMD}
}

make_plist_tcc805x() {
	echo "bl3_ca72_a:2M@${DEPLOY_DIR}/images/${MACHINE}/ca72_bl3.rom$1"								>> ${DEPLOY_DIR}/fwdn/partition.list$1

	if ${@bb.utils.contains('INVITE_PLATFORM', 'fw-update', 'true', 'false', d)}; then
		echo "boot_a:30M@${DEPLOY_DIR}/images/${MACHINE}/tc-boot-${MACHINE}.img$1"					>> ${DEPLOY_DIR}/fwdn/partition.list$1
		echo "boot_b:30M@${DEPLOY_DIR}/images/${MACHINE}/tc-boot-${MACHINE}.img$1"					>> ${DEPLOY_DIR}/fwdn/partition.list$1
		echo "system_a:${system_size}M@${DEPLOY_DIR}/images/${MACHINE}/${IMAGE_LINK_NAME}.${DEFAULT_IMAGE_FSTYPE}"	>> ${DEPLOY_DIR}/fwdn/partition.list$1
		echo "system_b:${system_size}M@${DEPLOY_DIR}/images/${MACHINE}/${IMAGE_LINK_NAME}.${DEFAULT_IMAGE_FSTYPE}"	>> ${DEPLOY_DIR}/fwdn/partition.list$1
		echo "dtb_a:200K@${DEPLOY_DIR}/images/${MACHINE}/$dtb_name.$dtb_ext"						>> ${DEPLOY_DIR}/fwdn/partition.list$1
		echo "dtb_b:200K@${DEPLOY_DIR}/images/${MACHINE}/$dtb_name.$dtb_ext"						>> ${DEPLOY_DIR}/fwdn/partition.list$1
	else
		echo "boot:60M@${DEPLOY_DIR}/images/${MACHINE}/tc-boot-${MACHINE}.img$1"					>> ${DEPLOY_DIR}/fwdn/partition.list$1
		echo "system:${system_size}M@${DEPLOY_DIR}/images/${MACHINE}/${IMAGE_LINK_NAME}.${DEFAULT_IMAGE_FSTYPE}"	>> ${DEPLOY_DIR}/fwdn/partition.list$1
		echo "dtb:200K@${DEPLOY_DIR}/images/${MACHINE}/$dtb_name.$dtb_ext"							>> ${DEPLOY_DIR}/fwdn/partition.list$1
	fi
	echo "env:1M@"																					>> ${DEPLOY_DIR}/fwdn/partition.list$1
	echo "misc:1M@"																					>> ${DEPLOY_DIR}/fwdn/partition.list$1
	echo "splash:40M@"																				>> ${DEPLOY_DIR}/fwdn/partition.list$1
	echo "home:500M@${DEPLOY_DIR}/home-directory.ext4"												>> ${DEPLOY_DIR}/fwdn/partition.list$1

	if ${@bb.utils.contains_any('INVITE_PLATFORM', 'with-subcore', 'true', 'false', d)}; then
		echo "bl3_ca53_a:2M@${SUBCORE_DEPLOY_DIR}/ca53_bl3.rom$1"									>> ${DEPLOY_DIR}/fwdn/partition.list$1
		if ${@bb.utils.contains_any('INVITE_PLATFORM', 'fw-update', 'true', 'false', d)}; then
			echo "subcore_boot_a:30M@${SUBCORE_DEPLOY_DIR}/${SUBCORE_BOOT_IMAGE_NAME}$1"			>> ${DEPLOY_DIR}/fwdn/partition.list$1
			echo "subcore_boot_b:30M@${SUBCORE_DEPLOY_DIR}/${SUBCORE_BOOT_IMAGE_NAME}$1"			>> ${DEPLOY_DIR}/fwdn/partition.list$1
		else
			echo "subcore_boot:30M@${SUBCORE_DEPLOY_DIR}/${SUBCORE_BOOT_IMAGE_NAME}$1"				>> ${DEPLOY_DIR}/fwdn/partition.list$1
		fi

		if ${@bb.utils.contains_any('INVITE_PLATFORM', 'fw-update', 'true', 'false', d)}; then
			echo "subcore_dtb_a:200K@${SUBCORE_DEPLOY_DIR}/${SUBCORE_DTB_IMAGE_NAME}"				>> ${DEPLOY_DIR}/fwdn/partition.list$1
			echo "subcore_dtb_b:200K@${SUBCORE_DEPLOY_DIR}/${SUBCORE_DTB_IMAGE_NAME}"				>> ${DEPLOY_DIR}/fwdn/partition.list$1
		else
			echo "subcore_dtb:200K@${SUBCORE_DEPLOY_DIR}/${SUBCORE_DTB_IMAGE_NAME}"					>> ${DEPLOY_DIR}/fwdn/partition.list$1
		fi

		echo "subcore_env:1M@"																		>> ${DEPLOY_DIR}/fwdn/partition.list$1
		echo "subcore_misc:1M@"																		>> ${DEPLOY_DIR}/fwdn/partition.list$1

		if [ -e ${SUBCORE_DEPLOY_DIR}/${SPLASH_IMAGE} ]; then
			if ${@bb.utils.contains_any('INVITE_PLATFORM', 'fw-update', 'true', 'false', d)}; then
				echo "subcore_splash_a:40M@${SUBCORE_DEPLOY_DIR}/${SPLASH_IMAGE}"			>> ${DEPLOY_DIR}/fwdn/partition.list$1
				echo "subcore_splash_b:40M@${SUBCORE_DEPLOY_DIR}/${SPLASH_IMAGE}"			>> ${DEPLOY_DIR}/fwdn/partition.list$1
			else
				echo "subcore_splash:40M@${SUBCORE_DEPLOY_DIR}/${SPLASH_IMAGE}"				>> ${DEPLOY_DIR}/fwdn/partition.list$1
			fi

		fi

		if ${@bb.utils.contains_any('INVITE_PLATFORM', 'fw-update', 'true', 'false', d)}; then
			echo "subcore_root_a:${subcore_item_size}M@${SUBCORE_DEPLOY_DIR}/${SUBCORE_ROOTFS_IMAGE_NAME}"	>> ${DEPLOY_DIR}/fwdn/partition.list$1
			echo "subcore_root_b:${subcore_item_size}M@${SUBCORE_DEPLOY_DIR}/${SUBCORE_ROOTFS_IMAGE_NAME}"	>> ${DEPLOY_DIR}/fwdn/partition.list$1
		else
			echo "subcore_root:${subcore_item_size}M@${SUBCORE_DEPLOY_DIR}/${SUBCORE_ROOTFS_IMAGE_NAME}"	>> ${DEPLOY_DIR}/fwdn/partition.list$1
		fi
	fi

	if [ -e ${DEPLOY_DIR}/images/${MACHINE}/optee.rom ]; then
		cp -ap ${DEPLOY_DIR}/images/${MACHINE}/optee.rom* ${DEPLOY_DIR}/images/${MACHINE}/boot-firmware
	fi
}

make_plist_tcc803x() {
	echo "bl3_ca53_a:2M@${DEPLOY_DIR}/images/${MACHINE}/u-boot.rom$1"								>> ${DEPLOY_DIR}/fwdn/partition.list$1
	echo "bl3_ca53_b:2M@${DEPLOY_DIR}/images/${MACHINE}/u-boot.rom$1"								>> ${DEPLOY_DIR}/fwdn/partition.list$1
	if ${@bb.utils.contains('INVITE_PLATFORM', 'fw-update', 'true', 'false', d)}; then
		echo "boot_a:30M@${DEPLOY_DIR}/images/${MACHINE}/tc-boot-${MACHINE}.img$1"						>> ${DEPLOY_DIR}/fwdn/partition.list$1
		echo "boot_b:30M@${DEPLOY_DIR}/images/${MACHINE}/tc-boot-${MACHINE}.img$1"						>> ${DEPLOY_DIR}/fwdn/partition.list$1
		echo "system_a:${system_size}M@${DEPLOY_DIR}/images/${MACHINE}/${IMAGE_LINK_NAME}.${DEFAULT_IMAGE_FSTYPE}"	>> ${DEPLOY_DIR}/fwdn/partition.list$1
		echo "system_b:${system_size}M@${DEPLOY_DIR}/images/${MACHINE}/${IMAGE_LINK_NAME}.${DEFAULT_IMAGE_FSTYPE}"	>> ${DEPLOY_DIR}/fwdn/partition.list$1
		echo "dtb_a:200K@${DEPLOY_DIR}/images/${MACHINE}/$dtb_name.$dtb_ext"							>> ${DEPLOY_DIR}/fwdn/partition.list$1
		echo "dtb_b:200K@${DEPLOY_DIR}/images/${MACHINE}/$dtb_name.$dtb_ext"							>> ${DEPLOY_DIR}/fwdn/partition.list$1

	else
		echo "boot:30M@${DEPLOY_DIR}/images/${MACHINE}/tc-boot-${MACHINE}.img$1"						>> ${DEPLOY_DIR}/fwdn/partition.list$1
		echo "system:${system_size}M@${DEPLOY_DIR}/images/${MACHINE}/${IMAGE_LINK_NAME}.${DEFAULT_IMAGE_FSTYPE}"	>> ${DEPLOY_DIR}/fwdn/partition.list$1
		echo "dtb:200K@${DEPLOY_DIR}/images/${MACHINE}/$dtb_name.$dtb_ext"							>> ${DEPLOY_DIR}/fwdn/partition.list$1
	fi
	echo "env:1M@"																					>> ${DEPLOY_DIR}/fwdn/partition.list$1
	echo "misc:1M@"																					>> ${DEPLOY_DIR}/fwdn/partition.list$1
	if [ -e ${DEPLOY_DIR}/images/${MACHINE}/splash_1920x720x32_tcc803xp.img ]; then
		echo "splash:40M@${DEPLOY_DIR}/images/${MACHINE}/splash_1920x720x32_tcc803xp.img"				>> ${DEPLOY_DIR}/fwdn/partition.list$1
	else
		echo "splash:40M@"																				>> ${DEPLOY_DIR}/fwdn/partition.list$1
	fi
	echo "home:500M@${DEPLOY_DIR}/home-directory.ext4"												>> ${DEPLOY_DIR}/fwdn/partition.list$1
	if ${@bb.utils.contains('INVITE_PLATFORM', 'with-subcore', 'true', 'false', d)}; then
		if ${@bb.utils.contains('INVITE_PLATFORM', 'fw-update', 'true', 'false', d)}; then
			echo "a7s_boot_a:8M@${SUBCORE_DEPLOY_DIR}/${SUBCORE_BOOT_IMAGE_NAME}$1"				>> ${DEPLOY_DIR}/fwdn/partition.list$1
			echo "a7s_boot_b:8M@${SUBCORE_DEPLOY_DIR}/${SUBCORE_BOOT_IMAGE_NAME}$1"				>> ${DEPLOY_DIR}/fwdn/partition.list$1
			echo "a7s_dtb_a:200K@${SUBCORE_DEPLOY_DIR}/${SUBCORE_DTB_IMAGE_NAME}"					>> ${DEPLOY_DIR}/fwdn/partition.list$1
			echo "a7s_dtb_b:200K@${SUBCORE_DEPLOY_DIR}/${SUBCORE_DTB_IMAGE_NAME}"					>> ${DEPLOY_DIR}/fwdn/partition.list$1
			echo "a7s_root_a:${subcore_item_size}M@${SUBCORE_DEPLOY_DIR}/${SUBCORE_ROOTFS_IMAGE_NAME}"	>> ${DEPLOY_DIR}/fwdn/partition.list$1
			echo "a7s_root_b:${subcore_item_size}M@${SUBCORE_DEPLOY_DIR}/${SUBCORE_ROOTFS_IMAGE_NAME}"	>> ${DEPLOY_DIR}/fwdn/partition.list$1
		else
			echo "a7s_boot:8M@${SUBCORE_DEPLOY_DIR}/${SUBCORE_BOOT_IMAGE_NAME}$1"				>> ${DEPLOY_DIR}/fwdn/partition.list$1
			echo "a7s_dtb:200K@${SUBCORE_DEPLOY_DIR}/${SUBCORE_DTB_IMAGE_NAME}"					>> ${DEPLOY_DIR}/fwdn/partition.list$1
			echo "a7s_root:${subcore_item_size}M@${SUBCORE_DEPLOY_DIR}/${SUBCORE_ROOTFS_IMAGE_NAME}"	>> ${DEPLOY_DIR}/fwdn/partition.list$1

		fi
	fi

	if [ -e ${DEPLOY_DIR}/images/${MACHINE}/optee.rom ]; then
		cp -ap ${DEPLOY_DIR}/images/${MACHINE}/optee.rom* ${DEPLOY_DIR}/images/${MACHINE}/boot-firmware
	fi
}

add_additional_partitions() {
	echo "No exist additional partition"
}

set_user_data_size() {
	cp $1 temp.list
	sed -i "s%[a-z0-9_]*:\([0-9]*[MK]\)@.*%\1%g" temp.list
	sed -i "s%[0-9]*K%1M%g" temp.list
	sed -i "s%^0M%%g" temp.list
	sed -i "s%\([0-9]*\)M%\1%g" temp.list
	sed -z -i "s/\n/,/g;s/,$/\n/" temp.list
	sed -i "s%,\([0-9]*\)% + \1%g" temp.list

	used_size=`cat temp.list | xargs expr`
	data_size=`expr ${STORAGE_SIZE} / 1048576 - $used_size`
	rm temp.list
	if [ ${data_size} -gt ${MAX_DATA_SIZE} ]; then
		data_size=${MAX_DATA_SIZE}
	elif [ ${data_size} -lt "0" ]; then
		data_size="1"
	fi

	echo "${data_size}"
}

do_clean[depends] += "${@oe.utils.less_or_equal('FWDN_VERSION', '7', '', 'boot-firmware:do_clean', d)}"
do_make_fai[depends] += "${@oe.utils.less_or_equal('FWDN_VERSION', '7', '', 'tc-fai-generator-native:do_populate_sysroot boot-firmware:do_deploy', d)}"
addtask cleanfwdn after do_clean before do_cleansstate
addtask make_fai
