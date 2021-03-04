Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E30032CDBA
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 08:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbhCDHiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 02:38:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:47474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231709AbhCDHhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 02:37:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B970F64EFC;
        Thu,  4 Mar 2021 07:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614843414;
        bh=9GE4+luXNQPp2YfYX7deNN93qnB2RU5uozC/6unUUWU=;
        h=From:To:Cc:Subject:Date:From;
        b=pPCdF40V9yxj5M51OGYz+EphJ9EtTf8V+a+zjemePNUSeZqVbMIG5nD1ocSCaVH9G
         MT8q4Vg6EpVmuBuRLsG/wNoqLr9oKoWeMSjhP89jPUA2wcZhGkD6k8cleb/8TCEniP
         yLG+fFvAYt4b+Rx88lht/D0xDznFKQbmhiCAEjm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.259
Date:   Thu,  4 Mar 2021 08:36:47 +0100
Message-Id: <1614843407163146@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.259 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/arm/boot/compressed/head.S                       |    4 
 arch/arm/boot/dts/exynos5250-spring.dts               |    2 
 arch/arm/boot/dts/exynos5420-arndale-octa.dts         |    2 
 arch/arm/boot/dts/omap443x.dtsi                       |    2 
 arch/arm64/boot/dts/exynos/exynos7-espresso.dts       |    2 
 arch/arm64/boot/dts/nvidia/tegra210.dtsi              |    1 
 arch/arm64/boot/dts/qcom/msm8916.dtsi                 |    4 
 arch/arm64/kernel/head.S                              |    1 
 arch/mips/kernel/vmlinux.lds.S                        |    1 
 arch/mips/lantiq/irq.c                                |    2 
 arch/mips/mm/c-r4k.c                                  |    2 
 arch/powerpc/Kconfig                                  |    2 
 arch/powerpc/platforms/pseries/dlpar.c                |    7 -
 arch/sparc/Kconfig                                    |    2 
 arch/sparc/lib/memset.S                               |    1 
 arch/x86/kernel/reboot.c                              |   29 +----
 block/blk-settings.c                                  |   12 ++
 crypto/ecdh_helper.c                                  |    3 
 drivers/acpi/acpi_configfs.c                          |    7 +
 drivers/amba/bus.c                                    |   20 ++-
 drivers/ata/ahci_brcm.c                               |   14 ++
 drivers/block/floppy.c                                |   27 ++---
 drivers/char/random.c                                 |    2 
 drivers/clk/meson/clk-pll.c                           |    2 
 drivers/clocksource/mxs_timer.c                       |    5 
 drivers/dma/fsldma.c                                  |    6 +
 drivers/gpio/gpio-pcf857x.c                           |    2 
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c            |   22 ++--
 drivers/gpu/drm/gma500/psb_drv.c                      |    2 
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_20nm.c            |    2 
 drivers/hid/hid-core.c                                |    9 +
 drivers/i2c/busses/i2c-brcmstb.c                      |    2 
 drivers/infiniband/core/user_mad.c                    |    7 +
 drivers/infiniband/sw/rxe/rxe_recv.c                  |   11 +-
 drivers/input/joydev.c                                |    7 -
 drivers/input/joystick/xpad.c                         |    1 
 drivers/input/serio/i8042-x86ia64io.h                 |    4 
 drivers/input/touchscreen/elo.c                       |    4 
 drivers/input/touchscreen/raydium_i2c_ts.c            |    3 
 drivers/md/dm-era-target.c                            |   93 +++++++++++-------
 drivers/media/pci/cx25821/cx25821-core.c              |    4 
 drivers/media/pci/saa7134/saa7134-empress.c           |    5 
 drivers/media/platform/pxa_camera.c                   |    3 
 drivers/media/platform/vsp1/vsp1_drv.c                |    4 
 drivers/media/tuners/qm1d1c0042.c                     |    4 
 drivers/media/usb/dvb-usb-v2/lmedm04.c                |    2 
 drivers/media/usb/tm6000/tm6000-dvb.c                 |    4 
 drivers/media/usb/uvc/uvc_v4l2.c                      |   18 +--
 drivers/mfd/wm831x-auxadc.c                           |    3 
 drivers/misc/eeprom/eeprom_93xx46.c                   |    1 
 drivers/misc/vmw_vmci/vmci_queue_pair.c               |    5 
 drivers/mmc/host/sdhci-esdhc-imx.c                    |    3 
 drivers/mmc/host/usdhi6rol0.c                         |    4 
 drivers/mtd/spi-nor/cadence-quadspi.c                 |    2 
 drivers/mtd/spi-nor/hisi-sfc.c                        |    4 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c             |    3 
 drivers/net/ethernet/intel/i40e/i40e_txrx.c           |    9 +
 drivers/net/ethernet/intel/igb/igb_main.c             |    2 
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c |    1 
 drivers/net/ethernet/sun/sunvnet_common.c             |   24 ----
 drivers/net/gtp.c                                     |    5 
 drivers/net/usb/qmi_wwan.c                            |    1 
 drivers/net/wireless/broadcom/b43/phy_n.c             |    2 
 drivers/net/xen-netback/interface.c                   |    8 -
 drivers/nvdimm/dimm_devs.c                            |   18 ++-
 drivers/of/fdt.c                                      |   12 +-
 drivers/pci/syscall.c                                 |   10 -
 drivers/power/reset/at91-sama5d2_shdwc.c              |    2 
 drivers/pwm/pwm-rockchip.c                            |    1 
 drivers/regulator/axp20x-regulator.c                  |    7 -
 drivers/scsi/bnx2fc/Kconfig                           |    1 
 drivers/spi/spi-pxa2xx-pci.c                          |   27 +++--
 drivers/spi/spi-s3c24xx-fiq.S                         |    9 -
 drivers/staging/rtl8188eu/os_dep/usb_intf.c           |    1 
 drivers/usb/core/quirks.c                             |    3 
 drivers/usb/dwc2/hcd.c                                |   15 +-
 drivers/usb/dwc2/hcd_intr.c                           |   14 ++
 drivers/usb/dwc3/gadget.c                             |   19 +++
 drivers/usb/musb/musb_core.c                          |   31 +++---
 drivers/usb/renesas_usbhs/fifo.c                      |    2 
 drivers/usb/serial/mos7720.c                          |    4 
 drivers/usb/serial/mos7840.c                          |    4 
 drivers/usb/serial/option.c                           |    3 
 drivers/video/fbdev/Kconfig                           |    2 
 fs/btrfs/ctree.c                                      |    7 -
 fs/btrfs/free-space-cache.c                           |    6 -
 fs/btrfs/relocation.c                                 |    4 
 fs/cifs/connect.c                                     |    1 
 fs/f2fs/file.c                                        |    3 
 fs/gfs2/lock_dlm.c                                    |    8 -
 fs/isofs/dir.c                                        |    1 
 fs/isofs/namei.c                                      |    1 
 fs/jffs2/summary.c                                    |    3 
 fs/jfs/jfs_dmap.c                                     |    2 
 fs/ntfs/inode.c                                       |    6 +
 fs/ocfs2/cluster/heartbeat.c                          |    8 +
 include/linux/icmpv6.h                                |   48 ++++++++-
 include/linux/ipv6.h                                  |    2 
 include/net/icmp.h                                    |   10 +
 kernel/debug/kdb/kdb_private.h                        |    2 
 kernel/futex.c                                        |   12 +-
 kernel/module.c                                       |   21 +++-
 kernel/seccomp.c                                      |    2 
 kernel/tracepoint.c                                   |   80 ++++++++++++---
 mm/huge_memory.c                                      |   15 ++
 mm/hugetlb.c                                          |   43 ++++++++
 mm/memory.c                                           |    6 -
 net/bluetooth/a2mp.c                                  |    3 
 net/bluetooth/hci_core.c                              |    6 -
 net/ipv4/icmp.c                                       |   34 ++++++
 net/ipv6/icmp.c                                       |   19 +--
 net/ipv6/ip6_icmp.c                                   |   46 +++++++-
 net/mac80211/mesh_hwmp.c                              |    2 
 scripts/recordmcount.pl                               |    6 -
 security/keys/trusted.c                               |    2 
 sound/soc/codecs/cs42l56.c                            |    3 
 tools/perf/tests/sample-parsing.c                     |    2 
 tools/perf/util/event.c                               |    2 
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c   |    3 
 120 files changed, 757 insertions(+), 301 deletions(-)

