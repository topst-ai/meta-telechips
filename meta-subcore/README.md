meta-subcore, the Yocto layer for TCCxxxx Linux IVI SDK
===================================================================

This layer's purpose is to add Sub-core Feature support when used with Poky.

Supported Machines
------------------

We do smoke test the builds of the machine that we currently support:

* TCC805x EVB Board        - emulated machine: tcc8050, tcc8053, tcc8059 (snor boot)
* TCC803xPE EVB Board   - emulated machine: tcc8031p, tcc8034p (snor boot)

Build a TCCxxxx Linux Sub-core image
----------------------------------------------

You can build a TCCxxxx Linux Sub-core image using the following steps:
If you want more information for build, you can refer to 'TCC805x Linux SDK-Getting Started' document

1. Set-up build envrionment and Choose MACHINE
   > $ source poky/ivi-build.sh
   Choose MACHINE
     1. tcc8031p-sub
     2. tcc8034p-sub
     3. tcc8050-sub
     4. tcc8053-sub
     5. tcc8059-sub
   select number(1-5) => 3
   machine(tcc8050-sub) selected.
   ...
   ...

2. Modify local.conf(default value)
   > $ vi conf/local.conf
   a. set numbers of thread : BB_NUMBER_THREADS(8)
   b. set parallel make : PARALLEL_MAKE(16)
   c. additional install packages : CORE_IMAGE_EXTRA_INSTALL
      > you can install extra packages to telechips-subcore-imge using CORE_IMAGE_EXTRA_INSTALL
   d. combinations : INVITE_PLATFORM
     - tcc805x
      > gpu-vz : support gpu virtualization
      > early-camera : support early view feature
   e. combinations : SUBCORE_APPS
      > rvc : intall rear camera app
      > cluster : install cluster app for cockpit

3. Build telechips-subcore-imge including TCC805x Linux IVI SDK Sub-core components
   > $ bitbake telechips-subcore-image

4. Deploy images: build/telechips/tmp/deploy/images/machine
    - tcc805x
       > boot loader : ca53_bl3.rom
       > kernel : tc-boot-machine.img
       > dtb : tcc805x-linux-subcore_svx.x.dtb
       > rootfs : telechips-subcore-image-machine.ext4(read/write or read-only, default is read-only)
    - tcc803xPE
       > kernel : Image-machine.bin
       > dtb : tcc803xpe-linux-a7s-machine.dtb
       > rootfs : telechips-subcore-image-machine.cpio

5. To login use these credentials:
   > User - root
