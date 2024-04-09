FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://0101-Fix-compilation-with-ICU-59.patch \
	file://0102-add-armv8-architecture-define.patch \
"
