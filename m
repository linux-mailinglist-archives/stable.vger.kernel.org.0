Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D86426E5C6
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 21:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgIQT4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 15:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727741AbgIQOpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 10:45:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B90221974;
        Thu, 17 Sep 2020 14:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600353913;
        bh=gCsCbq60LCQCA+rhJDJuczUXlr3TJcrskbhSKqW1WI8=;
        h=From:To:Cc:Subject:Date:From;
        b=PbUwuULgDdiloGbQpBrc3afWHIXxytR+p6RKyV5TLoDmCn6cBODu9xzGcKeZn8sHV
         ZxmfCSWWnpWlfk9QNblIrBsDYeBfBWYTTt21jBBcLcGc2Ogg14oihJCXqYzkbq5Uwi
         QpKiBpTli985tCCZHAT15GoIkRIhT86AtQdKLpjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.8.10
Date:   Thu, 17 Sep 2020 16:45:44 +0200
Message-Id: <1600353943112188@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.8.10 kernel.

All users of the 5.8 kernel series must upgrade.

The updated 5.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.8.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/sound/designs/timestamping.rst                  |    2 
 Makefile                                                      |    6 
 arch/arc/boot/dts/hsdk.dts                                    |    6 
 arch/arc/kernel/troubleshoot.c                                |   77 --
 arch/arc/plat-eznps/include/plat/ctop.h                       |    1 
 arch/arm/boot/dts/bcm-hr2.dtsi                                |    2 
 arch/arm/boot/dts/bcm-nsp.dtsi                                |    2 
 arch/arm/boot/dts/bcm5301x.dtsi                               |    2 
 arch/arm/boot/dts/imx6sx-pinfunc.h                            |    2 
 arch/arm/boot/dts/imx7d-zii-rmu2.dts                          |    2 
 arch/arm/boot/dts/imx7ulp.dtsi                                |    8 
 arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi               |   29 
 arch/arm/boot/dts/logicpd-torpedo-baseboard.dtsi              |    2 
 arch/arm/boot/dts/ls1021a.dtsi                                |    2 
 arch/arm/boot/dts/omap5.dtsi                                  |   20 
 arch/arm/boot/dts/socfpga_arria10.dtsi                        |    2 
 arch/arm/boot/dts/vfxxx.dtsi                                  |    2 
 arch/arm/mach-omap2/omap-iommu.c                              |    2 
 arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi              |    2 
 arch/arm64/boot/dts/freescale/Makefile                        |    1 
 arch/arm64/boot/dts/freescale/imx8mp.dtsi                     |    2 
 arch/arm64/boot/dts/freescale/imx8mq.dtsi                     |    2 
 arch/arm64/kernel/module-plts.c                               |    3 
 arch/arm64/kvm/mmu.c                                          |    8 
 arch/mips/include/asm/mach-loongson64/cpu-feature-overrides.h |    2 
 arch/powerpc/configs/pasemi_defconfig                         |    1 
 arch/powerpc/configs/ppc6xx_defconfig                         |    1 
 arch/x86/configs/i386_defconfig                               |    1 
 arch/x86/configs/x86_64_defconfig                             |    1 
 arch/x86/kvm/mmu/mmu.c                                        |    2 
 arch/x86/kvm/vmx/nested.c                                     |    2 
 arch/x86/kvm/vmx/vmx.c                                        |    1 
 arch/x86/kvm/x86.c                                            |    2 
 block/bio.c                                                   |    4 
 block/partitions/core.c                                       |    2 
 drivers/atm/firestream.c                                      |    1 
 drivers/block/rbd.c                                           |   12 
 drivers/cpufreq/intel_pstate.c                                |   14 
 drivers/dma/acpi-dma.c                                        |    4 
 drivers/dma/dma-jz4780.c                                      |   38 -
 drivers/firmware/efi/embedded-firmware.c                      |   10 
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c              |    3 
 drivers/gpu/drm/msm/adreno/a2xx_gpu.c                         |    5 
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c                         |   10 
 drivers/gpu/drm/msm/adreno/a4xx_gpu.c                         |   10 
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c                         |   14 
 drivers/gpu/drm/msm/adreno/a5xx_gpu.h                         |    1 
 drivers/gpu/drm/msm/adreno/a5xx_preempt.c                     |   25 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                         |    7 
 drivers/gpu/drm/msm/adreno/adreno_gpu.c                       |   27 
 drivers/gpu/drm/msm/msm_ringbuffer.c                          |    3 
 drivers/gpu/drm/sun4i/sun4i_backend.c                         |    4 
 drivers/gpu/drm/sun4i/sun4i_tcon.c                            |    8 
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c                        |    4 
 drivers/gpu/drm/sun4i/sun8i_vi_layer.c                        |    2 
 drivers/gpu/drm/tve200/tve200_display.c                       |   22 
 drivers/gpu/drm/virtio/virtgpu_display.c                      |   11 
 drivers/gpu/drm/virtio/virtgpu_drv.h                          |    1 
 drivers/gpu/drm/virtio/virtgpu_plane.c                        |    4 
 drivers/hid/hid-elan.c                                        |    2 
 drivers/hid/hid-ids.h                                         |    3 
 drivers/hid/hid-microsoft.c                                   |    2 
 drivers/hid/hid-quirks.c                                      |    2 
 drivers/i2c/busses/i2c-npcm7xx.c                              |    8 
 drivers/iio/accel/bmc150-accel-core.c                         |   15 
 drivers/iio/accel/kxsd9.c                                     |   16 
 drivers/iio/accel/mma7455_core.c                              |   16 
 drivers/iio/accel/mma8452.c                                   |   11 
 drivers/iio/adc/ina2xx-adc.c                                  |   11 
 drivers/iio/adc/max1118.c                                     |   10 
 drivers/iio/adc/mcp3422.c                                     |   16 
 drivers/iio/adc/ti-adc081c.c                                  |   11 
 drivers/iio/adc/ti-adc084s021.c                               |   10 
 drivers/iio/adc/ti-ads1015.c                                  |   10 
 drivers/iio/chemical/ccs811.c                                 |   13 
 drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c     |    5 
 drivers/iio/light/ltr501.c                                    |   15 
 drivers/iio/light/max44000.c                                  |   12 
 drivers/iio/magnetometer/ak8975.c                             |   16 
 drivers/iio/proximity/mb1232.c                                |   17 
 drivers/infiniband/core/cq.c                                  |    4 
 drivers/infiniband/core/verbs.c                               |    2 
 drivers/infiniband/hw/bnxt_re/ib_verbs.c                      |   43 -
 drivers/infiniband/hw/bnxt_re/main.c                          |    3 
 drivers/infiniband/hw/bnxt_re/qplib_fp.c                      |   26 
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c                    |   10 
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h                    |    5 
 drivers/infiniband/hw/mlx4/main.c                             |    3 
 drivers/infiniband/sw/rxe/rxe.c                               |    7 
 drivers/infiniband/sw/rxe/rxe.h                               |    2 
 drivers/infiniband/sw/rxe/rxe_mr.c                            |    1 
 drivers/infiniband/sw/rxe/rxe_sysfs.c                         |    5 
 drivers/infiniband/sw/rxe/rxe_verbs.c                         |    2 
 drivers/infiniband/ulp/isert/ib_isert.c                       |   93 +-
 drivers/infiniband/ulp/isert/ib_isert.h                       |   41 -
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c                  |   16 
 drivers/infiniband/ulp/rtrs/rtrs-srv.c                        |    9 
 drivers/interconnect/qcom/bcm-voter.c                         |   27 
 drivers/iommu/amd/iommu.c                                     |    7 
 drivers/iommu/amd/iommu_v2.c                                  |    7 
 drivers/media/rc/gpio-ir-tx.c                                 |   16 
 drivers/misc/eeprom/at24.c                                    |   11 
 drivers/mmc/core/sdio_ops.c                                   |   39 -
 drivers/mmc/host/sdhci-acpi.c                                 |   31 
 drivers/mmc/host/sdhci-msm.c                                  |   18 
 drivers/mmc/host/sdhci-of-esdhc.c                             |   10 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c               |    6 
 drivers/net/wan/hdlc.c                                        |    2 
 drivers/net/wan/hdlc_cisco.c                                  |    1 
 drivers/net/wan/lapbether.c                                   |    3 
 drivers/nfc/st95hf/core.c                                     |    2 
 drivers/nvme/host/core.c                                      |    8 
 drivers/nvme/host/fabrics.c                                   |   13 
 drivers/nvme/host/nvme.h                                      |    3 
 drivers/nvme/host/pci.c                                       |    4 
 drivers/nvme/host/rdma.c                                      |   68 +-
 drivers/nvme/host/tcp.c                                       |   80 +-
 drivers/nvme/target/tcp.c                                     |   10 
 drivers/phy/qualcomm/phy-qcom-qmp.c                           |   16 
 drivers/phy/qualcomm/phy-qcom-qmp.h                           |    2 
 drivers/regulator/core.c                                      |  155 ++--
 drivers/scsi/libsas/sas_ata.c                                 |    5 
 drivers/scsi/lpfc/lpfc_init.c                                 |    1 
 drivers/scsi/megaraid/megaraid_sas_fusion.c                   |    2 
 drivers/scsi/mpt3sas/mpt3sas_base.c                           |    2 
 drivers/scsi/qedf/qedf_main.c                                 |    2 
 drivers/scsi/qla2xxx/qla_def.h                                |    2 
 drivers/scsi/qla2xxx/qla_init.c                               |    6 
 drivers/soundwire/stream.c                                    |    8 
 drivers/spi/spi-stm32.c                                       |    8 
 drivers/staging/greybus/audio_topology.c                      |   29 
 drivers/staging/wlan-ng/hfa384x_usb.c                         |    5 
 drivers/staging/wlan-ng/prism2usb.c                           |   19 
 drivers/target/iscsi/iscsi_target.c                           |   17 
 drivers/target/iscsi/iscsi_target_login.c                     |    6 
 drivers/target/iscsi/iscsi_target_login.h                     |    3 
 drivers/target/iscsi/iscsi_target_nego.c                      |    3 
 drivers/thunderbolt/switch.c                                  |    1 
 drivers/thunderbolt/tb.h                                      |    2 
 drivers/usb/core/message.c                                    |   91 +-
 drivers/usb/core/sysfs.c                                      |    5 
 drivers/usb/dwc3/dwc3-meson-g12a.c                            |   15 
 drivers/usb/serial/ftdi_sio.c                                 |    1 
 drivers/usb/serial/ftdi_sio_ids.h                             |    1 
 drivers/usb/serial/option.c                                   |   22 
 drivers/usb/typec/mux/intel_pmc_mux.c                         |   14 
 drivers/usb/typec/ucsi/ucsi_acpi.c                            |    4 
 drivers/video/console/Kconfig                                 |   46 -
 drivers/video/console/vgacon.c                                |  221 ------
 drivers/video/fbdev/core/bitblit.c                            |   11 
 drivers/video/fbdev/core/fbcon.c                              |  334 ----------
 drivers/video/fbdev/core/fbcon.h                              |    2 
 drivers/video/fbdev/core/fbcon_ccw.c                          |   11 
 drivers/video/fbdev/core/fbcon_cw.c                           |   11 
 drivers/video/fbdev/core/fbcon_ud.c                           |   11 
 drivers/video/fbdev/core/tileblit.c                           |    2 
 drivers/video/fbdev/vga16fb.c                                 |    2 
 fs/btrfs/disk-io.c                                            |    2 
 fs/btrfs/extent-tree.c                                        |   19 
 fs/btrfs/ioctl.c                                              |    3 
 fs/btrfs/print-tree.c                                         |   12 
 fs/btrfs/transaction.c                                        |    1 
 fs/btrfs/volumes.c                                            |   10 
 fs/debugfs/file.c                                             |    4 
 fs/xfs/libxfs/xfs_attr_leaf.c                                 |    4 
 fs/xfs/libxfs/xfs_ialloc.c                                    |    4 
 fs/xfs/libxfs/xfs_trans_space.h                               |    2 
 include/linux/efi_embedded_fw.h                               |    6 
 include/linux/netfilter/nf_conntrack_sctp.h                   |    2 
 include/soc/nps/common.h                                      |    6 
 kernel/gcov/gcc_4_7.c                                         |    4 
 kernel/padata.c                                               |    5 
 kernel/seccomp.c                                              |   13 
 lib/kobject.c                                                 |    6 
 lib/test_firmware.c                                           |    9 
 net/mac80211/sta_info.h                                       |    4 
 net/mac80211/status.c                                         |   31 
 net/netfilter/nf_conntrack_proto_sctp.c                       |   39 +
 net/netfilter/nft_set_rbtree.c                                |   34 -
 net/wireless/chan.c                                           |   15 
 net/wireless/util.c                                           |    8 
 sound/hda/hdac_device.c                                       |    2 
 sound/hda/intel-dsp-config.c                                  |   10 
 sound/pci/hda/hda_tegra.c                                     |    7 
 sound/pci/hda/patch_hdmi.c                                    |    6 
 sound/x86/Kconfig                                             |    2 
 tools/testing/selftests/timers/Makefile                       |    1 
 tools/testing/selftests/timers/settings                       |    1 
 virt/kvm/kvm_main.c                                           |   21 
 189 files changed, 1293 insertions(+), 1403 deletions(-)

