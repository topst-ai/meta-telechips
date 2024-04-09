DESCRIPTION = "This image provides cortex-a53 subcore"
LICENSE = "MIT"

inherit core-image ${@bb.utils.contains('INVITE_PLATFORM', 'fw-update', 'make-sub-updatedir', '',d)}

IMAGE_FSTYPES ?= "ext4"
IMAGE_FSTYPES_tcc805x = "ext4"
IMAGE_FSTYPES_tcc803x = "cpio"
IMAGE_ROOTFS_SIZE ?= "532480"
#IMAGE_OVERHEAD_FACTOR = "1.2"
#IMAGE_ROOTFS_EXTRA_SPACE ?= "10240"
IMAGE_ROOTFS_ALIGNMENT = "1024"
IMAGE_LINGUAS = ""

UPDATE_ENGINE = "${@bb.utils.contains('TCC_ARCH_FAMILY', 'tcc803x', '', 'tc-update-engine', d)}"
POWERVR_APP = "${@bb.utils.contains('INVITE_PLATFORM', 'drm', '', 'powervr-app', d)}"

IMAGE_INSTALL = " \
	packagegroup-core-boot-telechips-${TCC_ARCH_FAMILY}-subcore \
	kernel-modules \
	kmod \
	tc-enable-removable-disk \
	hsm \
	${@bb.utils.contains('SUBCORE_APPS', 'cluster', '${CLUSTER_PKG_NAME}', '', d)} \
	${@bb.utils.contains('SUBCORE_APPS', 'rvc', 'tc-rvc-app', '', d)} \
	${@bb.utils.contains('SUBCORE_APPS', 't-sound', 'packagegroup-subcore-tsound', '', d)} \
	${@bb.utils.contains('SUBCORE_APPS', 'hdradio', 'tc-radio-hd-mw', '', d)} \
	${@bb.utils.contains('SUBCORE_APPS', 'drm30', 'tc-drm-mw', '', d)} \
	${@bb.utils.contains('SUBCORE_APPS', 'dab-sdr', 'tc-dab-sdr-mw', '', d)} \
	${@bb.utils.contains('INVITE_PLATFORM', 'micom', 'tc-micom-manager', '', d)} \
	${@bb.utils.contains('INVITE_PLATFORM', 'fw-update', '${UPDATE_ENGINE}', '', d)} \
    	${@bb.utils.contains('INVITE_PLATFORM', 'str', 'tc-str-manager', '', d)} \
	${@bb.utils.contains('INVITE_PLATFORM', 'gpu-vz', '${POWERVR_APP}', '', d)} \
    	${CORE_IMAGE_EXTRA_INSTALL} \
	v4l-utils \
	i2c-tools \
"

EXTRA_USERS_PARAMS = "\
	groupadd --gid 200 ${DEFAULT_GROUP_NAME}; \
	useradd --gid ${DEFAULT_GROUP_NAME} --uid 200 --groups audio,video --password '$ENCRYPTED_PASSWORD' ${DEFAULT_USER_NAME}; \
	usermod --password $ENCRYPTED_ROOT_PASSWORD root; \
"

set_user_group_prepend() {
	export ENCRYPTED_PASSWORD=$(openssl passwd ${DEFAULT_PASSWORD})
	export ENCRYPTED_ROOT_PASSWORD=$(openssl passwd ${DEFAULT_ROOT_PASSWORD})
}

IMAGE_INSTALL += " \
    packagegroup-telechips-ivi-multimedia \
    packagegroup-telechips-ivi-graphics \
"
