SUMMARY = "Telechips Core packages for Linux/GNU runtime images"
DESCRIPTION = "The minimal set of packages required to boot the Telechips System"
PR = "r17"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS_${PN} = " \
	customize-rootfs \
	dbus \
	alsa-lib \
	alsa-utils \
	alsa-state \
	tc-enable-removable-disk \
	android-tools \
	tcc-ufsd \
	sqlite3 \
	tzdata \
	tzdata-posix \
	kernel-modules \
    ${@bb.utils.contains('INVITE_PLATFORM', 'network', 'packagegroup-telechips-base-net', '', d)} \
"
