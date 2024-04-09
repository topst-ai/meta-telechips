do_generate_qt_environment_file_append() {
    echo 'export OE_QMAKE_OBJCOPY=${TARGET_PREFIX}objcopy' >> $script
    echo 'export OE_QMAKE_GDB=${TARGET_PREFIX}gdb' >> $script
}

do_generate_qt_environment_file[umask] = "022"
