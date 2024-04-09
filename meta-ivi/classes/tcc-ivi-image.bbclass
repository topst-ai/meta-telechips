#
# Copyright (C) Telechips Inc.
#

inherit tcc-base-image

LINGUAS_KO_KR = "ko-kr ko-kr.euc-kr"
LINGUAS_EN_GB = "en-gb en-gb.iso-8859-1"
LINGUAS_EN_US = "en-us en-us.iso-8859-1"

IMAGE_LINGUAS = "${LINGUAS_KO_KR} ${LINGUAS_EN_GB} ${LINGUAS_EN_US}"

# telechips ivi base install packages
IMAGE_INSTALL_append = " packagegroup-telechips-ivi-base"

# language
IMAGE_INSTALL_append = " glibc-gconv-utf-16 glibc-gconv-utf-32"
IMAGE_INSTALL_append = " glibc-gconv-euc-kr glibc-gconv-libksc"

# security
IMAGE_INSTALL_append = "${@bb.utils.contains_any('INVITE_PLATFORM', 'TEE HDA optee', ' packagegroup-telechips-security', '', d)}"
IMAGE_INSTALL_append = "${@bb.utils.contains_any('TCC_ARCH_FAMILY', 'tcc803x tcc805x', ' hsm', '', d)}"

python do_image_pkg_info() {
}

addtask image_pkg_info
do_image_pkg_info[nostamp] = "1"
