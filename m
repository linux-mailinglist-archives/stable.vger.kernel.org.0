Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A8A2B926E
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 13:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbgKSMPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 07:15:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:52114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726830AbgKSMPk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Nov 2020 07:15:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A963A206D5;
        Thu, 19 Nov 2020 12:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605788139;
        bh=zXVCFAWNBW0/YcL2y9lvup5bEWN5ZVlBqKnhLbNftGU=;
        h=From:To:Cc:Subject:Date:From;
        b=EGcoV8ANSNVBBuUyIS0r2jwxH+vcE+eNwr7pTYLNcjenuC2fc5PP7DkG5hhvszefv
         t1QiP0XI0Ewaq5muiSnExrjhLT6+sRCxjcJVUZPs1jaoUpZAlvZINrCJHXJDaaDwYV
         XkLMBiin+JvQrxSosVwWWMs1Of3YstJHKELK4EAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.78
Date:   Thu, 19 Nov 2020 13:16:22 +0100
Message-Id: <160578818298222@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.78 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/j1939.rst                               |    4 
 Makefile                                                         |    2 
 arch/arm/include/asm/kprobes.h                                   |   22 
 arch/arm/probes/kprobes/opt-arm.c                                |   18 
 arch/arm64/kvm/sys_regs.c                                        |   18 
 arch/powerpc/kernel/eeh_cache.c                                  |    5 
 arch/powerpc/kernel/head_32.S                                    |   12 
 arch/riscv/kernel/head.S                                         |    5 
 arch/s390/kernel/smp.c                                           |    3 
 arch/x86/kernel/cpu/bugs.c                                       |   52 -
 arch/x86/kvm/x86.c                                               |    4 
 drivers/block/nbd.c                                              |   10 
 drivers/char/random.c                                            |    1 
 drivers/char/tpm/eventlog/efi.c                                  |    5 
 drivers/char/tpm/tpm_tis.c                                       |   29 
 drivers/char/virtio_console.c                                    |    8 
 drivers/gpio/gpio-pcie-idio-24.c                                 |   62 +
 drivers/gpu/drm/amd/amdgpu/cik_sdma.c                            |   27 
 drivers/gpu/drm/amd/amdgpu/soc15.c                               |    3 
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c                 |    4 
 drivers/gpu/drm/amd/powerplay/inc/hwmgr.h                        |    1 
 drivers/gpu/drm/amd/powerplay/inc/smumgr.h                       |    2 
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c                 |   29 
 drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c                    |    8 
 drivers/gpu/drm/gma500/psb_irq.c                                 |   34 
 drivers/gpu/drm/i915/gem/i915_gem_domain.c                       |   28 
 drivers/gpu/drm/i915/gt/intel_engine_cs.c                        |    3 
 drivers/hv/hv_balloon.c                                          |    2 
 drivers/i2c/busses/i2c-mt65xx.c                                  |    8 
 drivers/i2c/busses/i2c-sh_mobile.c                               |   86 +
 drivers/iommu/amd_iommu_types.h                                  |    6 
 drivers/iommu/intel-svm.c                                        |    2 
 drivers/mfd/sprd-sc27xx-spi.c                                    |   28 
 drivers/misc/mei/client.h                                        |    4 
 drivers/mmc/host/renesas_sdhi_core.c                             |    1 
 drivers/mmc/host/sdhci-of-esdhc.c                                |    2 
 drivers/net/can/dev.c                                            |   14 
 drivers/net/can/flexcan.c                                        |    5 
 drivers/net/can/peak_canfd/peak_canfd.c                          |   11 
 drivers/net/can/rx-offload.c                                     |    4 
 drivers/net/can/ti_hecc.c                                        |    8 
 drivers/net/can/usb/peak_usb/pcan_usb_core.c                     |   51 -
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c                       |   48 -
 drivers/net/can/xilinx_can.c                                     |    6 
 drivers/net/ethernet/intel/igc/igc_main.c                        |   14 
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c                |    7 
 drivers/net/ethernet/microchip/lan743x_main.c                    |   12 
 drivers/net/ethernet/microchip/lan743x_main.h                    |    3 
 drivers/net/ethernet/realtek/r8169_main.c                        |    3 
 drivers/net/vrf.c                                                |   92 +
 drivers/net/wan/cosa.c                                           |    1 
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                    |    2 
 drivers/nvme/host/core.c                                         |    8 
 drivers/nvme/host/nvme.h                                         |    1 
 drivers/nvme/host/rdma.c                                         |   14 
 drivers/nvme/host/tcp.c                                          |   16 
 drivers/of/address.c                                             |    4 
 drivers/opp/core.c                                               |    7 
 drivers/pci/controller/dwc/pcie-qcom.c                           |   13 
 drivers/pinctrl/aspeed/pinctrl-aspeed.c                          |    7 
 drivers/pinctrl/intel/pinctrl-intel.c                            |    8 
 drivers/pinctrl/pinctrl-amd.c                                    |    6 
 drivers/scsi/device_handler/scsi_dh_alua.c                       |    9 
 drivers/scsi/hpsa.c                                              |    4 
 drivers/scsi/mpt3sas/mpt3sas_base.c                              |    7 
 drivers/spi/spi-bcm2835.c                                        |    3 
 drivers/thunderbolt/nhi.c                                        |   19 
 drivers/thunderbolt/xdomain.c                                    |    1 
 drivers/uio/uio.c                                                |   10 
 drivers/usb/class/cdc-acm.c                                      |    9 
 drivers/usb/dwc3/dwc3-pci.c                                      |    4 
 drivers/usb/dwc3/gadget.c                                        |   32 
 drivers/usb/gadget/udc/goku_udc.c                                |    2 
 drivers/usb/host/xhci-histb.c                                    |    2 
 drivers/vfio/pci/vfio_pci.c                                      |    2 
 drivers/vfio/platform/vfio_platform_common.c                     |    3 
 fs/afs/yfsclient.c                                               |    1 
 fs/btrfs/dev-replace.c                                           |   26 
 fs/btrfs/extent-tree.c                                           |    7 
 fs/btrfs/ioctl.c                                                 |   12 
 fs/btrfs/ref-verify.c                                            |    1 
 fs/btrfs/relocation.c                                            |    4 
 fs/btrfs/volumes.c                                               |   33 
 fs/cifs/cifs_unicode.c                                           |    8 
 fs/erofs/inode.c                                                 |   21 
 fs/ext4/inline.c                                                 |    1 
 fs/ext4/super.c                                                  |    4 
 fs/gfs2/rgrp.c                                                   |    5 
 fs/gfs2/super.c                                                  |    1 
 fs/jbd2/checkpoint.c                                             |    2 
 fs/jbd2/transaction.c                                            |    4 
 fs/ocfs2/super.c                                                 |    1 
 fs/xfs/libxfs/xfs_alloc.c                                        |    1 
 fs/xfs/libxfs/xfs_bmap.h                                         |    2 
 fs/xfs/libxfs/xfs_rmap.c                                         |    2 
 fs/xfs/libxfs/xfs_rmap_btree.c                                   |   16 
 fs/xfs/scrub/bmap.c                                              |    2 
 fs/xfs/scrub/inode.c                                             |    3 
 fs/xfs/scrub/refcount.c                                          |    8 
 fs/xfs/xfs_iops.c                                                |   10 
 fs/xfs/xfs_pnfs.c                                                |    2 
 include/linux/arm-smccc.h                                        |    2 
 include/linux/can/skb.h                                          |   20 
 include/linux/compiler-gcc.h                                     |    2 
 include/linux/compiler_types.h                                   |    4 
 include/linux/netfilter/nfnetlink.h                              |    9 
 include/linux/netfilter_ipv4.h                                   |    2 
 include/linux/netfilter_ipv6.h                                   |   10 
 include/linux/prandom.h                                          |   36 
 include/linux/time64.h                                           |    4 
 include/trace/events/btrfs.h                                     |   10 
 include/trace/events/sunrpc.h                                    |    8 
 kernel/bpf/Makefile                                              |    6 
 kernel/bpf/core.c                                                |    2 
 kernel/bpf/hashtab.c                                             |   30 
 kernel/dma/swiotlb.c                                             |    6 
 kernel/events/core.c                                             |    7 
 kernel/events/internal.h                                         |    2 
 kernel/exit.c                                                    |    5 
 kernel/futex.c                                                   |    5 
 kernel/irq/Kconfig                                               |    1 
 kernel/reboot.c                                                  |   28 
 kernel/time/itimer.c                                             |    4 
 kernel/time/tick-common.c                                        |    2 
 kernel/time/timer.c                                              |    7 
 kernel/trace/trace.c                                             |    4 
 lib/random32.c                                                   |  462 ++++++----
 mm/slub.c                                                        |    2 
 net/can/j1939/socket.c                                           |    6 
 net/ipv4/netfilter.c                                             |    8 
 net/ipv4/netfilter/iptable_mangle.c                              |    2 
 net/ipv4/netfilter/nf_reject_ipv4.c                              |    2 
 net/ipv4/syncookies.c                                            |    9 
 net/ipv4/udp_offload.c                                           |    2 
 net/ipv6/netfilter.c                                             |    6 
 net/ipv6/netfilter/ip6table_mangle.c                             |    2 
 net/ipv6/sit.c                                                   |    2 
 net/ipv6/syncookies.c                                            |   10 
 net/iucv/af_iucv.c                                               |    3 
 net/mac80211/tx.c                                                |   37 
 net/netfilter/ipset/ip_set_core.c                                |    3 
 net/netfilter/ipvs/ip_vs_core.c                                  |    4 
 net/netfilter/nf_nat_proto.c                                     |    4 
 net/netfilter/nf_synproxy_core.c                                 |    2 
 net/netfilter/nf_tables_api.c                                    |   15 
 net/netfilter/nfnetlink.c                                        |   22 
 net/netfilter/nft_chain_route.c                                  |    4 
 net/netfilter/utils.c                                            |    4 
 net/sched/sch_generic.c                                          |    3 
 net/tipc/topsrv.c                                                |   10 
 net/wireless/core.c                                              |   57 -
 net/wireless/core.h                                              |    5 
 net/wireless/nl80211.c                                           |    3 
 net/wireless/reg.c                                               |    2 
 net/x25/af_x25.c                                                 |    2 
 net/xfrm/xfrm_state.c                                            |    8 
 security/selinux/ibpkey.c                                        |    4 
 sound/hda/ext/hdac_ext_controller.c                              |    2 
 sound/pci/hda/hda_controller.h                                   |    3 
 sound/pci/hda/hda_intel.c                                        |   63 -
 sound/soc/codecs/cs42l51.c                                       |   22 
 sound/soc/codecs/wcd9335.c                                       |    2 
 sound/soc/intel/boards/kbl_rt5663_max98927.c                     |   39 
 sound/soc/qcom/sdm845.c                                          |    2 
 tools/perf/builtin-trace.c                                       |   15 
 tools/perf/util/scripting-engines/trace-event-python.c           |    7 
 tools/perf/util/session.c                                        |    1 
 tools/testing/selftests/bpf/prog_tests/map_init.c                |  214 ++++
 tools/testing/selftests/bpf/progs/test_map_init.c                |   33 
 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_user.tc |    4 
 tools/testing/selftests/pidfd/pidfd_open_test.c                  |    1 
 tools/testing/selftests/pidfd/pidfd_poll_test.c                  |    1 
 tools/testing/selftests/proc/proc-loadavg-001.c                  |    1 
 tools/testing/selftests/proc/proc-self-syscall.c                 |    1 
 tools/testing/selftests/proc/proc-uptime-002.c                   |    1 
 virt/kvm/arm/mmu.c                                               |    1 
 virt/kvm/arm/psci.c                                              |    2 
 177 files changed, 1740 insertions(+), 783 deletions(-)

