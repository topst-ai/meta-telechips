FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_change_defconfig_append() {
	echo "CONFIG_MAILBOX=y"				>> ${WORKDIR}/defconfig
	echo "CONFIG_TCC_MULTI_MAILBOX=y"	>> ${WORKDIR}/defconfig
	echo "CONFIG_PROC_MBOX=y"			>> ${WORKDIR}/defconfig
	echo "CONFIG_TCC_IPC=y"				>> ${WORKDIR}/defconfig
	echo "CONFIG_INPUT_UINPUT=y"      	>> ${WORKDIR}/defconfig
	echo "CONFIG_INPUT_MISC=y"        	>> ${WORKDIR}/defconfig
}

