DESCRIPTION = "PowerVR OpenGL ES sample applications"
SECTION = "applications"
LICENSE = "CLOSED"

SRC_URI = "file://gles-samples.tar.gz"

# check mandatory features
REQUIRED_DISTRO_FEATURES = "opengl"

# check conflict features when using arm
CONFLICT_DISTRO_FEATURES += "wayland"

inherit features_check

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
	install -d 	${D}${bindir}
	install -d 	${D}/usr/local/share/pvr/shaders
	install -m 0755 ${WORKDIR}/gles-samples/bin/*		${D}${bindir}/
	install -m 0644 ${WORKDIR}/gles-samples/shaders/*	${D}/usr/local/share/pvr/shaders/
}

FILES_${PN} += " \
	${bindir} \
	/usr/local/share/pvr \
"
RDEPENDS_${PN} += "libgles2-telechips libegl-telechips"
INSANE_SKIP_${PN} += "already-stripped file-rdeps"
