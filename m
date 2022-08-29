Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6795A47B9
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiH2LAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiH2LA2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:00:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D03919032;
        Mon, 29 Aug 2022 04:00:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FDADB80E7B;
        Mon, 29 Aug 2022 11:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887CCC433D6;
        Mon, 29 Aug 2022 11:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770822;
        bh=Sa4p8ksLG+WIprMjWTpQJO2VTM0symj1oKeQe4+W4ls=;
        h=From:To:Cc:Subject:Date:From;
        b=gCUPdkLCHlq1GR8RNOYN+2ztYy9SZosgCYs3+ajHSAEU+GV0Jq9hO7b2q+o5UfUcD
         QqJqcrghxh7RLeuw4TlSN7iQ2Pn+/JckQNbFj4DuShv2ApHubU+2v1wOYlP6Darok1
         Av7pbe4e5U+F5kkeEZ8oLsZELJFg1dS5UAK6GoEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 000/136] 5.15.64-rc1 review
Date:   Mon, 29 Aug 2022 12:57:47 +0200
Message-Id: <20220829105804.609007228@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.64-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.64-rc1
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

This is the start of the stable review cycle for the 5.15.64 release.
There are 136 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.64-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.64-rc1

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Don't use tnum_range on array range checking for poke descriptors

Saurabh Sengar <ssengar@linux.microsoft.com>
    scsi: storvsc: Remove WQ_MEM_RECLAIM from storvsc_error_wq

Kiwoong Kim <kwmad.kim@samsung.com>
    scsi: ufs: core: Enable link lost interrupt

Ian Rogers <irogers@google.com>
    perf stat: Clear evsel->reset_group for each stat run

Stephane Eranian <eranian@google.com>
    perf/x86/intel/ds: Fix precise store latency handling

Stephane Eranian <eranian@google.com>
    perf/x86/intel/uncore: Fix broken read_counter() for SNB IMC PMU

James Clark <james.clark@arm.com>
    perf python: Fix build when PYTHON_CONFIG is user supplied

Yu Kuai <yukuai3@huawei.com>
    blk-mq: fix io hung due to missing commit_rqs

Salvatore Bonaccorso <carnil@debian.org>
    Documentation/ABI: Mention retbleed vulnerability info file for sysfs

Peter Zijlstra <peterz@infradead.org>
    x86/nospec: Fix i386 RSB stuffing

Liam Howlett <liam.howlett@oracle.com>
    binder_alloc: add missing mmap_lock calls when using the VMA

Zenghui Yu <yuzenghui@huawei.com>
    arm64: Fix match_list for erratum 1286807 on Arm Cortex-A76

Yonglong Li <liyonglong@chinatelecom.cn>
    mptcp: Fix crash due to tcp_tsorted_anchor was initialized before release skb

Guoqing Jiang <guoqing.jiang@linux.dev>
    md: call __md_stop_writes in md_stop

Guoqing Jiang <guoqing.jiang@linux.dev>
    Revert "md-raid: destroy the bitmap after destroying the thread"

David Hildenbrand <david@redhat.com>
    mm/hugetlb: fix hugetlb not supporting softdirty tracking

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid polling"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usbnet: smsc95xx: Fix deadlock on runtime resume"

Jens Axboe <axboe@kernel.dk>
    io_uring: fix issue with io_write() not always undoing sb_start_write()

Conor Dooley <conor.dooley@microchip.com>
    riscv: traps: add missing prototype

Juergen Gross <jgross@suse.com>
    xen/privcmd: fix error exit of privcmd_ioctl_dm_op()

David Howells <dhowells@redhat.com>
    smb3: missing inode locks in punch hole

Karol Herbst <kherbst@redhat.com>
    nouveau: explicitly wait on the fence in nouveau_bo_move_m2mf

Riwen Lu <luriwen@kylinos.cn>
    ACPI: processor: Remove freq Qos request for all CPUs

Shakeel Butt <shakeelb@google.com>
    Revert "memcg: cleanup racy sum avoidance code"

Shigeru Yoshida <syoshida@redhat.com>
    fbdev: fbcon: Properly revert changes when vc_resize() failed

