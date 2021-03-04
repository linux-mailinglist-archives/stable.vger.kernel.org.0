Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E1D32CDB1
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 08:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhCDHhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 02:37:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232161AbhCDHh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 02:37:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8170E6023B;
        Thu,  4 Mar 2021 07:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614843406;
        bh=5nE+ddHuPCXm3KoFcKznqBTtcW2i3alx4qB1gTphtwY=;
        h=From:To:Cc:Subject:Date:From;
        b=Ya9KFUjGteP8f3UL1LGzrt6E0oOmnTztfK54051WDQkSUHupGkdjdlE4e7j3DWc80
         oFakjXUtA7W6JYdTpB6OOZGOWtvz/nAny7GdBkRdEADrgoAoa6YsKuzhyM7OWpHvOH
         +lpC1A9lRUSRNfS/FQSeBDS4mSABemMKei/jz4o0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.259
Date:   Thu,  4 Mar 2021 08:36:42 +0100
Message-Id: <1614843402121110@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.259 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/arm/boot/compressed/head.S                     |    4 
 arch/arm/boot/dts/exynos5250-spring.dts             |    2 
 arch/arm/boot/dts/exynos5420-arndale-octa.dts       |    2 
 arch/mips/kernel/vmlinux.lds.S                      |    1 
 arch/mips/lantiq/irq.c                              |    2 
 arch/mips/mm/c-r4k.c                                |    2 
 arch/powerpc/Kconfig                                |    2 
 arch/powerpc/platforms/pseries/dlpar.c              |    7 -
 arch/sparc/Kconfig                                  |    2 
 arch/sparc/lib/memset.S                             |    1 
 arch/x86/kernel/reboot.c                            |   29 ++----
 arch/xtensa/platforms/iss/simdisk.c                 |    1 
 block/blk-settings.c                                |   12 ++
 drivers/amba/bus.c                                  |   20 ++--
 drivers/block/brd.c                                 |    1 
 drivers/block/floppy.c                              |   27 +++--
 drivers/block/rbd.c                                 |    9 -
 drivers/block/zram/zram_drv.h                       |    1 
 drivers/clk/meson/clk-pll.c                         |    2 
 drivers/clocksource/mxs_timer.c                     |    5 -
 drivers/dma/fsldma.c                                |    6 +
 drivers/gpio/gpio-pcf857x.c                         |    2 
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c          |   22 ++--
 drivers/gpu/drm/gma500/psb_drv.c                    |    2 
 drivers/hid/hid-core.c                              |    9 +
 drivers/i2c/busses/i2c-brcmstb.c                    |    2 
 drivers/ide/ide-cd.c                                |    8 -
 drivers/ide/ide-cd.h                                |    6 -
 drivers/infiniband/core/user_mad.c                  |    7 +
 drivers/input/joydev.c                              |    7 +
 drivers/input/joystick/xpad.c                       |    1 
 drivers/input/serio/i8042-x86ia64io.h               |    4 
 drivers/input/touchscreen/elo.c                     |    4 
 drivers/md/dm-era-target.c                          |   93 ++++++++++++--------
 drivers/media/pci/cx25821/cx25821-core.c            |    4 
 drivers/media/pci/saa7134/saa7134-empress.c         |    5 -
 drivers/media/usb/dvb-usb-v2/lmedm04.c              |    2 
 drivers/media/usb/tm6000/tm6000-dvb.c               |    4 
 drivers/media/usb/uvc/uvc_v4l2.c                    |   18 +--
 drivers/mfd/wm831x-auxadc.c                         |    3 
 drivers/misc/eeprom/eeprom_93xx46.c                 |    1 
 drivers/misc/vmw_vmci/vmci_queue_pair.c             |    5 -
 drivers/mmc/host/usdhi6rol0.c                       |    4 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c           |    3 
 drivers/net/ethernet/intel/igb/igb_main.c           |    2 
 drivers/net/wireless/b43/phy_n.c                    |    2 
 drivers/net/xen-netback/interface.c                 |    9 +
 drivers/nvdimm/dimm_devs.c                          |   18 +++
 drivers/nvdimm/nd.h                                 |    1 
 drivers/pci/syscall.c                               |   10 +-
 drivers/regulator/axp20x-regulator.c                |    7 -
 drivers/scsi/bnx2fc/Kconfig                         |    1 
 drivers/scsi/gdth.h                                 |    3 
 drivers/spi/spi-s3c24xx-fiq.S                       |    9 -
 drivers/staging/rtl8188eu/os_dep/usb_intf.c         |    1 
 drivers/usb/core/quirks.c                           |    3 
 drivers/usb/dwc2/hcd_intr.c                         |   14 ++-
 drivers/usb/dwc3/gadget.c                           |   19 +++-
 drivers/usb/renesas_usbhs/fifo.c                    |    2 
 drivers/usb/serial/mos7720.c                        |    4 
 drivers/usb/serial/mos7840.c                        |    4 
 drivers/usb/serial/option.c                         |    3 
 drivers/video/fbdev/Kconfig                         |    2 
 fs/btrfs/free-space-cache.c                         |    6 +
 fs/btrfs/relocation.c                               |    4 
 fs/f2fs/file.c                                      |    3 
 fs/gfs2/lock_dlm.c                                  |    8 -
 fs/isofs/dir.c                                      |    1 
 fs/isofs/namei.c                                    |    1 
 fs/jffs2/summary.c                                  |    3 
 fs/jfs/jfs_dmap.c                                   |    2 
 fs/ntfs/inode.c                                     |    6 +
 include/linux/blkdev.h                              |   42 ++++++---
 include/linux/device-mapper.h                       |    2 
 include/linux/ide.h                                 |    1 
 include/uapi/linux/msdos_fs.h                       |    2 
 kernel/debug/kdb/kdb_private.h                      |    2 
 kernel/futex.c                                      |    7 -
 kernel/module.c                                     |   21 ++++
 kernel/tracepoint.c                                 |   80 +++++++++++++----
 mm/hugetlb.c                                        |   43 +++++++++
 mm/memory.c                                         |    6 -
 net/bluetooth/a2mp.c                                |    3 
 net/bluetooth/hci_core.c                            |    6 -
 scripts/recordmcount.pl                             |    6 +
 security/keys/trusted.c                             |    2 
 sound/soc/codecs/cs42l56.c                          |    3 
 tools/perf/tests/sample-parsing.c                   |    2 
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |    3 
 90 files changed, 493 insertions(+), 242 deletions(-)

