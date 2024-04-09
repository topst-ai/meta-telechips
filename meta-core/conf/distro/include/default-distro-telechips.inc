DISTRO_NAME = "Telechips Baseline (Poky/meta-telechips/meta-core)"
DISTRO_VERSION = "3.1.15"
MAINTAINER = "Telechips System IVI Team <thshin@telechips.com>"

TCMODE ?= "default"
EXTERNAL_TOOLCHAIN ?= ""
TARGET_VENDOR = "-telechips"
TCLIBCAPPEND = ""
ALS_VERSION ??= "TCC805x_Linux_IVI_K5.4_1.0.0"
ALS_RELEASE_DATE ??= "Apr. 8th, 2022"

ALS_BRANCH ??= "TOPST_D3"
ALS_GIT_PROTOCOL ??= "ssh"
ALS_TIME_ZONE ??= "Asia/Seoul"

#
# Default virtual providers
#
PREFERRED_PROVIDER_virtual/db ?= "db"
PREFERRED_PROVIDER_virtual/db-native ?= "db-native"
PREFERRED_PROVIDER_virtual/xserver ?= "xserver-xorg"
PREFERRED_PROVIDER_virtual/xserver-xf86 ?= "xserver-xorg"
PREFERRED_PROVIDER_virtual/update-alternatives ?= "opkg-utils"
PREFERRED_PROVIDER_virtual/update-alternatives-native ?= "opkg-utils-native"
PREFERRED_PROVIDER_virtual/libx11 ?= "libx11"
PREFERRED_PROVIDER_virtual/base-utils ?= "busybox"
PREFERRED_PROVIDER_xf86-video-intel ?= "xf86-video-intel"
PREFERRED_PROVIDER_virtual/make ?= "make"
PREFERRED_PROVIDER_virtual/make-native ?= "make-native"
PREFERRED_PROVIDER_virtual/crypt ?= "glibc"
PREFERRED_PROVIDER_virtual/nativesdk-crypt ?= "nativesdk-glibc"

#
# Default virtual runtime providers
#
VIRTUAL-RUNTIME_update-alternatives ?= "update-alternatives-opkg"
VIRTUAL-RUNTIME_apm ?= "apm"
VIRTUAL-RUNTIME_alsa-state ?= "alsa-state"
VIRTUAL-RUNTIME_getopt ?= "util-linux-getopt"
VIRTUAL-RUNTIME_wireless-tools ?= "iw wireless-tools"
VIRTUAL-RUNTIME_base-utils ?= "busybox"
VIRTUAL-RUNTIME_base-utils-hwclock ?= "busybox-hwclock"
VIRTUAL-RUNTIME_dev_manager ?= "udev"
VIRTUAL-RUNTIME_login_manager ?= "busybox"
VIRTUAL-RUNTIME_libomxil ?= "libomxil-telechips"

#
# Default recipe providers
#
PREFERRED_PROVIDER_dbus-glib ?= "dbus-glib"
PREFERRED_PROVIDER_dbus-glib-native ?= "dbus-glib-native"
PREFERRED_PROVIDER_gdk-pixbuf ?= "gdk-pixbuf"
PREFERRED_PROVIDER_libgcc ?= "libgcc"
PREFERRED_PROVIDER_nativesdk-libgcc ?= "nativesdk-libgcc"
PREFERRED_PROVIDER_linux-libc-headers ?= "linux-libc-headers"
PREFERRED_PROVIDER_nativesdk-linux-libc-headers ?= "nativesdk-linux-libc-headers"
PREFERRED_PROVIDER_matchbox-panel ?= "matchbox-panel-2"
PREFERRED_PROVIDER_opkg ?= "opkg"
PREFERRED_PROVIDER_opkg-native ?= "opkg-native"
PREFERRED_PROVIDER_nativesdk-opkg ?= "nativesdk-opkg"
PREFERRED_PROVIDER_console-tools ?= "kbd"
PREFERRED_PROVIDER_gzip-native ?= "pigz-native"
PREFERRED_RPROVIDER_bluez-hcidump ?= "${@bb.utils.contains('DISTRO_FEATURES','bluetooth bluez5','bluez5','bluez-hcidump',d)}"
# Alternative is ltp-ddt in meta-oe: meta-oe/recipes-devtools/ltp-ddt/ltp-ddt_0.0.4.bb
PREFERRED_PROVIDER_ltp ?= "ltp"
PREFERRED_PROVIDER_getopt ?= "util-linux-getopt"
PREFERRED_PROVIDER_openssl ?= "openssl"
PREFERRED_PROVIDER_openssl-native ?= "openssl-native"
PREFERRED_PROVIDER_nativesdk-openssl ?= "nativesdk-openssl"
PREFERRED_PROVIDER_pkgconfig ?= "pkgconfig"
PREFERRED_PROVIDER_nativesdk-pkgconfig ?= "nativesdk-pkgconfig"
PREFERRED_PROVIDER_pkgconfig-native ?= "pkgconfig-native"
PREFERRED_RPROVIDER_initd-functions ?= "initscripts"

