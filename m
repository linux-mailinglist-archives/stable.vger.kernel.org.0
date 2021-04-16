Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7918B3624E0
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 18:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238654AbhDPQAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 12:00:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238569AbhDPQAZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 12:00:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB2AB6124B;
        Fri, 16 Apr 2021 15:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618588800;
        bh=gV6lrhKf2VLJHixda25G/55q2a2wLDIZ+JkMAfw1TCg=;
        h=From:To:Cc:Subject:Date:From;
        b=ZuiId8BVok3kV+B4KYHXpeAvcq76RzSJHFLoYmH1K2KUNdvJKttiBQRz0n3w1x8m9
         o2BAMjT/GpFE2qogWI3uZDsjSfoU8YXhzxkAIe/DGSJZGtw05GXnu1nET4dvAWkoet
         t0AdryNLLL5vdg0MIgBfmMc1gpE7G5CSB5umlUY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.188
Date:   Fri, 16 Apr 2021 17:59:53 +0200
Message-Id: <161858879489157@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.188 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                               |    2 
 arch/arm64/include/asm/kvm_arm.h       |    1 
 arch/arm64/kernel/cpufeature.c         |    1 
 arch/arm64/kvm/debug.c                 |    2 
 arch/riscv/kernel/entry.S              |    1 
 block/bio.c                            |    2 
 drivers/base/dd.c                      |    8 
 drivers/gpu/drm/imx/imx-ldb.c          |   10 
 drivers/gpu/drm/tegra/dc.c             |   10 
 drivers/net/phy/bcm-phy-lib.c          |   11 
 drivers/staging/Kconfig                |    2 
 drivers/staging/Makefile               |    1 
 drivers/staging/mt7621-mmc/Kconfig     |   16 
 drivers/staging/mt7621-mmc/Makefile    |   42 
 drivers/staging/mt7621-mmc/TODO        |    8 
 drivers/staging/mt7621-mmc/board.h     |   63 
 drivers/staging/mt7621-mmc/dbg.c       |  307 ----
 drivers/staging/mt7621-mmc/dbg.h       |  149 --
 drivers/staging/mt7621-mmc/mt6575_sd.h |  488 ------
 drivers/staging/mt7621-mmc/sd.c        | 2392 ---------------------------------
 drivers/xen/events/events_base.c       |    4 
 fs/gfs2/super.c                        |   10 
 net/ipv4/netfilter/arp_tables.c        |    2 
 net/ipv4/netfilter/ip_tables.c         |    2 
 net/ipv6/netfilter/ip6_tables.c        |    2 
 net/netfilter/x_tables.c               |   10 
 tools/perf/util/map.c                  |    7 
 27 files changed, 53 insertions(+), 3500 deletions(-)

Arnaldo Carvalho de Melo (1):
      perf map: Tighten snprintf() string precision to pass gcc check on some 32-bit arches

Arnd Bergmann (1):
      drm/imx: imx-ldb: fix out of bounds array access warning

Bob Peterson (1):
      gfs2: report "already frozen/thawed" errors

Dmitry Osipenko (1):
      drm/tegra: dc: Don't set PLL clock to 0Hz

Florian Fainelli (1):
      net: phy: broadcom: Only advertise EEE for supported modes

Florian Westphal (1):
      netfilter: x_tables: fix compat match/target pad out-of-bound write

Greg Kroah-Hartman (2):
      staging: m57621-mmc: delete driver from the tree.
      Linux 4.19.188

Juergen Gross (1):
      xen/events: fix setting irq affinity

Saravana Kannan (1):
      driver core: Fix locking bug in deferred_probe_timeout_work_func()

Suzuki K Poulose (2):
      KVM: arm64: Hide system instruction access to Trace registers
      KVM: arm64: Disable guest access to trace filter controls

Yufen Yu (1):
      block: only update parent bi_status when bio fail

Zihao Yu (1):
      riscv,entry: fix misaligned base for excp_vect_table

