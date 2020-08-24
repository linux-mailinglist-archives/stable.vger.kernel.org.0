Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E3624F880
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbgHXItp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:49:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729756AbgHXItn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:49:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88940207DF;
        Mon, 24 Aug 2020 08:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258982;
        bh=zc0XHB5ZNEc+WXRWf3SahWbAdw5aAtzsvKKwfU2GkAE=;
        h=From:To:Cc:Subject:Date:From;
        b=PlL1pZgusqdq8TmNfcB+5A6jJMfiMY0aOFrmJ6GZxCW6qPORgyotIetQdyDgLBUgN
         Uvhq+aWtNLASBnHhFFdyU/Br4bPY9RSpNkihMAfw3ZpY+l5Z1VTe8uCSpUqhNZ8O3F
         KZFQcgjAYNx7WcXObsPRHvj/sZWlB5cwS9PjN18E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/33] 4.4.234-rc1 review
Date:   Mon, 24 Aug 2020 10:30:56 +0200
Message-Id: <20200824082346.498653578@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.234-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.234-rc1
X-KernelTest-Deadline: 2020-08-26T08:23+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.234 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 26 Aug 2020 08:23:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.234-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.234-rc1

Adam Ford <aford173@gmail.com>
    omapfb: dss: Fix max fclk divider for omap36xx

Juergen Gross <jgross@suse.com>
    xen: don't reschedule in preemption off sections

Peter Xu <peterx@redhat.com>
    mm/hugetlb: fix calculation of adjust_range_if_pmd_sharing_possible

Al Viro <viro@zeniv.linux.org.uk>
    do_epoll_ctl(): clean the failure exits up a bit

Marc Zyngier <maz@kernel.org>
    epoll: Keep a reference on files added to the check list

Michael Ellerman <mpe@ellerman.id.au>
    powerpc: Allow 4224 bytes of stack expansion for the signal frame

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ASoC: intel: Fix memleak in sst_media_open

Eric Sandeen <sandeen@redhat.com>
    ext4: fix potential negative array index in do_split()

Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
    alpha: fix annotation of io{read,write}{16,32}be()

Eiichi Tsukata <devel@etsukata.com>
    xfs: Fix UBSAN null-ptr-deref in xfs_sysfs_init

Mao Wenan <wenan.mao@linux.alibaba.com>
    virtio_ring: Avoid loop when vq is broken in virtqueue_poll

Javed Hasan <jhasan@marvell.com>
    scsi: libfc: Free skb in fc_disc_gpn_id_resp() for valid cases

Zhe Li <lizhe67@huawei.com>
    jffs2: fix UAF problem

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix inode quota reservation checks

Greg Ungerer <gerg@linux-m68k.org>
    m68knommu: fix overwriting of bits in ColdFire V3 cache control

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    Input: psmouse - add a newline when printing 'proto' by sysfs

Evgeny Novikov <novikov@ispras.ru>
    media: vpss: clean up resources in init

Chuhong Yuan <hslester96@gmail.com>
    media: budget-core: Improve exception handling in budget_register()

Jan Kara <jack@suse.cz>
    ext4: fix checking of directory entry validity for inline directories

Eric Biggers <ebiggers@google.com>
    ext4: clean up ext4_match() and callers

Charan Teja Reddy <charante@codeaurora.org>
    mm, page_alloc: fix core hung in free_pcppages_bulk()

Doug Berger <opendmb@gmail.com>
    mm: include CMA pages in lowmem_reserve at boot

Jann Horn <jannh@google.com>
    romfs: fix uninitialized memory leak in romfs_dev_read()

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't show full path of bind mounts in subvol=

Marcos Paulo de Souza <mpdesouza@suse.com>
    btrfs: export helpers for subvolume name/id resolution

Hugh Dickins <hughd@google.com>
    khugepaged: adjust VM_BUG_ON_MM() in __khugepaged_enter()

Hugh Dickins <hughd@google.com>
    khugepaged: khugepaged_test_exit() check mmget_still_valid()

Andrea Arcangeli <aarcange@redhat.com>
    coredump: fix race condition between collapse_huge_page() and core dumping

Ahmad Fatoum <a.fatoum@pengutronix.de>
    watchdog: f71808e_wdt: remove use of wrong watchdog_info option

Ahmad Fatoum <a.fatoum@pengutronix.de>
    watchdog: f71808e_wdt: indicate WDIOF_CARDRESET support in watchdog_info.options

Kees Cook <keescook@chromium.org>
    net/compat: Add missing sock updates for SCM_RIGHTS

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix memory leakage when the probe point is not found

Liu Ying <victor.liu@nxp.com>
    drm/imx: imx-ldb: Disable both channels for split mode in enc->disable()


-------------

Diffstat:

 Makefile                                     |  4 +-
 arch/alpha/include/asm/io.h                  |  8 +--
 arch/m68k/include/asm/m53xxacr.h             |  6 +-
 arch/powerpc/mm/fault.c                      |  7 +-
 drivers/gpu/drm/imx/imx-ldb.c                |  7 +-
 drivers/input/mouse/psmouse-base.c           |  2 +-
 drivers/media/pci/ttpci/budget-core.c        | 11 +++-
 drivers/media/platform/davinci/vpss.c        | 20 ++++--
 drivers/scsi/libfc/fc_disc.c                 | 12 +++-
 drivers/video/fbdev/omap2/dss/dss.c          |  2 +-
 drivers/virtio/virtio_ring.c                 |  3 +
 drivers/watchdog/f71808e_wdt.c               |  6 +-
 drivers/xen/preempt.c                        |  2 +-
 fs/btrfs/ctree.h                             |  2 +
 fs/btrfs/export.c                            |  8 +--
 fs/btrfs/export.h                            |  5 ++
 fs/btrfs/super.c                             | 18 +++--
 fs/eventpoll.c                               | 19 +++---
 fs/ext4/namei.c                              | 99 +++++++++++-----------------
 fs/jffs2/dir.c                               |  6 +-
 fs/romfs/storage.c                           |  4 +-
 fs/xfs/xfs_sysfs.h                           |  6 +-
 fs/xfs/xfs_trans_dquot.c                     |  2 +-
 include/linux/mm.h                           |  4 ++
 include/net/sock.h                           |  4 ++
 mm/huge_memory.c                             |  4 +-
 mm/hugetlb.c                                 | 25 ++++---
 mm/page_alloc.c                              |  7 +-
 net/compat.c                                 |  1 +
 net/core/sock.c                              | 21 ++++++
 sound/soc/intel/atom/sst-mfld-platform-pcm.c |  5 +-
 tools/perf/util/probe-finder.c               |  2 +-
 32 files changed, 197 insertions(+), 135 deletions(-)


