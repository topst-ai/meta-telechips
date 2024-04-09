FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

#SRC_URI += "file://ab-update.cfg"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'ab-update', 'file://ab-update.cfg', '', d)}"