PREFERRED_PROVIDER_virtual/egl           				?= "${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'mesa', 'powervr', d)}"
PREFERRED_PROVIDER_virtual/libgles1      				?= "${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'mesa', 'powervr', d)}"
PREFERRED_PROVIDER_virtual/libgles2      				?= "${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'mesa', 'powervr', d)}"
PREFERRED_PROVIDER_virtual/mesa         				?= "${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'mesa', 'powervr', d)}"
PREFERRED_PROVIDER_libglapi                				?= "${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'mesa', '', d)}"
PREFERRED_PROVIDER_libgbm              					?= "${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'mesa', '', d)}"
PREFERRED_PROVIDER_libwayland-egl        				?= "${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'mesa', '', d)}"
PREFERRED_PROVIDER_vulkan-loader 						?= "${@oe.utils.conditional('TCC_ARCH_FAMILY', 'tcc805x', 'powervr', '', d)}"
PREFERRED_PROVIDER_audiomanager 	       				?= "${@bb.utils.contains('DISTRO_FEATURES', 'pulseaudio', 'audiomanager', 'tc-audio-manager', d)}"
PREFERRED_PROVIDER_virtual/libomxil						?= "libomxil-telechips"

#Gstreamer Version
PREFERRED_VERSION_gstreamer1.0 ?= "1.16.2"
PREFERRED_VERSION_gstreamer1.0-vaapi ?= "1.16.2"
PREFERRED_VERSION_gstreamer1.0-rtsp-server ?= "1.16.2"
PREFERRED_VERSION_gstreamer1.0-python ?= "1.16.2"
PREFERRED_VERSION_gstreamer1.0-plugins-ugly ?= "1.16.2"
PREFERRED_VERSION_gstreamer1.0-plugins-good ?= "1.16.2"
PREFERRED_VERSION_gstreamer1.0-plugins-base ?= "1.16.2"
PREFERRED_VERSION_gstreamer1.0-plugins-bad ?= "1.16.2"
PREFERRED_VERSION_gstreamer1.0-omx ?= "1.16.2"
PREFERRED_VERSION_gstreamer1.0-libav ?= "1.16.2"
PREFERRED_VERSION_gst-validate ?= "1.16.2"
PREFERRED_VERSION_gst-examples ?= "1.16.0"

PREFERRED_VERSION_libdrm ?= "2.4.100"

PREFERRED_VERSION_linux-telechips = "${LINUX_VERSION}"
PREFERRED_VERSION_linux-libc-headers = "${LINUXLIBCVERSION}"

GCCVERSION ?= "arm-9.2"

PREFERRED_VERSION_glibc-locale = "${GLIBCVERSION}"
PREFERRED_VERSION_nativesdk-glibc-locale = "${GLIBCVERSION}"
PREFERRED_VERSION_cross-localedef-native = "${GLIBCVERSION}"

