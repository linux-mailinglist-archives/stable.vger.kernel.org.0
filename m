Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A55231B9B
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 10:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgG2Iwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 04:52:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbgG2Iwp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jul 2020 04:52:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BFF02075D;
        Wed, 29 Jul 2020 08:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596012763;
        bh=HkHN0r18M00JGksKP29JIvAuzyWSqybhBtOmvUpmGXY=;
        h=From:To:Cc:Subject:Date:From;
        b=fZUUwGQOJPJ3CznaKtQ9Vmw9d2STTyzasAdjAUpHEeAGxE+w1CvrWaiWtzI4HiYEl
         G5re0HQNl1Qlt3UUMb0pDoEdu9Lxhjq44j64eKlbkVMmNm+1zwnLgsA1q0YA/ZLVdi
         gOmAeQoJ5/shWd8KgiUDNOEOf4klUoTiNy6GWagI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.135
Date:   Wed, 29 Jul 2020 10:52:33 +0200
Message-Id: <159601275372237@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.135 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    4 -
 arch/arm64/kernel/debug-monitors.c                  |    4 -
 arch/parisc/include/asm/atomic.h                    |    2 
 arch/riscv/include/asm/barrier.h                    |   10 ++
 arch/x86/kernel/apic/io_apic.c                      |   10 +-
 arch/x86/kernel/apic/msi.c                          |   18 +++--
 arch/x86/kernel/apic/vector.c                       |    1 
 arch/x86/kernel/vmlinux.lds.S                       |    1 
 arch/x86/math-emu/wm_sqrt.S                         |    2 
 arch/x86/platform/uv/uv_irq.c                       |    3 
 arch/xtensa/kernel/setup.c                          |    3 
 arch/xtensa/kernel/xtensa_ksyms.c                   |    4 -
 drivers/android/binder_alloc.c                      |    2 
 drivers/base/regmap/regmap.c                        |    2 
 drivers/dma/ioat/dma.c                              |   12 +++
 drivers/dma/ioat/dma.h                              |    2 
 drivers/dma/tegra210-adma.c                         |    5 +
 drivers/firmware/psci_checker.c                     |    5 +
 drivers/fpga/dfl-afu-main.c                         |    3 
 drivers/gpio/gpio-arizona.c                         |    7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c              |    9 --
 drivers/gpu/drm/amd/powerplay/smumgr/vegam_smumgr.c |   10 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxg94.c    |    4 -
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c  |    4 -
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c              |    2 
 drivers/hid/hid-alps.c                              |    2 
 drivers/hid/hid-apple.c                             |   18 +++++
 drivers/hid/hid-steam.c                             |    6 +
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c            |    8 ++
 drivers/hwmon/aspeed-pwm-tacho.c                    |    2 
 drivers/hwmon/pmbus/adm1275.c                       |   10 ++
 drivers/hwmon/scmi-hwmon.c                          |    2 
 drivers/i2c/busses/i2c-rcar.c                       |    3 
 drivers/infiniband/core/umem_odp.c                  |    3 
 drivers/input/mouse/synaptics.c                     |    1 
 drivers/iommu/amd_iommu.c                           |    5 -
 drivers/iommu/intel_irq_remapping.c                 |    2 
 drivers/md/dm-integrity.c                           |    4 -
 drivers/md/dm.c                                     |   17 ++++
 drivers/net/bonding/bond_main.c                     |   10 +-
 drivers/net/bonding/bond_netlink.c                  |    3 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c   |    5 +
 drivers/net/ethernet/marvell/sky2.c                 |    2 
 drivers/net/ethernet/mellanox/mlxsw/core.c          |    3 
 drivers/net/ethernet/qlogic/qed/qed_cxt.c           |    4 -
 drivers/net/ethernet/smsc/smc91x.c                  |    4 -
 drivers/net/ethernet/socionext/sni_ave.c            |    2 
 drivers/net/hippi/rrunner.c                         |    2 
 drivers/net/ieee802154/adf7242.c                    |    4 -
 drivers/net/phy/dp83640.c                           |    4 +
 drivers/net/usb/ax88172a.c                          |    1 
 drivers/net/wan/lapbether.c                         |    9 ++
 drivers/net/wireless/ath/ath9k/hif_usb.c            |   52 +++++++++++---
 drivers/net/wireless/ath/ath9k/hif_usb.h            |    5 +
 drivers/pci/controller/vmd.c                        |    5 -
 drivers/pinctrl/pinctrl-amd.h                       |    2 
 drivers/scsi/scsi_transport_spi.c                   |    2 
 drivers/soc/qcom/rpmh.c                             |    8 +-
 drivers/spi/spi-fsl-dspi.c                          |    4 -
 drivers/spi/spi-mt65xx.c                            |   15 ++--
 drivers/staging/comedi/drivers/addi_apci_1032.c     |   20 +++--
 drivers/staging/comedi/drivers/addi_apci_1500.c     |   24 +++++-
 drivers/staging/comedi/drivers/addi_apci_1564.c     |   20 +++--
 drivers/staging/comedi/drivers/ni_6527.c            |    2 
 drivers/staging/wlan-ng/prism2usb.c                 |   16 ++++
 drivers/tty/serial/8250/8250_core.c                 |    2 
 drivers/tty/serial/8250/8250_exar.c                 |   12 +++
 drivers/tty/serial/8250/8250_mtk.c                  |   18 +++++
 drivers/tty/vt/vt.c                                 |   29 +++++---
 drivers/usb/gadget/udc/gr_udc.c                     |    7 +
 drivers/usb/host/xhci-mtk-sch.c                     |    4 +
 drivers/usb/host/xhci-pci.c                         |    3 
 drivers/video/fbdev/core/bitblit.c                  |    4 -
 drivers/video/fbdev/core/fbcon_ccw.c                |    4 -
 drivers/video/fbdev/core/fbcon_cw.c                 |    4 -
 drivers/video/fbdev/core/fbcon_ud.c                 |    4 -
 fs/btrfs/backref.c                                  |    1 
 fs/btrfs/extent_io.c                                |    3 
 fs/btrfs/volumes.c                                  |    8 ++
 fs/cifs/inode.c                                     |   10 --
 fs/fuse/dev.c                                       |    3 
 fs/nfs/direct.c                                     |   13 +--
 fs/nfs/file.c                                       |    1 
 include/asm-generic/vmlinux.lds.h                   |    5 +
 include/linux/device-mapper.h                       |    1 
 include/linux/io-mapping.h                          |    5 +
 include/linux/mod_devicetable.h                     |    2 
 include/sound/rt5670.h                              |    1 
 include/uapi/linux/input-event-codes.h              |    3 
 kernel/events/uprobes.c                             |    2 
 mm/memcontrol.c                                     |    4 -
 mm/slab_common.c                                    |   50 +++++++++++---
 net/mac80211/rx.c                                   |   26 +++++++
 net/netfilter/ipvs/ip_vs_sync.c                     |   12 ++-
 net/tipc/bcast.c                                    |    8 +-
 net/tipc/group.c                                    |    4 -
 net/tipc/link.c                                     |   12 +--
 net/tipc/node.c                                     |    7 +
 net/tipc/socket.c                                   |   12 +--
 scripts/decode_stacktrace.sh                        |    4 -
 scripts/gdb/linux/symbols.py                        |    2 
 sound/core/info.c                                   |    4 -
 sound/soc/codecs/rt5670.c                           |   71 +++++++++++++++-----
 sound/soc/codecs/rt5670.h                           |    2 
 sound/soc/qcom/Kconfig                              |    2 
 105 files changed, 584 insertions(+), 225 deletions(-)