Brian Foster <bfoster@redhat.com>
    s390: fix double free of GS and RI CBs on fork() failure

Liu Shixin <liushixin2@huawei.com>
    bootmem: remove the vmemmap pages from kmemleak in put_page_bootmem

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/mm: do not trigger write fault when vma does not allow VM_WRITE

Badari Pulavarty <badari.pulavarty@intel.com>
    mm/damon/dbgfs: avoid duplicate context directory creation

Quanyang Wang <quanyang.wang@windriver.com>
    asm-generic: sections: refactor memory_intersects

Khazhismel Kumykov <khazhy@chromium.org>
    writeback: avoid use-after-free after removing device

Siddh Raman Pant <code@siddh.me>
    loop: Check for overflow while configuring loop

Peter Zijlstra <peterz@infradead.org>
    x86/nospec: Unwreck the RSB stuffing

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Add "unknown" reporting for MMIO Stale Data

Chen Zhongjin <chenzhongjin@huawei.com>
    x86/unwind/orc: Unwind ftrace trampolines with correct ORC entry

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/lbr: Enable the branch type for the Arch LBR by default

Zixuan Fu <r33s3n6@gmail.com>
    btrfs: fix possible memory leak in btrfs_get_dev_args_from_path()

Goldwyn Rodrigues <rgoldwyn@suse.de>
    btrfs: check if root is readonly while setting security xattr

Anand Jain <anand.jain@oracle.com>
    btrfs: add info when mount fails due to stale replace target

Anand Jain <anand.jain@oracle.com>
    btrfs: replace: drop assert for suspended replace

Filipe Manana <fdmanana@suse.com>
    btrfs: fix silent failure when deleting root reference

Heiner Kallweit <hkallweit1@gmail.com>
    net: stmmac: work around sporadic tx issue on link-up

R Mohamed Shah <mohamed@pensando.io>
    ionic: VF initial random MAC address if no assigned mac

Shannon Nelson <snelson@pensando.io>
    ionic: fix up issues with handling EAGAIN on FW cmds

Shannon Nelson <snelson@pensando.io>
    ionic: clear broken state on generation change

Shannon Nelson <snelson@pensando.io>
    ionic: widen queue_lock use around lif init and deinit

David Howells <dhowells@redhat.com>
    rxrpc: Fix locking in rxrpc's sendmsg

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    i40e: Fix incorrect address type for IPv6 flow rules

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
    net: Fix data-races around sysctl_max_skb_frags.

Paolo Abeni <pabeni@redhat.com>
    mptcp: stop relying on tcp_tx_skb_cache

Paolo Abeni <pabeni@redhat.com>
    tcp: expose the tcp_mark_push() and tcp_skb_entail() helpers

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

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: fix stuck flows on cleanup due to pending work

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: add function to invoke garbage collection immediately

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

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: make table handle allocation per-netns friendly

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: disallow updates of implicit chain

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

Xiaolei Wang <xiaolei.wang@windriver.com>
    net: phy: Don't WARN for PHY_READY state in mdio_bus_phy_resume()

Alex Elder <elder@linaro.org>
    net: ipa: don't assume SMEM is page-aligned

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Fix wrong tc flag used when set hw-tc-offload off

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Fix wrong application of the LRO state

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Avoid false positive lockdep warning by adding lock_class_key

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5e: Properly disable vlan strip on non-UL reps

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: xsk: prohibit usage of non-balanced queue id

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: xsk: Force rings to be sized to power of 2

Duoming Zhou <duoming@zju.edu.cn>
    nfc: pn533: Fix use-after-free bugs caused by pn532_cmd_timeout

Hayes Wang <hayeswang@realtek.com>
    r8152: fix the RX FIFO settings when suspending

Hayes Wang <hayeswang@realtek.com>
    r8152: fix the units of some registers for RTL8156A

Bernard Pidoux <f6bvp@free.fr>
    rose: check NULL rose_loopback_neigh->loopback

Christian Brauner <brauner@kernel.org>
    ntfs: fix acl handling

