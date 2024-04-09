FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

SRC_URI += "file://resolv.conf"

do_install_append () {
	install -m 0644 ${WORKDIR}/interfaces ${D}${sysconfdir}/network/interfaces
	sed -i 's%^#\(\s*iface.*static.*\)%\1%g'  									${D}${sysconfdir}/network/interfaces
	sed -i 's%^#\(\s*hwaddress.*\)MY_MAC_ADDRESS%\1${MY_MAC_ADDRESS}%g'  		${D}${sysconfdir}/network/interfaces
	sed -i 's%^#\(\s*address.*\)MY_IP_ADDRESS%\1${MY_IP_ADDRESS}%g'  			${D}${sysconfdir}/network/interfaces
	sed -i 's%^#\(\s*netmask.*\)%\1%g'  										${D}${sysconfdir}/network/interfaces
	sed -i 's%^#\(\s*network.*\)%\1%g'  										${D}${sysconfdir}/network/interfaces
	sed -i 's%^#\(\s*gateway.*\)MY_GATEWAY_ADDRESS%\1${MY_GATEWAY_ADDRESS}%g'	${D}${sysconfdir}/network/interfaces

	install -m 0644 ${WORKDIR}/resolv.conf ${D}${sysconfdir}/
}

