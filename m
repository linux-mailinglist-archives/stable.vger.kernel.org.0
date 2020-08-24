Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B919B2503CA
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 18:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgHXQvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 12:51:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728678AbgHXQtJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:49:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB5CB20578;
        Mon, 24 Aug 2020 16:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287747;
        bh=xbXbpi+8r1iCaM9Tjg31zOCQCcffA5MyiUBMkzh9LkU=;
        h=From:To:Cc:Subject:Date:From;
        b=xelDyxzs4QWyssNDMpvEmGWX0rBaEoS19yiJLSoZxGaNOJrnahR4vaVC8sGDTLTX0
         3hTZnzbmzIZLCX46ifzocL5kkIqlVdRhLh2dsLJ5t/8zhWAGxCifGaCkSlgZ/tUPyA
         6/sQdtiqkqBtc//+O3C7Qbn/fRqJxDsTIV/Vf0RY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/51] 4.14.195-rc2 review
Date:   Mon, 24 Aug 2020 18:49:24 +0200
Message-Id: <20200824164724.981131044@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.195-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.195-rc2
X-KernelTest-Deadline: 2020-08-26T16:47+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.195 release.
There are 51 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.195-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.195-rc2

Will Deacon <will@kernel.org>
    KVM: arm/arm64: Don't reschedule in unmap_stage2_range()

Stephen Boyd <sboyd@kernel.org>
    clk: Evict unregistered clks from parent caches

Juergen Gross <jgross@suse.com>
    xen: don't reschedule in preemption off sections

Peter Xu <peterx@redhat.com>
    mm/hugetlb: fix calculation of adjust_range_if_pmd_sharing_possible

Al Viro <viro@zeniv.linux.org.uk>
    do_epoll_ctl(): clean the failure exits up a bit

Marc Zyngier <maz@kernel.org>
    epoll: Keep a reference on files added to the check list

Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
    powerpc/pseries: Do not initiate shutdown when system is running on UPS

Tom Rix <trix@redhat.com>
    net: dsa: b53: check for timeout

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix the queue_mapping in netvsc_vf_xmit()

Jiri Wiesner <jwiesner@suse.com>
    bonding: fix active-backup failover for current ARP slave

Alex Williamson <alex.williamson@redhat.com>
    vfio/type1: Add proper error unwind for vfio_iommu_replay()

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ASoC: intel: Fix memleak in sst_media_open

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: msm8916-wcd-analog: fix register Interrupt offset

Cong Wang <xiyou.wangcong@gmail.com>
    bonding: fix a potential double-unregister

Jarod Wilson <jarod@redhat.com>
    bonding: show saner speed for broadcast mode

Fugang Duan <fugang.duan@nxp.com>
    net: fec: correct the error path for regulator disable in probe

Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
    i40e: Fix crash during removing i40e driver

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

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    cpufreq: intel_pstate: Fix cpuinfo_max_freq when MSR_TURBO_RATIO_LIMIT is 0

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

Huacai Chen <chenhc@lemote.com>
    rtc: goldfish: Enable interrupt in set_alarm() when necessary

Chuhong Yuan <hslester96@gmail.com>
    media: budget-core: Improve exception handling in budget_register()

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Add DELAY_BEFORE_LPM quirk for Micron devices

Lukas Wunner <lukas@wunner.de>
    spi: Prevent adding devices below an unregistering controller

Yang Shi <shy828301@gmail.com>
    mm/memory.c: skip spurious TLB flush for retried page fault

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: add the missing unlock_buffer() in the error path of jbd2_write_superblock()

Jan Kara <jack@suse.cz>
    ext4: fix checking of directory entry validity for inline directories

Charan Teja Reddy <charante@codeaurora.org>
    mm, page_alloc: fix core hung in free_pcppages_bulk()

Doug Berger <opendmb@gmail.com>
    mm: include CMA pages in lowmem_reserve at boot

Wei Yongjun <weiyongjun1@huawei.com>
    kernel/relay.c: fix memleak on destroy relay channel

Jann Horn <jannh@google.com>
    romfs: fix uninitialized memory leak in romfs_dev_read()

Josef Bacik <josef@toxicpanda.com>
    btrfs: sysfs: use NOFS for device creation

