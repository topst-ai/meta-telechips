SUMMARY = "Target packages for the standalone SDK"
PR = "r8"

inherit packagegroup

RDEPENDS_${PN} = "\
    libgcc \
    libgcc-dev \
	${@oe.utils.conditional("TCMODE", "external-sourcery", "libgcov-dev", "", d)} \
    libstdc++ \
    libstdc++-dev \
    ${LIBC_DEPENDENCIES} \
    qemuwrapper-cross \
    "
