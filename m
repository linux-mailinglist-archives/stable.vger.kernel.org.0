Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933293C2444
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhGINWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231787AbhGINVy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:21:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F8C661357;
        Fri,  9 Jul 2021 13:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836750;
        bh=KAXRayC2x2u9eJ8yiuepek022ODdjR8LK9nnj7T6LRY=;
        h=From:To:Cc:Subject:Date:From;
        b=0CAe+BBqa20wNLOUQ4qDsXq0UsHXsDtfY1a1HF1SsJ+IILR30mRetbl8jGZyEqv7f
         xVjDErQFiIiyNFMAc8W//Jy9xmsHIeAJLGRSO1yAi2jDC6wKSb6hzbUXhbLA1z7dZK
         yIyOMJ4nnJ4ku6wNW5OfF4Z8qeJbLo1ycter27I0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.14 00/25] 4.14.239-rc1 review
Date:   Fri,  9 Jul 2021 15:18:31 +0200
Message-Id: <20210709131627.928131764@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.239-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.239-rc1
X-KernelTest-Deadline: 2021-07-11T13:16+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.239 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.239-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.239-rc1

Juergen Gross <jgross@suse.com>
    xen/events: reset active flag for lateeoi events later

Petr Mladek <pmladek@suse.com>
    kthread: prevent deadlock when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync()

Petr Mladek <pmladek@suse.com>
    kthread_worker: split code for canceling the delayed work timer

Sean Young <sean@mess.org>
    kfifo: DECLARE_KIFO_PTR(fifo, u64) does not work on arm 32 bit

Christian König <christian.koenig@amd.com>
    drm/nouveau: fix dma_address check for CPU/GPU sync

ManYi Li <limanyi@uniontech.com>
    scsi: sr: Return appropriate error code when disk is ejected

Hugh Dickins <hughd@google.com>
    mm, futex: fix shared futex pgoff on shmem huge page

Hugh Dickins <hughd@google.com>
    mm/thp: another PVMW_SYNC fix in page_vma_mapped_walk()

Hugh Dickins <hughd@google.com>
    mm/thp: fix page_vma_mapped_walk() if THP mapped by ptes

Hugh Dickins <hughd@google.com>
    mm: page_vma_mapped_walk(): get vma_address_end() earlier

Hugh Dickins <hughd@google.com>
    mm: page_vma_mapped_walk(): use goto instead of while (1)

Hugh Dickins <hughd@google.com>
    mm: page_vma_mapped_walk(): add a level of indentation

Hugh Dickins <hughd@google.com>
    mm: page_vma_mapped_walk(): crossing page table boundary

Hugh Dickins <hughd@google.com>
    mm: page_vma_mapped_walk(): prettify PVMW_MIGRATION block

Hugh Dickins <hughd@google.com>
    mm: page_vma_mapped_walk(): use pmde for *pvmw->pmd

Hugh Dickins <hughd@google.com>
    mm: page_vma_mapped_walk(): settle PageHuge on entry

Hugh Dickins <hughd@google.com>
    mm: page_vma_mapped_walk(): use page for pvmw->page

Yang Shi <shy828301@gmail.com>
    mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split

Jue Wang <juew@google.com>
    mm/thp: fix page_address_in_vma() on file THP tails

Hugh Dickins <hughd@google.com>
    mm/thp: fix vma_address() if virtual address below file offset

Hugh Dickins <hughd@google.com>
    mm/thp: try_to_unmap() use TTU_SYNC for safe splitting

Miaohe Lin <linmiaohe@huawei.com>
    mm/rmap: use page_not_mapped in try_to_unmap()

Miaohe Lin <linmiaohe@huawei.com>
    mm/rmap: remove unneeded semicolon in page_not_mapped()

Alex Shi <alex.shi@linux.alibaba.com>
    mm: add VM_WARN_ON_ONCE_PAGE() macro

Michal Hocko <mhocko@kernel.org>
    include/linux/mmdebug.h: make VM_WARN* non-rvals


-------------

Diffstat:

 Makefile                             |   4 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c |   4 +-
 drivers/scsi/sr.c                    |   2 +
 drivers/xen/events/events_base.c     |  23 ++++-
 include/linux/hugetlb.h              |  16 ----
 include/linux/kfifo.h                |   3 +-
 include/linux/mmdebug.h              |  21 ++++-
 include/linux/pagemap.h              |  13 +--
 include/linux/rmap.h                 |   3 +-
 kernel/futex.c                       |   2 +-
 kernel/kthread.c                     |  77 +++++++++++------
 mm/huge_memory.c                     |  26 ++----
 mm/hugetlb.c                         |   5 +-
 mm/internal.h                        |  53 +++++++++---
 mm/page_vma_mapped.c                 | 160 ++++++++++++++++++++++-------------
 mm/rmap.c                            |  48 ++++++-----
 16 files changed, 281 insertions(+), 179 deletions(-)


