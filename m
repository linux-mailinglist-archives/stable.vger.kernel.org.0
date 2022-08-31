Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2AA5A832B
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 18:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiHaQ1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 12:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbiHaQ1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 12:27:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4CED51CB;
        Wed, 31 Aug 2022 09:26:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D2E6B821E9;
        Wed, 31 Aug 2022 16:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDB5C433C1;
        Wed, 31 Aug 2022 16:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661963208;
        bh=SnBESrAiWDpof7n+2RYDvVABW4f8ChOSVW9iViOM7r4=;
        h=From:To:Cc:Subject:Date:From;
        b=vQvYcMsYNsbkVyPwrKk9NZZxXRtHepT4MJhyuygDVeHaT08SZ91MpdPErYys9xuzu
         hJECmnsuQhtVahJ6dD/h0wwPKbJtajfmlLwSVP8fi5aTcj/gXJ7/iUihzgfQiUaDQY
         /P2t0oDD8572f+7ByFlspXMaMA88hi9Dd9yR5jJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.19.6
Date:   Wed, 31 Aug 2022 18:26:44 +0200
Message-Id: <16619632046269@kroah.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.19.6 kernel.

All users of the 5.19 kernel series must upgrade.

The updated 5.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-devices-system-cpu              |    1 
 Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst |   14 
 Documentation/admin-guide/kernel-parameters.txt                 |    2 
 Documentation/admin-guide/sysctl/net.rst                        |    2 
 Makefile                                                        |    2 
 arch/arm64/include/asm/fpsimd.h                                 |    4 
 arch/arm64/include/asm/setup.h                                  |   17 
 arch/arm64/kernel/cpu_errata.c                                  |    2 
 arch/arm64/kernel/fpsimd.c                                      |   21 -
 arch/arm64/kernel/ptrace.c                                      |    6 
 arch/arm64/kernel/signal.c                                      |   12 
 arch/arm64/mm/mmu.c                                             |   18 -
 arch/parisc/Kconfig                                             |   21 -
 arch/parisc/kernel/unaligned.c                                  |    2 
 arch/riscv/boot/dts/microchip/mpfs-icicle-kit.dts               |    3 
 arch/riscv/boot/dts/microchip/mpfs-polarberry.dts               |    3 
 arch/riscv/boot/dts/microchip/mpfs.dtsi                         |    5 
 arch/riscv/include/asm/signal.h                                 |   12 
 arch/riscv/include/asm/thread_info.h                            |    2 
 arch/riscv/kernel/signal.c                                      |    1 
 arch/riscv/kernel/traps.c                                       |    3 
 arch/s390/kernel/process.c                                      |   22 -
 arch/s390/mm/fault.c                                            |    4 
 arch/x86/boot/compressed/misc.h                                 |   12 
 arch/x86/boot/compressed/sev.c                                  |    8 
 arch/x86/entry/entry_64_compat.S                                |    2 
 arch/x86/events/intel/ds.c                                      |   12 
 arch/x86/events/intel/lbr.c                                     |    8 
 arch/x86/events/intel/uncore_snb.c                              |   18 -
 arch/x86/include/asm/cpufeatures.h                              |    5 
 arch/x86/include/asm/nospec-branch.h                            |   92 ++---
 arch/x86/kernel/cpu/bugs.c                                      |   14 
 arch/x86/kernel/cpu/common.c                                    |   42 +-
 arch/x86/kernel/sev.c                                           |   16 
 arch/x86/kernel/unwind_orc.c                                    |   15 
 arch/x86/mm/pat/memtype.c                                       |   10 
 block/blk-mq.c                                                  |    5 
 drivers/acpi/processor_thermal.c                                |    2 
 drivers/android/binder_alloc.c                                  |   31 +
 drivers/block/loop.c                                            |    5 
 drivers/block/zram/zram_drv.c                                   |   42 +-
 drivers/block/zram/zram_drv.h                                   |    1 
 drivers/gpu/drm/amd/amdkfd/kfd_device.c                         |    6 
 drivers/gpu/drm/nouveau/nouveau_bo.c                            |    9 
 drivers/md/md.c                                                 |    3 
 drivers/net/bonding/bond_3ad.c                                  |   38 --
 drivers/net/dsa/microchip/ksz8795.c                             |  102 +----
 drivers/net/dsa/microchip/ksz8795_reg.h                         |   16 
 drivers/net/dsa/microchip/ksz9477.c                             |   89 +----
 drivers/net/dsa/microchip/ksz9477_reg.h                         |    1 
 drivers/net/dsa/microchip/ksz_common.c                          |  173 +++++++++-
 drivers/net/dsa/microchip/ksz_common.h                          |   47 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                       |    5 
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                       |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c               |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c                 |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c                   |   10 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                  |    2 
 drivers/net/ethernet/intel/ice/ice.h                            |   36 +-
 drivers/net/ethernet/intel/ice/ice_lib.c                        |    4 
 drivers/net/ethernet/intel/ice/ice_main.c                       |   25 -
 drivers/net/ethernet/intel/ice/ice_xsk.c                        |   18 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c                    |   59 ++-
 drivers/net/ethernet/lantiq_xrx200.c                            |    9 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                     |   29 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.h                     |    5 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c               |   12 
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c                |    2 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c      |    3 
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c               |   57 +--
 drivers/net/ethernet/mellanox/mlx5/core/main.c                  |    4 
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c             |    9 
 drivers/net/ethernet/moxa/moxart_ether.c                        |   11 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c                 |   95 +++++
 drivers/net/ethernet/pensando/ionic/ionic_main.c                |    4 
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c                 |    8 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c               |    9 
 drivers/net/ipa/ipa_mem.c                                       |    2 
 drivers/net/ipvlan/ipvtap.c                                     |    4 
 drivers/net/macsec.c                                            |   11 
 drivers/net/phy/phy_device.c                                    |    8 
 drivers/net/usb/r8152.c                                         |   27 -
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c            |    2 
 drivers/net/wireless/mediatek/mt76/mt7921/main.c                |   47 ++
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c                 |    5 
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h              |    2 
 drivers/nfc/pn533/uart.c                                        |    1 
 drivers/scsi/scsi_lib.c                                         |    3 
 drivers/scsi/storvsc_drv.c                                      |    2 
 drivers/video/fbdev/core/fbcon.c                                |   27 +
 drivers/xen/privcmd.c                                           |   21 -
 fs/btrfs/block-group.c                                          |   47 --
 fs/btrfs/block-group.h                                          |    4 
 fs/btrfs/ctree.h                                                |    1 
 fs/btrfs/dev-replace.c                                          |    5 
 fs/btrfs/extent-tree.c                                          |   30 -
 fs/btrfs/file.c                                                 |    2 
 fs/btrfs/root-tree.c                                            |    5 
 fs/btrfs/volumes.c                                              |    5 
 fs/btrfs/xattr.c                                                |    3 
 fs/cifs/smb2ops.c                                               |   12 
 fs/cifs/smb2pdu.c                                               |   16 
 fs/fs-writeback.c                                               |   12 
 fs/namespace.c                                                  |    7 
 fs/nfs/file.c                                                   |   15 
 fs/nfs/inode.c                                                  |    1 
 fs/nfs/nfs4file.c                                               |    6 
 fs/nfs/write.c                                                  |    6 
 fs/ntfs3/xattr.c                                                |   16 
 fs/ocfs2/dlmglue.c                                              |    8 
 fs/ocfs2/super.c                                                |    3 
 fs/proc/task_mmu.c                                              |    7 
 fs/userfaultfd.c                                                |    4 
 include/asm-generic/sections.h                                  |    7 
 include/linux/memcontrol.h                                      |   15 
 include/linux/mlx5/driver.h                                     |    1 
 include/linux/mm.h                                              |    1 
 include/linux/netdevice.h                                       |   20 -
 include/linux/netfilter_bridge/ebtables.h                       |    4 
 include/linux/nfs_fs.h                                          |    1 
 include/linux/userfaultfd_k.h                                   |    2 
 include/net/busy_poll.h                                         |    2 
 include/net/gro.h                                               |    2 
 include/net/netfilter/nf_flow_table.h                           |    3 
 include/net/netfilter/nf_tables.h                               |    1 
 include/ufs/ufshci.h                                            |    6 
 init/main.c                                                     |   18 -
 io_uring/io_uring.c                                             |    7 
 kernel/audit_fsnotify.c                                         |    1 
 kernel/auditsc.c                                                |    4 
 kernel/bpf/verifier.c                                           |   10 
 kernel/cgroup/cgroup.c                                          |    1 
 kernel/kprobes.c                                                |    9 
 kernel/sys_ni.c                                                 |    1 
 lib/ratelimit.c                                                 |   12 
 mm/backing-dev.c                                                |   10 
 mm/bootmem_info.c                                               |    2 
 mm/damon/dbgfs.c                                                |    3 
 mm/gup.c                                                        |   69 ++-
 mm/huge_memory.c                                                |   65 ++-
 mm/hugetlb.c                                                    |   28 +
 mm/mmap.c                                                       |    8 
 mm/mprotect.c                                                   |    3 
 mm/page-writeback.c                                             |    6 
 mm/shmem.c                                                      |    1 
 mm/userfaultfd.c                                                |   29 +
 net/bridge/netfilter/ebtable_broute.c                           |    8 
 net/bridge/netfilter/ebtable_filter.c                           |    8 
 net/bridge/netfilter/ebtable_nat.c                              |    8 
 net/bridge/netfilter/ebtables.c                                 |    8 
 net/core/bpf_sk_storage.c                                       |    5 
 net/core/dev.c                                                  |   20 -
 net/core/filter.c                                               |   13 
 net/core/gro_cells.c                                            |    2 
 net/core/skbuff.c                                               |    2 
 net/core/sock.c                                                 |   18 -
 net/core/sysctl_net_core.c                                      |   15 
 net/ipv4/devinet.c                                              |   16 
 net/ipv4/ip_output.c                                            |    2 
 net/ipv4/ip_sockglue.c                                          |    6 
 net/ipv4/tcp.c                                                  |    4 
 net/ipv4/tcp_output.c                                           |    2 
 net/ipv6/addrconf.c                                             |    5 
 net/ipv6/ipv6_sockglue.c                                        |    4 
 net/key/af_key.c                                                |    3 
 net/mptcp/protocol.c                                            |    2 
 net/netfilter/ipvs/ip_vs_sync.c                                 |    4 
 net/netfilter/nf_flow_table_core.c                              |   15 
 net/netfilter/nf_flow_table_offload.c                           |    8 
 net/netfilter/nf_tables_api.c                                   |   14 
 net/netfilter/nft_osf.c                                         |   18 -
 net/netfilter/nft_payload.c                                     |   29 +
 net/netfilter/nft_tproxy.c                                      |    8 
 net/netfilter/nft_tunnel.c                                      |    1 
 net/rose/rose_loopback.c                                        |    3 
 net/rxrpc/call_object.c                                         |    4 
 net/rxrpc/sendmsg.c                                             |   92 +++--
 net/sched/sch_generic.c                                         |    2 
 net/socket.c                                                    |    2 
 net/sunrpc/clnt.c                                               |    2 
 net/xfrm/espintcp.c                                             |    2 
 net/xfrm/xfrm_input.c                                           |    3 
 net/xfrm/xfrm_output.c                                          |    1 
 net/xfrm/xfrm_policy.c                                          |    3 
 net/xfrm/xfrm_state.c                                           |    1 
 tools/perf/Makefile.config                                      |    2 
 tools/perf/builtin-stat.c                                       |    1 
 187 files changed, 1602 insertions(+), 916 deletions(-)

