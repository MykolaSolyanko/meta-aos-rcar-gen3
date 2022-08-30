FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://domd-set-root \
"

FILES_${PN} += " \
    ${libdir}/xen/bin/domd-set-root \
    ${libdir}/xen/boot/initramfs-domd \
"

RDEPENDS_${PN} += " \
    guestreboot \
"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'virtio', 'true', 'false', d)}; then
        # Increase XT page pool
        sed -i 's/xt_page_pool=67108864/xt_page_pool=603979776/' \
        ${D}${sysconfdir}/xen/domd.cfg
    fi

    # Install domd-set-root script
    install -d ${D}${libdir}/xen/bin
    install -m 0744 ${WORKDIR}/domd-set-root ${D}${libdir}/xen/bin

    # Call domd-set-root script
    echo "[Service]" >> ${D}${systemd_system_unitdir}/domd.service
    echo "ExecStartPre=${libdir}/xen/bin/domd-set-root" >> ${D}${systemd_system_unitdir}/domd.service

    # Add guest reboot dependency
    echo "[Unit]" >> ${D}${systemd_system_unitdir}/domd.service
    echo "Wants=guestreboot@DomD.service" >> ${D}${systemd_system_unitdir}/domd.service
    echo "Before=guestreboot@DomD.service" >> ${D}${systemd_system_unitdir}/domd.service

    # Install domd initramfs
    install -m 0644 ${S}/initramfs-domd.rootfs.cpio.gz ${D}${libdir}/xen/boot/initramfs-domd
}
