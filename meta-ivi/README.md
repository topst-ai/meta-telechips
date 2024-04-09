meta-ivi, the Yocto layer for TCCxxxx Linux IVI SDK
===================================================================

This layer's purpose is to add In-Vehicle Infotainment (IVI) support when
used with Poky.  The goal is to make the TCCxxxx Linux IVI SDK.

Supported Machines
------------------

We do smoke test the builds of the machine that we currently support:

* TCC805x EVB Board        - emulated machine: tcc8050, tcc8053, tcc8059
* TCC803xPE EVB Board - emulated machine: tcc8031p, tcc8034p

How to enable usb power(vbus)
----------------------------------------------
We turned off the usb power initially then turn on usb power when excute enable-removable-disk.sh

 > The usb power will turn on when active enbale-removable-disk service(meta-telechips-bsp/recipes-core/tc-enable-removable-disk).
 > The enable-removable-disk service will be active when created pid file in /var/run/xxx.pid.
 > xxx is defined by MEDIA_PLAYER_NAME variable in meta-telechips-bsp/conf/machine/tcc-family.inc
 > You can change it in your layer(meta-xxx/conf/layer.conf) or conf/local.conf as follow
   - MEDIA_PLAYER_NAME = "xxx"


Build a TCCxxx Linux IVI SDK image
----------------------------------------------

You can build a TCCxxxx Linux IVI SDK image using the following steps:
If you want more information for build, you can refer to 'TCC805x Linux SDK-Getting Started' document

1. Set-up build envrionment and Choose MACHINE
   > $ source poky/ivi-build.sh
   Choose MACHINE
     1. tcc8031p-main
     2. tcc8034p-main
     3. tcc8050-main
     4. tcc8053-main
     5. tcc8059-main
   select number(1-5) => 3
   machine(tcc8050) graphic backend(wayland) selected.
   ...
   ...

2. Modify local.conf(default value)
   > $ vi conf/local.conf
   a. set numbers of thread : BB_NUMBER_THREADS(8)
   b. set parallel make : PARALLEL_MAKE(16)
   c. additional install packages : CORE_IMAGE_EXTRA_INSTALL
      > you can install extra packages to automotive-linux-platform-image using CORE_IMAGE_EXTRA_INSTALL
   d. combinations : INVITE_PLATFORM
     - tcc805x
      > with-subcore : support subcore(cortex-a53)
      > gpu-vz : support gpu virtualization
      > hud-display : support hud display(DP-Daisy Chain)
      > qt-examples : install qt-examples
     - tcc803xPE
      > with-subcore : support subcore(cortex-a7)
      > cluster-display : support cluster display(Dual LVDS)
      > qt-examples : install qt-examples

3. Select Graphics System and Qt Platform Abstraction using conf/local.conf
   a. Qt5/Wayland(default)
   b. Qt5/EGLFS
      > DISTRO_FEATURES_remove = "wayland"

4. Build automotive-linux-platform-image including TCCxxxx Linux IVI SDK components
   > $ bitbake automotive-linux-platform-image

5. Deploy images: build/telechips/tmp/deploy/images/machine
    - tcc805x
       > boot loader : ca72_bl3.rom
       > kernel : tc-boot-machine.img
       > dtb : tcc805x-linux-lpd432x_sv1.0.dtb
       > rootfs : automotive-linux-platform-image-machine.ext4(read/write or read-only, default is read-only)
              automotive-linux-platform-image-machine.squashfs(only read-only)
    - tcc803xPE
     > boot-firmware
       > boot loader : u-boot-tcc8031p-main.rom
       > kernel : tc-boot-machine.img
       > dtb : tcc803xp-linux-lpd4321_sv1.0.dtb
       > rootfs : automotive-linux-platform-image-machine.ext4(read/write or read-only, default is read-only)
              automotive-linux-platform-image-machine.squashfs(only read-only)

6. To login use these credentials:
   > User - root
   > Password - root
