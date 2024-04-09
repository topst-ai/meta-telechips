FILESEXTRAPATHS_append := ":${THISDIR}"
DESCRIPTION = "Micom Manager Applications for Telechips Linux AVN"
SECTION = "applications"
LICENSE = "Telechips"
LIC_FILES_CHKSUM = "file://${COREBASE}/../meta-telechips/meta-core/licenses/Telechips;md5=e23a23ed6facb2366525db53060c05a4"

COMPATIBLE_MACHINE = "(tcc803x|tcc805x)"


SRC_URI = "${TELECHIPS_AUTOMOTIVE_APP_GIT}/tc-micom-manager.git;protocol=${ALS_GIT_PROTOCOL};branch=${ALS_BRANCH} \
		  ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'file://tc-micom-manager.service', 'file://micom-manager.init.sh', d)} \
		  ${@bb.utils.contains('INVITE_PLATFORM', 'str', 'file://suspend-micom-manager.sh', '', d)} \
"

SRCREV = "4c28c266b811f29c3bc7a66217a62745ad75826b"

UPDATE_RCD := "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd', 'update-rc.d', d)}"

inherit autotools pkgconfig ${UPDATE_RCD}

DEPENDS += "libtcipcctrl"
PATCHTOOL = "git"

S = "${WORKDIR}/git"

MACHINE_TYPE = "${@d.getVar("MACHINE").split("-")[1]}"

PACKAGECONFIG ??= "${@bb.utils.contains_any('MACHINE_TYPE', 'main dvrs', 'dbus', '', d)}"
PACKAGECONFIG[dbus] = ",--without-dbus,dbus"

# for systemd
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "tc-micom-manager.service"

# for sysvinit
INIT_NAME = "micom-manager"

INITSCRIPT_NAME = "${INIT_NAME}"
INITSCRIPT_PARAMS = "start 40 S . stop 20 0 1 6 ."

do_install_append() {
	if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
		install -d ${D}${sysconfdir}/init.d
		install -m 0755 ${WORKDIR}/micom-manager.init.sh ${D}${sysconfdir}/init.d/${INIT_NAME}
	else
		install -d ${D}/${systemd_unitdir}/system
		install -m 644 ${WORKDIR}/tc-micom-manager.service ${D}/${systemd_unitdir}/system
	fi

	if ${@bb.utils.contains('INVITE_PLATFORM', 'str', 'true', 'false', d)}; then
		install -m 0755 ${WORKDIR}/suspend-micom-manager.sh ${D}${bindir}/
	fi
}

FILES_${PN} += " \
		${sysconfdir} \
		${localstatedir} \
		${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${systemd_unitdir}', '', d)} \
"

RDEPENDS_${PN} += "bash"