Adam Ford (3):
      ARM: dts: logicpd-torpedo-baseboard: Fix broken audio
      ARM: dts: logicpd-som-lv-baseboard: Fix broken audio
      ARM: dts: logicpd-som-lv-baseboard: Fix missing video

Adrian Hunter (1):
      mmc: sdio: Use mmc_pre_req() / mmc_post_req()

Aleksander Morgado (1):
      USB: serial: option: add support for SIM7070/SIM7080/SIM7090 modules

Alexandru Elisei (1):
      KVM: arm64: Update page shift if stage 2 block mapping not supported

Amar Singhal (1):
      cfg80211: Adjust 6 GHz frequency to channel conversion

Amjad Ouled-Ameur (1):
      Revert "usb: dwc3: meson-g12a: fix shared reset control use"

Andy Shevchenko (1):
      kobject: Restore old behaviour of kobject_del(NULL)

Angelo Compagnucci (2):
      iio: adc: mcp3422: fix locking scope
      iio: adc: mcp3422: fix locking on error path

Anson Huang (1):
      ARM: dts: imx7ulp: Correct gpio ranges

Bjørn Mork (1):
      USB: serial: option: support dynamic Quectel USB compositions

Brian Foster (1):
      xfs: fix off-by-one in inode alloc block reservation calculation