Aleksander Jan Bajkowski (3):
      net: lantiq_xrx200: confirm skb is allocated before using
      net: lantiq_xrx200: fix lock under memory pressure
      net: lantiq_xrx200: restore buffer if memory allocation failed

Alex Elder (1):
      net: ipa: don't assume SMEM is page-aligned

Anand Jain (2):
      btrfs: replace: drop assert for suspended replace
      btrfs: add info when mount fails due to stale replace target

Antony Antony (2):
      Revert "xfrm: update SA curlft.use_time"
      xfrm: clone missing x->lastused in xfrm_do_migrate

Arun Ramadoss (6):
      net: dsa: microchip: ksz9477: cleanup the ksz9477_switch_detect
      net: dsa: microchip: move switch chip_id detection to ksz_common
      net: dsa: microchip: move tag_protocol to ksz_common
      net: dsa: microchip: move vlan functionality to ksz_common
      net: dsa: microchip: move the port mirror to ksz_common
      net: dsa: microchip: update the ksz_phylink_get_caps

Aya Levin (1):
      net/mlx5e: Fix wrong application of the LRO state

Badari Pulavarty (1):
      mm/damon/dbgfs: avoid duplicate context directory creation

Bernard Pidoux (1):
      rose: check NULL rose_loopback_neigh->loopback

