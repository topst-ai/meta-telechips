FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
		file://20200810.1-tcc-gstreamer1.0-plugins-bad-fix_segmentfault_broken_h264_file.patch \
		file://20200911.1-tcc-gstreamer1.0-plugins-bad-adpcmdec-don-t-check-blockalign.patch \
		file://20201019.1-tcc-gstreamer1.0-plugins-bad-modify-h265parse-and-h265codecparser.patch \
		file://20210222.1-tcc-gstreamer1.0-plugins-bad-h264parse-add-ring-mode-and-errorconcealment.patch \
"
PACKAGECONFIG = " \
    ${GSTREAMER_ORC} \
    ${@bb.utils.filter('DISTRO_FEATURES', 'vulkan', d)} \
    ${@bb.utils.filter('DISTRO_FEATURES', 'wayland', d)} \
    bz2 closedcaption curl dash dtls hls rsvg sbc smoothstreaming sndfile \
    ttml uvch264 webp \
"

# for waylandsink
SRC_URI_append = " \
    ${@oe.utils.conditional('VIDEO_SINK', 'waylandsink', 'file://0101-waylandsink-Fix-xdg_shell-fullscreen-mode.patch', '', d)} \
    ${@oe.utils.conditional('VIDEO_SINK', 'waylandsink', 'file://0102-waylandsink-support-I420-format-for-dmabuf.patch', '', d)} \
    ${@oe.utils.conditional('VIDEO_SINK', 'waylandsink', 'file://0103-waylandsink-support-ivi-shell-interface.patch', '', d)} \
    ${@oe.utils.conditional('VIDEO_SINK', 'waylandsink', 'file://0201-waylandsink-Keep-per-display-wayland-buffer-caches.patch', '', d)} \
    ${@oe.utils.conditional('VIDEO_SINK', 'waylandsink', 'file://0202-waylandsink-use-GstMemory-instead-of-GstBuffer-for-cache-lookup.patch', '', d)} \
    ${@oe.utils.conditional('VIDEO_SINK', 'waylandsink', 'file://0203-waylandsink-Update-stale-GstBuffer-references-in-wayland-buffer-cache.patch', '', d)} \
"
DEPENDS += "${@oe.utils.conditional('VIDEO_SINK', 'waylandsink', 'wayland-ivi-extension', '', d)}"

CONFLICT_INVITE_PLATFORM = "${@oe.utils.conditional('VIDEO_SINK', 'waylandsink', 'support-4k-video', '', d)}"
