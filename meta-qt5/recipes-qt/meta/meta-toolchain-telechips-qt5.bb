SUMMARY = "Meta package for building a installable toolchain for Telechips Automotive Linux SDK include Qt5"
LICENSE = "MIT"

PR = "r7"

require recipes-core/meta/meta-toolchain-telechips.bb

inherit populate_sdk_qt5

FEATURES_append = "-qt5"
