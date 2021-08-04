Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903603E00FB
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 14:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237411AbhHDMTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 08:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237182AbhHDMTE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Aug 2021 08:19:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 984EB60F13;
        Wed,  4 Aug 2021 12:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628079532;
        bh=694MVrfGAt9MBEwLpWI4RMzQQWwVXM2CzvE19kS5phI=;
        h=From:To:Cc:Subject:Date:From;
        b=Ao/sIj+m5l5/t8HQaaaGC2S0We1+KHVzAd0zsuo4GNonL1+/UplWSN+mMMtM1/kVN
         spi6j+8FHNTUhdoJKl6d36HvS0zuv9a8hNZLdCK4uWEzULYijyoPDtk9zsnz2lShd6
         OcnKDQae5ThTb34lTWaDLsPrrViwAL2tfSjVCMz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.278
Date:   Wed,  4 Aug 2021 14:18:38 +0200
Message-Id: <162807951823177@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.278 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                     |    2 
 arch/arm/boot/dts/versatile-ab.dts           |    5 
 arch/arm/boot/dts/versatile-pb.dts           |    2 
 arch/arm/kernel/signal.c                     |   14 +-
 arch/x86/include/asm/proto.h                 |    2 
 drivers/net/can/usb/ems_usb.c                |   14 ++
 drivers/net/can/usb/esd_usb2.c               |   16 ++
 drivers/net/can/usb/usb_8dev.c               |   15 ++
 drivers/net/ethernet/dec/tulip/winbond-840.c |    7 -
 drivers/net/ethernet/mellanox/mlx4/main.c    |    1 
 drivers/net/ethernet/sis/sis900.c            |    7 -
 drivers/net/ethernet/sun/niu.c               |    3 
 fs/hfs/bfind.c                               |   14 ++
 fs/hfs/bnode.c                               |   25 +++-
 fs/hfs/btree.h                               |    7 +
 fs/hfs/super.c                               |   10 -
 fs/ocfs2/file.c                              |  103 ++++++++++-------
 include/linux/string.h                       |   30 +++++
 include/net/af_unix.h                        |    1 
 include/net/llc_pdu.h                        |   31 +++--
 include/net/sctp/constants.h                 |    4 
 kernel/workqueue.c                           |   20 ++-
 lib/string.c                                 |   66 +++++++++++
 net/802/garp.c                               |   14 ++
 net/802/mrp.c                                |   14 ++
 net/Makefile                                 |    2 
 net/llc/af_llc.c                             |   10 +
 net/llc/llc_s_ac.c                           |    2 
 net/netfilter/nft_nat.c                      |    4 
 net/sctp/protocol.c                          |    3 
 net/tipc/socket.c                            |    9 -
 net/unix/Kconfig                             |    5 
 net/unix/Makefile                            |    2 
 net/unix/af_unix.c                           |  115 +++++++------------
 net/unix/garbage.c                           |   68 -----------
 net/unix/scm.c                               |  161 +++++++++++++++++++++++++++
 net/unix/scm.h                               |   10 +
 net/wireless/scan.c                          |    6 -
 38 files changed, 578 insertions(+), 246 deletions(-)

Desmond Cheong Zhi Xi (3):
      hfs: add missing clean-up in hfs_fill_super
      hfs: fix high memory mapping in hfs_bnode_read
      hfs: add lock nesting notation to hfs_find_init

Greg Kroah-Hartman (1):
      Linux 4.4.278

Hoang Le (1):
      tipc: fix sleeping in tipc accept routine

Jan Kiszka (1):
      x86/asm: Ensure asm/proto.h can be included stand-alone

Jens Axboe (1):
      net: split out functions related to registering inflight socket files

Jiapeng Chong (1):
      mlx4: Fix missing error code in mlx4_load_one()

Junxiao Bi (2):
      ocfs2: fix zero out valid data
      ocfs2: issue zeroout to EOF blocks

Matthew Wilcox (1):
      lib/string.c: add multibyte memset functions

Miklos Szeredi (1):
      af_unix: fix garbage collect vs MSG_PEEK

Nguyen Dinh Phi (1):
      cfg80211: Fix possible memory leak in function cfg80211_bss_update

Pablo Neira Ayuso (1):
      netfilter: nft_nat: allow to specify layer 4 protocol NAT only

Paul Jakma (1):
      NIU: fix incorrect error return, missed in previous revert

Pavel Skripkin (4):
      can: usb_8dev: fix memory leak
      can: ems_usb: fix memory leak
      can: esd_usb2: fix memory leak
      net: llc: fix skb_over_panic

Russell King (1):
      ARM: ensure the signal page contains defined contents

Sudeep Holla (1):
      ARM: dts: versatile: Fix up interrupt controller node names

Wang Hai (2):
      tulip: windbond-840: Fix missing pci_disable_device() in probe and remove
      sis900: Fix missing pci_disable_device() in probe and remove

Xin Long (1):
      sctp: move 198 addresses from unusable to private scope

Yang Yingliang (3):
      workqueue: fix UAF in pwq_unbound_release_workfn()
      net/802/mrp: fix memleak in mrp_request_join()
      net/802/garp: fix memleak in garp_request_join()

