Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1369024F7AE
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgHXJTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:19:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730115AbgHXIzv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:55:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5929207D3;
        Mon, 24 Aug 2020 08:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259350;
        bh=wZpTjzmwiqRhJtM1tpVPWx0J+fDtNyJvroihrdqp5jg=;
        h=From:To:Cc:Subject:Date:From;
        b=DsyiGZtu0N8dRq8t2gu71Jg9mG9CHn8AeCNZIaRDm/mdpFrV57Vw5uX+E9gYmqXDZ
         p95Yk+yb+m7SnLeCGgTLJmClb/ogUDaWbAqrmyg7hpAKBGvsX5SYuE1/FS5WeMAtp6
         BRmjCs3ij3IsAYYqqGl9rXrhtU9tYLbUq3akt31o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/71] 4.19.142-rc1 review
Date:   Mon, 24 Aug 2020 10:30:51 +0200
Message-Id: <20200824082355.848475917@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.142-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.142-rc1
X-KernelTest-Deadline: 2020-08-26T08:23+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.142 release.
There are 71 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 26 Aug 2020 08:23:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.142-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.142-rc1

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

Li Heng <liheng40@huawei.com>
    efi: add missed destroy_workqueue when efisubsys_init fails

Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
    powerpc/pseries: Do not initiate shutdown when system is running on UPS

Tom Rix <trix@redhat.com>
    net: dsa: b53: check for timeout

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix the queue_mapping in netvsc_vf_xmit()

Wang Hai <wanghai38@huawei.com>
    net: gemini: Fix missing free_netdev() in error path of gemini_ethernet_port_probe()

Shay Agroskin <shayagr@amazon.com>
    net: ena: Prevent reset after device destruction

Jiri Wiesner <jwiesner@suse.com>
    bonding: fix active-backup failover for current ARP slave

David Howells <dhowells@redhat.com>
    afs: Fix NULL deref in afs_dynroot_depopulate()

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Do not add user qps to flushlist

Randy Dunlap <rdunlap@infradead.org>
    Fix build error when CONFIG_ACPI is not set/enabled:

Juergen Gross <jgross@suse.com>
    efi: avoid error message when booting under Xen

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: qconf: fix signal connection to invalid slots

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: qconf: do not limit the pop-up menu to the first row

Jim Mattson <jmattson@google.com>
    kvm: x86: Toggling CR4.PKE does not load PDPTEs in PAE mode

Jim Mattson <jmattson@google.com>
    kvm: x86: Toggling CR4.SMAP does not load PDPTEs in PAE mode

Alex Williamson <alex.williamson@redhat.com>
    vfio/type1: Add proper error unwind for vfio_iommu_replay()

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ASoC: intel: Fix memleak in sst_media_open

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: msm8916-wcd-analog: fix register Interrupt offset

Heiko Carstens <hca@linux.ibm.com>
    s390/ptrace: fix storage key handling

Heiko Carstens <hca@linux.ibm.com>
    s390/runtime_instrumentation: fix storage key handling

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

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: q6routing: add dummy register read/write function

Jan Kara <jack@suse.cz>
    ext4: don't allow overlapping system zones

Eric Sandeen <sandeen@redhat.com>
    ext4: fix potential negative array index in do_split()

Helge Deller <deller@gmx.de>
    fs/signalfd.c: fix inconsistent return codes for signalfd4

Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
    alpha: fix annotation of io{read,write}{16,32}be()

Eiichi Tsukata <devel@etsukata.com>
    xfs: Fix UBSAN null-ptr-deref in xfs_sysfs_init

Gaurav Singh <gaurav1086@gmail.com>
    tools/testing/selftests/cgroup/cgroup_util.c: cg_read_strcmp: fix null pointer dereference

Mao Wenan <wenan.mao@linux.alibaba.com>
    virtio_ring: Avoid loop when vq is broken in virtqueue_poll

Javed Hasan <jhasan@marvell.com>
    scsi: libfc: Free skb in fc_disc_gpn_id_resp() for valid cases

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    cpufreq: intel_pstate: Fix cpuinfo_max_freq when MSR_TURBO_RATIO_LIMIT is 0

Xiubo Li <xiubli@redhat.com>
    ceph: fix use-after-free for fsc->mdsc

Zhe Li <lizhe67@huawei.com>
    jffs2: fix UAF problem

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix inode quota reservation checks

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Fix another Receive buffer leak

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

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range on ARM

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Add DELAY_BEFORE_LPM quirk for Micron devices

Lukas Wunner <lukas@wunner.de>
    spi: Prevent adding devices below an unregistering controller

