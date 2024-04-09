FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://iptables.service"
SRC_URI += "file://iptables.rules"

inherit systemd

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "iptables.service"

do_install_append() {
	if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
		install -d ${D}/${systemd_unitdir}/system
		install -d ${D}/${sysconfdir}/iptables

		install -m 644 ${WORKDIR}/iptables.service	${D}${systemd_unitdir}/system/
		install -m 644 ${WORKDIR}/iptables.rules	${D}${sysconfdir}/iptables/

		sed -i "s%IP_MASQUERADE_INTERFACE%${IP_MASQUERADE_INTERFACE}%g"	${D}/${sysconfdir}/iptables/iptables.rules
		sed -i "s%IP_FORWARD_INTERFACE%${IP_FORWARD_INTERFACE}%g"			${D}/${sysconfdir}/iptables/iptables.rules
	fi
}

FILES_${PN} += " \
	${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${systemd_unitdir}', '', d)} \
	${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${sysconfdir}', '', d)} \
"
