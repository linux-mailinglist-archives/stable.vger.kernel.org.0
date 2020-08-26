Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA253252BCA
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 12:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbgHZKzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 06:55:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728363AbgHZKzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 06:55:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A1A72080C;
        Wed, 26 Aug 2020 10:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598439337;
        bh=1yICH4LVnZnT/FX7uc6nwcVLqTUyUgRo9HLl/SEe4jA=;
        h=From:To:Cc:Subject:Date:From;
        b=GtSs29/HTC2wjjVsTO0a38/Pg0DwU65EoHalnEr2j9N4YnUgtaSi3j+CWzfx0r1p7
         6wqpMu9iJjMeAic+0joytDnOE+HS2CBe00Coq53CyuFlTF2cpbD/s3Xm1zLfJUQKwF
         nYtGxMgAyV1KA3WM42edkTE03TbBgsKhY1Oc53nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.234
Date:   Wed, 26 Aug 2020 12:55:48 +0200
Message-Id: <1598439348169223@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.234 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/alpha/include/asm/io.h                       |    8 -
 arch/arm/kvm/mmu.c                                |    6 -
 arch/m68k/include/asm/m53xxacr.h                  |    6 -
 arch/powerpc/mm/fault.c                           |    7 +
 arch/powerpc/platforms/pseries/ras.c              |    1 
 arch/x86/include/asm/archrandom.h                 |    8 -
 arch/x86/include/asm/bitops.h                     |   29 +++---
 arch/x86/include/asm/percpu.h                     |    2 
 drivers/gpu/drm/imx/imx-ldb.c                     |    7 -
 drivers/input/mouse/psmouse-base.c                |    2 
 drivers/media/pci/ttpci/budget-core.c             |   11 +-
 drivers/media/platform/davinci/vpss.c             |   20 +++-
 drivers/net/dsa/b53/b53_common.c                  |    2 
 drivers/net/ethernet/freescale/fec_main.c         |    4 
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h |    2 
 drivers/net/ethernet/intel/i40e/i40e_common.c     |   35 ++++++-
 drivers/scsi/libfc/fc_disc.c                      |   12 ++
 drivers/scsi/ufs/ufs_quirks.h                     |    1 
 drivers/scsi/ufs/ufshcd.c                         |    2 
 drivers/virtio/virtio_ring.c                      |    3 
 drivers/xen/preempt.c                             |    2 
 fs/btrfs/ctree.h                                  |    2 
 fs/btrfs/export.c                                 |    8 -
 fs/btrfs/export.h                                 |    5 +
 fs/btrfs/super.c                                  |   18 ++--
 fs/eventpoll.c                                    |   19 ++--
 fs/ext4/namei.c                                   |   99 ++++++++--------------
 fs/jffs2/dir.c                                    |    6 +
 fs/romfs/storage.c                                |    4 
 fs/xfs/xfs_sysfs.h                                |    6 -
 fs/xfs/xfs_trans_dquot.c                          |    2 
 kernel/relay.c                                    |    1 
 kernel/trace/trace_hwlat.c                        |   37 ++++----
 mm/hugetlb.c                                      |   24 ++---
 mm/khugepaged.c                                   |    7 -
 mm/page_alloc.c                                   |    7 +
 sound/soc/intel/atom/sst-mfld-platform-pcm.c      |    5 -
 tools/perf/util/probe-finder.c                    |    2 
 39 files changed, 237 insertions(+), 187 deletions(-)

Al Viro (1):
      do_epoll_ctl(): clean the failure exits up a bit

Charan Teja Reddy (1):
      mm, page_alloc: fix core hung in free_pcppages_bulk()

Chuhong Yuan (1):
      media: budget-core: Improve exception handling in budget_register()

Darrick J. Wong (1):
      xfs: fix inode quota reservation checks

Dinghao Liu (1):
      ASoC: intel: Fix memleak in sst_media_open

Doug Berger (1):
      mm: include CMA pages in lowmem_reserve at boot

Eiichi Tsukata (1):
      xfs: Fix UBSAN null-ptr-deref in xfs_sysfs_init

Eric Biggers (1):
      ext4: clean up ext4_match() and callers

Eric Sandeen (1):
      ext4: fix potential negative array index in do_split()

Evgeny Novikov (1):
      media: vpss: clean up resources in init

Fugang Duan (1):
      net: fec: correct the error path for regulator disable in probe

Greg Kroah-Hartman (1):
      Linux 4.9.234

Greg Ungerer (1):
      m68knommu: fix overwriting of bits in ColdFire V3 cache control

Hugh Dickins (2):
      khugepaged: khugepaged_test_exit() check mmget_still_valid()
      khugepaged: adjust VM_BUG_ON_MM() in __khugepaged_enter()

Jan Beulich (1):
      x86/asm: Add instruction suffixes to bitops

Jan Kara (1):
      ext4: fix checking of directory entry validity for inline directories

Jann Horn (1):
      romfs: fix uninitialized memory leak in romfs_dev_read()

Javed Hasan (1):
      scsi: libfc: Free skb in fc_disc_gpn_id_resp() for valid cases

Josef Bacik (1):
      btrfs: don't show full path of bind mounts in subvol=

Juergen Gross (1):
      xen: don't reschedule in preemption off sections

Kevin Hao (1):
      tracing/hwlat: Honor the tracing_cpumask

Liu Ying (1):
      drm/imx: imx-ldb: Disable both channels for split mode in enc->disable()

Luc Van Oostenryck (1):
      alpha: fix annotation of io{read,write}{16,32}be()

Mao Wenan (1):
      virtio_ring: Avoid loop when vq is broken in virtqueue_poll

Marc Zyngier (1):
      epoll: Keep a reference on files added to the check list

Marcos Paulo de Souza (1):
      btrfs: export helpers for subvolume name/id resolution

Masami Hiramatsu (1):
      perf probe: Fix memory leakage when the probe point is not found

Michael Ellerman (1):
      powerpc: Allow 4224 bytes of stack expansion for the signal frame

Peter Xu (1):
      mm/hugetlb: fix calculation of adjust_range_if_pmd_sharing_possible

Przemyslaw Patynowski (1):
      i40e: Set RX_ONLY mode for unicast promiscuous on VLAN

Stanley Chu (1):
      scsi: ufs: Add DELAY_BEFORE_LPM quirk for Micron devices

Steven Rostedt (VMware) (1):
      tracing: Clean up the hwlat binding code

Tom Rix (1):
      net: dsa: b53: check for timeout

Uros Bizjak (1):
      x86/asm: Remove unnecessary \n\t in front of CC_SET() from asm templates

Vasant Hegde (1):
      powerpc/pseries: Do not initiate shutdown when system is running on UPS

Wei Yongjun (1):
      kernel/relay.c: fix memleak on destroy relay channel

Will Deacon (1):
      KVM: arm/arm64: Don't reschedule in unmap_stage2_range()

Xiongfeng Wang (1):
      Input: psmouse - add a newline when printing 'proto' by sysfs

Zhe Li (1):
      jffs2: fix UAF problem

