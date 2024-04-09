DESCRIPTION = "Apply the liblog one of Android logging system in ALS"
SECTION = "utils"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit autotools-brokensep

SRC_URI = "${TELECHIPS_AUTOMOTIVE_UTILS_GIT}/android-tools/liblog.git;protocol=${ALS_GIT_PROTOCOL};branch=${ALS_BRANCH}"
SRCREV = "7f059ce5b6e46e0e0f7b6aef45ff1e1d85fde5b4"

S = "${WORKDIR}/git"

PATCHTOOL = "git"
BBCLASSEXTEND = "native nativesdk"
