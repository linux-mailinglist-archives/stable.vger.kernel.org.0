Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F89D445523
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhKDOUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232406AbhKDOTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:19:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7455D610FD;
        Thu,  4 Nov 2021 14:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035390;
        bh=6D9D3dRea/u/2kUOUoKrqyPXS7NBu46FITY6xPfRjVo=;
        h=From:To:Cc:Subject:Date:From;
        b=Tv/ttbp0Fma0MALopdyg3SGXfUd4qTNAk6GxsrkxFHZHj8r2b4gZt75itBwAqPify
         E7HQ3mfNfBYvYtmRwPXXbVFQZfV28j3aq++zzXr8hG2kWuWLwI9EfiNyCyCSn8otBB
         4yU/Wep1HbzGSoD3S61p4bfjRYWI3pq8IdahTZsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 0/7] 4.19.216-rc1 review
Date:   Thu,  4 Nov 2021 15:13:03 +0100
Message-Id: <20211104141158.037189396@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.216-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.216-rc1
X-KernelTest-Deadline: 2021-11-06T14:11+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.216 release.
There are 7 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.216-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.216-rc1

Wang Kefeng <wangkefeng.wang@huawei.com>
    ARM: 9120/1: Revert "amba: make use of -1 IRQs warn"

Arnd Bergmann <arnd@arndb.de>
    arch: pgtable: define MAX_POSSIBLE_PHYSMEM_BITS where needed

Erik Ekman <erik@kryo.se>
    sfc: Fix reading non-legacy supported link modes

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields

Gustavo A. R. Silva <gustavo@embeddedor.com>
    IB/qib: Use struct_size() helper

Dan Carpenter <dan.carpenter@oracle.com>
    media: firewire: firedtv-avc: fix a buffer overflow in avc_ca_pmt()

Ming Lei <ming.lei@redhat.com>
    scsi: core: Put LLD module refcnt after SCSI device is released


-------------

Diffstat:

 Makefile                                  |  4 ++--
 arch/arc/include/asm/pgtable.h            |  2 ++
 arch/arm/include/asm/pgtable-2level.h     |  2 ++
 arch/arm/include/asm/pgtable-3level.h     |  2 ++
 arch/mips/include/asm/pgtable-32.h        |  3 +++
 arch/powerpc/include/asm/pte-common.h     |  2 ++
 arch/riscv/include/asm/pgtable-32.h       |  2 ++
 drivers/amba/bus.c                        |  3 ---
 drivers/infiniband/hw/qib/qib_user_sdma.c | 34 ++++++++++++++++++++++---------
 drivers/media/firewire/firedtv-avc.c      | 14 ++++++++++---
 drivers/media/firewire/firedtv-ci.c       |  2 ++
 drivers/net/ethernet/sfc/ethtool.c        | 10 ++-------
 drivers/scsi/scsi.c                       |  4 +++-
 drivers/scsi/scsi_sysfs.c                 |  9 ++++++++
 include/asm-generic/pgtable.h             | 13 ++++++++++++
 15 files changed, 79 insertions(+), 27 deletions(-)


