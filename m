Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C4B33008D
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 12:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbhCGLy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 06:54:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:35308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230475AbhCGLys (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 06:54:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3B2465020;
        Sun,  7 Mar 2021 11:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615118088;
        bh=TxaW9yo3Rqu6PNJcQGVvCONzcOZ+hPliPm6VwpwLdLI=;
        h=From:To:Cc:Subject:Date:From;
        b=cIV1IHamAGZn2I/xZJma6jWzZjvy7WfTG3Q2p1Rm01GWJJC5pOlnvc7kD5GFYh2s4
         fVSpl/nJ4vpFohHWlmDnPkxHVqkATulyCnvSuliRAoWNp75hG+TOSIolycelg9atkY
         skAXdCsumBoD7yuXCJWvhu++6atRr04Bk9GAQYzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.179
Date:   Sun,  7 Mar 2021 12:54:44 +0100
Message-Id: <161511808487241@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.179 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/net/btusb.txt |    2 
 Documentation/filesystems/sysfs.txt             |    8 -
 Makefile                                        |    2 
 arch/arm/xen/p2m.c                              |   35 +++++
 arch/arm64/include/asm/atomic_ll_sc.h           |  108 +++++++++--------
 arch/arm64/include/asm/atomic_lse.h             |   46 +++----
 arch/arm64/include/asm/cmpxchg.h                |  116 +++++++++---------
 arch/arm64/kernel/module.lds                    |    6 
 arch/mips/vdso/Makefile                         |    5 
 arch/parisc/kernel/irq.c                        |    4 
 arch/x86/kernel/module.c                        |    1 
 arch/x86/kernel/reboot.c                        |    9 +
 arch/x86/tools/relocs.c                         |   12 +
 arch/x86/xen/p2m.c                              |   44 ++++++-
 crypto/tcrypt.c                                 |   20 +--
 drivers/block/zram/zram_drv.c                   |    2 
 drivers/bluetooth/hci_h5.c                      |    5 
 drivers/gpu/drm/amd/display/dc/core/dc_link.c   |    5 
 drivers/gpu/drm/virtio/virtgpu_vq.c             |    6 
 drivers/media/rc/mceusb.c                       |    9 +
 drivers/media/usb/uvc/uvc_driver.c              |    7 -
 drivers/media/v4l2-core/v4l2-ioctl.c            |   19 +--
 drivers/net/usb/qmi_wwan.c                      |    1 
 drivers/net/wireless/ath/ath10k/mac.c           |   15 --
 drivers/net/wireless/rsi/rsi_91x_hal.c          |    3 
 drivers/net/wireless/rsi/rsi_91x_sdio.c         |    6 
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c     |   52 ++------
 drivers/net/wireless/rsi/rsi_sdio.h             |    8 -
 drivers/net/wireless/ti/wl12xx/main.c           |    3 
 drivers/net/wireless/ti/wlcore/main.c           |   15 --
 drivers/net/wireless/ti/wlcore/wlcore.h         |    3 
 drivers/net/xen-netback/netback.c               |   12 +
 drivers/pci/pci.c                               |    9 +
 drivers/s390/virtio/virtio_ccw.c                |    4 
 drivers/scsi/libiscsi.c                         |  148 ++++++++++++------------
 drivers/scsi/scsi_transport_iscsi.c             |   38 ++++--
 drivers/staging/fwserial/fwserial.c             |    2 
 drivers/staging/most/sound/sound.c              |    2 
 drivers/tty/vt/consolemap.c                     |    2 
 drivers/video/fbdev/udlfb.c                     |    1 
 fs/btrfs/transaction.c                          |   11 -
 fs/f2fs/namei.c                                 |    8 +
 fs/f2fs/segment.h                               |    4 
 fs/jfs/jfs_filsys.h                             |    1 
 fs/jfs/jfs_mount.c                              |   10 +
 fs/sysfs/file.c                                 |   55 ++++++++
 fs/xfs/xfs_iops.c                               |    2 
 include/linux/sysfs.h                           |   16 ++
 include/linux/zsmalloc.h                        |    2 
 mm/hugetlb.c                                    |   28 ++--
 mm/page_io.c                                    |   11 -
 mm/swapfile.c                                   |    2 
 mm/zsmalloc.c                                   |   17 +-
 net/bluetooth/amp.c                             |    3 
 net/bridge/br_sysfs_if.c                        |    9 -
 net/core/pktgen.c                               |    2 
 net/core/skbuff.c                               |   14 ++
 security/smack/smackfs.c                        |   21 +++
 sound/pci/hda/patch_realtek.c                   |    2 
 sound/soc/intel/boards/bytcr_rt5640.c           |   37 ++++++
 60 files changed, 651 insertions(+), 399 deletions(-)

Andrew Murray (1):
      arm64: Use correct ll/sc atomic constraints

Ard Biesheuvel (1):
      crypto: tcrypt - avoid signed overflow in byte count

Chao Yu (1):
      f2fs: fix to set/clear I_LINKABLE under i_lock

Chris Leech (2):
      scsi: iscsi: Ensure sysfs attributes are limited to PAGE_SIZE
      scsi: iscsi: Verify lengths on passthrough PDUs

Christian Gromm (1):
      staging: most: sound: add sanity check for function argument

Claire Chang (1):
      Bluetooth: hci_h5: Set HCI_QUIRK_SIMULTANEOUS_DISCOVERY for btrtl

Cornelia Huck (1):
      virtio/s390: implement virtio-ccw revision 2 correctly

Di Zhu (1):
      pktgen: fix misuse of BUG_ON() in pktgen_thread_worker()

Dinghao Liu (1):
      staging: fwserial: Fix error handling in fwserial_create

Eckhart Mohr (1):
      ALSA: hda/realtek: Add quirk for Clevo NH55RZQ

Fangrui Song (1):
      x86/build: Treat R_386_PLT32 relocation as R_386_PC32

Geert Uytterhoeven (1):
      dt-bindings: net: btusb: DT fix s/interrupt-name/interrupt-names/

Gopal Tiwari (1):
      Bluetooth: Fix null pointer dereference in amp_read_loc_assoc_final_data

Greg Kroah-Hartman (1):
      Linux 4.19.179

Hans de Goede (3):
      ASoC: Intel: bytcr_rt5640: Add quirk for the Estar Beauty HD MID 7316R tablet
      ASoC: Intel: bytcr_rt5640: Add quirk for the Voyo Winpad A15 tablet
      ASoC: Intel: bytcr_rt5640: Add quirk for the Acer One S1002 tablet

Heiner Kallweit (1):
      x86/reboot: Add Zotac ZBOX CI327 nano PCI reboot quirk

Jaegeuk Kim (1):
      f2fs: handle unallocated section and zone on pinned/atgc

Jan Beulich (2):
      Xen/gnttab: handle p2m update errors on a per-slot basis
      xen-netback: respect gnttab_map_refs()'s return value

Jens Axboe (1):
      swap: fix swapfile read/write offset

Jiri Slaby (1):
      vt/consolemap: do font sum unsigned

Joe Perches (1):
      sysfs: Add sysfs_emit and sysfs_emit_at to format sysfs output

John David Anglin (1):
      parisc: Bump 64-bit IRQ stack size to 64 KB

Josef Bacik (1):
      btrfs: fix error handling in commit_fs_roots

Lech Perczak (1):
      net: usb: qmi_wwan: support ZTE P685M modem

Lee Duncan (1):
      scsi: iscsi: Restrict sessions and handles to admin capabilities

Li Xinhai (1):
      mm/hugetlb.c: fix unnecessary address expansion of pmd sharing

Marco Elver (1):
      net: fix up truesize of cloned skb in skb_prepare_for_shift()

Marek Vasut (2):
      rsi: Fix TX EAPOL packet handling against iwlwifi AP
      rsi: Move card interrupt handling to RX thread

Miaoqing Pan (1):
      ath10k: fix wmi mgmt tx queue full due to race condition

Mike Kravetz (1):
      hugetlb: fix update_and_free_page contig page struct assumption

Nathan Chancellor (1):
      MIPS: VDSO: Use CLANG_FLAGS instead of filtering out '--target='

Nicholas Kazlauskas (1):
      drm/amd/display: Guard against NULL pointer deref when get_i2c_info fails

Nirmoy Das (1):
      PCI: Add a REBAR size quirk for Sapphire RX 5600 XT Pulse

Randy Dunlap (1):
      JFS: more checks for invalid superblock

Ricardo Ribalda (1):
      media: uvcvideo: Allow entities with no pads

Rokudo Yan (1):
      zsmalloc: account the number of compacted pages correctly

Sabyrzhan Tasbolatov (1):
      smackfs: restrict bytes count in smackfs write functions

Sakari Ailus (1):
      media: v4l: ioctl: Fix memory leak in video_usercopy

Sean Young (1):
      media: mceusb: sanity check for prescaler value

Sergey Senozhatsky (1):
      drm/virtio: use kvmalloc for large allocations

Shaoying Xu (1):
      arm64 module: set plt* section addresses to 0x0

Takashi Iwai (1):
      ALSA: hda/realtek: Apply dual codec quirks for MSI Godlike X570 board

Tony Lindgren (1):
      wlcore: Fix command execute failure 19 for wl12xx

Vladimir Oltean (1):
      net: bridge: use switchdev for port flags set through sysfs too

Will Deacon (2):
      arm64: Avoid redundant type conversions in xchg() and cmpxchg()
      arm64: cmpxchg: Use "K" instead of "L" for ll/sc immediate constraint

Yumei Huang (1):
      xfs: Fix assert failure in xfs_setattr_size()

Zqiang (1):
      udlfb: Fix memory leak in dlfb_usb_probe

