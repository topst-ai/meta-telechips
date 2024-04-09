FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	${@bb.utils.contains('INVITE_PLATFORM', 'ivi-extension', 'file://weston.ivi.ini', 'file://weston.desktop.ini', d)} \
	${@bb.utils.contains("DISTRO_FEATURES", 'x11', 'file://weston.xwayland.ini', '', d)} \
	file://background.png \
	file://0001-Define-K_OFF-if-it-isn-t-defined-already.patch \
	file://0002-backend-drm-disable-bo-geometry-out-of-bounds-messag.patch \
	file://0003-meson-fix-failure-to-find-libudev-when-linking-the-c.patch \
	file://0004-tests-add-wayland-client-dep-to-test-runner-lib.patch \
	file://0005-shared-fix-implicit-declaration-of-mmap-warning.patch \
	file://0006-shared-exclude-sealing-code-if-no-memfd_create.patch \
    file://0007-Add-setGeometry-handling-function.patch \
    file://0008-gl-renderer-update-logic-for-dmabuf.patch \
    file://0009-enable-background-alpha-blending.patch \
    file://0010-Fix-QAC-step3-diagnostic-results-on-weston.patch \
    file://0011-Fix-Codesonar-step3-warnings-on-weston.patch \
"

REQUIRED_DISTRO_FEATURES = "wayland"

KMS = "${@bb.utils.contains("INVITE_PLATFORM", 'drm', 'kms', '', d)}"
EGL = "${@bb.utils.contains("DISTRO_FEATURES", 'opengl', 'egl', '', d)}"

PACKAGECONFIG = " \
        ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', '${KMS} fbdev wayland ${EGL}', '', d)}\
        ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'x11 xwayland', '', d)} \
        ${@bb.utils.contains('DISTRO_FEATURES', 'pam', 'pam', '', d)} \
        ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd', '', d)} \
		clients \
		launch \
		image-jpeg \
		screenshare \
		shell-desktop \
		shell-fullscreen \
		shell-ivi \
		"


EXTRA_OECONF += " \
	${@bb.utils.contains('INVITE_PLATFORM', 'drm', '', 'WESTON_NATIVE_BACKEND=fbdev-backend.so', d)} \
"

do_install_append() {
	install -d ${D}/${datadir}
	install -d ${D}/${datadir}/weston
	if ${@bb.utils.contains("DISTRO_FEATURES", 'x11', 'true', 'false', d)}; then
		install -m 0644 ${WORKDIR}/weston.xwayland.ini ${D}${datadir}/weston/weston.ini
	else
		if ${@bb.utils.contains("INVITE_PLATFORM", 'ivi-extension', 'true', 'false', d)}; then
			install -m 0644 ${WORKDIR}/weston.ivi.ini ${D}${datadir}/weston/weston.ini
		else
			install -m 0644 ${WORKDIR}/weston.desktop.ini ${D}${datadir}/weston/weston.ini
			install -m 0644 ${WORKDIR}/background.png ${D}${datadir}/weston
		fi
	fi
}

FILES_${PN} += "${datadir} ${sysconfdir}"
FILES_${PN}-dbg += "${libdir}/libweston-1/.debug/*.so"
