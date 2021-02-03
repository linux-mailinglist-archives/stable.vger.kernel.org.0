Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123F730E6AA
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 00:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbhBCXFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 18:05:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233348AbhBCXFE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 18:05:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F13664F6B;
        Wed,  3 Feb 2021 23:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612393455;
        bh=vWg/BerFM9haS2zG+5D4RICg/MrCGNiuoZXhuxZTV40=;
        h=From:To:Cc:Subject:Date:From;
        b=xdC3YUjbbLPGaWI+yPkdPD6Hwz8ydvpfioYFzOVsNanRqy4kmLMZu4pbv4UxxpaS3
         xZs/qNeQab3+6CH1F8ZN/+lzsp7nv2Ph4bDj4YpnzIA5qyBwDBs5zjUd0Gk80kD+um
         uV9u/YgedWIzNGlHvGLf2YcrEZcGRtLgh3NieBa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.255
Date:   Thu,  4 Feb 2021 00:04:10 +0100
Message-Id: <1612393450245231@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.255 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 
 arch/arm/mach-imx/suspend-imx6.S                |    1 
 arch/x86/kvm/pmu_intel.c                        |    2 
 arch/x86/kvm/x86.c                              |    5 
 drivers/acpi/device_sysfs.c                     |   20 -
 drivers/infiniband/hw/cxgb4/qp.c                |    2 
 drivers/iommu/dmar.c                            |   41 +-
 drivers/leds/led-triggers.c                     |   10 
 drivers/net/can/dev.c                           |    2 
 drivers/net/usb/qmi_wwan.c                      |    1 
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |   14 
 drivers/net/wireless/mediatek/mt7601u/dma.c     |    5 
 fs/exec.c                                       |    2 
 include/linux/compat.h                          |    2 
 include/linux/futex.h                           |   44 +-
 include/linux/intel-iommu.h                     |    2 
 include/linux/sched.h                           |    9 
 kernel/Makefile                                 |    3 
 kernel/exit.c                                   |   29 -
 kernel/fork.c                                   |   40 --
 kernel/futex.c                                  |  446 ++++++++++++++++++++++--
 kernel/futex_compat.c                           |  201 ----------
 net/mac80211/ieee80211_i.h                      |    1 
 net/mac80211/iface.c                            |    6 
 net/netfilter/nft_dynset.c                      |    4 
 net/nfc/netlink.c                               |    1 
 net/nfc/rawsock.c                               |    2 
 net/wireless/wext-core.c                        |    5 
 net/xfrm/xfrm_input.c                           |    2 
 29 files changed, 544 insertions(+), 360 deletions(-)

Andrea Righi (1):
      leds: trigger: fix potential deadlock with libata

Arnd Bergmann (1):
      y2038: futex: Move compat implementation into futex.c

Bartosz Golaszewski (1):
      iommu/vt-d: Don't dereference iommu_device if IOMMU_API is not built

Dan Carpenter (1):
      can: dev: prevent potential information leak in can_fill_info()

David Woodhouse (1):
      iommu/vt-d: Gracefully handle DMAR units with no supported address widths

Giacinto Cifelli (1):
      net: usb: qmi_wwan: added support for Thales Cinterion PLSx3 modem family

Greg Kroah-Hartman (1):
      Linux 4.9.255

Jay Zhou (1):
      KVM: x86: get smi pending status correctly

Johannes Berg (4):
      wext: fix NULL-ptr-dereference with cfg80211's lack of commit()
      iwlwifi: pcie: use jiffies for memory read spin time limit
      iwlwifi: pcie: reschedule in long-running memory reads
      mac80211: pause TX while changing interface type

Kai-Heng Feng (1):
      ACPI: sysfs: Prefer "compatible" modalias

Kamal Heib (1):
      RDMA/cxgb4: Fix the reported max_recv_sge value

Like Xu (1):
      KVM: x86/pmu: Fix HW_REF_CPU_CYCLES event pseudo-encoding in intel_arch_events[]

Lorenzo Bianconi (2):
      mt7601u: fix kernel crash unplugging the device
      mt7601u: fix rx buffer refcounting

Max Krummenacher (1):
      ARM: imx: build suspend-imx6.S with arm instruction set

Pablo Neira Ayuso (1):
      netfilter: nft_dynset: add timeout extension to template

Pan Bian (2):
      NFC: fix resource leak when target index is invalid
      NFC: fix possible resource leak

Shmulik Ladkani (1):
      xfrm: Fix oops in xfrm_replay_advance_bmp

Thomas Gleixner (11):
      futex: Move futex exit handling into futex code
      futex: Replace PF_EXITPIDONE with a state
      exit/exec: Seperate mm_release()
      futex: Split futex_mm_release() for exit/exec
      futex: Set task::futex_state to DEAD right after handling futex exit
      futex: Mark the begin of futex exit explicitly
      futex: Sanitize exit state handling
      futex: Provide state handling for exec() as well
      futex: Add mutex around futex exit
      futex: Provide distinct return value when owner is exiting
      futex: Prevent exit livelock

