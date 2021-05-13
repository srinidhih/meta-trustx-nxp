SRC_URI += "file://trustx.cfg \
            file://imx6ull.cfg \
            "
SRCREV_meta = "aafb8f095e97013d6e55b09ed150369cbe0c6476"
SRC_URI_append += "\
                   git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=yocto-5.4;destsuffix=kernel-meta \
                   "

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_preconfigure () {
        cat ${WORKDIR}/trustx.cfg >> ${WORKDIR}/defconfig
        cat ${WORKDIR}/imx6ull.cfg >> ${WORKDIR}/defconfig
}

addtask do_preconfigure after do_patch before do_configure
