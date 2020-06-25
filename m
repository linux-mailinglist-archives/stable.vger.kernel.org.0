Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D6C20A400
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 19:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406791AbgFYR2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 13:28:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406786AbgFYR2B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 13:28:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A476B20775;
        Thu, 25 Jun 2020 17:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593106079;
        bh=sRpRTZxSI6B/OjRbl4+qQSKHQXKipPgru5WuA+yTauw=;
        h=From:To:Cc:Subject:Date:From;
        b=YgxVWDG4kdnqpHKJ0CcsGiyWBm2UDMAjyloULx0+QVpUg946wmtbnk5qjqXDczOd9
         Hu5tp4U+JtsDea+PuoVMntAxG8f+/2NrB+xYEN7WngC0cp4/WMVzE9Af5sJdBv1q+o
         +vnXLCORyEkWrr7jGP91XQQOevAgnCJyM7wJVh5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.130
Date:   Thu, 25 Jun 2020 19:27:42 +0200
Message-Id: <1593106062179209@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.130 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/driver-api/mtdnand.rst                           |    4 
 Makefile                                                       |    2 
 arch/arm/boot/dts/sun8i-h2-plus-bananapi-m2-zero.dts           |    2 
 arch/arm/mach-integrator/Kconfig                               |    7 
 arch/arm64/boot/dts/mediatek/mt8173.dtsi                       |   22 -
 arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi                 |    2 
 arch/arm64/kernel/hw_breakpoint.c                              |   44 +-
 arch/m68k/coldfire/pci.c                                       |    4 
 arch/openrisc/kernel/entry.S                                   |    4 
 arch/powerpc/include/asm/book3s/64/pgtable.h                   |   23 +
 arch/powerpc/include/asm/processor.h                           |    1 
 arch/powerpc/kernel/head_64.S                                  |    9 
 arch/powerpc/kernel/machine_kexec.c                            |    8 
 arch/powerpc/kvm/book3s_64_mmu_radix.c                         |   16 -
 arch/powerpc/perf/hv-24x7.c                                    |   10 
 arch/powerpc/platforms/4xx/pci.c                               |    4 
 arch/powerpc/platforms/ps3/mm.c                                |   22 -
 arch/powerpc/platforms/pseries/ras.c                           |    5 
 arch/s390/include/asm/syscall.h                                |   12 
 arch/x86/boot/Makefile                                         |    2 
 arch/x86/kernel/apic/apic.c                                    |    2 
 arch/x86/kernel/idt.c                                          |    6 
 arch/x86/kernel/kprobes/core.c                                 |   16 -
 arch/x86/kvm/mmu.c                                             |   51 +++
 arch/x86/kvm/x86.c                                             |   31 --
 arch/x86/purgatory/Makefile                                    |    5 
 crypto/algboss.c                                               |    2 
 crypto/algif_skcipher.c                                        |    6 
 drivers/ata/libata-core.c                                      |   11 
 drivers/base/platform.c                                        |    2 
 drivers/block/ps3disk.c                                        |    1 
 drivers/char/ipmi/ipmi_msghandler.c                            |    7 
 drivers/clk/bcm/clk-bcm2835.c                                  |   10 
 drivers/clk/qcom/gcc-msm8916.c                                 |    8 
 drivers/clk/samsung/clk-exynos5420.c                           |   16 -
 drivers/clk/samsung/clk-exynos5433.c                           |    3 
 drivers/clk/sprd/pll.c                                         |    2 
 drivers/clk/st/clk-flexgen.c                                   |    1 
 drivers/clk/sunxi/clk-sunxi.c                                  |    2 
 drivers/clk/ti/composite.c                                     |    1 
 drivers/crypto/omap-sham.c                                     |   64 ++--
 drivers/extcon/extcon-adc-jack.c                               |    3 
 drivers/firmware/qcom_scm.c                                    |    9 
 drivers/fpga/dfl-afu-dma-region.c                              |    4 
 drivers/gpio/gpio-dwapb.c                                      |   34 +-
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c               |    2 
 drivers/gpu/drm/drm_dp_mst_topology.c                          |   58 ++-
 drivers/gpu/drm/drm_encoder_slave.c                            |    5 
 drivers/gpu/drm/i915/i915_cmd_parser.c                         |    4 
 drivers/gpu/drm/i915/i915_irq.c                                |    1 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c                       |    3 
 drivers/gpu/drm/qxl/qxl_kms.c                                  |    2 
 drivers/gpu/drm/sun4i/sun4i_hdmi.h                             |    2 
 drivers/gpu/drm/sun4i/sun4i_hdmi_ddc_clk.c                     |    2 
 drivers/hid/hid-ids.h                                          |    3 
 drivers/hid/hid-quirks.c                                       |    1 
 drivers/i2c/busses/i2c-piix4.c                                 |    3 
 drivers/i2c/busses/i2c-pxa.c                                   |   13 
 drivers/iio/pressure/bmp280-core.c                             |    7 
 drivers/infiniband/core/cma_configfs.c                         |   13 
 drivers/infiniband/hw/cxgb4/device.c                           |    1 
 drivers/infiniband/hw/mlx5/devx.c                              |    1 
 drivers/md/bcache/btree.c                                      |    8 
 drivers/md/dm-mpath.c                                          |    2 
 drivers/md/dm-zoned-metadata.c                                 |    4 
 drivers/md/dm-zoned-reclaim.c                                  |    4 
 drivers/md/md.c                                                |   13 
 drivers/md/raid0.c                                             |    3 
 drivers/mfd/wm8994-core.c                                      |    1 
 drivers/mtd/nand/raw/ams-delta.c                               |    4 
 drivers/mtd/nand/raw/atmel/nand-controller.c                   |    2 
 drivers/mtd/nand/raw/au1550nd.c                                |    4 
 drivers/mtd/nand/raw/bcm47xxnflash/main.c                      |    2 
 drivers/mtd/nand/raw/bcm47xxnflash/ops_bcm4706.c               |    2 
 drivers/mtd/nand/raw/brcmnand/brcmnand.c                       |    4 
 drivers/mtd/nand/raw/cafe_nand.c                               |    4 
 drivers/mtd/nand/raw/cmx270_nand.c                             |    4 
 drivers/mtd/nand/raw/cs553x_nand.c                             |    4 
 drivers/mtd/nand/raw/davinci_nand.c                            |    4 
 drivers/mtd/nand/raw/denali.c                                  |    6 
 drivers/mtd/nand/raw/diskonchip.c                              |   11 
 drivers/mtd/nand/raw/docg4.c                                   |    4 
 drivers/mtd/nand/raw/fsl_elbc_nand.c                           |    5 
 drivers/mtd/nand/raw/fsl_ifc_nand.c                            |    5 
 drivers/mtd/nand/raw/fsl_upm.c                                 |    4 
 drivers/mtd/nand/raw/fsmc_nand.c                               |    4 
 drivers/mtd/nand/raw/gpio.c                                    |    4 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c                     |    4 
 drivers/mtd/nand/raw/hisi504_nand.c                            |    5 
 drivers/mtd/nand/raw/jz4740_nand.c                             |    4 
 drivers/mtd/nand/raw/jz4780_nand.c                             |    6 
 drivers/mtd/nand/raw/lpc32xx_mlc.c                             |    5 
 drivers/mtd/nand/raw/lpc32xx_slc.c                             |    5 
 drivers/mtd/nand/raw/marvell_nand.c                            |    6 
 drivers/mtd/nand/raw/mpc5121_nfc.c                             |    4 
 drivers/mtd/nand/raw/mtk_nand.c                                |    6 
 drivers/mtd/nand/raw/mxc_nand.c                                |    4 
 drivers/mtd/nand/raw/nand_base.c                               |   29 -
 drivers/mtd/nand/raw/nandsim.c                                 |    6 
 drivers/mtd/nand/raw/ndfc.c                                    |    4 
 drivers/mtd/nand/raw/nuc900_nand.c                             |    4 
 drivers/mtd/nand/raw/omap2.c                                   |    4 
 drivers/mtd/nand/raw/orion_nand.c                              |    7 
 drivers/mtd/nand/raw/oxnas_nand.c                              |   18 -
 drivers/mtd/nand/raw/pasemi_nand.c                             |    4 
 drivers/mtd/nand/raw/plat_nand.c                               |    6 
 drivers/mtd/nand/raw/qcom_nandc.c                              |    4 
 drivers/mtd/nand/raw/r852.c                                    |    4 
 drivers/mtd/nand/raw/s3c2410.c                                 |    4 
 drivers/mtd/nand/raw/sh_flctl.c                                |    4 
 drivers/mtd/nand/raw/sharpsl.c                                 |    6 
 drivers/mtd/nand/raw/sm_common.c                               |    2 
 drivers/mtd/nand/raw/socrates_nand.c                           |    7 
 drivers/mtd/nand/raw/sunxi_nand.c                              |    6 
 drivers/mtd/nand/raw/tango_nand.c                              |    4 
 drivers/mtd/nand/raw/tegra_nand.c                              |    2 
 drivers/mtd/nand/raw/tmio_nand.c                               |    6 
 drivers/mtd/nand/raw/txx9ndfmc.c                               |    4 
 drivers/mtd/nand/raw/vf610_nfc.c                               |    4 
 drivers/mtd/nand/raw/xway_nand.c                               |    6 
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c               |    5 
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c                 |    2 
 drivers/net/ethernet/intel/e1000e/netdev.c                     |   14 
 drivers/net/geneve.c                                           |    7 
 drivers/net/hamradio/yam.c                                     |    1 
 drivers/ntb/ntb.c                                              |    9 
 drivers/ntb/test/ntb_perf.c                                    |   30 +
 drivers/ntb/test/ntb_pingpong.c                                |   14 
 drivers/ntb/test/ntb_tool.c                                    |    9 
 drivers/of/kobj.c                                              |    3 
 drivers/pci/controller/dwc/pcie-designware-host.c              |    2 
 drivers/pci/controller/pci-aardvark.c                          |    4 
 drivers/pci/controller/pci-v3-semi.c                           |    2 
 drivers/pci/controller/pcie-rcar.c                             |    9 
 drivers/pci/controller/vmd.c                                   |    6 
 drivers/pci/pcie/aspm.c                                        |   10 
 drivers/pci/pcie/ptm.c                                         |   22 +
 drivers/pci/probe.c                                            |    5 
 drivers/pci/setup-res.c                                        |    9 
 drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c                   |    2 
 drivers/pinctrl/freescale/pinctrl-imx.c                        |   19 -
 drivers/pinctrl/freescale/pinctrl-imx1-core.c                  |    1 
 drivers/pinctrl/pinctrl-rockchip.c                             |    7 
 drivers/pinctrl/pinctrl-rza1.c                                 |    2 
 drivers/power/supply/Kconfig                                   |    2 
 drivers/power/supply/lp8788-charger.c                          |   18 -
 drivers/power/supply/smb347-charger.c                          |    1 
 drivers/pwm/pwm-img.c                                          |    8 
 drivers/remoteproc/remoteproc_core.c                           |    3 
 drivers/s390/cio/qdio.h                                        |    1 
 drivers/s390/cio/qdio_setup.c                                  |    1 
 drivers/s390/cio/qdio_thinint.c                                |   14 
 drivers/scsi/arm/acornscsi.c                                   |    4 
 drivers/scsi/ibmvscsi/ibmvscsi.c                               |    2 
 drivers/scsi/iscsi_boot_sysfs.c                                |    2 
 drivers/scsi/lpfc/lpfc_els.c                                   |    2 
 drivers/scsi/mpt3sas/mpt3sas_base.c                            |    2 
 drivers/scsi/qedf/qedf.h                                       |    1 
 drivers/scsi/qedf/qedf_main.c                                  |   35 ++
 drivers/scsi/qedi/qedi_iscsi.c                                 |    7 
 drivers/scsi/qla2xxx/qla_os.c                                  |    1 
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                             |    2 
 drivers/scsi/sr.c                                              |    6 
 drivers/scsi/ufs/ufs-qcom.c                                    |    6 
 drivers/scsi/ufs/ufshcd.c                                      |    1 
 drivers/slimbus/qcom-ngd-ctrl.c                                |    4 
 drivers/staging/gasket/gasket_sysfs.c                          |    2 
 drivers/staging/greybus/light.c                                |    3 
 drivers/staging/mt29f_spinand/mt29f_spinand.c                  |    2 
 drivers/staging/sm750fb/sm750.c                                |    1 
 drivers/target/target_core_user.c                              |  154 ++++------
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c             |    6 
 drivers/tty/hvc/hvc_console.c                                  |   16 -
 drivers/tty/n_gsm.c                                            |   26 -
 drivers/tty/serial/8250/8250_port.c                            |    4 
 drivers/tty/serial/amba-pl011.c                                |    1 
 drivers/usb/class/usblp.c                                      |    5 
 drivers/usb/dwc2/core_intr.c                                   |    7 
 drivers/usb/dwc3/gadget.c                                      |   24 +
 drivers/usb/gadget/composite.c                                 |   78 +++--
 drivers/usb/gadget/udc/lpc32xx_udc.c                           |   11 
 drivers/usb/gadget/udc/m66592-udc.c                            |    2 
 drivers/usb/gadget/udc/s3c2410_udc.c                           |    4 
 drivers/usb/host/ehci-mxc.c                                    |    2 
 drivers/usb/host/ehci-platform.c                               |  131 ++++++++
 drivers/usb/host/ohci-platform.c                               |    5 
 drivers/usb/host/xhci-plat.c                                   |   10 
 drivers/vfio/mdev/mdev_sysfs.c                                 |    2 
 drivers/vfio/pci/vfio_pci_config.c                             |   14 
 drivers/video/backlight/lp855x_bl.c                            |   20 +
 drivers/watchdog/da9062_wdt.c                                  |    5 
 fs/afs/proc.c                                                  |    1 
 fs/afs/write.c                                                 |    5 
 fs/block_dev.c                                                 |   12 
 fs/dlm/dlm_internal.h                                          |    1 
 fs/ext4/extents.c                                              |    2 
 fs/ext4/super.c                                                |   23 -
 fs/f2fs/super.c                                                |    3 
 fs/gfs2/log.c                                                  |   11 
 fs/gfs2/ops_fstype.c                                           |    2 
 fs/nfs/nfs4proc.c                                              |    2 
 fs/nfsd/nfs4callback.c                                         |    2 
 include/linux/bitops.h                                         |    2 
 include/linux/elfnote.h                                        |    2 
 include/linux/genhd.h                                          |    2 
 include/linux/kprobes.h                                        |    4 
 include/linux/libata.h                                         |    3 
 include/linux/mtd/rawnand.h                                    |    9 
 include/linux/usb/composite.h                                  |    3 
 include/linux/usb/ehci_def.h                                   |    2 
 include/uapi/linux/raid/md_p.h                                 |    2 
 kernel/kprobes.c                                               |   27 +
 kernel/trace/blktrace.c                                        |   30 -
 lib/zlib_inflate/inffast.c                                     |   91 ++---
 net/core/dev.c                                                 |   40 +-
 net/core/filter.c                                              |   16 -
 net/rxrpc/proc.c                                               |    6 
 net/sunrpc/addr.c                                              |    4 
 net/xdp/xsk.c                                                  |    4 
 scripts/mksysmap                                               |    2 
 security/apparmor/domain.c                                     |    9 
 security/apparmor/include/label.h                              |    1 
 security/apparmor/label.c                                      |   37 ++
 security/apparmor/lsm.c                                        |    5 
 security/selinux/ss/services.c                                 |    4 
 sound/isa/wavefront/wavefront_synth.c                          |    8 
 sound/pci/hda/patch_realtek.c                                  |   14 
 sound/soc/codecs/rt5645.c                                      |   14 
 sound/soc/davinci/davinci-mcasp.c                              |    4 
 sound/soc/fsl/fsl_asrc_dma.c                                   |    1 
 sound/soc/img/img-i2s-in.c                                     |    1 
 sound/soc/intel/boards/bytcr_rt5640.c                          |   24 +
 sound/soc/meson/axg-fifo.c                                     |   10 
 sound/soc/soc-core.c                                           |   22 +
 sound/soc/tegra/tegra_wm8903.c                                 |    6 
 sound/usb/card.h                                               |    4 
 sound/usb/endpoint.c                                           |   49 ++-
 sound/usb/endpoint.h                                           |    1 
 sound/usb/pcm.c                                                |    2 
 tools/perf/builtin-report.c                                    |    3 
 tools/testing/selftests/networking/timestamping/timestamping.c |   10 
 tools/testing/selftests/ntb/ntb_test.sh                        |    2 
 tools/testing/selftests/x86/protection_keys.c                  |    3 
 243 files changed, 1439 insertions(+), 887 deletions(-)

