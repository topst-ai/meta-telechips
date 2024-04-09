SUMMARY = "Telechips EGL library"
DESCRIPTION = "GLES libraries for telechips SoCs for a family of Mali GPU"
HOMEPAGE = "http://www.telechips.com"
SECTION = "libs"
LICENSE = "ARM"
LIC_FILES_CHKSUM = "file://${COREBASE}/../meta-telechips/meta-core/licenses/ARM;md5=75b66ff7a76b0f648ed1db4b275073a3"

DEPENDS += "patchelf-native"
DEPENDS += "${@bb.utils.contains('INVITE_PLATFORM', 'drm', 'libdrm', '', d)}"

PROVIDES += "virtual/egl virtual/libgles1 virtual/libgles2 virtual/libgbm virtual/mesa"
PROVIDES += "${@bb.utils.contains("DISTRO_FEATURES", "wayland", " virtual/libwayland-egl", " ", d)}"

inherit gettext features_check invite_platform_check

# check chipset
COMPATIBLE_MACHINE = "(.*)"

# check mandatory features
REQUIRED_DISTRO_FEATURES = "opengl"
REQUIRED_INVITE_PLATFORM += "telechips-egl"
REQUIRED_INVITE_PLATFORM += "${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'drm', '', d)}"

# check conflict features when using arm
CONFLICT_INVITE_PLATFORM += "${@bb.utils.contains('DISTRO_FEATURES', 'wayland', '', 'drm', d)}"

PACKAGECONFIG ??= "egl gles \
		${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'wayland', '', d)}\
		"

PACKAGECONFIG[egl] = ",,"
PACKAGECONFIG[gles] = ",,"
PACKAGECONFIG[wayland] = ",,wayland"

S = "${WORKDIR}/git"

PACKAGES = " libmali-telechips \
             libegl-telechips libegl-telechips-dev \
             libgles1-telechips libgles1-telechips-dev \
             libgles2-telechips libgles2-telechips-dev \
             libgles3-telechips-dev \
             libwayland-egl libwayland-egl-dev \
             libgbm libgbm-dev \
"

USE_WL = "${@bb.utils.contains("DISTRO_FEATURES", "wayland", "yes", "no", d)}"

MALI_TOOLCHAIN = ""
MALI_NAME = ""

MALI_WAYLAND_tcc803x = "libmali-bifrost-g51-r30p0-wayland.so"
MALI_FBDEV_tcc803x = "${@oe.utils.conditional('TCC_MACHINE_FAMILY', 'tcc803x-sub',\
						  'libmali-bifrost-g51-r30p0-fbdev-full-strip.so',\
						  'libmali-bifrost-g51-r30p0-fbdev.so', d)}"

MALI_SUPPORT_GLES3_tcc803x = "1"

MALI_WAYLAND_tcc897x = "libmali-utgard-400-r9p0-wayland.so"
MALI_FBDEV_tcc897x = "libmali-utgard-400-r9p0-fbdev.so"

python __anonymous() {
    tunes = d.getVar("TUNE_FEATURES", True)
    if not tunes:
        return

    if bb.utils.contains('TUNE_FEATURES', 'aarch64', True, False, d):
        d.setVar("MALI_TOOLCHAIN", "aarch64-none-linux-gnu")
    else:
        d.setVar("MALI_TOOLCHAIN", "arm-none-linux-gnueabihf")

    use_wayland = d.getVar("USE_WL", True)
    if use_wayland == "yes":
        d.setVar("MALI_NAME", d.getVar("MALI_WAYLAND", True))
    else:
        d.setVar("MALI_NAME", d.getVar("MALI_FBDEV", True))
}

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"
INHIBIT_SYSROOT_STRIP = "1"