Brian Foster (1):
      s390: fix double free of GS and RI CBs on fork() failure

Chen Zhongjin (1):
      x86/unwind/orc: Unwind ftrace trampolines with correct ORC entry

Christian Brauner (1):
      ntfs: fix acl handling

Conor Dooley (6):
      riscv: signal: fix missing prototype warning
      riscv: traps: add missing prototype
      riscv: dts: microchip: mpfs: fix incorrect pcie child node name
      riscv: dts: microchip: mpfs: remove ti,fifo-depth property
      riscv: dts: microchip: mpfs: remove bogus card-detect-delay
      riscv: dts: microchip: mpfs: remove pci axi address translation property

Daniel Borkmann (1):
      bpf: Don't use tnum_range on array range checking for poke descriptors

David Hildenbrand (3):
      mm/gup: fix FOLL_FORCE COW security issue and remove FOLL_COW
      mm/hugetlb: support write-faults in shared mappings
      mm/hugetlb: fix hugetlb not supporting softdirty tracking

David Howells (2):
      rxrpc: Fix locking in rxrpc's sendmsg
      smb3: missing inode locks in punch hole

Deren Wu (1):
      mt76: mt7921: fix command timeout in AP stop period

Duoming Zhou (1):
      nfc: pn533: Fix use-after-free bugs caused by pn532_cmd_timeout