Chenyi Qiang (1):
      KVM: nVMX: Fix the update value of nested load IA32_PERF_GLOBAL_CTRL control

Chris Healy (2):
      ARM: dts: imx7d-zii-rmu2: fix rgmii phy-mode for ksz9031 phy
      ARM: dts: vfxxx: Add syscon compatible with OCOTP

Chris Packham (1):
      mmc: sdhci-of-esdhc: Don't walk device-tree on every interrupt

Christoph Hellwig (1):
      block: restore a specific error code in bdev_del_partition

Dan Carpenter (1):
      spi: stm32: fix pm_runtime_get_sync() error checking

Daniel Jordan (1):
      padata: fix possible padata_works_lock deadlock

Darrick J. Wong (1):
      xfs: initialize the shortform attr header padding entry

David Shah (1):
      ARM: dts: omap5: Fix DSI base address and clocks

Dinghao Liu (4):
      RDMA/rxe: Fix memleak in rxe_mem_init_user
      NFC: st95hf: Fix memleak in st95hf_in_send_cmd
      firestream: Fix memleak in fs_open
      HID: elan: Fix memleak in elan_input_configured

Dinh Nguyen (1):
      ARM: dts: socfpga: fix register entry for timer3 on Arria10

Dmitry Osipenko (1):
      regulator: core: Fix slab-out-of-bounds in regulator_unlock_recursive()

