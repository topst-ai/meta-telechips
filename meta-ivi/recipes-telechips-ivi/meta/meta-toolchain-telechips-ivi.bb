SUMMARY = "Meta package for building a installable toolchain for Telechips Automotive Linux SDK"
LICENSE = "MIT"

require recipes-core/meta/meta-toolchain-telechips.bb

FEATURES_append = "-ivi"

TOOLCHAIN_TARGET_TASK_append = " packagegroup-als-ivi-toolchain-target"
