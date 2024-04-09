do_change_defconfig_append() {
	echo "CONFIG_INET=y"									>> ${WORKDIR}/defconfig
}
