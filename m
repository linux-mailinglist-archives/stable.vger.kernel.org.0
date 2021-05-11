Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2390A37A7CB
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 15:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhEKNhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 09:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231308AbhEKNhP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 May 2021 09:37:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 784EF6127A;
        Tue, 11 May 2021 13:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620740169;
        bh=PPsGso548WxaOJFnWvJzqG9CtJeNH2owq8ILcYoh+BQ=;
        h=From:To:Cc:Subject:Date:From;
        b=v4bR2BfSMVXBYNg74Cr2lSOyOz4PxIusxmQb3VQfHL/COUtCe3BmVlkLvc2B2IyS/
         ENEN8/TnmtIuhhdF4idt4N3jYFDl6g49gdmMtsfPJEeX63Tk8wlqZpDtOaOtcO1AZY
         O+/ou9uZTD4DBeG8V0Q+i2bB16ns9+QDnN4C/NA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.118
Date:   Tue, 11 May 2021 15:36:05 +0200
Message-Id: <1620740165207216@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.118 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                         |   10 
 arch/arm/boot/compressed/Makefile                                |    4 
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi                     |    3 
 arch/arm64/boot/dts/mediatek/mt8173.dtsi                         |    2 
 arch/arm64/kernel/vdso/vdso.lds.S                                |    8 
 arch/powerpc/include/uapi/asm/errno.h                            |    1 
 arch/powerpc/kernel/eeh.c                                        |   11 
 arch/s390/crypto/arch_random.c                                   |    4 
 arch/s390/kernel/dis.c                                           |    2 
 arch/x86/Makefile                                                |    1 
 arch/x86/kernel/cpu/common.c                                     |    2 
 crypto/api.c                                                     |    2 
 crypto/rng.c                                                     |   10 
 drivers/acpi/arm64/gtdt.c                                        |   10 
 drivers/acpi/custom_method.c                                     |    4 
 drivers/ata/ahci.c                                               |    5 
 drivers/ata/ahci.h                                               |    1 
 drivers/ata/libahci.c                                            |    5 
 drivers/bus/ti-sysc.c                                            |   49 ++
 drivers/char/tpm/eventlog/common.c                               |    3 
 drivers/char/tpm/eventlog/efi.c                                  |   29 +
 drivers/clk/socfpga/clk-gate-a10.c                               |    1 
 drivers/crypto/omap-aes.c                                        |    6 
 drivers/crypto/qat/qat_common/qat_algs.c                         |   11 
 drivers/crypto/stm32/stm32-cryp.c                                |    4 
 drivers/crypto/stm32/stm32-hash.c                                |    8 
 drivers/extcon/extcon-arizona.c                                  |   57 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c                          |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                          |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c                          |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c                         |    9 
 drivers/gpu/drm/amd/amdkfd/kfd_debugfs.c                         |    7 
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c            |   17 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                |    8 
 drivers/gpu/drm/amd/display/dc/core/dc.c                         |    3 
 drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c   |    1 
 drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c |    1 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                   |   14 
 drivers/gpu/drm/i915/intel_pm.c                                  |    2 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_cmd_encoder.c                 |   18 -
 drivers/gpu/drm/qxl/qxl_display.c                                |    4 
 drivers/gpu/drm/vkms/vkms_crtc.c                                 |    3 
 drivers/hwtracing/intel_th/gth.c                                 |    4 
 drivers/hwtracing/intel_th/pci.c                                 |   10 
 drivers/input/touchscreen/ili210x.c                              |    2 
 drivers/irqchip/irq-gic-v3.c                                     |    8 
 drivers/md/dm-integrity.c                                        |    1 
 drivers/md/dm-raid.c                                             |   34 +
 drivers/md/dm-rq.c                                               |    2 
 drivers/md/persistent-data/dm-btree-internal.h                   |    4 
 drivers/md/persistent-data/dm-space-map-common.c                 |    2 
 drivers/md/persistent-data/dm-space-map-common.h                 |    8 
 drivers/md/raid1.c                                               |    2 
 drivers/media/dvb-core/dvbdev.c                                  |    1 
 drivers/media/i2c/adv7511-v4l2.c                                 |    2 
 drivers/media/i2c/adv7604.c                                      |    2 
 drivers/media/i2c/adv7842.c                                      |    2 
 drivers/media/i2c/tc358743.c                                     |    2 
 drivers/media/i2c/tda1997x.c                                     |    2 
 drivers/media/pci/saa7164/saa7164-encoder.c                      |   20 -
 drivers/media/pci/sta2x11/Kconfig                                |    1 
 drivers/media/platform/sti/bdisp/bdisp-debug.c                   |    2 
 drivers/media/platform/vivid/vivid-core.c                        |    6 
 drivers/media/rc/ite-cir.c                                       |    8 
 drivers/media/usb/dvb-usb/dvb-usb-init.c                         |   90 +++--
 drivers/media/usb/dvb-usb/dvb-usb.h                              |    2 
 drivers/media/usb/em28xx/em28xx-dvb.c                            |    1 
 drivers/media/usb/gspca/gspca.c                                  |    2 
 drivers/media/usb/gspca/gspca.h                                  |    1 
 drivers/media/usb/gspca/sq905.c                                  |    2 
 drivers/media/usb/gspca/stv06xx/stv06xx.c                        |    9 
 drivers/mfd/arizona-irq.c                                        |    2 
 drivers/mmc/core/block.c                                         |   16 
 drivers/mmc/core/core.c                                          |   76 ----
 drivers/mmc/core/core.h                                          |   17 
 drivers/mmc/core/host.c                                          |   40 ++
 drivers/mmc/core/mmc.c                                           |    7 
 drivers/mmc/core/mmc_ops.c                                       |    4 
 drivers/mmc/core/sd.c                                            |    6 
 drivers/mmc/core/sdio.c                                          |   28 +
 drivers/mmc/host/sdhci-pci-core.c                                |   29 +
 drivers/mmc/host/sdhci-pci.h                                     |    2 
 drivers/mmc/host/sdhci.c                                         |   60 +--
 drivers/mmc/host/uniphier-sd.c                                   |    5 
 drivers/mtd/nand/raw/atmel/nand-controller.c                     |    6 
 drivers/mtd/nand/spi/core.c                                      |    2 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c                |   30 -
 drivers/net/wimax/i2400m/op-rfkill.c                             |    2 
 drivers/net/wireless/rsi/rsi_91x_sdio.c                          |    2 
 drivers/pci/pci.c                                                |   16 
 drivers/perf/arm_pmu_platform.c                                  |    2 
 drivers/phy/ti/phy-twl4030-usb.c                                 |    2 
 drivers/platform/x86/intel_pmc_core.c                            |   19 -
 drivers/power/supply/bq27xxx_battery.c                           |   51 +-
 drivers/power/supply/generic-adc-battery.c                       |    2 
 drivers/power/supply/lp8788-charger.c                            |    2 
 drivers/power/supply/pm2301_charger.c                            |    2 
 drivers/power/supply/s3c_adc_battery.c                           |    2 
 drivers/power/supply/tps65090-charger.c                          |    2 
 drivers/power/supply/tps65217_charger.c                          |    2 
 drivers/scsi/device_handler/scsi_dh_alua.c                       |    5 
 drivers/scsi/libfc/fc_lport.c                                    |    2 
 drivers/scsi/lpfc/lpfc_attr.c                                    |   75 ++--
 drivers/scsi/lpfc/lpfc_crtn.h                                    |    3 
 drivers/scsi/lpfc/lpfc_hw4.h                                     |  174 ----------
 drivers/scsi/lpfc/lpfc_init.c                                    |  112 ------
 drivers/scsi/lpfc/lpfc_mbox.c                                    |   36 --
 drivers/scsi/lpfc/lpfc_nportdisc.c                               |   11 
 drivers/scsi/lpfc/lpfc_nvmet.c                                   |    1 
 drivers/scsi/lpfc/lpfc_sli.c                                     |   43 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                              |    4 
 drivers/scsi/qla2xxx/qla_attr.c                                  |    8 
 drivers/scsi/qla2xxx/qla_bsg.c                                   |    3 
 drivers/scsi/qla2xxx/qla_os.c                                    |    7 
 drivers/scsi/smartpqi/smartpqi_init.c                            |  160 +++++++++
 drivers/spi/spi-ath79.c                                          |    3 
 drivers/spi/spi-dln2.c                                           |    2 
 drivers/spi/spi-omap-100k.c                                      |    6 
 drivers/spi/spi-qup.c                                            |    2 
 drivers/spi/spi-ti-qspi.c                                        |   20 -
 drivers/staging/media/imx/imx-media-capture.c                    |    2 
 drivers/staging/media/ipu3/ipu3-v4l2.c                           |   36 +-
 drivers/target/target_core_pscsi.c                               |    3 
 drivers/tee/optee/core.c                                         |   10 
 drivers/tty/n_gsm.c                                              |   14 
 drivers/tty/vt/vt.c                                              |    1 
 drivers/usb/core/hub.c                                           |    2 
 drivers/usb/dwc2/core_intr.c                                     |    8 
 drivers/usb/dwc3/gadget.c                                        |   22 -
 drivers/usb/gadget/config.c                                      |    4 
 drivers/usb/gadget/function/f_fs.c                               |    3 
 drivers/usb/gadget/function/f_uac1.c                             |   43 ++
 drivers/usb/gadget/function/f_uac2.c                             |   39 ++
 drivers/usb/gadget/function/f_uvc.c                              |    8 
 drivers/usb/gadget/legacy/webcam.c                               |    1 
 drivers/usb/gadget/udc/dummy_hcd.c                               |   23 -
 drivers/usb/host/xhci-mem.c                                      |    9 
 drivers/usb/host/xhci-mtk.c                                      |    3 
 drivers/usb/host/xhci-mtk.h                                      |    1 
 drivers/usb/host/xhci.c                                          |   14 
 drivers/usb/musb/musb_core.c                                     |    2 
 drivers/video/fbdev/core/fbcmap.c                                |    8 
 fs/btrfs/ctree.c                                                 |   20 +
 fs/btrfs/ioctl.c                                                 |   18 -
 fs/btrfs/relocation.c                                            |    6 
 fs/cifs/smb2ops.c                                                |    2 
 fs/ecryptfs/main.c                                               |    6 
 fs/erofs/erofs_fs.h                                              |    3 
 fs/erofs/inode.c                                                 |    7 
 fs/ext4/ialloc.c                                                 |   48 +-
 fs/ext4/super.c                                                  |    9 
 fs/f2fs/node.c                                                   |    3 
 fs/fuse/file.c                                                   |   41 +-
 fs/fuse/fuse_i.h                                                 |    1 
 fs/fuse/virtio_fs.c                                              |    1 
 fs/jffs2/compr_rtime.c                                           |    3 
 fs/jffs2/scan.c                                                  |    2 
 fs/nfs/pnfs.c                                                    |    7 
 fs/ubifs/replay.c                                                |    3 
 include/crypto/acompress.h                                       |    2 
 include/crypto/aead.h                                            |    2 
 include/crypto/akcipher.h                                        |    2 
 include/crypto/hash.h                                            |    4 
 include/crypto/kpp.h                                             |    2 
 include/crypto/rng.h                                             |    2 
 include/crypto/skcipher.h                                        |    2 
 include/linux/mmc/host.h                                         |    3 
 include/linux/module.h                                           |   26 -
 include/linux/power/bq27xxx_battery.h                            |    1 
 include/scsi/libfcoe.h                                           |    2 
 include/uapi/linux/usb/video.h                                   |    3 
 kernel/.gitignore                                                |    1 
 kernel/Makefile                                                  |    9 
 kernel/futex.c                                                   |    3 
 kernel/irq/matrix.c                                              |    4 
 kernel/module.c                                                  |   60 ++-
 kernel/sched/fair.c                                              |    4 
 kernel/time/posix-timers.c                                       |    4 
 kernel/trace/ftrace.c                                            |    5 
 kernel/trace/trace.c                                             |   41 --
 kernel/trace/trace_clock.c                                       |   44 +-
 net/bluetooth/ecdh_helper.h                                      |    2 
 net/openvswitch/actions.c                                        |    8 
 security/commoncap.c                                             |    2 
 sound/isa/sb/emu8000.c                                           |    4 
 sound/isa/sb/sb16_csp.c                                          |    8 
 sound/pci/hda/patch_conexant.c                                   |   14 
 sound/pci/hda/patch_realtek.c                                    |   25 +
 sound/usb/clock.c                                                |   18 -
 sound/usb/mixer.c                                                |   60 +--
 sound/usb/mixer_maps.c                                           |   68 ++-
 sound/usb/mixer_quirks.c                                         |    6 
 sound/usb/mixer_scarlett.c                                       |   14 
 sound/usb/proc.c                                                 |    2 
 sound/usb/stream.c                                               |    4 
 sound/usb/validate.c                                             |    4 
 196 files changed, 1541 insertions(+), 1051 deletions(-)