Eli Cohen (2):
      net/mlx5: LAG, fix logic over MLX5_LAG_FLAG_NDEVS_READY
      net/mlx5: Eswitch, Fix forwarding decision to uplink

Filipe Manana (2):
      btrfs: fix silent failure when deleting root reference
      btrfs: update generation of hole file extent item when merging holes

Florian Westphal (2):
      netfilter: ebtables: reject blobs that don't provide all entry points
      netfilter: nft_tproxy: restrict to prerouting hook

Gaosheng Cui (1):
      audit: fix potential double free on error path from fsnotify_add_inode_mark

Gerald Schaefer (1):
      s390/mm: do not trigger write fault when vma does not allow VM_WRITE

Goldwyn Rodrigues (1):
      btrfs: check if root is readonly while setting security xattr

Greg Kroah-Hartman (1):
      Linux 5.19.6

Guoqing Jiang (2):
      Revert "md-raid: destroy the bitmap after destroying the thread"
      md: call __md_stop_writes in md_stop

Hayes Wang (2):
      r8152: fix the units of some registers for RTL8156A
      r8152: fix the RX FIFO settings when suspending

Heiner Kallweit (1):
      net: stmmac: work around sporadic tx issue on link-up

Heinrich Schuchardt (1):
      riscv: dts: microchip: correct L2 cache interrupts

Helge Deller (2):
      parisc: Make CONFIG_64BIT available for ARCH=parisc64 only
      parisc: Fix exception handler for fldw and fstw instructions

Heming Zhao (1):
      ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown

Herbert Xu (1):
      af_key: Do not call xfrm_probe_algs in parallel

Ian Rogers (1):
      perf stat: Clear evsel->reset_group for each stat run

Jacob Keller (1):
      ixgbe: stop resetting SYSTIME in ixgbe_ptp_start_cyclecounter

James Clark (1):
      perf python: Fix build when PYTHON_CONFIG is user supplied

Jan Beulich (1):
      x86/PAT: Have pat_enabled() properly reflect state when running on Xen

Jens Axboe (1):
      io_uring: fix issue with io_write() not always undoing sb_start_write()

Jing-Ting Wu (1):
      cgroup: Fix race condition at rebind_subsystems()

Jiri Slaby (1):
      Revert "zram: remove double compression logic"

