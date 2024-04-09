do_install_append() {
	if ${@bb.utils.contains('INVITE_PLATFORM', 'b2qt', 'true', 'false', d)}; then
		install -d ${D}/data/user/qt/enterprise-dashboard
		install -d ${D}/data/user/qt/enterprise-gallery
		install -d ${D}/data/user/qt/enterprise-flat-controls

	    cp -r ${S}/examples/quick/extras/dashboard/qml ${D}/data/user/qt/enterprise-dashboard/
	    cp -r ${S}/examples/quick/extras/dashboard/images ${D}/data/user/qt/enterprise-dashboard/
	    cp -r ${S}/examples/quick/extras/gallery/qml ${D}/data/user/qt/enterprise-gallery/
	    cp -r ${S}/examples/quick/extras/gallery/images ${D}/data/user/qt/enterprise-gallery/
	    cp -r ${S}/examples/quick/extras/gallery/fonts ${D}/data/user/qt/enterprise-gallery/

	    cp -r ${S}/examples/quick/extras/flat/images ${D}/data/user/qt/enterprise-flat-controls/
	    cp ${S}/examples/quick/extras/flat/*.qml ${D}/data/user/qt/enterprise-flat-controls/

	    sed -i '/import QtQuick.Window/c\' ${D}/data/user/qt/enterprise-dashboard/qml/dashboard.qml ${D}/data/user/qt/enterprise-gallery/qml/gallery.qml
	    sed -i 's/Window /Rectangle /1' ${D}/data/user/qt/enterprise-dashboard/qml/dashboard.qml ${D}/data/user/qt/enterprise-gallery/qml/gallery.qml
	    sed -i 's/ApplicationWindow /Rectangle /1' ${D}/data/user/qt/enterprise-flat-controls/main.qml
	    sed -i '/title: "Qt Quick Extras Demo"/c\' ${D}/data/user/qt/enterprise-dashboard/qml/dashboard.qml ${D}/data/user/qt/enterprise-gallery/qml/gallery.qml
	    sed -i '/title: "Flat Example"/c\' ${D}/data/user/qt/enterprise-flat-controls/main.qml
	    sed -i 's/"Light Flat UI Demo"/"Qt Quick Controls"/1' ${D}/data/user/qt/enterprise-flat-controls/main.qml
	    sed -i '/{ name: "Exit", action: null }/c\' ${D}/data/user/qt/enterprise-flat-controls/main.qml

	    sed -i -e 's/qrc:/../g' ${D}/data/user/qt/enterprise-dashboard/qml/* ${D}/data/user/qt/enterprise-gallery/qml/*
	    sed -i 's/qrc:\///g' ${D}/data/user/qt/enterprise-flat-controls/Content.qml
	fi
}

FILES_${PN} += "/data/user/qt/"
FILES_${PN}-dbg += "/data/user/qt/*/*/.debug/"
