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
	${GST_DEP_PACKAGES} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'opengl', '${OPENGL_DEP_PACKAGES}', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', '${WAYLAND_DEP_PACKAGES}', '', d)} \
"

GPU_WAYLAND_DEP_PACKAGES = " \
	${@bb.utils.contains('INVITE_PLATFORM', 'telechips-egl', 'libegl-telechips-dev', 'libegl-mesa-dev', d)} \
	${@bb.utils.contains('INVITE_PLATFORM', 'telechips-egl', 'libgles1-telechips-dev', 'libgles1-mesa-dev', d)} \
	${@bb.utils.contains('INVITE_PLATFORM', 'telechips-egl', 'libgles2-telechips-dev', 'libgles2-mesa-dev', d)} \
	libgbm-dev \
"
GPU_WAYLAND_DEP_PACKAGES_append_armv8a = " \
	${@bb.utils.contains('INVITE_PLATFORM', 'telechips-egl', 'libgles3-telechips-dev', 'libgles3-mesa-dev', d)} \
"

GPU_EGL_DEP_PACKAGES = " \
	libegl-telechips-dev \
	libgles1-telechips-dev \
	libgles2-telechips-dev \
"

GPU_EGL_DEP_PACKAGES_append_armv8a = " \
	${@bb.utils.contains('INVITE_PLATFORM', 'telechips-egl', 'libgles3-telechips-dev', 'libgles3-mesa-dev', d)} \
"

OPENGL_DEP_PACKAGES = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', '${GPU_WAYLAND_DEP_PACKAGES}', '${GPU_EGL_DEP_PACKAGES}', d)} \
"

GST_DEP_PACKAGES = " \
	alsa-dev \
	orc-dev \
	libogg-dev \
	libtheora-dev \
	libvorbis-dev \
	pango-dev \
	libcap-dev \
	cairo-dev \
	flac-dev \
	gdk-pixbuf-dev \
	libpng-dev \
	libsoup-2.4-dev \
	speex-dev \
	curl-dev \
	neon-dev \
	sbc-dev \
	libxml2-dev \
	bzip2-dev \
	librsvg-dev \
	libsndfile1-dev \
	liba52-dev \
"

WAYLAND_DEP_PACKAGES = " \
	libdrm-dev \
	wayland-dev \
	weston-dev \
"