Adrian Hunter (2):
      mmc: sdhci-pci: Fix initialization of some SD cards for Intel BYT-based controllers
      mmc: sdhci-pci: Add PCI IDs for Intel LKF

Alexander Lobakin (1):
      mtd: spinand: core: add missing MODULE_DEVICE_TABLE()

Alexander Shishkin (2):
      intel_th: pci: Add Rocket Lake CPU support
      intel_th: pci: Add Alder Lake-M support

Anirudh Rayabharam (1):
      usb: gadget: dummy_hcd: fix gpf in gadget_setup

Anson Jacob (2):
      drm/amdkfd: Fix UBSAN shift-out-of-bounds warning
      drm/amd/display: Fix UBSAN warning for not a valid value for type '_Bool'

Ard Biesheuvel (2):
      ARM: 9056/1: decompressor: fix BSS size calculation for LLVM ld.lld
      crypto: api - check for ERR pointers in crypto_destroy_tfm()

Aric Cyr (1):
      drm/amd/display: Don't optimize bandwidth before disabling planes

Arnd Bergmann (2):
      amdgpu: avoid incorrect %hu format string
      security: commoncap: fix -Wstringop-overread warning

Artur Petrosyan (1):
      usb: dwc2: Fix session request interrupt handler

Arun Easi (1):
      scsi: qla2xxx: Fix crash in qla2xxx_mqueuecommand()

