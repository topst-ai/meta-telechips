FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "${@oe.utils.conditional('GLIBCVERSION', '2.34%', '${GLIBC_2_34_PATCH}', '', d)}"

GLIBC_2_34_PATCH = " \
	file://0001-sort.c-Reorder-includes-for-glibc-2.34-portability.patch \
"
