SUMMARY = "Meta package for building a installable toolchain for Telechips Automotive Linux SDK"
LICENSE = "MIT"

require recipes-core/meta/meta-toolchain-telechips.bb

FEATURES_append = "-subcore"

TOOLCHAIN_HOST_TASK_remove = "nativesdk-als-packagegroup-sdk-host"
TOOLCHAIN_TARGET_TASK_remove = "packagegroup-als-toolchain-target"
TOOLCHAIN_TARGET_TASK_append = " packagegroup-als-subcore-toolchain-target"
