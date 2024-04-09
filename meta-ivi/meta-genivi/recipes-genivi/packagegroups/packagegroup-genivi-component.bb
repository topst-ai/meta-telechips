DESCRIPTION = "GENIVI components"

inherit packagegroup

PACKAGES = "\
    packagegroup-genivi-component \
    "

ALLOW_EMPTY_${PN} = "1"


RDEPENDS_${PN} += "\
    common-api-c++ \
	common-api-c++-dbus \
    dlt-daemon \
    dlt-daemon-systemd \
    node-startup-controller \
    node-state-manager \
    node-health-monitor \
    persistence-client-library \
    persistence-administrator \
    "