Al Viro (1):
      don't dump the threads that had been already exiting when zapped.

Alexander Lobakin (2):
      virtio: virtio_console: fix DMA memory allocation for rproc serial
      net: udp: fix UDP header access on Fast/frag0 UDP GRO

Alexander Usyskin (1):
      mei: protect mei_cl_mtu from null dereference

Anand Jain (1):
      btrfs: dev-replace: fail mount if we don't have replace item with target device

Anand K Mistry (1):
      x86/speculation: Allow IBPB to be conditionally enabled on CPUs with always-on STIBP

Andrew Jeffery (1):
      ARM: 9019/1: kprobes: Avoid fortify_panic() when copying optprobe template

Andrew Jones (1):
      KVM: arm64: Don't hide ID registers from userspace

Andy Shevchenko (1):
      pinctrl: intel: Set default bias in case no particular value given

Ansuel Smith (1):
      PCI: qcom: Make sure PCIe is reset before init for rev 2.1.0

Ard Biesheuvel (1):
      bpf: Don't rely on GCC __attribute__((optimize)) to disable GCSE

Arnaldo Carvalho de Melo (1):
      perf scripting python: Avoid declaring function pointers with a visibility attribute

Arnaud de Turckheim (3):
      gpio: pcie-idio-24: Fix irq mask when masking
      gpio: pcie-idio-24: Fix IRQ Enable Register value
      gpio: pcie-idio-24: Enable PEX8311 interrupts