Adam Honse (1):
      i2c: piix4: Detect secondary SMBus controller on AMD AM4 chipsets

Aharon Landau (1):
      RDMA/mlx5: Add init2init as a modify command

Ahmed S. Darwish (2):
      block: nr_sects_write(): Disable preemption on seqcount write
      net: core: device_rename: Use rwsem instead of a seqcount

Alain Volmat (1):
      clk: clk-flexgen: fix clock-critical handling

Alex Elder (1):
      remoteproc: Fix IDR initialisation in rproc_alloc()

Alex Williamson (1):
      vfio-pci: Mask cap zero

Alexander Sverdlin (1):
      net: octeon: mgmt: Repair filling of RX ring

Alexander Tsoy (1):
      ALSA: usb-audio: Improve frames size computation

Andreas Klinger (1):
      iio: bmp280: fix compensation of humidity

Andrew Murray (1):
      PCI: rcar: Fix incorrect programming of OB windows

Andy Shevchenko (3):
      iio: pressure: bmp280: Tolerate IRQ before registering
      gpio: dwapb: Call acpi_gpiochip_free_interrupts() on GPIO chip de-registration
      gpio: dwapb: Append MODULE_ALIAS for platform driver

Ard Biesheuvel (2):
      PCI: Allow pci_resize_resource() for devices on root bus
      x86/boot/compressed: Relax sed symbol type regex for LLVM ld.lld

