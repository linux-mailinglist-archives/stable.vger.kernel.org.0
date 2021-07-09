Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315053C242A
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhGINVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231623AbhGINVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:21:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76BDB61377;
        Fri,  9 Jul 2021 13:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836718;
        bh=C4Q81nmVs3j9ma5tCYfNtT6ohH6asiT6PrgqvgQYX4U=;
        h=From:To:Cc:Subject:Date:From;
        b=htm317IPMvjaEnOlutzFi2q7yJQjWqbMNHa5pAsyrrcSRPCtssO0fuqPTaUpoZ1dc
         WdUWmiFoLD7CT1ffZ+h8WVY/EGkJUW2s9EBrdzX36vJkTf2Tu5mrD5T2xohxia0w0Z
         DoRqi2YtRTmvsk1nDmmiDh3lfuBxrlZqUakxP3Eo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 0/9] 4.9.275-rc1 review
Date:   Fri,  9 Jul 2021 15:18:27 +0200
Message-Id: <20210709131542.410636747@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.275-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.275-rc1
X-KernelTest-Deadline: 2021-07-11T13:15+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.275 release.
There are 9 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.275-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.275-rc1

Juergen Gross <jgross@suse.com>
    xen/events: reset active flag for lateeoi events later

Petr Mladek <pmladek@suse.com>
    kthread: prevent deadlock when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync()

Petr Mladek <pmladek@suse.com>
    kthread_worker: split code for canceling the delayed work timer

Christian König <christian.koenig@amd.com>
    drm/nouveau: fix dma_address check for CPU/GPU sync

ManYi Li <limanyi@uniontech.com>
    scsi: sr: Return appropriate error code when disk is ejected

Hugh Dickins <hughd@google.com>
    mm, futex: fix shared futex pgoff on shmem huge page

Yang Shi <shy828301@gmail.com>
    mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split

Alex Shi <alex.shi@linux.alibaba.com>
    mm: add VM_WARN_ON_ONCE_PAGE() macro

Michal Hocko <mhocko@kernel.org>
    include/linux/mmdebug.h: make VM_WARN* non-rvals


-------------

Diffstat:

 Makefile                             |  4 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c |  4 +-
 drivers/scsi/sr.c                    |  2 +
 drivers/xen/events/events_base.c     | 23 +++++++++--
 include/linux/hugetlb.h              | 15 -------
 include/linux/mmdebug.h              | 21 ++++++++--
 include/linux/pagemap.h              | 13 +++---
 kernel/futex.c                       |  2 +-
 kernel/kthread.c                     | 77 ++++++++++++++++++++++++------------
 mm/huge_memory.c                     | 29 +++++---------
 mm/hugetlb.c                         |  5 +--
 11 files changed, 112 insertions(+), 83 deletions(-)


