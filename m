Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E4B5A47BE
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiH2LAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiH2LAj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:00:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964B924F2D;
        Mon, 29 Aug 2022 04:00:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1FBBB80EF5;
        Mon, 29 Aug 2022 11:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B9FC433C1;
        Mon, 29 Aug 2022 11:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770828;
        bh=/B2NpHBj+Nb71iiIXCa/71vKSCd8att6f6WP4MN1boM=;
        h=From:To:Cc:Subject:Date:From;
        b=YJC0sm+QVQlAhcl5ws2maZp/ldlbGpqKY4Ic/xZEMO1aeGMbJOTI17eKgPfSIV7+t
         mEmw63RzBiioqUxPOJpyYmONgzZVGTaxU9zx10gbc8ryWNqbhvUtkSGKAfmMKrOpk7
         rqCt9p4qb7s8gn4YZEamWP4gpGsDMn8MO7kOgOKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.19 000/158] 5.19.6-rc1 review
Date:   Mon, 29 Aug 2022 12:57:30 +0200
Message-Id: <20220829105808.828227973@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.19.6-rc1
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

This is the start of the stable review cycle for the 5.19.6 release.
There are 158 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.19.6-rc1

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Don't use tnum_range on array range checking for poke descriptors

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: microchip: mpfs: remove pci axi address translation property

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: microchip: mpfs: remove bogus card-detect-delay

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: microchip: mpfs: remove ti,fifo-depth property

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: microchip: mpfs: fix incorrect pcie child node name

Mike Christie <michael.christie@oracle.com>
    scsi: core: Fix passthrough retry counter handling

Saurabh Sengar <ssengar@linux.microsoft.com>
    scsi: storvsc: Remove WQ_MEM_RECLAIM from storvsc_error_wq

Kiwoong Kim <kwmad.kim@samsung.com>
    scsi: ufs: core: Enable link lost interrupt

Mark Brown <broonie@kernel.org>
    arm64/sme: Don't flush SVE register state when handling SME traps

Mark Brown <broonie@kernel.org>
    arm64/sme: Don't flush SVE register state when allocating SME storage

Mark Brown <broonie@kernel.org>
    arm64/signal: Flush FPSIMD register state when disabling streaming mode

Mark Rutland <mark.rutland@arm.com>
    arm64: fix rodata=full

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

Prike Liang <Prike.Liang@amd.com>
    drm/amdkfd: Fix isa version for the GC 10.3.7

Peter Zijlstra <peterz@infradead.org>
    x86/nospec: Fix i386 RSB stuffing

Liam Howlett <liam.howlett@oracle.com>
    binder_alloc: add missing mmap_lock calls when using the VMA

Zenghui Yu <yuzenghui@huawei.com>
    arm64: Fix match_list for erratum 1286807 on Arm Cortex-A76

Guoqing Jiang <guoqing.jiang@linux.dev>
    md: call __md_stop_writes in md_stop

Guoqing Jiang <guoqing.jiang@linux.dev>
    Revert "md-raid: destroy the bitmap after destroying the thread"

David Hildenbrand <david@redhat.com>
    mm/hugetlb: fix hugetlb not supporting softdirty tracking

Jens Axboe <axboe@kernel.dk>
    io_uring: fix issue with io_write() not always undoing sb_start_write()

Jiri Slaby <jirislaby@kernel.org>
    Revert "zram: remove double compression logic"

Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
    riscv: dts: microchip: correct L2 cache interrupts

Conor Dooley <conor.dooley@microchip.com>
    riscv: traps: add missing prototype

Conor Dooley <conor.dooley@microchip.com>
    riscv: signal: fix missing prototype warning

Juergen Gross <jgross@suse.com>
    xen/privcmd: fix error exit of privcmd_ioctl_dm_op()

Heming Zhao <ocfs2-devel@oss.oracle.com>
    ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown

David Howells <dhowells@redhat.com>
    smb3: missing inode locks in punch hole

Karol Herbst <kherbst@redhat.com>
    nouveau: explicitly wait on the fence in nouveau_bo_move_m2mf

Riwen Lu <luriwen@kylinos.cn>
    ACPI: processor: Remove freq Qos request for all CPUs

Matthew Wilcox (Oracle) <willy@infradead.org>
    shmem: update folio if shmem_replace_page() updates the page

Shakeel Butt <shakeelb@google.com>
    Revert "memcg: cleanup racy sum avoidance code"

Shigeru Yoshida <syoshida@redhat.com>
    fbdev: fbcon: Properly revert changes when vc_resize() failed