Douglas Anderson (1):
      mmc: sdhci-msm: Add retries when all tuning phases are found valid

Evgeniy Didin (1):
      ARC: [plat-hsdk]: Switch ethernet phy-mode to rgmii-id

Felix Fietkau (1):
      mac80211: reduce packet loss event false positives

Filipe Manana (2):
      btrfs: fix NULL pointer dereference after failure to create snapshot
      btrfs: fix wrong address when faulting in pages in the search ioctl

Florian Fainelli (4):
      ARM: dts: bcm: HR2: Fixed QSPI compatible string
      ARM: dts: NSP: Fixed QSPI compatible string
      ARM: dts: BCM5301X: Fixed QSPI compatible string
      arm64: dts: ns2: Fixed QSPI compatible string

Florian Westphal (1):
      netfilter: conntrack: allow sctp hearbeat after connection re-use

Francisco Jerez (1):
      cpufreq: intel_pstate: Fix intel_pstate_get_hwp_max() for turbo disabled

Fugang Duan (1):
      ARM: dts: imx6sx: fix the pad QSPI1B_SCLK mux mode for uart3

Gerd Hoffmann (1):
      drm/virtio: fix unblank

Greg Kroah-Hartman (1):
      Linux 5.8.10

Gwendal Grignou (1):
      iio: cros_ec: Set Gyroscope default frequency to 25Hz

