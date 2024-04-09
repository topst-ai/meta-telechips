FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://20200611.1-tcc-gstreamer1.0-omx-add-telechips-audio-codec.patch \
	file://20200622.1-tcc-gstreamer1.0-omx-add-telechips-video-codec.patch \
	file://20200702.1-tcc-gstreamer1.0-omx-modify-h265dec-sinkcaps-add-flushed.patch \
	file://20200720.1-tcc-gstreamer1.0-omx-videodec-add-specout-return.patch \
	file://20200810.1-tcc-gstreamer1.0-omx-add-telechips-videodec-property.patch \
	file://20200812.1-tcc-gstreamer1.0-omx-set-can-support-resolution-video-size.patch \
	file://20200813.1-tcc-gstreamer1.0-omx-remove-licence-codec-at-default-setting.patch \
	file://20200915.1-tcc-gstreamer1.0-omx-omxaudiodec-set-output-timestamp.patch \
	file://20201012.1-tcc-gstreamer1.0-omx-change-mjpeg-mimetype-to-video-x-jpeg-for-distinguish-image-jpeg.patch \
	file://20201019.1-tcc-gstreamer1.0-omx-add-omxvideodec-ringmode.patch \
	file://20201201.1-tcc-gstreamer1.0-omx-add_clear_error_state.patch \
	file://20201201.2-tcc-gstreamer1.0-omx-modify-wmv-hack-remove-no-empty-eos-buffer.patch \
	file://20210209.1-tcc-gstreamer1.0-omx-add-omxh264enc.patch \
	file://20210225.1-tcc-gstreamer1.0-omx-omxvideodec-add-sinkevent.patch \
	file://20210225.2-tcc-gstreamer1.0-omx-omxaudiodec-omxvideodec-prevent-seek-dead-lock.patch \
	file://20210316.1-tcc-gstreamer1.0-omx-omxvideodec-use-omxbufferpool-for-avsync.patch \
	file://20210518.1-tcc-gstreamer1.0-omx-omxbufferpool-dont-need-copy-set.patch \
	${@bb.utils.contains_any('TCC_ARCH_FAMILY', 'tcc897x', '', '${WAYLAND_SINK_PATCH}', d)} \
	file://20210929.1-tcc-gstreamer1.0-omx-omxvideodec-set-output-pts-if-frame-pts-is-null.patch \
	file://20211104.1-tcc-gstreamer1.0-omx-add-code-for-divx-enable.patch \
	file://20211122.1-tcc-gstreamer1.0-omx-fix-multi-audio-decoding-to-play.patch \
"

WAYLAND_SINK_PATCH = " \
	file://20210430.1-tcc-gstreamer1.0-omx-support-tc-dmabuf.patch \
	file://20210809.1-tcc-gstreamer1.0-omx-vpudmabuf-remove-unused-code-for-better-readablity.patch \
"

GSTREAMER_1_0_OMX_TARGET = "bellagio"
GSTREAMER_1_0_OMX_CORE_NAME = "${libdir}/libomxil-tcc.so.0"

DEPENDS += "virtual/kernel"
RDEPENDS_${PN} = "libomxil-telechips"

set_omx_core_name() {
	sed -i -e "s;^core-name=.*;core-name=${GSTREAMER_1_0_OMX_CORE_NAME};" "${D}${sysconfdir}/xdg/gstomx.conf"
}

ADD_INCLUDE_PATH = " \
	-I${STAGING_KERNEL_DIR}/${KERNEL_MACH_PATH}/include \
	-I${STAGING_KERNEL_DIR}/include/video/tcc \
	-I${STAGING_KERNEL_BUILDDIR}/include \
"

EXTRA_OECONF += "${EXTRA_OMX_MACHINE_CONF}"
EXTRA_OECONF += "PROCESSOR=${TCC_ARCH_FAMILY}"

CFLAGS_append = " ${ADD_INCLUDE_PATH}"
CFLAGS_append = " -D${GST_ARCH_FAMILY_NAME}_INCLUDE"
#CFLAGS_append = " -DSUPPORT_HIGHBPS_OUTPUT"
CFLAGS_append = " ${@bb.utils.contains('INVITE_PLATFORM', 'support-4k-video', '-DSUPPORT_4K_VIDEO', '', d)}"