Liang Chen <cl@rock-chips.com>
    kthread: Do not preempt current task if it is going to call schedule()

Krunoslav Kovac <Krunoslav.Kovac@amd.com>
    drm/amd/display: fix pow() crashing when given base 0

Yang Shi <shy828301@gmail.com>
    mm/memory.c: skip spurious TLB flush for retried page fault

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: Fix use-after-free in request timeout handlers

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
 arch/powerpc/platforms/pseries/ras.c              |  1 -
 arch/s390/kernel/ptrace.c                         |  7 ++-
 arch/s390/kernel/runtime_instr.c                  |  2 +-
 arch/x86/kvm/x86.c                                |  2 +-
 arch/x86/pci/xen.c                                |  1 +
 drivers/clk/clk.c                                 | 52 +++++++++++++----
 drivers/cpufreq/intel_pstate.c                    |  1 +
 drivers/firmware/efi/efi.c                        |  2 +
 drivers/gpu/drm/amd/display/include/fixed31_32.h  |  3 +
 drivers/gpu/drm/vgem/vgem_drv.c                   | 27 ---------
 drivers/infiniband/hw/bnxt_re/main.c              |  3 +-
 drivers/input/mouse/psmouse-base.c                |  2 +-
 drivers/media/pci/ttpci/budget-core.c             | 11 +++-
 drivers/media/platform/davinci/vpss.c             | 20 +++++--
 drivers/net/bonding/bond_main.c                   | 42 ++++++++++++--
 drivers/net/dsa/b53/b53_common.c                  |  2 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c      | 19 +++---
 drivers/net/ethernet/cortina/gemini.c             |  4 +-
 drivers/net/ethernet/freescale/fec_main.c         |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c     | 35 ++++++++---
 drivers/net/ethernet/intel/i40e/i40e_main.c       |  3 +
 drivers/net/hyperv/netvsc_drv.c                   |  2 +-
 drivers/rtc/rtc-goldfish.c                        |  1 +
 drivers/s390/scsi/zfcp_fsf.c                      |  4 +-
 drivers/scsi/libfc/fc_disc.c                      | 12 +++-
 drivers/scsi/ufs/ufs_quirks.h                     |  1 +
 drivers/scsi/ufs/ufshcd.c                         |  2 +
 drivers/spi/Kconfig                               |  3 +
 drivers/spi/spi.c                                 | 21 ++++++-
 drivers/target/target_core_user.c                 |  2 +-
 drivers/vfio/vfio_iommu_type1.c                   | 71 +++++++++++++++++++++--
 drivers/video/fbdev/efifb.c                       |  2 +-
 drivers/virtio/virtio_ring.c                      |  3 +
 drivers/xen/preempt.c                             |  2 +-
 fs/afs/dynroot.c                                  | 20 ++++---
 fs/btrfs/ctree.h                                  |  2 +
 fs/btrfs/export.c                                 |  8 +--
 fs/btrfs/export.h                                 |  5 ++
 fs/btrfs/inode.c                                  | 23 +++++---
 fs/btrfs/super.c                                  | 18 ++++--
 fs/btrfs/sysfs.c                                  |  4 ++
 fs/ceph/mds_client.c                              |  3 +-
 fs/eventpoll.c                                    | 19 +++---
 fs/ext4/block_validity.c                          | 36 +++++-------
 fs/ext4/namei.c                                   | 22 +++++--
 fs/jbd2/journal.c                                 |  4 +-
 fs/jffs2/dir.c                                    |  6 +-
 fs/romfs/storage.c                                |  4 +-
 fs/signalfd.c                                     | 10 ++--
 fs/xfs/xfs_sysfs.h                                |  6 +-
 fs/xfs/xfs_trans_dquot.c                          |  2 +-
 kernel/kthread.c                                  | 17 +++++-
 kernel/relay.c                                    |  1 +
 mm/hugetlb.c                                      | 24 ++++----
 mm/khugepaged.c                                   |  7 +--
 mm/memory.c                                       |  3 +
 mm/page_alloc.c                                   |  7 ++-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c           |  2 +
 scripts/kconfig/qconf.cc                          | 70 +++++++++++-----------
 sound/soc/codecs/msm8916-wcd-analog.c             |  4 +-
 sound/soc/intel/atom/sst-mfld-platform-pcm.c      |  5 +-
 sound/soc/qcom/qdsp6/q6routing.c                  | 16 +++++
 tools/perf/util/probe-finder.c                    |  2 +-
 tools/testing/selftests/cgroup/cgroup_util.c      |  2 +-
 68 files changed, 496 insertions(+), 245 deletions(-)