Hanjun Guo (1):
      dmaengine: acpi: Put the CSRT table after using it

Heikki Krogerus (1):
      usb: typec: ucsi: acpi: Check the _DEP dependencies

Hou Pu (1):
      scsi: target: iscsi: Fix hang in iscsit_access_np() when getting tpg->np_login_sem

Ilya Dryomov (1):
      rbd: require global CAP_SYS_ADMIN for mapping and unmapping

James Smart (2):
      scsi: lpfc: Fix setting IRQ affinity with an empty CPU mask
      nvme: Revert: Fix controller creation races with teardown flow

Jernej Skrabec (1):
      drm/sun4i: Fix DE2 YVU handling

Jessica Yu (1):
      arm64/module: set trampoline section flags regardless of CONFIG_DYNAMIC_FTRACE

Jiaxun Yang (1):
      MIPS: Loongson64: Do not override watch and ejtag feature

Jing Xiangfeng (1):
      ARM: OMAP2+: Fix an IS_ERR() vs NULL check in _get_pwrdm()

Joerg Roedel (2):
      iommu/amd: Do not force direct mapping when SME is active
      iommu/amd: Do not use IOMMUv2 functionality when SME is active

Jonathan Cameron (13):
      iio:light:ltr501 Fix timestamp alignment issue.
      iio:proximity:mb1232: Fix timestamp alignment and prevent data leak.
      iio:accel:bmc150-accel: Fix timestamp alignment and prevent data leak.
      iio:adc:ti-adc084s021 Fix alignment and data leak issues.
      iio:adc:ina2xx Fix timestamp alignment issue.
      iio:adc:max1118 Fix alignment of timestamp and data leak issues
      iio:adc:ti-adc081c Fix alignment and data leak issues
      iio:magnetometer:ak8975 Fix alignment and data leak issues.
      iio:light:max44000 Fix timestamp alignment and prevent data leak.
      iio:chemical:ccs811: Fix timestamp alignment and prevent data leak.
      iio: accel: kxsd9: Fix alignment of local buffer.
      iio:accel:mma7455: Fix timestamp alignment and prevent data leak.
      iio:accel:mma8452: Fix timestamp alignment and prevent data leak.

Jordan Crouse (3):
      drm/msm: Split the a5xx preemption record
      drm/msm: Disable preemption on all 5xx targets
      drm/msm: Disable the RPTR shadow

Josef Bacik (2):
      btrfs: fix lockdep splat in add_missing_dev
      btrfs: free data reloc tree on failed mount

Josh Poimboeuf (1):
      Revert "kbuild: use -flive-patching when CONFIG_LIVEPATCH is enabled"

Kamal Heib (3):
      RDMA/rxe: Drop pointless checks in rxe_init_ports
      RDMA/rxe: Fix panic when calling kmem_cache_create()
      RDMA/core: Fix reported speed and width

Kees Cook (1):
      test_firmware: Test platform fw loading on non-EFI systems

Krzysztof Kozlowski (1):
      arm64: dts: imx8mq: Fix TMU interrupt property

Lai Jiangshan (1):
      kvm x86/mmu: use KVM_REQ_MMU_SYNC to sync when needed

Leon Romanovsky (1):
      gcov: Disable gcov build with GCC 10

