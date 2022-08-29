Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01985A47B4
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiH2LAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiH2LAU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B837913CC7;
        Mon, 29 Aug 2022 04:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F47DB80EC5;
        Mon, 29 Aug 2022 11:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5012BC433C1;
        Mon, 29 Aug 2022 11:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770816;
        bh=pzVBeCOFCn/9TcRSwPjeEOJzv9dhpMbd9tEU+/b5SBU=;
        h=From:To:Cc:Subject:Date:From;
        b=SEBnXqeF7qJVJV4cjv+FNAbPdEXRfoEMFUBBZwx0gWkhE0axxi4I5NbSs1J/jSq/J
         Z2lNmjkZFai6iJNJUO4SN/bg7rzZ2iEpj99k4sQbJIMBubStbuP6suIp4uYXAKJwyz
         KaXnwF6oo/sJe3Rem6PigWC1D2uZR+GvG+R9Ud+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/86] 5.10.140-rc1 review
Date:   Mon, 29 Aug 2022 12:58:26 +0200
Message-Id: <20220829105756.500128871@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.140-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.140-rc1
X-KernelTest-Deadline: 2022-08-31T10:58+00:00
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

This is the start of the stable review cycle for the 5.10.140 release.
There are 86 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.140-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.140-rc1

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Don't use tnum_range on array range checking for poke descriptors

Saurabh Sengar <ssengar@linux.microsoft.com>
    scsi: storvsc: Remove WQ_MEM_RECLAIM from storvsc_error_wq

Kiwoong Kim <kwmad.kim@samsung.com>
    scsi: ufs: core: Enable link lost interrupt

Stephane Eranian <eranian@google.com>
    perf/x86/intel/uncore: Fix broken read_counter() for SNB IMC PMU

James Clark <james.clark@arm.com>
    perf python: Fix build when PYTHON_CONFIG is user supplied

Yu Kuai <yukuai3@huawei.com>
    blk-mq: fix io hung due to missing commit_rqs

Salvatore Bonaccorso <carnil@debian.org>
    Documentation/ABI: Mention retbleed vulnerability info file for sysfs

Zenghui Yu <yuzenghui@huawei.com>
    arm64: Fix match_list for erratum 1286807 on Arm Cortex-A76

Guoqing Jiang <guoqing.jiang@linux.dev>
    md: call __md_stop_writes in md_stop

Guoqing Jiang <guoqing.jiang@linux.dev>
    Revert "md-raid: destroy the bitmap after destroying the thread"

David Hildenbrand <david@redhat.com>
    mm/hugetlb: fix hugetlb not supporting softdirty tracking

Juergen Gross <jgross@suse.com>
    xen/privcmd: fix error exit of privcmd_ioctl_dm_op()

Riwen Lu <luriwen@kylinos.cn>
    ACPI: processor: Remove freq Qos request for all CPUs

Brian Foster <bfoster@redhat.com>
    s390: fix double free of GS and RI CBs on fork() failure

Quanyang Wang <quanyang.wang@windriver.com>
    asm-generic: sections: refactor memory_intersects

Siddh Raman Pant <code@siddh.me>
    loop: Check for overflow while configuring loop

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Add "unknown" reporting for MMIO Stale Data

Chen Zhongjin <chenzhongjin@huawei.com>
    x86/unwind/orc: Unwind ftrace trampolines with correct ORC entry

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/lbr: Enable the branch type for the Arch LBR by default

Goldwyn Rodrigues <rgoldwyn@suse.de>
    btrfs: check if root is readonly while setting security xattr

Anand Jain <anand.jain@oracle.com>
    btrfs: add info when mount fails due to stale replace target

Anand Jain <anand.jain@oracle.com>
    btrfs: replace: drop assert for suspended replace

Filipe Manana <fdmanana@suse.com>
    btrfs: fix silent failure when deleting root reference

Shannon Nelson <snelson@pensando.io>
    ionic: fix up issues with handling EAGAIN on FW cmds

David Howells <dhowells@redhat.com>
    rxrpc: Fix locking in rxrpc's sendmsg

Jacob Keller <jacob.e.keller@intel.com>
    ixgbe: stop resetting SYSTIME in ixgbe_ptp_start_cyclecounter

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around sysctl_somaxconn.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix data-races around sysctl_devconf_inherit_init_net.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix data-races around sysctl_fb_tunnels_only_for_init_net.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around netdev_budget_usecs.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around netdev_budget.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around sysctl_net_busy_read.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around sysctl_net_busy_poll.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around sysctl_tstamp_allow_data.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix data-races around sysctl_optmem_max.

Martin KaFai Lau <kafai@fb.com>
    bpf: Folding omem_charge() into sk_storage_charge()

Kuniyuki Iwashima <kuniyu@amazon.com>
    ratelimit: Fix data-races in ___ratelimit().

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix data-races around netdev_tstamp_prequeue.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix data-races around netdev_max_backlog.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix data-races around weight_p and dev_weight_[rt]x_bias.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix data-races around sysctl_[rw]mem_(max|default).

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix data-races around sysctl_[rw]mem(_offset)?.

