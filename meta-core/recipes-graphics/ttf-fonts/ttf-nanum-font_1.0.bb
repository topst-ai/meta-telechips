SUMMARY = "The Nanum Fonts"
DESCRIPTION = "TrueType font package nanum fonts"
SECTION = "fonts"
LICENSE = "OFL-1.1 & NAVER"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/OFL-1.1;md5=fac3a519e5e9eb96316656e0ca4f2b90 \
					file://${COREBASE}/../meta-telechips/meta-core/licenses/NAVER;md5=f9f0edd32fbe6d0789334a9571a9e646 \
"

# we don't need a compiler nor a c library for these fonts
INHIBIT_DEFAULT_DEPS = "1"

inherit allarch fontcache

SRC_URI = "http://cdn.naver.com/naver/NanumFont/fontfiles/NanumFont_TTF_ALL.zip;name=default \
	file://nanum-barun-gothic.tar.gz;name=barun_gothic \
"
PACKAGES = "${PN} ${PN}-brush ${PN}-barun-gothic ${PN}-gothic ${PN}-myeongjo ${PN}-pen"
ALLOW_EMPTY_${PN} = "1"

do_install() {
    install -d ${D}${datadir}/fonts/truetype/
    find ${WORKDIR}/ -name '*.tt[cf]' -exec install -m 0644 {} ${D}${datadir}/fonts/truetype/ \;
}

SRC_URI[default.md5sum] = "55d28f3d3601d49eabff419b693ad27a"
SRC_URI[default.sha256sum] = "25eee9a54f391d1d81dc5bbaab313f6c055bcbd2e7ab5d2cca8a0aa57257bdd9"
SRC_URI[barun_gothic.md5sum] = "0a444b090a3d42e5d750cf8f9b523de6"
SRC_URI[barun_gothic.sha256sum] = "1d083b5637892c0aa2deb7e3ba91d96f23c83fc072be0affbe9a15a436847ffd"

RDEPENDS_${PN}  += "${PN}-brush ${PN}-barun-gothic ${PN}-gothic ${PN}-myeongjo ${PN}-pen"

FILES_${PN}-brush = "${datadir}/fonts/truetype/*Brush*"
FILES_${PN}-barun-gothic = "${datadir}/fonts/truetype/*BarunGothic*"
FILES_${PN}-gothic = "${datadir}/fonts/truetype/*Gothic*"
FILES_${PN}-myeongjo = "${datadir}/fonts/truetype/*Myeongjo*"
FILES_${PN}-pen = "${datadir}/fonts/truetype/*Pen*"
