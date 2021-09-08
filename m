Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C354034B9
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 09:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236309AbhIHHHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 03:07:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234219AbhIHHHR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 03:07:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8938460ED8;
        Wed,  8 Sep 2021 07:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631084770;
        bh=4DnWL0qEEkiBkY5nEzSTOSyivSxdKRdD3GrEBhk14nM=;
        h=From:To:Cc:Subject:Date:From;
        b=NQAr8nDDETFwSbFVfjBdGo/67EA680h8EANorLUPsZu1fHYMO6MWZLIVd9/KFxspb
         NXceZnur/0pCsUEDWbRRUVvXBsNkeir+cDxGRT+qOWSssgrCBOQCSfZe6YnVrVG6Hy
         Zv2zbmbn0j7Xl9pCM+n327u38qX1rpO6TisAsNCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.63
Date:   Wed,  8 Sep 2021 09:06:04 +0200
Message-Id: <1631084764230217@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.63 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                     |    2 -
 arch/arm/mach-omap1/board-ams-delta.c        |   14 --------
 arch/x86/events/amd/ibs.c                    |    8 ++++
 arch/x86/events/amd/power.c                  |    1 
 arch/x86/events/intel/pt.c                   |    2 -
 arch/xtensa/Kconfig                          |    2 -
 drivers/block/Kconfig                        |    4 +-
 drivers/block/cryptoloop.c                   |    2 +
 drivers/gpu/ipu-v3/ipu-cpmem.c               |   30 +++++++++---------
 drivers/media/usb/stkwebcam/stk-webcam.c     |    6 ++-
 drivers/net/ethernet/cadence/macb_ptp.c      |   11 ++++++
 drivers/net/ethernet/qlogic/qed/qed_main.c   |    7 +++-
 drivers/net/ethernet/qlogic/qede/qede_main.c |    2 -
 drivers/reset/reset-zynqmp.c                 |    3 +
 drivers/tty/serial/8250/8250_omap.c          |    1 
 fs/9p/vfs_inode.c                            |    4 +-
 fs/9p/vfs_inode_dotl.c                       |    4 +-
 fs/ceph/mdsmap.c                             |    8 +++-
 fs/cifs/inode.c                              |    5 +--
 fs/crypto/hooks.c                            |   44 +++++++++++++++++++++++++++
 fs/exec.c                                    |    4 --
 fs/ext4/inline.c                             |    6 +++
 fs/ext4/symlink.c                            |   11 ++++++
 fs/f2fs/namei.c                              |   11 ++++++
 fs/fuse/dir.c                                |    6 +--
 fs/fuse/fuse_i.h                             |    7 ++++
 fs/fuse/inode.c                              |    4 +-
 fs/fuse/readdir.c                            |    7 +++-
 fs/nfs/inode.c                               |    6 +--
 fs/nfsd/nfsproc.c                            |    2 -
 fs/overlayfs/namei.c                         |    4 +-
 fs/ubifs/file.c                              |   12 ++++++-
 include/linux/cred.h                         |    2 -
 include/linux/fs.h                           |    5 +++
 include/linux/fscrypt.h                      |    7 ++++
 include/linux/spi/spi.h                      |    4 +-
 include/linux/user_namespace.h               |    4 --
 kernel/cred.c                                |   41 -------------------------
 kernel/fork.c                                |    6 ---
 kernel/static_call.c                         |    4 +-
 kernel/sys.c                                 |   12 -------
 kernel/ucount.c                              |   40 +-----------------------
 kernel/user_namespace.c                      |    3 -
 sound/core/pcm_lib.c                         |    2 -
 sound/pci/hda/patch_realtek.c                |   11 ++++++
 45 files changed, 201 insertions(+), 180 deletions(-)

Al Viro (1):
      new helper: inode_wrong_type()

Amir Goldstein (1):
      fuse: fix illegal access to inode with reused nodeid

Andy Shevchenko (1):
      spi: Switch to signed types for *_native_cs SPI controller fields

Christoph Hellwig (1):
      cryptoloop: add a deprecation warning

Eric Biggers (4):
      fscrypt: add fscrypt_symlink_getattr() for computing st_size
      ext4: report correct st_size for encrypted symlinks
      f2fs: report correct st_size for encrypted symlinks
      ubifs: report correct st_size for encrypted symlinks

Greg Kroah-Hartman (4):
      Revert "ucounts: Increase ucounts reference counter before the security hook"
      Revert "cred: add missing return error code when set_cred_ucounts() failed"
      Revert "Add a reference to ucounts for each cred"
      Linux 5.10.63

Harini Katakam (1):
      net: macb: Add a NULL check on desc_ptp

Johnathon Clark (1):
      ALSA: hda/realtek: Quirk for HP Spectre x360 14 amp setup

Kim Phillips (2):
      perf/x86/amd/ibs: Work around erratum #1197
      perf/x86/amd/power: Assign pmu.module

Krzysztof Hałasa (1):
      gpu: ipu-v3: Fix i.MX IPU-v3 offset calculations for (semi)planar U/V formats

Maciej Falkowski (1):
      ARM: OMAP1: ams-delta: remove unused function ams_delta_camera_power

Matthieu Baerts (1):
      static_call: Fix unused variable warn w/o MODULE

Pavel Skripkin (1):
      media: stkwebcam: fix memory leak in stk_camera_probe

Randy Dunlap (1):
      xtensa: fix kconfig unmet dependency warning for HAVE_FUTEX_CMPXCHG

Sai Krishna Potthuri (1):
      reset: reset-zynqmp: Fixed the argument data type

Shai Malin (2):
      qed: Fix the VF msix vectors flow
      qede: Fix memset corruption

Takashi Iwai (1):
      ALSA: hda/realtek: Workaround for conflicting SSID on ASUS ROG Strix G17

Theodore Ts'o (1):
      ext4: fix race writing to an inline_data file while its xattrs are changing

Tuo Li (1):
      ceph: fix possible null-pointer dereference in ceph_mdsmap_decode()

Vignesh Raghavendra (1):
      serial: 8250: 8250_omap: Fix possible array out of bounds access

Xiaoyao Li (1):
      perf/x86/intel/pt: Fix mask of num_address_ranges

Zubin Mithra (1):
      ALSA: pcm: fix divide error in snd_pcm_lib_ioctl

