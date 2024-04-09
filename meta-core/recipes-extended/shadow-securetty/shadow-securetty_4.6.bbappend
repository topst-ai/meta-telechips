FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://securetty-telechips"

do_configure_prepend () {
    cat ${WORKDIR}/securetty-telechips >> ${WORKDIR}/securetty
}
