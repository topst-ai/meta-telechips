SUMMARY = "Telechips Core packages for Linux/GNU runtime images"
DESCRIPTION = "The minimal set of packages required to boot the Telechips System"
PR = "r17"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS_${PN} = " \
	kernel-modules-vpu \
	gstreamer1.0-meta-audio \
	gstreamer1.0-meta-video \
	gstreamer1.0-meta-extra \
	${@bb.utils.contains('DISTRO_FEATURES', 'pulseaudio', 'packagegroup-pulseaudio-telechips', '', d)} \
"
