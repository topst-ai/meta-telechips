FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_remove = "file://bootlogd.init \
				  file://01_bootlogd \
				  "

do_install () {
	oe_runmake 'ROOT=${D}' install

	install -d ${D}${sysconfdir} \
		   ${D}${sysconfdir}/default \
		   ${D}${sysconfdir}/init.d
	for level in S 0 1 2 3 4 5 6; do
		install -d ${D}${sysconfdir}/rc$level.d
	done

	install -m 0644    ${WORKDIR}/rcS-default	${D}${sysconfdir}/default/rcS
	install -m 0755    ${WORKDIR}/rc		${D}${sysconfdir}/init.d
	install -m 0755    ${WORKDIR}/rcS		${D}${sysconfdir}/init.d

	install -d ${D}${sysconfdir}/default/volatiles

	chown root:shutdown ${D}${base_sbindir}/halt ${D}${base_sbindir}/shutdown
	chmod o-x,u+s ${D}${base_sbindir}/halt ${D}${base_sbindir}/shutdown

        # Already provided by e2fsprogs; sysvinit's version is a copy from there
        rm ${D}${base_sbindir}/logsave
        rm ${D}${mandir}/man8/logsave.8
}
