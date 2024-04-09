FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://format-filesystem.service \
            file://format-filesystem.sh \
			file://format-data-partition.service \
			file://format-data-partition.sh \
			file://systemd-udevd.conf \
			file://systemd-udevd.service \
			file://systemd-modules-load.service \
			file://sys-fs-fuse-connections.mount \
			file://sys-kernel-config.mount \
			file://systemd-sysctl.service \
			file://scsi.conf \
		    file://sdmmc.conf \
		    file://sound.conf \
		    file://tcc-dwc2.conf \
		    ${@bb.utils.contains_any('TCC_ARCH_FAMILY', 'tcc803x tcc805x', 'file://tcc-dwc3.conf', '', d)} \
		    ${@bb.utils.contains_any('TCC_ARCH_FAMILY', 'tcc897x tcc805x', 'file://tcc-ehci.conf', '', d)} \
		    ${@bb.utils.contains_any('TCC_ARCH_FAMILY', 'tcc897x tcc805x', 'file://tcc-ohci.conf', '', d)} \
		    file://usb-storage.conf \
		    ${@bb.utils.contains_any('TCC_ARCH_FAMILY', 'tcc803x tcc805x', 'file://input.conf', '', d)} \
		    file://vpu.conf \
		    file://topst_test_sub.service \ 
"

EXTRA_OEMESON += "-Ddefault-dnssec=no"

PACKAGECONFIG_remove = "hibernate nss-resolve"
PACKAGECONFIG_remove = "${@bb.utils.contains('INVITE_PLATFORM', 'network', '', 'networkd resolved', d)}"

