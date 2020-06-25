Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F81820A3F7
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 19:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406768AbgFYR1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 13:27:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404701AbgFYR1i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 13:27:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7D9820775;
        Thu, 25 Jun 2020 17:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593106057;
        bh=fY1UBPjuD8XBIsINj9CgueLXjQsmBOUEGFMaHQ7+tf0=;
        h=From:To:Cc:Subject:Date:From;
        b=YSixO/ZRUiY4p03FxK9SWLVmMR0IHPuf8dfUhllLr610i1IPKIXaOcmKs9v1y6TKV
         brOqyJ/aXwUt/k9qDyfHzn/nmmahMT54/8doVWGMICzrPWWzkOsfeob0NyS9EXrsrL
         JepDsPSqBb2sa1I2I+otLL+UCpcm9j6fdYY9JFaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.186
Date:   Thu, 25 Jun 2020 19:27:31 +0200
Message-Id: <159310605120626@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.186 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/driver-api/mtdnand.rst                           |    2 
 Makefile                                                       |    2 
 arch/arm/mach-integrator/Kconfig                               |    7 
 arch/arm64/kernel/hw_breakpoint.c                              |   44 ++--
 arch/m68k/coldfire/pci.c                                       |    4 
 arch/openrisc/kernel/entry.S                                   |    4 
 arch/powerpc/include/asm/book3s/64/pgtable.h                   |   23 ++
 arch/powerpc/kernel/machine_kexec.c                            |    8 
 arch/powerpc/perf/hv-24x7.c                                    |   10 -
 arch/powerpc/platforms/4xx/pci.c                               |    4 
 arch/powerpc/platforms/ps3/mm.c                                |   22 +-
 arch/powerpc/platforms/pseries/ras.c                           |    5 
 arch/s390/include/asm/syscall.h                                |   12 +
 arch/x86/boot/Makefile                                         |    2 
 arch/x86/kernel/apic/apic.c                                    |    2 
 arch/x86/kernel/kprobes/core.c                                 |   16 -
 arch/x86/kvm/mmu.c                                             |   51 +++++
 arch/x86/kvm/x86.c                                             |   31 ---
 crypto/algboss.c                                               |    2 
 crypto/algif_skcipher.c                                        |    6 
 drivers/ata/libata-core.c                                      |   11 -
 drivers/base/platform.c                                        |    2 
 drivers/block/ps3disk.c                                        |    1 
 drivers/clk/bcm/clk-bcm2835.c                                  |   10 -
 drivers/clk/qcom/gcc-msm8916.c                                 |    8 
 drivers/clk/samsung/clk-exynos5433.c                           |    3 
 drivers/clk/st/clk-flexgen.c                                   |    1 
 drivers/clk/sunxi/clk-sunxi.c                                  |    2 
 drivers/clk/ti/composite.c                                     |    1 
 drivers/crypto/omap-sham.c                                     |   64 +++----
 drivers/extcon/extcon-adc-jack.c                               |    3 
 drivers/gpu/drm/drm_dp_mst_topology.c                          |   58 +++---
 drivers/gpu/drm/drm_encoder_slave.c                            |    5 
 drivers/gpu/drm/i915/i915_cmd_parser.c                         |    4 
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c                        |    3 
 drivers/gpu/drm/qxl/qxl_kms.c                                  |    2 
 drivers/gpu/drm/sun4i/sun4i_hdmi.h                             |    2 
 drivers/gpu/drm/sun4i/sun4i_hdmi_ddc_clk.c                     |    2 
 drivers/i2c/busses/i2c-piix4.c                                 |    3 
 drivers/i2c/busses/i2c-pxa.c                                   |   13 -
 drivers/iio/pressure/bmp280-core.c                             |    7 
 drivers/infiniband/core/cma_configfs.c                         |   13 +
 drivers/md/bcache/btree.c                                      |    8 
 drivers/md/dm-mpath.c                                          |    2 
 drivers/md/dm-zoned-metadata.c                                 |    4 
 drivers/md/dm-zoned-reclaim.c                                  |    4 
 drivers/md/md.c                                                |   13 +
 drivers/md/raid0.c                                             |    3 
 drivers/mfd/wm8994-core.c                                      |    1 
 drivers/mtd/nand/ams-delta.c                                   |    2 
 drivers/mtd/nand/au1550nd.c                                    |    2 
 drivers/mtd/nand/bcm47xxnflash/main.c                          |    2 
 drivers/mtd/nand/bf5xx_nand.c                                  |    2 
 drivers/mtd/nand/brcmnand/brcmnand.c                           |    2 
 drivers/mtd/nand/cafe_nand.c                                   |    2 
 drivers/mtd/nand/cmx270_nand.c                                 |    2 
 drivers/mtd/nand/cs553x_nand.c                                 |    2 
 drivers/mtd/nand/davinci_nand.c                                |    2 
 drivers/mtd/nand/denali.c                                      |    4 
 drivers/mtd/nand/diskonchip.c                                  |    9 
 drivers/mtd/nand/docg4.c                                       |    4 
 drivers/mtd/nand/fsl_elbc_nand.c                               |    2 
 drivers/mtd/nand/fsl_ifc_nand.c                                |    2 
 drivers/mtd/nand/fsl_upm.c                                     |    2 
 drivers/mtd/nand/fsmc_nand.c                                   |    2 
 drivers/mtd/nand/gpio.c                                        |    2 
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c                         |    2 
 drivers/mtd/nand/hisi504_nand.c                                |    5 
 drivers/mtd/nand/jz4740_nand.c                                 |    4 
 drivers/mtd/nand/jz4780_nand.c                                 |    4 
 drivers/mtd/nand/lpc32xx_mlc.c                                 |    5 
 drivers/mtd/nand/lpc32xx_slc.c                                 |    5 
 drivers/mtd/nand/mpc5121_nfc.c                                 |    2 
 drivers/mtd/nand/mtk_nand.c                                    |    4 
 drivers/mtd/nand/mxc_nand.c                                    |    2 
 drivers/mtd/nand/nand_base.c                                   |    8 
 drivers/mtd/nand/nandsim.c                                     |    4 
 drivers/mtd/nand/ndfc.c                                        |    2 
 drivers/mtd/nand/nuc900_nand.c                                 |    2 
 drivers/mtd/nand/omap2.c                                       |    2 
 drivers/mtd/nand/orion_nand.c                                  |    5 
 drivers/mtd/nand/oxnas_nand.c                                  |   16 -
 drivers/mtd/nand/pasemi_nand.c                                 |    2 
 drivers/mtd/nand/plat_nand.c                                   |    4 
 drivers/mtd/nand/pxa3xx_nand.c                                 |    2 
 drivers/mtd/nand/qcom_nandc.c                                  |    2 
 drivers/mtd/nand/r852.c                                        |    4 
 drivers/mtd/nand/s3c2410.c                                     |    2 
 drivers/mtd/nand/sh_flctl.c                                    |    2 
 drivers/mtd/nand/sharpsl.c                                     |    4 
 drivers/mtd/nand/socrates_nand.c                               |    5 
 drivers/mtd/nand/sunxi_nand.c                                  |    4 
 drivers/mtd/nand/tango_nand.c                                  |    2 
 drivers/mtd/nand/tmio_nand.c                                   |    4 
 drivers/mtd/nand/txx9ndfmc.c                                   |    2 
 drivers/mtd/nand/vf610_nfc.c                                   |    2 
 drivers/mtd/nand/xway_nand.c                                   |    4 
 drivers/net/ethernet/intel/e1000e/netdev.c                     |   14 +
 drivers/net/geneve.c                                           |    7 
 drivers/net/hamradio/yam.c                                     |    1 
 drivers/ntb/ntb.c                                              |    8 
 drivers/pci/host/pci-aardvark.c                                |    4 
 drivers/pci/host/pcie-rcar.c                                   |    9 
 drivers/pci/pcie/aspm.c                                        |   10 -
 drivers/pci/pcie/ptm.c                                         |   22 +-
 drivers/pci/probe.c                                            |    5 
 drivers/pinctrl/freescale/pinctrl-imx.c                        |   19 --
 drivers/pinctrl/freescale/pinctrl-imx1-core.c                  |    1 
 drivers/power/supply/Kconfig                                   |    2 
 drivers/power/supply/lp8788-charger.c                          |   18 -
 drivers/power/supply/smb347-charger.c                          |    1 
 drivers/remoteproc/remoteproc_core.c                           |    3 
 drivers/s390/cio/qdio.h                                        |    1 
 drivers/s390/cio/qdio_setup.c                                  |    1 
 drivers/s390/cio/qdio_thinint.c                                |   14 -
 drivers/scsi/arm/acornscsi.c                                   |    4 
 drivers/scsi/ibmvscsi/ibmvscsi.c                               |    2 
 drivers/scsi/iscsi_boot_sysfs.c                                |    2 
 drivers/scsi/lpfc/lpfc_els.c                                   |    2 
 drivers/scsi/mpt3sas/mpt3sas_base.c                            |    2 
 drivers/scsi/qedi/qedi_iscsi.c                                 |    7 
 drivers/scsi/qla2xxx/qla_os.c                                  |    1 
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                             |    2 
 drivers/scsi/sr.c                                              |    6 
 drivers/scsi/ufs/ufs-qcom.c                                    |    6 
 drivers/scsi/ufs/ufshcd.c                                      |    1 
 drivers/staging/greybus/light.c                                |    3 
 drivers/staging/sm750fb/sm750.c                                |    1 
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c             |    6 
 drivers/tty/hvc/hvc_console.c                                  |   16 +
 drivers/tty/n_gsm.c                                            |   26 +-
 drivers/tty/serial/amba-pl011.c                                |    1 
 drivers/usb/class/usblp.c                                      |    5 
 drivers/usb/dwc2/core_intr.c                                   |    7 
 drivers/usb/gadget/composite.c                                 |   78 ++++++--
 drivers/usb/gadget/udc/lpc32xx_udc.c                           |   11 -
 drivers/usb/gadget/udc/m66592-udc.c                            |    2 
 drivers/usb/gadget/udc/s3c2410_udc.c                           |    4 
 drivers/usb/host/ehci-mxc.c                                    |    2 
 drivers/usb/host/ehci-platform.c                               |    5 
 drivers/usb/host/ohci-platform.c                               |    5 
 drivers/usb/host/xhci-plat.c                                   |   10 -
 drivers/vfio/mdev/mdev_sysfs.c                                 |    2 
 drivers/vfio/pci/vfio_pci_config.c                             |   14 +
 drivers/video/backlight/lp855x_bl.c                            |   20 +-
 drivers/watchdog/da9062_wdt.c                                  |    5 
 fs/block_dev.c                                                 |   12 -
 fs/dlm/dlm_internal.h                                          |    1 
 fs/ext4/extents.c                                              |    2 
 fs/f2fs/super.c                                                |    3 
 fs/gfs2/log.c                                                  |   11 -
 fs/gfs2/ops_fstype.c                                           |    2 
 fs/nfs/nfs4proc.c                                              |    2 
 fs/nfsd/nfs4callback.c                                         |    2 
 include/linux/bitops.h                                         |    2 
 include/linux/elfnote.h                                        |    2 
 include/linux/genhd.h                                          |    2 
 include/linux/kprobes.h                                        |    4 
 include/linux/libata.h                                         |    3 
 include/linux/mtd/rawnand.h                                    |    6 
 include/linux/usb/composite.h                                  |    3 
 include/uapi/linux/raid/md_p.h                                 |    2 
 kernel/kprobes.c                                               |   27 ++
 kernel/trace/blktrace.c                                        |   30 +--
 lib/zlib_inflate/inffast.c                                     |   91 +++-------
 net/core/dev.c                                                 |   40 +---
 net/sunrpc/addr.c                                              |    4 
 scripts/mksysmap                                               |    2 
 security/apparmor/label.c                                      |    4 
 security/selinux/ss/services.c                                 |    4 
 sound/isa/wavefront/wavefront_synth.c                          |    8 
 sound/soc/davinci/davinci-mcasp.c                              |    4 
 sound/soc/fsl/fsl_asrc_dma.c                                   |    1 
 sound/usb/card.h                                               |    4 
 sound/usb/endpoint.c                                           |   43 ++++
 sound/usb/endpoint.h                                           |    1 
 sound/usb/pcm.c                                                |    2 
 tools/perf/builtin-report.c                                    |    3 
 tools/testing/selftests/networking/timestamping/timestamping.c |   10 -
 tools/testing/selftests/x86/protection_keys.c                  |    3 
 180 files changed, 823 insertions(+), 587 deletions(-)

