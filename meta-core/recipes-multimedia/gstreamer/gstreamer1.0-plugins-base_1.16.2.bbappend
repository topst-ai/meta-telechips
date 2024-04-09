FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
		file://20200324.1-tcc-gstreamer1.0-plugins-base-riff-parser-can-create-flac-and-h265-decode-caps.patch \
		file://20200512.1-tcc-gstreamer1.0-plugins-base-Create-allocate-output-function-to-prevent-segment-fault.patch \
		file://20200512.2-tcc-gstreamer1.0-plugins-base-add-Telechips-platform-specific-codec-and-support-ringmode.patch \
		file://20200720.1-tcc-gstreamer1.0-plugins-base-Use-telechips-mp4-demux-when-the-audio-is-PCM.patch \
		file://20200720.2-tcc-gstreamer1.0-plugins-base-add-case-to-use-telechips-mp4-demux.patch \
		file://20200910.1-tcc-gstreamer1.0-plugins-base-playbin-disable-text-play.patch \
		file://20200915.1-tcc-gstreamer1.0-plugins-base-audiodecoder-correct-timestamp.patch \
		file://20200923.1-tcc-gstreamer1.0-plugins-base-add-tc-format-to-video-meta.patch \
		file://20201012.1-tcc-gstreamer1.0-plugins-base-allocator-check-memory-type-instread-of-allocator-type.patch \
		file://20201012.2-tcc-gstreamer1.0-plugins-base-riff-case-of-motion-jpeg-and-still-image-jpeg-us.patch \
		file://20201019.1-tcc-gstreamer1.0-plugins-base-decodebin2-set-multiqueue-buffering-size-bigger-and-longer.patch \
		file://20201201.1-tcc-gstreamer1.0-plugins-base-audio_buffer_acquire_guard.patch \
		file://20210204.1-tcc-gstreamer1.0-plugins-base-videodecoder-if-pts-is-invalid-use-dts-data.patch \
		file://20210518.1-tcc-gstreamer1.0-plugins-base-video-format-add-gst_video_format_info_component.patch \
		file://20210518.2-tcc-gstreamer1.0-plugins-base-video-info-add-gst_video_info_align_full.patch \
		file://20210518.3-tcc-gstreamer1.0-plugins-base-videometa-add-alignment-field.patch \
		file://20210809.1-tcc-gstreamer1.0-plugins-base-add-tc-parameter-for-using-dma-buf.patch \
		file://20210817.1-tcc-gstreamer1.0-plugins-base-riff-use-channel-information-for-adpcm.patch \
		file://20220321.1-tcc-gstreamer1.0-plugins-base-id3v2frame-fix-check-current-frame-data-size-too.patch \
"
# for tc-dma-buf
SRC_URI_append = " \
    ${@oe.utils.conditional('VIDEO_SINK', 'waylandsink', 'file://20201130.1-tcc-gstreamer1.0-plugins-base-riff-high-resolution-jpeg-stream-is-decoded-by-JPU.patch', '', d)} \
"

ADD_INCLUDE_PATH = " \
	-I${STAGING_KERNEL_DIR}/${KERNEL_MACH_PATH}/include \
	-I${STAGING_KERNEL_DIR}/include/video/tcc \
"
CFLAGS_append = " ${ADD_INCLUDE_PATH}"