Adrian Hunter (1):
      perf intel-pt: Fix missing CYC processing in PSB

Al Viro (1):
      sparc32: fix a user-triggerable oops in clear_user()

Alexander Lobakin (1):
      MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section

Arnd Bergmann (1):
      ARM: s3c: fix fiq for clang IAS

Aswath Govindraju (2):
      misc: eeprom_93xx46: Fix module alias to enable module autoprobe
      misc: eeprom_93xx46: Add module alias to avoid breaking support for non device tree users

Bart Van Assche (1):
      block: Move SECTOR_SIZE and SECTOR_SHIFT definitions into <linux/blkdev.h>

Bob Peterson (1):
      gfs2: Don't skip dlm unlock if glock has an lvb

Chao Yu (1):
      f2fs: fix out-of-repair __setattr_copy()

Christophe JAILLET (4):
      media: cx25821: Fix a bug when reallocating some dma memory
      dmaengine: fsldma: Fix a resource leak in the remove function
      dmaengine: fsldma: Fix a resource leak in an error handling path of the probe function
      mmc: usdhi6rol0: Fix a resource leak in the error handling path of the probe

Christophe Leroy (1):
      powerpc/47x: Disable 256k page size

Christopher William Snowhill (1):
      Bluetooth: Fix initializing response id after clearing struct

Colin Ian King (2):
      b43: N-PHY: Fix the update of coef for the PHY revision >= 3case
      fs/jfs: fix potential integer overflow on shift of a int