Arnd Bergmann (2):
      dlm: remove BUG() before panic()
      include/linux/bitops.h: avoid clang shift-count-overflow warnings

Bard Liao (1):
      ASoC: core: only convert non DPCM link to DPCM link

Bjorn Helgaas (1):
      PCI/PTM: Inherit Switch Downstream Port PTM settings from Upstream Port

Bob Peterson (2):
      gfs2: Allow lock_nolock mount to specify jid=X
      gfs2: fix use-after-free on transaction ail lists

Bodo Stroesser (1):
      scsi: target: tcmu: Userspace must not complete queued commands

Boris Brezillon (2):
      mtd: rawnand: Pass a nand_chip object to nand_scan()
      mtd: rawnand: Pass a nand_chip object to nand_release()

Borislav Petkov (1):
      x86/apic: Make TSC deadline timer detection message visible

Bryan O'Donoghue (1):
      clk: qcom: msm8916: Fix the address location of pll->config_reg

Can Guo (1):
      scsi: ufs: Don't update urgent bkops level when toggling auto bkops

Chad Dupuis (1):
      scsi: qedf: Fix crash when MFW calls for protocol stats while function is still probing

Chaitanya Kulkarni (3):
      blktrace: use errno instead of bi_status
      blktrace: fix endianness in get_pdu_int()
      blktrace: fix endianness for blk_log_remap()