Jonathan Toppins (1):
      bonding: 802.3ad: fix no transmission of LACPDUs

Juergen Gross (2):
      x86/entry: Fix entry_INT80_compat for Xen PV guests
      xen/privcmd: fix error exit of privcmd_ioctl_dm_op()

Kan Liang (2):
      perf/x86/intel: Fix pebs event constraints for ADL
      perf/x86/lbr: Enable the branch type for the Arch LBR by default

Karol Herbst (1):
      nouveau: explicitly wait on the fence in nouveau_bo_move_m2mf

Khazhismel Kumykov (1):
      writeback: avoid use-after-free after removing device

Kiwoong Kim (1):
      scsi: ufs: core: Enable link lost interrupt

Kuniyuki Iwashima (18):
      kprobes: don't call disarm_kprobe() for disabled kprobes
      net: Fix data-races around sysctl_[rw]mem_(max|default).
      net: Fix data-races around weight_p and dev_weight_[rt]x_bias.
      net: Fix data-races around netdev_max_backlog.
      net: Fix data-races around netdev_tstamp_prequeue.
      ratelimit: Fix data-races in ___ratelimit().
      net: Fix data-races around sysctl_optmem_max.
      net: Fix a data-race around sysctl_tstamp_allow_data.
      net: Fix a data-race around sysctl_net_busy_poll.
      net: Fix a data-race around sysctl_net_busy_read.
      net: Fix a data-race around netdev_budget.
      net: Fix data-races around sysctl_max_skb_frags.
      net: Fix a data-race around netdev_budget_usecs.
      net: Fix data-races around sysctl_fb_tunnels_only_for_init_net.
      net: Fix data-races around sysctl_devconf_inherit_init_net.
      net: Fix a data-race around gro_normal_batch.
      net: Fix a data-race around netdev_unregister_timeout_secs.
      net: Fix a data-race around sysctl_somaxconn.

Liam Howlett (1):
      binder_alloc: add missing mmap_lock calls when using the VMA

Liu Shixin (1):
      bootmem: remove the vmemmap pages from kmemleak in put_page_bootmem

Lorenzo Bianconi (2):
      net: ethernet: mtk_eth_soc: enable rx cksum offload for MTK_NETSYS_V2
      net: ethernet: mtk_eth_soc: fix hw hash reporting for MTK_NETSYS_V2

Maciej Fijalkowski (2):
      ice: xsk: prohibit usage of non-balanced queue id
      ice: xsk: use Rx ring's XDP ring when picking NAPI context

Maciej Żenczykowski (1):
      net: ipvtap - add __init/__exit annotations to module init/exit funcs

Maor Dickman (1):
      net/mlx5e: Fix wrong tc flag used when set hw-tc-offload off

Mark Brown (3):
      arm64/signal: Flush FPSIMD register state when disabling streaming mode
      arm64/sme: Don't flush SVE register state when allocating SME storage
      arm64/sme: Don't flush SVE register state when handling SME traps

Mark Rutland (1):
      arm64: fix rodata=full

Matthew Wilcox (Oracle) (1):
      shmem: update folio if shmem_replace_page() updates the page

Miaohe Lin (1):
      mm/hugetlb: avoid corrupting page->mapping in hugetlb_mcopy_atomic_pte

Michael Roth (1):
      x86/boot: Don't propagate uninitialized boot_params->cc_blob_address

Mike Christie (1):
      scsi: core: Fix passthrough retry counter handling

Moshe Shemesh (1):
      net/mlx5: Avoid false positive lockdep warning by adding lock_class_key

Nikolay Aleksandrov (1):
      xfrm: policy: fix metadata dst->dev xmit null pointer dereference

Olga Kornievskaia (1):
      NFSv4.2 fix problems with __nfs42_ssc_open

Omar Sandoval (1):
      btrfs: fix space cache corruption and potential double allocations

