DESCRIPTION = "Telechips CDK library"
SECTION = "libs"
LICENSE = "Telechips"

inherit autotools pkgconfig

SRC_URI = "${TELECHIPS_AUTOMOTIVE_MULTIMEDIA_GIT}/libcdk.git;protocol=${ALS_GIT_PROTOCOL};branch=${ALS_BRANCH}"
SRCREV = "d7f278653c1538e72453019107a82c738fd90705"
PATCHTOOL = "git"

PACKAGES = "${PN} ${PN}-dbg"

EXTRA_OECONF += "PROCESSOR=${TCC_ARCH_FAMILY}"
EXTRA_OECONF_append_aarch64 = " TUNE_ARCH=64bit"
EXTRA_OECONF_append_arm = " TUNE_ARCH=32bit FLOAT_ABI=${TUNE_CCARGS_MFLOAT}"

FILES_${PN} += "${libdir}/*.so"
INSANE_SKIP_${PN} += "dev-so textrel"
