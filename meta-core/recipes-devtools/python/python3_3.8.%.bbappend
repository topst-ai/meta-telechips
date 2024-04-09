PACKAGECONFIG:append:class-target = "${@bb.utils.contains("DISTRO_FEATURES", 'x11', ' tk', '', d)}"

