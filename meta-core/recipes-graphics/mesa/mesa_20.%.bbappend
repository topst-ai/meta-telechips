FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://0001-Add-pvr-dri-driver.patch \
	file://0002-Force-Mesa-to-use-the-PVR-driver-for-platform-device.patch \
	file://0003-dri-Add-some-new-DRI-formats-and-fourccs.patch \
	file://0004-dri-Add-MT21-DRI-fourcc-and-DRM-format.patch \
	file://0005-GL_EXT_sparse_texture-entry-points.patch \
	file://0006-Add-support-for-various-GLES-extensions.patch \
	file://0007-Add-EGL_IMG_cl_image-extension.patch \
	file://0008-egl_dri2-set-pbuffer-config-attribs-to-0-for-non-pbu.patch \
	file://0009-egl-Be-stricter-when-making-a-context-current-withou.patch \
	file://0010-egl-optimise-eglMakeCurrent-for-the-case-where-nothi.patch \
	file://0011-GL_EXT_shader_pixel_local_storage2-entry-points.patch \
	file://0012-GL_IMG_framebuffer_downsample-entry-points.patch \
	file://0013-GL_OVR_multiview-entry-points.patch \
	file://0014-Add-OVR_multiview_multisampled_render_to_texture.patch \
	file://0015-wayland-drm-install-wayland-drm.xml-to-the-configure.patch \
	file://0016-Enable-buffer-sharing-in-the-kms_swrast-driver.patch \
	file://0017-egl-wayland-add-support-for-RGB565-back-buffers.patch \
	file://0018-egl-dri3-fix-segfault-in-eglCopyBuffers.patch \
	file://0019-egl-automatically-call-eglReleaseThread-on-thread-te.patch \
	file://0020-egl-add-Tizen-platform-support.patch \
	file://0021-egl-add-support-for-EGL_TIZEN_image_native_surface.patch \
	file://0022-egl-wayland-post-maximum-damage-when-blitting.patch \
	file://0023-egl-wayland-flush-the-drawable-before-blitting.patch \
	file://0024-egl-tizen-create-an-internal-_EGLImage-for-each-tbm-.patch \
	file://0025-dri-use-a-supported-API-in-driCreateNewContext.patch \
	file://0026-gbm-add-gbm_bo_blit.patch \
	file://0027-gbm-don-t-assert-if-DRI-context-creation-fails.patch \
	file://0028-egl-wayland-add-pbuffer-support.patch \
	file://0029-egl-tizen-support-DRI-driver-handling-of-swap-preser.patch \
	file://0030-egl-eglBindAPI-workaround-for-dEQP-bug.patch \
	file://0031-GL_EXT_multi_draw_indirect-entry-points.patch \
	file://0032-dri-add-support-for-YUV-DRI-config.patch \
	file://0033-egl-add-support-for-EXT_yuv_surface.patch \
	file://0034-dri-add-missing-__DRI_IMAGE_COMPONENTS-define-for-EG.patch \
	file://0035-egl-wayland-expose-EXT_yuv_surface-support.patch \
	file://0036-egl-tizen-expose-EXT_yuv_surface-support.patch \
	file://0037-dri2-allow-the-DRM-platform-to-use-swrast.patch \
	file://0038-gbm-add-some-new-GBM-formats.patch \
	file://0039-egl-add-null-platform.patch \
	file://0040-egl-add-config-debug-printout.patch \
	file://0041-egl-dri2-try-to-bind-old-context-if-bindContext-fail.patch \
	file://0042-egl-add-support-for-EXT_image_gl_colorspace.patch \
	file://0043-meson-force-C-2011-for-thread_local.patch \
	file://0044-dri2-add-support-for-swap-intervals-other-than-1.patch \
	file://0045-null_platform-add-support-for-explicit-synchronisati.patch \
	file://0046-dri2-add-support-for-image-modifiers.patch \
	file://0047-egl-query-the-supported-ES2-context-version.patch \
"

LINKER_HASH_STYLE = "sysv"

PE = ""

DRIDRIVERS_append = "pvr"

EXTRA_OEMESON_remove = "-Dglx-read-only-text=true"

PACKAGECONFIG_class-target = " \
	${@bb.utils.filter('DISTRO_FEATURES', 'wayland vulkan', d)} \
	${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'opengl egl gles gbm dri', '', d)} \
"

PACKAGECONFIG_class-native ?= "gbm dri egl opengl"
PACKAGECONFIG_class-nativesdk ?= "gbm dri egl opengl"

PACKAGECONFIG[gles] = "-Dgles1=true -Dgles2=true"
PACKAGECONFIG[egl] = "-Degl=true ${DRI_PLATFORMS}"

DRI_PLATFORMS = " \
	${@bb.utils.contains('INVITE_PLATFORM', 'drm', \
		bb.utils.contains('DISTRO_FEATURES', 'wayland', \
		' -Dplatforms=wayland,drm', \
		' -Dplatforms=drm', d), \
		' -Dplatforms=null', d)} \
"

RDEPENDS_libgles1-mesa += " \
	libgles1-telechips \
"
RDEPENDS_libgles2-mesa += " \
	libgles2-telechips \
"

FILES_libegl-mesa-dev += " \
	${@bb.utils.contains('INVITE_PLATFORM', 'drm', bb.utils.contains('DISTRO_FEATURES', 'wayland', '${datadir}/pkgconfig/wayland-drm.pc', '', d), '', d)} \
"
