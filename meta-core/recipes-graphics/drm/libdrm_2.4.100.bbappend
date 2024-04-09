FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc805x', 'file://0001-Add-Mediatek-proprietary-format.patch', '', d)} \
	${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc805x', 'file://0002-Add-support-for-mediatek.patch', '', d)} \
	${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc805x', 'file://0003-libsync-add-support-for-pre-v4.7-kernels.patch', '', d)} \
	${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc805x', 'file://0004-Add-sync_fence_info-and-sync_pt_info.patch', '', d)} \
	${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc805x', 'file://0005-xf86drm-add-support-for-populating-drm-formats.patch', '', d)} \
	${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc805x', 'file://0006-Add-sync_file_info-and-sync_get_fence_info.patch', '', d)} \
"

EXTRA_OEMESON_append = " -Dmediatek=true -Dintel=true -Dradeon=false -Damdgpu=false -Dnouveau=false -Dvmwgfx=false -Dvc4=false"
EXTRA_OEMESON_append = " -Dinstall-test-programs=false -Dman-pages=false"
