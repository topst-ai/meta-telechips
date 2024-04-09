DESCRIPTION = "Telechips Packagergroup for T-Sound"
inherit packagegroup

RDEPENDS_${PN}= " \
	t-sound \
	libasound \
	alsa-utils-amixer \
	alsa-utils-aplay \
	kernel-module-snd-soc-ak4601 \
	kernel-module-tcc-adma-pcm \
	kernel-module-tcc-i2s \
	kernel-module-tcc-snd-card \
"
