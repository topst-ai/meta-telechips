FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG:append:tcc805x = " opencl"
RRECOMMENDS:${PN}:tcc805x += "libopencl-telechips"