Brian Foster <bfoster@redhat.com>
    s390: fix double free of GS and RI CBs on fork() failure

Paulo Alcantara <pc@cjr.nz>
    cifs: skip extra NULL byte in filenames

Peter Xu <peterx@redhat.com>
    mm/mprotect: only reference swap pfn page if type match

Miaohe Lin <linmiaohe@huawei.com>
    mm/hugetlb: avoid corrupting page->mapping in hugetlb_mcopy_atomic_pte

Liu Shixin <liushixin2@huawei.com>
    bootmem: remove the vmemmap pages from kmemleak in put_page_bootmem

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/mm: do not trigger write fault when vma does not allow VM_WRITE

Badari Pulavarty <badari.pulavarty@intel.com>
    mm/damon/dbgfs: avoid duplicate context directory creation

Quanyang Wang <quanyang.wang@windriver.com>
    asm-generic: sections: refactor memory_intersects

Richard Guy Briggs <rgb@redhat.com>
    audit: move audit_return_fixup before the filters

Khazhismel Kumykov <khazhy@chromium.org>
    writeback: avoid use-after-free after removing device

Siddh Raman Pant <code@siddh.me>
    loop: Check for overflow while configuring loop

Jan Beulich <jbeulich@suse.com>
    x86/PAT: Have pat_enabled() properly reflect state when running on Xen

Peter Zijlstra <peterz@infradead.org>
    x86/nospec: Unwreck the RSB stuffing

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Add "unknown" reporting for MMIO Stale Data

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sev: Don't use cc_platform_has() for early SEV-SNP calls

Chen Zhongjin <chenzhongjin@huawei.com>
    x86/unwind/orc: Unwind ftrace trampolines with correct ORC entry

Juergen Gross <jgross@suse.com>
    x86/entry: Fix entry_INT80_compat for Xen PV guests

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/lbr: Enable the branch type for the Arch LBR by default

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix pebs event constraints for ADL

Michael Roth <michael.roth@amd.com>
    x86/boot: Don't propagate uninitialized boot_params->cc_blob_address

Filipe Manana <fdmanana@suse.com>
    btrfs: update generation of hole file extent item when merging holes

Zixuan Fu <r33s3n6@gmail.com>
    btrfs: fix possible memory leak in btrfs_get_dev_args_from_path()

Goldwyn Rodrigues <rgoldwyn@suse.de>
    btrfs: check if root is readonly while setting security xattr

Omar Sandoval <osandov@fb.com>
    btrfs: fix space cache corruption and potential double allocations

Anand Jain <anand.jain@oracle.com>
    btrfs: add info when mount fails due to stale replace target

Anand Jain <anand.jain@oracle.com>
    btrfs: replace: drop assert for suspended replace

Filipe Manana <fdmanana@suse.com>
    btrfs: fix silent failure when deleting root reference

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: lantiq_xrx200: restore buffer if memory allocation failed

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: lantiq_xrx200: fix lock under memory pressure

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: lantiq_xrx200: confirm skb is allocated before using

Heiner Kallweit <hkallweit1@gmail.com>
    net: stmmac: work around sporadic tx issue on link-up

R Mohamed Shah <mohamed@pensando.io>
    ionic: VF initial random MAC address if no assigned mac

Shannon Nelson <snelson@pensando.io>
    ionic: fix up issues with handling EAGAIN on FW cmds

Shannon Nelson <snelson@pensando.io>
    ionic: clear broken state on generation change

David Howells <dhowells@redhat.com>
    rxrpc: Fix locking in rxrpc's sendmsg

Lorenzo Bianconi <lorenzo@kernel.org>
    net: ethernet: mtk_eth_soc: fix hw hash reporting for MTK_NETSYS_V2

Lorenzo Bianconi <lorenzo@kernel.org>
    net: ethernet: mtk_eth_soc: enable rx cksum offload for MTK_NETSYS_V2

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    i40e: Fix incorrect address type for IPv6 flow rules

Jacob Keller <jacob.e.keller@intel.com>
    ixgbe: stop resetting SYSTIME in ixgbe_ptp_start_cyclecounter

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around sysctl_somaxconn.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around netdev_unregister_timeout_secs.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around gro_normal_batch.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix data-races around sysctl_devconf_inherit_init_net.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix data-races around sysctl_fb_tunnels_only_for_init_net.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around netdev_budget_usecs.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix data-races around sysctl_max_skb_frags.

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
    bnxt_en: fix LRO/GRO_HW features in ndo_fix_features callback

