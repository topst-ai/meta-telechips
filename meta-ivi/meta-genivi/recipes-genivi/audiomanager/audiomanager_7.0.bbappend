FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

inherit features_check

DEPENDS_append = " pulseaudio"
RCONFLICTS_${PN} = "tc-audio-manager"
REQUIRED_DISTRO_FEATURES = "pulseaudio"

SRC_URI_remove = " git://git.projects.genivi.org/AudioManager.git;branch=master;protocol=http \ "
SRC_URI_append = " git://github.com/GENIVI/AudioManager.git;branch=master;rev=8725157e248c6706de59a02996f869b6ccdccb13;protocol=https \
                   git://github.com/GENIVI/AudioManagerPlugins.git;destsuffix=git/Plugins;branch=master;rev=a0ed3b8f05147e9240d941655488d505057bbae7;protocol=https \
                   file://sqlite_database_handler_change_mainVolume_to_volume.patch \
                   file://fix_dbus_plugins.patch \
                   file://0001-Porting-Pulse-Routing-Interface-from-AM-v1.x-to-AM-v.patch;patchdir=${S}/Plugins \
                   file://0001-Porting-Pulse-Control-Interface-from-AM-v1.x-to-AM-v.patch;patchdir=${S}/Plugins \
                   file://0001-Temporarily-code-block-for-rpi2.patch \
				   file://0001-Modify-TC-AM-Daemon-TCC805x.patch \
				   file://0002-Modify-TC-AM-Daemon-TCC805x.patch \
				   file://0003-Fix-adapt-volume-to-new-stream-TC-AM-Daemon.patch \
				   file://0001-Modify-TC-AM-Plugins-TCC805x.patch;patchdir=${S}/Plugins \
				   file://0002-Modify-TC-AM-Plugins-TCC805x.patch;patchdir=${S}/Plugins \
				   ${@bb.utils.contains('INVITE_PLATFORM', 't-sound', \
						   'file://0003-Modify-TC-AM-Plugin-modify-configs-to-addpt-TSound.patch;patchdir=${S}/Plugins', '', d)} \
				   file://0004-Fix-adapt-volume-to-new-stream-TC-AM-Plugins.patch;patchdir=${S}/Plugins \
                 "

EXTRA_OECMAKE += " \
    -DWITH_PULSE_CONTROL_PLUGIN=ON \
    -DWITH_TEST_CONTROLLER=OFF \
    -DWITH_ENABLED_IPC=DBUS \
    -DWITH_DATABASE_STORAGE=OFF \
    -DWITH_COMMAND_INTERFACE_CAPI=OFF \
    -DWITH_COMMAND_INTERFACE_DBUS=ON \
    -DWITH_ROUTING_INTERFACE_CAPI=OFF \
    -DWITH_ROUTING_INTERFACE_DBUS=OFF \
    -DWITH_ROUTING_INTERFACE_ASYNC=OFF \
    -DWITH_ROUTING_INTERFACE_PULSE=ON \
    "

FILES_${PN} += " \
    ${libdir}/audiomanager/command/*.so* \
    ${libdir}/audiomanager/control/*.conf \
    ${libdir}/audiomanager/control/*.so* \
    ${libdir}/audiomanager/routing/*.conf \
    ${libdir}/audiomanager/routing/*.so* \
    ${systemd_unitdir}/scripts/setup_amgr.sh \
    "
