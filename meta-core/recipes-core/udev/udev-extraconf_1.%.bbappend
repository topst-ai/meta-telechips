FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://automount.rules.ufs \
	file://udevextra.rules \
"

do_install_append() {
    rm -f ${D}${sysconfdir}/udev/rules.d/autonet.rules
	if ${@oe.utils.conditional('BOOT_STORAGE', 'ufs', 'true', 'false', d)}; then
		install -m 0644 ${WORKDIR}/automount.rules.ufs     ${D}${sysconfdir}/udev/rules.d/automount.rules
	fi
	install -m 0644 ${WORKDIR}/udevextra.rules     ${D}${sysconfdir}/udev/rules.d/
}
