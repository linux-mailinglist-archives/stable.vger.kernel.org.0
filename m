Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20697252BF4
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 13:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgHZK4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 06:56:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728757AbgHZK4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 06:56:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFB712083B;
        Wed, 26 Aug 2020 10:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598439375;
        bh=cnYX01IhWDZZgUPv/rZK0AZn/iNb/sp7NdZebw3BTI0=;
        h=From:To:Cc:Subject:Date:From;
        b=DLihaQarhWGo3484u9UW3JP6a+1HCsLOiPvjPimO78BSHVro/XmMINvCG1Oa+W5AR
         418dKxklez4cHrUAMqjkp0rC7vjfDF8zDtedZ7AwoWCedhtFZ+/5467a4niA1L5g3H
         Aiw9CApkhjGTUPMKutmttO8mW7h/dTW9HHGLwKSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.61
Date:   Wed, 26 Aug 2020 12:56:20 +0200
Message-Id: <1598439380235254@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.61 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/kbuild/index.rst                        |    1 
 Documentation/kbuild/kbuild.rst                       |    5 
 Documentation/kbuild/llvm.rst                         |   87 +++++++
 MAINTAINERS                                           |    1 
 Makefile                                              |   40 ++-
 arch/alpha/include/asm/io.h                           |    8 
 arch/arm/include/asm/kvm_host.h                       |    2 
 arch/arm64/Makefile                                   |    1 
 arch/arm64/include/asm/kvm_host.h                     |    2 
 arch/arm64/kernel/vdso32/Makefile                     |    2 
 arch/m68k/include/asm/m53xxacr.h                      |    6 
 arch/mips/include/asm/kvm_host.h                      |    2 
 arch/mips/kernel/setup.c                              |    2 
 arch/mips/kvm/mmu.c                                   |    3 
 arch/powerpc/include/asm/kvm_host.h                   |    3 
 arch/powerpc/kvm/book3s.c                             |    3 
 arch/powerpc/kvm/e500_mmu_host.c                      |    3 
 arch/powerpc/platforms/pseries/ras.c                  |    1 
 arch/s390/kernel/ptrace.c                             |    7 
 arch/s390/kernel/runtime_instr.c                      |    2 
 arch/x86/boot/compressed/Makefile                     |    2 
 arch/x86/include/asm/kvm_host.h                       |    3 
 arch/x86/kvm/mmu.c                                    |    3 
 arch/x86/kvm/x86.c                                    |    2 
 arch/x86/pci/xen.c                                    |    1 
 drivers/cpufreq/intel_pstate.c                        |    1 
 drivers/firmware/efi/efi.c                            |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c     |    1 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c |    2 
 drivers/gpu/drm/amd/display/include/fixed31_32.h      |    3 
 drivers/gpu/drm/ttm/ttm_bo_vm.c                       |    4 
 drivers/gpu/drm/vgem/vgem_drv.c                       |   27 --
 drivers/infiniband/hw/bnxt_re/main.c                  |    3 
 drivers/infiniband/hw/hfi1/tid_rdma.c                 |    1 
 drivers/input/mouse/psmouse-base.c                    |    2 
 drivers/md/bcache/super.c                             |   12 -
 drivers/media/pci/ttpci/budget-core.c                 |   11 
 drivers/media/platform/davinci/vpss.c                 |   20 +
 drivers/media/platform/qcom/camss/camss.c             |   30 +-
 drivers/net/bonding/bond_main.c                       |   42 +++
 drivers/net/dsa/b53/b53_common.c                      |    2 
 drivers/net/ethernet/amazon/ena/ena_netdev.c          |   19 -
 drivers/net/ethernet/cortina/gemini.c                 |    4 
 drivers/net/ethernet/freescale/fec_main.c             |    4 
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h     |    2 
 drivers/net/ethernet/intel/i40e/i40e_common.c         |   35 ++-
 drivers/net/ethernet/intel/i40e/i40e_main.c           |    3 
 drivers/net/hyperv/netvsc_drv.c                       |    2 
 drivers/net/wan/Kconfig                               |    2 
 drivers/net/wan/Makefile                              |   12 -
 drivers/opp/core.c                                    |   10 
 drivers/rtc/rtc-goldfish.c                            |    1 
 drivers/s390/scsi/zfcp_fsf.c                          |    4 
 drivers/scsi/libfc/fc_disc.c                          |   12 -
 drivers/scsi/qla2xxx/qla_os.c                         |    4 
 drivers/scsi/ufs/ufs_quirks.h                         |    1 
 drivers/scsi/ufs/ufshcd.c                             |    2 
 drivers/spi/Kconfig                                   |    3 
 drivers/spi/spi-stm32.c                               |   27 ++
 drivers/spi/spi.c                                     |   21 +
 drivers/target/target_core_user.c                     |    2 
 drivers/vfio/vfio_iommu_type1.c                       |   71 +++++-
 drivers/video/fbdev/efifb.c                           |    2 
 drivers/virtio/virtio_ring.c                          |    3 
 drivers/xen/preempt.c                                 |    2 
 drivers/xen/swiotlb-xen.c                             |    8 
 fs/afs/dynroot.c                                      |   20 -
 fs/btrfs/block-group.c                                |    2 
 fs/btrfs/ctree.h                                      |    2 
 fs/btrfs/delayed-inode.c                              |    2 
 fs/btrfs/export.c                                     |    8 
 fs/btrfs/export.h                                     |    5 
 fs/btrfs/extent-tree.c                                |   10 
 fs/btrfs/extent_io.c                                  |    2 
 fs/btrfs/scrub.c                                      |    2 
 fs/btrfs/super.c                                      |   20 +
 fs/btrfs/transaction.c                                |   30 +-
 fs/btrfs/transaction.h                                |   12 +
 fs/ceph/mds_client.c                                  |    3 
 fs/eventpoll.c                                        |   19 -
 fs/ext4/block_validity.c                              |   36 +--
 fs/ext4/namei.c                                       |   22 +
 fs/gfs2/bmap.c                                        |   68 +++--
 fs/jbd2/journal.c                                     |    4 
 fs/jffs2/dir.c                                        |    6 
 fs/romfs/storage.c                                    |    4 
 fs/signalfd.c                                         |   10 
 fs/xfs/xfs_sysfs.h                                    |    6 
 fs/xfs/xfs_trans_dquot.c                              |    2 
 kernel/events/uprobes.c                               |    2 
 kernel/kthread.c                                      |   17 +
 kernel/relay.c                                        |    1 
 mm/hugetlb.c                                          |   24 --
 mm/khugepaged.c                                       |    7 
 mm/page_alloc.c                                       |    7 
 net/can/j1939/socket.c                                |   14 +
 net/can/j1939/transport.c                             |   89 ++++++-
 net/core/filter.c                                     |   49 +++-
 net/netfilter/nft_exthdr.c                            |    4 
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c               |    2 
 scripts/kconfig/qconf.cc                              |   70 +++---
 sound/pci/hda/patch_realtek.c                         |    2 
 sound/soc/codecs/msm8916-wcd-analog.c                 |    4 
 sound/soc/intel/atom/sst-mfld-platform-pcm.c          |    5 
 sound/soc/qcom/qdsp6/q6afe-dai.c                      |  210 +++++++++---------
 sound/soc/qcom/qdsp6/q6routing.c                      |   16 +
 tools/objtool/Makefile                                |    6 
 tools/perf/util/probe-finder.c                        |    2 
 tools/testing/selftests/cgroup/cgroup_util.c          |    2 
 virt/kvm/arm/mmu.c                                    |   19 +
 virt/kvm/kvm_main.c                                   |    3 
 111 files changed, 983 insertions(+), 478 deletions(-)