Vikas Gupta <vikas.gupta@broadcom.com>
    bnxt_en: fix NQ resource accounting during vf creation on 57500 chips

Vikas Gupta <vikas.gupta@broadcom.com>
    bnxt_en: set missing reload flag in devlink features

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Use PAGE_SIZE to init buffer when multi buffer XDP is not in use

Florian Westphal <fw@strlen.de>
    netfilter: nft_tproxy: restrict to prerouting hook

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

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: microchip: keep compatibility with device tree blobs with no phy-mode

Arun Ramadoss <arun.ramadoss@microchip.com>
    net: dsa: microchip: update the ksz_phylink_get_caps

Arun Ramadoss <arun.ramadoss@microchip.com>
    net: dsa: microchip: move the port mirror to ksz_common

Arun Ramadoss <arun.ramadoss@microchip.com>
    net: dsa: microchip: move vlan functionality to ksz_common

Arun Ramadoss <arun.ramadoss@microchip.com>
    net: dsa: microchip: move tag_protocol to ksz_common

Arun Ramadoss <arun.ramadoss@microchip.com>
    net: dsa: microchip: move switch chip_id detection to ksz_common

Arun Ramadoss <arun.ramadoss@microchip.com>
    net: dsa: microchip: ksz9477: cleanup the ksz9477_switch_detect

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Fix wrong tc flag used when set hw-tc-offload off

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Fix wrong application of the LRO state

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Avoid false positive lockdep warning by adding lock_class_key

Roy Novich <royno@nvidia.com>
    net/mlx5: Fix cmd error logging for manage pages cmd

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5: Disable irq when locking lag_lock

Eli Cohen <elic@nvidia.com>
    net/mlx5: Eswitch, Fix forwarding decision to uplink

Eli Cohen <elic@nvidia.com>
    net/mlx5: LAG, fix logic over MLX5_LAG_FLAG_NDEVS_READY

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5e: Properly disable vlan strip on non-UL reps

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: xsk: use Rx ring's XDP ring when picking NAPI context

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: xsk: prohibit usage of non-balanced queue id

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

Sabrina Dubroca <sd@queasysnail.net>
    Revert "net: macsec: update SCI upon MAC address change."

Seth Forshee <sforshee@digitalocean.com>
    fs: require CAP_SYS_ADMIN in target namespace for idmapped mounts

Nikolay Aleksandrov <razor@blackwall.org>
    xfrm: policy: fix metadata dst->dev xmit null pointer dereference

Herbert Xu <herbert@gondor.apana.org.au>
    af_key: Do not call xfrm_probe_algs in parallel

Antony Antony <antony.antony@secunet.com>
    xfrm: clone missing x->lastused in xfrm_do_migrate

Antony Antony <antony.antony@secunet.com>
    Revert "xfrm: update SA curlft.use_time"

Xin Xiong <xiongx18@fudan.edu.cn>
    xfrm: fix refcount leak in __xfrm_policy_check()

Deren Wu <deren.wu@mediatek.com>
    mt76: mt7921: fix command timeout in AP stop period

David Hildenbrand <david@redhat.com>
    mm/hugetlb: support write-faults in shared mappings

Peter Xu <peterx@redhat.com>
    mm/uffd: reset write protection when unregister with wp-mode

Kuniyuki Iwashima <kuniyu@amazon.com>
    kprobes: don't call disarm_kprobe() for disabled kprobes

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

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix another fsync() issue after a server reboot