Chen Yu (1):
      e1000e: Do not wake up the system via WOL if device wakeup is disabled

Chen Zhou (1):
      staging: greybus: fix a missing-check bug in gb_lights_light_config()

Chris Wilson (1):
      drm/i915: Whitelist context-local timestamp in the gen9 cmdparser

Christoph Hellwig (1):
      firmware: qcom_scm: fix bogous abuse of dma-direct internals

Christophe JAILLET (7):
      m68k/PCI: Fix a memory leak in an error handling path
      PCI: v3-semi: Fix a memory leak in v3_pci_probe() error handling paths
      power: supply: lp8788: Fix an error handling path in 'lp8788_charger_probe()'
      extcon: adc-jack: Fix an error handling path in 'adc_jack_probe()'
      pinctrl: imxl: Fix an error handling path in 'imx1_pinctrl_core_probe()'
      pinctrl: freescale: imx: Fix an error handling path in 'imx_pinctrl_probe()'
      scsi: acornscsi: Fix an error handling path in acornscsi_probe()

Chunyan Zhang (1):
      clk: sprd: return correct type of value for _sprd_pll_recalc_rate

Colin Ian King (1):
      usb: gadget: lpc32xx_udc: don't dereference ep pointer before null check

Cristian Klein (1):
      HID: Add quirks for Trust Panora Graphic Tablet