Adrian Hunter (1):
      perf intel-pt: Fix missing CYC processing in PSB

Al Viro (1):
      sparc32: fix a user-triggerable oops in clear_user()

Alexander Lobakin (1):
      MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section

Andy Shevchenko (1):
      spi: pxa2xx: Fix the controller numbering for Wildcat Point

Arnaldo Carvalho de Melo (1):
      perf tools: Fix DSO filtering when not finding a map for a sampled address

Arnd Bergmann (1):
      ARM: s3c: fix fiq for clang IAS

Aswath Govindraju (2):
      misc: eeprom_93xx46: Fix module alias to enable module autoprobe
      misc: eeprom_93xx46: Add module alias to avoid breaking support for non device tree users

Bob Pearson (1):
      RDMA/rxe: Fix coding error in rxe_recv.c

Bob Peterson (1):
      gfs2: Don't skip dlm unlock if glock has an lvb

Chao Yu (1):
      f2fs: fix out-of-repair __setattr_copy()

Christoph Schemmel (1):
      NET: usb: qmi_wwan: Adding support for Cinterion MV31

Christophe JAILLET (5):
      media: vsp1: Fix an error handling path in the probe function
      media: cx25821: Fix a bug when reallocating some dma memory
      dmaengine: fsldma: Fix a resource leak in the remove function
      dmaengine: fsldma: Fix a resource leak in an error handling path of the probe function
      mmc: usdhi6rol0: Fix a resource leak in the error handling path of the probe

