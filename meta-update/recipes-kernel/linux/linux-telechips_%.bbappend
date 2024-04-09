FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_change_defconfig_append() {
	echo "CONFIG_MAILBOX=y"				>> ${WORKDIR}/defconfig
	echo "CONFIG_TCC_SNOR_UPDATER=y"        	>> ${WORKDIR}/defconfig
}

