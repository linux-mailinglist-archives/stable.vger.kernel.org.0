Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94113252BD5
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 12:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbgHZK4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 06:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728684AbgHZK4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 06:56:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF66F2087D;
        Wed, 26 Aug 2020 10:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598439382;
        bh=OHCboMbuBJwZAH2680ZeZ32CAO6q4YMc6OoM7Pl2lJM=;
        h=From:To:Cc:Subject:Date:From;
        b=PYvz9zssdu77R5CCgJK+Ss/MymwY5pzQLfjg/P1DgIFeRbmwLrFriDFvM0CCESieY
         RrcYUfib1sNivYlhqG8XetagE7FqKKI5TtyjjvWa2OyNNSSMv3zlw5h4+Fjs0SQTIR
         FGHqNX8hcQaVAfAnW0PYo3sR1JggxjWHjvUZYrJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.8.4
Date:   Wed, 26 Aug 2020 12:56:29 +0200
Message-Id: <1598439390129173@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.8.4 kernel.

All users of the 5.8 kernel series must upgrade.

The updated 5.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.8.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/alpha/include/asm/io.h                                 |    8 
 arch/arm64/Makefile                                         |    1 
 arch/arm64/include/asm/kvm_host.h                           |    2 
 arch/arm64/kernel/vdso32/Makefile                           |    2 
 arch/arm64/kvm/mmu.c                                        |   19 -
 arch/ia64/include/asm/pgtable.h                             |    9 
 arch/m68k/include/asm/m53xxacr.h                            |    6 
 arch/mips/include/asm/kvm_host.h                            |    2 
 arch/mips/kernel/setup.c                                    |    2 
 arch/mips/kvm/mmu.c                                         |    3 
 arch/powerpc/include/asm/fixmap.h                           |    2 
 arch/powerpc/include/asm/kvm_host.h                         |    3 
 arch/powerpc/kernel/setup-common.c                          |    1 
 arch/powerpc/kvm/book3s.c                                   |    3 
 arch/powerpc/kvm/e500_mmu_host.c                            |    3 
 arch/powerpc/platforms/pseries/hotplug-cpu.c                |   18 -
 arch/powerpc/platforms/pseries/ras.c                        |    1 
 arch/riscv/kernel/vmlinux.lds.S                             |    2 
 arch/s390/kernel/ptrace.c                                   |    7 
 arch/s390/kernel/runtime_instr.c                            |    2 
 arch/s390/pci/pci.c                                         |   22 -
 arch/s390/pci/pci_bus.c                                     |   52 +-
 arch/s390/pci/pci_bus.h                                     |   13 
 arch/s390/pci/pci_event.c                                   |    7 
 arch/x86/include/asm/kvm_host.h                             |    3 
 arch/x86/kvm/mmu/mmu.c                                      |    3 
 arch/x86/kvm/x86.c                                          |    2 
 arch/x86/pci/xen.c                                          |    1 
 arch/x86/platform/efi/efi_64.c                              |    2 
 drivers/cpufreq/intel_pstate.c                              |    1 
 drivers/edac/i7core_edac.c                                  |    4 
 drivers/edac/pnd2_edac.c                                    |    2 
 drivers/edac/sb_edac.c                                      |    4 
 drivers/edac/skx_common.c                                   |    4 
 drivers/firmware/efi/efi.c                                  |    2 
 drivers/firmware/efi/libstub/efi-stub-helper.c              |   12 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c                |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |    1 
 drivers/gpu/drm/amd/display/dc/core/dc_link.c               |    7 
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c            |   16 
 drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.h         |    2 
 drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c |   11 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c          |    4 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c       |    2 
 drivers/gpu/drm/amd/display/include/fixed31_32.h            |    3 
 drivers/gpu/drm/ast/ast_drv.c                               |    1 
 drivers/gpu/drm/ast/ast_drv.h                               |    2 
 drivers/gpu/drm/ast/ast_main.c                              |   91 ++---
 drivers/gpu/drm/ast/ast_mode.c                              |   11 
 drivers/gpu/drm/ast/ast_post.c                              |   10 
 drivers/gpu/drm/i915/i915_pmu.c                             |   17 
 drivers/gpu/drm/panel/panel-simple.c                        |    2 
 drivers/gpu/drm/ttm/ttm_bo_vm.c                             |    4 
 drivers/gpu/drm/vgem/vgem_drv.c                             |   27 -
 drivers/gpu/drm/virtio/virtgpu_ioctl.c                      |    1 
 drivers/infiniband/hw/bnxt_re/main.c                        |    3 
 drivers/infiniband/hw/hfi1/tid_rdma.c                       |    1 
 drivers/infiniband/hw/hns/hns_roce_device.h                 |    2 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                  |    9 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h                  |    4 
 drivers/infiniband/hw/hns/hns_roce_qp.c                     |    5 
 drivers/infiniband/hw/hns/hns_roce_srq.c                    |    2 
 drivers/input/mouse/psmouse-base.c                          |    2 
 drivers/media/pci/ttpci/budget-core.c                       |   11 
 drivers/media/platform/coda/coda-jpeg.c                     |    5 
 drivers/media/platform/davinci/vpss.c                       |   20 -
 drivers/media/platform/qcom/camss/camss.c                   |   30 +
 drivers/net/bonding/bond_main.c                             |   42 ++
 drivers/net/dsa/b53/b53_common.c                            |    2 
 drivers/net/ethernet/amazon/ena/ena_netdev.c                |   30 -
 drivers/net/ethernet/cortina/gemini.c                       |    4 
 drivers/net/ethernet/freescale/fec_main.c                   |    4 
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h           |    2 
 drivers/net/ethernet/intel/i40e/i40e_common.c               |   35 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c                 |    3 
 drivers/net/ethernet/intel/igc/igc_main.c                   |    5 
 drivers/net/ethernet/intel/igc/igc_ptp.c                    |    2 
 drivers/net/hyperv/netvsc_drv.c                             |    2 
 drivers/net/ipvlan/ipvlan_main.c                            |   27 +
 drivers/of/address.c                                        |    5 
 drivers/opp/core.c                                          |   19 -
 drivers/pci/hotplug/s390_pci_hpc.c                          |   12 
 drivers/rtc/rtc-goldfish.c                                  |    1 
 drivers/s390/scsi/zfcp_fsf.c                                |    4 
 drivers/scsi/libfc/fc_disc.c                                |   12 
 drivers/scsi/qla2xxx/qla_os.c                               |    4 
 drivers/scsi/ufs/ti-j721e-ufs.c                             |    1 
 drivers/scsi/ufs/ufs_quirks.h                               |    1 
 drivers/scsi/ufs/ufshcd-pci.c                               |   16 
 drivers/scsi/ufs/ufshcd.c                                   |  130 ++++++-
 drivers/scsi/ufs/ufshcd.h                                   |   38 ++
 drivers/spi/Kconfig                                         |    3 
 drivers/spi/spi-stm32.c                                     |   27 +
 drivers/spi/spi.c                                           |   21 +
 drivers/target/target_core_user.c                           |    2 
 drivers/vfio/pci/vfio_pci_private.h                         |    2 
 drivers/vfio/pci/vfio_pci_rdwr.c                            |  120 +++++-
 drivers/vfio/vfio_iommu_type1.c                             |   71 +++-
 drivers/video/fbdev/efifb.c                                 |    2 
 drivers/virtio/virtio_ring.c                                |    3 
 drivers/xen/swiotlb-xen.c                                   |    8 
 fs/afs/dynroot.c                                            |   20 -
 fs/afs/fs_operation.c                                       |    1 
 fs/ceph/mds_client.c                                        |    3 
 fs/eventpoll.c                                              |   26 -
 fs/ext4/block_validity.c                                    |   87 ++--
 fs/ext4/ext4.h                                              |    6 
 fs/ext4/extents.c                                           |   16 
 fs/ext4/file.c                                              |    4 
 fs/ext4/indirect.c                                          |    6 
 fs/ext4/inode.c                                             |    5 
 fs/ext4/mballoc.c                                           |    4 
 fs/ext4/namei.c                                             |   22 -
 fs/f2fs/compress.c                                          |    6 
 fs/f2fs/node.c                                              |   10 
 fs/fat/fatent.c                                             |    3 
 fs/io_uring.c                                               |   33 +
 fs/jbd2/journal.c                                           |    4 
 fs/jffs2/dir.c                                              |    6 
 fs/romfs/storage.c                                          |    4 
 fs/signalfd.c                                               |   10 
 fs/squashfs/block.c                                         |    6 
 fs/xfs/xfs_sysfs.h                                          |    6 
 fs/xfs/xfs_trans_dquot.c                                    |    2 
 include/linux/pgtable.h                                     |    2 
 include/linux/sched/user.h                                  |    3 
 kernel/bpf/task_iter.c                                      |    3 
 kernel/events/uprobes.c                                     |    2 
 kernel/relay.c                                              |    1 
 kernel/watch_queue.c                                        |    8 
 mm/khugepaged.c                                             |    2 
 mm/memory.c                                                 |    3 
 mm/page_alloc.c                                             |    7 
 mm/vmalloc.c                                                |    2 
 net/can/j1939/socket.c                                      |   14 
 net/can/j1939/transport.c                                   |   89 ++++-
 net/core/filter.c                                           |   75 +++-
 net/netfilter/nft_exthdr.c                                  |    4 
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c                     |    2 
 scripts/kconfig/qconf.cc                                    |   72 ++--
 sound/hda/hdac_bus.c                                        |   12 
 sound/hda/hdac_controller.c                                 |   11 
 sound/pci/hda/patch_realtek.c                               |    2 
 sound/soc/amd/renoir/acp3x-pdm-dma.c                        |   29 -
 sound/soc/codecs/msm8916-wcd-analog.c                       |    4 
 sound/soc/intel/atom/sst-mfld-platform-pcm.c                |    5 
 sound/soc/qcom/qdsp6/q6afe-dai.c                            |  210 ++++++------
 sound/soc/qcom/qdsp6/q6routing.c                            |   16 
 tools/bpf/bpftool/gen.c                                     |    8 
 tools/lib/bpf/libbpf.c                                      |   16 
 tools/testing/selftests/bpf/.gitignore                      |    1 
 tools/testing/selftests/bpf/Makefile                        |    2 
 tools/testing/selftests/cgroup/cgroup_util.c                |    2 
 tools/testing/selftests/kvm/x86_64/debug_regs.c             |    4 
 virt/kvm/kvm_main.c                                         |    3 
 156 files changed, 1385 insertions(+), 719 deletions(-)

