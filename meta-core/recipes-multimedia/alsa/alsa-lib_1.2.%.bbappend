FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://01-telechips.conf \
	file://01-telechips-for-t-sound.conf \
	${@bb.utils.contains('DISTRO_FEATURES', 'bluetooth', 'file://02-bluez.conf', '', d)} \
"
do_install_append() {
	install -d ${D}${sysconfdir}/alsa/conf.d
	if ${@bb.utils.contains('INVITE_PLATFORM', 't-sound', 'true', 'false', d)}; then
		install -m 0644 ${WORKDIR}/01-telechips-for-t-sound.conf ${D}${sysconfdir}/alsa/conf.d/
	else
		install -m 0644 ${WORKDIR}/01-telechips.conf ${D}${sysconfdir}/alsa/conf.d/
	fi

	if ${@bb.utils.contains('DISTRO_FEATURES', 'bluetooth', 'true', 'false', d)}; then
		install -d ${D}${sysconfdir}
		install -m 0644 ${WORKDIR}/02-bluez.conf ${D}${sysconfdir}
	fi
}