do_install_append() {
# override mountflags of systemd-udevd.service for access mount point its own filesystem namespace
	install -d ${D}${sysconfdir}/systemd/system/systemd-udevd.service.d
	install -m 0644 ${WORKDIR}/systemd-udevd.conf 		${D}${sysconfdir}/systemd/system/systemd-udevd.service.d/
	install -m 0644 ${WORKDIR}/systemd-udevd.service	${D}${systemd_unitdir}/system

# install service file & script file
	install -m 0644 ${WORKDIR}/format-filesystem.service		${D}/${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/format-data-partition.service	${D}/${systemd_unitdir}/system
	install -m 0755 ${WORKDIR}/format-filesystem.sh 			${D}/${bindir}/
	install -m 0755 ${WORKDIR}/format-data-partition.sh 		${D}/${bindir}/

	install -d ${D}${sysconfdir}/systemd/system/sysinit.target.wants
	install -d ${D}${sysconfdir}/systemd/system/sockets.target.wants
	ln -sf ${systemd_unitdir}/system/format-filesystem.service		${D}${sysconfdir}/systemd/system/sysinit.target.wants/format-filesystem.service
	ln -sf ${systemd_unitdir}/system/format-data-partition.service	${D}${sysconfdir}/systemd/system/sockets.target.wants/format-data-partition.service

# install network configuration
	# change how to load kernel modules from automatic to manual
	sed -i "s%\(ENV{MODALIAS}==\"?\*.*\)%#\1%g" ${D}${base_libdir}/udev/rules.d/80-drivers.rules

	# add modprobe configuration files
	install -d ${D}${sysconfdir}/modules-load.d/
	install -m 0644 ${WORKDIR}/scsi.conf			${D}${sysconfdir}/modules-load.d/
	install -m 0644 ${WORKDIR}/sound.conf			${D}${sysconfdir}/modules-load.d/
	if ${@bb.utils.contains_any("TCC_ARCH_FAMILY", "tcc803x tcc805x", "true", "false", d)}; then
		install -m 0644 ${WORKDIR}/input.conf			${D}${sysconfdir}/modules-load.d/
	fi

	if ${@bb.utils.contains_any("MACHINE", "tcc8050-main", "true", "false", d)}; then
		install -m 0644 ${WORKDIR}/tcc-dwc2.conf		${D}${sysconfdir}/modules-load.d/
		install -m 0644 ${WORKDIR}/tcc-dwc3.conf		${D}${sysconfdir}/modules-load.d/

		if ${@bb.utils.contains_any("MACHINE", "tcc8050-sub", "false", "true", d)}; then
			echo "ehci-tcc" >> ${D}${sysconfdir}/modules-load.d/tcc-dwc2.conf
		fi
	fi

	if ${@bb.utils.contains_any("MACHINE", "tcc8050-sub", "true", "false", d)}; then
		install -m 0644 ${WORKDIR}/tcc-ehci.conf		${D}${sysconfdir}/modules-load.d/
		# MP Tool
		install -m 0644 ${WORKDIR}/topst_test_sub.service		${D}/${systemd_unitdir}/system
		ln -sf ${systemd_unitdir}/system/topst_test_sub.service		${D}${sysconfdir}/systemd/system/sysinit.target.wants/topst_test_sub.service
	fi

	#install -m 0644 ${WORKDIR}/tcc-ohci.conf		${D}${sysconfdir}/modules-load.d/

	install -m 0644 ${WORKDIR}/usb-storage.conf		${D}${sysconfdir}/modules-load.d/
	install -m 0644 ${WORKDIR}/sdmmc.conf			${D}${sysconfdir}/modules-load.d/

	# remove vpu module
	if ${@bb.utils.contains('DISTRO_FEATURES','remove-vpu-module','false','true',d)}; then
		install -m 0644 ${WORKDIR}/vpu.conf				${D}${sysconfdir}/modules-load.d/
	fi

    if ${@bb.utils.contains('INVITE_PLATFORM', 't-sound', 'true', 'false', d)}; then
		sed -i "s/snd-soc-ak4601/snd-soc-ak4601-virtual/g"	${D}${sysconfdir}/modules-load.d/sound.conf
		sed -i "s/tcc-snd-card/snd-soc-tcc-asrc/g"	${D}${sysconfdir}/modules-load.d/sound.conf
		echo "tcc_asrc_m2m_pcm"	>> ${D}${sysconfdir}/modules-load.d/sound.conf
		echo "tcc_vir_i2s"		>> ${D}${sysconfdir}/modules-load.d/sound.conf
		echo "tcc-snd-card"		>> ${D}${sysconfdir}/modules-load.d/sound.conf
	fi

	# change order of kernel modules
	install -m 0644 ${WORKDIR}/systemd-modules-load.service ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/sys-fs-fuse-connections.mount ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/sys-kernel-config.mount ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/systemd-sysctl.service ${D}${systemd_unitdir}/system

# delete no need rules
	rm -f ${D}${base_libdir}/udev/rules.d/50-firmware.rules
	rm -f ${D}${base_libdir}/udev/rules.d/60-block.rules
	rm -f ${D}${base_libdir}/udev/rules.d/60-cdrom_id.rules
	rm -f ${D}${base_libdir}/udev/rules.d/60-drm.rules
	rm -f ${D}${base_libdir}/udev/rules.d/60-evdev.rules
	rm -f ${D}${base_libdir}/udev/rules.d/60-persistent-alsa.rules
	rm -f ${D}${base_libdir}/udev/rules.d/60-persistent-input.rules
	rm -f ${D}${base_libdir}/udev/rules.d/60-persistent-storage-tape.rules
	rm -f ${D}${base_libdir}/udev/rules.d/60-persistent-v4l.rules
	rm -f ${D}${base_libdir}/udev/rules.d/60-serial.rules
	rm -f ${D}${base_libdir}/udev/rules.d/64-btrfs.rules
	rm -f ${D}${base_libdir}/udev/rules.d/70-mouse.rules
	rm -f ${D}${base_libdir}/udev/rules.d/70-power-switch.rules
	rm -f ${D}${base_libdir}/udev/rules.d/70-uaccess.rules
	rm -f ${D}${base_libdir}/udev/rules.d/71-seat.rules
	rm -f ${D}${base_libdir}/udev/rules.d/73-seat-late.rules
	rm -f ${D}${base_libdir}/udev/rules.d/75-net-description.rules
	rm -f ${D}${base_libdir}/udev/rules.d/75-probe_mtd.rules
	rm -f ${D}${base_libdir}/udev/rules.d/78-sound-card.rules
	rm -f ${D}${base_libdir}/udev/rules.d/80-net-setup-link.rules
	rm -f ${D}${base_libdir}/udev/rules.d/90-vconsole.rules

# delete no need service files
	rm -f ${D}${systemd_unitdir}/system/smartcard.target
	rm -f ${D}${systemd_unitdir}/system/systemd-sysusers.service
	rm -f ${D}${systemd_unitdir}/system/systemd-time-wait-sync.service
	rm -f ${D}${systemd_unitdir}/system/systemd-localed.service
}


RRECOMMENDS_${PN} += "util-linux-mkfs e2fsprogs-mke2fs"
RRECOMMENDS_${PN}_remove = "udev-hwdb ${PN}-extra-utils"
RRECOMMENDS_udev := "udev-extraconf"

FILES_${PN} += " \
	${bindir}/format-filesystem.sh \
	${bindir}/format-data-partition.sh \
"