Corinna Vinschen (1):
      igb: Remove incorrect "unexpected SYS WRAP" log message

Dan Carpenter (7):
      gma500: clean up error handling in init
      ASoC: cs42l56: fix up error handling in probe
      mfd: wm831x-auxadc: Prevent use after free in wm831x_auxadc_read_irq()
      Input: elo - fix an error code in elo_connect()
      Input: joydev - prevent potential read overflow in ioctl
      USB: serial: mos7840: fix error code in mos7840_write()
      USB: serial: mos7720: fix error code in mos7720_write()

Dan Williams (1):
      libnvdimm/dimm: Avoid race between probe and available_slots_show()

David Vrabel (1):
      xen-netback: delete NAPI instance when queue fails to initialize

Dinghao Liu (2):
      media: media/pci: Fix memleak in empress_init
      media: tm6000: Fix memleak in tm6000_start_stream

Edwin Peer (1):
      bnxt_en: reverse order of TX disable and carrier off

Fangrui Song (1):
      module: Ignore _GLOBAL_OFFSET_TABLE_ when warning for undefined symbols

Greg Kroah-Hartman (1):
      Linux 4.4.259

Guenter Roeck (2):
      usb: dwc2: Abort transaction after errors with unknown reason
      usb: dwc2: Make "trimming xfer length" a debug message

Heiner Kallweit (1):
      PCI: Align checking of syscall user config accessors

Jarkko Sakkinen (1):
      KEYS: trusted: Fix migratable=1 failing

Jialin Zhang (1):
      drm/gma500: Fix error return code in psb_driver_load()

Jiri Kosina (1):
      floppy: reintroduce O_NDELAY fix

Joe Perches (1):
      media: lmedm04: Fix misuse of comma

Jorgen Hansen (1):
      VMCI: Use set_page_dirty_lock() when unregistering guest memory

Josef Bacik (1):
      btrfs: fix reloc root leak with 0 ref reloc roots on recovery

Juergen Gross (1):
      xen/netback: fix spurious event detection for common event case

Krzysztof Kozlowski (2):
      ARM: dts: exynos: correct PMIC interrupt trigger level on Spring
      ARM: dts: exynos: correct PMIC interrupt trigger level on Arndale Octa

Laurent Pinchart (1):
      media: uvcvideo: Accept invalid bFormatIndex and bFrameIndex values

Lech Perczak (1):
      USB: serial: option: update interface mapping for ZTE P685M

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

Pan Bian (4):
      Bluetooth: drop HCI device reference before return
      Bluetooth: Put HCI device if inquiry procedure interrupts
      regulator: axp20x: Fix reference cout leak
      isofs: release buffer head before return

Peter Zijlstra (1):
      futex: Fix OWNER_DEAD fixup

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

Sean Christopherson (1):
      x86/reboot: Force all cpus to exit VMX root if VMX is supported

Shay Drory (1):
      IB/umad: Return EIO in case of when device disassociated

Stefan Ursella (1):
      usb: quirks: add quirk to start video capture on ELMO L-12F document camera reliable

Steven Rostedt (VMware) (1):
      tracepoint: Do not fail unregistering a probe due to memory failure

Sumit Garg (1):
      kdb: Make memory allocations more robust

Thinh Nguyen (2):
      usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_m1
      usb: dwc3: gadget: Fix dep->interval for fullspeed interrupt

Tom Rix (2):
      jffs2: fix use after free in jffs2_sum_write_data()
      clocksource/drivers/mxs_timer: Add missing semicolon when DEBUG is defined

Uwe Kleine-König (1):
      amba: Fix resource leak for drivers without .remove

Vladimir Murzin (1):
      ARM: 9046/1: decompressor: Do not clear SCTLR.nTLSMD for ARMv7+ cores

Will McVicker (1):
      HID: make arrays usage and value to be the same

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: Clear pipe running flag in usbhs_pkt_pop()

Zhihao Cheng (1):
      btrfs: clarify error returns values in __load_free_space_cache