SDK_NAME = "${DISTRO}-${TCLIBC}-${SDK_ARCH}-${IMAGE_BASENAME}-${TUNE_PKGARCH}"
SDKPATH = "/opt/${DISTRO}/${SDK_VERSION}"

DEBUG_PREFIX_MAP_remove ?= "${@oe.utils.conditional('GCCVERSION', 'linaro-7.2', \
							'-fmacro-prefix-map=${WORKDIR}=/usr/src/debug/${PN}/${EXTENDPE}${PV}-${PR}', \
							'', d)}"

#USERADDEXTENSION = "useradd-staticids"
#USERADD_UID_TABLES = "files/telechips-passwd"
#USERADD_GID_TABLES = "files/telechips-group"
#USERADD_ERROR_DYNAMIC = "1"
DEFAULT_USER_NAME ?= "telechips"
DEFAULT_GROUP_NAME ?= "telechips"
DEFAULT_PASSWORD ?= "telechips"
DEFAULT_ROOT_PASSWORD ?= "root"

#set image block size to 4096 because default block size of UFS is 4096.
EXTRA_IMAGECMD_append = " -b 4096"

IMAGE_LINGUAS ?= "en-us en-gb"
ENABLE_BINARY_LOCALE_GENERATION ?= "1"
IMAGE_FEATURES ?= ""
IMAGE_FEATURES_remove = "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'ssh-server-openssh', 'read-only-rootfs', '', d)}"
INVITE_PLATFORM_append = "${@bb.utils.contains('DISTRO_FEATURES', 'wayland', ' drm', '', d)}"

DISTRO_FEATURES_DEFAULT = "alsa argp ext2 irda largefile usbgadget usbhost xattr zeroconf opengl wayland"
DISTRO_FEATURES_BACKFILL_CONSIDERED += "pulseaudio"

DISTRO_FEATURES_LIBC_DEFAULT ?= "ipv4 ipv6 libc-backtrace libc-big-macros libc-bsd libc-cxx-tests libc-catgets libc-charsets libc-crypt \
					libc-crypt-ufc libc-db-aliases libc-envz libc-fcvt libc-fmtmsg libc-fstab libc-ftraverse \
					libc-getlogin libc-idn libc-inet-anl libc-libm libc-locales libc-locale-code \
					libc-memusage libc-nis libc-nsswitch libc-rcmd libc-rtld-debug libc-spawn libc-streams libc-sunrpc \
					libc-utmp libc-utmpx libc-wordexp libc-posix-clang-wchar libc-posix-regexp libc-posix-regexp-glibc \
					libc-posix-wchar-io"
DISTRO_FEATURES_LIBC ?= "${DISTRO_FEATURES_LIBC_DEFAULT}"
DISTRO_FEATURES_LIBC_class-nativesdk = "${DISTRO_FEATURES_LIBC_DEFAULT}"
DISTRO_FEATURES ?= "${DISTRO_FEATURES_DEFAULT} ${DISTRO_FEATURES_LIBC}"
DISTRO_FEATURES_BACKFILL_remove = "bluez5"

# This is a list of packages that are used by the build system to build the distribution, they are not
# directly part of the distribution.
HOSTTOOLS_WHITELIST_GPL-3.0 ?= ""

NO32LIBS ??= "1"

# Missing checksums should raise an error
BB_STRICT_CHECKSUM = "1"

GTK2DISTROFEATURES = "directfb x11"
GTK3DISTROFEATURES = "x11 wayland"

# Set of commercial licenses whitelist
LICENSE_FLAGS_WHITELIST += "commercial_gstreamer1.0-omx"
COMMERCIAL_AUDIO_PLUGINS ?= ""
COMMERCIAL_VIDEO_PLUGINS ?= ""
COMMERCIAL_QT ?= ""