Al Viro (1):
      do_epoll_ctl(): clean the failure exits up a bit

Alex Williamson (1):
      vfio/type1: Add proper error unwind for vfio_iommu_replay()

Amelie Delaunay (1):
      spi: stm32: fixes suspend/resume management

Andreas Gruenbacher (1):
      gfs2: Improve mmap write vs. punch_hole consistency

Bob Peterson (1):
      gfs2: Never call gfs2_block_zero_range with an open transaction

Bodo Stroesser (1):
      scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range on ARM

Boris Ostrovsky (1):
      swiotlb-xen: use vmalloc_to_page on vmalloc virt addresses

Charan Teja Reddy (1):
      mm, page_alloc: fix core hung in free_pcppages_bulk()

Chris Wilson (1):
      drm/vgem: Replace opencoded version of drm_gem_dumb_map_offset()

Chuck Lever (1):
      svcrdma: Fix another Receive buffer leak

Chuhong Yuan (1):
      media: budget-core: Improve exception handling in budget_register()

Coly Li (1):
      bcache: avoid nr_stripes overflow in bcache_device_init()

Cong Wang (1):
      bonding: fix a potential double-unregister

Daniel Kolesa (1):
      drm/amdgpu/display: use GFP_ATOMIC in dcn20_validate_bandwidth_internal

Darrick J. Wong (1):
      xfs: fix inode quota reservation checks

David Howells (1):
      afs: Fix NULL deref in afs_dynroot_depopulate()

David Sterba (1):
      btrfs: add wrapper for transaction abort predicate

Dinghao Liu (1):
      ASoC: intel: Fix memleak in sst_media_open

Dmitry Golovin (1):
      x86/boot: kbuild: allow readelf executable to be specified

Doug Berger (1):
      mm: include CMA pages in lowmem_reserve at boot

Eiichi Tsukata (1):
      xfs: Fix UBSAN null-ptr-deref in xfs_sysfs_init

Eric Dumazet (1):
      can: j1939: fix kernel-infoleak in j1939_sk_sock2sockaddr_can()

Eric Sandeen (1):
      ext4: fix potential negative array index in do_split()

Evgeny Novikov (2):
      media: vpss: clean up resources in init
      media: camss: fix memory leaks on error handling paths in probe

