SUMMARY = "Telechips Network packages for Linux/GNU runtime images"
DESCRIPTION = "The minimal set of packages required to network system"
PR = "r17"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS_${PN} = "\
	packagegroup-core-ssh-openssh \
	${@bb.utils.contains("DISTRO_FEATURES", "sysvinit", "resolvconf ", "", d)} \
	dhcp-client \
	ethtool \
	libnewt \
	net-tools \
	iproute2 \
	${@bb.utils.contains('USE_IP_NETFILTER', '1', 'iptables', '', d)} \
"