Baolin Wang (1):
      mfd: sprd: Add wakeup capability for PMIC IRQ

Billy Tsai (1):
      pinctrl: aspeed: Fix GPI only function problem.

Bob Peterson (3):
      gfs2: Free rd_bits later in gfs2_clear_rgrpd to fix use-after-free
      gfs2: Add missing truncate_inode_pages_final for sd_aspace
      gfs2: check for live vs. read-only file system in gfs2_fitrim

Boris Protopopov (1):
      Convert trailing spaces and periods in path components

Brian Foster (1):
      xfs: flush new eof page on truncate to avoid post-eof corruption

Chao Leng (3):
      nvme: introduce nvme_sync_io_queues
      nvme-rdma: avoid race between time out and tear down
      nvme-tcp: avoid race between time out and tear down

Chen Zhou (1):
      selinux: Fix error return code in sel_ib_pkey_sid_slow()

Chris Brandt (1):
      usb: cdc-acm: Add DISABLE_ECHO for Renesas USB Download mode

Chris Wilson (1):
      drm/i915/gem: Flush coherency domains on first set-domain-ioctl

Christoph Hellwig (2):
      nbd: fix a block_device refcount leak in nbd_release
      xfs: fix a missing unlock on error in xfs_fs_map_blocks

Christophe Leroy (1):
      powerpc/603: Always fault when _PAGE_ACCESSED is not set

