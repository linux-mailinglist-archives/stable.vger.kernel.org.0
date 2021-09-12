Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1D4407D95
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 15:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbhILN1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 09:27:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235178AbhILN1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Sep 2021 09:27:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83949610CE;
        Sun, 12 Sep 2021 13:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631453178;
        bh=3SB+poM9OiAmrtr0AEtTGh2Z4fGDTi1R2K4An9Y5GF8=;
        h=From:To:Cc:Subject:Date:From;
        b=XIS131TskZ8az+w6BRadhLr7dsLM/8las4WZ6rfcwdEUPqkGWLi95jggdzbbnmPIS
         JIRuPrxDg76nnH3uaic6sgDrNzteEWWKO9jptmXr98x34BK3Fs55v9XUsEh/er812i
         HHG3Bbtp2zWGOYIBdlV0jaNyPab/DbjLOhbkcKV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.145
Date:   Sun, 12 Sep 2021 15:26:14 +0200
Message-Id: <163145317415133@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.145 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                     |    2 -
 arch/arc/Kconfig                             |    1 
 arch/arc/include/asm/syscalls.h              |    1 
 arch/arc/include/uapi/asm/unistd.h           |    1 
 arch/arc/kernel/entry.S                      |   12 ++++++
 arch/arc/kernel/process.c                    |    7 +--
 arch/arc/kernel/sys.c                        |    1 
 arch/arm/kernel/Makefile                     |    6 ++-
 arch/arm/kernel/return_address.c             |    4 --
 arch/powerpc/boot/crt0.S                     |    3 -
 arch/x86/events/amd/ibs.c                    |    8 ++++
 arch/x86/events/amd/iommu.c                  |   47 +++++++++++++-----------
 arch/x86/events/amd/power.c                  |    1 
 arch/x86/events/intel/pt.c                   |    2 -
 arch/x86/kernel/reboot.c                     |    3 +
 arch/xtensa/Kconfig                          |    2 -
 drivers/block/Kconfig                        |    4 +-
 drivers/block/cryptoloop.c                   |    2 +
 drivers/gpu/ipu-v3/ipu-cpmem.c               |   30 +++++++--------
 drivers/media/usb/stkwebcam/stk-webcam.c     |    6 ++-
 drivers/net/ethernet/cadence/macb_ptp.c      |   11 +++++
 drivers/net/ethernet/qlogic/qed/qed_main.c   |    7 +++
 drivers/net/ethernet/qlogic/qede/qede_main.c |    2 -
 drivers/net/ethernet/realtek/r8169_main.c    |    1 
 drivers/net/ethernet/xilinx/ll_temac_main.c  |    4 --
 drivers/pci/quirks.c                         |   12 +++---
 drivers/reset/reset-zynqmp.c                 |    3 +
 drivers/usb/host/xhci-debugfs.c              |    6 ++-
 drivers/usb/host/xhci-rcar.c                 |    7 +++
 drivers/usb/host/xhci-trace.h                |    8 ++--
 drivers/usb/host/xhci.h                      |   52 ++++++++++++++-------------
 drivers/usb/mtu3/mtu3_gadget.c               |    6 +--
 drivers/usb/serial/mos7720.c                 |    4 +-
 fs/btrfs/inode.c                             |    2 -
 fs/crypto/hooks.c                            |   44 ++++++++++++++++++++++
 fs/ext4/inline.c                             |    6 +++
 fs/ext4/symlink.c                            |   11 +++++
 fs/f2fs/namei.c                              |   11 +++++
 fs/ubifs/file.c                              |   12 +++++-
 include/linux/fscrypt.h                      |    7 +++
 kernel/kthread.c                             |   43 +++++++++++++++-------
 kernel/sched/fair.c                          |    2 -
 mm/page_alloc.c                              |    8 ++--
 net/ipv4/icmp.c                              |   23 ++++++++++-
 net/ipv4/igmp.c                              |    2 +
 sound/core/pcm_lib.c                         |    2 -
 sound/pci/hda/patch_realtek.c                |   10 +++++
 sound/usb/quirks.c                           |    1 
 48 files changed, 320 insertions(+), 130 deletions(-)

Alexander Tsoy (1):
      ALSA: usb-audio: Add registration quirk for JBL Quantum 800

Ben Dooks (1):
      ARM: 8918/2: only build return_address() if needed

Christoph Hellwig (1):
      cryptoloop: add a deprecation warning

Chunfeng Yun (2):
      usb: mtu3: use @mult for HS isoc or intr
      usb: mtu3: fix the wrong HS mult value

Eric Biggers (4):
      fscrypt: add fscrypt_symlink_getattr() for computing st_size
      ext4: report correct st_size for encrypted symlinks
      f2fs: report correct st_size for encrypted symlinks
      ubifs: report correct st_size for encrypted symlinks

Esben Haabendal (1):
      net: ll_temac: Remove left-over debug message

Fangrui Song (1):
      powerpc/boot: Delete unneeded .globl _zimage_start

Greg Kroah-Hartman (1):
      Linux 5.4.145

Harini Katakam (1):
      net: macb: Add a NULL check on desc_ptp

Hayes Wang (1):
      Revert "r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM"

Kim Phillips (2):
      perf/x86/amd/ibs: Work around erratum #1197
      perf/x86/amd/power: Assign pmu.module

Krzysztof Hałasa (1):
      gpu: ipu-v3: Fix i.MX IPU-v3 offset calculations for (semi)planar U/V formats

Liu Jian (1):
      igmp: Add ip_mc_list lock in ip_check_mc_rcu

Marek Behún (1):
      PCI: Call Max Payload Size-related fixup quirks early

Mathias Nyman (1):
      xhci: fix unsafe memory usage in xhci tracing

Mathieu Desnoyers (1):
      ipv4/icmp: l3mdev: Perform icmp error route lookup on source device routing table (v2)

Muchun Song (1):
      mm/page_alloc: speed up the iteration of max_order

Paul Gortmaker (1):
      x86/reboot: Limit Dell Optiplex 990 quirk to early BIOS versions

Pavel Skripkin (1):
      media: stkwebcam: fix memory leak in stk_camera_probe

Peter Zijlstra (1):
      kthread: Fix PF_KTHREAD vs to_kthread() race

Qu Wenruo (1):
      Revert "btrfs: compression: don't try to compress if we don't have enough pages"

Randy Dunlap (1):
      xtensa: fix kconfig unmet dependency warning for HAVE_FUTEX_CMPXCHG

Sai Krishna Potthuri (1):
      reset: reset-zynqmp: Fixed the argument data type

Shai Malin (2):
      qed: Fix the VF msix vectors flow
      qede: Fix memset corruption

Suravee Suthikulpanit (1):
      x86/events/amd/iommu: Fix invalid Perf result due to IOMMU PMC power-gating

Takashi Iwai (1):
      ALSA: hda/realtek: Workaround for conflicting SSID on ASUS ROG Strix G17

Theodore Ts'o (1):
      ext4: fix race writing to an inline_data file while its xattrs are changing

Tom Rix (1):
      USB: serial: mos7720: improve OOM-handling in read_mos_reg()

Vineet Gupta (1):
      ARC: wireup clone3 syscall

Xiaoyao Li (1):
      perf/x86/intel/pt: Fix mask of num_address_ranges

Yoshihiro Shimoda (1):
      usb: host: xhci-rcar: Don't reload firmware after the completion

Zubin Mithra (1):
      ALSA: pcm: fix divide error in snd_pcm_lib_ioctl