David Hildenbrand <david@redhat.com>
    mm/gup: fix FOLL_FORCE COW security issue and remove FOLL_COW


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-devices-system-cpu |   1 +
 .../hw-vuln/processor_mmio_stale_data.rst          |  14 ++
 Documentation/admin-guide/kernel-parameters.txt    |   2 +
 Documentation/admin-guide/sysctl/net.rst           |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/include/asm/fpsimd.h                    |   4 +-
 arch/arm64/include/asm/setup.h                     |  17 ++
 arch/arm64/kernel/cpu_errata.c                     |   2 +
 arch/arm64/kernel/fpsimd.c                         |  21 +--
 arch/arm64/kernel/ptrace.c                         |   6 +-
 arch/arm64/kernel/signal.c                         |  12 +-
 arch/arm64/mm/mmu.c                                |  18 ---
 arch/parisc/Kconfig                                |  21 +--
 arch/parisc/kernel/unaligned.c                     |   2 +-
 arch/riscv/boot/dts/microchip/mpfs-icicle-kit.dts  |   3 -
 arch/riscv/boot/dts/microchip/mpfs-polarberry.dts  |   3 -
 arch/riscv/boot/dts/microchip/mpfs.dtsi            |   5 +-
 arch/riscv/include/asm/signal.h                    |  12 ++
 arch/riscv/include/asm/thread_info.h               |   2 +
 arch/riscv/kernel/signal.c                         |   1 +
 arch/riscv/kernel/traps.c                          |   3 +-
 arch/s390/kernel/process.c                         |  22 ++-
 arch/s390/mm/fault.c                               |   4 +-
 arch/x86/boot/compressed/misc.h                    |  12 +-
 arch/x86/boot/compressed/sev.c                     |   8 +
 arch/x86/entry/entry_64_compat.S                   |   2 +-
 arch/x86/events/intel/ds.c                         |  12 +-
 arch/x86/events/intel/lbr.c                        |   8 +
 arch/x86/events/intel/uncore_snb.c                 |  18 ++-
 arch/x86/include/asm/cpufeatures.h                 |   5 +-
 arch/x86/include/asm/nospec-branch.h               |  92 ++++++-----
 arch/x86/kernel/cpu/bugs.c                         |  14 +-
 arch/x86/kernel/cpu/common.c                       |  42 +++--
 arch/x86/kernel/sev.c                              |  16 +-
 arch/x86/kernel/unwind_orc.c                       |  15 +-
 arch/x86/mm/pat/memtype.c                          |  10 +-
 block/blk-mq.c                                     |   5 +-
 drivers/acpi/processor_thermal.c                   |   2 +-
 drivers/android/binder_alloc.c                     |  31 ++--
 drivers/block/loop.c                               |   5 +
 drivers/block/zram/zram_drv.c                      |  42 +++--
 drivers/block/zram/zram_drv.h                      |   1 +
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   6 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   9 ++
 drivers/md/md.c                                    |   3 +-
 drivers/net/bonding/bond_3ad.c                     |  38 ++---
 drivers/net/dsa/microchip/ksz8795.c                | 102 +++---------
 drivers/net/dsa/microchip/ksz8795_reg.h            |  16 --
 drivers/net/dsa/microchip/ksz9477.c                |  89 +++--------
 drivers/net/dsa/microchip/ksz9477_reg.h            |   1 -
 drivers/net/dsa/microchip/ksz_common.c             | 173 ++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h             |  47 +++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |  10 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   2 +-
 drivers/net/ethernet/intel/ice/ice.h               |  36 +++--
 drivers/net/ethernet/intel/ice/ice_lib.c           |   4 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  25 ++-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  18 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c       |  59 +++++--
 drivers/net/ethernet/lantiq_xrx200.c               |   9 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  29 ++--
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   2 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  57 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   4 +
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   9 +-
 drivers/net/ethernet/moxa/moxart_ether.c           |  11 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  95 ++++++++++-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |   4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c    |   8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   9 +-
 drivers/net/ipa/ipa_mem.c                          |   2 +-
 drivers/net/ipvlan/ipvtap.c                        |   4 +-
 drivers/net/macsec.c                               |  11 +-
 drivers/net/phy/phy_device.c                       |   8 +-
 drivers/net/usb/r8152.c                            |  27 ++--
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  47 ++++--
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   2 +
 drivers/nfc/pn533/uart.c                           |   1 +
 drivers/scsi/scsi_lib.c                            |   3 +-
 drivers/scsi/storvsc_drv.c                         |   2 +-
 drivers/video/fbdev/core/fbcon.c                   |  27 +++-
 drivers/xen/privcmd.c                              |  21 +--
 fs/btrfs/block-group.c                             |  47 ++----
 fs/btrfs/block-group.h                             |   4 +-
 fs/btrfs/ctree.h                                   |   1 -
 fs/btrfs/dev-replace.c                             |   5 +-
 fs/btrfs/extent-tree.c                             |  30 +---
 fs/btrfs/file.c                                    |   2 +
 fs/btrfs/root-tree.c                               |   5 +-
 fs/btrfs/volumes.c                                 |   5 +-
 fs/btrfs/xattr.c                                   |   3 +
 fs/cifs/smb2ops.c                                  |  12 +-
 fs/cifs/smb2pdu.c                                  |  16 +-
 fs/fs-writeback.c                                  |  12 +-
 fs/namespace.c                                     |   7 +
 fs/nfs/file.c                                      |  15 +-
 fs/nfs/inode.c                                     |   1 +
 fs/nfs/nfs4file.c                                  |   6 +
 fs/nfs/write.c                                     |   6 +-
 fs/ntfs3/xattr.c                                   |  16 +-
 fs/ocfs2/dlmglue.c                                 |   8 +-
 fs/ocfs2/super.c                                   |   3 +-
 fs/proc/task_mmu.c                                 |   7 +-
 fs/userfaultfd.c                                   |   4 +
 include/asm-generic/sections.h                     |   7 +-
 include/linux/memcontrol.h                         |  15 +-
 include/linux/mlx5/driver.h                        |   1 +
 include/linux/mm.h                                 |   1 -
 include/linux/netdevice.h                          |  20 ++-
 include/linux/netfilter_bridge/ebtables.h          |   4 -
 include/linux/nfs_fs.h                             |   1 +
 include/linux/userfaultfd_k.h                      |   2 +
 include/net/busy_poll.h                            |   2 +-
 include/net/gro.h                                  |   2 +-
 include/net/netfilter/nf_flow_table.h              |   3 +
 include/net/netfilter/nf_tables.h                  |   1 +
 include/ufs/ufshci.h                               |   6 +-
 init/main.c                                        |  18 ++-
 io_uring/io_uring.c                                |   7 +-
 kernel/audit_fsnotify.c                            |   1 +
 kernel/auditsc.c                                   |   4 +-
 kernel/bpf/verifier.c                              |  10 +-
 kernel/cgroup/cgroup.c                             |   1 +
 kernel/kprobes.c                                   |   9 +-
 kernel/sys_ni.c                                    |   1 +
 lib/ratelimit.c                                    |  12 +-
 mm/backing-dev.c                                   |  10 +-
 mm/bootmem_info.c                                  |   2 +
 mm/damon/dbgfs.c                                   |   3 +
 mm/gup.c                                           |  69 +++++---
 mm/huge_memory.c                                   |  65 +++++---
 mm/hugetlb.c                                       |  28 +++-
 mm/mmap.c                                          |   8 +-
 mm/mprotect.c                                      |   3 +-
 mm/page-writeback.c                                |   6 +-
 mm/shmem.c                                         |   1 +
 mm/userfaultfd.c                                   |  29 ++--
 net/bridge/netfilter/ebtable_broute.c              |   8 -
 net/bridge/netfilter/ebtable_filter.c              |   8 -
 net/bridge/netfilter/ebtable_nat.c                 |   8 -
 net/bridge/netfilter/ebtables.c                    |   8 +-
 net/core/bpf_sk_storage.c                          |   5 +-
 net/core/dev.c                                     |  20 +--
 net/core/filter.c                                  |  13 +-
 net/core/gro_cells.c                               |   2 +-
 net/core/skbuff.c                                  |   2 +-
 net/core/sock.c                                    |  18 ++-
 net/core/sysctl_net_core.c                         |  15 +-
 net/ipv4/devinet.c                                 |  16 +-
 net/ipv4/ip_output.c                               |   2 +-
 net/ipv4/ip_sockglue.c                             |   6 +-
 net/ipv4/tcp.c                                     |   4 +-
 net/ipv4/tcp_output.c                              |   2 +-
 net/ipv6/addrconf.c                                |   5 +-
 net/ipv6/ipv6_sockglue.c                           |   4 +-
 net/key/af_key.c                                   |   3 +
 net/mptcp/protocol.c                               |   2 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |   4 +-
 net/netfilter/nf_flow_table_core.c                 |  15 +-
 net/netfilter/nf_flow_table_offload.c              |   8 +
 net/netfilter/nf_tables_api.c                      |  14 +-
 net/netfilter/nft_osf.c                            |  18 ++-
 net/netfilter/nft_payload.c                        |  29 +++-
 net/netfilter/nft_tproxy.c                         |   8 +
 net/netfilter/nft_tunnel.c                         |   1 +
 net/rose/rose_loopback.c                           |   3 +-
 net/rxrpc/call_object.c                            |   4 +-
 net/rxrpc/sendmsg.c                                |  92 ++++++-----
 net/sched/sch_generic.c                            |   2 +-
 net/socket.c                                       |   2 +-
 net/sunrpc/clnt.c                                  |   2 +-
 net/xfrm/espintcp.c                                |   2 +-
 net/xfrm/xfrm_input.c                              |   3 +-
 net/xfrm/xfrm_output.c                             |   1 -
 net/xfrm/xfrm_policy.c                             |   3 +-
 net/xfrm/xfrm_state.c                              |   1 +
 tools/perf/Makefile.config                         |   2 +-
 tools/perf/builtin-stat.c                          |   1 +
 187 files changed, 1603 insertions(+), 917 deletions(-)