Alexander Lobakin (1):
      qed: suppress "don't support RoCE & iWARP" flooding on HW init

Arnd Bergmann (1):
      x86: math-emu: Fix up 'cmp' insn for clang ias

Ben Skeggs (1):
      drm/nouveau/i2c/g94-: increase NV_PMGR_DP_AUXCTL_TRANSACTREQ timeout

Boris Burkov (1):
      btrfs: fix mount failure caused by race with umount

Caiyuan Xie (1):
      HID: alps: support devices with report id 2

Chen-Yu Tsai (1):
      drm: sun4i: hdmi: Fix inverted HPD result

Christophe JAILLET (1):
      hippi: Fix a size used in a 'pci_free_consistent()' in an error handling path

Chu Lin (1):
      hwmon: (adm1275) Make sure we are reading enough data for different chips

Chunfeng Yun (1):
      usb: xhci-mtk: fix the failure of bandwidth allocation

Cong Wang (1):
      bonding: check return value of register_netdevice() in bond_newlink()

Cristian Marussi (1):
      hwmon: (scmi) Fix potential buffer overflow in scmi_hwmon_probe()

Dinghao Liu (1):
      dmaengine: tegra210-adma: Fix runtime PM imbalance on error

Douglas Anderson (1):
      soc: qcom: rpmh: Dirt can only make you dirtier, not cleaner

