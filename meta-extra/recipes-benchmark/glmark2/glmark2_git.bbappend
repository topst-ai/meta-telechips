FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
PACKAGECONFIG = "${@bb.utils.contains('DISTRO_FEATURES', 'wayland opengl', 'wayland-gles2', 'drm-gles2', d)}"

SRC_URI += " \
	file://glmark2.service \
	file://glmark2.path \
"

inherit systemd

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "${PN}.service ${PN}.path"

do_install_append() {
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/glmark2.service		${D}${systemd_unitdir}/system/
	install -m 0644 ${WORKDIR}/glmark2.path			${D}${systemd_unitdir}/system/
}