Dafna Hirschfeld (1):
      pinctrl: rockchip: fix memleak in rockchip_dt_node_to_map

Dan Carpenter (4):
      scsi: qedi: Check for buffer overflow in qedi_set_path()
      ALSA: isa/wavefront: prevent out of bounds write in ioctl
      scsi: target: tcmu: Fix a use after free in tcmu_check_expired_queue_cmd()
      of: Fix a refcounting bug in __of_attach_node_sysfs()

David Howells (3):
      rxrpc: Adjust /proc/net/rxrpc/calls to display call->debug_id not user_ID
      afs: Fix non-setting of mtime when writing into mmap
      afs: afs_write_end() should change i_size under the right lock

Dmitry Osipenko (2):
      ASoC: tegra: tegra_wm8903: Support nvidia, headset property
      power: supply: smb347-charger: IRQSTAT_D is volatile

Dmitry V. Levin (1):
      s390: fix syscall_get_error for compat processes

Emmanuel Nicolet (1):
      ps3disk: use the default segment boundary

Enric Balletbo i Serra (1):
      power: supply: bq24257_charger: Replace depends on REGMAP_I2C with select

Eric Biggers (1):
      crypto: algboss - don't wait during notifier callback

Fabrice Gasnier (1):
      usb: dwc2: gadget: move gadget resume after the core is in L0 state

