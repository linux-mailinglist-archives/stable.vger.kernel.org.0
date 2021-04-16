Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD163624F3
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 18:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239524AbhDPQBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 12:01:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238843AbhDPQAx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 12:00:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2685E611ED;
        Fri, 16 Apr 2021 16:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618588828;
        bh=XUVY9iMKNtLFzjRmu27Zw7baDrqdvixZNC0KMQU7+Ag=;
        h=From:To:Cc:Subject:Date:From;
        b=HS7Khk13JocVX7FDPx3nB0L7d6YxrrhJ8eRrbSNWqdXGZ+f6ErPSWmfCZ2jbzlXAj
         sFpZnCb+XBcA90F1hZzAWgk3v0b1mqA2nuCoCgxFYcR6kdEjsYTh8WC0eIvBhWTrHE
         mrFT0G/57NrjC6BXeOCJIrCNbHq7tpLUroSFz2cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.31
Date:   Fri, 16 Apr 2021 18:00:19 +0200
Message-Id: <1618588820170148@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.31 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 -
 arch/arm64/include/asm/kvm_arm.h      |    1 
 arch/arm64/kernel/cpufeature.c        |    1 
 arch/arm64/kvm/debug.c                |    2 +
 arch/riscv/kernel/entry.S             |    1 
 block/bio.c                           |    2 -
 drivers/block/null_blk.h              |    1 
 drivers/block/null_blk_main.c         |   26 +++++++++++++++++++-----
 drivers/gpu/drm/imx/imx-ldb.c         |   10 +++++++++
 drivers/gpu/drm/tegra/dc.c            |   10 ++++-----
 drivers/gpu/host1x/bus.c              |   10 +++++----
 drivers/interconnect/core.c           |    2 +
 drivers/net/phy/sfp-bus.c             |   11 ++++------
 drivers/net/phy/sfp.c                 |   36 ++++++++++++++++++++--------------
 drivers/xen/events/events_base.c      |    4 +--
 fs/block_dev.c                        |    4 +++
 fs/gfs2/super.c                       |   14 ++++++++-----
 fs/io_uring.c                         |    2 -
 include/linux/host1x.h                |    9 +++++++-
 kernel/trace/ftrace.c                 |    9 +++++---
 lib/test_xarray.c                     |   26 +++++++++++++-----------
 lib/xarray.c                          |    4 +--
 net/ipv4/netfilter/arp_tables.c       |    2 +
 net/ipv4/netfilter/ip_tables.c        |    2 +
 net/ipv6/netfilter/ip6_tables.c       |    2 +
 net/netfilter/x_tables.c              |   10 +--------
 tools/kvm/kvm_stat/kvm_stat.service   |    1 
 tools/perf/util/map.c                 |    7 ++----
 tools/testing/radix-tree/idr-test.c   |   10 +++++++--
 tools/testing/radix-tree/multiorder.c |    2 +
 tools/testing/radix-tree/xarray.c     |    2 +
 31 files changed, 148 insertions(+), 77 deletions(-)

Andrew Price (1):
      gfs2: Flag a withdraw if init_threads() fails

Arnaldo Carvalho de Melo (1):
      perf map: Tighten snprintf() string precision to pass gcc check on some 32-bit arches

Arnd Bergmann (1):
      drm/imx: imx-ldb: fix out of bounds array access warning

Bob Peterson (1):
      gfs2: report "already frozen/thawed" errors

Damien Le Moal (1):
      null_blk: fix command timeout completion handling

Dmitry Osipenko (1):
      drm/tegra: dc: Don't set PLL clock to 0Hz

Florian Westphal (1):
      netfilter: x_tables: fix compat match/target pad out-of-bound write

Greg Kroah-Hartman (1):
      Linux 5.10.31

Jens Axboe (1):
      io_uring: don't mark S_ISBLK async work as unbounded

Jia-Ju Bai (1):
      interconnect: core: fix error return code of icc_link_destroy()

Juergen Gross (1):
      xen/events: fix setting irq affinity

Matthew Wilcox (Oracle) (4):
      XArray: Fix splitting to non-zero orders
      radix tree test suite: Register the main thread with the RCU library
      idr test suite: Take RCU read lock in idr_find_test_1
      idr test suite: Create anchor before launching throbber

Mikko Perttunen (1):
      gpu: host1x: Use different lock classes for each client

Pavel Begunkov (1):
      block: don't ignore REQ_NOWAIT for direct IO

Russell King (2):
      net: sfp: relax bitrate-derived mode check
      net: sfp: cope with SFPs that set both LOS normal and LOS inverted

Stefan Raspl (1):
      tools/kvm_stat: Add restart delay

Steven Rostedt (VMware) (1):
      ftrace: Check if pages were allocated before calling free_pages()

Suzuki K Poulose (2):
      KVM: arm64: Hide system instruction access to Trace registers
      KVM: arm64: Disable guest access to trace filter controls

Yufen Yu (1):
      block: only update parent bi_status when bio fail

Zihao Yu (1):
      riscv,entry: fix misaligned base for excp_vect_table