Adam Honse (1):
      i2c: piix4: Detect secondary SMBus controller on AMD AM4 chipsets

Ahmed S. Darwish (2):
      block: nr_sects_write(): Disable preemption on seqcount write
      net: core: device_rename: Use rwsem instead of a seqcount

Alain Volmat (1):
      clk: clk-flexgen: fix clock-critical handling

Alex Elder (1):
      remoteproc: Fix IDR initialisation in rproc_alloc()

Alex Williamson (1):
      vfio-pci: Mask cap zero

Alexander Tsoy (1):
      ALSA: usb-audio: Improve frames size computation

Andreas Klinger (1):
      iio: bmp280: fix compensation of humidity

Andrew Murray (1):
      PCI: rcar: Fix incorrect programming of OB windows

Andy Shevchenko (1):
      iio: pressure: bmp280: Tolerate IRQ before registering

Ard Biesheuvel (1):
      x86/boot/compressed: Relax sed symbol type regex for LLVM ld.lld

Arnd Bergmann (2):
      dlm: remove BUG() before panic()
      include/linux/bitops.h: avoid clang shift-count-overflow warnings

Bjorn Helgaas (1):
      PCI/PTM: Inherit Switch Downstream Port PTM settings from Upstream Port

Bob Peterson (2):
      gfs2: Allow lock_nolock mount to specify jid=X
      gfs2: fix use-after-free on transaction ail lists