Fedor Tokarev (1):
      net: sunrpc: Fix off-by-one issues in 'rpc_ntop6'

Feng Tang (1):
      ipmi: use vzalloc instead of kmalloc for user creation

Gaurav Singh (1):
      perf report: Fix NULL pointer dereference in hists__fprintf_nr_sample_events()

Geoff Levand (1):
      powerpc/ps3: Fix kexec shutdown hang

Greg Kroah-Hartman (1):
      Linux 4.19.130

Gregory CLEMENT (3):
      tty: n_gsm: Fix SOF skipping
      tty: n_gsm: Fix waking up upper tty layer when room available
      tty: n_gsm: Fix bogus i++ in gsm_data_kick

Hannes Reinecke (1):
      dm zoned: return NULL if dmz_get_zone_for_reclaim() fails to find a zone

Hans de Goede (4):
      x86/purgatory: Disable various profiling and sanitizing options
      ASoC: Intel: bytcr_rt5640: Add quirk for Toshiba Encore WT8-A tablet
      ASoC: Intel: bytcr_rt5640: Add quirk for Toshiba Encore WT10-A tablet
      ASoC: rt5645: Add platform-data for Asus T101HA

Herbert Xu (1):
      crypto: algif_skcipher - Cap recv SG list at ctx->used

Hsin-Yi Wang (1):
      arm64: dts: mt8173: fix unit name warnings

Huacai Chen (1):
      drm/qxl: Use correct notify port address when creating cursor ring

Imre Deak (1):
      drm/i915/icl+: Fix hotplug interrupt disabling after storm detection

Jann Horn (1):
      lib/zlib: remove outdated and incorrect pre-increment optimization

Jason Yan (2):
      pinctrl: rza1: Fix wrong array assignment of rza1l_swio_entries
      block: Fix use-after-free in blkdev_get()

Jeffrey Hugo (1):
      scsi: ufs-qcom: Fix scheduling while atomic issue

Jernej Skrabec (1):
      drm/sun4i: hdmi ddc clk: Fix size of m divider

Jiri Benc (1):
      geneve: change from tx_error to tx_dropped on missing metadata

Jiri Olsa (1):
      kretprobe: Prevent triggering kretprobe from within kprobe_flush_task

John Johansen (2):
      apparmor: fix introspection of of task mode for unconfined tasks
      apparmor: fix nnp subset test for unconfined

John Stultz (1):
      serial: amba-pl011: Make sure we initialize the port.lock spinlock

Jon Derrick (1):
      PCI: vmd: Filter resource type bits from shadow register

Jon Hunter (2):
      backlight: lp855x: Ensure regulators are disabled on probe failure
      arm64: tegra: Fix ethernet phy-mode for Jetson Xavier

Julian Wiedmann (1):
      s390/qdio: put thinint indicator after early error

Kai Huang (2):
      kvm: x86: Move kvm_set_mmio_spte_mask() from x86.c to mmu.c
      kvm: x86: Fix reserved bits related calculation errors caused by MKTME

Kai-Heng Feng (3):
      ALSA: hda/realtek - Introduce polarity for micmute LED GPIO
      PCI/ASPM: Allow ASPM on links to PCIe-to-PCI/PCI-X Bridges
      libata: Use per port sync for detach

Kajol Jain (1):
      powerpc/perf/hv-24x7: Fix inconsistent output values incase multiple hv-24x7 events run

Konstantin Khlebnikov (1):
      f2fs: report delalloc reserve as non-free in statfs for project quota

Kuppuswamy Sathyanarayanan (1):
      drivers: base: Fix NULL pointer exception in __platform_driver_probe() if a driver developer is foolish

Li RongQing (1):
      xdp: Fix xsk_generic_xmit errno

Linus Walleij (1):
      ARM: integrator: Add some Kconfig selections

Logan Gunthorpe (8):
      NTB: ntb_pingpong: Choose doorbells based on port number
      NTB: Fix the default port and peer numbers for legacy drivers
      NTB: ntb_tool: reading the link file should not end in a NULL byte
      NTB: Revert the change to use the NTB device dev for DMA allocations
      NTB: perf: Don't require one more memory window than number of peers
      NTB: perf: Fix support for hardware that doesn't have port numbers
      NTB: perf: Fix race condition when run with ntb_test
      NTB: ntb_test: Fix bug when counting remote files

