FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    ${@oe.utils.conditional('TCC_ARCH_FAMILY', 'tcc805x', 'file://0001-ref-pp125085.eglfs_pvr.Qt5.6.3.patch.patch', '', d)} \
    ${@oe.utils.conditional('TCC_ARCH_FAMILY', 'tcc803x', 'file://0101-change-native-window-type-for-mali-bifrost.patch', '', d)} \
"

# change opengl option
PACKAGECONFIG_GL = "${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'gles2', '', d)}"
PACKAGECONFIG_X11 = "${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'xcb xvideo xsync xshape xrender xrandr xfixes xinput2 xinput xinerama xcursor glib xkb', '', d)}"

# accessibility is required to compile qtquickcontrols
PACKAGECONFIG_DEFAULT_append = " alsa glib sql-sqlite accessibility freetype fontconfig xkbcommon-evdev"
PACKAGECONFIG_DEFAULT_append = " ${@bb.utils.contains("DISTRO_FEATURES", "wayland", "mtdev libinput libproxy", "", d)}"

PACKAGECONFIG_append = " ${@bb.utils.contains("ADDITIONAL_QT5_MODULES", "qtwebkit", "icu", "", d)}"
PACKAGECONFIG_append = " eglfs"
PACKAGECONFIG_append = " examples"

QPA_PLATFORM = "${@bb.utils.contains('INVITE_PLATFORM', 'qt5/wayland', 'wayland', \
				bb.utils.contains('INVITE_PLATFORM', 'qt5/eglfs', 'eglfs', 'linuxfb', d), d)} \
"

QT_CONFIG_FLAGS += "-qpa ${QPA_PLATFORM}"
