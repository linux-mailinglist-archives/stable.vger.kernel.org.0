Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B86E5A831F
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 18:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiHaQ00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 12:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiHaQ0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 12:26:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32D49E102;
        Wed, 31 Aug 2022 09:26:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AF57B821E9;
        Wed, 31 Aug 2022 16:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C98C433C1;
        Wed, 31 Aug 2022 16:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661963181;
        bh=XfawmRwXKP5sS2Sjk5VHy4A3A2pZmzx4vHyrUj34yWI=;
        h=From:To:Cc:Subject:Date:From;
        b=Tz7EX7i3Bas7E5bbSecDeauU8n3bCjH3Z+RE76gkJ5VjjB7vLCqPa5i29a8yAtSCV
         pJvMRf+fBGZxOJsEsalkXUG111cQk91j8zh51wM/PZJFJFG+hjfKJCKqSa+ySf8F3M
         sKPzn89HEzrAGBt6VmxKZr3nJRrq9/7I1wbQhmvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.140
Date:   Wed, 31 Aug 2022 18:26:17 +0200
Message-Id: <166196317772156@kroah.com>
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

I'm announcing the release of the 5.10.140 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-devices-system-cpu              |    1 
 Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst |   14 
 Documentation/admin-guide/sysctl/net.rst                        |    2 
 Makefile                                                        |    2 
 arch/arm64/kernel/cpu_errata.c                                  |    2 
 arch/parisc/kernel/unaligned.c                                  |    2 
 arch/s390/kernel/process.c                                      |   22 +
 arch/x86/events/intel/lbr.c                                     |    8 
 arch/x86/events/intel/uncore_snb.c                              |   18 +
 arch/x86/include/asm/cpufeatures.h                              |    5 
 arch/x86/kernel/cpu/bugs.c                                      |   14 
 arch/x86/kernel/cpu/common.c                                    |   42 +-
 arch/x86/kernel/unwind_orc.c                                    |   15 -
 block/blk-mq.c                                                  |    5 
 drivers/acpi/processor_thermal.c                                |    2 
 drivers/block/loop.c                                            |    5 
 drivers/md/md.c                                                 |    3 
 drivers/net/bonding/bond_3ad.c                                  |   38 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c                 |    2 
 drivers/net/ethernet/intel/ice/ice_xsk.c                        |   14 
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c                    |   59 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c                |    2 
 drivers/net/ethernet/moxa/moxart_ether.c                        |   11 
 drivers/net/ethernet/pensando/ionic/ionic_main.c                |    4 
 drivers/net/ipa/ipa_mem.c                                       |    2 
 drivers/net/ipvlan/ipvtap.c                                     |    4 
 drivers/nfc/pn533/uart.c                                        |    1 
 drivers/pinctrl/pinctrl-amd.c                                   |   11 
 drivers/scsi/storvsc_drv.c                                      |    2 
 drivers/scsi/ufs/ufshci.h                                       |    6 
 drivers/xen/privcmd.c                                           |   21 -
 fs/btrfs/dev-replace.c                                          |    5 
 fs/btrfs/root-tree.c                                            |    5 
 fs/btrfs/xattr.c                                                |    3 
 fs/nfs/nfs4file.c                                               |   16 -
 fs/proc/task_mmu.c                                              |    7 
 fs/sync.c                                                       |   48 +--
 fs/xfs/xfs_ioctl.c                                              |    4 
 fs/xfs/xfs_ioctl.h                                              |    5 
 fs/xfs/xfs_super.c                                              |   13 
 include/asm-generic/sections.h                                  |    7 
 include/linux/netdevice.h                                       |   20 +
 include/linux/netfilter_bridge/ebtables.h                       |    4 
 include/linux/sched.h                                           |    4 
 include/net/busy_poll.h                                         |    2 
 include/net/netfilter/nf_tables.h                               |    9 
 include/net/netfilter/nf_tables_core.h                          |    9 
 include/net/sock.h                                              |    8 
 kernel/audit_fsnotify.c                                         |    1 
 kernel/bpf/verifier.c                                           |   10 
 kernel/sys_ni.c                                                 |    1 
 lib/ratelimit.c                                                 |   12 
 mm/huge_memory.c                                                |    4 
 mm/mmap.c                                                       |    8 
 net/bridge/netfilter/ebtable_broute.c                           |    8 
 net/bridge/netfilter/ebtable_filter.c                           |    8 
 net/bridge/netfilter/ebtable_nat.c                              |    8 
 net/bridge/netfilter/ebtables.c                                 |    8 
 net/core/bpf_sk_storage.c                                       |   24 -
 net/core/dev.c                                                  |   18 -
 net/core/filter.c                                               |   13 
 net/core/gro_cells.c                                            |    2 
 net/core/skbuff.c                                               |    2 
 net/core/sock.c                                                 |   18 -
 net/core/sysctl_net_core.c                                      |   15 -
 net/decnet/af_decnet.c                                          |    4 
 net/ipv4/devinet.c                                              |   16 -
 net/ipv4/ip_output.c                                            |    2 
 net/ipv4/ip_sockglue.c                                          |    6 
 net/ipv4/tcp.c                                                  |    6 
 net/ipv4/tcp_input.c                                            |   51 ++-
 net/ipv4/tcp_output.c                                           |    4 
 net/ipv6/addrconf.c                                             |    5 
 net/ipv6/ipv6_sockglue.c                                        |    4 
 net/key/af_key.c                                                |    3 
 net/mptcp/protocol.c                                            |    6 
 net/netfilter/ipvs/ip_vs_sync.c                                 |    4 
 net/netfilter/nf_tables_api.c                                   |   90 +++---
 net/netfilter/nf_tables_core.c                                  |   55 +++
 net/netfilter/nft_bitwise.c                                     |   67 ++--
 net/netfilter/nft_cmp.c                                         |  142 ++++++++--
 net/netfilter/nft_immediate.c                                   |   22 +
 net/netfilter/nft_osf.c                                         |   18 +
 net/netfilter/nft_payload.c                                     |   29 +-
 net/netfilter/nft_range.c                                       |   27 -
 net/netfilter/nft_tunnel.c                                      |    1 
 net/rose/rose_loopback.c                                        |    3 
 net/rxrpc/call_object.c                                         |    4 
 net/rxrpc/sendmsg.c                                             |   92 +++---
 net/sched/sch_generic.c                                         |    2 
 net/socket.c                                                    |    2 
 net/sunrpc/clnt.c                                               |    2 
 net/tipc/socket.c                                               |    2 
 net/xfrm/espintcp.c                                             |    2 
 net/xfrm/xfrm_input.c                                           |    2 
 net/xfrm/xfrm_policy.c                                          |    3 
 net/xfrm/xfrm_state.c                                           |    1 
 tools/perf/Makefile.config                                      |    2 
 98 files changed, 873 insertions(+), 474 deletions(-)

