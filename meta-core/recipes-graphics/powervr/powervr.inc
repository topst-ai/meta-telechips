DESCRIPTION = "PowerVR GPU use modules"
LICENSE = "CLOSED"

inherit autotools-brokensep

# check mandatory features
DEPENDS += "libdrm patchelf-native"

PACKAGECONFIG ??= " \
	${@bb.utils.contains('DISTRO_FEATURES', 'wayland', '', \
		'egl gles opencl', d)} \
	${@bb.utils.filter('DISTRO_FEATURES', 'wayland vulkan', d)} \
"

PACKAGECONFIG[egl] = ",,"
PACKAGECONFIG[gles] = ",,"
PACKAGECONFIG[opencl] = ",,"
PACKAGECONFIG[wayland] = ",,wayland"
PACKAGECONFIG[vulkan] = ",,"

LINKER_HASH_STYLE = "sysv"

PROVIDES = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', '', \
        'virtual/egl virtual/libgles1 virtual/libgles2 virtual/mesa', d)} \
    opencl-headers \
    virtual/opencl-headers \
    virtual/opencl-icd \
"
S = "${WORKDIR}/git"

PACKAGES += " \
             pvr-firmware libpvr-telechips \
             libegl-telechips libegl-telechips-dev \
             libgles1-telechips libgles1-telechips-dev \
             libgles2-telechips libgles2-telechips-dev \
             libgles3-telechips-dev \
             libopencl-telechips libopencl-telechips-dev \
             libvulkan-telechips libvulkan-telechips-dev \
"

DM = ""
TA = ""
WS = "${@bb.utils.contains("DISTRO_FEATURES", "wayland", "lws-generic", "nullws", d)}"