Chuck Lever (1):
      SUNRPC: Fix general protection fault in trace_rpc_xdr_overflow()

Chunyan Zhang (1):
      tick/common: Touch watchdog in tick_unfreeze() on all CPUs

Coiby Xu (2):
      pinctrl: amd: use higher precision for 512 RtcClk
      pinctrl: amd: fix incorrect way to disable debounce filter

Colin Ian King (1):
      selftests/ftrace: check for do_sys_openat2 in user-memory test

Dan Carpenter (3):
      ALSA: hda: prevent undefined shift in snd_hdac_ext_bus_get_link()
      can: peak_usb: add range checking in decode operations
      futex: Don't enable IRQs unconditionally in put_pi_state()

Darrick J. Wong (6):
      xfs: set xefi_discard when creating a deferred agfl free log intent item
      xfs: fix scrub flagging rtinherit even if there is no rt device
      xfs: fix flags argument to rmap lookup when converting shared file rmaps
      xfs: set the unwritten bit in rmap lookup flags in xchk_bmap_get_rmapextents
      xfs: fix rmap key and record comparison functions
      xfs: fix brainos in the refcount scrubber's rmap fragment processor

David Howells (1):
      afs: Fix warning due to unadvanced marshalling pointer

David Verbeiren (1):
      bpf: Zero-fill re-used per-cpu map element

Dinghao Liu (1):
      btrfs: ref-verify: fix memory leak in btrfs_ref_tree_mod

Evan Nimmo (1):
      of/address: Fix of_node memory leak in of_dma_is_coherent

Evan Quan (3):
      drm/amdgpu: perform srbm soft reset always on SDMA resume
      drm/amd/pm: perform SMC reset on suspend/hibernation
      drm/amd/pm: do not use ixFEATURE_STATUS for checking smc running

Evgeny Novikov (1):
      usb: gadget: goku_udc: fix potential crashes in probe

Fred Gao (1):
      vfio/pci: Bypass IGD init in case of -ENODEV

Gao Xiang (1):
      erofs: derive atime instead of leaving it empty

George Spelvin (1):
      random32: make prandom_u32() output unpredictable

Greg Kroah-Hartman (1):
      Linux 5.4.78

Hannes Reinecke (1):
      scsi: scsi_dh_alua: Avoid crash during alua_bus_detach()