Alex Elder (1):
      net: ipa: don't assume SMEM is page-aligned

Anand Jain (2):
      btrfs: replace: drop assert for suspended replace
      btrfs: add info when mount fails due to stale replace target

Antony Antony (1):
      xfrm: clone missing x->lastused in xfrm_do_migrate

Basavaraj Natikar (1):
      pinctrl: amd: Don't save/restore interrupt status and wake status bits

Bernard Pidoux (1):
      rose: check NULL rose_loopback_neigh->loopback

Brian Foster (1):
      s390: fix double free of GS and RI CBs on fork() failure

Chen Zhongjin (1):
      x86/unwind/orc: Unwind ftrace trampolines with correct ORC entry

Christoph Hellwig (1):
      fs: remove __sync_filesystem

Colin Ian King (1):
      netfilter: nftables: remove redundant assignment of variable err

Dan Carpenter (1):
      xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()

Daniel Borkmann (1):
      bpf: Don't use tnum_range on array range checking for poke descriptors

Darrick J. Wong (4):
      xfs: reject crazy array sizes being fed to XFS_IOC_GETBMAP*
      vfs: make sync_filesystem return errors from ->sync_fs
      xfs: return errors in xfs_fs_sync_fs
      xfs: only bother with sync_filesystem during readonly remount

David Hildenbrand (1):
      mm/hugetlb: fix hugetlb not supporting softdirty tracking

David Howells (1):
      rxrpc: Fix locking in rxrpc's sendmsg

Duoming Zhou (1):
      nfc: pn533: Fix use-after-free bugs caused by pn532_cmd_timeout

Eric Dumazet (1):
      tcp: tweak len/truesize ratio for coalesce candidates

Filipe Manana (1):
      btrfs: fix silent failure when deleting root reference

Florian Westphal (1):
      netfilter: ebtables: reject blobs that don't provide all entry points

Gaosheng Cui (1):
      audit: fix potential double free on error path from fsnotify_add_inode_mark

Goldwyn Rodrigues (1):
      btrfs: check if root is readonly while setting security xattr

Greg Kroah-Hartman (1):
      Linux 5.10.140

Guoqing Jiang (2):
      Revert "md-raid: destroy the bitmap after destroying the thread"
      md: call __md_stop_writes in md_stop