Christophe Leroy (1):
      powerpc/47x: Disable 256k page size

Christopher William Snowhill (1):
      Bluetooth: Fix initializing response id after clearing struct

Chuhong Yuan (1):
      net/mlx4_core: Add missed mlx4_free_cmd_mailbox()

Claudiu Beznea (1):
      power: reset: at91-sama5d2_shdwc: fix wkupdbc mask

Colin Ian King (3):
      mac80211: fix potential overflow when multiplying to u32 integers
      b43: N-PHY: Fix the update of coef for the PHY revision >= 3case
      fs/jfs: fix potential integer overflow on shift of a int

Corinna Vinschen (1):
      igb: Remove incorrect "unexpected SYS WRAP" log message

Dan Carpenter (8):
      gma500: clean up error handling in init
      ASoC: cs42l56: fix up error handling in probe
      mfd: wm831x-auxadc: Prevent use after free in wm831x_auxadc_read_irq()
      Input: elo - fix an error code in elo_connect()
      ocfs2: fix a use after free on error
      Input: joydev - prevent potential read overflow in ioctl
      USB: serial: mos7840: fix error code in mos7840_write()
      USB: serial: mos7720: fix error code in mos7720_write()

Dan Williams (1):
      libnvdimm/dimm: Avoid race between probe and available_slots_show()

Daniele Alessandrelli (1):
      crypto: ecdh_helper - Ensure 'len >= secret.len' in decode_key()

Dinghao Liu (2):
      media: media/pci: Fix memleak in empress_init
      media: tm6000: Fix memleak in tm6000_start_stream

Edwin Peer (1):
      bnxt_en: reverse order of TX disable and carrier off

Eric Biggers (1):
      random: fix the RNDRESEEDCRNG ioctl

Eric Dumazet (1):
      ipv6: icmp6: avoid indirect call for icmpv6_send()

Fangrui Song (1):
      module: Ignore _GLOBAL_OFFSET_TABLE_ when warning for undefined symbols

Filipe Manana (1):
      btrfs: fix extent buffer leak on failure to copy root

