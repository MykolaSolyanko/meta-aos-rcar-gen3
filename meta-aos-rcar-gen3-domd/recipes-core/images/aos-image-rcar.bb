SUMMARY = "Aos image for Renesas RCAR devices"

require recipes-graphics/images/core-image-weston.bb
require recipes-core/images/aos-image.inc

IMAGE_INSTALL:append = " \
    aos-messageproxy \
    xen-tools-xenstore \
    ${@bb.utils.contains('DISTRO_FEATURES', 'enable_virtio', ' virglrenderer libsdl2 qemu-system-aarch64 qemu-keymaps', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'pvcamera', 'camerabe', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'vis', 'aos-vis', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'sndbe', 'sndbe', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'displbe', 'displbe', '', d)} \
"

# Set fixed rootfs size
IMAGE_ROOTFS_SIZE = "1048576"
IMAGE_OVERHEAD_FACTOR = "1.0"
IMAGE_ROOTFS_EXTRA_SPACE = "0"
