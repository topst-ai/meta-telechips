require conf/distro/include/security_flags.inc

SECURITY_STRINGFORMAT_pn-busybox-initramfs = ""

SECURITY_PIC_CFLAGS = "-fPIC"
SECURITY_PIE_CFLAGS = "-fPIE -pie"

SECURITY_CFLAGS = "${SECURITY_STACK_PROTECTOR} ${SECURITY_PIE_CFLAGS} ${lcl_maybe_fortify} ${SECURITY_STRINGFORMAT} ${SECURITY_PIC_CFLAGS}"
