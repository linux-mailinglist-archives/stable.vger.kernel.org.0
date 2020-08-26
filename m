Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB83252BF5
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 13:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgHZK4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 06:56:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728751AbgHZKz7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 06:55:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DA46206EB;
        Wed, 26 Aug 2020 10:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598439358;
        bh=86rXoaezkP82Mkqu+TavO/3wQSovQEBWaJg/Ax11uKo=;
        h=From:To:Cc:Subject:Date:From;
        b=wbk+cr3jusb8Nf5umZ985KjqHTe9pSJ38sfg0rIReww57Rt9ZU56PGzyWvcAqli+I
         Km+89UnzZI5WtlQllsKA+i8GQDWh4rS1s//CLv2yQwzN5CAS/B7n7PGgSygXKPDNOW
         TY3zN5QoAPh9lB9zmhyuhVsY/6F5dL9xiOTqhJDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.142
Date:   Wed, 26 Aug 2020 12:56:10 +0200
Message-Id: <159843937111637@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.142 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/alpha/include/asm/io.h                       |    8 +-
 arch/arm/include/asm/kvm_host.h                   |    2 
 arch/arm64/include/asm/kvm_host.h                 |    2 
 arch/m68k/include/asm/m53xxacr.h                  |    6 -
 arch/mips/include/asm/kvm_host.h                  |    2 
 arch/mips/kvm/mmu.c                               |    3 
 arch/powerpc/include/asm/kvm_host.h               |    3 
 arch/powerpc/kvm/book3s.c                         |    3 
 arch/powerpc/kvm/e500_mmu_host.c                  |    3 
 arch/powerpc/platforms/pseries/ras.c              |    1 
 arch/s390/kernel/ptrace.c                         |    7 +-
 arch/s390/kernel/runtime_instr.c                  |    2 
 arch/x86/include/asm/kvm_host.h                   |    3 
 arch/x86/kvm/mmu.c                                |    3 
 arch/x86/kvm/x86.c                                |    2 
 arch/x86/pci/xen.c                                |    1 
 drivers/clk/clk.c                                 |   52 ++++++++++++----
 drivers/cpufreq/intel_pstate.c                    |    1 
 drivers/firmware/efi/efi.c                        |    2 
 drivers/gpu/drm/amd/display/include/fixed31_32.h  |    3 
 drivers/gpu/drm/vgem/vgem_drv.c                   |   27 --------
 drivers/infiniband/hw/bnxt_re/main.c              |    3 
 drivers/input/mouse/psmouse-base.c                |    2 
 drivers/media/pci/ttpci/budget-core.c             |   11 ++-
 drivers/media/platform/davinci/vpss.c             |   20 ++++--
 drivers/net/bonding/bond_main.c                   |   42 +++++++++++--
 drivers/net/dsa/b53/b53_common.c                  |    2 
 drivers/net/ethernet/amazon/ena/ena_netdev.c      |   19 +++--
 drivers/net/ethernet/cortina/gemini.c             |    4 -
 drivers/net/ethernet/freescale/fec_main.c         |    4 -
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h |    2 
 drivers/net/ethernet/intel/i40e/i40e_common.c     |   35 ++++++++--
 drivers/net/ethernet/intel/i40e/i40e_main.c       |    3 
 drivers/net/hyperv/netvsc_drv.c                   |    2 
 drivers/rtc/rtc-goldfish.c                        |    1 
 drivers/s390/scsi/zfcp_fsf.c                      |    4 -
 drivers/scsi/libfc/fc_disc.c                      |   12 ++-
 drivers/scsi/ufs/ufs_quirks.h                     |    1 
 drivers/scsi/ufs/ufshcd.c                         |    2 
 drivers/spi/Kconfig                               |    3 
 drivers/spi/spi.c                                 |   21 ++++++
 drivers/target/target_core_user.c                 |    2 
 drivers/vfio/vfio_iommu_type1.c                   |   71 ++++++++++++++++++++--
 drivers/video/fbdev/efifb.c                       |    2 
 drivers/virtio/virtio_ring.c                      |    3 
 drivers/xen/preempt.c                             |    2 
 fs/afs/dynroot.c                                  |   20 +++---
 fs/btrfs/ctree.h                                  |    2 
 fs/btrfs/export.c                                 |    8 +-
 fs/btrfs/export.h                                 |    5 +
 fs/btrfs/inode.c                                  |   23 ++++---
 fs/btrfs/super.c                                  |   18 +++--
 fs/btrfs/sysfs.c                                  |    4 +
 fs/ceph/mds_client.c                              |    3 
 fs/eventpoll.c                                    |   19 +++--
 fs/ext4/block_validity.c                          |   36 ++++-------
 fs/ext4/namei.c                                   |   22 ++++--
 fs/jbd2/journal.c                                 |    4 -
 fs/jffs2/dir.c                                    |    6 +
 fs/romfs/storage.c                                |    4 -
 fs/signalfd.c                                     |   10 +--
 fs/xfs/xfs_sysfs.h                                |    6 +
 fs/xfs/xfs_trans_dquot.c                          |    2 
 kernel/kthread.c                                  |   17 ++++-
 kernel/relay.c                                    |    1 
 mm/hugetlb.c                                      |   24 +++----
 mm/khugepaged.c                                   |    7 --
 mm/page_alloc.c                                   |    7 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c           |    2 
 scripts/kconfig/qconf.cc                          |   70 ++++++++++-----------
 sound/soc/codecs/msm8916-wcd-analog.c             |    4 -
 sound/soc/intel/atom/sst-mfld-platform-pcm.c      |    5 -
 sound/soc/qcom/qdsp6/q6routing.c                  |   16 ++++
 tools/perf/util/probe-finder.c                    |    2 
 tools/testing/selftests/cgroup/cgroup_util.c      |    2 
 virt/kvm/arm/mmu.c                                |   18 ++++-
 virt/kvm/kvm_main.c                               |    2 
 78 files changed, 521 insertions(+), 259 deletions(-)