Adrian Hunter (2):
      scsi: ufs-pci: Add quirk for broken auto-hibernate for Intel EHL
      scsi: ufs: Fix interrupt error message for shared interrupts

Al Viro (1):
      do_epoll_ctl(): clean the failure exits up a bit

Alex Deucher (1):
      Revert "drm/amd/display: Improve DisplayPort monitor interop"

Alex Williamson (2):
      vfio-pci: Avoid recursive read-lock usage
      vfio/type1: Add proper error unwind for vfio_iommu_replay()

Alim Akhtar (4):
      scsi: ufs: Add quirk to fix mishandling utrlclr/utmrlclr
      scsi: ufs: Add quirk to disallow reset of interrupt aggregation
      scsi: ufs: Add quirk to enable host controller without hce
      scsi: ufs: Introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk

Amelie Delaunay (1):
      spi: stm32: fixes suspend/resume management

Andrii Nakryiko (2):
      tools/bpftool: Make skeleton code C++17-friendly by dropping typeof()
      libbpf: Fix BTF-defined map-in-map initialization on 32-bit host arches

Aneesh Kumar K.V (1):
      mm/vunmap: add cond_resched() in vunmap_pmd_range

Aric Cyr (1):
      drm/amd/display: Fix incorrect backlight register offset for DCN

