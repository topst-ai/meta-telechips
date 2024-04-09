# Berkeley DB can't support armv8 archecture.
# So, we have to use default setting
ARM_MUTEX = "${@bb.utils.contains('TUNE_FEATURES', 'cortexa53', '', '--with-mutex=ARM/gcc-assembly', d)}"