Al Viro (1):
      do_epoll_ctl(): clean the failure exits up a bit

Alex Williamson (1):
      vfio/type1: Add proper error unwind for vfio_iommu_replay()

Bodo Stroesser (1):
      scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range on ARM

Charan Teja Reddy (1):
      mm, page_alloc: fix core hung in free_pcppages_bulk()

Chris Wilson (1):
      drm/vgem: Replace opencoded version of drm_gem_dumb_map_offset()

Chuck Lever (1):
      svcrdma: Fix another Receive buffer leak

Chuhong Yuan (1):
      media: budget-core: Improve exception handling in budget_register()

Cong Wang (1):
      bonding: fix a potential double-unregister

Darrick J. Wong (1):
      xfs: fix inode quota reservation checks

David Howells (1):
      afs: Fix NULL deref in afs_dynroot_depopulate()

Dinghao Liu (1):
      ASoC: intel: Fix memleak in sst_media_open

Doug Berger (1):
      mm: include CMA pages in lowmem_reserve at boot

Eiichi Tsukata (1):
      xfs: Fix UBSAN null-ptr-deref in xfs_sysfs_init

Eric Sandeen (1):
      ext4: fix potential negative array index in do_split()

Evgeny Novikov (1):
      media: vpss: clean up resources in init

Fugang Duan (1):
      net: fec: correct the error path for regulator disable in probe

Gaurav Singh (1):
      tools/testing/selftests/cgroup/cgroup_util.c: cg_read_strcmp: fix null pointer dereference

Greg Kroah-Hartman (1):
      Linux 4.19.142

Greg Ungerer (1):
      m68knommu: fix overwriting of bits in ColdFire V3 cache control

Grzegorz Szczurek (1):
      i40e: Fix crash during removing i40e driver

Haiyang Zhang (1):
      hv_netvsc: Fix the queue_mapping in netvsc_vf_xmit()

Heiko Carstens (2):
      s390/runtime_instrumentation: fix storage key handling
      s390/ptrace: fix storage key handling

Helge Deller (1):
      fs/signalfd.c: fix inconsistent return codes for signalfd4

Huacai Chen (1):
      rtc: goldfish: Enable interrupt in set_alarm() when necessary

Hugh Dickins (2):
      khugepaged: khugepaged_test_exit() check mmget_still_valid()
      khugepaged: adjust VM_BUG_ON_MM() in __khugepaged_enter()