Avri Altman (2):
      mmc: block: Update ext_csd.cache_ctrl if it was written
      mmc: block: Issue a cache flush only when it's enabled

Bart Van Assche (2):
      scsi: qla2xxx: Always check the return value of qla24xx_get_isp_stats()
      scsi: libfc: Fix a format specifier

Benjamin Block (1):
      dm rq: fix double free of blk_mq_tag_set in dev remove after table load fails

Bill Wendling (1):
      arm64/vdso: Discard .note.gnu.property sections in vDSO

Bixuan Cui (2):
      usb: musb: fix PM reference leak in musb_irq_work()
      usb: core: hub: Fix PM reference leak in usb_port_resume()

Chaitanya Kulkarni (1):
      scsi: target: pscsi: Fix warning in pscsi_complete_cmd()

Chao Yu (1):
      f2fs: fix to avoid out-of-bounds memory access

Chen Jun (1):
      posix-timers: Preserve return value in clock_adjtime32()

Christoph Hellwig (8):
      modules: mark ref_module static
      modules: mark find_symbol static
      modules: mark each_symbol_section static
      modules: unexport __module_text_address
      modules: unexport __module_address
      modules: rename the licence field in struct symsearch to license
      modules: return licensing information from find_symbol
      modules: inherit TAINT_PROPRIETARY_MODULE

