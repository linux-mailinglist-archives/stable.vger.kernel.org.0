Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECCE231B97
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 10:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgG2IwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 04:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbgG2IwP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jul 2020 04:52:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA54C2075D;
        Wed, 29 Jul 2020 08:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596012734;
        bh=FbKDp1iaGk/d9cqrkFMwlXXUQxrg2XLDHhpoQ7eU97c=;
        h=From:To:Cc:Subject:Date:From;
        b=ajAjG5AGMaHhnwH4etBwhm8NuiPTU+IwSKZwlb/glB1zpas8ONlQSA+iy3ipG89Sj
         Ljz9LhNY13Xk0OEUgacdhWOQc9939gIhEkHCvfyIJoiKF8ot9i+PDLUbYJmtuDUgTd
         ILwi2YfjsKrolhkaTDgL8CJ6AgQ0p0H+5Ls39exw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.190
Date:   Wed, 29 Jul 2020 10:52:04 +0200
Message-Id: <1596012723217164@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.190 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    4 -
 arch/arm64/kernel/debug-monitors.c                 |    4 -
 arch/parisc/include/asm/atomic.h                   |    2 
 arch/x86/kernel/apic/io_apic.c                     |   10 ++--
 arch/x86/kernel/apic/msi.c                         |   16 ++++--
 arch/x86/kernel/apic/vector.c                      |    1 
 arch/x86/math-emu/wm_sqrt.S                        |    2 
 arch/x86/platform/uv/uv_irq.c                      |    3 -
 arch/xtensa/kernel/setup.c                         |    3 -
 arch/xtensa/kernel/xtensa_ksyms.c                  |    4 -
 drivers/android/binder_alloc.c                     |    2 
 drivers/base/regmap/regmap.c                       |    2 
 drivers/dma/ioat/dma.c                             |   12 ++++
 drivers/dma/ioat/dma.h                             |    2 
 drivers/dma/tegra210-adma.c                        |    5 +-
 drivers/gpio/gpio-arizona.c                        |    7 ++
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxg94.c   |    4 -
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c |    4 -
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c             |    2 
 drivers/hid/hid-apple.c                            |   18 +++++++
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |    8 +++
 drivers/hwmon/aspeed-pwm-tacho.c                   |    2 
 drivers/i2c/busses/i2c-rcar.c                      |    3 +
 drivers/infiniband/core/umem_odp.c                 |    3 -
 drivers/input/mouse/synaptics.c                    |    1 
 drivers/iommu/amd_iommu.c                          |    5 +-
 drivers/iommu/intel_irq_remapping.c                |    2 
 drivers/net/bonding/bond_main.c                    |   10 ++--
 drivers/net/bonding/bond_netlink.c                 |    3 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |    5 +-
 drivers/net/ethernet/marvell/sky2.c                |    2 
 drivers/net/ethernet/mellanox/mlxsw/core.c         |    3 -
 drivers/net/ethernet/smsc/smc91x.c                 |    4 -
 drivers/net/hippi/rrunner.c                        |    2 
 drivers/net/phy/dp83640.c                          |    4 +
 drivers/net/usb/ax88172a.c                         |    1 
 drivers/net/wan/lapbether.c                        |    9 +++
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   52 ++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/hif_usb.h           |    5 ++
 drivers/pci/host/vmd.c                             |    5 +-
 drivers/pinctrl/pinctrl-amd.h                      |    2 
 drivers/scsi/scsi_transport_spi.c                  |    2 
 drivers/spi/spi-fsl-dspi.c                         |    4 +
 drivers/spi/spi-mt65xx.c                           |   15 +++---
 drivers/staging/comedi/drivers/addi_apci_1032.c    |   20 +++++---
 drivers/staging/comedi/drivers/addi_apci_1500.c    |   24 +++++++--
 drivers/staging/comedi/drivers/addi_apci_1564.c    |   20 +++++---
 drivers/staging/comedi/drivers/ni_6527.c           |    2 
 drivers/staging/wlan-ng/prism2usb.c                |   16 ++++++
 drivers/tty/serial/8250/8250_core.c                |    2 
 drivers/tty/serial/8250/8250_exar.c                |   12 ++++
 drivers/tty/serial/8250/8250_mtk.c                 |   18 +++++++
 drivers/tty/vt/vt.c                                |   29 +++++++----
 drivers/usb/gadget/udc/gr_udc.c                    |    7 ++
 drivers/usb/host/xhci-mtk-sch.c                    |    4 +
 drivers/usb/host/xhci-pci.c                        |    3 +
 drivers/video/fbdev/core/bitblit.c                 |    4 -
 drivers/video/fbdev/core/fbcon_ccw.c               |    4 -
 drivers/video/fbdev/core/fbcon_cw.c                |    4 -
 drivers/video/fbdev/core/fbcon_ud.c                |    4 -
 fs/btrfs/backref.c                                 |    1 
 fs/btrfs/extent_io.c                               |    3 -
 fs/btrfs/volumes.c                                 |    8 +++
 fs/cifs/inode.c                                    |   10 ----
 fs/nfs/direct.c                                    |   13 +----
 fs/nfs/file.c                                      |    1 
 include/linux/io-mapping.h                         |    5 +-
 include/linux/mod_devicetable.h                    |    2 
 include/uapi/linux/input-event-codes.h             |    3 -
 kernel/events/uprobes.c                            |    2 
 mm/memcontrol.c                                    |    4 -
 net/mac80211/rx.c                                  |   26 ++++++++++
 net/netfilter/ipvs/ip_vs_sync.c                    |   12 +++-
 scripts/decode_stacktrace.sh                       |    4 -
 sound/core/info.c                                  |    4 +
 sound/soc/codecs/rt5670.h                          |    2 
 76 files changed, 386 insertions(+), 146 deletions(-)

