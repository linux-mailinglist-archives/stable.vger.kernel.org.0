Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DA3330037
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 12:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbhCGLLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 06:11:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:57886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231604AbhCGLLV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 06:11:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FF6B65178;
        Sun,  7 Mar 2021 11:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615115480;
        bh=DdBCAEAIObtfum+vUgIZNMguOAnEOjO5lK5mark4Q6A=;
        h=From:To:Cc:Subject:Date:From;
        b=Tvum+ff9kljBRcCOZwXlZwi1A/7FwCh6B2Ee2bVfTVmDxnLb3wV/3vrh0eWSD8KHa
         DbL743YGImkWiYdjCRUGHKhCGFXaaL/HQrYJEZK4JNKjFZL58kuqfw8RiPKiNMeDIQ
         pZNXBqn4Mm0PfACeRR7mdMJcx4PZyUafxkMvcQew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.260
Date:   Sun,  7 Mar 2021 12:11:16 +0100
Message-Id: <161511547663204@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.260 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/sysfs.txt     |    8 -
 Makefile                                |    2 
 arch/arm/xen/p2m.c                      |   35 ++++++-
 arch/x86/kernel/module.c                |    1 
 arch/x86/kernel/reboot.c                |    9 +
 arch/x86/tools/relocs.c                 |   12 +-
 arch/x86/xen/p2m.c                      |   44 ++++++++-
 drivers/block/zram/zram_drv.c           |    2 
 drivers/media/usb/uvc/uvc_driver.c      |    7 +
 drivers/media/v4l2-core/v4l2-ioctl.c    |   19 +---
 drivers/mmc/host/sdhci-esdhc-imx.c      |    3 
 drivers/net/usb/qmi_wwan.c              |    1 
 drivers/net/wireless/ath/ath10k/mac.c   |   15 ---
 drivers/net/wireless/iwlwifi/pcie/tx.c  |    4 
 drivers/net/wireless/ti/wl12xx/main.c   |    3 
 drivers/net/wireless/ti/wlcore/main.c   |   15 ---
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 
 drivers/net/xen-netback/netback.c       |   12 ++
 drivers/scsi/libiscsi.c                 |  148 ++++++++++++++++----------------
 drivers/scsi/scsi_transport_iscsi.c     |   38 ++++++--
 drivers/staging/fwserial/fwserial.c     |    2 
 drivers/staging/most/aim-sound/sound.c  |    2 
 drivers/tty/vt/consolemap.c             |    2 
 fs/jfs/jfs_filsys.h                     |    1 
 fs/jfs/jfs_mount.c                      |   10 ++
 fs/sysfs/file.c                         |   55 +++++++++++
 fs/xfs/xfs_iops.c                       |    2 
 include/linux/sysfs.h                   |   16 +++
 include/linux/zsmalloc.h                |    2 
 kernel/futex.c                          |   24 ++---
 mm/hugetlb.c                            |   28 +++---
 mm/page_io.c                            |   11 --
 mm/swapfile.c                           |    2 
 mm/zsmalloc.c                           |   17 ++-
 net/bluetooth/amp.c                     |    3 
 net/core/pktgen.c                       |    2 
 net/core/skbuff.c                       |   14 ++-
 scripts/Makefile                        |    9 +
 38 files changed, 389 insertions(+), 194 deletions(-)

Chris Leech (2):
      scsi: iscsi: Ensure sysfs attributes are limited to PAGE_SIZE
      scsi: iscsi: Verify lengths on passthrough PDUs

Christian Gromm (1):
      staging: most: sound: add sanity check for function argument

Di Zhu (1):
      pktgen: fix misuse of BUG_ON() in pktgen_thread_worker()

Dinghao Liu (1):
      staging: fwserial: Fix error handling in fwserial_create

Fangrui Song (1):
      x86/build: Treat R_386_PLT32 relocation as R_386_PC32

Frank Li (1):
      mmc: sdhci-esdhc-imx: fix kernel panic when remove module

Gopal Tiwari (1):
      Bluetooth: Fix null pointer dereference in amp_read_loc_assoc_final_data

Greg Kroah-Hartman (1):
      Linux 4.4.260

Heiner Kallweit (1):
      x86/reboot: Add Zotac ZBOX CI327 nano PCI reboot quirk

Jan Beulich (2):
      Xen/gnttab: handle p2m update errors on a per-slot basis
      xen-netback: respect gnttab_map_refs()'s return value

Jens Axboe (1):
      swap: fix swapfile read/write offset

Jiri Slaby (1):
      vt/consolemap: do font sum unsigned

Joe Perches (1):
      sysfs: Add sysfs_emit and sysfs_emit_at to format sysfs output

Lech Perczak (1):
      net: usb: qmi_wwan: support ZTE P685M modem

Lee Duncan (1):
      scsi: iscsi: Restrict sessions and handles to admin capabilities

Li Xinhai (1):
      mm/hugetlb.c: fix unnecessary address expansion of pmd sharing

Marco Elver (1):
      net: fix up truesize of cloned skb in skb_prepare_for_shift()

Miaoqing Pan (1):
      ath10k: fix wmi mgmt tx queue full due to race condition

Mike Kravetz (1):
      hugetlb: fix update_and_free_page contig page struct assumption

Nobuhiro Iwamatsu (1):
      iwlwifi: pcie: fix to correct null check

Randy Dunlap (1):
      JFS: more checks for invalid superblock

Ricardo Ribalda (1):
      media: uvcvideo: Allow entities with no pads

Rokudo Yan (1):
      zsmalloc: account the number of compacted pages correctly

Rolf Eike Beer (2):
      scripts: use pkg-config to locate libcrypto
      scripts: set proper OpenSSL include dir also for sign-file

Sakari Ailus (1):
      media: v4l: ioctl: Fix memory leak in video_usercopy

Thomas Gleixner (1):
      futex: Ensure the correct return value from futex_lock_pi()

Tony Lindgren (1):
      wlcore: Fix command execute failure 19 for wl12xx

Yumei Huang (1):
      xfs: Fix assert failure in xfs_setattr_size()