Fangrui Song (1):
      Documentation/llvm: fix the name of llvm-size

Felix Kuehling (1):
      drm/ttm: fix offset in VMAs with a pg_offs in ttm_bo_vm_access

Fugang Duan (1):
      net: fec: correct the error path for regulator disable in probe

Gaurav Singh (1):
      tools/testing/selftests/cgroup/cgroup_util.c: cg_read_strcmp: fix null pointer dereference

Greg Kroah-Hartman (1):
      Linux 5.4.61

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

Hugh Dickins (3):
      khugepaged: khugepaged_test_exit() check mmget_still_valid()
      khugepaged: adjust VM_BUG_ON_MM() in __khugepaged_enter()
      uprobes: __replace_page() avoid BUG in munlock_vma_page()

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

Jinyang He (1):
      MIPS: Fix unable to reserve memory for Crash kernel

Jiri Wiesner (1):
      bonding: fix active-backup failover for current ARP slave

John Fastabend (1):
      bpf: sock_ops sk access may stomp registers when dst_reg = src_reg

Josef Bacik (2):
      btrfs: don't show full path of bind mounts in subvol=
      btrfs: return EROFS for BTRFS_FS_STATE_ERROR cases

Juergen Gross (2):
      efi: avoid error message when booting under Xen
      xen: don't reschedule in preemption off sections

Kaike Wan (1):
      RDMA/hfi1: Correct an interlock issue for TID RDMA WRITE request

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

Masahiro Yamada (8):
      net: wan: wanxl: use allow to pass CROSS_COMPILE_M68k for rebuilding firmware
      net: wan: wanxl: use $(M68KCC) instead of $(M68KAS) for rebuilding firmware
      kbuild: remove PYTHON2 variable
      kbuild: remove AS variable
      kbuild: replace AS=clang with LLVM_IAS=1
      kbuild: support LLVM=1 to switch the default tools to Clang/LLVM
      kconfig: qconf: do not limit the pop-up menu to the first row
      kconfig: qconf: fix signal connection to invalid slots

Masami Hiramatsu (1):
      perf probe: Fix memory leakage when the probe point is not found

Mike Pozulp (2):
      ALSA: hda/realtek: Add quirk for Samsung Galaxy Flex Book
      ALSA: hda/realtek: Add quirk for Samsung Galaxy Book Ion

Nick Desaulniers (1):
      Documentation/llvm: add documentation on building w/ Clang/LLVM

Oleksij Rempel (4):
      can: j1939: transport: j1939_session_tx_dat(): fix use-after-free read in j1939_tp_txtimer()
      can: j1939: socket: j1939_sk_bind(): make sure ml_priv is allocated
      can: j1939: transport: j1939_simple_recv(): ignore local J1939 messages send not by J1939 stack
      can: j1939: transport: add j1939_session_skb_find_by_offset() function

Peter Xu (1):
      mm/hugetlb: fix calculation of adjust_range_if_pmd_sharing_possible

Przemyslaw Patynowski (1):
      i40e: Set RX_ONLY mode for unicast promiscuous on VLAN

Quinn Tran (1):
      Revert "scsi: qla2xxx: Disable T10-DIF feature with FC-NVMe during probe"

Rajendra Nayak (1):
      opp: Enable resources again if they were disabled earlier

Randy Dunlap (1):
      Fix build error when CONFIG_ACPI is not set/enabled:

Selvin Xavier (1):
      RDMA/bnxt_re: Do not add user qps to flushlist

Shay Agroskin (1):
      net: ena: Prevent reset after device destruction

Srinivas Kandagatla (3):
      ASoC: q6afe-dai: mark all widgets registers as SND_SOC_NOPM
      ASoC: q6routing: add dummy register read/write function
      ASoC: msm8916-wcd-analog: fix register Interrupt offset

Srinivas Pandruvada (1):
      cpufreq: intel_pstate: Fix cpuinfo_max_freq when MSR_TURBO_RATIO_LIMIT is 0

Stanley Chu (1):
      scsi: ufs: Add DELAY_BEFORE_LPM quirk for Micron devices

Steffen Maier (1):
      scsi: zfcp: Fix use-after-free in request timeout handlers

Stephen Boyd (1):
      ARM64: vdso32: Install vdso32 from vdso_install

Stephen Suryaputra (1):
      netfilter: nf_tables: nft_exthdr: the presence return value should be little-endian

Stylon Wang (1):
      drm/amd/display: Fix EDID parsing after resume from suspend

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

Zhang Changzhong (4):
      can: j1939: fix support for multipacket broadcast message
      can: j1939: cancel rxtimer on multipacket broadcast session complete
      can: j1939: abort multipacket broadcast session when timeout occurs
      can: j1939: add rxtimer for multipacket broadcast session

Zhe Li (1):
      jffs2: fix UAF problem

zhangyi (F) (1):
      jbd2: add the missing unlock_buffer() in the error path of jbd2_write_superblock()