Arvind Sankar (4):
      efi/x86: Mark kernel rodata non-executable for mixed mode
      efi/libstub: Stop parsing arguments at "--"
      efi/libstub: Handle NULL cmdline
      efi/libstub: Handle unterminated cmdline

Bodo Stroesser (1):
      scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range on ARM

Boris Ostrovsky (1):
      swiotlb-xen: use vmalloc_to_page on vmalloc virt addresses

Chao Yu (1):
      f2fs: fix to check page dirty status before writeback

Charan Teja Reddy (1):
      mm, page_alloc: fix core hung in free_pcppages_bulk()

Chen Zhou (1):
      media: coda: jpeg: add NULL check after kmalloc

Chris Wilson (2):
      drm/vgem: Replace opencoded version of drm_gem_dumb_map_offset()
      drm/i915: Provide the perf pmu.module

Christophe JAILLET (1):
      drm: amdgpu: Use the correct size when allocating memory

Christophe Leroy (1):
      powerpc/fixmap: Fix the size of the early debug area

Chuck Lever (1):
      svcrdma: Fix another Receive buffer leak

Chuhong Yuan (1):
      media: budget-core: Improve exception handling in budget_register()

Colin Ian King (1):
      of/address: check for invalid range.cpu_addr

Cong Wang (1):
      bonding: fix a potential double-unregister

Daniel Kolesa (1):
      drm/amdgpu/display: use GFP_ATOMIC in dcn20_validate_bandwidth_internal

