Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF347231B9F
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 10:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgG2IxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 04:53:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbgG2IxH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jul 2020 04:53:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 914FE2076E;
        Wed, 29 Jul 2020 08:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596012785;
        bh=ysjy6dn1jpwMtEvwLdb0We1pzevRK6YHPHb1q47z5II=;
        h=From:To:Cc:Subject:Date:From;
        b=o+CY+2TAqjRxDE/Rj7DE4n2X86kcX31wUJB9v6PXQD0ekxSuNU45Wu3XR8tGqGaKR
         wbaVRCN4+cI6W1SM/Cdis+X1SM5WXkiahAi4sN5USUPU5ETgUNDQw65PCVU/6mdpcU
         GW+4KiWd2dB/QMsezpyJcYUkOQaGRAezJnv3NBWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.54
Date:   Wed, 29 Jul 2020 10:52:43 +0200
Message-Id: <1596012763246183@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.54 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                      |    4 
 arch/arm/boot/dts/imx6qdl-gw551x.dtsi                         |   19 +-
 arch/arm/boot/dts/omap3-n900.dts                              |   12 +
 arch/arm64/kernel/debug-monitors.c                            |    4 
 arch/mips/pci/pci-xtalk-bridge.c                              |    5 
 arch/parisc/include/asm/atomic.h                              |    2 
 arch/riscv/include/asm/barrier.h                              |   10 +
 arch/x86/kernel/apic/io_apic.c                                |   10 -
 arch/x86/kernel/apic/msi.c                                    |   18 +-
 arch/x86/kernel/apic/vector.c                                 |    1 
 arch/x86/kernel/vmlinux.lds.S                                 |    1 
 arch/x86/math-emu/wm_sqrt.S                                   |    2 
 arch/x86/platform/uv/uv_irq.c                                 |    3 
 arch/xtensa/kernel/setup.c                                    |    3 
 arch/xtensa/kernel/xtensa_ksyms.c                             |    4 
 drivers/android/binder_alloc.c                                |    2 
 drivers/base/regmap/regmap.c                                  |    2 
 drivers/char/mem.c                                            |   10 -
 drivers/dma-buf/dma-buf.c                                     |   11 -
 drivers/dma/fsl-edma-common.c                                 |   26 +--
 drivers/dma/ioat/dma.c                                        |   12 +
 drivers/dma/ioat/dma.h                                        |    2 
 drivers/dma/tegra210-adma.c                                   |    5 
 drivers/firmware/psci/psci_checker.c                          |    5 
 drivers/fpga/dfl-afu-main.c                                   |    3 
 drivers/fpga/dfl-pci.c                                        |    3 
 drivers/gpio/gpio-arizona.c                                   |    7 
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c                   |   20 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c                        |    9 -
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                        |    9 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c             |    7 
 drivers/gpu/drm/amd/powerplay/smumgr/vegam_smumgr.c           |   10 -
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxg94.c              |    4 
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c            |    4 
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c                        |    2 
 drivers/hid/hid-alps.c                                        |    2 
 drivers/hid/hid-apple.c                                       |   18 ++
 drivers/hid/hid-steam.c                                       |    6 
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c                      |    8 +
 drivers/hwmon/aspeed-pwm-tacho.c                              |    2 
 drivers/hwmon/nct6775.c                                       |    6 
 drivers/hwmon/pmbus/adm1275.c                                 |   10 +
 drivers/hwmon/scmi-hwmon.c                                    |    2 
 drivers/i2c/busses/i2c-qcom-geni.c                            |    6 
 drivers/i2c/busses/i2c-rcar.c                                 |    3 
 drivers/infiniband/hw/mlx5/srq_cmd.c                          |    4 
 drivers/input/mouse/elan_i2c_core.c                           |    9 -
 drivers/input/mouse/synaptics.c                               |    1 
 drivers/iommu/amd_iommu.c                                     |    5 
 drivers/iommu/hyperv-iommu.c                                  |    5 
 drivers/iommu/intel_irq_remapping.c                           |    2 
 drivers/md/dm-integrity.c                                     |    4 
 drivers/md/dm.c                                               |   22 ++-
 drivers/mmc/host/sdhci-of-aspeed.c                            |    2 
 drivers/net/bonding/bond_main.c                               |   10 -
 drivers/net/bonding/bond_netlink.c                            |    3 
 drivers/net/dsa/microchip/ksz9477.c                           |   42 +++--
 drivers/net/dsa/microchip/ksz_common.c                        |    2 
 drivers/net/dsa/microchip/ksz_common.h                        |    2 
 drivers/net/ethernet/atheros/ag71xx.c                         |    3 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                     |   12 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c             |    5 
 drivers/net/ethernet/freescale/enetc/enetc_pf.c               |    1 
 drivers/net/ethernet/hisilicon/hns3/hnae3.h                   |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c               |    8 +
 drivers/net/ethernet/marvell/sky2.c                           |    2 
 drivers/net/ethernet/mellanox/mlxsw/core.c                    |    3 
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c           |    7 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c               |   17 --
 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c         |    5 
 drivers/net/ethernet/qlogic/qed/qed_cxt.c                     |    4 
 drivers/net/ethernet/qlogic/qed/qed_dev.c                     |    2 
 drivers/net/ethernet/qlogic/qed/qed_int.c                     |   50 ++++---
 drivers/net/ethernet/qlogic/qed/qed_int.h                     |    4 
 drivers/net/ethernet/smsc/smc91x.c                            |    4 
 drivers/net/ethernet/socionext/sni_ave.c                      |    2 
 drivers/net/geneve.c                                          |    2 
 drivers/net/hippi/rrunner.c                                   |    2 
 drivers/net/ieee802154/adf7242.c                              |    4 
 drivers/net/netdevsim/netdev.c                                |    4 
 drivers/net/phy/dp83640.c                                     |    4 
 drivers/net/usb/ax88172a.c                                    |    1 
 drivers/net/wan/lapbether.c                                   |    9 +
 drivers/net/wireless/ath/ath9k/hif_usb.c                      |   52 +++++--
 drivers/net/wireless/ath/ath9k/hif_usb.h                      |    5 
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                  |    8 -
 drivers/pci/controller/vmd.c                                  |    5 
 drivers/pci/pci.c                                             |   30 +---
 drivers/perf/arm-cci.c                                        |    1 
 drivers/perf/arm-ccn.c                                        |    1 
 drivers/perf/arm_dsu_pmu.c                                    |    1 
 drivers/perf/arm_smmuv3_pmu.c                                 |    2 
 drivers/perf/arm_spe_pmu.c                                    |    1 
 drivers/perf/fsl_imx8_ddr_perf.c                              |    2 
 drivers/perf/hisilicon/hisi_uncore_ddrc_pmu.c                 |    2 
 drivers/perf/hisilicon/hisi_uncore_hha_pmu.c                  |    2 
 drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c                  |    2 
 drivers/perf/qcom_l2_pmu.c                                    |    1 
 drivers/perf/qcom_l3_pmu.c                                    |    1 
 drivers/perf/thunderx2_pmu.c                                  |    1 
 drivers/perf/xgene_pmu.c                                      |    1 
 drivers/pinctrl/pinctrl-amd.h                                 |    2 
 drivers/platform/x86/asus-wmi.c                               |    1 
 drivers/platform/x86/intel_speed_select_if/isst_if_common.h   |    3 
 drivers/platform/x86/intel_speed_select_if/isst_if_mbox_pci.c |    1 
 drivers/platform/x86/intel_speed_select_if/isst_if_mmio.c     |    1 
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                            |   12 -
 drivers/scsi/scsi_devinfo.c                                   |    1 
 drivers/scsi/scsi_dh.c                                        |    1 
 drivers/scsi/scsi_transport_spi.c                             |    2 
 drivers/soc/qcom/rpmh.c                                       |    8 -
 drivers/spi/spi-mt65xx.c                                      |   15 +-
 drivers/staging/comedi/drivers/addi_apci_1032.c               |   20 +-
 drivers/staging/comedi/drivers/addi_apci_1500.c               |   24 ++-
 drivers/staging/comedi/drivers/addi_apci_1564.c               |   20 +-
 drivers/staging/comedi/drivers/ni_6527.c                      |    2 
 drivers/staging/wlan-ng/prism2usb.c                           |   16 ++
 drivers/tty/serial/8250/8250_core.c                           |    2 
 drivers/tty/serial/8250/8250_exar.c                           |   12 +
 drivers/tty/serial/8250/8250_mtk.c                            |   18 ++
 drivers/tty/serial/serial-tegra.c                             |    7 
 drivers/tty/serial/xilinx_uartps.c                            |    8 -
 drivers/tty/vt/vt.c                                           |   29 ++--
 drivers/usb/cdns3/ep0.c                                       |   30 ++--
 drivers/usb/cdns3/trace.h                                     |    6 
 drivers/usb/dwc3/dwc3-pci.c                                   |    8 +
 drivers/usb/gadget/udc/gr_udc.c                               |    7 
 drivers/usb/host/xhci-mtk-sch.c                               |    4 
 drivers/usb/host/xhci-pci.c                                   |    3 
 drivers/video/fbdev/core/bitblit.c                            |    4 
 drivers/video/fbdev/core/fbcon_ccw.c                          |    4 
 drivers/video/fbdev/core/fbcon_cw.c                           |    4 
 drivers/video/fbdev/core/fbcon_ud.c                           |    4 
 fs/btrfs/backref.c                                            |    1 
 fs/btrfs/extent_io.c                                          |    3 
 fs/btrfs/relocation.c                                         |   11 +
 fs/btrfs/volumes.c                                            |    8 +
 fs/cifs/inode.c                                               |   10 -
 fs/fuse/dev.c                                                 |    3 
 fs/nfs/direct.c                                               |   13 -
 fs/nfs/file.c                                                 |    1 
 fs/nfsd/nfs4state.c                                           |   20 ++
 include/asm-generic/mmiowb.h                                  |    6 
 include/asm-generic/vmlinux.lds.h                             |    5 
 include/linux/device-mapper.h                                 |    1 
 include/linux/dma-buf.h                                       |    1 
 include/linux/io-mapping.h                                    |    5 
 include/linux/mod_devicetable.h                               |    2 
 include/sound/rt5670.h                                        |    1 
 include/uapi/linux/input-event-codes.h                        |    3 
 kernel/events/uprobes.c                                       |    2 
 mm/khugepaged.c                                               |    3 
 mm/memcontrol.c                                               |    4 
 mm/mmap.c                                                     |   16 +-
 mm/slab_common.c                                              |   35 +++-
 net/mac80211/rx.c                                             |   26 +++
 net/netfilter/ipvs/ip_vs_sync.c                               |   12 +
 net/vmw_vsock/virtio_transport.c                              |    2 
 scripts/decode_stacktrace.sh                                  |    4 
 scripts/gdb/linux/symbols.py                                  |    2 
 sound/core/info.c                                             |    4 
 sound/pci/hda/patch_hdmi.c                                    |   36 +++--
 sound/pci/hda/patch_realtek.c                                 |    2 
 sound/soc/codecs/rt5670.c                                     |   71 +++++++---
 sound/soc/codecs/rt5670.h                                     |    2 
 sound/soc/intel/boards/bytcht_es8316.c                        |    4 
 sound/soc/qcom/Kconfig                                        |    2 
 sound/soc/soc-topology.c                                      |   24 ++-
 168 files changed, 919 insertions(+), 406 deletions(-)