Evgeny Novikov (2):
      hwmon: (aspeed-pwm-tacho) Avoid possible buffer overflow
      usb: gadget: udc: gr_udc: fix memleak on error handling path in gr_ep_init()

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
      Linux 4.19.135

Hans de Goede (3):
      ASoC: rt5670: Correct RT5670_LDO_SEL_MASK
      HID: apple: Disable Fn-key key-re-mapping on clone keyboards
      ASoC: rt5670: Add new gpio1_is_ext_spk_en quirk and enable it on the Lenovo Miix 2 10

Hugh Dickins (1):
      mm/memcg: fix refcount error while moving and swapping

Ian Abbott (4):
      staging: comedi: addi_apci_1032: check INSN_CONFIG_DIGITAL_TRIG shift
      staging: comedi: ni_6527: fix INSN_CONFIG_DIGITAL_TRIG support
      staging: comedi: addi_apci_1500: check INSN_CONFIG_DIGITAL_TRIG shift
      staging: comedi: addi_apci_1564: check INSN_CONFIG_DIGITAL_TRIG shift

Ilya Katsnelson (1):
      Input: synaptics - enable InterTouch for ThinkPad X1E 1st gen

Jacky Hu (1):
      pinctrl: amd: fix npins for uart0 in kerncz_groups

Joerg Roedel (1):
      x86, vmlinux.lds: Page-align end of ..page_aligned sections

John David Anglin (1):
      parisc: Add atomic64_set_release() define to avoid CPU soft lockups

Jon Maloy (1):
      tipc: clean up skb list lock handling on send path

Leonid Ravich (1):
      dmaengine: ioat setting ioat timeout as module parameter

Liu Jian (2):
      ieee802154: fix one possible memleak in adf7242_probe
      mlxsw: destroy workqueue when trap_register in mlxsw_emad_init

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

Merlijn Wajer (1):
      Input: add `SW_MACHINE_COVER`

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

Pi-Hsun Shih (1):
      scripts/decode_stacktrace: strip basepath from all paths

Qiu Wenbo (1):
      drm/amd/powerplay: fix a crash when overclocking Vega M

Qiujun Huang (1):
      ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb

Robbie Ko (1):
      btrfs: fix page leaks after failure to lock page for delalloc

Rodrigo Rivas Costa (1):
      HID: steam: fixes race in handling device list.

Roman Gushchin (1):
      mm: memcg/slab: synchronize access to kmem_cache dying flag using a spinlock

Rustam Kovhaev (1):
      staging: wlan-ng: properly check endpoint types

Serge Semin (1):
      serial: 8250_mtk: Fix high-speed baud rates clamping

Sergey Organov (1):
      net: dp83640: fix SIOCSHWTSTAMP to update the struct with actual configuration

Stefano Garzarella (1):
      scripts/gdb: fix lx-symbols 'gdb.error' while loading modules

Steve French (1):
      Revert "cifs: Fix the target file was deleted when rename failed."

Taehee Yoo (1):
      bonding: check error value of register_netdevice() immediately

Takashi Iwai (1):
      ALSA: info: Drop WARN_ON() from buffer NULL sanity check

Tetsuo Handa (3):
      binder: Don't use mmput() from shrinker function.
      fbdev: Detect integer underflow at "struct fbcon_ops"->clear_margins.
      vt: Reject zero-sized screen buffer size.

Thomas Gleixner (1):
      irqdomain/treewide: Keep firmware node unconditionally allocated

Tom Rix (2):
      scsi: scsi_transport_spi: Fix function pointer check
      net: sky2: initialize return of gm_phy_read

Vasundhara Volam (1):
      bnxt_en: Fix race when modifying pause settings.

Vladimir Oltean (1):
      spi: spi-fsl-dspi: Exit the ISR with IRQ_NONE when it's not ours

Wang Hai (2):
      net: smc91x: Fix possible memory leak in smc_drv_probe()
      net: ethernet: ave: Fix error returns in ave_init

Will Deacon (1):
      arm64: Use test_tsk_thread_flag() for checking TIF_SINGLESTEP

Wolfram Sang (1):
      i2c: rcar: always clear ICSAR to avoid side effects

Xie He (1):
      drivers/net/wan/lapbether: Fixed the value of hard_header_len

Yang Yingliang (2):
      IB/umem: fix reference count leak in ib_umem_odp_get()
      serial: 8250: fix null-ptr-deref in serial8250_start_tx()

guodeqing (1):
      ipvs: fix the connection sync failed in some cases

leilk.liu (1):
      spi: mediatek: use correct SPI_CFG2_REG MACRO