Darrick J. Wong (1):
      xfs: fix inode quota reservation checks

David Howells (3):
      watch_queue: Limit the number of watches a user can hold
      afs: Fix key ref leak in afs_put_operation()
      afs: Fix NULL deref in afs_dynroot_depopulate()

Dinghao Liu (1):
      ASoC: intel: Fix memleak in sst_media_open

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

Felix Kuehling (1):
      drm/ttm: fix offset in VMAs with a pg_offs in ttm_bo_vm_access

Fugang Duan (1):
      net: fec: correct the error path for regulator disable in probe

Gaurav Singh (1):
      tools/testing/selftests/cgroup/cgroup_util.c: cg_read_strcmp: fix null pointer dereference

Greg Kroah-Hartman (1):
      Linux 5.8.4

Greg Ungerer (1):
      m68knommu: fix overwriting of bits in ColdFire V3 cache control

Grzegorz Szczurek (1):
      i40e: Fix crash during removing i40e driver

Guo Ren (1):
      riscv: Fixup static_obj() fail

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
      khugepaged: adjust VM_BUG_ON_MM() in __khugepaged_enter()
      uprobes: __replace_page() avoid BUG in munlock_vma_page()

Hui Wang (1):
      ASoC: amd: renoir: restore two more registers during resume

Jaegeuk Kim (1):
      f2fs: should avoid inode eviction in synchronous path

Jaehyun Chung (1):
      drm/amd/display: Blank stream before destroying HDCP session

Jan Kara (4):
      ext4: do not block RWF_NOWAIT dio write on unallocated space
      ext4: fix checking of directory entry validity for inline directories
      ext4: don't allow overlapping system zones
      ext4: check journal inode extents more carefully

Jann Horn (1):
      romfs: fix uninitialized memory leak in romfs_dev_read()

Jarod Wilson (1):
      bonding: show saner speed for broadcast mode

Javed Hasan (1):
      scsi: libfc: Free skb in fc_disc_gpn_id_resp() for valid cases

Jens Axboe (1):
      io_uring: find and cancel head link async work on files exit

Jessica Clarke (1):
      arch/ia64: Restore arch-specific pgd_offset_k implementation

Jim Mattson (2):
      kvm: x86: Toggling CR4.SMAP does not load PDPTEs in PAE mode
      kvm: x86: Toggling CR4.PKE does not load PDPTEs in PAE mode

Jing Xiangfeng (1):
      scsi: ufs: ti-j721e-ufs: Fix error return in ti_j721e_ufs_probe()

Jinyang He (1):
      MIPS: Fix unable to reserve memory for Crash kernel

Jiri Wiesner (1):
      bonding: fix active-backup failover for current ARP slave

John Fastabend (2):
      bpf: sock_ops ctx access may stomp registers in corner case
      bpf: sock_ops sk access may stomp registers when dst_reg = src_reg

Juergen Gross (1):
      efi: avoid error message when booting under Xen

Kaike Wan (1):
      RDMA/hfi1: Correct an interlock issue for TID RDMA WRITE request

Kiwoong Kim (1):
      scsi: ufs: Add quirk to fix abnormal ocs fatal error

Krunoslav Kovac (1):
      drm/amd/display: fix pow() crashing when given base 0

Li Heng (1):
      efi: add missed destroy_workqueue when efisubsys_init fails

Luc Van Oostenryck (1):
      alpha: fix annotation of io{read,write}{16,32}be()

Lukas Wunner (1):
      spi: Prevent adding devices below an unregistering controller

Mahesh Bandewar (1):
      ipvlan: fix device features

Mao Wenan (1):
      virtio_ring: Avoid loop when vq is broken in virtqueue_poll

Marc Zyngier (1):
      epoll: Keep a reference on files added to the check list

Masahiro Yamada (3):
      kconfig: qconf: do not limit the pop-up menu to the first row
      kconfig: qconf: fix signal connection to invalid slots
      kconfig: qconf: remove qInfo() to get back Qt4 support

Michael Neuling (1):
      powerpc: Fix P10 PVR revision in /proc/cpuinfo for SMT4 cores

Michael Roth (1):
      powerpc/pseries/hotplug-cpu: wait indefinitely for vCPU death

Mike Pozulp (2):
      ALSA: hda/realtek: Add quirk for Samsung Galaxy Flex Book
      ALSA: hda/realtek: Add quirk for Samsung Galaxy Book Ion