Alexander Lobakin (2):
      qed: suppress "don't support RoCE & iWARP" flooding on HW init
      qed: suppress false-positives interrupt error messages on HW init

Angelo Dureghello (1):
      dmaengine: fsl-edma: fix wrong tcd endianness for big-endian cpu

Arnd Bergmann (1):
      x86: math-emu: Fix up 'cmp' insn for clang ias

Ben Skeggs (1):
      drm/nouveau/i2c/g94-: increase NV_PMGR_DP_AUXCTL_TRANSACTREQ timeout

Bjorn Helgaas (1):
      Revert "PCI/PM: Assume ports without DLL Link Active train links in 100 ms"

Boris Burkov (1):
      btrfs: fix mount failure caused by race with umount

Caiyuan Xie (1):
      HID: alps: support devices with report id 2

Charan Teja Kalla (1):
      dmabuf: use spinlock to access dmabuf->name

Chen-Yu Tsai (1):
      drm: sun4i: hdmi: Fix inverted HPD result

Christoph Hellwig (1):
      dm: use bio_uninit instead of bio_disassociate_blkg

Christophe JAILLET (1):
      hippi: Fix a size used in a 'pci_free_consistent()' in an error handling path

Chu Lin (1):
      hwmon: (adm1275) Make sure we are reading enough data for different chips

