DESCRIPTION = "Target packages for basic of Telechips Automotive Linux SDK"

inherit packagegroup

PACKAGEGROUP_DISABLE_COMPLEMENTARY = "1"

RDEPENDS_${PN} += "\
	packagegroup-core-standalone-sdk-target \
	libsqlite3-dev \
    expat-dev \
	base-files \
	glib-2.0-dev \
	dbus-dev \
	dbus-glib-dev \
	boost-dev \
	libusb1-dev \
	taglib-dev \
	python3 \
	libsdl2-dev \
	alsa-dev \
	libegl-telechips-dev \
	libgles1-telechips-dev \
	libgles2-telechips-dev \
	libgles3-telechips-dev \
	libxml2-dev \
"
