Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3964C891EA
	for <lists+stable@lfdr.de>; Sun, 11 Aug 2019 15:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfHKN5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 09:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbfHKN5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Aug 2019 09:57:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10733216F4;
        Sun, 11 Aug 2019 13:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565531838;
        bh=EKhbEXkuN2ZDGDQDDOeHR5yEUXMTrmt9kFJSq7Yr/c4=;
        h=Date:From:To:Cc:Subject:From;
        b=dEUo6gFgpCW5qwrNSy2i1ariezzngOi0dDqvHVhIVtJrCVwJxq/CIBGmjtJcHp2Xx
         5yrCFXFR+82q+CEoh5qkOguBCGR6f9gw4bM9Ztgl3+ns31ULYsv0W6UmFqS32TcQhA
         3x08Ig6vyu3TQvysg6OTIULIrt61XP90fxTD41YM=
Date:   Sun, 11 Aug 2019 15:57:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.189
Message-ID: <20190811135716.GA23065@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.189 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt             |    7 -
 Makefile                                        |    2 
 arch/arm64/include/asm/cpufeature.h             |    7 -
 arch/arm64/kernel/cpufeature.c                  |   14 ++-
 arch/x86/entry/calling.h                        |   19 ++++
 arch/x86/entry/entry_64.S                       |   25 ++++-
 arch/x86/include/asm/cpufeatures.h              |   10 +-
 arch/x86/kernel/cpu/bugs.c                      |  105 +++++++++++++++++++++---
 arch/x86/kernel/cpu/common.c                    |   42 ++++++---
 block/blk-core.c                                |    1 
 drivers/atm/iphase.c                            |    8 +
 drivers/hid/hid-ids.h                           |    1 
 drivers/hid/usbhid/hid-quirks.c                 |    1 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    2 
 drivers/net/ethernet/mellanox/mlx5/core/main.c  |    2 
 drivers/net/ppp/pppoe.c                         |    3 
 drivers/net/ppp/pppox.c                         |   13 ++
 drivers/net/ppp/pptp.c                          |    3 
 drivers/spi/spi-bcm2835.c                       |    3 
 fs/compat_ioctl.c                               |    3 
 include/linux/if_pppox.h                        |    3 
 include/net/tcp.h                               |   17 +++
 net/bridge/br_vlan.c                            |    5 +
 net/core/dev.c                                  |    2 
 net/ipv4/tcp_output.c                           |   11 ++
 net/l2tp/l2tp_ppp.c                             |    3 
 net/netfilter/nfnetlink_acct.c                  |    2 
 net/sched/sch_codel.c                           |    3 
 net/tipc/netlink_compat.c                       |   11 +-
 29 files changed, 271 insertions(+), 57 deletions(-)

Arnd Bergmann (1):
      compat_ioctl: pppoe: fix PPPOEIOCSFWD handling

Ben Hutchings (1):
      x86: cpufeatures: Sort feature word 7

Eric Dumazet (1):
      tcp: be more careful in tcp_fragment()

Greg Kroah-Hartman (1):
      Linux 4.4.189

Gustavo A. R. Silva (1):
      atm: iphase: Fix Spectre v1 vulnerability

Jia-Ju Bai (1):
      net: sched: Fix a possible null-pointer dereference in dequeue_func()

Jiri Pirko (1):
      net: fix ifindex collision during namespace removal

Josh Poimboeuf (3):
      x86/speculation: Prepare entry code for Spectre v1 swapgs mitigations
      x86/speculation: Enable Spectre v1 swapgs mitigations
      x86/entry/64: Use JMP instead of JMPQ

Lukas Wunner (1):
      spi: bcm2835: Fix 3-wire mode if DMA is enabled

Mark Zhang (1):
      net/mlx5: Use reversed order when unregister devices

Nikolay Aleksandrov (1):
      net: bridge: delete local fdb on device init failure

Phil Turnbull (1):
      netfilter: nfnetlink_acct: validate NFACCT_QUOTA parameter

Sebastian Parschauer (1):
      HID: Add quirk for HP X1200 PIXART OEM mouse

Sudarsana Reddy Kalluru (1):
      bnx2x: Disable multi-cos feature.

Taras Kondratiuk (1):
      tipc: compat: allow tipc commands without arguments

Thomas Gleixner (1):
      x86/speculation/swapgs: Exclude ATOMs from speculation through SWAPGS

Wanpeng Li (1):
      x86/entry/64: Fix context tracking state warning when load_gs_index fails

Will Deacon (2):
      arm64: cpufeature: Fix CTR_EL0 field definitions
      arm64: cpufeature: Fix feature comparison for CTR_EL0.{CWG,ERG}

xiao jin (1):
      block: blk_init_allocated_queue() set q->fq as NULL in the fail case

