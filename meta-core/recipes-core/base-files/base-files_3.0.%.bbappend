FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://fstab \
	file://profile_local.sh \
	file://system-config-users \
"

hostname = "telechips-${MACHINE}"
dirs755 += "/opt"
dirs755 += "${@bb.utils.contains('INVITE_PLATFORM', 'optee', '/sest', '', d)}"

do_install_append () {
	rm -f ${D}${sysconfdir}/fstab
	install -m 0644 ${WORKDIR}/fstab ${D}${sysconfdir}/fstab

	if ${@bb.utils.contains('INVITE_PLATFORM', 'optee', 'true', 'false', d)}; then
		echo "PARTLABEL=sest  /sest  ext4  defaults,noatime,nofail,x-systemd.device-timeout=10  1  2" >> ${D}${sysconfdir}/fstab
	fi

	install -d ${D}${sysconfdir}/profile.d/
	install -m 0755 ${WORKDIR}/profile_local.sh ${D}${sysconfdir}/profile.d/

	if ${@bb.utils.contains('INVITE_PLATFORM', 'drm', 'false', 'true', d)}; then
		echo "export QT_QPA_EGLFS_PHYSICAL_WIDTH=${LCD_WIDTH}"								>> ${D}${sysconfdir}/profile.d/profile_local.sh
		echo "export QT_QPA_EGLFS_PHYSICAL_HEIGHT=${LCD_HEIGHT}"							>> ${D}${sysconfdir}/profile.d/profile_local.sh
		echo "export QT_QPA_EGLFS_WIDTH=${LCD_WIDTH}"										>> ${D}${sysconfdir}/profile.d/profile_local.sh
		echo "export QT_QPA_EGLFS_HEIGHT=${LCD_HEIGHT}"										>> ${D}${sysconfdir}/profile.d/profile_local.sh

		if ${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc805x', 'true', 'false', d)}; then
			echo "export QT_QPA_EGLFS_INTEGRATION=eglfs_pvr"								>> ${D}${sysconfdir}/profile.d/profile_local.sh
			echo "export NULLWS_BUFFERS_COUNT=3"											>> ${D}${sysconfdir}/profile.d/profile_local.sh
		else
			echo "export QT_QPA_EGLFS_INTEGRATION=eglfs_mali"								>> ${D}${sysconfdir}/profile.d/profile_local.sh
		fi
		echo "export QT_QPA_EGLFS_FORCE888=1"												>> ${D}${sysconfdir}/profile.d/profile_local.sh
		echo "export QT_QPA_EGLFS_FB=/dev/${EGLFS_FB}"										>> ${D}${sysconfdir}/profile.d/profile_local.sh
		echo "export QT_QPA_EVDEV_KEYBOARD_PARAMETERS='grab=1;/dev/input/virtual-keyboard'"	>> ${D}${sysconfdir}/profile.d/profile_local.sh
		echo "export QT_QPA_FONTDIR=/usr/share/fonts/"										>> ${D}${sysconfdir}/profile.d/profile_local.sh
	fi

	install -d ${D}${sysconfdir}/sysconfig
	install -m 644 ${WORKDIR}/system-config-users	${D}${sysconfdir}/sysconfig/
	sed -i "s%DATA_PART_FSTYPE%${DATA_PART_FSTYPE}%g"	${D}${sysconfdir}/sysconfig/system-config-users

	if ${@bb.utils.contains_any('INVITE_PLATFORM', 'hud-display', 'true', 'false', d)}; then
		echo "export IVI_DISPLAY_NUMBER=1" >> ${D}${sysconfdir}/profile.d/profile_local.sh
		echo "export PASSENGER_DISPLAY_NUMBER=0" >> ${D}${sysconfdir}/profile.d/profile_local.sh
	else
		echo "export IVI_DISPLAY_NUMBER=0" >> ${D}${sysconfdir}/profile.d/profile_local.sh
	fi
}

FILES_${PN} += " \
	${sysconfdir} \
"
