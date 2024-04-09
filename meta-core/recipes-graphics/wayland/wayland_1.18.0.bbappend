FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Add-setGeometry-protocol.patch \
	${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc805x', 'file://0001-Fix-an-IMG-DDK-build-warning-for-pre-0.52.0-Meson.patch', '', d)} \
"

do_install_append() {
	if ${@bb.utils.contains('INVITE_PLATFORM', 'telechips-egl', 'true', 'false', d)}; then
        rm -rf ${D}/${libdir}/libwayland-egl*
        rm -rf ${D}/${libdir}/pkgconfig/wayland-egl*
	fi
}