Chunfeng Yun (1):
      usb: xhci-mtk: fix the failure of bandwidth allocation

Claudiu Manoil (1):
      enetc: Remove the mdio bus on PF probe bailout

Cong Wang (2):
      bonding: check return value of register_netdevice() in bond_newlink()
      geneve: fix an uninitialized value in geneve_changelink()

Cristian Marussi (1):
      hwmon: (scmi) Fix potential buffer overflow in scmi_hwmon_probe()

Damien Le Moal (1):
      scsi: mpt3sas: Fix unlock imbalance

Derek Basehore (1):
      Input: elan_i2c - only increment wakeup count on touch

Dinghao Liu (1):
      dmaengine: tegra210-adma: Fix runtime PM imbalance on error

Douglas Anderson (2):
      soc: qcom: rpmh: Dirt can only make you dirtier, not cleaner
      i2c: i2c-qcom-geni: Fix DMA transfer race

Eddie James (1):
      mmc: sdhci-of-aspeed: Fix clock divider calculation

Eric Biggers (1):
      /dev/mem: Add missing memory barriers for devmem_inode

Evgeny Novikov (2):
      hwmon: (aspeed-pwm-tacho) Avoid possible buffer overflow
      usb: gadget: udc: gr_udc: fix memleak on error handling path in gr_ep_init()

