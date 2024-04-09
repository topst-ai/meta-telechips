DESCRIPTION = "Telechips Packagergroup for Pulseaudio"
inherit packagegroup

RDEPENDS_${PN}= "\
	pulseaudio \
	pulseaudio-server \
	pulseaudio-misc \
	pulseaudio-module-remap-sink \
	pulseaudio-module-loopback \
	alsa-plugins-pulseaudio-conf \
"
