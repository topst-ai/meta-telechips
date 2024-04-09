FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SYSTEMD_AUTO_ENABLE = "disable"

do_install_append() {
	install -d ${D}${base_sbindir}
	ln -s ${base_libdir}/systemd/systemd-bootchart ${D}${base_sbindir}/bootchartd
}
