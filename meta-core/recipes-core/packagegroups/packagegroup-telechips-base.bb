SUMMARY = "Telechips Core packages for Linux/GNU runtime images"
DESCRIPTION = "The minimal set of packages required to boot the Telechips System"
PR = "r17"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS_${PN} = "\
	acl \
	attr \
	bash \
	ldd \
	procps \
	bc \
	coreutils \
	cpio \
	e2fsprogs \
	ed \
	findutils \
	gawk \
	grep \
	kmod \
	logrotate \
	mingetty \
	ncurses \
	procps \
	psmisc \
	sed \
	sudo \
	tar \
	time \
	util-linux \
	util-linux-mount \
	util-linux-umount \
	util-linux-blkid \
	util-linux-fstrim \
	util-linux-hwclock \
	util-linux-fsck \
	dosfstools \
	vim \
	which \
"
