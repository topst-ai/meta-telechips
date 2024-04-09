FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

SRC_URI += "file://wpa_supplicant.conf-invite"

do_install_append() {
	install -m 600 ${WORKDIR}/wpa_supplicant.conf-invite ${D}${sysconfdir}/wpa_supplicant.conf
}
