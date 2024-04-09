DESCRIPTION = "Core Library for Telechips Linux AVN"

SECTION = "libs"
LICENSE = "Telechips"
LIC_FILES_CHKSUM = "file://include/tc-ipc-ctrl.h;beginline=1;endline=24;md5=b45074fc72e3c30f73dd329db5219492"

SRC_URI = "${TELECHIPS_AUTOMOTIVE_APP_GIT}/libtc-ipc-ctrl.git;protocol=${ALS_GIT_PROTOCOL};branch=${ALS_BRANCH}"
SRCREV = "24282a8d51a9bfde7ed13d21795675574baad997"

inherit autotools pkgconfig

do_configure[depends] += "virtual/kernel:do_shared_workdir"

EXTRA_OEMAKE += "KERNELDIR='${STAGING_KERNEL_DIR}'"
DEPENDS += "linux-libc-headers"
RDEPENDS_${PN} += "libgcc"

PATCHTOOL = "git"

S = "${WORKDIR}/git"
