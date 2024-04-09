#Check your update romfile name

UPDATE_DIR = "${DEPLOY_DIR_IMAGE}/update_sub"

do_make_updatedir() {

	rm -rf ${UPDATE_DIR}
	mkdir ${UPDATE_DIR}

	if ${@oe.utils.conditional('TCC_ARCH_FAMILY', 'tcc803x', 'true', 'false', d)}; then

		install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_KERNEL_NAME}			${UPDATE_DIR}/sub_boot.bin
		install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_ROOTFS_NAME}			${UPDATE_DIR}/sub_rootfs.cpio
		install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_DTB_NAME}			${UPDATE_DIR}/sub.dtb
	else
		install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_BOOTLOADER_NAME}		${UPDATE_DIR}/ca53_bl3.rom
		install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_KERNEL_NAME}			${UPDATE_DIR}/sub_boot.img
		install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_ROOTFS_NAME}			${UPDATE_DIR}/sub_rootfs.ext4
		install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_DTB_NAME}			${UPDATE_DIR}/sub.dtb

		if [ -e ${DEPLOY_DIR_IMAGE}/splash_1920x720x32.img ]; then
			install -m 0644 ${DEPLOY_DIR_IMAGE}/splash_1920x720x32.img			${UPDATE_DIR}/subcore_splash
		fi

	fi

}

addtask make_updatedir
