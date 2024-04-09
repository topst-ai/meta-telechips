SUMMARY = "Host packages for the Telechips Automotive Linux SDK standalone SDK or external toolchain"

inherit packagegroup nativesdk

PACKAGEGROUP_DISABLE_COMPLEMENTARY = "1"

RDEPENDS_${PN} = " \
	nativesdk-protobuf-compiler \
	nativesdk-wayland-dev \
"