Christophe JAILLET (2):
      mmc: uniphier-sd: Fix an error handling path in uniphier_sd_probe()
      mmc: uniphier-sd: Fix a resource leak in the remove function

Chunfeng Yun (2):
      arm64: dts: mt8173: fix property typo of 'phys' in dsi node
      usb: xhci-mtk: support quirk to disable usb2 lpm

Colin Ian King (1):
      clk: socfpga: arria10: Fix memory leak of socfpga_clk on error return

Daniel Niv (1):
      media: media/saa7164: fix saa7164_encoder_register() memory leak bugs

David Bauer (2):
      spi: ath79: always call chipselect function
      spi: ath79: remove spi-master setup and cleanup assignment

David E. Box (1):
      platform/x86: intel_pmc_core: Don't use global pmcdev in quirks

Davide Caratti (1):
      openvswitch: fix stack OOB read while fragmenting IPv4 packets

Dean Anderson (1):
      usb: gadget/function/f_fs string table fix for multiple languages

Dinghao Liu (2):
      media: platform: sti: Fix runtime PM imbalance in regs_show
      mfd: arizona: Fix rumtime PM imbalance on error

Dmitry Vyukov (1):
      drm/vkms: fix misuse of WARN_ON

Dmytro Laktyushkin (1):
      drm/amd/display: fix dml prefetch validation