do_preconfigure[noexec] = "1"
do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
	# copy header files
	install -d ${D}/${includedir}
	cp -ap ${S}/include/EGL				${D}${includedir}
	cp -ap ${S}/include/GLES			${D}${includedir}
	cp -ap ${S}/include/GLES2			${D}${includedir}
	if [ "${MALI_SUPPORT_GLES3}" = "1" ]; then
		cp -ap ${S}/include/GLES3		${D}${includedir}
	fi
	cp -ap ${S}/include/KHR				${D}${includedir}
	cp -ap ${S}/include/gbm.h			${D}${includedir}

	# Create MALI manifest
	install -m 755 -d ${D}/${libdir}
	install ${S}/lib/${MALI_TOOLCHAIN}/${MALI_NAME} ${D}/${libdir}/libMali.so


	ln -sf libMali.so ${D}/${libdir}/libEGL.so
	ln -sf libMali.so ${D}/${libdir}/libEGL.so.1
	ln -sf libMali.so ${D}/${libdir}/libGLESv1_CM.so
	ln -sf libMali.so ${D}/${libdir}/libGLESv1_CM.so.1
	ln -sf libMali.so ${D}/${libdir}/libGLESv2.so
	ln -sf libMali.so ${D}/${libdir}/libGLESv2.so.2
	ln -sf libMali.so ${D}/${libdir}/libgbm.so
	ln -sf libMali.so ${D}/${libdir}/libgbm.so.1

	if [ "${USE_WL}" = "yes" ]; then
		ln -sf libMali.so ${D}/${libdir}/libwayland-egl.so.1
		ln -sf libwayland-egl.so.1 ${D}/${libdir}/libwayland-egl.so
	fi

	# copy pkgconfig files
	install -d ${D}${libdir}/pkgconfig
	cp -ap ${S}/pkgconfig/*.pc			${D}/${libdir}/pkgconfig

	if [ "${USE_WL}" = "yes" ]; then
		cd ${D}${libdir}/pkgconfig/
		sed -i "s/^Libs:/Libs:-lwayland-client -lwayland-server /" wayland-egl.pc
	fi
	# Workaround: libMali.so provided by tcc having no SONAME field in itroot
	# so add it to fix rdepends problems
	patchelf --set-soname "libMali.so" ${D}/${libdir}/libMali.so
}

# For the packages that make up the OpenGL interfaces, inject variables so that
# they don't get Debian-renamed (which would remove the -telechips suffix), and
# RPROVIDEs/RCONFLICTs on the generic libgl name.
python __anonymous() {
    pkgconfig = (d.getVar('PACKAGECONFIG', True) or "").split()
    for p in (("egl", "libegl", "libegl1"),
              ("dri", "libgl", "libgl1"),
              ("gles", "libgles1", "libglesv1-cm1"),
              ("gles", "libgles2", "libglesv2-2"),
              ("gles", "libgles3",)):
        if not p[0] in pkgconfig:
            continue
        fullp = p[1] + "-telechips"
        pkgs = " ".join(p[1:])
        d.setVar("DEBIAN_NOAUTONAME_" + fullp, "1")
        d.appendVar("RREPLACES_" + fullp, pkgs)
        d.appendVar("RPROVIDES_" + fullp, pkgs)
        d.appendVar("RCONFLICTS_" + fullp, pkgs)

        # For -dev, the first element is both the Debian and original name
        fullp += "-dev"
        pkgs = p[1] + "-dev"
        d.setVar("DEBIAN_NOAUTONAME_" + fullp, "1")
        d.appendVar("RREPLACES_" + fullp, pkgs)
        d.appendVar("RPROVIDES_" + fullp, pkgs)
        d.appendVar("RCONFLICTS_" + fullp, pkgs)
}

RDEPENDS_libmali-telechips += " \
        libgles2-telechips \
        libgles1-telechips \
        ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'libwayland-egl libgbm', '', d)} \
"
RDEPENDS_libgles1-telechips += " \
        libegl-telechips \
"
RDEPENDS_libgles2-telechips += " \
        libegl-telechips \
"
# as long as there is no libgles3-telechips: ship libgles3-telechips-dev along with
# libgles2-telechips-dev - otherwise GLES3 headers have to be added manually
RDEPENDS_libgles2-telechips-dev_tcc803x += "libgles3-telechips-dev"

LINKER_HASH_STYLE = "sysv"

FILES_libmali-telechips = "${libdir}/libMali.so"
INSANE_SKIP_libmali-telechips += "already-stripped ldflags dev-so"

FILES_libegl-telechips = "${libdir}/libEGL.so*"
FILES_libgbm = "${libdir}/libgbm.so*"
FILES_libgles1-telechips = "${libdir}/libGLESv1*.so*"
FILES_libgles2-telechips = "${libdir}/libGLESv2.so*"
FILES_libwayland-egl = "${libdir}/libwayland-egl.so*"

FILES_libegl-telechips-dev = "${libdir}/libEGL.* ${includedir}/EGL ${includedir}/KHR ${libdir}/pkgconfig/egl.pc ${libdir}/pkgconfig/mali.pc"
FILES_libgbm-dev = "${libdir}/libgbm.* ${includedir}/gbm.h ${libdir}/pkgconfig/gbm.pc"
FILES_libgles1-telechips-dev = "${libdir}/libGLESv1*.* ${includedir}/GLES ${libdir}/pkgconfig/glesv1*.pc"
FILES_libgles2-telechips-dev = "${libdir}/libGLESv2.* ${includedir}/GLES2 ${libdir}/pkgconfig/glesv2.pc"
FILES_libgles3-telechips-dev = "${includedir}/GLES3"
FILES_libwayland-egl-dev = "${libdir}/libwayland-egl.* ${libdir}/pkgconfig/wayland-egl*.pc"

INSANE_SKIP_libegl-telechips += "already-stripped ldflags dev-so"
INSANE_SKIP_libgbm += "already-stripped ldflags dev-so"
INSANE_SKIP_libgles1-telechips += "already-stripped ldflags dev-so"
INSANE_SKIP_libgles2-telechips += "already-stripped ldflags dev-so"
INSANE_SKIP_libwayland-egl += "already-stripped ldflags dev-so"
