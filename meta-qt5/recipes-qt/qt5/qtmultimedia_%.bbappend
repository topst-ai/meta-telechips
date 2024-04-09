FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://0101-set-alsa-device-tccout-tccin.patch \
"

PACKAGECONFIG_append = " gstreamer"

