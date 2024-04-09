PROVIDES += "virtual/crypt"

EXTRA_OECONF_remove = "--disable-crypt"

FILES_${PN} += "${base_libdir}/libcrypt-*.so ${base_libdir}/libcrypt*.so.*"
