require ${BPN}.inc

SRC_URI = "${TELECHIPS_AUTOMOTIVE_BSP_GIT}/3dmali.git;protocol=${ALS_GIT_PROTOCOL};branch=${ALS_BRANCH}"
SRCREV = "1fb01baf518dc6c90e4c06f3a972d9104eaed904"

PATCHTOOL = "git"

COMPATIBLE_MACHINE = "(tcc897x|tcc803x)"
