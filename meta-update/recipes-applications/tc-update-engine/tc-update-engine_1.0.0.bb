DESCRIPTION = "Telechips Update Engine"
LICENSE = "Telechips"
LIC_FILES_CHKSUM = "file://include/update-engine.h;beginline=1;endline=21;md5=4b28161e2474d4d17e8aab7e8098bff5"
SECTION = "libs"

SRC_URI = "${TELECHIPS_AUTOMOTIVE_APP_GIT}/tc-update-engine.git;protocol=${ALS_GIT_PROTOCOL};branch=${ALS_BRANCH}"
SRCREV = "cefbc8b0d2eabafb0bf0c5f88676244131def926"

EXTRA_OECONF_append_tcc803x = " --enable-803x-update"

inherit autotools pkgconfig

DEPENDS += "linux-libc-headers"
LINKER_HASH_STYLE = "sysv"

S = "${WORKDIR}/git"

PATCHTOOL = "git"