DooHyun Hwang (1):
      mmc: core: Do a power cycle when the CMD11 fails

Eckhart Mohr (1):
      ALSA: hda/realtek: Add quirk for Intel Clevo PCx0Dx

Eric Biggers (1):
      crypto: rng - fix crypto_rng_reset() refcounting when !CRYPTO_STATS

Eryk Brol (1):
      drm/amd/display: Check for DSC support instead of ASIC revision

Ewan D. Milne (1):
      scsi: scsi_dh_alua: Remove check for ASC 24h in alua_rtpg()

Fengnan Chang (1):
      ext4: fix error code in ext4_commit_super

Filipe Manana (2):
      btrfs: fix metadata extent leak after failure to create subvolume
      btrfs: fix race when picking most recent mod log operation for an old root

Gao Xiang (1):
      erofs: add unsupported inode i_format check

Gerd Hoffmann (1):
      drm/qxl: release shadow on shutdown

Greg Kroah-Hartman (1):
      Linux 5.4.118

Guchun Chen (1):
      drm/amdgpu: fix NULL pointer dereference

Guochun Mao (1):
      ubifs: Only check replay with inode type to judge if inode linked

Hans Verkuil (3):
      media: gspca/sq905.c: fix uninitialized variable
      media: vivid: update EDID
      media: gscpa/stv06xx: fix memory leak

Hans de Goede (2):
      extcon: arizona: Fix some issues when HPDET IRQ fires after the jack has been unplugged
      extcon: arizona: Fix various races on driver unbind

Hansem Ro (1):
      Input: ili210x - add missing negation for touch indication on ili210x

Harald Freudenberger (1):
      s390/archrandom: add parameter check for s390_arch_random_generate

He Ying (1):
      irqchip/gic-v3: Do not enable irqs when handling spurious interrups

Heinz Mauelshagen (1):
      dm raid: fix inconclusive reshape layout on fast raid4/5/6 table reload sequences

Hemant Kumar (1):
      usb: gadget: Fix double free of device descriptor pointers

Hillf Danton (1):
      tty: n_gsm: check error while registering tty devices

Hui Tang (1):
      crypto: qat - fix unmap invalid dma address

Ido Schimmel (1):
      mlxsw: spectrum_mr: Update egress RIF list before route's action

James Smart (5):
      scsi: lpfc: Fix incorrect dbde assignment when building target abts wqe
      scsi: lpfc: Fix pt2pt connection does not recover after LOGO
      scsi: lpfc: Fix crash when a REG_RPI mailbox fails triggering a LOGO response
      scsi: lpfc: Fix error handling for mailboxes completed in MBX_POLL mode
      scsi: lpfc: Remove unsupported mbox PORT_CAPABILITIES logic

Jared Baldridge (1):
      drm: Added orientation quirk for OneGX1 Pro

Jeffrey Mitchell (1):
      ecryptfs: fix kernel panic with null dev_name

Jerome Forissier (1):
      tee: optee: do not check memref size on return from Secure World

Joe Thornber (2):
      dm persistent data: packed struct should have an aligned() attribute too
      dm space map common: fix division bug in sm_ll_find_free_block()

John Millikin (1):
      x86/build: Propagate $(CLANG_FLAGS) to $(REALMODE_FLAGS)

Jonathan Kim (1):
      drm/amdgpu: mask the xgmi number of hops reported from psp to kfd

Josef Bacik (1):
      btrfs: convert logic BUG_ON()'s in replace_path to ASSERT()'s

Julian Braha (1):
      media: drivers: media: pci: sta2x11: fix Kconfig dependency on GPIOLIB

Kai Stuhlemmer (ebee Engineering) (1):
      mtd: rawnand: atmel: Update ecc_stats.corrected counter