Boris Brezillon (1):
      mtd: rawnand: Pass a nand_chip object to nand_release()

Borislav Petkov (1):
      x86/apic: Make TSC deadline timer detection message visible

Bryan O'Donoghue (1):
      clk: qcom: msm8916: Fix the address location of pll->config_reg

Can Guo (1):
      scsi: ufs: Don't update urgent bkops level when toggling auto bkops

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

Christophe JAILLET (6):
      m68k/PCI: Fix a memory leak in an error handling path
      power: supply: lp8788: Fix an error handling path in 'lp8788_charger_probe()'
      extcon: adc-jack: Fix an error handling path in 'adc_jack_probe()'
      pinctrl: imxl: Fix an error handling path in 'imx1_pinctrl_core_probe()'
      pinctrl: freescale: imx: Fix an error handling path in 'imx_pinctrl_probe()'
      scsi: acornscsi: Fix an error handling path in acornscsi_probe()

Colin Ian King (1):
      usb: gadget: lpc32xx_udc: don't dereference ep pointer before null check

Dan Carpenter (2):
      scsi: qedi: Check for buffer overflow in qedi_set_path()
      ALSA: isa/wavefront: prevent out of bounds write in ioctl

Dmitry Osipenko (1):
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

Gaurav Singh (1):
      perf report: Fix NULL pointer dereference in hists__fprintf_nr_sample_events()

