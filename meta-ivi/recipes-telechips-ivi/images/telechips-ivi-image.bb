DESCRIPTION = "This image provides ivi image"

inherit tcc-ivi-image

IMAGE_INSTALL += " \
    packagegroup-telechips-ivi-multimedia \
    packagegroup-telechips-ivi-graphics \
"