Florian Fainelli (1):
      ata: ahci_brcm: Add back regulators management

Frank Li (1):
      mmc: sdhci-esdhc-imx: fix kernel panic when remove module

Greg Kroah-Hartman (1):
      Linux 4.9.259

Guenter Roeck (3):
      usb: dwc2: Do not update data length if it is 0 on inbound transfers
      usb: dwc2: Abort transaction after errors with unknown reason
      usb: dwc2: Make "trimming xfer length" a debug message

Heiner Kallweit (1):
      PCI: Align checking of syscall user config accessors

Jarkko Sakkinen (1):
      KEYS: trusted: Fix migratable=1 failing

Jason A. Donenfeld (5):
      icmp: introduce helper for nat'd source address in network device context
      icmp: allow icmpv6_ndo_send to work with CONFIG_IPV6=n
      gtp: use icmp_ndo_send helper
      sunvnet: use icmp_ndo_send helper
      net: icmp: pass zeroed opts from icmp{,v6}_ndo_send before sending

Jialin Zhang (1):
      drm/gma500: Fix error return code in psb_driver_load()

Jiri Kosina (1):
      floppy: reintroduce O_NDELAY fix

Joe Perches (1):
      media: lmedm04: Fix misuse of comma

Jorgen Hansen (1):
      VMCI: Use set_page_dirty_lock() when unregistering guest memory

Josef Bacik (2):
      btrfs: abort the transaction if we fail to inc ref in btrfs_copy_root
      btrfs: fix reloc root leak with 0 ref reloc roots on recovery

Juergen Gross (1):
      xen/netback: fix spurious event detection for common event case

KarimAllah Ahmed (1):
      fdt: Properly handle "no-map" field in the memory region

Konrad Dybcio (1):
      drm/msm/dsi: Correct io_start for MSM8994 (20nm PHY)

Krzysztof Kozlowski (3):
      ARM: dts: exynos: correct PMIC interrupt trigger level on Spring
      ARM: dts: exynos: correct PMIC interrupt trigger level on Arndale Octa
      arm64: dts: exynos: correct PMIC interrupt trigger level on Espresso

Laurent Pinchart (1):
      media: uvcvideo: Accept invalid bFormatIndex and bFrameIndex values

Lech Perczak (1):
      USB: serial: option: update interface mapping for ZTE P685M

Leon Romanovsky (1):
      ipv6: silence compilation warning for non-IPV6 builds

Luo Meng (1):
      media: qm1d1c0042: fix error return code in qm1d1c0042_init()

Marc Zyngier (1):
      arm64: Add missing ISB after invalidating TLB in __primary_switch

Marcos Paulo de Souza (1):
      Input: i8042 - add ASUS Zenbook Flip to noselftest list

Martin Blumenstingl (1):
      clk: meson: clk-pll: fix initializing the old rate (fallback) for a PLL

Martin Kaiser (1):
      staging: rtl8188eu: Add Edimax EW-7811UN V2 to device table

Maxim Kiselev (1):
      gpio: pcf857x: Fix missing first interrupt

Maxime Ripard (1):
      i2c: brcmstb: Fix brcmstd_send_i2c_cmd condition

Miaohe Lin (2):
      mm/memory.c: fix potential pte_unmap_unlock pte error
      mm/hugetlb: fix potential double free in hugetlb_register_node() error path

Mikulas Patocka (1):
      blk-settings: align max_sectors on "logical_block_size" boundary

Muchun Song (1):
      mm: hugetlb: fix a race between freeing and dissolving the page

Namhyung Kim (1):
      perf test: Fix unaligned access in sample parsing test

Nathan Chancellor (2):
      MIPS: c-r4k: Fix section mismatch for loongson2_sc_init
      MIPS: lantiq: Explicitly compare LTQ_EBU_PCC_ISTAT against 0

Nathan Lynch (1):
      powerpc/pseries/dlpar: handle ibm, configure-connector delay status

Nicolas Boichat (1):
      of/fdt: Make sure no-map does not remove already reserved regions

