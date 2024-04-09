#Check your update romfile name

UPDATE_DIR = "${DEPLOY_DIR_IMAGE}/update_main"

CHIP_NAME = "${@bb.utils.contains_any('MACHINE', 'tcc8050-main tcc8053-main tcc8050-cluster tcc8053-cluster', 'tcc8050', 'tcc8059', d)}"

do_make_updatedir() {
	rm -rf ${UPDATE_DIR}
	mkdir ${UPDATE_DIR}

	if ${@oe.utils.conditional('TCC_ARCH_FAMILY', 'tcc803x', 'true', 'false', d)}; then
		install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_BOOTLOADER_NAME} 			${UPDATE_DIR}/bootloader.rom
		install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_KERNEL_NAME}				${UPDATE_DIR}/main_boot.img
		install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_ROOTFS_NAME}				${UPDATE_DIR}/main_rootfs.ext4
		install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_DTB_NAME}					${UPDATE_DIR}/main.dtb
		install -m 0644 ${DEPLOY_DIR_IMAGE}/boot-firmware/${UPDATE_SNOR_NAME}	${UPDATE_DIR}/snor.rom
	else
		install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_BOOTLOADER_NAME} 			${UPDATE_DIR}/ca72_bl3.rom
		install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_KERNEL_NAME}				${UPDATE_DIR}/main_boot.img
		install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_ROOTFS_NAME}				${UPDATE_DIR}/main_rootfs.ext4
		install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_DTB_NAME}					${UPDATE_DIR}/main.dtb
		install -m 0644 ${DEPLOY_DIR_IMAGE}/boot-firmware/${UPDATE_SNOR_NAME}	${UPDATE_DIR}/snor.rom
	fi
}

addtask make_updatedir
