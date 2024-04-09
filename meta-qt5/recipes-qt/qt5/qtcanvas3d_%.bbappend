do_install_append() {
	if ${@bb.utils.contains('INVITE_PLATFORM', 'b2qt', 'true', 'false', d)}; then
		install -d ${D}/data/user/qt/canvas3d-planets

	    cp ${S}/examples/canvas3d/canvas3d/threejs/planets/*.qml  ${D}/data/user/qt/canvas3d-planets
	    cp ${S}/examples/canvas3d/canvas3d/threejs/planets/*.js ${D}/data/user/qt/canvas3d-planets
	    cp -r ${S}/examples/canvas3d/canvas3d/threejs/planets/images ${D}/data/user/qt/canvas3d-planets
	    cp ${S}/examples/canvas3d/canvas3d/threejs/controls/ControlEventSource.qml ${D}/data/user/qt/canvas3d-planets
	    cp ${S}/examples/canvas3d/canvas3d/3rdparty/*.js ${D}/data/user/qt/canvas3d-planets

	    # get rid of qrc:/ prefixes and the custom slider
	    sed -i 's/qrc:\(\/\)\?//g' ${D}/data/user/qt/canvas3d-planets/*.qml
	    sed -i 's/qrc:\(\/\)\?//g' ${D}/data/user/qt/canvas3d-planets/*.js
	    sed -i 's/StyledSlider/Slider/g' ${D}/data/user/qt/canvas3d-planets/planets.qml
	    sed -i '39 i import QtQuick.Controls 1.2' ${D}/data/user/qt/canvas3d-planets/planets.qml
	fi
}

FILES_${PN} += "/data/user/qt/"
FILES_${PN}-dbg += "/data/user/qt/*/*/.debug/"

