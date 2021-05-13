inherit trustmegeneric

#
# Create an partitioned trustme image that can be copied to an SD card
#

TEST_CERT_DIR = "${TOPDIR}/test_certificates"
SECURE_BOOT_SIGNING_KEY = "${TEST_CERT_DIR}/ssig_subca.key"
SECURE_BOOT_SIGNING_CERT = "${TEST_CERT_DIR}/ssig_subca.cert"

TRUSTME_BOOTPART_DIR="${DEPLOY_DIR_IMAGE}/trustme_bootpart"
TRUSTME_IMAGE_TMP="${DEPLOY_DIR_IMAGE}/tmp_trustmeimage"

TRUSTME_BOOTPART_DIR="${DEPLOY_DIR_IMAGE}/trustme_bootpart"
TRUSTME_IMAGE_OUT="${DEPLOY_DIR_IMAGE}/trustme_image"

TRUSTME_IMAGE="${TRUSTME_IMAGE_OUT}/trustmeimage.img"

TRUSTME_DEFAULTCONFIG="trustx-core.conf"


do_image_trustmefslc[depends] = " \
    u-boot-mkimage-native:do_populate_sysroot \
    virtual/bootloader:do_deploy \
    virtual/kernel:do_assemble_fitimage_initramfs \
    trustx-cml-initramfs:do_image_complete \
"


do_image_trustmefslc[depends] += " ${TRUSTME_GENERIC_DEPENDS} "

do_fslc_bootpart () {

	if [ -z "${DEPLOY_DIR_IMAGE}" ];then
		bbfatal "Cannot get bitbake variable \"DEPLOY_DIR_IMAGE\""
		exit 1
	fi

	if [ -z "${TRUSTME_BOOTPART_DIR}" ];then
		bbfatal "Cannot get bitbake variable \"TRUSTME_BOOTPART_DIR\""
		exit 1
	fi

	bbnote "Copying boot partition files to ${TRUSTME_BOOTPART_DIR}"
	
	machine=$(echo "${MACHINE}" | tr "_" "-")
	bbdebug 1 "Boot machine: $machine"

	rm -fr "${TRUSTME_BOOTPART_DIR}"
	install -d "${TRUSTME_BOOTPART_DIR}"
	
	cp --dereference "${DEPLOY_DIR_IMAGE}/cml-kernel/fitImage-trustx-cml-initramfs-${MACHINE}-${MACHINE}" "${TRUSTME_BOOTPART_DIR}/fitImage"
}


IMAGE_CMD_trustmefslc () {
	bbnote  "Using standard trustme partition"
	do_fslc_bootpart
	do_build_trustmeimage
}
