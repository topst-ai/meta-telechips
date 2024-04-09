FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " file://50-pulseaudio.conf;subdir=${S}/pulse"
SRC_URI_append = " file://0001-add-set-pa-prop-media-role.patch"
SRC_URI_append = " \
   ${@bb.utils.contains('INVITE_PLATFORM', 't-sound', 'file://0002-T-sound-Call-path-is-separated.patch', '', d)} \
"

do_install_append() {
	rm -f ${D}${datadir}/alsa/alsa.conf.d/99-pulseaudio-default.conf
	rm -f ${D}${sysconfdir}/alsa/conf.d/99-pulseaudio-default.conf
}