Linus Torvalds (3):
      fbcon: remove soft scrollback code
      fbcon: remove now unusued 'softback_lines' cursor() argument
      vgacon: remove software scrollback support

Linus Walleij (1):
      drm/tve200: Stabilize enable/disable

Luo Jiaxing (1):
      scsi: libsas: Set data_dir as DMA_NONE if libata marks qc as NODATA

Madhuparna Bhowmik (1):
      drivers/dma/dma-jz4780: Fix race condition between probe and irq handler

Madhusudanarao Amara (1):
      usb: typec: intel_pmc_mux: Un-register the USB role switch

Marc Zyngier (1):
      KVM: arm64: Do not try to map PUDs when they are folded into PMD

Marek Vasut (1):
      spi: stm32: Rate-limit the 'Communication suspended' message

Mark Bloch (1):
      RDMA/mlx4: Read pkey table length instead of hardcoded value

Mathias Nyman (1):
      usb: Fix out of sync data toggle if a configured device is reconfigured

Matthias Schiffer (1):
      ARM: dts: ls1021a: fix QuadSPI-memory reg range

Maxim Kochetkov (1):
      iio: adc: ti-ads1015: fix conversion when CONFIG_PM is not set

Maxime Ripard (2):
      drm/sun4i: backend: Support alpha property on lowest plane
      drm/sun4i: backend: Disable alpha on the lowest plane on the A20

Md Haris Iqbal (2):
      RDMA/rtrs-srv: Replace device_register with device_initialize and device_add
      RDMA/rtrs-srv: Set .release function for rtrs srv device during device init

Michał Mirosław (6):
      regulator: push allocation in regulator_ena_gpio_request() out of lock
      regulator: remove superfluous lock in regulator_resolve_coupling()
      regulator: push allocation in regulator_init_coupling() outside of lock
      regulator: push allocations in create_regulator() outside of lock
      regulator: push allocation in set_consumer_device_supply() out of lock
      regulator: plug of_node leak in regulator_register()'s error path

Mike Tipton (1):
      interconnect: qcom: Fix small BW votes being truncated to zero

Mohan Kumar (2):
      ALSA: hda: Fix 2 channel swapping for Tegra
      ALSA: hda/tegra: Program WAKEEN register for Tegra

Naresh Kumar PBS (2):
      RDMA/bnxt_re: Static NQ depth allocation
      RDMA/bnxt_re: Fix driver crash on unaligned PSN entry address

Nicholas Miell (1):
      HID: microsoft: Add rumble support for the 8bitdo SN30 Pro+ controller

Nikunj A. Dadhania (1):
      thunderbolt: Disable ports that are not implemented

Nirenjan Krishnan (1):
      HID: quirks: Set INCREMENT_USAGE_ON_DUPLICATE for all Saitek X52 devices

Ondrej Jirman (1):
      drm/sun4i: Fix dsi dcs long write function

Patrick Riphagen (1):
      USB: serial: ftdi_sio: add IDs for Xsens Mti USB converter

Peter Oberparleiter (1):
      gcov: add support for GCC 10.1

Pierre-Louis Bossart (1):
      ALSA: hda: use consistent HDAudio spelling in comments/docs

Po-Hsu Lin (1):
      selftests/timers: Turn off timeout setting

Qu Wenruo (1):
      btrfs: require only sector size alignment for parent eb bytenr

Rafael J. Wysocki (1):
      cpufreq: intel_pstate: Refuse to turn off with HWP enabled

Rander Wang (2):
      ALSA: hda: hdmi - add Rocketlake support
      ALSA: hda: fix a runtime pm issue in SOF when integrated GPU is disabled

Raul E Rangel (1):
      mmc: sdhci-acpi: Clear amd_sdhci_host on reset

René Rebe (1):
      scsi: qla2xxx: Fix regression on sparc64

Ritesh Harjani (1):
      block: Set same_page to false in __bio_try_merge_page if ret is false

Rob Clark (1):
      drm/msm/gpu: make ringbuffer readonly

Rob Herring (1):
      arm64: dts: imx: Add missing imx8mm-beacon-kit.dtb to build

Robin Gong (1):
      arm64: dts: imx8mp: correct sdma1 clk setting