Geoff Levand (1):
      powerpc/ps3: Fix kexec shutdown hang

Greg Kroah-Hartman (1):
      Linux 4.14.186

Gregory CLEMENT (3):
      tty: n_gsm: Fix SOF skipping
      tty: n_gsm: Fix waking up upper tty layer when room available
      tty: n_gsm: Fix bogus i++ in gsm_data_kick

Hannes Reinecke (1):
      dm zoned: return NULL if dmz_get_zone_for_reclaim() fails to find a zone

Herbert Xu (1):
      crypto: algif_skcipher - Cap recv SG list at ctx->used

Huacai Chen (1):
      drm/qxl: Use correct notify port address when creating cursor ring

Jann Horn (1):
      lib/zlib: remove outdated and incorrect pre-increment optimization

Jason Yan (1):
      block: Fix use-after-free in blkdev_get()

Jeffle Xu (1):
      ext4: fix partial cluster initialization when splitting extent

Jeffrey Hugo (1):
      scsi: ufs-qcom: Fix scheduling while atomic issue

Jernej Skrabec (1):
      drm/sun4i: hdmi ddc clk: Fix size of m divider

Jiri Benc (1):
      geneve: change from tx_error to tx_dropped on missing metadata

Jiri Olsa (1):
      kretprobe: Prevent triggering kretprobe from within kprobe_flush_task

John Johansen (1):
      apparmor: fix introspection of of task mode for unconfined tasks

John Stultz (1):
      serial: amba-pl011: Make sure we initialize the port.lock spinlock

Jon Hunter (1):
      backlight: lp855x: Ensure regulators are disabled on probe failure

Julian Wiedmann (1):
      s390/qdio: put thinint indicator after early error

Kai Huang (2):
      kvm: x86: Move kvm_set_mmio_spte_mask() from x86.c to mmu.c
      kvm: x86: Fix reserved bits related calculation errors caused by MKTME

