#
# Copyright (C) Telechips Inc.
#

inherit core-image extrausers make_fai

IMAGE_FSTYPES = "squashfs ext4"
#IMAGE_OVERHEAD_FACTOR ??= "1.2"

# preset rootfs size pre kilo byte
IMAGE_ROOTFS_SIZE ?= "5296128"
IMAGE_ROOTFS_ALIGNMENT = "1024"

# telechips base install packages
CORE_IMAGE_BASE_INSTALL = "\
    ${CORE_IMAGE_EXTRA_INSTALL} \
    packagegroup-core-boot \
    packagegroup-telechips-base \
"

ROOTFS_POSTPROCESS_COMMAND += "rootfs_update_timestamp ; "

set_user_group_prepend() {
	export ENCRYPTED_PASSWORD=$(openssl passwd ${DEFAULT_PASSWORD})
	export ENCRYPTED_ROOT_PASSWORD=$(openssl passwd ${DEFAULT_ROOT_PASSWORD})
}

EXTRA_USERS_PARAMS = "\
	groupadd --gid 200 ${DEFAULT_GROUP_NAME}; \
	useradd --gid ${DEFAULT_GROUP_NAME} --uid 200 --groups audio,video --password '$ENCRYPTED_PASSWORD' ${DEFAULT_USER_NAME}; \
	usermod --password $ENCRYPTED_ROOT_PASSWORD root; \
"
