DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd', '', d)}"
DEPENDS_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'udev', '', d)}"
PACKAGECONFIG = "udev"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://init\
"

SRC_URI_append = " file://0001-do-not-check-for-sys-kernel-uevent_helper.patch"

EXTRA_OECONF += "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '--with-systemdsystemunitdir=${sysconfdir}/system', '', d)}"

do_configure_prepend() {
	sed -i 's%basic%multi-user%g' ${S}/alsactl/Makefile.am
}

do_install_append() {
	if ${@bb.utils.contains('INVITE_PLATFORM', 't-sound', 'false', 'true', d)}; then
		install -m 0644 ${WORKDIR}/init/* ${D}${datadir}/alsa/init/
	fi
}

FILES_alsa-utils-alsactl += "${sysconfdir}"
