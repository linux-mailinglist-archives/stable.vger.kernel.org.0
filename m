Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89553407D99
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 15:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbhILN1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 09:27:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235624AbhILN1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Sep 2021 09:27:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 271C761056;
        Sun, 12 Sep 2021 13:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631453185;
        bh=/6ZMm4i07nrdw3xo5GmPNPt1a2wcV5EoBsHpPCROIbk=;
        h=From:To:Cc:Subject:Date:From;
        b=2GU35R3kcEk4JS7MpqRytRrbZUuebWu1bgxRXadls/+gSAVbllXdeOG6OMY5URvFL
         KVJxMjC3bolONNj5hgqhhCGHsqIFcIKUwQ+G9699bBl+0/epHMAcMwM5c0uLnyf9d6
         AMaL0HEfGSZKnMO+AeDjYjI6WBilXWvqop+UNVLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.64
Date:   Sun, 12 Sep 2021 15:26:19 +0200
Message-Id: <163145317911619@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.64 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 arch/x86/events/amd/iommu.c                 |   47 ++++++++------
 arch/x86/kernel/reboot.c                    |    3 
 block/blk-core.c                            |    1 
 block/blk-flush.c                           |   13 ++++
 block/blk-mq.c                              |   37 +++++++++++
 block/blk.h                                 |    6 -
 drivers/net/ethernet/realtek/r8169_main.c   |    1 
 drivers/net/ethernet/xilinx/ll_temac_main.c |    4 -
 drivers/pci/quirks.c                        |   12 +--
 drivers/tty/serial/8250/8250_omap.c         |   26 ++++----
 drivers/usb/gadget/udc/tegra-xudc.c         |    4 -
 drivers/usb/host/xhci-debugfs.c             |   14 +++-
 drivers/usb/host/xhci-rcar.c                |    7 ++
 drivers/usb/host/xhci-ring.c                |    3 
 drivers/usb/host/xhci-trace.h               |   26 ++++----
 drivers/usb/host/xhci.h                     |   73 +++++++++++-----------
 drivers/usb/mtu3/mtu3_core.c                |    4 -
 drivers/usb/mtu3/mtu3_gadget.c              |    6 -
 drivers/usb/serial/mos7720.c                |    4 -
 include/linux/skbuff.h                      |    4 -
 include/uapi/linux/termios.h                |   15 ----
 lib/Kconfig.debug                           |    2 
 mm/page_alloc.c                             |    8 +-
 net/ipv4/igmp.c                             |    2 
 net/netfilter/nf_tables_api.c               |   89 +++++++++++++++++-----------
 net/netfilter/nft_set_hash.c                |   10 +--
 sound/usb/quirks.c                          |    1 
 28 files changed, 251 insertions(+), 173 deletions(-)

Alexander Tsoy (1):
      ALSA: usb-audio: Add registration quirk for JBL Quantum 800

Chunfeng Yun (4):
      usb: gadget: tegra-xudc: fix the wrong mult value for HS isoc or intr
      usb: mtu3: restore HS function when set SS/SSP
      usb: mtu3: use @mult for HS isoc or intr
      usb: mtu3: fix the wrong HS mult value

Eric Dumazet (1):
      netfilter: nftables: avoid potential overflows on 32bit arches

Esben Haabendal (1):
      net: ll_temac: Remove left-over debug message

Greg Kroah-Hartman (1):
      Linux 5.10.64

Hayes Wang (1):
      Revert "r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM"

Jiri Slaby (1):
      tty: drop termiox user definitions

Liu Jian (1):
      igmp: Add ip_mc_list lock in ip_check_mc_rcu

Marek Behún (1):
      PCI: Call Max Payload Size-related fixup quirks early

Mathias Nyman (2):
      xhci: fix even more unsafe memory usage in xhci tracing
      xhci: fix unsafe memory usage in xhci tracing

Ming Lei (3):
      blk-mq: fix kernel panic during iterating over flush request
      blk-mq: fix is_flush_rq
      blk-mq: clearing flush request reference in tags->rqs[]

Muchun Song (1):
      mm/page_alloc: speed up the iteration of max_order

Pablo Neira Ayuso (2):
      netfilter: nf_tables: initialize set before expression setup
      netfilter: nftables: clone set element expression template

Paul Gortmaker (1):
      x86/reboot: Limit Dell Optiplex 990 quirk to early BIOS versions

Randy Dunlap (2):
      net: kcov: don't select SKB_EXTENSIONS when there is no NET
      net: linux/skbuff.h: combine SKB_EXTENSIONS + KCOV handling

Suravee Suthikulpanit (1):
      x86/events/amd/iommu: Fix invalid Perf result due to IOMMU PMC power-gating

Tom Rix (1):
      USB: serial: mos7720: improve OOM-handling in read_mos_reg()

Vignesh Raghavendra (1):
      serial: 8250: 8250_omap: Fix unused variable warning

Yoshihiro Shimoda (1):
      usb: host: xhci-rcar: Don't reload firmware after the completion