Jan Kara (2):
      ext4: fix checking of directory entry validity for inline directories
      ext4: don't allow overlapping system zones

Jann Horn (1):
      romfs: fix uninitialized memory leak in romfs_dev_read()

Jarod Wilson (1):
      bonding: show saner speed for broadcast mode

Javed Hasan (1):
      scsi: libfc: Free skb in fc_disc_gpn_id_resp() for valid cases

Jim Mattson (2):
      kvm: x86: Toggling CR4.SMAP does not load PDPTEs in PAE mode
      kvm: x86: Toggling CR4.PKE does not load PDPTEs in PAE mode

Jiri Wiesner (1):
      bonding: fix active-backup failover for current ARP slave

Josef Bacik (2):
      btrfs: don't show full path of bind mounts in subvol=
      btrfs: sysfs: use NOFS for device creation

Juergen Gross (2):
      efi: avoid error message when booting under Xen
      xen: don't reschedule in preemption off sections

Krunoslav Kovac (1):
      drm/amd/display: fix pow() crashing when given base 0

Li Heng (1):
      efi: add missed destroy_workqueue when efisubsys_init fails

Liang Chen (1):
      kthread: Do not preempt current task if it is going to call schedule()

Luc Van Oostenryck (1):
      alpha: fix annotation of io{read,write}{16,32}be()

Lukas Wunner (1):
      spi: Prevent adding devices below an unregistering controller

Mao Wenan (1):
      virtio_ring: Avoid loop when vq is broken in virtqueue_poll

Marc Zyngier (1):
      epoll: Keep a reference on files added to the check list

Marcos Paulo de Souza (1):
      btrfs: export helpers for subvolume name/id resolution

Masahiro Yamada (2):
      kconfig: qconf: do not limit the pop-up menu to the first row
      kconfig: qconf: fix signal connection to invalid slots

Masami Hiramatsu (1):
      perf probe: Fix memory leakage when the probe point is not found

Nikolay Borisov (1):
      btrfs: Move free_pages_out label in inline extent handling branch in compress_file_range

Peter Xu (1):
      mm/hugetlb: fix calculation of adjust_range_if_pmd_sharing_possible

Przemyslaw Patynowski (1):
      i40e: Set RX_ONLY mode for unicast promiscuous on VLAN

Qu Wenruo (1):
      btrfs: inode: fix NULL pointer dereference if inode doesn't need compression

Randy Dunlap (1):
      Fix build error when CONFIG_ACPI is not set/enabled:

Selvin Xavier (1):
      RDMA/bnxt_re: Do not add user qps to flushlist

Shay Agroskin (1):
      net: ena: Prevent reset after device destruction

Srinivas Kandagatla (2):
      ASoC: q6routing: add dummy register read/write function
      ASoC: msm8916-wcd-analog: fix register Interrupt offset

Srinivas Pandruvada (1):
      cpufreq: intel_pstate: Fix cpuinfo_max_freq when MSR_TURBO_RATIO_LIMIT is 0

Stanley Chu (1):
      scsi: ufs: Add DELAY_BEFORE_LPM quirk for Micron devices

Steffen Maier (1):
      scsi: zfcp: Fix use-after-free in request timeout handlers

Stephen Boyd (1):
      clk: Evict unregistered clks from parent caches

Tom Rix (1):
      net: dsa: b53: check for timeout

Vasant Hegde (1):
      powerpc/pseries: Do not initiate shutdown when system is running on UPS

Wang Hai (1):
      net: gemini: Fix missing free_netdev() in error path of gemini_ethernet_port_probe()

Wei Yongjun (1):
      kernel/relay.c: fix memleak on destroy relay channel

Will Deacon (2):
      KVM: Pass MMU notifier range flags to kvm_unmap_hva_range()
      KVM: arm64: Only reschedule if MMU_NOTIFIER_RANGE_BLOCKABLE is not set

Xiongfeng Wang (1):
      Input: psmouse - add a newline when printing 'proto' by sysfs

Xiubo Li (1):
      ceph: fix use-after-free for fsc->mdsc

Zhe Li (1):
      jffs2: fix UAF problem

zhangyi (F) (1):
      jbd2: add the missing unlock_buffer() in the error path of jbd2_write_superblock()