Eric Dumazet <edumazet@google.com>
    tcp: tweak len/truesize ratio for coalesce candidates

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: disallow binding to already bound chain

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: disallow jump to implicit chain from set element

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: upfront validation of data via nft_data_init()

Jeremy Sowden <jeremy@azazel.net>
    netfilter: bitwise: improve error goto labels

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_cmp: optimize comparison for 16-bytes

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: consolidate rule verdict trace call

Colin Ian King <colin.king@canonical.com>
    netfilter: nftables: remove redundant assignment of variable err

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_tunnel: restrict it to netdev family

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_osf: restrict osf to ipv4, ipv6 and inet families

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: do not leave chain stats enabled on error

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: do not truncate csum_offset and csum_type

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: report ERANGE for too long offset and length

Vikas Gupta <vikas.gupta@broadcom.com>
    bnxt_en: fix NQ resource accounting during vf creation on 57500 chips

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: reject blobs that don't provide all entry points

Maciej Żenczykowski <maze@google.com>
    net: ipvtap - add __init/__exit annotations to module init/exit funcs

Jonathan Toppins <jtoppins@redhat.com>
    bonding: 802.3ad: fix no transmission of LACPDUs

Sergei Antonov <saproj@gmail.com>
    net: moxa: get rid of asymmetry in DMA mapping/unmapping

Alex Elder <elder@linaro.org>
    net: ipa: don't assume SMEM is page-aligned

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5e: Properly disable vlan strip on non-UL reps

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: xsk: prohibit usage of non-balanced queue id

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: xsk: Force rings to be sized to power of 2

Duoming Zhou <duoming@zju.edu.cn>
    nfc: pn533: Fix use-after-free bugs caused by pn532_cmd_timeout

Bernard Pidoux <f6bvp@free.fr>
    rose: check NULL rose_loopback_neigh->loopback

Peter Xu <peterx@redhat.com>
    mm/smaps: don't access young/dirty bit if pte unpresent

Miaohe Lin <linmiaohe@huawei.com>
    mm/huge_memory.c: use helper function migration_entry_to_page()

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: RPC level errors should set task->tk_rpc_status

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.2 fix problems with __nfs42_ssc_open

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't allocate nfs_fattr on the stack in __nfs42_ssc_open()

Nikolay Aleksandrov <razor@blackwall.org>
    xfrm: policy: fix metadata dst->dev xmit null pointer dereference

Herbert Xu <herbert@gondor.apana.org.au>
    af_key: Do not call xfrm_probe_algs in parallel

Antony Antony <antony.antony@secunet.com>
    xfrm: clone missing x->lastused in xfrm_do_migrate

Xin Xiong <xiongx18@fudan.edu.cn>
    xfrm: fix refcount leak in __xfrm_policy_check()

Hui Su <suhui_kernel@163.com>
    kernel/sched: Remove dl_boosted flag comment

Darrick J. Wong <djwong@kernel.org>
    xfs: only bother with sync_filesystem during readonly remount

Darrick J. Wong <djwong@kernel.org>
    xfs: return errors in xfs_fs_sync_fs

Darrick J. Wong <djwong@kernel.org>
    vfs: make sync_filesystem return errors from ->sync_fs

Christoph Hellwig <hch@lst.de>
    fs: remove __sync_filesystem

Darrick J. Wong <djwong@kernel.org>
    xfs: reject crazy array sizes being fed to XFS_IOC_GETBMAP*

Dan Carpenter <dan.carpenter@oracle.com>
    xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    pinctrl: amd: Don't save/restore interrupt status and wake status bits

Randy Dunlap <rdunlap@infradead.org>
    kernel/sys_ni: add compat entry for fadvise64_64

Helge Deller <deller@gmx.de>
    parisc: Fix exception handler for fldw and fstw instructions

