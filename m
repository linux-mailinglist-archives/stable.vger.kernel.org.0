Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E781A30E6CB
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 00:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbhBCXJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 18:09:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:45904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233582AbhBCXFE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 18:05:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6717A64F6C;
        Wed,  3 Feb 2021 23:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612393460;
        bh=GCyt+/sbIOotrg0Pu3snfsccyx6s+2sCdb+adggFQXg=;
        h=From:To:Cc:Subject:Date:From;
        b=ve+XUQXS8i1MwOvG2qNYqMzWpxiQksycjvFNCU5X2gQtl0wcdzeDjVbJgg3MJTUBw
         ZBe72i+vSPOEXIzed/gYMQkZcoDu6dM2idh1PkZsopP/CKDDxjBjfT6lLeTUONQAdw
         h/uj/UPkWiMfFaqcDUsg/e3ZlwnKYFfGfIBdYXvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.219
Date:   Thu,  4 Feb 2021 00:04:15 +0100
Message-Id: <161239345513961@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.219 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 -
 arch/arm/boot/dts/imx6qdl-gw52xx.dtsi           |    2 -
 arch/arm/mach-imx/suspend-imx6.S                |    1 
 arch/x86/entry/entry_64_compat.S                |    8 ++--
 arch/x86/kvm/pmu_intel.c                        |    2 -
 arch/x86/kvm/x86.c                              |    5 ++
 drivers/acpi/device_sysfs.c                     |   20 +++-------
 drivers/block/nbd.c                             |    8 ++++
 drivers/block/xen-blkfront.c                    |   20 +++-------
 drivers/infiniband/hw/cxgb4/qp.c                |    2 -
 drivers/iommu/dmar.c                            |   45 ++++++++++++++++--------
 drivers/leds/led-triggers.c                     |   10 +++--
 drivers/net/can/dev.c                           |    2 -
 drivers/net/team/team.c                         |    6 +--
 drivers/net/usb/qmi_wwan.c                      |    1 
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |   14 ++++---
 drivers/net/wireless/mediatek/mt7601u/dma.c     |    5 +-
 drivers/soc/atmel/soc.c                         |   13 ++++++
 drivers/xen/xenbus/xenbus_probe.c               |   31 ++++++++++++++++
 include/linux/intel-iommu.h                     |    2 +
 include/net/tcp.h                               |    2 -
 net/ipv4/tcp_input.c                            |   10 +++--
 net/ipv4/tcp_recovery.c                         |    5 +-
 net/mac80211/ieee80211_i.h                      |    1 
 net/mac80211/iface.c                            |    6 +++
 net/netfilter/nft_dynset.c                      |    4 +-
 net/nfc/netlink.c                               |    1 
 net/nfc/rawsock.c                               |    2 -
 net/wireless/wext-core.c                        |    5 +-
 net/xfrm/xfrm_input.c                           |    2 -
 tools/testing/selftests/x86/test_syscall_vdso.c |   35 +++++++++++-------
 31 files changed, 180 insertions(+), 92 deletions(-)

Andrea Righi (1):
      leds: trigger: fix potential deadlock with libata

Andy Lutomirski (2):
      x86/entry/64/compat: Preserve r8-r11 in int $0x80
      x86/entry/64/compat: Fix "x86/entry/64/compat: Preserve r8-r11 in int $0x80"

Bartosz Golaszewski (1):
      iommu/vt-d: Don't dereference iommu_device if IOMMU_API is not built

Claudiu Beznea (1):
      drivers: soc: atmel: add null entry at the end of at91_soc_allowed_list[]

Dan Carpenter (1):
      can: dev: prevent potential information leak in can_fill_info()

David Woodhouse (2):
      xen: Fix XenStore initialisation for XS_LOCAL
      iommu/vt-d: Gracefully handle DMAR units with no supported address widths

Giacinto Cifelli (1):
      net: usb: qmi_wwan: added support for Thales Cinterion PLSx3 modem family

Greg Kroah-Hartman (1):
      Linux 4.14.219

Ivan Vecera (1):
      team: protect features update by RCU to avoid deadlock

Jay Zhou (1):
      KVM: x86: get smi pending status correctly

Johannes Berg (4):
      wext: fix NULL-ptr-dereference with cfg80211's lack of commit()
      iwlwifi: pcie: use jiffies for memory read spin time limit
      iwlwifi: pcie: reschedule in long-running memory reads
      mac80211: pause TX while changing interface type

Josef Bacik (1):
      nbd: freeze the queue while we're adding connections

Kai-Heng Feng (1):
      ACPI: sysfs: Prefer "compatible" modalias

Kamal Heib (1):
      RDMA/cxgb4: Fix the reported max_recv_sge value

Koen Vandeputte (1):
      ARM: dts: imx6qdl-gw52xx: fix duplicate regulator naming

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

Pengcheng Yang (1):
      tcp: fix TLP timer not set when CA_STATE changes from DISORDER to OPEN

Roger Pau Monne (1):
      xen-blkfront: allow discard-* nodes to be optional

Shmulik Ladkani (1):
      xfrm: Fix oops in xfrm_replay_advance_bmp

Sudeep Holla (1):
      drivers: soc: atmel: Avoid calling at91_soc_init on non AT91 SoCs

