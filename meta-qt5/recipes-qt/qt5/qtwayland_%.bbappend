FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# matching for /usr/include/EGL/eglplatform.h
QT_WAYLAND_DEFINES = "WL_EGL_PLATFORM"

# You must to add below patch file when using QML application.
# For more information, please refer to below site.
# If you apply below patch file you can't use a few Qt controls base on QWidget.
# It is Qt 5.6 bugs
# If you want to use QWidget together QML, you must use commercial Qt(after v5.8)
# https://codereview.qt-project.org/#/c/176254
# file://0103-Create-and-destroy-the-shell-surface-when-showing-an.patch \
#
SRC_URI += " \
	file://0101-Add-setGeometry-interface.patch \
	file://0102-Check-surface-exists-when-setting-textinput-focus.patch \
	${@bb.utils.contains("INVITE_PLATFORM", 'ivi-extension', 'file://0201-Implement-initial-IVI-Shell-support.patch', '', d)} \
	${@bb.utils.contains("INVITE_PLATFORM", 'ivi-extension', 'file://0202-add-support-for-IVI-Surface-ID-property.patch', '', d)} \
"

SRC_URI_append_tcc897x = " \
	file://0103-Create-and-destroy-the-shell-surface-when-showing-an.patch \
	file://0104-upg-Update-qtwayland-to-prevent-null-pointer-excepti.patch \
"
