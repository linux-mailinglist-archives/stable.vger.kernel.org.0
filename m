Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD89924F59B
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbgHXIvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:51:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729866AbgHXIvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:51:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D18D42075B;
        Mon, 24 Aug 2020 08:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259070;
        bh=Zv3EO11zyXJjgP8dhCDA+Z/WTQl47zoTQ6gF4rJEpA4=;
        h=From:To:Cc:Subject:Date:From;
        b=hY5JLR9W6Ej8qz2QwbunEds7345Rsa29pkhpA30tUofQd4VhjRcngY1boNHDS7Eyb
         Lqf0PWZKfAHxd3bVRcxUovM+qZUWuUngSK7cyzUkcqI4zyFmtrubZWh6cdabLOTM22
         m3SA2WxNlBvQGyeB1Qx9iED6bzQpTLvC6ZT45AxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/39] 4.9.234-rc1 review
Date:   Mon, 24 Aug 2020 10:30:59 +0200
Message-Id: <20200824082348.445866152@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.234-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.234-rc1
X-KernelTest-Deadline: 2020-08-26T08:23+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.234 release.
There are 39 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 26 Aug 2020 08:23:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.234-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.234-rc1

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

Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
    powerpc/pseries: Do not initiate shutdown when system is running on UPS

Tom Rix <trix@redhat.com>
    net: dsa: b53: check for timeout

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ASoC: intel: Fix memleak in sst_media_open

Fugang Duan <fugang.duan@nxp.com>
    net: fec: correct the error path for regulator disable in probe

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    i40e: Set RX_ONLY mode for unicast promiscuous on VLAN

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

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Add DELAY_BEFORE_LPM quirk for Micron devices

Jan Kara <jack@suse.cz>
    ext4: fix checking of directory entry validity for inline directories

Eric Biggers <ebiggers@google.com>
    ext4: clean up ext4_match() and callers

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: add the missing unlock_buffer() in the error path of jbd2_write_superblock()

Charan Teja Reddy <charante@codeaurora.org>
    mm, page_alloc: fix core hung in free_pcppages_bulk()

Doug Berger <opendmb@gmail.com>
    mm: include CMA pages in lowmem_reserve at boot

Wei Yongjun <weiyongjun1@huawei.com>
    kernel/relay.c: fix memleak on destroy relay channel

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

Kevin Hao <haokexin@gmail.com>
    tracing/hwlat: Honor the tracing_cpumask

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Clean up the hwlat binding code

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix memory leakage when the probe point is not found

Liu Ying <victor.liu@nxp.com>
    drm/imx: imx-ldb: Disable both channels for split mode in enc->disable()

Jan Beulich <JBeulich@suse.com>
    x86/asm: Add instruction suffixes to bitops

Uros Bizjak <ubizjak@gmail.com>
    x86/asm: Remove unnecessary \n\t in front of CC_SET() from asm templates


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/alpha/include/asm/io.h                       |  8 +-
 arch/m68k/include/asm/m53xxacr.h                  |  6 +-
 arch/powerpc/mm/fault.c                           |  7 +-
 arch/powerpc/platforms/pseries/ras.c              |  1 -
 arch/x86/include/asm/archrandom.h                 |  8 +-
 arch/x86/include/asm/bitops.h                     | 29 ++++---
 arch/x86/include/asm/percpu.h                     |  2 +-
 drivers/gpu/drm/imx/imx-ldb.c                     |  7 +-
 drivers/input/mouse/psmouse-base.c                |  2 +-
 drivers/media/pci/ttpci/budget-core.c             | 11 ++-
 drivers/media/platform/davinci/vpss.c             | 20 ++++-
 drivers/net/dsa/b53/b53_common.c                  |  2 +
 drivers/net/ethernet/freescale/fec_main.c         |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c     | 35 ++++++--
 drivers/scsi/libfc/fc_disc.c                      | 12 ++-
 drivers/scsi/ufs/ufs_quirks.h                     |  1 +
 drivers/scsi/ufs/ufshcd.c                         |  2 +
 drivers/virtio/virtio_ring.c                      |  3 +
 drivers/xen/preempt.c                             |  2 +-
 fs/btrfs/ctree.h                                  |  2 +
 fs/btrfs/export.c                                 |  8 +-
 fs/btrfs/export.h                                 |  5 ++
 fs/btrfs/super.c                                  | 18 +++--
 fs/eventpoll.c                                    | 19 +++--
 fs/ext4/namei.c                                   | 99 +++++++++--------------
 fs/jbd2/journal.c                                 |  4 +-
 fs/jffs2/dir.c                                    |  6 +-
 fs/romfs/storage.c                                |  4 +-
 fs/xfs/xfs_sysfs.h                                |  6 +-
 fs/xfs/xfs_trans_dquot.c                          |  2 +-
 kernel/relay.c                                    |  1 +
 kernel/trace/trace_hwlat.c                        | 37 ++++-----
 mm/hugetlb.c                                      | 24 +++---
 mm/khugepaged.c                                   |  7 +-
 mm/page_alloc.c                                   |  7 +-
 sound/soc/intel/atom/sst-mfld-platform-pcm.c      |  5 +-
 tools/perf/util/probe-finder.c                    |  2 +-
 39 files changed, 241 insertions(+), 183 deletions(-)


