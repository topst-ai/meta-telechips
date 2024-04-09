SUMMARY = "Recovery rootfs for image update"
DESCRIPTION = "Update rootfs image udpate"
SECTION = "base"
LICENSE = "Telechips"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta-telechips-bsp/licenses/Telechips;md5=e23a23ed6facb2366525db53060c05a4"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
	install -d ${D}${sysconfdir}
	echo "Telechips ${ALS_VERSION} (${ALS_RELEASE_DATE})" > ${D}${sysconfdir}/als-release
}

FILES_${PN} += "${sysconfdir}"
