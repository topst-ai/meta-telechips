SUMMARY = "Telechips Core packages for Linux/GNU runtime images"
DESCRIPTION = "The minimal set of packages required to boot the Telechips System"
PR = "r17"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS_${PN} = "\
	${@bb.utils.contains('INVITE_PLATFORM', 'TEE', ' kernel-module-tzdrv tzos', '', d)} \
	${@bb.utils.contains('INVITE_PLATFORM', 'HDA', ' kernel-module-hciph hciph', '', d)} \
	${@bb.utils.contains('INVITE_PLATFORM', 'optee', 'optee', '', d)} \
"
