FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
		file://20200324.1-tcc-gstreamer1.0-plugins-good-add-depth-in-flacparser-caps.patch \
		file://20200324.2-tcc-gstreamer1.0-plugins-good-can-skip-dummydata-in-ac3parser.patch \
		file://20200512.1-tcc-gstreamer1.0-plugins-good-modify-avidemux-pts-vbraudio-vorbis-avcc.patch \
		file://20200520.1-tcc-gstreamer1.0-plugins-good-modify-qtdemux-ctts.patch \
		file://20200618.1-tcc-gstreamer1.0-plugins-good-v4l2sink-support-telechips-format.patch \
		file://20200618.2-tcc-gstreamer1.0-plugins-good-v4l2sink-support-aspectratio.patch \
		file://20200720.1-tcc-gstreamer1.0-plugins-good-flacparse-Modify-don-t-push-meta-data-to-input-framedata.patch \
		file://20200812.1-tcc-gstreamer1.0-plugins-good-mpegaudioparse-Modify-search-next-framedata-qtdemux-add-flac-fourcc.patch \
		file://20210120.1-tcc-gstreamer1.0-plugins-good-v4l2sink-use-delay-property.patch \
		file://20210203.1-tcc-gstreamer1.0-plugins-good-qtdemux-use-JPU-for-jpeg-decoding.patch \
		file://20210420.1-tcc-gstreamer1.0-plugins-good-qtdemux-use-dts-for-video-and-audio.patch \
		file://20210430.1-tcc-gstreamer1.0-plugins-good-v4l2sink-re-check-tc-decoder-connected-and-add-code-for-tc-video-meta.patch \
		file://20210818.1-tcc-gstreamer1.0-plugins-good-amrparse-add-code-for-search-valid-data.patch \
		file://20211001.1-tcc-gstreamer1.0-plugins-good-v4l2sink-need-codec-type-for-mapconverter.patch \
		file://20211130.1-tcc-gstreamer1.0-plugins-good-v4l2sink-dont-use-map-convert-define.patch \
		file://20220321.1-tcc-gstreamer1.0-plugins-good-wavparse-guard-against-overflow-when-comparing-chunk-sizes.patch \
		file://20220321.2-tcc-gstreamer1.0-plugins-good-wavparse-clean-up-adtl-note-labl-chunk-parsing.patch \
		file://20220321.3-tcc-gstreamer1.0-plugins-good-fix-wavparse-check-null-buffer-at-gst_wavparse_cue_c.patch \
"
# for tc-dma-buf
SRC_URI_append = " \
    ${@oe.utils.conditional('VIDEO_SINK', 'waylandsink', 'file://20201005.1-tcc-gstreamer1.0-plugins-good-v4l2sink-temp-n-plane-set-1.patch', '', d)} \
"

DEPENDS += "linux-telechips"

ADD_INCLUDE_PATH = " \
	-I${STAGING_KERNEL_DIR}/${KERNEL_MACH_PATH}/include \
	-I${STAGING_KERNEL_DIR}/include/video/tcc \
	-I${STAGING_KERNEL_BUILDDIR}/include \
"

EXTRA_OECONF += "PROCESSOR=${TCC_ARCH_FAMILY}"

CFLAGS_append = " ${ADD_INCLUDE_PATH}"
CFLAGS_append = " -DTCC_V4L2SINK_DRIVER_USE"
