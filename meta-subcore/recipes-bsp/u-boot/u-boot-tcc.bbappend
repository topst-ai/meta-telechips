FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " ${@bb.utils.contains('SUBCORE_APPS', 'cluster', 'file://add-dlvds.cfg', '', d)} "
