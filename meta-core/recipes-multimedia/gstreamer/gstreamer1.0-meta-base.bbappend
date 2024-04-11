DEPENDS_append  = " gstreamer1.0-plugins-telechips gstreamer1.0-omx"

PACKAGES += "gstreamer1.0-meta-extra"
ALLOW_EMPTY_gstreamer1.0-meta-extra = "1"

RDEPENDS_gstreamer1.0-meta-base = "\
	gstreamer1.0 \
    gstreamer1.0-plugins-good-autodetect \
	gstreamer1.0-plugins-base-playback \
	gstreamer1.0-plugins-base-alsa \
	gstreamer1.0-plugins-base-volume \
	gstreamer1.0-plugins-base-audioconvert \
	gstreamer1.0-plugins-base-audioresample \
	gstreamer1.0-plugins-base-typefindfunctions \
	gstreamer1.0-omx \
	gstreamer1.0-plugins-telechips-tcdemux \
"
RDEPENDS_gstreamer1.0-meta-base += "\
	gstreamer1.0-plugins-base-videoscale \
	gstreamer1.0-plugins-base-videoconvert \
	gstreamer1.0-plugins-base-subparse \
	gstreamer1.0-plugins-base-ogg \
	gstreamer1.0-plugins-bad-mpegtsdemux \
	gstreamer1.0-plugins-bad-sbc \
	gstreamer1.0-plugins-bad-bz2 \
	gstreamer1.0-plugins-bad-curl \
	gstreamer1.0-plugins-bad-smoothstreaming \
	gstreamer1.0-plugins-good-matroska \
	gstreamer1.0-plugins-good-avi \
	gstreamer1.0-plugins-bad-hls \
	gstreamer1.0-plugins-base-apps \
"

RDEPENDS_gstreamer1.0-meta-audio = "\
	gstreamer1.0-meta-base \
	gstreamer1.0-plugins-base-vorbis \
	gstreamer1.0-plugins-bad-adpcmdec \
	gstreamer1.0-plugins-good-id3demux \
	gstreamer1.0-plugins-good-apetag \
	gstreamer1.0-plugins-good-audioparsers \
	gstreamer1.0-plugins-good-wavparse \
	${@bb.utils.contains('DISTRO_FEATURES', 'pulseaudio', 'gstreamer1.0-plugins-good-pulse', '', d)} \
	${COMMERCIAL_AUDIO_PLUGINS} \
"

RDEPENDS_gstreamer1.0-meta-video = "\
	gstreamer1.0-meta-base \
	gstreamer1.0-plugins-bad-videoparsersbad \
	gstreamer1.0-plugins-good-video4linux2 \
	gstreamer1.0-plugins-good-isomp4 \
	gstreamer1.0-plugins-base-app \
	gstreamer1.0-plugins-base-pango \
	gstreamer1.0-plugins-good-souphttpsrc \
	gstreamer1.0-plugins-good-icydemux \
	${COMMERCIAL_VIDEO_PLUGINS} \
"

RDEPENDS_gstreamer1.0-meta-extra += "\
	gstreamer1.0-plugins-good-taglib \
	gstreamer1.0-plugins-good-rtpmanager \
	gstreamer1.0-plugins-good-mulaw \
	gstreamer1.0-plugins-good-alaw \
	gstreamer1.0-plugins-good-gdkpixbuf \
	gstreamer1.0-plugins-good-udp \
	gstreamer1.0-plugins-good-speex \
	gstreamer1.0-plugins-good-jpeg \
	gstreamer1.0-plugins-good-png \
	gstreamer1.0-plugins-good-rtp \
	gstreamer1.0-plugins-good-rtsp \
"
RDEPENDS_gstreamer1.0-meta-video += "${@oe.utils.conditional('VIDEO_SINK', 'waylandsink', 'gstreamer1.0-plugins-bad-waylandsink', '',d)}"