Kevin Barnett (1):
      scsi: smartpqi: Add new PCI IDs

Laurent Pinchart (1):
      media: imx: capture: Return -EPIPE from __capture_legacy_try_fmt()

Lingutla Chandrasekhar (1):
      sched/fair: Ignore percpu threads for imbalance pulls

Linus Torvalds (1):
      Fix misc new gcc warnings

Luis Henriques (1):
      virtiofs: fix memory leak in virtio_fs_probe()

Luke D Jones (1):
      ALSA: hda/realtek: GA503 use same quirks as GA401

Lv Yunlong (2):
      ALSA: emu8000: Fix a use after free in snd_emu8000_create_mixer
      ALSA: sb: Fix two use after free in snd_sb_qsound_build

Mahesh Salgaonkar (1):
      powerpc/eeh: Fix EEH handling for hugepages in ioremap space.

Marc Zyngier (1):
      ACPI: GTDT: Don't corrupt interrupt mappings on watchdow probe failure

Marek Behún (1):
      arm64: dts: marvell: armada-37xx: add syscon compatible to NB clk node

Marek Vasut (1):
      rsi: Use resume_noirq for SDIO

Marijn Suijten (2):
      drm/msm/mdp5: Configure PP_SYNC_HEIGHT to double the vtotal
      drm/msm/mdp5: Do not multiply vclk line count by 100

Mark Langsdorf (2):
      ACPI: custom_method: fix potential use-after-free issue
      ACPI: custom_method: fix a possible memory leak

Masahiro Yamada (1):
      kbuild: update config_data.gz only when the content of .config is changed

Mathias Nyman (2):
      xhci: check control context is valid before dereferencing it.
      xhci: fix potential array out of bounds with several interrupters

Matthias Schiffer (1):
      power: supply: bq27xxx: fix power_avg for newer ICs

Muhammad Usama Anjum (1):
      media: em28xx: fix memory leak

Murthy Bhat (1):
      scsi: smartpqi: Correct request leakage during reset operations

Nathan Chancellor (1):
      Makefile: Move -Wno-unused-but-set-variable out of GCC only block

Paul Aurich (1):
      cifs: Return correct error code from smb2_get_enc_key

Paul Clements (1):
      md/raid1: properly indicate failure when ending a failed write request

Pavel Machek (1):
      intel_th: Consistency and off-by-one fix

Pavel Skripkin (2):
      media: dvb-usb: fix memory leak in dvb_usb_adapter_init
      tty: fix memory leak in vc_deallocate

Pawel Laszczak (2):
      usb: gadget: uvc: add bInterval checking for HS mode
      usb: webcam: Invalid size of Processing Unit Descriptor

Peilin Ye (1):
      media: dvbdev: Fix memory leak in dvb_media_device_free()

Phil Calvin (1):
      ALSA: hda/realtek: fix mic boost on Intel NUC 8

Phillip Potter (1):
      fbdev: zero-fill colormap in fbcmap.c

Pradeep P V K (1):
      mmc: sdhci: Check for reset prior to DMA address unmap

Qu Huang (1):
      drm/amdkfd: Fix cat debugfs hang_hws file causes system crash bug

Quinn Tran (1):
      scsi: qla2xxx: Fix use after free in bsg

Rafael J. Wysocki (1):
      PCI: PM: Do not read power state in pci_enable_device_flags()

Ricardo Ribalda (3):
      media: staging/intel-ipu3: Fix memory leak in imu_fmt
      media: staging/intel-ipu3: Fix set_fmt error handling
      media: staging/intel-ipu3: Fix race condition during set_fmt

Robin Murphy (1):
      perf/arm_pmu_platform: Fix error handling

Ruslan Bilovol (2):
      usb: gadget: f_uac2: validate input parameters
      usb: gadget: f_uac1: validate input parameters

Sami Loone (1):
      ALSA: hda/realtek: fix static noise on ALC285 Lenovo laptops

Sean Christopherson (1):
      x86/cpu: Initialize MSR_TSC_AUX if RDTSCP *or* RDPID is supported

Sean Young (1):
      media: ite-cir: check for receive overflow

Seunghui Lee (1):
      mmc: core: Set read only for SD cards with permanent write protect bit