Niklas Schnelle (4):
      s390/pci: fix zpci_bus_link_virtfn()
      s390/pci: re-introduce zpci_remove_device()
      s390/pci: fix PF/VF linking on hot plug
      s390/pci: ignore stale configuration request event

OGAWA Hirofumi (1):
      fat: fix fat_ra_init() for data clusters == 0

Oleksij Rempel (4):
      can: j1939: transport: j1939_session_tx_dat(): fix use-after-free read in j1939_tp_txtimer()
      can: j1939: socket: j1939_sk_bind(): make sure ml_priv is allocated
      can: j1939: transport: j1939_simple_recv(): ignore local J1939 messages send not by J1939 stack
      can: j1939: transport: add j1939_session_skb_find_by_offset() function

Pankaj Bharadiya (1):
      drm/i915/pmu: Prefer drm_WARN_ON over WARN_ON

Paul Cercueil (1):
      drm/panel-simple: Fix inverted V/H SYNC for Frida FRD350H54004 panel

Paul Hsieh (1):
      drm/amd/display: Fix DFPstate hang due to view port changed

Phillip Lougher (1):
      squashfs: avoid bio_alloc() failure with 1Mbyte blocks

Przemyslaw Patynowski (1):
      i40e: Set RX_ONLY mode for unicast promiscuous on VLAN

Qi Liu (1):
      drm/virtio: fix missing dma_fence_put() in virtio_gpu_execbuffer_ioctl()

Quinn Tran (1):
      Revert "scsi: qla2xxx: Disable T10-DIF feature with FC-NVMe during probe"

Rajendra Nayak (1):
      opp: Enable resources again if they were disabled earlier

Randy Dunlap (1):
      Fix build error when CONFIG_ACPI is not set/enabled:

Sameer Pujar (1):
      ALSA: hda: avoid reset of sdo_limit

Selvin Xavier (1):
      RDMA/bnxt_re: Do not add user qps to flushlist

Shay Agroskin (2):
      net: ena: Prevent reset after device destruction
      net: ena: Change WARN_ON expression in ena_del_napi_in_range()

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

Stephen Boyd (3):
      opp: Put opp table in dev_pm_opp_set_rate() for empty tables
      opp: Put opp table in dev_pm_opp_set_rate() if _set_opp_bw() fails
      ARM64: vdso32: Install vdso32 from vdso_install

Stephen Suryaputra (1):
      netfilter: nf_tables: nft_exthdr: the presence return value should be little-endian

Stylon Wang (1):
      drm/amd/display: Fix EDID parsing after resume from suspend

Thomas Zimmermann (2):
      drm/ast: Remove unused code paths for AST 1180
      drm/ast: Initialize DRAM type before posting GPU

Tom Rix (1):
      net: dsa: b53: check for timeout

Tony Luck (1):
      EDAC/{i7core,sb,pnd2,skx}: Fix error event severity

Vasant Hegde (1):
      powerpc/pseries: Do not initiate shutdown when system is running on UPS

Veronika Kabatova (1):
      selftests/bpf: Remove test_align leftovers

Vinicius Costa Gomes (1):
      igc: Fix PTP initialization

Wang Hai (1):
      net: gemini: Fix missing free_netdev() in error path of gemini_ethernet_port_probe()

Wei Yongjun (1):
      kernel/relay.c: fix memleak on destroy relay channel

Weihang Li (1):
      Revert "RDMA/hns: Reserve one sge in order to avoid local length error"

Will Deacon (2):
      KVM: Pass MMU notifier range flags to kvm_unmap_hva_range()
      KVM: arm64: Only reschedule if MMU_NOTIFIER_RANGE_BLOCKABLE is not set

Xiongfeng Wang (1):
      Input: psmouse - add a newline when printing 'proto' by sysfs

Xiubo Li (1):
      ceph: fix use-after-free for fsc->mdsc

Yang Shi (1):
      mm/memory.c: skip spurious TLB flush for retried page fault

Yang Weijiang (1):
      selftests: kvm: Use a shorter encoding to clear RAX

Yonghong Song (1):
      bpf: Use get_file_rcu() instead of get_file() for task_file iterator

Zhang Changzhong (4):
      can: j1939: fix support for multipacket broadcast message
      can: j1939: cancel rxtimer on multipacket broadcast session complete
      can: j1939: abort multipacket broadcast session when timeout occurs
      can: j1939: add rxtimer for multipacket broadcast session

Zhe Li (1):
      jffs2: fix UAF problem

zhangyi (F) (1):
      jbd2: add the missing unlock_buffer() in the error path of jbd2_write_superblock()