python __anonymous() {
    modes = d.getVar("GPU_DRIVER_MODE", True)
    if not modes:
        return

    tunes = d.getVar("TUNE_FEATURES", True)
    if not tunes:
        return

    if bb.utils.contains('TUNE_FEATURES', 'aarch64', True, False, d):
        d.setVar("TA", "aarch64-linux-gnu")
    elif bb.utils.contains('TUNE_FEATURES', 'callconvention-hard', True, False, d):
        d.setVar("TA", "arm-linux-gnueabihf")
    else:
        d.setVar("TA", "arm-linux-gnueabi")

    d.setVar("DM", d.getVar("GPU_DRIVER_MODE", True))
}

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
	# copy header files
	if ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'false', 'true', d)}; then
		install -d ${D}/${includedir}/EGL
		install -m 644 ${S}/rogue/include/khronos/EGL/*		${D}${includedir}/EGL/
		install -d ${D}/${includedir}/GLES
		install -m 644 ${S}/rogue/include/khronos/GLES/*		${D}${includedir}/GLES
		install -d ${D}/${includedir}/GLES2
		install -m 644 ${S}/rogue/include/khronos/GLES2/*		${D}${includedir}/GLES2/
		install -d ${D}/${includedir}/GLES3
		install -m 644 ${S}/rogue/include/khronos/GLES3/*		${D}${includedir}/GLES3/
		install -d ${D}/${includedir}/KHR
		install -m 644 ${S}/rogue/include/khronos/KHR/*		${D}${includedir}/KHR/
	fi

	# Intall pre-built firmware
	install -d ${D}${base_libdir}/firmware
	install -m 644 ${S}/rogue/lib/${TA}/${WS}/${DM}/lib/firmware/* ${D}${base_libdir}/firmware/

	# Install pre-built libraries
	install -d ${D}${libdir}
	for x in ${S}/rogue/lib/${TA}/${WS}/${DM}/usr/lib/*.so*; do
		install -m 0755 $x ${D}${libdir}/
	done

	# Install EGL, GLES pkg-config files for nullws
        if ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'false', 'true', d)}; then
		install -d ${D}/${libdir}/pkgconfig
		cp ${WORKDIR}/pkgconfig/egl.pc                          ${D}/${libdir}/pkgconfig
		cp ${WORKDIR}/pkgconfig/glesv1_cm.pc                    ${D}/${libdir}/pkgconfig
		cp ${WORKDIR}/pkgconfig/glesv2.pc                       ${D}/${libdir}/pkgconfig
        fi


	if ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'true', 'false', d)}; then
		mv ${D}${libdir}/libGLESv1_CM_PVR_MESA.so			${D}${libdir}/libGLESv1_CM_PVR_MESA.so.1.1.0
		mv ${D}${libdir}/libGLESv2_PVR_MESA.so			${D}${libdir}/libGLESv2_PVR_MESA.so.2.0.0

		ln -sf libGLESv1_CM_PVR_MESA.so.1.1.0			${D}${libdir}/libGLESv1_CM_PVR_MESA.so.1
		ln -sf libGLESv1_CM_PVR_MESA.so.1			${D}${libdir}/libGLESv1_CM_PVR_MESA.so
		ln -sf libGLESv2_PVR_MESA.so.2.0.0			${D}${libdir}/libGLESv2_PVR_MESA.so.2
		ln -sf libGLESv2_PVR_MESA.so.2			${D}${libdir}/libGLESv2_PVR_MESA.so
	else
		mv ${D}${libdir}/libEGL.so			${D}${libdir}/libEGL.so.1.0.0
		mv ${D}${libdir}/libGLES_CM.so			${D}${libdir}/libGLES_CM.so.1.1.0
		mv ${D}${libdir}/libGLESv2.so			${D}${libdir}/libGLESv2.so.2.0.0

		ln -sf libEGL.so.1.0.0		${D}${libdir}/libEGL.so.1
		ln -sf libEGL.so.1			${D}${libdir}/libEGL.so
		ln -sf libGLES_CM.so.1.1.0		${D}${libdir}/libGLES_CM.so.1
		ln -sf libGLES_CM.so.1			${D}${libdir}/libGLES_CM.so
		ln -sf libGLES_CM.so.1.1.0      ${D}${libdir}/libGLESv1_CM.so.1.1.0
		ln -sf libGLESv1_CM.so.1.1.0        ${D}${libdir}/libGLESv1_CM.so.1
		ln -sf libGLESv1_CM.so.1        ${D}${libdir}/libGLESv1_CM.so
		ln -sf libGLESv2.so.2.0.0		${D}${libdir}/libGLESv2.so.2
		ln -sf libGLESv2.so.2			${D}${libdir}/libGLESv2.so
	fi

	if ${@bb.utils.contains('DISTRO_FEATURES', 'vulkan', 'true', 'false', d)}; then
		install -d ${D}/${includedir}/vulkan
		install -m 644 ${S}/rogue/include/khronos/vulkan/*		${D}${includedir}/vulkan/

		install -d ${D}${sysconfdir}/vulkan/icd.d
		install -m 644 ${S}/rogue/lib/${TA}/${WS}/${DM}/etc/vulkan/icd.d/icdconf.json	${D}${sysconfdir}/vulkan/icd.d/

		# Install pre-built libraries
		mv ${D}${libdir}/libVK_IMG.so ${D}${libdir}/libVK_IMG.so.1.2.170
		mv ${D}${libdir}/libvulkan.so ${D}${libdir}/libvulkan.so.1.2.170

		ln -sf libVK_IMG.so.1.2.170		${D}${libdir}/libVK_IMG.so.1
		ln -sf libVK_IMG.so.1		${D}${libdir}/libVK_IMG.so
		ln -sf libvulkan.so.1.2.170		${D}${libdir}/libvulkan.so.1
		ln -sf libvulkan.so.1		${D}${libdir}/libvulkan.so.0
		ln -sf libvulkan.so.1		${D}${libdir}/libvulkan.so

		ln -sf libvulkan.so.1.2.170		${D}${libdir}/libvulkan-1.so.1.2.170
		ln -sf libvulkan-1.so.1.2.170		${D}${libdir}/libvulkan-1.so.1
		ln -sf libvulkan-1.so.1		${D}${libdir}/libvulkan-1.so
	else
		rm -rf ${D}${libdir}/libVK_IMG.so ${D}${libdir}/libvulkan.so
	fi

	if ${@bb.utils.contains('INVITE_PLATFORM', 'opencl', 'true', 'false', d)}; then
		# Install OpenCL library, headers and icd
		install -d ${D}/${includedir}/CL
		install -m 644 ${S}/rogue/include/khronos/CL/*		${D}${includedir}/CL/

		install -d ${D}${sysconfdir}/OpenCL/vendors/
		install -m 644 ${S}/rogue/lib/${TA}/${WS}/${DM}/etc/OpenCL/vendors/IMG.icd	${D}${sysconfdir}/OpenCL/vendors/

		mv ${D}${libdir}/libPVROCL.so ${D}${libdir}/libPVROCL.so.1.0.0

		ln -sf libPVROCL.so.1.0.0		${D}${libdir}/libPVROCL.so.1
		ln -sf libPVROCL.so.1		${D}${libdir}/libPVROCL.so
		ln -sf libPVROCL.so.1.0.0		${D}${libdir}/libOpenCL.so.1.0.0
		ln -sf libOpenCL.so.1.0.0		${D}${libdir}/libOpenCL.so.1
		ln -sf libOpenCL.so.1		${D}${libdir}/libOpenCL.so
	else
		rm -rf ${D}${libdir}/libPVROCL.so
	fi
}

# For the packages that make up the OpenGL interfaces, inject variables so that
# they don't get Debian-renamed (which would remove the -telechips suffix), and
# RPROVIDEs/RCONFLICTs on the generic libgl name.
python __anonymous() {
    pkgconfig = (d.getVar('PACKAGECONFIG', True) or "").split()
    for p in (("egl", "libegl", "libegl1"),
              ("dri", "libgl", "libgl1"),
              ("vulkan", "libvulkan", "libvulkan1"),
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

FILES_${PN} = ""
FILES_${PN}-dev = ""
FILES_pvr-firmware += " \
	${base_libdir}/firmware \
"
FILES_libpvr-telechips += " \
	${libdir}/libPVRScopeServices.so \
	${libdir}/libsutu_display.so \
	${libdir}/libufwriter.so \
	${libdir}/libsrv_um.so \
	${libdir}/libusc.so \
	${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		'${libdir}/libpvr_dri_support.so', \
		'${libdir}/libIMGegl.so ${libdir}/libpvrNULL_WSEGL.so', d)} \
"
FILES_libegl-telechips += " \
	${@bb.utils.contains('DISTRO_FEATURES', 'wayland', '', \
		'${libdir}/libEGL${SOLIBS}', d)} \
"
FILES_libgles1-telechips += " \
	${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		'${libdir}/libGLESv1_CM_PVR_MESA${SOLIBS}', \
		'${libdir}/libGLES_CM${SOLIBS} ${libdir}/libGLESv1_CM${SOLIBS}', d)} \
"
FILES_libgles2-telechips += " \
	${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		'${libdir}/libGLESv2_PVR_MESA${SOLIBS}', \
		'${libdir}/libGLESv2${SOLIBS}', d)} \
"
FILES_libegl-telechips-dev += " \
	${@bb.utils.contains('DISTRO_FEATURES', 'wayland', '', \
		'${includedir}/EGL ${includedir}/KHR ${libdir}/libEGL${SOLIBSDEV}', d)} \
"
FILES_libgles1-telechips-dev += " \
	${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		'${libdir}/libGLESv1_CM_PVR_MESA${SOLIBSDEV}', \
		'${includedir}/GLES ${libdir}/libGLES_CM${SOLIBSDEV} ${libdir}/libGLESv1_CM${SOLIBSDEV}', d)} \
"
FILES_libgles2-telechips-dev += " \
	${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		'${libdir}/libGLESv2_PVR_MESA${SOLIBSDEV}', \
		'${includedir}/GLES2 ${libdir}/libGLESv2${SOLIBSDEV}', d)} \
"
FILES_libgles3-telechips-dev += " \
	${@bb.utils.contains('DISTRO_FEATURES', 'wayland', '', '${includedir}/GLES3', d)} \
"
FILES_libopencl-telechips += " \
	${@bb.utils.contains('INVITE_PLATFORM', 'opencl', \
		'${libdir}/libOpenCL${SOLIBS} ${libdir}/libPVROCL${SOLIBS} ${sysconfdir}/OpenCL/vendors/IMG.icd ', \
		'', d)} \
"
FILES_libvulkan-telechips += " \
	${@bb.utils.contains('DISTRO_FEATURES', 'vulkan', \
		'${libdir}/libVK_IMG${SOLIBS} ${libdir}/libvulkan${SOLIBS} ${libdir}/libvulkan-1${SOLIBS} ${sysconfdir}/vulkan/icd.d/icdconf.json', \
		'', d)} \
"
FILES_libopencl-telechips-dev += " \
	${@bb.utils.contains('INVITE_PLATFORM', 'opencl', \
		'${libdir}/libOpenCL${SOLIBSDEV} ${libdir}/libPVROCL${SOLIBSDEV} ${includedir}/CL', \
		'', d)} \
"
FILES_libvulkan-telechips-dev += " \
	${@bb.utils.contains('DISTRO_FEATURES', 'vulkan', \
		'${libdir}/libVK_IMG${SOLIBSDEV} ${libdir}/libvulkan${SOLIBSDEV} ${libdir}/libvulkan-1${SOLIBSDEV} ${includedir}/vulkan', \
		'', d)} \
"


RDEPENDS_libpvr-telechips += " \
	pvr-firmware \
"
RDEPENDS_libegl-telechips += " \
	libpvr-telechips \
"
RDEPENDS_libgles1-telechips += " \
	${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		'libpvr-telechips', 'libegl-telechips', d)} \
"
RDEPENDS_libgles2-telechips += " \
	${@bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		'libpvr-telechips', 'libegl-telechips', d)} \
"
RDEPENDS_libvulkan-telechips += " \
	libpvr-telechips \
"
RDEPENDS_libopencl-telechips += " \
	libpvr-telechips \
"
RDEPENDS_libegl-telechips-dev += " \
	libegl-telechips \
"
RDEPENDS_libgles1-telechips-dev += " \
	libgles1-telechips \
"
RDEPENDS_libgles2-telechips-dev += " \
	libgles2-telechips \
"
RDEPENDS_libopencl-telechips-dev += " \
	libopencl-telechips \
"
RDEPENDS_libvulkan-telechips-dev += " \
	libvulkan-telechips \
"
RPROVIDES_libvulkan-telechips += " \
	vulkan-loader \
"

# Add .so to runtime package for fbdev opengl apps
FILES_libegl-telechips += " \
	${@bb.utils.contains('DISTRO_FEATURES', 'wayland', '', \
		'${libdir}/libEGL.so ${libdir}/pkgconfig/egl.pc', d)} \
"

FILES_libgles1-telechips += " \
	${@bb.utils.contains('DISTRO_FEATURES', 'wayland', '', \
		'${libdir}/libGLES_CM.so ${libdir}/libGLESv1_CM.so ${libdir}/pkgconfig/glesv1_cm.pc', d)} \
"

FILES_libgles2-telechips += " \
	${@bb.utils.contains('DISTRO_FEATURES', 'wayland', '', \
		'${libdir}/libGLESv2.so ${libdir}/pkgconfig/glesv2.pc', d)} \
"

DEBIAN_NOAUTONAME_libopencl-telechips = "1"
DEBIAN_NOAUTONAME_libopencl-telechips-dev = "1"

INSANE_SKIP_${PN}_append = "already-stripped"
INSANE_SKIP_libegl-telechips_append = "dev-so"
INSANE_SKIP_libgles1-telechips_append = "dev-so"
INSANE_SKIP_libgles2-telechips_append = "dev-so"
