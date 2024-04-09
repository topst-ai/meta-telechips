FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_aarch64 = " file://wired.config \
                           file://wired-setup \
                           file://wired-connection.service \
"

SYSTEMD_SERVICE_${PN}_aarch64 = "wired-connection.service"

FILES_${PN} += "${systemd_system_unitdir}/*"
