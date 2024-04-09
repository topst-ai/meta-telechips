DESCRIPTION = "Telechips EGL Example"
SECTION = "libs"
LICENSE = "Telechips"
LIC_FILES_CHKSUM = "file://${COREBASE}/../meta-telechips/meta-core/licenses/Telechips;md5=e23a23ed6facb2366525db53060c05a4"

SRC_URI = "${TELECHIPS_AUTOMOTIVE_BSP_GIT}/3dmali.git;protocol=${ALS_GIT_PROTOCOL};branch=${ALS_BRANCH}"
SRC_URI += "${@bb.utils.contains("DISTRO_FEATURES", "systemd", \
			bb.utils.contains("DISTRO_FEATURES", "wayland", "file://tc-teapot-light.service file://tc-teapot-light.path", "file://tc-teapot-light.service.eglfs", d), \
			"file://tc-teapot-light.init.sh", d)} \
"
SRCREV = "1fb01baf518dc6c90e4c06f3a972d9104eaed904"

DEPENDS += "telechips-egl"
UPDATE_RCD := "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd', 'update-rc.d', d)}"

inherit autotools gettext features_check ${UPDATE_RCD}

REQUIRED_DISTRO_FEATURES = "opengl"

PATCHTOOL = "git"
LINKER_HASH_STYLE = "sysv"

S = "${WORKDIR}/git/sample_app/tcTeapotLight"

# for systemd
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "${@bb.utils.contains("DISTRO_FEATURES", "wayland", "tc-teapot-light.service tc-teapot-light.path", "tc-teapot-light.service", d)}"
SYSTEMD_AUTO_ENABLE_${PN} = "disable"

# for sysvinit
INIT_NAME = "tc-teapot-light"
INITSCRIPT_NAME = "${INIT_NAME}"

do_install_append() {
	if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
		install -d ${D}/${systemd_unitdir}/system

		if ${@bb.utils.contains("DISTRO_FEATURES", "wayland", "true", "false", d)}; then
			install -m 644 ${WORKDIR}/tc-teapot-light.service		${D}${systemd_unitdir}/system/
			install -m 644 ${WORKDIR}/tc-teapot-light.path			${D}${systemd_unitdir}/system/
		else
			install -m 644 ${WORKDIR}/tc-teapot-light.service.eglfs	${D}${systemd_unitdir}/system/tc-teapot-light.service
			sed -i 's%\(^Environment=QT_QPA_EGLFS_PHYSICAL_WIDTH=\)LCD_WIDTH%\1${LCD_WIDTH}%g'		${D}${systemd_unitdir}/system/tc-teapot-light.service
			sed -i 's%\(^Environment=QT_QPA_EGLFS_PHYSICAL_HEIGHT=\)LCD_HEIGHT%\1${LCD_HEIGHT}%g'	${D}${systemd_unitdir}/system/tc-teapot-light.service
		fi
		sed -i 's%LCD_WIDTH%${LCD_WIDTH}%g'		${D}${systemd_unitdir}/system/tc-teapot-light.service
		sed -i 's%LCD_HEIGHT%${LCD_HEIGHT}%g'	${D}${systemd_unitdir}/system/tc-teapot-light.service
	else
		install -d ${D}${sysconfdir}/init.d
		install -m 0755 ${WORKDIR}/tc-teapot-light.init.sh	${D}${sysconfdir}/init.d/${INIT_NAME}
		sed -i 's%LCD_WIDTH%${LCD_WIDTH}%g'		${D}${sysconfdir}/init.d/${INIT_NAME}
		sed -i 's%LCD_HEIGHT%${LCD_HEIGHT}%g'	${D}${sysconfdir}/init.d/${INIT_NAME}
	fi
}

FILES_${PN} += " \
	${datadir} \
	${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', '${sysconfdir}', '', d)} \
	${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${systemd_unitdir}', '', d)} \
"
