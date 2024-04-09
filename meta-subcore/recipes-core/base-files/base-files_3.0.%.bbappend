FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_install_append () {
	echo "export QT_QPA_EGLFS_PHYSICAL_WIDTH=${LCD_WIDTH}"		>> ${D}${sysconfdir}/profile.d/profile_local.sh
	echo "export QT_QPA_EGLFS_PHYSICAL_HEIGHT=${LCD_HEIGHT}"	>> ${D}${sysconfdir}/profile.d/profile_local.sh
	if ${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc805x', 'true', 'false', d)}; then
		echo "export QT_QPA_EGLFS_INTEGRATION=eglfs_pvr"			>> ${D}${sysconfdir}/profile.d/profile_local.sh
	else
		echo "export QT_QPA_EGLFS_INTEGRATION=eglfs_mali"							>> ${D}${sysconfdir}/profile.d/profile_local.sh
	fi
	echo "export QT_QPA_EGLFS_FORCE888=1"						>> ${D}${sysconfdir}/profile.d/profile_local.sh
}
