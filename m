Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87717430751
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 10:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237472AbhJQIuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 04:50:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234660AbhJQIuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Oct 2021 04:50:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6763E60F46;
        Sun, 17 Oct 2021 08:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634460473;
        bh=moqXV7yzzXWeo1xtGnlEs6GIBqGmPK3HeGOEDSYEDFc=;
        h=From:To:Cc:Subject:Date:From;
        b=X7LmWosNl4LOg46NkVyKHyFxv3rvJeWcnjVv9Ghw80rMF7m6DWjnBznxDNQQmaFBe
         xJsPjTXRNSXHtWwHJXUhHD4y83ea07KLK/KSDQqeMhuIU5TjvjTQ+YT6EGhtrJyZsM
         gj8KaxYyEast4wmH2EcMZVtja+7LHwW0d57dDYx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.289
Date:   Sun, 17 Oct 2021 10:47:50 +0200
Message-Id: <1634460470200194@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.289 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 -
 arch/arm/mach-imx/pm-imx6.c                 |    2 +
 arch/x86/kernel/cpu/perf_event.c            |    1 
 arch/xtensa/kernel/irq.c                    |    2 -
 drivers/hid/hid-apple.c                     |    7 ++++
 drivers/net/ethernet/intel/i40e/i40e_main.c |    2 -
 drivers/net/phy/mdio_bus.c                  |    7 ++++
 drivers/ptp/ptp_pch.c                       |    1 
 drivers/scsi/ses.c                          |    2 -
 drivers/scsi/virtio_scsi.c                  |    4 +-
 drivers/usb/class/cdc-acm.c                 |    8 ++++
 fs/nfsd/nfs4xdr.c                           |   19 ++++++-----
 mm/gup.c                                    |   48 +++++++++++++++++++++++-----
 mm/huge_memory.c                            |   10 +----
 mm/memory.c                                 |   12 ++++---
 net/ipv6/netfilter/ip6_tables.c             |    1 
 net/mac80211/rx.c                           |    3 +
 net/netlink/af_netlink.c                    |   14 +++++---
 net/sched/sch_fifo.c                        |    3 +
 19 files changed, 109 insertions(+), 39 deletions(-)

Anand K Mistry (1):
      perf/x86: Reset destroy callback on event init failure

Andy Shevchenko (1):
      ptp_pch: Load module automatically if ID matches

Colin Ian King (1):
      scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"

Eric Dumazet (2):
      net_sched: fix NULL deref in fifo_set_limit()
      netlink: annotate data races around nlk->bound

Greg Kroah-Hartman (1):
      Linux 4.4.289

Jeremy Sowden (1):
      netfilter: ip6_tables: zero-initialize fragment offset

Jiapeng Chong (1):
      scsi: ses: Fix unsigned comparison with less than zero

Jiri Benc (1):
      i40e: fix endless loop under rtnl

Johan Hovold (2):
      USB: cdc-acm: fix racy tty buffer accesses
      USB: cdc-acm: fix break reporting

Linus Torvalds (1):
      gup: document and work around "COW can break either way" issue

Lorenzo Stoakes (1):
      mm: check VMA flags to avoid invalid PROT_NONE NUMA balancing

Max Filippov (1):
      xtensa: call irqchip_init only when CONFIG_USE_OF is selected

Mizuho Mori (1):
      HID: apple: Fix logical maximum and usage maximum of Magic Keyboard JIS

Oleksij Rempel (1):
      ARM: imx6: disable the GIC CPU interface before calling stby-poweroff sequence

Pavel Skripkin (1):
      phy: mdio: fix memory leak

Trond Myklebust (1):
      nfsd4: Handle the NFSv4 READDIR 'dircount' hint being zero

YueHaibing (1):
      mac80211: Drop frames from invalid MAC address in ad-hoc mode