Heikki Krogerus (1):
      usb: dwc3: pci: add support for the Intel Alder Lake-S

Heiner Kallweit (1):
      r8169: fix potential skb double free in an error path

Jason A. Donenfeld (1):
      netfilter: use actual socket sk rather than skb sk when routing harder

Jerry Snitselaar (1):
      tpm_tis: Disable interrupts on ThinkPad T490s

Jing Xiangfeng (1):
      thunderbolt: Add the missed ida_simple_remove() in ring_request_msix()

Jiri Olsa (2):
      perf tools: Add missing swap for ino_generation
      perf/core: Fix race in the perf_mmap_close() function

Joakim Zhang (2):
      can: flexcan: remove FLEXCAN_QUIRK_DISABLE_MECR quirk for LS1021A
      can: flexcan: flexcan_remove(): disable wakeup completely

Johannes Berg (2):
      mac80211: fix use of skb payload instead of header
      cfg80211: initialize wdev data earlier

Johannes Thumshirn (1):
      btrfs: reschedule when cloning lots of extents

Josef Bacik (2):
      btrfs: sysfs: init devices outside of the chunk_mutex
      btrfs: fix min reserved size calculation in merge_reloc_root

Joseph Qi (1):
      ext4: unlock xattr_sem properly in ext4_inline_data_truncate()

Kai-Heng Feng (2):
      ALSA: hda: Separate runtime and system suspend
      ALSA: hda: Reinstate runtime_allow() for all hda controllers

Kaixu Xia (1):
      ext4: correctly report "not supported" for {usr,grp}jquota when !CONFIG_QUOTA

Keita Suzuki (1):
      scsi: hpsa: Fix memory leak in hpsa_init_one()

Laurent Dufour (1):
      mm/slub: fix panic in slab_alloc_node()

Liu, Yi L (1):
      iommu/vt-d: Fix a bug for PDP check in prq_event_thread

Mao Wenan (1):
      net: Update window_clamp if SOCK_RCVBUF is set

Maor Gottlieb (1):
      net/mlx5: Fix deletion of duplicate rules

Marc Kleine-Budde (1):
      can: rx-offload: don't call kfree_skb() from IRQ context

Marc Zyngier (1):
      genirq: Let GENERIC_IRQ_IPI select IRQ_DOMAIN_HIERARCHY

Martin Hundebøll (1):
      spi: bcm2835: remove use of uninitialized gpio flags variable

Martin Schiller (1):
      net/x25: Fix null-ptr-deref in x25_connect

Martin Willi (1):
      vrf: Fix fast path output packet handling with async Netfilter rules

Masashi Honma (1):
      ath9k_htc: Use appropriate rs_datalen type

Matteo Croce (2):
      Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"
      reboot: fix overflow parsing reboot cpu number

Matthew Wilcox (Oracle) (1):
      btrfs: fix potential overflow in cluster_pages_for_defrag on 32bit arch

Maxim Levitsky (1):
      KVM: x86: don't expose MSR_IA32_UMWAIT_CONTROL unconditionally

Mika Westerberg (1):
      thunderbolt: Fix memory leak if ida_simple_get() fails in enumerate_services()

Ming Lei (1):
      nbd: don't update block size after device is started

Navid Emamdoost (1):
      can: xilinx_can: handle failure cases of pm_runtime_get_sync

Olaf Hering (1):
      hv_balloon: disable warning when floor reached

Oleksij Rempel (1):
      can: can_create_echo_skb(): fix echo skb generation: always use skb_clone()

Oliver Hartkopp (1):
      can: dev: __can_get_echo_skb(): fix real payload length return value for RTR frames

Oliver Herms (1):
      IPv6: Set SIT tunnel hard_header_len to zero

Olivier Moysan (1):
      ASoC: cs42l51: manage mclk shutdown delay

Pablo Neira Ayuso (1):
      netfilter: nf_tables: missing validation from the abort path

Peter Zijlstra (1):
      perf: Fix get_recursion_context()

Qian Cai (2):
      powerpc/eeh_cache: Fix a possible debugfs deadlock
      s390/smp: move rcu_cpu_starting() earlier

Qii Wang (1):
      i2c: mediatek: move dma reset before i2c reset

Qiujun Huang (1):
      tracing: Fix the checking of stackidx in __ftrace_trace_stack