Nikos Tsironis (7):
      dm era: Recover committed writeset after crash
      dm era: Verify the data block size hasn't changed
      dm era: Fix bitset memory leaks
      dm era: Use correct value size in equality function of writeset tree
      dm era: Reinitialize bitset cache before digesting a new writeset
      dm era: only resize metadata in preresume
      dm era: Update in-core bitset after committing the metadata

Olivier Crête (1):
      Input: xpad - add support for PowerA Enhanced Wired Controller for Xbox Series X|S

Pan Bian (5):
      Bluetooth: drop HCI device reference before return
      Bluetooth: Put HCI device if inquiry procedure interrupts
      regulator: axp20x: Fix reference cout leak
      isofs: release buffer head before return
      mtd: spi-nor: hisi-sfc: Put child node np on error path

Paul Cercueil (2):
      usb: musb: Fix runtime PM race in musb_queue_resume_work
      seccomp: Add missing return in non-void function

Peter Zijlstra (1):
      futex: Fix OWNER_DEAD fixup

Pratyush Yadav (1):
      spi: cadence-quadspi: Abort read if dummy cycles required are too many

Qinglang Miao (1):
      ACPI: configfs: add missing check after configfs_register_default_group()

Randy Dunlap (4):
      fbdev: aty: SPARC64 requires FB_ATY_CT
      HID: core: detect and skip invalid inputs to snto32()
      sparc64: only select COMPAT_BINFMT_ELF if BINFMT_ELF is set
      scsi: bnx2fc: Fix Kconfig warning & CNIC build errors

Rong Chen (1):
      scripts/recordmcount.pl: support big endian for ARCH sh

Rustam Kovhaev (1):
      ntfs: check for valid standard information attribute

Sabyrzhan Tasbolatov (1):
      drivers/misc/vmw_vmci: restrict too big queue size in qp_host_alloc_queue

Sameer Pujar (1):
      arm64: tegra: Add power-domain for Tegra210 HDA

Sean Christopherson (1):
      x86/reboot: Force all cpus to exit VMX root if VMX is supported

Shay Drory (1):
      IB/umad: Return EIO in case of when device disassociated

Shyam Prasad N (1):
      cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.

Simon South (1):
      pwm: rockchip: rockchip_pwm_probe(): Remove superfluous clk_unprepare()

Slawomir Laba (1):
      i40e: Fix flow for IPv6 next header (extension header)

Stefan Ursella (1):
      usb: quirks: add quirk to start video capture on ELMO L-12F document camera reliable

Steven Rostedt (VMware) (1):
      tracepoint: Do not fail unregistering a probe due to memory failure

Sumit Garg (1):
      kdb: Make memory allocations more robust

Thinh Nguyen (2):
      usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_m1
      usb: dwc3: gadget: Fix dep->interval for fullspeed interrupt

Thomas Gleixner (1):
      futex: fix dead code in attach_to_pi_owner()

Tom Rix (3):
      media: pxa_camera: declare variable when DEBUG is defined
      jffs2: fix use after free in jffs2_sum_write_data()
      clocksource/drivers/mxs_timer: Add missing semicolon when DEBUG is defined

Tony Lindgren (1):
      ARM: dts: Configure missing thermal interrupt for 4430

Uwe Kleine-König (1):
      amba: Fix resource leak for drivers without .remove

Vincent Knecht (1):
      arm64: dts: msm8916: Fix reserved and rfsa nodes unit address

Vladimir Murzin (1):
      ARM: 9046/1: decompressor: Do not clear SCTLR.nTLSMD for ARMv7+ cores

Vlastimil Babka (1):
      mm, thp: make do_huge_pmd_wp_page() lock page for testing mapcount

Will McVicker (1):
      HID: make arrays usage and value to be the same

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: Clear pipe running flag in usbhs_pkt_pop()

Zhihao Cheng (1):
      btrfs: clarify error returns values in __load_free_space_cache

jeffrey.lin (1):
      Input: raydium_ts_i2c - do not send zero length

