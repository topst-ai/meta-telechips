DESCRIPTION = "Telechips OMX Decoder library"
SECTION = "libs"

LICENSE = "LGPLv2.1 & Telechips"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/LGPL-2.1;md5=1a6d268fd218675ffea8be556788b780 \
                    file://src/omx/omx_include/tcc_audio_common.h;beginline=1;endline=16;md5=bbbd5733d2f0be44ccf56e2c3b509ab2 \
                    file://src/omx/omx_include/tcc_video_common.h;beginline=1;endline=16;md5=133307b648fca781317bcbbde9cf88af"

inherit autotools-brokensep pkgconfig

SRC_URI = "${TELECHIPS_AUTOMOTIVE_MULTIMEDIA_GIT}/libomxil-telechips.git;protocol=${ALS_GIT_PROTOCOL};branch=${ALS_BRANCH}"
SRC_URI += "file://libomxil-bellagio.pc"

SRCREV = "09287f9d5efb0eaaa2a38cf71e244b15ddc00bec"

DEPENDS = "libcdk-audio libcdk-video glib-2.0 virtual/kernel"

PATCHTOOL = "git"

S = "${WORKDIR}/git"

ADD_INCLUDE_PATH = " \
	-I${STAGING_KERNEL_DIR}/${KERNEL_MACH_PATH}/include  \
	-I${STAGING_DIR_HOST}/usr/include/glib-2.0 \
	-I${STAGING_DIR_HOST}/usr/lib/glib-2.0/include \
	-I${STAGING_KERNEL_DIR}/include/video/tcc \
	-I${STAGING_KERNEL_BUILDDIR}/include \
"
ADD_INCLUDE_PATH += "${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc805x', '-I${STAGING_KERNEL_DIR}/include/video/tcc', '', d)}"
ADD_INCLUDE_PATH += "${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc803x', '-I${STAGING_KERNEL_DIR}/include/video/tcc', '', d)}"

EXTRA_OECONF += "PROCESSOR=${TCC_ARCH_FAMILY}"
CFLAGS_append = " ${ADD_INCLUDE_PATH}"
CFLAGS_append = " ${@bb.utils.contains('INVITE_PLATFORM', 'use-vout-vsync', '-DTCC_VSYNC_INCLUDE', '', d)}"
CFLAGS_append = " ${@bb.utils.contains_any('TCC_ARCH_FAMILY', 'tcc805x tcc803x', '-DSUPPORT_4K_VIDEO', '', d)}"
CFLAGS_append = " ${@bb.utils.contains_any('VIDEO_SINK', 'waylandsink', '-DFORCE_DISABLE_MAP_CONVERTER', '', d)}"

PROVIDES += "virtual/libomxil"

do_install_append() {
	install -d ${D}${includedir}
	install -d ${D}${libdir}/pkgconfig

	install -m 0644 ${WORKDIR}/libomxil-bellagio.pc ${D}${libdir}/pkgconfig/
	cp -ap ${S}/src/omx/omx_include/* ${D}${includedir}
}

PACKAGES = "${PN} ${PN}-dev ${PN}-staticdev ${PN}-dbg"
INSANE_SKIP_${PN} += "installed-vs-shipped dev-so textrel"

FILES_${PN} += "${libdir}/*.so \
                ${libdir}/*${SOLIBS} \
"
FILES_${PN}-staticdev += "${libdir}/*.a \
"
FILES_${PN}-dev += "${libdir}/*.la \
                    ${libdir}/*${SOLIBSDEV} \
"
FILES_${PN}-dbg += "${libdir}/.debug/ \
"

RDEPENDS_${PN} += " \
	libcdk-audio \
"