Qu Wenruo (1):
      btrfs: tracepoints: output proper root owner for trace_find_free_extent()

Sagi Grimberg (2):
      nvme-rdma: avoid repeated request completion
      nvme-tcp: avoid repeated request completion

Santosh Shukla (1):
      KVM: arm64: Force PTE mapping on fault resulting in a device mapping

Sean Anderson (1):
      riscv: Set text_offset correctly for M-Mode

Shin'ichiro Kawasaki (1):
      uio: Fix use-after-free in uio_unregister_device()

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix timeouts observed while reenabling IRQ

Srinivas Kandagatla (2):
      ASoC: codecs: wcd9335: Set digital gain range correctly
      ASoC: qcom: sdm845: set driver name correctly

Stanislav Ivanichkin (1):
      perf trace: Fix segfault when trying to trace events by cgroup

Stefano Brivio (1):
      netfilter: ipset: Update byte and packet counters regardless of whether they match

Stefano Stabellini (1):
      swiotlb: fix "x86: Don't panic if can not alloc buffer for swiotlb"

Stephane Grosjean (2):
      can: peak_usb: peak_usb_get_ts_time(): fix timestamp wrapping
      can: peak_canfd: pucan_handle_can_rx(): fix echo management when loopback is on

Stephen Boyd (1):
      KVM: arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return SMCCC_RET_NOT_REQUIRED

Suravee Suthikulpanit (1):
      iommu/amd: Increase interrupt remapping table limit to 512 entries

Sven Van Asbroeck (1):
      lan743x: fix "BUG: invalid wait context" when setting rx mode

Theodore Ts'o (1):
      jbd2: fix up sparse warnings in checkpoint code

Thinh Nguyen (2):
      usb: dwc3: gadget: Continue to process pending requests
      usb: dwc3: gadget: Reclaim extra TRBs after request completion

Thomas Zimmermann (1):
      drm/gma500: Fix out-of-bounds access to struct drm_device.vblank[]

Tomasz Figa (1):
      ASoC: Intel: kbl_rt5663_max98927: Fix kabylake_ssp_fixup function

Tommi Rantala (2):
      selftests: pidfd: fix compilation errors due to wait.h
      selftests: proc: fix warning: _GNU_SOURCE redefined

Tyler Hicks (1):
      tpm: efi: Don't create binary_bios_measurements file for an empty log

Ulrich Hecht (1):
      i2c: sh_mobile: implement atomic transfers

Ursula Braun (1):
      net/af_iucv: fix null pointer dereference on shutdown

Veerabadhran Gopalakrishnan (1):
      amd/amdgpu: Disable VCN DPG mode for Picasso

Venkata Sandeep Dhanalakota (1):
      drm/i915: Correctly set SFC capability for video engines

Vincent Mailhol (1):
      can: dev: can_get_echo_skb(): prevent call to kfree_skb() in hard IRQ context

Vinicius Costa Gomes (1):
      igc: Fix returning wrong statistics

Viresh Kumar (1):
      opp: Reduce the size of critical section in _opp_table_kref_release()

Wang Hai (2):
      cosa: Add missing kfree in error path of cosa_write
      tipc: fix memory leak in tipc_topsrv_start()

Wengang Wang (1):
      ocfs2: initialize ip_next_orphan

Yangbo Lu (1):
      mmc: sdhci-of-esdhc: Handle pulse width detection erratum for more SoCs

Ye Bin (1):
      cfg80211: regulatory: Fix inconsistent format argument

Yegor Yefremov (1):
      can: j1939: swap addr and pgn in the send example

Yoshihiro Shimoda (1):
      mmc: renesas_sdhi_core: Add missing tmio_mmc_host_free() at remove

Yunsheng Lin (1):
      net: sch_generic: fix the missing new qdisc assignment bug

Zeng Tao (1):
      time: Prevent undefined behaviour in timespec64_to_ns()

Zhang Changzhong (2):
      can: j1939: j1939_sk_bind(): return failure if netdev is down
      can: ti_hecc: ti_hecc_probe(): add missed clk_disable_unprepare() in error path

Zhang Qilong (2):
      vfio: platform: fix reference leak in vfio_platform_open
      xhci: hisilicon: fix refercence leak in xhci_histb_probe

zhuoliang zhang (1):
      net: xfrm: fix a race condition during allocing spi