Fabio Estevam (1):
      ARM: dts: imx6qdl-gw551x: Do not use 'simple-audio-card,dai-link'

Fangrui Song (1):
      Makefile: Fix GCC_TOOLCHAIN_DIR prefix for Clang cross compilation

Federico Ricchiuto (1):
      HID: i2c-hid: add Mediacom FlexBook edge13 to descriptor override

Filipe Manana (1):
      btrfs: fix double free on ulist after backref resolution failure

Forest Crossman (1):
      usb: xhci: Fix ASM2142/ASM3142 DMA addressing

Gavin Shan (1):
      drivers/firmware/psci: Fix memory leakage in alloc_init_cpu_groups()

Geert Uytterhoeven (1):
      ASoC: qcom: Drop HAS_DMA dependency to fix link failure

George Kennedy (1):
      ax88172a: fix ax88172a_unbind() failures

Greg Kroah-Hartman (1):
      Linux 5.4.54

Guenter Roeck (1):
      hwmon: (nct6775) Accept PECI Calibration as temperature source for NCT6798D

Hans de Goede (3):
      ASoC: rt5670: Correct RT5670_LDO_SEL_MASK
      HID: apple: Disable Fn-key key-re-mapping on clone keyboards
      ASoC: rt5670: Add new gpio1_is_ext_spk_en quirk and enable it on the Lenovo Miix 2 10

Heikki Krogerus (2):
      usb: dwc3: pci: add support for the Intel Tiger Lake PCH -H variant
      usb: dwc3: pci: add support for the Intel Jasper Lake

Helmut Grohne (2):
      net: dsa: microchip: call phy_remove_link_mode during probe
      tty: xilinx_uartps: Really fix id assignment

Huang Guobin (1):
      net: ag71xx: add missed clk_disable_unprepare in error path of probe

Hugh Dickins (1):
      mm/memcg: fix refcount error while moving and swapping