Rustam Kovhaev (2):
      staging: wlan-ng: fix out of bounds read in prism2sta_probe_usb()
      KVM: fix memory leak in kvm_io_bus_unregister_dev()

Sagi Grimberg (10):
      nvme-fabrics: allow to queue requests for live queues
      IB/isert: Fix unaligned immediate-data handling
      nvme-fabrics: don't check state NVME_CTRL_NEW for request acceptance
      nvme: have nvme_wait_freeze_timeout return if it timed out
      nvme-tcp: serialize controller teardown sequences
      nvme-tcp: fix timeout handler
      nvme-tcp: fix reset hang if controller died in the middle of a reset
      nvme-rdma: serialize controller teardown sequences
      nvme-rdma: fix timeout handler
      nvme-rdma: fix reset hang if controller died in the middle of a reset

Sandeep Raghuraman (1):
      drm/amdgpu: Fix bug in reporting voltage for CIK

Sean Young (1):
      media: gpio-ir-tx: spinlock is not needed to disable interrupts

Selvin Xavier (3):
      RDMA/bnxt_re: Do not report transparent vlan from QP1
      RDMA/bnxt_re: Fix the qp table indexing
      RDMA/bnxt_re: Remove the qp from list only if the qp destroy succeeds

Shay Bar (1):
      wireless: fix wrong 160/80+80 MHz setting

Sivaprakash Murugesan (1):
      phy: qcom-qmp: Use correct values for ipq8074 PCIe Gen2 PHY init

Stefano Brivio (1):
      netfilter: nft_set_rbtree: Detect partial overlap with start endpoint match

Tali Perry (1):
      i2c: npcm7xx: Fix timeout calculation

Tetsuo Handa (1):
      video: fbdev: fix OOB read in vga_8planes_imageblit()

Tom Rix (1):
      soundwire: fix double free of dangling pointer

Tomas Henzl (2):
      scsi: megaraid_sas: Don't call disable_irq from process IRQ poll
      scsi: mpt3sas: Don't call disable_irq from IRQ poll handler

Tong Zhang (1):
      nvme-pci: cancel nvme device request before disabling

Tycho Andersen (1):
      seccomp: don't leak memory when filter install races

Utkarsh Patel (2):
      usb: typec: intel_pmc_mux: Do not configure Altmode HPD High
      usb: typec: intel_pmc_mux: Do not configure SBU and HSL Orientation in Alternate modes

Vadym Kochan (1):
      misc: eeprom: at24: register nvmem only after eeprom is ready to use

Vaibhav Agarwal (1):
      staging: greybus: audio: fix uninitialized value issue

Varun Prakash (1):
      scsi: target: iscsi: Fix data digest calculation

Vineet Gupta (3):
      ARC: HSDK: wireup perf irq
      ARC: show_regs: fix r12 printing and simplify
      irqchip/eznps: Fix build error for !ARC700 builds

Vitaly Kuznetsov (1):
      KVM: x86: always allow writing '0' to MSR_KVM_ASYNC_PF_EN

Vladis Dronov (1):
      debugfs: Fix module state check condition

Wanpeng Li (1):
      KVM: VMX: Don't freeze guest when event delivery causes an APIC-access exit

Xi Wang (1):
      RDMA/core: Fix unsafe linked list traversal after failing to allocate CQ

Xie He (4):
      drivers/net/wan/lapbether: Added needed_tailroom
      drivers/net/wan/lapbether: Set network_header before transmitting
      drivers/net/wan/hdlc_cisco: Add hard_header_len
      drivers/net/wan/hdlc: Change the default of hard_header_len to 0

Ye Bin (1):
      scsi: qedf: Fix null ptr reference in qedf_stag_change_work

Yi Li (1):
      net: hns3: Fix for geneve tx checksum bug

Yi Zhang (1):
      RDMA/rxe: Fix the parent sysfs read when the interface has 15 chars

Yu Kuai (1):
      drm/sun4i: add missing put_device() call in sun8i_r40_tcon_tv_set_mux()

Zeng Tao (1):
      usb: core: fix slab-out-of-bounds Read in read_descriptors

Ziye Yang (1):
      nvmet-tcp: Fix NULL dereference when a connect data comes in h2cdata pdu

