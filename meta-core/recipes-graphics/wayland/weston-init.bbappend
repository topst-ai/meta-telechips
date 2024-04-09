FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES','systemd', '${SYSTEMD_SERVICE_LIST}', '${INIT_SCRIPT_LIST}', d)}"

INIT_SCRIPT_LIST = " \
	file://wayland_env.sh \
	file://wl_calibrate.rules \
	file://init \
	file://runWeston \
"
SYSTEMD_SERVICE_LIST = " \
	file://weston.service \
	file://weston.conf \
	file://weston-init \
"

FILES_${PN} += "${sysconfdir}/xdg/weston/weston.ini"

SYSTEMD_SERVICE_${PN} = "weston.service"
SYSTEMD_AUTO_ENABLE = "enable"

do_install() {
	if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
		install -d ${D}${sysconfdir}/sysconfig
		install -d ${D}${systemd_unitdir}/system

		install -m 644 ${WORKDIR}/weston.service		${D}${systemd_system_unitdir}/weston.service
		install -m 644 ${WORKDIR}/weston.conf			${D}${sysconfdir}/sysconfig/weston
		install -m 755 ${WORKDIR}/weston-init			${D}${sysconfdir}/sysconfig/
	else
		install -d ${D}${bindir}
		install -d ${D}${sysconfdir}/init.d
		install -m 755 ${WORKDIR}/init				${D}${sysconfdir}/init.d/weston
		install -m 755 ${WORKDIR}/runWeston			${D}${bindir}/runWeston

		install -d ${D}${sysconfdir}/profile.d
		install -m 0644 ${WORKDIR}/wayland_env.sh ${D}${sysconfdir}/profile.d/

		#Touch calibration for ak4183
		if [ "${TOUCH_SCREEN_TYPE}" = "AK4183" ]; then
		    install -d ${D}${sysconfdir}/udev/rules.d/
		    install -m 0644 ${WORKDIR}/wl_calibrate.rules ${D}${sysconfdir}/udev/rules.d/wl_calibrate.rules
		fi
	fi

	if ${@bb.utils.contains("INVITE_PLATFORM", 'ivi-extension', 'true', 'false', d)}; then
		if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
			echo "QT_WAYLAND_SHELL_INTEGRATION=ivi-shell" >> ${D}${sysconfdir}/sysconfig/weston
		else
			echo "export QT_WAYLAND_SHELL_INTEGRATION=ivi-shell" >> ${D}${sysconfdir}/profile.d/wayland_env.sh
		fi
	fi

	if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
		if ${@bb.utils.contains_any('INVITE_PLATFORM', 'hud-display', 'true', 'false', d)}; then
			echo "IVI_DISPLAY_NUMBER=1" >> ${D}${sysconfdir}/sysconfig/weston
			echo "PASSENGER_DISPLAY_NUMBER=0" >> ${D}${sysconfdir}/sysconfig/weston
		else
			echo "IVI_DISPLAY_NUMBER=0" >> ${D}${sysconfdir}/sysconfig/weston
		fi
	fi
}