Peter Xu <peterx@redhat.com>
    mm/smaps: don't access young/dirty bit if pte unpresent

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: RPC level errors should set task->tk_rpc_status

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.2 fix problems with __nfs42_ssc_open

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't allocate nfs_fattr on the stack in __nfs42_ssc_open()

Sabrina Dubroca <sd@queasysnail.net>
    Revert "net: macsec: update SCI upon MAC address change."

Jakub Kicinski <kuba@kernel.org>
    net: use eth_hw_addr_set() instead of ether_addr_copy()

Seth Forshee <sforshee@digitalocean.com>
    fs: require CAP_SYS_ADMIN in target namespace for idmapped mounts

Nikolay Aleksandrov <razor@blackwall.org>
    xfrm: policy: fix metadata dst->dev xmit null pointer dereference

Herbert Xu <herbert@gondor.apana.org.au>
    af_key: Do not call xfrm_probe_algs in parallel

Antony Antony <antony.antony@secunet.com>
    xfrm: clone missing x->lastused in xfrm_do_migrate

Xin Xiong <xiongx18@fudan.edu.cn>
    xfrm: fix refcount leak in __xfrm_policy_check()

Chen Lifu <chenlifu@huawei.com>
    riscv: lib: uaccess: fix CSR_STATUS SR_SUM bit

Jisheng Zhang <jszhang@kernel.org>
    riscv: lib: uaccess: fold fixups into body

Qu Wenruo <wqu@suse.com>
    btrfs: remove unnecessary parameter delalloc_start for writepage_delalloc()

Filipe Manana <fdmanana@suse.com>
    btrfs: pass the dentry to btrfs_log_new_name() instead of the inode

Filipe Manana <fdmanana@suse.com>
    btrfs: put initial index value of a directory in a constant

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Fix dropped IKE message

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix response queue handler reading stale packets

Phil Auld <pauld@redhat.com>
    drivers/base: fix userspace break from using bin_attributes for cpumap and cpulist

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - add additional TUXEDO devices to i8042 quirk tables

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - add TUXEDO devices to i8042 quirk tables

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - merge quirk tables

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - move __initconst to fix code styling warning

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: convert count_max_extents() to use fs_info->max_extent_size

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: replace BTRFS_MAX_EXTENT_SIZE with fs_info->max_extent_size

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: revive max_zone_append_bytes

Naohiro Aota <naohiro.aota@wdc.com>
    block: add bdev_max_segments() helper

Christoph Hellwig <hch@lst.de>
    block: add a bdev_max_zone_append_sectors helper

Lai Jiangshan <jiangshan.ljs@antgroup.com>
    x86/entry: Move CLD to the start of the idtentry macro

Randy Dunlap <rdunlap@infradead.org>
    kernel/sys_ni: add compat entry for fadvise64_64

Helge Deller <deller@gmx.de>
    parisc: Fix exception handler for fldw and fstw instructions

Helge Deller <deller@gmx.de>
    parisc: Make CONFIG_64BIT available for ARCH=parisc64 only

Jing-Ting Wu <Jing-Ting.Wu@mediatek.com>
    cgroup: Fix race condition at rebind_subsystems()

Gaosheng Cui <cuigaosheng1@huawei.com>
    audit: fix potential double free on error path from fsnotify_add_inode_mark

Martin Liška <mliska@suse.cz>
    eth: sun: cassini: remove dead code

