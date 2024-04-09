SUMMARY = "Telechips Core packages for Linux/GNU runtime images"
DESCRIPTION = "The minimal set of packages required to boot the Telechips System"
PR = "r17"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS_${PN} = " \
	${@bb.utils.contains("DISTRO_FEATURES", "wayland", "${WAYLAND_PACKAGES}", "", d)} \
	${QT_PACKAGES} \
"

WAYLAND_PACKAGES = " \
	wayland \
	weston \
	weston-init \
	weston-examples \
	${@bb.utils.contains("INVITE_PLATFORM", 'ivi-extension', 'wayland-ivi-extension qtbase-examples', '', d)} \
	${@bb.utils.contains("DISTRO_FEATURES", 'x11', 'weston-xwayland ${X11_EXAMPLES}', '', d)} \
"
X11_EXAMPLES = " \
    packagegroup-core-x11-xserver \
    packagegroup-core-x11-utils \
    matchbox-wm \
    mini-x-session \
    liberation-fonts \
	xeyes \
	xev \
	l3afpad \
	pcmanfm \
	puzzles \
"

QT_EXAMPLES = " \
	qtbase-examples \
	${@bb.utils.contains("INVITE_PLATFORM", "qt5/wayland", "qtwayland-examples", "", d)} \
"

QT_PACKAGES = " \
	qtbase \
	qtbase-plugins \
	${@bb.utils.contains("INVITE_PLATFORM", "qt5/wayland", "qtwayland qtwayland-plugins", "", d)} \
	${@bb.utils.contains("INVITE_PLATFORM", "qt-examples", " ${QT_EXAMPLES}", "", d)} \
"