Qu Wenruo <wqu@suse.com>
    btrfs: inode: fix NULL pointer dereference if inode doesn't need compression

Nikolay Borisov <nborisov@suse.com>
    btrfs: Move free_pages_out label in inline extent handling branch in compress_file_range

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't show full path of bind mounts in subvol=

Marcos Paulo de Souza <mpdesouza@suse.com>
    btrfs: export helpers for subvolume name/id resolution

Michael Ellerman <mpe@ellerman.id.au>
    powerpc: Allow 4224 bytes of stack expansion for the signal frame

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/mm: Only read faulting instruction when necessary in do_page_fault()

Hugh Dickins <hughd@google.com>
    khugepaged: adjust VM_BUG_ON_MM() in __khugepaged_enter()

Hugh Dickins <hughd@google.com>
    khugepaged: khugepaged_test_exit() check mmget_still_valid()

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix memory leakage when the probe point is not found

Chris Wilson <chris@chris-wilson.co.uk>
    drm/vgem: Replace opencoded version of drm_gem_dumb_map_offset()


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/alpha/include/asm/io.h                       |  8 +--
 arch/m68k/include/asm/m53xxacr.h                  |  6 +-
 arch/powerpc/mm/fault.c                           | 55 ++++++++++++------
 arch/powerpc/platforms/pseries/ras.c              |  1 -
 drivers/clk/clk.c                                 | 52 +++++++++++++----
 drivers/cpufreq/intel_pstate.c                    |  1 +
 drivers/gpu/drm/vgem/vgem_drv.c                   | 27 ---------
 drivers/input/mouse/psmouse-base.c                |  2 +-
 drivers/media/pci/ttpci/budget-core.c             | 11 +++-
 drivers/media/platform/davinci/vpss.c             | 20 +++++--
 drivers/net/bonding/bond_main.c                   | 42 ++++++++++++--
 drivers/net/dsa/b53/b53_common.c                  |  2 +
 drivers/net/ethernet/freescale/fec_main.c         |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c     | 35 ++++++++---
 drivers/net/ethernet/intel/i40e/i40e_main.c       |  3 +
 drivers/net/hyperv/netvsc_drv.c                   |  2 +-
 drivers/rtc/rtc-goldfish.c                        |  1 +
 drivers/scsi/libfc/fc_disc.c                      | 12 +++-
 drivers/scsi/ufs/ufs_quirks.h                     |  1 +
 drivers/scsi/ufs/ufshcd.c                         |  2 +
 drivers/spi/Kconfig                               |  3 +
 drivers/spi/spi.c                                 | 21 ++++++-
 drivers/vfio/vfio_iommu_type1.c                   | 71 +++++++++++++++++++++--
 drivers/virtio/virtio_ring.c                      |  3 +
 drivers/xen/preempt.c                             |  2 +-
 fs/btrfs/ctree.h                                  |  2 +
 fs/btrfs/export.c                                 |  8 +--
 fs/btrfs/export.h                                 |  5 ++
 fs/btrfs/inode.c                                  | 23 +++++---
 fs/btrfs/super.c                                  | 18 ++++--
 fs/btrfs/sysfs.c                                  |  4 ++
 fs/eventpoll.c                                    | 19 +++---
 fs/ext4/namei.c                                   | 22 +++++--
 fs/jbd2/journal.c                                 |  4 +-
 fs/jffs2/dir.c                                    |  6 +-
 fs/romfs/storage.c                                |  4 +-
 fs/xfs/xfs_sysfs.h                                |  6 +-
 fs/xfs/xfs_trans_dquot.c                          |  2 +-
 kernel/relay.c                                    |  1 +
 mm/hugetlb.c                                      | 24 ++++----
 mm/khugepaged.c                                   |  7 +--
 mm/memory.c                                       |  3 +
 mm/page_alloc.c                                   |  7 ++-
 sound/soc/codecs/msm8916-wcd-analog.c             |  4 +-
 sound/soc/intel/atom/sst-mfld-platform-pcm.c      |  5 +-
 tools/perf/util/probe-finder.c                    |  2 +-
 virt/kvm/arm/mmu.c                                |  6 --
 49 files changed, 403 insertions(+), 172 deletions(-)