Ian Abbott (4):
      staging: comedi: addi_apci_1032: check INSN_CONFIG_DIGITAL_TRIG shift
      staging: comedi: ni_6527: fix INSN_CONFIG_DIGITAL_TRIG support
      staging: comedi: addi_apci_1500: check INSN_CONFIG_DIGITAL_TRIG shift
      staging: comedi: addi_apci_1564: check INSN_CONFIG_DIGITAL_TRIG shift

Ilya Katsnelson (1):
      Input: synaptics - enable InterTouch for ThinkPad X1E 1st gen

J. Bruce Fields (1):
      nfsd4: fix NULL dereference in nfsd/clients display code

Jack Xiao (2):
      drm/amdgpu/gfx10: fix race condition for kiq
      drm/amdgpu: fix preemption unit test

Jacky Hu (1):
      pinctrl: amd: fix npins for uart0 in kerncz_groups

Jerry (Fangzhi) Zuo (1):
      drm/amd/display: Check DMCU Exists Before Loading

Jing Xiangfeng (1):
      ASoC: Intel: bytcht_es8316: Add missed put_device()

Joerg Roedel (1):
      x86, vmlinux.lds: Page-align end of ..page_aligned sections

Johan Hovold (1):
      serial: tegra: fix CREAD handling for PIO

Johannes Berg (1):
      iwlwifi: mvm: don't call iwl_mvm_free_inactive_queue() under RCU

Johannes Thumshirn (1):
      scsi: mpt3sas: Fix error returns in BRM_status_show

John David Anglin (1):
      parisc: Add atomic64_set_release() define to avoid CPU soft lockups

Joonho Wohn (1):
      ALSA: hda/realtek: Fixed ALC298 sound bug by adding quirk for Samsung Notebook Pen S

Kai Vehmanen (1):
      ALSA: hda/hdmi: fix failures at PCM open on Intel ICL and later

Kirill A. Shutemov (2):
      mm/mmap.c: close race between munmap() and expand_upwards()/downwards()
      khugepaged: fix null-pointer dereference due to race

Leonid Ravich (1):
      dmaengine: ioat setting ioat timeout as module parameter

Liu Jian (2):
      ieee802154: fix one possible memleak in adf7242_probe
      mlxsw: destroy workqueue when trap_register in mlxsw_emad_init

Maor Gottlieb (1):
      RDMA/mlx5: Use xa_lock_irq when access to SRQ table

Marc Kleine-Budde (1):
      regmap: dev_get_regmap_match(): fix string comparison

Mark O'Donovan (1):
      ath9k: Fix regression with Atheros 9271

Markus Theil (1):
      mac80211: allow rx of mesh eapol frames with default rx key

Matthew Gerlach (1):
      fpga: dfl: fix bug in port reset handshake

Matthew Howell (1):
      serial: exar: Fix GPIO configuration for Sealevel cards based on XR17V35X

Max Filippov (2):
      xtensa: fix __sync_fetch_and_{and,or}_4 declarations
      xtensa: update *pos in cpuinfo_op.next

Merlijn Wajer (2):
      Input: add `SW_MACHINE_COVER`
      ARM: dts: n900: remove mmc1 card detect gpio

Michael Chan (1):
      bnxt_en: Fix completion ring sizing with TPA enabled.

Michael J. Ruhl (1):
      io-mapping: indicate mapping failure

Miklos Szeredi (1):
      fuse: fix weird page warning

Mikulas Patocka (1):
      dm integrity: fix integrity recalculation that is improperly skipped

Muchun Song (1):
      mm: memcg/slab: fix memory leak at non-root kmem_cache destroy

Navid Emamdoost (2):
      gpio: arizona: handle pm_runtime_get_sync failure case
      gpio: arizona: put pm_runtime in case of failure

Oleg Nesterov (1):
      uprobes: Change handle_swbp() to send SIGTRAP with si_code=SI_KERNEL, to fix GDB regression

Olga Kornievskaia (1):
      SUNRPC reverting d03727b248d0 ("NFSv4 fix CLOSE not waiting for direct IO compeletion")

Palmer Dabbelt (1):
      RISC-V: Upgrade smp_mb__after_spinlock() to iorw,iorw

Paweł Gronowski (1):
      drm/amdgpu: Fix NULL dereference in dpm sysfs handlers