Pablo Neira Ayuso (10):
      netfilter: nf_tables: disallow updates of implicit chain
      netfilter: nf_tables: make table handle allocation per-netns friendly
      netfilter: nft_payload: report ERANGE for too long offset and length
      netfilter: nft_payload: do not truncate csum_offset and csum_type
      netfilter: nf_tables: do not leave chain stats enabled on error
      netfilter: nft_osf: restrict osf to ipv4, ipv6 and inet families
      netfilter: nft_tunnel: restrict it to netdev family
      netfilter: nf_tables: disallow binding to already bound chain
      netfilter: flowtable: add function to invoke garbage collection immediately
      netfilter: flowtable: fix stuck flows on cleanup due to pending work

Paulo Alcantara (1):
      cifs: skip extra NULL byte in filenames

Pavan Chebbi (1):
      bnxt_en: Use PAGE_SIZE to init buffer when multi buffer XDP is not in use

Pawan Gupta (1):
      x86/bugs: Add "unknown" reporting for MMIO Stale Data

Peter Xu (3):
      mm/uffd: reset write protection when unregister with wp-mode
      mm/smaps: don't access young/dirty bit if pte unpresent
      mm/mprotect: only reference swap pfn page if type match

Peter Zijlstra (2):
      x86/nospec: Unwreck the RSB stuffing
      x86/nospec: Fix i386 RSB stuffing

Prike Liang (1):
      drm/amdkfd: Fix isa version for the GC 10.3.7

Quanyang Wang (1):
      asm-generic: sections: refactor memory_intersects

R Mohamed Shah (1):
      ionic: VF initial random MAC address if no assigned mac

Randy Dunlap (1):
      kernel/sys_ni: add compat entry for fadvise64_64

Richard Guy Briggs (1):
      audit: move audit_return_fixup before the filters

Riwen Lu (1):
      ACPI: processor: Remove freq Qos request for all CPUs

Roy Novich (1):
      net/mlx5: Fix cmd error logging for manage pages cmd

Sabrina Dubroca (1):
      Revert "net: macsec: update SCI upon MAC address change."

Salvatore Bonaccorso (1):
      Documentation/ABI: Mention retbleed vulnerability info file for sysfs

Saurabh Sengar (1):
      scsi: storvsc: Remove WQ_MEM_RECLAIM from storvsc_error_wq

Sergei Antonov (1):
      net: moxa: get rid of asymmetry in DMA mapping/unmapping

Seth Forshee (1):
      fs: require CAP_SYS_ADMIN in target namespace for idmapped mounts

Shakeel Butt (1):
      Revert "memcg: cleanup racy sum avoidance code"

Shannon Nelson (2):
      ionic: clear broken state on generation change
      ionic: fix up issues with handling EAGAIN on FW cmds

Shigeru Yoshida (1):
      fbdev: fbcon: Properly revert changes when vc_resize() failed

Siddh Raman Pant (1):
      loop: Check for overflow while configuring loop

Stephane Eranian (2):
      perf/x86/intel/uncore: Fix broken read_counter() for SNB IMC PMU
      perf/x86/intel/ds: Fix precise store latency handling

Sylwester Dziedziuch (1):
      i40e: Fix incorrect address type for IPv6 flow rules

Tom Lendacky (1):
      x86/sev: Don't use cc_platform_has() for early SEV-SNP calls

Trond Myklebust (2):
      NFS: Fix another fsync() issue after a server reboot
      SUNRPC: RPC level errors should set task->tk_rpc_status

Vikas Gupta (3):
      bnxt_en: set missing reload flag in devlink features
      bnxt_en: fix NQ resource accounting during vf creation on 57500 chips
      bnxt_en: fix LRO/GRO_HW features in ndo_fix_features callback

Vlad Buslov (2):
      net/mlx5e: Properly disable vlan strip on non-UL reps
      net/mlx5: Disable irq when locking lag_lock

Vladimir Oltean (1):
      net: dsa: microchip: keep compatibility with device tree blobs with no phy-mode

Xiaolei Wang (1):
      net: phy: Don't WARN for PHY_READY state in mdio_bus_phy_resume()

Xin Xiong (1):
      xfrm: fix refcount leak in __xfrm_policy_check()

Yu Kuai (1):
      blk-mq: fix io hung due to missing commit_rqs

Zenghui Yu (1):
      arm64: Fix match_list for erratum 1286807 on Arm Cortex-A76

Zixuan Fu (1):
      btrfs: fix possible memory leak in btrfs_get_dev_args_from_path()

