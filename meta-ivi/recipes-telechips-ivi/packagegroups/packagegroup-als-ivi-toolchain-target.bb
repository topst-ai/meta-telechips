DESCRIPTION = "Target packages for ivi of Telechips Automotive Linux SDK"

inherit packagegroup

PACKAGEGROUP_DISABLE_COMPLEMENTARY = "1"

RDEPENDS_${PN} += " \
	libtcdbgen-dev \
	libtcutils-dev \
	libtcconnect-dev \
	${GST_DEV} \
"

GST_DEV = " \
	gstreamer1.0-dev \
	gstreamer1.0-plugins-base-dev \
	gstreamer1.0-plugins-good-dev \
	gstreamer1.0-plugins-bad-dev \
"
