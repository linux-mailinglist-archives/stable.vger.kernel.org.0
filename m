Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4FB4583BA
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 14:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238019AbhKUNOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 08:14:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:50888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231147AbhKUNOu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Nov 2021 08:14:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5C1F60232;
        Sun, 21 Nov 2021 13:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637500305;
        bh=lcaydPUBZSryXYNPYsq8qKxI/wnVOjnlB5jLLMxVZ/s=;
        h=From:To:Cc:Subject:Date:From;
        b=IjZULcu9ECRhIyG4pgx2VUs9PDJT5gZTJcQvNWL+GT/BgbCVZmotOvIvySDRH5y/f
         2hFSPqlc82C70aWz7l7UGG3W+/BKfN63SeX8lqMpQF5R988lr9EUewo7b/PG3uky1H
         nEaESX/zrbbdydvRIB2S6ksiwPykNGjMeDDOibn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.81
Date:   Sun, 21 Nov 2021 14:11:41 +0100
Message-Id: <1637500301510@kroah.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.81 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/parisc/kernel/entry.S                            |    2 
 arch/x86/include/asm/insn-eval.h                      |    1 
 arch/x86/include/asm/processor.h                      |    1 
 arch/x86/kernel/process.c                             |    1 
 arch/x86/kernel/traps.c                               |   34 +++++
 arch/x86/lib/insn-eval.c                              |    2 
 drivers/block/loop.c                                  |   17 --
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c        |    9 -
 drivers/net/ethernet/stmicro/stmmac/stmmac.h          |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     |   87 ++++++++++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c     |  111 +++++++++++++-----
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c |   30 +++-
 drivers/pci/msi.c                                     |   27 ++--
 drivers/pci/quirks.c                                  |    6 
 drivers/thermal/thermal_of.c                          |    9 -
 fs/erofs/zdata.c                                      |   15 +-
 fs/erofs/zpvec.h                                      |   14 +-
 include/linux/blkdev.h                                |    8 +
 include/linux/pci.h                                   |    2 
 init/main.c                                           |    1 
 kernel/events/core.c                                  |   10 -
 scripts/lld-version.sh                                |   35 ++++-
 security/Kconfig                                      |    3 
 tools/testing/selftests/x86/iopl.c                    |   78 +++++++++---
 25 files changed, 375 insertions(+), 131 deletions(-)

Borislav Petkov (1):
      selftests/x86/iopl: Adjust to the faked iopl CLI/STI usage

Gao Xiang (1):
      erofs: fix unsafe pagevec reuse of hooked pclusters

Greg Kroah-Hartman (1):
      Linux 5.10.81

Greg Thelen (1):
      perf/core: Avoid put_page() when GUP fails

Joakim Zhang (2):
      net: stmmac: add clocks management for gmac driver
      net: stmmac: fix system hang if change mac address after interface ifdown

Kees Cook (1):
      fortify: Explicitly disable Clang support

Marc Zyngier (2):
      PCI/MSI: Deal with devices lying about their MSI mask capability
      PCI: Add MSI masking quirk for Nvidia ION AHCI

Masami Hiramatsu (1):
      bootconfig: init: Fix memblock leak in xbc_make_cmdline()

Michael Riesch (1):
      net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings

Nathan Chancellor (1):
      scripts/lld-version.sh: Rewrite based on upstream ld-version.sh

Peter Zijlstra (1):
      x86/iopl: Fake iopl(3) CLI/STI usage

Subbaraman Narayanamurthy (1):
      thermal: Fix NULL pointer dereferences in of_thermal_ functions

Sven Schnelle (1):
      parisc/entry: fix trace test in syscall exit path

Thomas Gleixner (1):
      PCI/MSI: Destroy sysfs before freeing entries

Wei Yongjun (1):
      net: stmmac: platform: fix build error with !CONFIG_PM_SLEEP

Wong Vee Khee (1):
      net: stmmac: fix issue where clk is being unprepared twice

Xie Yongji (2):
      block: Add a helper to validate the block size
      loop: Use blk_validate_block_size() to validate block size

Yang Yingliang (1):
      net: stmmac: fix missing unlock on error in stmmac_suspend()

Yue Hu (1):
      erofs: remove the occupied parameter from z_erofs_pagevec_enqueue()