# Set of common licenses used for license.bbclass
COMMON_LICENSE_DIR ??= "${COREBASE}/meta/files/common-licenses"
LICENSE_PATH += "${COREBASE}/../meta-telechips/meta-core/licenses"
LICENSE_PATH += "${COREBASE}/../meta-telechips-bsp/licenses"
COMPATIBLE_LICENSES = "Telechips GPL-3.0-with-GCC-exception GPL-3.0-with-autoconf-exception Apache-2.0 BSL-1.0 BSD-2-Clause BSD-3-Clause ISC MIT Zlib"
COMPATIBLE_LICENSES += "Public-Domain LGPL-2.0 LGPL-2.1 GPL-2.0-with-classpath-exception"
COMPATIBLE_LICENSES += "GPL-1.0 GPL-2.0 GPLv2 bzip2-1.0.6 Sleepycat Python-2.0 BSD-4-Clause PD OpenSSL MPL-2.0 Libpng GFDL-1.2 ICU bzip2-1.0.4 PSF-2.0"
COMPATIBLE_LICENSES += "GFDL-1.3 BSD BSD-0-Clause vim The-Qt-Company-Qt-LGPL-Exception-1.1 NAVER OFL-1.1 CC-BY-SA-3.0"
INCOMPATIBLE_LICENSE ?= "${@' '.join(sorted(set(d.getVar('AVAILABLE_LICENSES').split()) - set(d.getVar('COMPATIBLE_LICENSES').split())))}"

SDKIMAGE_FEATURES = "dev-pkgs"

BUILDCFG_VARS += "LINUX_VERSION KBUILD_DEFCONFIG TCMODE INVITE_PLATFORM IMAGE_FEATURES SDKIMAGE_FEATURES"
BUILDCFG_VARS += "GCCVERSION"
BUILDCFG_VARS += "GLIBCVERSION"

# Bump the connection timeout to 5 minutes to overcome slow proxy servers
FETCHCMD_wget = "/usr/bin/env wget -t 2 -T 300 -nv --passive-ftp --no-check-certificate"

ADDITIONAL_QT5_MODULES ?= ""
ADDITIONAL_QT5_EXAMPLES ?= ""

MACHINE_ESSENTIAL_EXTRA_RDEPENDS = ""

TELECHIPS_AUTOMOTIVE_GIT ?= "git://git@github.com/topst-development"
TELECHIPS_AUTOMOTIVE_BSP_GIT ?= "git://git@github.com/topst-development"
TELECHIPS_AUTOMOTIVE_UTILS_GIT ?= "git://git@github.com/topst-development"
TELECHIPS_AUTOMOTIVE_GRAPHICS_GIT ?= "git://git@github.com/topst-development"
TELECHIPS_AUTOMOTIVE_MULTIMEDIA_GIT ?= "git://git@github.com/topst-development"
TELECHIPS_AUTOMOTIVE_APP_GIT ?= "git://git@github.com/topst-development"
TELECHIPS_AUTOMOTIVE_COMMERCIAL_GIT ?= "git://git@github.com/topst-development"
TELECHIPS_AUTOMOTIVE_TEE_GIT ?= "git://git@github.com/topst-development"

QEMU_TARGETS ?= "arm aarch64 i386 mips mipsel mips64 ppc x86_64"
# Other QEMU_TARGETS "mips64el sh4"

PREMIRRORS ??= " \
bzr://.*/.*   http://downloads.yoctoproject.org/mirror/sources/ \n \
cvs://.*/.*   http://downloads.yoctoproject.org/mirror/sources/ \n \
git://.*/.*   http://downloads.yoctoproject.org/mirror/sources/ \n \
gitsm://.*/.* http://downloads.yoctoproject.org/mirror/sources/ \n \
hg://.*/.*    http://downloads.yoctoproject.org/mirror/sources/ \n \
osc://.*/.*   http://downloads.yoctoproject.org/mirror/sources/ \n \
p4://.*/.*    http://downloads.yoctoproject.org/mirror/sources/ \n \
svn://.*/.*   http://downloads.yoctoproject.org/mirror/sources/ \n \
"

MIRRORS =+ " \
ftp://.*/.*      http://downloads.yoctoproject.org/mirror/sources/ \n \
http://.*/.*     http://downloads.yoctoproject.org/mirror/sources/ \n \
https://.*/.*    http://downloads.yoctoproject.org/mirror/sources/ \n \
"