Gaosheng Cui <cuigaosheng1@huawei.com>
    audit: fix potential double free on error path from fsnotify_add_inode_mark


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-devices-system-cpu |   1 +
 .../hw-vuln/processor_mmio_stale_data.rst          |  14 ++
 Documentation/admin-guide/sysctl/net.rst           |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/kernel/cpu_errata.c                     |   2 +
 arch/parisc/kernel/unaligned.c                     |   2 +-
 arch/s390/kernel/process.c                         |  22 +++-
 arch/x86/events/intel/lbr.c                        |   8 ++
 arch/x86/events/intel/uncore_snb.c                 |  18 ++-
 arch/x86/include/asm/cpufeatures.h                 |   5 +-
 arch/x86/kernel/cpu/bugs.c                         |  14 +-
 arch/x86/kernel/cpu/common.c                       |  42 +++---
 arch/x86/kernel/unwind_orc.c                       |  15 ++-
 block/blk-mq.c                                     |   5 +-
 drivers/acpi/processor_thermal.c                   |   2 +-
 drivers/block/loop.c                               |   5 +
 drivers/md/md.c                                    |   3 +-
 drivers/net/bonding/bond_3ad.c                     |  38 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  14 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c       |  59 +++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   2 +
 drivers/net/ethernet/moxa/moxart_ether.c           |  11 +-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |   4 +-
 drivers/net/ipa/ipa_mem.c                          |   2 +-
 drivers/net/ipvlan/ipvtap.c                        |   4 +-
 drivers/nfc/pn533/uart.c                           |   1 +
 drivers/pinctrl/pinctrl-amd.c                      |  11 +-
 drivers/scsi/storvsc_drv.c                         |   2 +-
 drivers/scsi/ufs/ufshci.h                          |   6 +-
 drivers/xen/privcmd.c                              |  21 +--
 fs/btrfs/dev-replace.c                             |   5 +-
 fs/btrfs/root-tree.c                               |   5 +-
 fs/btrfs/xattr.c                                   |   3 +
 fs/nfs/nfs4file.c                                  |  16 ++-
 fs/proc/task_mmu.c                                 |   7 +-
 fs/sync.c                                          |  48 +++----
 fs/xfs/xfs_ioctl.c                                 |   4 +-
 fs/xfs/xfs_ioctl.h                                 |   5 +-
 fs/xfs/xfs_super.c                                 |  13 +-
 include/asm-generic/sections.h                     |   7 +-
 include/linux/netdevice.h                          |  20 ++-
 include/linux/netfilter_bridge/ebtables.h          |   4 -
 include/linux/sched.h                              |   4 -
 include/net/busy_poll.h                            |   2 +-
 include/net/netfilter/nf_tables.h                  |   9 +-
 include/net/netfilter/nf_tables_core.h             |   9 ++
 include/net/sock.h                                 |   8 +-
 kernel/audit_fsnotify.c                            |   1 +
 kernel/bpf/verifier.c                              |  10 +-
 kernel/sys_ni.c                                    |   1 +
 lib/ratelimit.c                                    |  12 +-
 mm/huge_memory.c                                   |   4 +-
 mm/mmap.c                                          |   8 +-
 net/bridge/netfilter/ebtable_broute.c              |   8 --
 net/bridge/netfilter/ebtable_filter.c              |   8 --
 net/bridge/netfilter/ebtable_nat.c                 |   8 --
 net/bridge/netfilter/ebtables.c                    |   8 +-
 net/core/bpf_sk_storage.c                          |  24 ++--
 net/core/dev.c                                     |  18 +--
 net/core/filter.c                                  |  13 +-
 net/core/gro_cells.c                               |   2 +-
 net/core/skbuff.c                                  |   2 +-
 net/core/sock.c                                    |  18 +--
 net/core/sysctl_net_core.c                         |  15 ++-
 net/decnet/af_decnet.c                             |   4 +-
 net/ipv4/devinet.c                                 |  16 ++-
 net/ipv4/ip_output.c                               |   2 +-
 net/ipv4/ip_sockglue.c                             |   6 +-
 net/ipv4/tcp.c                                     |   6 +-
 net/ipv4/tcp_input.c                               |  51 ++++++--
 net/ipv4/tcp_output.c                              |   4 +-
 net/ipv6/addrconf.c                                |   5 +-
 net/ipv6/ipv6_sockglue.c                           |   4 +-
 net/key/af_key.c                                   |   3 +
 net/mptcp/protocol.c                               |   6 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |   4 +-
 net/netfilter/nf_tables_api.c                      |  90 +++++++------
 net/netfilter/nf_tables_core.c                     |  55 +++++++-
 net/netfilter/nft_bitwise.c                        |  67 +++++-----
 net/netfilter/nft_cmp.c                            | 142 +++++++++++++++++----
 net/netfilter/nft_immediate.c                      |  22 +++-
 net/netfilter/nft_osf.c                            |  18 ++-
 net/netfilter/nft_payload.c                        |  29 +++--
 net/netfilter/nft_range.c                          |  27 ++--
 net/netfilter/nft_tunnel.c                         |   1 +
 net/rose/rose_loopback.c                           |   3 +-
 net/rxrpc/call_object.c                            |   4 +-
 net/rxrpc/sendmsg.c                                |  92 +++++++------
 net/sched/sch_generic.c                            |   2 +-
 net/socket.c                                       |   2 +-
 net/sunrpc/clnt.c                                  |   2 +-
 net/tipc/socket.c                                  |   2 +-
 net/xfrm/espintcp.c                                |   2 +-
 net/xfrm/xfrm_input.c                              |   2 +-
 net/xfrm/xfrm_policy.c                             |   3 +-
 net/xfrm/xfrm_state.c                              |   1 +
 tools/perf/Makefile.config                         |   2 +-
 98 files changed, 874 insertions(+), 475 deletions(-)