Arnd Bergmann (1):
      x86: math-emu: Fix up 'cmp' insn for clang ias

Ben Skeggs (1):
      drm/nouveau/i2c/g94-: increase NV_PMGR_DP_AUXCTL_TRANSACTREQ timeout

Boris Burkov (1):
      btrfs: fix mount failure caused by race with umount

Chen-Yu Tsai (1):
      drm: sun4i: hdmi: Fix inverted HPD result

Christophe JAILLET (1):
      hippi: Fix a size used in a 'pci_free_consistent()' in an error handling path

Chunfeng Yun (1):
      usb: xhci-mtk: fix the failure of bandwidth allocation

Cong Wang (1):
      bonding: check return value of register_netdevice() in bond_newlink()

Dinghao Liu (1):
      dmaengine: tegra210-adma: Fix runtime PM imbalance on error

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

George Kennedy (1):
      ax88172a: fix ax88172a_unbind() failures

Greg Kroah-Hartman (1):
      Linux 4.14.190

Hans de Goede (2):
      ASoC: rt5670: Correct RT5670_LDO_SEL_MASK
      HID: apple: Disable Fn-key key-re-mapping on clone keyboards

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

John David Anglin (1):
      parisc: Add atomic64_set_release() define to avoid CPU soft lockups

Leonid Ravich (1):
      dmaengine: ioat setting ioat timeout as module parameter

Liu Jian (1):
      mlxsw: destroy workqueue when trap_register in mlxsw_emad_init

Marc Kleine-Budde (1):
      regmap: dev_get_regmap_match(): fix string comparison

Mark O'Donovan (1):
      ath9k: Fix regression with Atheros 9271

Markus Theil (1):
      mac80211: allow rx of mesh eapol frames with default rx key

Matthew Howell (1):
      serial: exar: Fix GPIO configuration for Sealevel cards based on XR17V35X

Max Filippov (2):
      xtensa: fix __sync_fetch_and_{and,or}_4 declarations
      xtensa: update *pos in cpuinfo_op.next

Merlijn Wajer (1):
      Input: add `SW_MACHINE_COVER`

Michael J. Ruhl (1):
      io-mapping: indicate mapping failure

Navid Emamdoost (2):
      gpio: arizona: handle pm_runtime_get_sync failure case
      gpio: arizona: put pm_runtime in case of failure

Oleg Nesterov (1):
      uprobes: Change handle_swbp() to send SIGTRAP with si_code=SI_KERNEL, to fix GDB regression

Olga Kornievskaia (1):
      SUNRPC reverting d03727b248d0 ("NFSv4 fix CLOSE not waiting for direct IO compeletion")

Pi-Hsun Shih (1):
      scripts/decode_stacktrace: strip basepath from all paths

Qiujun Huang (1):
      ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb

Robbie Ko (1):
      btrfs: fix page leaks after failure to lock page for delalloc

Rustam Kovhaev (1):
      staging: wlan-ng: properly check endpoint types

Serge Semin (1):
      serial: 8250_mtk: Fix high-speed baud rates clamping

Sergey Organov (1):
      net: dp83640: fix SIOCSHWTSTAMP to update the struct with actual configuration

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

Wang Hai (1):
      net: smc91x: Fix possible memory leak in smc_drv_probe()

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

