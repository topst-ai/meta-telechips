FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

OPENGL_PKGCONFIGS = "dri glamor dri3 xshmfence"
OPENGL_PKGCONFIGS:tcc897x = "glamor dri3 xshmfence"
OPENGL_PKGCONFIGS:tcc803x = "glamor dri3 xshmfence"
PACKAGECONFIG:append = "${@bb.utils.contains('DISTRO_FEATURES', 'opengl wayland', ' xwayland', '', d)}"

SRC_URI += " \
	file://0001-remove-gl-dependency.patch \
	file://x11_env.sh \
"

do_install:append () {
	install -d ${D}${sysconfdir}/profile.d/
	install -m 0755 ${WORKDIR}/x11_env.sh ${D}${sysconfdir}/profile.d/
}

FILES:${PN} += "${sysconfdir}/profile.d/x11_env.sh"
