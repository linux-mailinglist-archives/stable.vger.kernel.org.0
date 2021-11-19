Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C10F457596
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236756AbhKSRlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:41:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236575AbhKSRlD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:41:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D20C611CC;
        Fri, 19 Nov 2021 17:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343481;
        bh=tGdIerjZ9k5A3CzT+pGJN/c04CBQEwwI8JcHsbITMdg=;
        h=From:To:Cc:Subject:Date:From;
        b=E/KreX7T3nAgQoS8qKVFT4Pn/xBzRXlnBugQ6ilM9NpymK2VFj9p0DCHHJb9p5bGB
         IIzHtvJeW875nF4+LUESiQlUUx9K6uMFQyiqmvnTGuyEjjvtcDoQGispYuFlU4yGNr
         Oq2oJqAGbMcotWTTBHeluOiIBI1E/COhnVDL4Bbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/21] 5.10.81-rc1 review
Date:   Fri, 19 Nov 2021 18:37:35 +0100
Message-Id: <20211119171443.892729043@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.81-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.81-rc1
X-KernelTest-Deadline: 2021-11-21T17:14+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.81 release.
There are 21 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 21 Nov 2021 17:14:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.81-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.81-rc1

Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
    thermal: Fix NULL pointer dereferences in of_thermal_ functions

Greg Thelen <gthelen@google.com>
    perf/core: Avoid put_page() when GUP fails

Nathan Chancellor <nathan@kernel.org>
    scripts/lld-version.sh: Rewrite based on upstream ld-version.sh

Gao Xiang <hsiangkao@linux.alibaba.com>
    erofs: fix unsafe pagevec reuse of hooked pclusters

Yue Hu <huyue2@yulong.com>
    erofs: remove the occupied parameter from z_erofs_pagevec_enqueue()

Marc Zyngier <maz@kernel.org>
    PCI: Add MSI masking quirk for Nvidia ION AHCI

Marc Zyngier <maz@kernel.org>
    PCI/MSI: Deal with devices lying about their MSI mask capability

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Destroy sysfs before freeing entries

Sven Schnelle <svens@stackframe.org>
    parisc/entry: fix trace test in syscall exit path

Peter Zijlstra <peterz@infradead.org>
    x86/iopl: Fake iopl(3) CLI/STI usage

Nick Desaulniers <ndesaulniers@google.com>
    arm64: vdso32: suppress error message for 'make mrproper'

Michael Riesch <michael.riesch@wolfvision.net>
    net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings

Wong Vee Khee <vee.khee.wong@linux.intel.com>
    net: stmmac: fix issue where clk is being unprepared twice

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: stmmac: fix system hang if change mac address after interface ifdown

Yang Yingliang <yangyingliang@huawei.com>
    net: stmmac: fix missing unlock on error in stmmac_suspend()

Wei Yongjun <weiyongjun1@huawei.com>
    net: stmmac: platform: fix build error with !CONFIG_PM_SLEEP

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: stmmac: add clocks management for gmac driver

Masami Hiramatsu <mhiramat@kernel.org>
    bootconfig: init: Fix memblock leak in xbc_make_cmdline()

Xie Yongji <xieyongji@bytedance.com>
    loop: Use blk_validate_block_size() to validate block size

Xie Yongji <xieyongji@bytedance.com>
    block: Add a helper to validate the block size

Kees Cook <keescook@chromium.org>
    fortify: Explicitly disable Clang support


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/kernel/vdso32/Makefile                  |   3 +-
 arch/parisc/kernel/entry.S                         |   2 +-
 arch/x86/include/asm/insn-eval.h                   |   1 +
 arch/x86/include/asm/processor.h                   |   1 +
 arch/x86/kernel/process.c                          |   1 +
 arch/x86/kernel/traps.c                            |  34 +++++++
 arch/x86/lib/insn-eval.c                           |   2 +-
 drivers/block/loop.c                               |  17 +---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |   9 --
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  87 ++++++++++++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  | 111 ++++++++++++++++-----
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  30 ++++--
 drivers/pci/msi.c                                  |  27 ++---
 drivers/pci/quirks.c                               |   6 ++
 drivers/thermal/thermal_of.c                       |   9 +-
 fs/erofs/zdata.c                                   |  15 ++-
 fs/erofs/zpvec.h                                   |  14 ++-
 include/linux/blkdev.h                             |   8 ++
 include/linux/pci.h                                |   2 +
 init/main.c                                        |   1 +
 kernel/events/core.c                               |  10 +-
 scripts/lld-version.sh                             |  35 +++++--
 security/Kconfig                                   |   3 +
 25 files changed, 320 insertions(+), 113 deletions(-)