Jakub Kicinski <kuba@kernel.org>
    wifi: rtlwifi: remove always-true condition pointed out by GCC 12


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-devices-system-cpu |    1 +
 .../hw-vuln/processor_mmio_stale_data.rst          |   14 +
 Documentation/admin-guide/sysctl/net.rst           |    2 +-
 Makefile                                           |    4 +-
 arch/arm64/kernel/cpu_errata.c                     |    2 +
 arch/parisc/Kconfig                                |   21 +-
 arch/parisc/kernel/unaligned.c                     |    2 +-
 arch/riscv/include/asm/thread_info.h               |    2 +
 arch/riscv/kernel/traps.c                          |    3 +-
 arch/riscv/lib/uaccess.S                           |   24 +-
 arch/s390/kernel/process.c                         |   22 +-
 arch/s390/mm/fault.c                               |    4 +-
 arch/x86/entry/entry_64.S                          |    8 +-
 arch/x86/events/intel/ds.c                         |   10 +-
 arch/x86/events/intel/lbr.c                        |    8 +
 arch/x86/events/intel/uncore_snb.c                 |   18 +-
 arch/x86/include/asm/cpufeatures.h                 |    5 +-
 arch/x86/include/asm/nospec-branch.h               |   92 +-
 arch/x86/kernel/cpu/bugs.c                         |   14 +-
 arch/x86/kernel/cpu/common.c                       |   42 +-
 arch/x86/kernel/unwind_orc.c                       |   15 +-
 block/blk-mq.c                                     |    5 +-
 drivers/acpi/processor_thermal.c                   |    2 +-
 drivers/android/binder_alloc.c                     |   31 +-
 drivers/base/node.c                                |    4 +-
 drivers/base/topology.c                            |   28 +-
 drivers/block/loop.c                               |    5 +
 drivers/gpu/drm/nouveau/nouveau_bo.c               |    9 +
 drivers/input/serio/i8042-x86ia64io.h              | 1251 ++++++++++++--------
 drivers/md/md.c                                    |    3 +-
 drivers/net/bonding/bond_3ad.c                     |   38 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |    2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   14 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c       |   59 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |    2 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |    4 +
 drivers/net/ethernet/moxa/moxart_ether.c           |   11 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  109 +-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |    4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c    |    8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    9 +-
 drivers/net/ethernet/sun/cassini.c                 |    4 +-
 drivers/net/ipa/ipa_mem.c                          |    2 +-
 drivers/net/ipvlan/ipvlan_main.c                   |    2 +-
 drivers/net/ipvlan/ipvtap.c                        |    4 +-
 drivers/net/macsec.c                               |   13 +-
 drivers/net/macvlan.c                              |    2 +-
 drivers/net/phy/phy_device.c                       |    8 +-
 drivers/net/usb/r8152.c                            |   27 +-
 drivers/net/usb/smsc95xx.c                         |  139 +--
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |    5 +-
 drivers/nfc/pn533/uart.c                           |    1 +
 drivers/nvme/target/zns.c                          |    3 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |    2 +
 drivers/scsi/qla2xxx/qla_isr.c                     |   76 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   10 +
 drivers/scsi/storvsc_drv.c                         |    2 +-
 drivers/scsi/ufs/ufshci.h                          |    6 +-
 drivers/video/fbdev/core/fbcon.c                   |   27 +-
 drivers/xen/privcmd.c                              |   21 +-
 fs/btrfs/btrfs_inode.h                             |   12 +-
 fs/btrfs/ctree.h                                   |   29 +-
 fs/btrfs/delalloc-space.c                          |    6 +-
 fs/btrfs/dev-replace.c                             |    5 +-
 fs/btrfs/disk-io.c                                 |    2 +
 fs/btrfs/extent_io.c                               |   18 +-
 fs/btrfs/inode.c                                   |   40 +-
 fs/btrfs/root-tree.c                               |    5 +-
 fs/btrfs/tree-log.c                                |   19 +-
 fs/btrfs/tree-log.h                                |    2 +-
 fs/btrfs/volumes.c                                 |    5 +-
 fs/btrfs/xattr.c                                   |    3 +
 fs/btrfs/zoned.c                                   |   20 +
 fs/btrfs/zoned.h                                   |    1 +
 fs/cifs/smb2ops.c                                  |   12 +-
 fs/fs-writeback.c                                  |   12 +-
 fs/io_uring.c                                      |    7 +-
 fs/namespace.c                                     |    7 +
 fs/nfs/nfs4file.c                                  |   16 +-
 fs/ntfs3/xattr.c                                   |   16 +-
 fs/proc/task_mmu.c                                 |    7 +-
 fs/zonefs/super.c                                  |    3 +-
 include/asm-generic/sections.h                     |    7 +-
 include/linux/blkdev.h                             |   11 +
 include/linux/cpumask.h                            |   18 +
 include/linux/memcontrol.h                         |   15 +-
 include/linux/mlx5/driver.h                        |    1 +
 include/linux/netdevice.h                          |   20 +-
 include/linux/netfilter_bridge/ebtables.h          |    4 -
 include/net/busy_poll.h                            |    2 +-
 include/net/netfilter/nf_flow_table.h              |    3 +
 include/net/netfilter/nf_tables.h                  |   10 +-
 include/net/netfilter/nf_tables_core.h             |    9 +
 include/net/tcp.h                                  |    2 +
 kernel/audit_fsnotify.c                            |    1 +
 kernel/bpf/verifier.c                              |   10 +-
 kernel/cgroup/cgroup.c                             |    1 +
 kernel/sys_ni.c                                    |    1 +
 lib/ratelimit.c                                    |   12 +-
 mm/backing-dev.c                                   |   10 +-
 mm/bootmem_info.c                                  |    2 +
 mm/damon/dbgfs.c                                   |    3 +
 mm/mmap.c                                          |    8 +-
 mm/page-writeback.c                                |    6 +-
 net/8021q/vlan_dev.c                               |    6 +-
 net/bridge/netfilter/ebtable_broute.c              |    8 -
 net/bridge/netfilter/ebtable_filter.c              |    8 -
 net/bridge/netfilter/ebtable_nat.c                 |    8 -
 net/bridge/netfilter/ebtables.c                    |    8 +-
 net/core/bpf_sk_storage.c                          |    5 +-
 net/core/dev.c                                     |   18 +-
 net/core/filter.c                                  |   13 +-
 net/core/gro_cells.c                               |    2 +-
 net/core/skbuff.c                                  |    2 +-
 net/core/sock.c                                    |   18 +-
 net/core/sysctl_net_core.c                         |   15 +-
 net/dsa/slave.c                                    |    4 +-
 net/hsr/hsr_device.c                               |    2 +-
 net/hsr/hsr_main.c                                 |    2 +-
 net/ipv4/devinet.c                                 |   16 +-
 net/ipv4/ip_output.c                               |    2 +-
 net/ipv4/ip_sockglue.c                             |    6 +-
 net/ipv4/tcp.c                                     |   12 +-
 net/ipv4/tcp_output.c                              |    2 +-
 net/ipv6/addrconf.c                                |    5 +-
 net/ipv6/ipv6_sockglue.c                           |    4 +-
 net/key/af_key.c                                   |    3 +
 net/mptcp/protocol.c                               |  138 ++-
 net/netfilter/ipvs/ip_vs_sync.c                    |    4 +-
 net/netfilter/nf_flow_table_core.c                 |   15 +-
 net/netfilter/nf_flow_table_offload.c              |    8 +
 net/netfilter/nf_tables_api.c                      |   96 +-
 net/netfilter/nf_tables_core.c                     |   55 +-
 net/netfilter/nft_bitwise.c                        |   67 +-
 net/netfilter/nft_cmp.c                            |  140 ++-
 net/netfilter/nft_immediate.c                      |   22 +-
 net/netfilter/nft_osf.c                            |   18 +-
 net/netfilter/nft_payload.c                        |   29 +-
 net/netfilter/nft_range.c                          |   27 +-
 net/netfilter/nft_tunnel.c                         |    1 +
 net/rose/rose_loopback.c                           |    3 +-
 net/rxrpc/call_object.c                            |    4 +-
 net/rxrpc/sendmsg.c                                |   92 +-
 net/sched/sch_generic.c                            |    2 +-
 net/socket.c                                       |    2 +-
 net/sunrpc/clnt.c                                  |    2 +-
 net/xfrm/espintcp.c                                |    2 +-
 net/xfrm/xfrm_input.c                              |    2 +-
 net/xfrm/xfrm_policy.c                             |    3 +-
 net/xfrm/xfrm_state.c                              |    1 +
 tools/perf/Makefile.config                         |    2 +-
 tools/perf/builtin-stat.c                          |    1 +
 154 files changed, 2271 insertions(+), 1316 deletions(-)