PeiSen Hou (1):
      ALSA: hda/realtek - fixup for yet another Intel reference board

Peter Chen (2):
      usb: cdns3: ep0: fix some endian issues
      usb: cdns3: trace: fix some endian issues

Pi-Hsun Shih (1):
      scripts/decode_stacktrace: strip basepath from all paths

Pierre-Louis Bossart (2):
      ASoC: topology: fix kernel oops on route addition error
      ASoC: topology: fix tlvs in error handling for widget_dmixer

Qi Liu (2):
      drivers/perf: Fix kernel panic when rmmod PMU modules during perf sampling
      drivers/perf: Prevent forced unbinding of PMU drivers

Qiu Wenbo (1):
      drm/amd/powerplay: fix a crash when overclocking Vega M

Qiujun Huang (1):
      ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb

Qu Wenruo (2):
      btrfs: reloc: fix reloc root leak and NULL pointer dereference
      btrfs: reloc: clear DEAD_RELOC_TREE bit for orphan roots to prevent runaway balance

Robbie Ko (1):
      btrfs: fix page leaks after failure to lock page for delalloc

Rodrigo Rivas Costa (1):
      HID: steam: fixes race in handling device list.

Rustam Kovhaev (1):
      staging: wlan-ng: properly check endpoint types

Serge Semin (1):
      serial: 8250_mtk: Fix high-speed baud rates clamping

Sergey Organov (1):
      net: dp83640: fix SIOCSHWTSTAMP to update the struct with actual configuration

Shannon Nelson (2):
      ionic: use offset for ethtool regs data
      ionic: fix up filter locks and debug msgs

Srinivas Pandruvada (1):
      platform/x86: ISST: Add new PCI device ids

Stefano Garzarella (2):
      vsock/virtio: annotate 'the_virtio_vsock' RCU pointer
      scripts/gdb: fix lx-symbols 'gdb.error' while loading modules

Steve French (1):
      Revert "cifs: Fix the target file was deleted when rename failed."

Steve Schremmer (1):
      scsi: dh: Add Fujitsu device to devinfo and dh lists

Taehee Yoo (2):
      bonding: check error value of register_netdevice() immediately
      netdevsim: fix unbalaced locking in nsim_create()

Takashi Iwai (1):
      ALSA: info: Drop WARN_ON() from buffer NULL sanity check

Tetsuo Handa (3):
      binder: Don't use mmput() from shrinker function.
      fbdev: Detect integer underflow at "struct fbcon_ops"->clear_margins.
      vt: Reject zero-sized screen buffer size.

Thomas Gleixner (1):
      irqdomain/treewide: Keep firmware node unconditionally allocated

Tim Harvey (1):
      ARM: dts: imx6qdl-gw551x: fix audio SSI

Tom Rix (2):
      scsi: scsi_transport_spi: Fix function pointer check
      net: sky2: initialize return of gm_phy_read

Vasiliy Kupriakov (1):
      platform/x86: asus-wmi: allow BAT1 battery name

Vasundhara Volam (1):
      bnxt_en: Fix race when modifying pause settings.

Wang Hai (2):
      net: smc91x: Fix possible memory leak in smc_drv_probe()
      net: ethernet: ave: Fix error returns in ave_init

Will Deacon (2):
      arm64: Use test_tsk_thread_flag() for checking TIF_SINGLESTEP
      asm-generic/mmiowb: Allow mmiowb_set_pending() when preemptible()

Wolfram Sang (1):
      i2c: rcar: always clear ICSAR to avoid side effects

Xie He (1):
      drivers/net/wan/lapbether: Fixed the value of hard_header_len

Xu Yilun (1):
      fpga: dfl: pci: reduce the scope of variable 'ret'

Yang Yingliang (1):
      serial: 8250: fix null-ptr-deref in serial8250_start_tx()

Yunsheng Lin (1):
      net: hns3: fix error handling for desc filling

guodeqing (1):
      ipvs: fix the connection sync failed in some cases

leilk.liu (1):
      spi: mediatek: use correct SPI_CFG2_REG MACRO

