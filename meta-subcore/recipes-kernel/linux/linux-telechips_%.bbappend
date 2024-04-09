do_change_defconfig() {
	if ${@bb.utils.contains_any('SUBCORE_APPS', 'rvc svm', 'true', 'false', d)}; then
		echo "CONFIG_MEDIA_SUPPORT=y"							>> ${WORKDIR}/defconfig
		echo "CONFIG_MEDIA_CAMERA_SUPPORT=y"					>> ${WORKDIR}/defconfig
		echo "CONFIG_V4L_PLATFORM_DRIVERS=y"					>> ${WORKDIR}/defconfig

		echo "CONFIG_MEDIA_CONTROLLER=y"						>> ${WORKDIR}/defconfig
		echo "CONFIG_VIDEO_V4L2_SUBDEV_API=y"					>> ${WORKDIR}/defconfig
		echo "CONFIG_VIDEO_TCCVIN2=y"							>> ${WORKDIR}/defconfig
		echo "# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set"		>> ${WORKDIR}/defconfig
		#echo "CONFIG_VIDEO_ADV7182=y"							>> ${WORKDIR}/defconfig
		echo "CONFIG_VIDEO_ISL79988=y"							>> ${WORKDIR}/defconfig
		echo "CONFIG_VIDEO_ARXXXX=y"							>> ${WORKDIR}/defconfig
		echo "CONFIG_VIDEO_MAX96701=y"							>> ${WORKDIR}/defconfig
		echo "CONFIG_VIDEO_MAX9286=y"							>> ${WORKDIR}/defconfig

		echo "CONFIG_MAILBOX=y"									>> ${WORKDIR}/defconfig
		echo "CONFIG_TCC_MULTI_MAILBOX=y"						>> ${WORKDIR}/defconfig
		echo "# CONFIG_VIDEO_TCC_VOUT is not set"				>> ${WORKDIR}/defconfig
		echo "CONFIG_SWITCH_REVERSE=y"							>> ${WORKDIR}/defconfig
		echo "CONFIG_FB_TCC_OVERLAY=y"							>> ${WORKDIR}/defconfig

		if ${@bb.utils.contains_any('SUBCORE_APPS', 'rvc', 'true', 'false', d)}; then
			echo "CONFIG_OVERLAY_PGL=y"							>> ${WORKDIR}/defconfig
		fi
	fi
		
	# TOST : Raspberry Camera
	echo "CONFIG_VIDEO_TP2855=y"							>> ${WORKDIR}/defconfig
	echo "CONFIG_VIDEO_IMX219=y"							>> ${WORKDIR}/defconfig
	echo "CONFIG_VIDEOBUF2_VMALLOC=y"						>> ${WORKDIR}/defconfig

	if ${@bb.utils.contains('SUBCORE_APPS', 't-sound', 'true', 'false', d)}; then
		echo "CONFIG_SOUND=y"									>>  ${WORKDIR}/defconfig
		echo "CONFIG_SND=y"										>>  ${WORKDIR}/defconfig
		echo "CONFIG_SND_SOC=y"									>>  ${WORKDIR}/defconfig
		echo "CONFIG_SND_SOC_TCC=m"								>>  ${WORKDIR}/defconfig
		echo "CONFIG_SND_SOC_AK4601=m "							>>  ${WORKDIR}/defconfig
		echo "CONFIG_TCC_MULTI_MAILBOX_AUDIO=y"					>>  ${WORKDIR}/defconfig
	fi

# network configuration for ssh server
	if ${@bb.utils.contains('INVITE_PLATFORM', 'network', 'true', 'false', d)}; then
		echo "CONFIG_INET=y"									>> ${WORKDIR}/defconfig
		echo "CONFIG_IPV6=y"									>> ${WORKDIR}/defconfig
		echo "CONFIG_NETDEVICES=y"								>> ${WORKDIR}/defconfig
		echo "CONFIG_ETHERNET=y"								>> ${WORKDIR}/defconfig
		echo "CONFIG_PHYLIB=y"									>> ${WORKDIR}/defconfig
		echo "# CONFIG_WLAN is not set"							>> ${WORKDIR}/defconfig
		echo "# CONFIG_WIRELESS is not set"						>> ${WORKDIR}/defconfig
		echo "CONFIG_USB_USBNET=y"								>>  ${WORKDIR}/defconfig

		if ${@bb.utils.contains('USE_RNDIS_HOST', '1', 'true', 'false', d)}; then
			echo "CONFIG_USB_NET_RNDIS_HOST=y"					>> ${WORKDIR}/defconfig
		fi
	fi

	if ${@bb.utils.contains('INVITE_PLATFORM', 'gpu-vz', 'true', 'false', d)}; then
		echo "CONFIG_POWERVR_ROGUE=y"							>> ${WORKDIR}/defconfig
		echo "CONFIG_POWERVR_TCC9XTP=y"							>> ${WORKDIR}/defconfig
		echo "CONFIG_POWERVR_VZ=y"								>> ${WORKDIR}/defconfig

		if ${@bb.utils.contains('INVITE_PLATFORM', 'drm', 'true', 'false', d)}; then
			echo "CONFIG_DRM_TCC=y"                             >> ${WORKDIR}/defconfig
			echo "CONFIG_DRM_TCC_LCD=y"                         >> ${WORKDIR}/defconfig
		else
			echo "CONFIG_POWERVR_DC_FBDEV=y"                    >> ${WORKDIR}/defconfig
		fi
	fi

	if ${@bb.utils.contains_any('SUBCORE_APPS', 'rvc svm', 'true', 'false', d)}; then
		echo "CONFIG_CAMIPC=y"								>> ${WORKDIR}/defconfig
	fi

}

do_change_defconfig_append_tcc803x() {
	if ${@bb.utils.contains('SUBCORE_APPS', 'cluster', 'true', 'false', d)}; then
		echo "CONFIG_FB_NEW_DISP1=y"							>> ${WORKDIR}/defconfig
		sed -i 's%\(^.*\)22M\(.*\)%\1${EXPECTED_ROOTFS_SIZE}\2%g'  ${S}/arch/arm/boot/dts/tcc/tcc803x-subcore.dtsi
	fi
}

# DP MST
SRC_URI += "${@bb.utils.contains('INVITE_PLATFORM', 'dp-mst', 'file://0001-add-config-for-DP-MST.patch', '', d)}"