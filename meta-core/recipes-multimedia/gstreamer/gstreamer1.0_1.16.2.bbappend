FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
		file://20200312.1-tcc-gstreamer1.0-Add-error-value-of-DIVX-specout.patch \
		file://20200324.1-tcc-gstreamer1.0-can-skip-dummy-data-in-any-parser.patch \
		file://20201019.1-tcc-gstreamer1.0-multiqueue-fix-the-hang-up-queue-full.patch \
		file://20201021.1-tcc-gstreamer1.0-fix-element-prevent-media-lock-up.patch \
		file://20210316.1-tcc-gstreamer1.0-buffer-remove-warning-message-for-over-buffermaxsize.patch \
		file://20210518.1-tcc-gstreamer1.0-baseparse_fix_memory_leak.patch \
		file://20210518.2-tcc-gstreamer1.0-identity-fix-minor-leak-using-meta_str.patch \
		file://20210518.3-tcc-gstreamer1.0-buffer-fix-meta-sequence-number-.patch \
		file://20210518.4-tcc-gstreamer1.0-gstmeta-intern-registered-impl-string.patch \
		file://20210810.1-tcc-gstreamer1.0-multiqueue-modify-memory-leak.patch \
"