Helge Deller (1):
      parisc: Fix exception handler for fldw and fstw instructions

Herbert Xu (1):
      af_key: Do not call xfrm_probe_algs in parallel

Hui Su (1):
      kernel/sched: Remove dl_boosted flag comment

Jacob Keller (1):
      ixgbe: stop resetting SYSTIME in ixgbe_ptp_start_cyclecounter

James Clark (1):
      perf python: Fix build when PYTHON_CONFIG is user supplied

Jeremy Sowden (1):
      netfilter: bitwise: improve error goto labels

Jonathan Toppins (1):
      bonding: 802.3ad: fix no transmission of LACPDUs

Juergen Gross (1):
      xen/privcmd: fix error exit of privcmd_ioctl_dm_op()

Kan Liang (1):
      perf/x86/lbr: Enable the branch type for the Arch LBR by default

Kiwoong Kim (1):
      scsi: ufs: core: Enable link lost interrupt

Kuniyuki Iwashima (15):
      net: Fix data-races around sysctl_[rw]mem(_offset)?.
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
      net: Fix a data-race around netdev_budget_usecs.
      net: Fix data-races around sysctl_fb_tunnels_only_for_init_net.
      net: Fix data-races around sysctl_devconf_inherit_init_net.
      net: Fix a data-race around sysctl_somaxconn.

Maciej Fijalkowski (2):
      ice: xsk: Force rings to be sized to power of 2
      ice: xsk: prohibit usage of non-balanced queue id

Maciej Żenczykowski (1):
      net: ipvtap - add __init/__exit annotations to module init/exit funcs

Martin KaFai Lau (1):
      bpf: Folding omem_charge() into sk_storage_charge()

Miaohe Lin (1):
      mm/huge_memory.c: use helper function migration_entry_to_page()

Nikolay Aleksandrov (1):
      xfrm: policy: fix metadata dst->dev xmit null pointer dereference

Olga Kornievskaia (1):
      NFSv4.2 fix problems with __nfs42_ssc_open

Pablo Neira Ayuso (10):
      netfilter: nft_payload: report ERANGE for too long offset and length
      netfilter: nft_payload: do not truncate csum_offset and csum_type
      netfilter: nf_tables: do not leave chain stats enabled on error
      netfilter: nft_osf: restrict osf to ipv4, ipv6 and inet families
      netfilter: nft_tunnel: restrict it to netdev family
      netfilter: nf_tables: consolidate rule verdict trace call
      netfilter: nft_cmp: optimize comparison for 16-bytes
      netfilter: nf_tables: upfront validation of data via nft_data_init()
      netfilter: nf_tables: disallow jump to implicit chain from set element
      netfilter: nf_tables: disallow binding to already bound chain

Pawan Gupta (1):
      x86/bugs: Add "unknown" reporting for MMIO Stale Data

Peter Xu (1):
      mm/smaps: don't access young/dirty bit if pte unpresent

Quanyang Wang (1):
      asm-generic: sections: refactor memory_intersects

Randy Dunlap (1):
      kernel/sys_ni: add compat entry for fadvise64_64

Riwen Lu (1):
      ACPI: processor: Remove freq Qos request for all CPUs

Salvatore Bonaccorso (1):
      Documentation/ABI: Mention retbleed vulnerability info file for sysfs

Saurabh Sengar (1):
      scsi: storvsc: Remove WQ_MEM_RECLAIM from storvsc_error_wq

Sergei Antonov (1):
      net: moxa: get rid of asymmetry in DMA mapping/unmapping

Shannon Nelson (1):
      ionic: fix up issues with handling EAGAIN on FW cmds

Siddh Raman Pant (1):
      loop: Check for overflow while configuring loop

Stephane Eranian (1):
      perf/x86/intel/uncore: Fix broken read_counter() for SNB IMC PMU

Trond Myklebust (2):
      NFS: Don't allocate nfs_fattr on the stack in __nfs42_ssc_open()
      SUNRPC: RPC level errors should set task->tk_rpc_status

Vikas Gupta (1):
      bnxt_en: fix NQ resource accounting during vf creation on 57500 chips

Vlad Buslov (1):
      net/mlx5e: Properly disable vlan strip on non-UL reps

Xin Xiong (1):
      xfrm: fix refcount leak in __xfrm_policy_check()

Yu Kuai (1):
      blk-mq: fix io hung due to missing commit_rqs

Zenghui Yu (1):
      arm64: Fix match_list for erratum 1286807 on Arm Cortex-A76