Lyude Paul (2):
      drm/dp_mst: Reformat drm_dp_check_act_status() a bit
      drm/dp_mst: Increase ACT retry timeout to 3s

Maor Gottlieb (1):
      IB/cma: Fix ports memory leak in cma_configfs

Marc Zyngier (1):
      PCI: dwc: Fix inner MSI IRQ domain registration

Marek Szyprowski (3):
      clk: samsung: Mark top ISP and CAM clocks on Exynos542x as critical
      mfd: wm8994: Fix driver operation if loaded as modules
      clk: samsung: exynos5433: Add IGNORE_UNUSED flag to sclk_i2s1

Martin Wilck (1):
      dm mpath: switch paths in dm_blk_ioctl() code path

Masami Hiramatsu (1):
      kprobes: Fix to protect kick_kprobe_optimizer() by kprobe_mutex

Matej Dujava (1):
      staging: sm750fb: add missing case while setting FB_VISUAL

Mauricio Faria de Oliveira (1):
      apparmor: check/put label on apparmor_sk_clone_security()

Michael Ellerman (1):
      powerpc/64: Don't initialise init_task->thread.regs

Miquel Raynal (9):
      mtd: rawnand: diskonchip: Fix the probe error path
      mtd: rawnand: sharpsl: Fix the probe error path
      mtd: rawnand: xway: Fix the probe error path
      mtd: rawnand: orion: Fix the probe error path
      mtd: rawnand: oxnas: Fix the probe error path
      mtd: rawnand: socrates: Fix the probe error path
      mtd: rawnand: plat_nand: Fix the probe error path
      mtd: rawnand: mtk: Fix the probe error path
      mtd: rawnand: tmio: Fix the probe error path

Nathan Chancellor (2):
      USB: gadget: udc: s3c2410_udc: Remove pointless NULL check in s3c2410_udc_nuke
      clk: bcm2835: Fix return type of bcm2835_register_gate

Navid Emamdoost (1):
      pwm: img: Call pm_runtime_put() in pm_runtime_get_sync() failed case

NeilBrown (1):
      md: add feature flag MD_FEATURE_RAID0_LAYOUT

Nicholas Piggin (1):
      powerpc/pseries/ras: Fix FWNMI_VALID off by one

Nick Desaulniers (1):
      elfnote: mark all .note sections SHF_ALLOC

Nilesh Javali (1):
      scsi: qedi: Do not flush offload work if ARP not resolved

Nishka Dasgupta (1):
      mtd: rawnand: oxnas: Add of_node_put()

Olga Kornievskaia (1):
      NFSv4.1 fix rpc_call_done assignment for BIND_CONN_TO_SESSION

Oliver Neukum (1):
      usblp: poison URBs upon disconnect

Pali Rohár (1):
      PCI: aardvark: Don't blindly enable ASPM L0s and don't write to read-only register

Pavel Machek (CIP) (1):
      ASoC: meson: add missing free_irq() in error path

Pawel Laszczak (1):
      usb: gadget: Fix issue with config_ep_by_speed function

Pingfan Liu (1):
      powerpc/crashkernel: Take "mem=" option into account

Potnuri Bharat Teja (1):
      RDMA/iw_cxgb4: cleanup device debugfs entries on ULD remove

Qais Yousef (3):
      usb/ohci-platform: Fix a warning when hibernating
      usb/xhci-plat: Set PM runtime as active on resume
      usb/ehci-platform: Set PM runtime as active on resume

Qian Cai (3):
      vfio/pci: fix memory leaks in alloc_perm_bits()
      powerpc/64s/pgtable: fix an undefined behaviour
      KVM: PPC: Book3S HV: Ignore kmemleak false positives

Qiushi Wu (4):
      usb: gadget: fix potential double-free in m66592_probe.
      ASoC: fix incomplete error-handling in img_i2s_in_probe.
      vfio/mdev: Fix reference count leak in add_mdev_supported_type
      scsi: iscsi: Fix reference count leak in iscsi_boot_create_kobj

Raghavendra Rao Ananta (1):
      tty: hvc: Fix data abort due to race in hvc_open

Ram Pai (1):
      selftests/vm/pkeys: fix alloc_random_pkey() to make it really random

Rikard Falkeborn (1):
      clk: sunxi: Fix incorrect usage of round_down()

Rob Herring (1):
      PCI: Fix pci_register_host_bridge() device_register() error handling