SOURCE_MIRROR_URL ?= "http://downloads.yoctoproject.org/mirror/sources/"

SSTATE_MIRRORS ?= " \
	file://.* ${SSTATE_MIRROR_URL}/PATH \n \
"

# The CONNECTIVITY_CHECK_URI's are used to test whether we can succesfully
# fetch from the network (and warn you if not). To disable the test set
# the variable to be empty.
# Git example url: git://git.yoctoproject.org/yocto-firewall-test;protocol=git;rev=HEAD

CONNECTIVITY_CHECK_URIS = ""

# Default hash policy for distro
BB_SIGNATURE_HANDLER ?= 'OEBasicHash'
#
# OELAYOUT_ABI allows us to notify users when the format of TMPDIR changes in
# an incompatible way. Such changes should usually be detailed in the commit
# that breaks the format and have been previously discussed on the mailing list
# with general agreement from the core team.
#
OELAYOUT_ABI = "12"

# add rm_work, invite_platform_check
INHERIT += "rm_work invite_platform_check"
RM_WORK_EXCLUDE += "lk lk-dt lk-tcc u-boot u-boot-tcc initramfs-telechips-image linux-telechips kernel-devsrc tc-bsp-utils tc-enable-removable-disk"
RM_WORK_EXCLUDE += "tcc-vpu tcc-ufsd"
RM_WORK_EXCLUDE += "telechips-ivi-image-minimal telechips-ivi-image-gstreamer \
					telechips-ivi-image-qt telechips-ivi-image telechips-ivi-image-update"
RM_WORK_EXCLUDE += "meta-toolchain-telechips meta-toolchain-telechips-ivi meta-toolchain-telechips-qt5"
RM_WORK_EXCLUDE += "liblog logcat"
RM_WORK_EXCLUDE += "libcdk-video libcdk-audio libcdk-demux libomxil-telechips telechips-egl mesa powervr powervr-app"
RM_WORK_EXCLUDE += "gstreamer1.0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-telechips gstreamer1.0-omx "
RM_WORK_EXCLUDE += "libtcconnect libtcutils libtcdbgen libtcipcctrl"
RM_WORK_EXCLUDE += "tc-audio-manager audiomanager audiomanager-demo tc-micom-manager tc-eq-manager tc-dispman tc-mode-manager tc-str-manager"
RM_WORK_EXCLUDE += "tc-launcher tc-media-playback tmplayer tmplayer-gui navit"
RM_WORK_EXCLUDE += "hsm"

# Telechips EVB UFS Size
TCC_UFS_STORAGE_SIZE ?= "31998345216"
TCC_EMMC_STORAGE_SIZE ?= "7818182656"

# Telechips EVB eMMc Size : 32G
#User Capacity: 29.1 GiB (31268536320 Byte)
#TCC_EMMC_STORAGE_SIZE ?= "31268536320"

STORAGE_SIZE ?= "${@oe.utils.conditional('BOOT_STORAGE', 'ufs', '${TCC_UFS_STORAGE_SIZE}', '${TCC_EMMC_STORAGE_SIZE}', d)}"
# Set maximum size of user rw parition. MB
MAX_DATA_SIZE ?= "1024"

# refer to poky distro in meta-yocto layer
# QA check settings - a little stricter than the OE-Core defaults
WARN_TO_ERROR_QA = "already-stripped compile-host-path install-host-path \
                    ldflags pn-overrides rpaths staticdev \
                    useless-rpaths"
WARN_QA_remove = "${WARN_TO_ERROR_QA} host-user-contaminated unhandled-features-check"
ERROR_QA_append = " ${WARN_TO_ERROR_QA}"

ERROR_TO_WARN_QA = "pkgconfig version-going-backwards"
ERROR_QA_remove = "${ERROR_TO_WARN_QA}"
WARN_QA_append = " ${ERROR_TO_WARN_QA}"
