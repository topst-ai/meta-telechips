FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://daemon.conf \
			file://client.conf \
			${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'file://pulseaudio.service', '', d)} \
			file://tc_set.pa \
			${@bb.utils.contains('INVITE_PLATFORM', 't-sound', 'file://tc_set_t-sound.pa', '', d)} \
			file://0001-Fix-memory-leak-in-context_free.patch \
"

inherit features_check

REQUIRED_DISTRO_FEATURES = "systemd"

SYSTEMD_PACKAGES = "${PN}-server"
SYSTEMD_SERVICE_${PN}-server = "pulseaudio.service"

do_install_append() {
	install -d ${D}${sysconfdir}/pulse
	install -m 0755 ${WORKDIR}/daemon.conf ${D}${sysconfdir}/pulse/
	install -m 0755 ${WORKDIR}/client.conf ${D}${sysconfdir}/pulse/

	if ${@bb.utils.contains('INVITE_PLATFORM', 't-sound', 'true', 'false', d)}; then
		install -m 0755 ${WORKDIR}/tc_set_t-sound.pa ${D}${sysconfdir}/pulse/tc_set.pa
	else
		install -m 0755 ${WORKDIR}/tc_set.pa ${D}${sysconfdir}/pulse/
	fi

	install -d ${D}/${systemd_unitdir}/system
	install -m 644 ${WORKDIR}/pulseaudio.service ${D}/${systemd_unitdir}/system
}
