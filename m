Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B69430756
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 10:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245124AbhJQIuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 04:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234660AbhJQIuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Oct 2021 04:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06DBB60F46;
        Sun, 17 Oct 2021 08:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634460481;
        bh=z5glA058WpNBQ4koE0EINV8EAV2EVGOddYDtwc1hfI8=;
        h=From:To:Cc:Subject:Date:From;
        b=h2lUJBKWZxCK7Y43kDFTnLQ8qpPQu0gFrqa2jRS1RXtVxQ6cTsrJaK+XRUgasXlnw
         GU6/0j8TvKMZVINj4qJoRxdopB4O+Eb9Kx7PtISs1hrZIhKBEpxi8HUheuNQuQaajR
         nWVgXEUnClJvYEUV3B2ZaxcYQcuQtWENdTyW6Cy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.287
Date:   Sun, 17 Oct 2021 10:47:55 +0200
Message-Id: <1634460475200218@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.287 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 -
 arch/arm/boot/dts/omap3430-sdp.dts          |    2 -
 arch/arm/mach-imx/pm-imx6.c                 |    2 +
 arch/powerpc/boot/dts/fsl/t1023rdb.dts      |    2 -
 arch/x86/events/core.c                      |    1 
 arch/xtensa/kernel/irq.c                    |    2 -
 drivers/gpu/drm/nouveau/nouveau_debugfs.c   |    1 
 drivers/hid/hid-apple.c                     |    7 ++++
 drivers/net/ethernet/intel/i40e/i40e_main.c |    2 -
 drivers/net/phy/mdio_bus.c                  |    7 ++++
 drivers/ptp/ptp_pch.c                       |    1 
 drivers/scsi/ses.c                          |    2 -
 drivers/scsi/virtio_scsi.c                  |    4 +-
 drivers/usb/Kconfig                         |    3 -
 drivers/usb/class/cdc-acm.c                 |    8 ++++
 fs/nfsd/nfs4xdr.c                           |   19 ++++++-----
 fs/overlayfs/dir.c                          |   10 ++++-
 kernel/bpf/stackmap.c                       |    3 +
 mm/gup.c                                    |   48 +++++++++++++++++++++++-----
 mm/huge_memory.c                            |    7 +---
 net/bridge/br_netlink.c                     |    2 -
 net/core/rtnetlink.c                        |    2 -
 net/ipv6/netfilter/ip6_tables.c             |    1 
 net/mac80211/rx.c                           |    3 +
 net/netlink/af_netlink.c                    |   14 +++++---
 net/sched/sch_fifo.c                        |    3 +
 26 files changed, 117 insertions(+), 41 deletions(-)

Anand K Mistry (1):
      perf/x86: Reset destroy callback on event init failure

Andy Shevchenko (1):
      ptp_pch: Load module automatically if ID matches

Ben Hutchings (1):
      Partially revert "usb: Kconfig: using select for USB_COMMON dependency"

Colin Ian King (1):
      scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"

Eric Dumazet (4):
      net_sched: fix NULL deref in fifo_set_limit()
      net: bridge: use nla_total_size_64bit() in br_get_linkxstats_size()
      netlink: annotate data races around nlk->bound
      rtnetlink: fix if_nlmsg_stats_size() under estimation

Greg Kroah-Hartman (1):
      Linux 4.9.287

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

Max Filippov (1):
      xtensa: call irqchip_init only when CONFIG_USE_OF is selected

Mizuho Mori (1):
      HID: apple: Fix logical maximum and usage maximum of Magic Keyboard JIS

Oleksij Rempel (1):
      ARM: imx6: disable the GIC CPU interface before calling stby-poweroff sequence

Pali Rohár (1):
      powerpc/fsl/dts: Fix phy-connection-type for fm1mac3

Pavel Skripkin (1):
      phy: mdio: fix memory leak

Roger Quadros (1):
      ARM: dts: omap3430-sdp: Fix NAND device node

Tatsuhiko Yasumatsu (1):
      bpf: Fix integer overflow in prealloc_elems_and_freelist()

Trond Myklebust (1):
      nfsd4: Handle the NFSv4 READDIR 'dircount' hint being zero

Yang Yingliang (1):
      drm/nouveau/debugfs: fix file release memory leak

YueHaibing (1):
      mac80211: Drop frames from invalid MAC address in ad-hoc mode

Zheng Liang (1):
      ovl: fix missing negative dentry check in ovl_rename()

