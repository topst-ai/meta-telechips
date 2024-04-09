SUMMARY = "GENIVI AudioManager Monitor"
DESCRIPTION = "Monitor APP of the GENIVI AudioManager"

LICENSE = "MPLv2"
LIC_FILES_CHKSUM = "file://${PN}/LICENSE;md5=815ca599c9df247a0c7f619bab123dad"
DEPENDS = "qtbase qtdeclarative pulseaudio audiomanager"

BRANCH="master"

SRC_URI = "\
    git://git.projects.genivi.org/AudioManagerDemo.git;branch=${BRANCH};destsuffix=git/${PN};protocol=http;name=demo \
    file://AudioManager_Monitor.service; \
    file://0001-gdp-audio-monitor-include-fix.patch;patchdir=${S}${PN} \
	file://0001-Modify-Source-Sink-Names.patch;patchdir=${S}${PN} \
    "
SRCREV_demo = "eea896440e5ad49622c7b1a4095f0d63c3465aa2"

S = "${WORKDIR}/git/"

PATCHTOOL = "git"

QMAKE_PROFILES ?= "${S}${PN}"

inherit qmake5 systemd

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "AudioManager_Monitor.service"

SYSTEMD_AUTO_ENABLE = "disable"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/AudioManager_Monitor.service ${D}${systemd_unitdir}/system
}

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

FILES_${PN} += "/opt/AudioManagerMonitor/*"
FILES_${PN}-dbg += "/usr/bin/AudioManagerMonitor/.debug/*"
