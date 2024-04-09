SUMMARY = "Meta package for building a installable toolchain for Telechips Automotive Linux SDK"
LICENSE = "MIT"

inherit populate_sdk

FEATURES = "${@bb.utils.contains('DISTRO_FEATURES', 'opengl', '-opengl', '-no-opengl', d)}"
FEATURES_append = "${@bb.utils.contains('DISTRO_FEATURES', 'wayland', '-wayland', '-fbdev', d)}"

FLOAT_ABI = "${@bb.utils.contains("TUNE_FEATURES", "callconvention-hard", "-hard", "-softfp", d)}"
TOOLCHAIN_OUTPUTNAME = "${ALS_VERSION}-${TCC_ARCH_FAMILY}-toolchain-${PACKAGE_ARCH}${FEATURES}-${SDK_ARCH}-gcc-${SDKGCCVERSION}"
TOOLCHAIN_TARGET_TASK_append = " packagegroup-als-toolchain-target"
TOOLCHAIN_HOST_TASK_append = " nativesdk-als-packagegroup-sdk-host"
SDKIMAGE_LINGUAS = ""

create_sdk_files_append() {
    mkdir -p ${SDK_OUTPUT}/${SDKPATHNATIVE}/environment-setup.d/
    script=${SDK_OUTPUT}/${SDKPATHNATIVE}/environment-setup.d/telechips.sh

    touch $script
    echo 'export SIZE="${TARGET_PREFIX}size"' >> $script
    echo 'export KERNEL_DIR="${SDKTARGETSYSROOT}/usr/src/kernel"' >> $script
    echo 'export MACHINE="${MACHINE}"' >> $script
}
