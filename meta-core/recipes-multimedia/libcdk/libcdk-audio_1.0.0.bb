include libcdk.inc

LIC_FILES_CHKSUM = "file://include/tcc_audio_interface.h;beginline=1;endline=31;md5=ee857ba4f0e423eaf3df666efd399ce0"
S = "${WORKDIR}/git/audiocodec"

do_install_append() {
	rm -rf ${D}${includedir}
}