Shixin Liu (3):
      crypto: stm32/hash - Fix PM reference leak on stm32-hash.c
      crypto: stm32/cryp - Fix PM reference leak on stm32-cryp.c
      crypto: omap-aes - Fix PM reference leak on omap-aes.c

Sreekanth Reddy (1):
      scsi: mpt3sas: Block PCI config access from userspace during reset

Stefan Berger (2):
      tpm: efi: Use local variable for calculating final log size
      tpm: vtpm_proxy: Avoid reading host log when using a virtual device

Steven Rostedt (VMware) (3):
      ftrace: Handle commands when closing set_ftrace_filter file
      tracing: Map all PIDs to command lines
      tracing: Restructure trace_clock_global() to never block

Takashi Iwai (5):
      ALSA: hda/conexant: Re-order CX5066 quirk table entries
      ALSA: usb-audio: Explicitly set up the clock selector
      ALSA: usb-audio: More constifications
      media: dvb-usb: Fix use-after-free access
      media: dvb-usb: Fix memory leak at error in dvb_usb_device_init()

Thinh Nguyen (2):
      usb: xhci: Fix port minor revision
      usb: dwc3: gadget: Fix START_TRANSFER link state check

Thomas Gleixner (1):
      Revert 337f13046ff0 ("futex: Allow FUTEX_CLOCK_REALTIME with FUTEX_WAIT op")

Tian Tao (1):
      dm integrity: fix missing goto in bitmap_flush_interval error handling

Timo Gurr (1):
      ALSA: usb-audio: Add dB range mapping for Sennheiser Communications Headset PC 8

Tony Ambardar (1):
      powerpc: fix EDEADLOCK redefinition error in uapi/asm/errno.h

Tony Lindgren (1):
      bus: ti-sysc: Probe for l4_wkup and l4_cfg interconnect devices first

Trond Myklebust (2):
      NFS: Don't discard pNFS layout segments that are marked for return
      NFSv4: Don't discard segments marked for return in _pnfs_return_layout()

Tudor Ambarus (1):
      spi: spi-ti-qspi: Free DMA resources

Ulf Hansson (1):
      mmc: core: Fix hanging on I/O during system suspend for removable cards

Vasily Gorbik (1):
      s390/disassembler: increase ebpf disasm buffer size

Vitaly Kuznetsov (1):
      genirq/matrix: Prevent allocation counter corruption

Vivek Goyal (1):
      fuse: fix write deadlock

Wang Li (1):
      spi: qup: fix PM reference leak in spi_qup_remove()

Wei Yongjun (2):
      spi: dln2: Fix reference leak to master
      spi: omap-100k: Fix reference leak to master

Wesley Cheng (1):
      usb: dwc3: gadget: Ignore EP queue requests during bus reset

Xingui Yang (1):
      ata: ahci: Disable SXS for Hisilicon Kunpeng920

Yang Yang (1):
      jffs2: check the validity of dstlen in jffs2_zlib_compress()

Yang Yingliang (8):
      phy: phy-twl4030-usb: Fix possible use-after-free in twl4030_usb_remove()
      power: supply: generic-adc-battery: fix possible use-after-free in gab_remove()
      power: supply: s3c_adc_battery: fix possible use-after-free in s3c_adc_bat_remove()
      media: tc358743: fix possible use-after-free in tc358743_remove()
      media: adv7604: fix possible use-after-free in adv76xx_remove()
      media: i2c: adv7511-v4l2: fix possible use-after-free in adv7511_remove()
      media: i2c: tda1997: Fix possible use-after-free in tda1997x_remove()
      media: i2c: adv7842: fix possible use-after-free in adv7842_remove()

Zhang Yi (2):
      ext4: fix check to prevent false positive report of incorrect used inodes
      ext4: do not set SB_ACTIVE in ext4_orphan_cleanup()

dongjian (1):
      power: supply: Use IRQF_ONESHOT

karthik alapati (1):
      staging: wimax/i2400m: fix byte-order issue

lizhe (1):
      jffs2: Fix kasan slab-out-of-bounds problem

shaoyunl (1):
      drm/amdgpu : Fix asic reset regression issue introduce by 8f211fe8ac7c4f