Roy Spliet (1):
      drm/msm/mdp5: Fix mdp5_init error path for failed mdp5_kms allocation

Russell King (2):
      i2c: pxa: clear all master action bits in i2c_pxa_stop_message()
      i2c: pxa: fix i2c_pxa_scream_blue_murder() debug output

Sandeep Raghuraman (1):
      drm/amdgpu: Replace invalid device ID with a valid device ID

Sanjay R Mehta (2):
      ntb_perf: pass correct struct device to dma_alloc_coherent
      ntb_tool: pass correct struct device to dma_alloc_coherent

Sasha Levin (1):
      ext4: fix partial cluster initialization when splitting extent

Sean Christopherson (1):
      KVM: x86/mmu: Set mmio_value to '0' if reserved #PF can't be generated

Serge Semin (1):
      serial: 8250: Fix max baud limit in generic 8250 port

Shaokun Zhang (1):
      drivers/perf: hisi: Fix wrong value for all counters enable

Simon Arlott (1):
      scsi: sr: Fix sr_probe() missing deallocate of device minor

Souptick Joarder (1):
      fpga: dfl: afu: Corrected error handling levels

Srinivas Kandagatla (1):
      slimbus: ngd: get drvdata from correct device

Stafford Horne (1):
      openrisc: Fix issue with argument clobbering for clone/fork

Stefan Riedmueller (1):
      watchdog: da9062: No need to ping manually before setting timeout

Sudip Mukherjee (1):
      thermal/drivers/ti-soc-thermal: Avoid dereferencing ERR_PTR

Suganath Prabu S (1):
      scsi: mpt3sas: Fix double free warnings

Takashi Iwai (1):
      ALSA: usb-audio: Fix racy list management in output queue

Tang Bin (1):
      USB: host: ehci-mxc: Add error handling in ehci_mxc_drv_probe()

Tero Kristo (2):
      clk: ti: composite: fix memory leak
      crypto: omap-sham - add proper load balancing support for multicore

Theodore Ts'o (1):
      ext4: avoid race conditions when remounting with options that change dax

Thinh Nguyen (1):
      usb: dwc3: gadget: Properly handle failed kick_transfer

Thomas Gleixner (1):
      sched/rt, net: Use CONFIG_PREEMPTION.patch

Tom Rix (1):
      selinux: fix double free

Tyrel Datwyler (1):
      scsi: ibmvscsi: Don't send host info in adapter info MAD after LPM

Viacheslav Dubeyko (2):
      scsi: qla2xxx: Fix issue with adapter's stopping state
      scsi: qla2xxx: Fix warning after FC target reset

Vincent Stehlé (1):
      ARM: dts: sun8i-h2-plus-bananapi-m2-zero: Fix led polarity

Vitaly Kuznetsov (1):
      x86/idt: Keep spurious entries unset in system_vectors

Vladimir Oltean (1):
      Revert "dpaa_eth: fix usage as DSA master, try 3"

Wang Hai (1):
      yam: fix possible memory leak in yam_init_driver

Will Deacon (1):
      arm64: hw_breakpoint: Don't invoke overflow handler on uaccess watchpoints

Wolfram Sang (1):
      drm: encoder_slave: fix refcouting error for modules

Xiyu Yang (6):
      ASoC: davinci-mcasp: Fix dma_chan refcnt leak when getting dma type
      scsi: lpfc: Fix lpfc_nodelist leak when processing unsolicited event
      nfsd: Fix svc_xprt refcnt leak when setup callback client failed
      staging: gasket: Fix mapping refcnt leak when put attribute fails
      staging: gasket: Fix mapping refcnt leak when register/store fails
      ASoC: fsl_asrc_dma: Fix dma_chan leak when config DMA channel failed

YiFei Zhu (1):
      net/filter: Permit reading NET in load_bytes_relative when MAC not set

Yoshihiro Shimoda (1):
      usb: host: ehci-platform: add a quirk to avoid stuck

Zhihao Cheng (1):
      afs: Fix memory leak in afs_put_sysnames()

Zhiqiang Liu (1):
      bcache: fix potential deadlock problem in btree_gc_coalesce

ashimida (1):
      mksysmap: Fix the mismatch of '.L' symbols in System.map

huhai (1):
      powerpc/4xx: Don't unmap NULL mbase

tannerlove (1):
      selftests/net: in timestamping, strncpy needs to preserve null byte

yangerkun (1):
      ext4: stop overwrite the errcode in ext4_setup_super

