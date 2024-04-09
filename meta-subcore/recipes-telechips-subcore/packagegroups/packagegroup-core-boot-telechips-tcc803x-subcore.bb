# derived from meta/recipes-core/packagegroups/packagegroup-core-boot.bb

SUMMARY = "Minimal boot requirements"
DESCRIPTION = "The minimal set of packages required to boot the Telechips IVI System"
PR = "r11"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS_${PN} = "\
	base-files \
	busybox \
	busybox-inittab \
	base-passwd \
	shadow-securetty \
	libegl-telechips \
	libgles2-telechips \
	${@bb.utils.contains('INVITE_PLATFORM', 'svm', 'svm', '', d)} \
	${@bb.utils.contains('INVITE_PLATFORM', 'rear-camera', 'tc-camera-app', '', d)} \
	${@bb.utils.contains('INVITE_PLATFORM', 't-sound', 't-sound', '', d)} \
"
