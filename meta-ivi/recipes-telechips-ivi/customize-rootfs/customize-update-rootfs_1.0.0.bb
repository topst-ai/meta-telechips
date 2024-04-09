SUMMARY = "Update rootfs for customizing update root filesystem"
DESCRIPTION = "Update rootfs for customizing update root filesystem"
SECTION = "base"
LICENSE = "Telechips"
LIC_FILES_CHKSUM = "file://${COREBASE}/../meta-telechips/meta-core/licenses/Telechips;md5=e23a23ed6facb2366525db53060c05a4"

require customize-rootfs_${PV}.bb

IS_UPDATE_ROOTFS = "1"