Kai-Heng Feng (2):
      PCI/ASPM: Allow ASPM on links to PCIe-to-PCI/PCI-X Bridges
      libata: Use per port sync for detach

Kajol Jain (1):
      powerpc/perf/hv-24x7: Fix inconsistent output values incase multiple hv-24x7 events run

Konstantin Khlebnikov (1):
      f2fs: report delalloc reserve as non-free in statfs for project quota

Kuppuswamy Sathyanarayanan (1):
      drivers: base: Fix NULL pointer exception in __platform_driver_probe() if a driver developer is foolish

Linus Walleij (1):
      ARM: integrator: Add some Kconfig selections

Logan Gunthorpe (1):
      NTB: Fix the default port and peer numbers for legacy drivers

Lyude Paul (2):
      drm/dp_mst: Reformat drm_dp_check_act_status() a bit
      drm/dp_mst: Increase ACT retry timeout to 3s

Maor Gottlieb (1):
      IB/cma: Fix ports memory leak in cma_configfs

Marek Szyprowski (2):
      mfd: wm8994: Fix driver operation if loaded as modules
      clk: samsung: exynos5433: Add IGNORE_UNUSED flag to sclk_i2s1

Martin Wilck (1):
      dm mpath: switch paths in dm_blk_ioctl() code path

Masami Hiramatsu (1):
      kprobes: Fix to protect kick_kprobe_optimizer() by kprobe_mutex

Matej Dujava (1):
      staging: sm750fb: add missing case while setting FB_VISUAL

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

Pawel Laszczak (1):
      usb: gadget: Fix issue with config_ep_by_speed function

Pingfan Liu (1):
      powerpc/crashkernel: Take "mem=" option into account

Qais Yousef (3):
      usb/ohci-platform: Fix a warning when hibernating
      usb/xhci-plat: Set PM runtime as active on resume
      usb/ehci-platform: Set PM runtime as active on resume

Qian Cai (2):
      vfio/pci: fix memory leaks in alloc_perm_bits()
      powerpc/64s/pgtable: fix an undefined behaviour

Qiushi Wu (3):
      usb: gadget: fix potential double-free in m66592_probe.
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

Sean Christopherson (1):
      KVM: x86/mmu: Set mmio_value to '0' if reserved #PF can't be generated

Simon Arlott (1):
      scsi: sr: Fix sr_probe() missing deallocate of device minor

Stafford Horne (1):
      openrisc: Fix issue with argument clobbering for clone/fork

Stefan Riedmueller (1):
      watchdog: da9062: No need to ping manually before setting timeout

Sudip Mukherjee (1):
      thermal/drivers/ti-soc-thermal: Avoid dereferencing ERR_PTR

Suganath Prabu S (1):
      scsi: mpt3sas: Fix double free warnings

Tang Bin (1):
      USB: host: ehci-mxc: Add error handling in ehci_mxc_drv_probe()

Tero Kristo (2):
      clk: ti: composite: fix memory leak
      crypto: omap-sham - add proper load balancing support for multicore

Thomas Gleixner (1):
      sched/rt, net: Use CONFIG_PREEMPTION.patch

Tom Rix (1):
      selinux: fix double free

Tyrel Datwyler (1):
      scsi: ibmvscsi: Don't send host info in adapter info MAD after LPM

Viacheslav Dubeyko (2):
      scsi: qla2xxx: Fix issue with adapter's stopping state
      scsi: qla2xxx: Fix warning after FC target reset

Wang Hai (1):
      yam: fix possible memory leak in yam_init_driver

Will Deacon (1):
      arm64: hw_breakpoint: Don't invoke overflow handler on uaccess watchpoints

Wolfram Sang (1):
      drm: encoder_slave: fix refcouting error for modules

Xiyu Yang (4):
      ASoC: davinci-mcasp: Fix dma_chan refcnt leak when getting dma type
      scsi: lpfc: Fix lpfc_nodelist leak when processing unsolicited event
      nfsd: Fix svc_xprt refcnt leak when setup callback client failed
      ASoC: fsl_asrc_dma: Fix dma_chan leak when config DMA channel failed

Zhiqiang Liu (1):
      bcache: fix potential deadlock problem in btree_gc_coalesce

ashimida (1):
      mksysmap: Fix the mismatch of '.L' symbols in System.map

huhai (1):
      powerpc/4xx: Don't unmap NULL mbase

tannerlove (1):
      selftests/net: in timestamping, strncpy needs to preserve null byte

