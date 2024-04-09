require ${BPN}.inc

SRC_URI = "${TELECHIPS_AUTOMOTIVE_BSP_GIT}/gpu.git;protocol=${ALS_GIT_PROTOCOL};branch=${ALS_BRANCH};"
SRC_URI += "file://pkgconfig"

SRCREV = "f5c5c29a33fed0274ad309a08fbe1656be5ac063"

PATCHTOOL = "git"
COMPATIBLE_MACHINE = "tcc805x"
