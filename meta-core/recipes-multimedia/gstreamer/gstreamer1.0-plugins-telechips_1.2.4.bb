DESCRIPTION = "Telechips CDK Demux Plugins for GStreamer1.0"
SECTION = "multimedia"
DEPENDS = "gstreamer1.0 gstreamer1.0-plugins-base libcdk-demux"

LICENSE = "LGPLv2.1 & Telechips"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/LGPL-2.1;md5=1a6d268fd218675ffea8be556788b780 \
                    file://gst/tcdemux/gst_tc_demux_base.h;beginline=1;endline=44;md5=ba9e1c64d6f28b2d9ab602e9e44bb8be"

LIBV = "1.0"

inherit autotools-brokensep pkgconfig

require recipes-multimedia/gstreamer/gstreamer1.0-plugins-packaging.inc

PACKAGES_DYNAMIC += "^${PN}-.*"

SRC_URI = "${TELECHIPS_AUTOMOTIVE_MULTIMEDIA_GIT}/gst-plugins-telechips_1.2.4.git;protocol=${ALS_GIT_PROTOCOL};branch=${ALS_BRANCH}"
SRCREV = "2bafee35f91a94e6e462552eeefec90ca3434633"

PATCHTOOL = "git"

S = "${WORKDIR}/git"

EXTRA_OECONF = " \
	${GSTREAMER_1_0_DEBUG} \
	PROCESSOR=${TCC_ARCH_FAMILY} \
"
oe_runconf_prepend() {
	if [ -e ${S}/po/Makefile.in.in ]; then
		sed -i -e "1a\\" -e 'GETTEXT_PACKAGE = @GETTEXT_PACKAGE@' ${S}/po/Makefile.in.in
	fi
}

CFLAGS_append = " -D${GST_ARCH_FAMILY_NAME}_INCLUDE"
RDEPENDS_${PN}-tcdemux += "libcdk-demux"
