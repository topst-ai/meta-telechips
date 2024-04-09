DESCRIPTION = "Power VR applications"
SECTION = "applications"
LICENSE = "CLOSED"

SRC_URI = "file://pvr_util"
SRC_URI += "${@bb.utils.contains("DISTRO_FEATURES", 'systemd', 'file://pvr-util.service', 'file://pvr-util.init.sh', d)}"

UPDATE_RCD := "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd', 'update-rc.d', d)}"

inherit autotools ${UPDATE_RCD}

# for systemd
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "pvr-util.service"

# for sysvinit
INIT_NAME = "pvr-util"
INITSCRIPT_NAME = "${INIT_NAME}"
INITSCRIPT_PARAMS = "start 01 S . stop 30 0 1 6 ."

LINKER_HASH_STYLE = "sysv"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
	install -d 	${D}${bindir}
	install -m 0755 ${WORKDIR}/pvr_util	${D}${bindir}

	if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
		install -d ${D}/${systemd_unitdir}/system
		install -m 644 ${WORKDIR}/pvr-util.service	${D}${systemd_unitdir}/system/
	else
		install -d ${D}${sysconfdir}/init.d
		install -m 0755 ${WORKDIR}/pvr-util.init.sh ${D}${sysconfdir}/init.d/${INIT_NAME}
	fi
}

FILES_${PN} += " \
	${bindir} \
	${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', '${sysconfdir}', '', d)} \
"
INSANE_SKIP_${PN} += "already-stripped"
RDEPENDS_${PN} += "libpvr-telechips"
