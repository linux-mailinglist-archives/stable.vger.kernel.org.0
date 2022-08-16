Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02423595C9B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 15:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiHPNBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 09:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234824AbiHPNAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 09:00:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC155B14E6;
        Tue, 16 Aug 2022 05:59:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A565AB818DF;
        Tue, 16 Aug 2022 12:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCD1C433D6;
        Tue, 16 Aug 2022 12:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660654782;
        bh=VY6KIrS/u5IeFuJ3jJMaSmGMf6gYsR7N4vYbjfTmXWI=;
        h=From:To:Cc:Subject:Date:From;
        b=GLlAuGSmMHfH+NJta9synxt1qWR7JwBacPQeCGFnWOipz6h/7kCYiofsGoTSD1O0u
         K5Qw6m+2mtpsSUz7+lVafqqGhvfaAuY1gFlgeSkPBQ1worhrJAfD8BC59UA4f8idfP
         42L1MUCxg6eZCB/OEcnzxJkjMbV1GA5xSIN/7dNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.19 0000/1157] 5.19.2-rc2 review
Date:   Tue, 16 Aug 2022 14:59:38 +0200
Message-Id: <20220816124610.393032991@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.2-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.19.2-rc2
X-KernelTest-Deadline: 2022-08-18T12:46+00:00
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

This is the start of the stable review cycle for the 5.19.2 release.
There are 1157 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 18 Aug 2022 12:43:10 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.2-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.19.2-rc2

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: avs: Use lookup table to create modules

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: mem-account pbuf buckets

Russell Currey <ruscur@russell.cc>
    powerpc/kexec: Fix build failure from uninitialised variable

Alexander Gordeev <agordeev@linux.ibm.com>
    Revert "s390/smp: enforce lowcore protection on CPU restart"

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: fix min gate len calculation for tc when its first gate is closed

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Use a copy of the va_list for __assign_vstr()

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: remove chandef check in cfg80211_cac_event()

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: acquire wdev mutex earlier in start_ap

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: relax wdev mutex check in wdev_chandef()

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: hold wdev mutex for tid config

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: handle IBSS in channel switch

Paolo Abeni <pabeni@redhat.com>
    mptcp: refine memory scheduling

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "devcoredump: remove the useless gfp_t parameter in dev_coredumpv and dev_coredumpm"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv"

Eric Dumazet <edumazet@google.com>
    raw: fix a typo in raw_icmp_error()

Eric Dumazet <edumazet@google.com>
    raw: remove unused variables from raw6_icmp_error()

Jason A. Donenfeld <Jason@zx2c4.com>
    crypto: lib/blake2s - reduce stack frame usage in self test

Eric Dumazet <edumazet@google.com>
    tcp: fix over estimation in sk_forced_mem_schedule()

Robert Foss <robert.foss@linaro.org>
    Revert "drm/bridge: anx7625: Use DPI bus type"

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    net_sched: cls_route: remove from list when handle is 0

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc64/ftrace: Fix ftrace for clang builds

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc: Fix eh field when calling lwarx on PPC32

SeongJae Park <sj@kernel.org>
    xen-blkfront: Apply 'feature_persistent' parameter when connect

Maximilian Heyne <mheyne@amazon.de>
    xen-blkback: Apply 'feature_persistent' parameter when connect

SeongJae Park <sj@kernel.org>
    xen-blkback: fix persistent grants negotiation

Mårten Lindahl <marten.lindahl@axis.com>
    tpm: Add check for Failure mode for TPM2 modules

Huacai Chen <chenhuacai@kernel.org>
    tpm: eventlog: Fix section mismatch for DEBUG_SECTION_MISMATCH

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    KEYS: asymmetric: enforce SM2 signature use pkey algo

Jan Kara <jack@suse.cz>
    ext4: fix race when reusing xattr blocks

Jan Kara <jack@suse.cz>
    ext4: unindent codeblock in ext4_xattr_block_set()

Jan Kara <jack@suse.cz>
    ext4: remove EA inode entry from mbcache on inode eviction

Lukas Czerner <lczerner@redhat.com>
    ext4: make sure ext4_append() always allocates new block

Lukas Czerner <lczerner@redhat.com>
    ext4: check if directory block is within i_size

Bagas Sanjaya <bagasdotme@gmail.com>
    Documentation: ext4: fix cell spacing of table heading on blockmap table

Ye Bin <yebin10@huawei.com>
    ext4: fix warning in ext4_iomap_begin as race between bmap and write

Baokun Li <libaokun1@huawei.com>
    ext4: correct the misjudgment in ext4_iget_extra_inode

Baokun Li <libaokun1@huawei.com>
    ext4: correct max_inline_xattr_value_size computing

Baokun Li <libaokun1@huawei.com>
    ext4: fix use-after-free in ext4_xattr_set_entry

Baokun Li <libaokun1@huawei.com>
    ext4: add EXT4_INODE_HAS_XATTR_SPACE macro in xattr.h

Eric Whitney <enwlinux@gmail.com>
    ext4: fix extent status tree race in writeback error recovery path

Theodore Ts'o <tytso@mit.edu>
    ext4: update s_overhead_clusters in the superblock during an on-line resize

Zhang Yi <yi.zhang@huawei.com>
    ext4: fix reading leftover inlined symlinks

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Use a struct alignof to determine trace event field alignment

Steven Rostedt (Google) <rostedt@goodmis.org>
    batman-adv: tracing: Use the new __vstring() helper

Miaohe Lin <linmiaohe@huawei.com>
    hugetlb_cgroup: fix wrong hugetlb cgroup numa stat

Jianglei Nie <niejianglei2021@163.com>
    mm/damon/reclaim: fix potential memory leak in damon_reclaim_init()

Mike Snitzer <snitzer@kernel.org>
    dm: fix dm-raid crash if md_handle_request() splits bio

Mikulas Patocka <mpatocka@redhat.com>
    dm raid: fix address sanitizer warning in raid_resume

Mikulas Patocka <mpatocka@redhat.com>
    dm raid: fix address sanitizer warning in raid_status

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Attempt to load PERF_GLOBAL_CTRL on nVMX xfer iff it exists

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Add helper to check if the guest PMU has PERF_GLOBAL_CTRL

Sean Christopherson <seanjc@google.com>
    Revert "KVM: x86/pmu: Accept 0 for absent PMU MSRs when host-initiated if !enable_pmu"

Like Xu <likexu@tencent.com>
    KVM: x86/pmu: Accept 0 for absent PMU MSRs when host-initiated if !enable_pmu

Like Xu <likexu@tencent.com>
    KVM: x86/pmu: Ignore pmu->global_ctrl check if vPMU doesn't support global_ctrl

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Mark all PERF_GLOBAL_(OVF)_CTRL bits reserved if there's no vPMU

Like Xu <like.xu@linux.intel.com>
    KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter

Sumanth Korikkar <sumanthk@linux.ibm.com>
    s390/unwind: fix fgraph return address recovery

Jason A. Donenfeld <Jason@zx2c4.com>
    powerpc/powernv/kvm: Use darn for H_RANDOM on Power9

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: CPPC: Do not prevent CPPC from working in the future

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    intel_idle: make SPR C1 and C1E be independent

Filipe Manana <fdmanana@suse.com>
    btrfs: join running log transaction when logging new name

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: wait until zone is finished when allocation didn't progress

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: write out partially allocated region

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: activate necessary block group

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: activate metadata block group on flush_space

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: introduce space_info->active_total_bytes

Stefan Roesch <shr@fb.com>
    btrfs: store chunk size in space-info struct

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: disable metadata overcommit for zoned

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: finish least available block group on data bg allocation

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: let can_allocate_chunk return error

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: convert count_max_extents() to use fs_info->max_extent_size

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: replace BTRFS_MAX_EXTENT_SIZE with fs_info->max_extent_size

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: revive max_zone_append_bytes

Naohiro Aota <naohiro.aota@wdc.com>
    block: add bdev_max_segments() helper

Nikolay Borisov <nborisov@suse.com>
    btrfs: properly flag filesystem with BTRFS_FEATURE_INCOMPAT_BIG_METADATA

Josef Bacik <josef@toxicpanda.com>
    btrfs: reset block group chunk force if we have to wait

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: fix error handling of fallback uncompress write

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: ensure pages are unlocked on cow_file_range() failure

Josef Bacik <josef@toxicpanda.com>
    btrfs: tree-log: make the return value for log syncing consistent

Jinke Han <hanjinke.666@bytedance.com>
    block: don't allow the same type rq_qos add more than once

Chen Zhongjin <chenzhongjin@huawei.com>
    locking/csd_lock: Change csdlock_debug from early_param to __setup

Jason A. Donenfeld <Jason@zx2c4.com>
    timekeeping: contribute wall clock to rng on time change

Pali Rohár <pali@kernel.org>
    ARM: Marvell: Update PCIe fixup

Tyler Hicks <tyhicks@linux.microsoft.com>
    net/9p: Initialize the iounit field during fid creation

Luo Meng <luomeng12@huawei.com>
    dm thin: fix use-after-free crash in dm_sm_register_threshold_callback

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/events: Add __vstring() and __assign_vstr() helper macros

Michal Suchanek <msuchanek@suse.de>
    kexec, KEYS, s390: Make use of built-in and secondary keyring for signature verification

Coiby Xu <coxu@redhat.com>
    kexec: clean up arch_kexec_kernel_verify_sig

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    kexec_file: drop weak attribute from functions

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: set a default MAX_WRITEBACK_JOBS

Robert Marko <robimarko@gmail.com>
    PCI: qcom: Power on PHY before IPQ8074 DBI register accesses

Mohamed Khalfella <mkhalfella@purestorage.com>
    PCI/AER: Iterate over error counters instead of error strings

Alexander Lobakin <alexandr.lobakin@intel.com>
    iommu/vt-d: avoid invalid memory access via node_online(NUMA_NO_NODE)

Sean Christopherson <seanjc@google.com>
    KVM: x86: Signal #GP, not -EPERM, on bad WRMSR(MCi_CTL/STATUS)

Lev Kujawski <lkujaw@member.fsf.org>
    KVM: set_msr_mce: Permit guests to ignore single-bit ECC errors

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Raptor Lake-S CPU support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Raptor Lake-S PCH support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Meteor Lake-P support

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scpi: Ensure scpi_info is not assigned if the probe fails

Jason A. Donenfeld <Jason@zx2c4.com>
    crypto: blake2s - remove shash module

Jitao Shi <jitao.shi@mediatek.com>
    drm/mediatek: Keep dsi as LP00 before dcs cmds transfer

Phil Auld <pauld@redhat.com>
    drivers/base: fix userspace break from using bin_attributes for cpumap and cpulist

Guo Ren <guoren@kernel.org>
    csky: abiv1: Fixup compile error

David Collins <quic_collinsd@quicinc.com>
    spmi: trace: fix stack-out-of-bound access in SPMI tracing functions

Al Viro <viro@zeniv.linux.org.uk>
    __follow_mount_rcu(): verify that mount_lock remains unchanged

Xie Shaowen <studentxswpy@163.com>
    Input: gscps2 - check return value of ioremap() in gscps2_probe()

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    posix-cpu-timers: Cleanup CPU timers before freeing them during exec

Bharath SM <bharathsm@microsoft.com>
    SMB3: fix lease break timeout when multiple deferred close handles for the same file.

Alexander Lobakin <alexandr.lobakin@intel.com>
    x86/olpc: fix 'logical not is only applied to the left hand side'

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    x86/kprobes: Update kcb status flag after singlestepping

Steven Rostedt (Google) <rostedt@goodmis.org>
    ftrace/x86: Add back ftrace_expected assignment

Kim Phillips <kim.phillips@amd.com>
    x86/bugs: Enable STIBP for IBPB mitigated RETBleed

Paulo Alcantara <pc@cjr.nz>
    cifs: fix lock length calculation

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix losing FCP-2 targets during port perturbation tests

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix losing target when it reappears during delete

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix losing FCP-2 targets on long port disable with I/Os

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Wind down adapter after PCIe error

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix erroneous mailbox timeout after PCI error injection

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix excessive I/O error messages by default

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix crash due to stale SRB access around I/O timeouts

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Turn off multi-queue for 8G adapters

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix discovery issues in FC-AL topology

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix imbalance vha->vref_count

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: Fix missing auto port scan and thus missing target ports

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Correct ufshcd_shutdown() flow

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: s3fb: Check the size of screen before memset_io()

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: arkfb: Check the size of screen before memset_io()

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: vt8623fb: Check the size of screen before memset_io()

Jaewook Kim <jw5454.kim@samsung.com>
    f2fs: do not allow to decompress files have FI_COMPRESS_RELEASED

Andrea Righi <andrea.righi@canonical.com>
    x86/entry: Build thunk_$(BITS) only if CONFIG_PREEMPTION=y

Mel Gorman <mgorman@techsingularity.net>
    sched/core: Do not requeue task on CPU excluded from cpus_mask

Tianchen Ding <dtcccc@linux.alibaba.com>
    sched: Remove the limitation of WF_ON_CPU on wakelist if wakee cpu is idle

Tianchen Ding <dtcccc@linux.alibaba.com>
    sched: Fix the check of nr_running at queue wakelist

Florian Fainelli <f.fainelli@gmail.com>
    tools/thermal: Fix possible path truncations

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: arkfb: Fix a divide-by-zero bug in ark_set_pixclock()

Siddh Raman Pant <code@siddh.me>
    x86/numa: Use cpumask_available instead of hardcoded NULL check

Waiman Long <longman@redhat.com>
    sched, cpuset: Fix dl_cpu_busy() panic due to empty cs->cpus_allowed

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64e: Fix kexec build error

Douglas Anderson <dianders@chromium.org>
    tty: serial: qcom-geni-serial: Fix %lu -> %u in print statements

Josh Poimboeuf <jpoimboe@kernel.org>
    scripts/faddr2line: Fix vmlinux detection on arm64

Arnaldo Carvalho de Melo <acme@redhat.com>
    genelf: Use HAVE_LIBCRYPTO_SUPPORT, not the never defined HAVE_LIBCRYPTO

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pci: Fix PHB numbering when using opal-phbid

Chenyi Qiang <chenyi.qiang@intel.com>
    x86/bus_lock: Don't assume the init value of DEBUGCTLMSR.BUS_LOCK_DETECT to be zero

Chen Zhongjin <chenzhongjin@huawei.com>
    kprobes: Forbid probing on trampoline and BPF code areas

Ian Rogers <irogers@google.com>
    perf symbol: Fail to read phdr workaround

Miaoqian Lin <linmq006@gmail.com>
    powerpc/cell/axon_msi: Fix refcount leak in setup_msi_msg_address

Miaoqian Lin <linmq006@gmail.com>
    powerpc/xive: Fix refcount leak in xive_get_max_prio

Miaoqian Lin <linmq006@gmail.com>
    powerpc/spufs: Fix refcount leak in spufs_init_isolated_loader

Matthew Wilcox (Oracle) <willy@infradead.org>
    cifs: Fix memory leak when using fscache

Chao Liu <liuchao@coolpad.com>
    f2fs: fix to remove F2FS_COMPR_FL and tag F2FS_NOCOMP_FL at the same time

Chao Yu <chao@kernel.org>
    f2fs: fix to check inline_data during compressed inode conversion

Chao Yu <chao@kernel.org>
    f2fs: fix to invalidate META_MAPPING before DIO write

Kan Liang <kan.liang@linux.intel.com>
    perf stat: Revert "perf stat: Add default hybrid events"

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/smp: enforce lowcore protection on CPU restart

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: correct the count of break characters

Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>
    tty: serial: qcom-geni-serial: Fix get_clk_div_rate() which otherwise could return a sub-optimal clock rate.

Guo Mengqi <guomengqi3@huawei.com>
    serial: 8250_bcm2835aux: Add missing clk_disable_unprepare()

Rashmica Gupta <rashmica@linux.ibm.com>
    selftests/powerpc: Fix matrix multiply assist test

Pali Rohár <pali@kernel.org>
    powerpc/pci: Prefer PCI domain assignment via DT 'linux,pci-domain' and alias

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/iommu: Fix iommu_table_in_use for a small default DMA window case

Alexey Kardashevskiy <aik@ozlabs.ru>
    pseries/iommu/ddw: Fix kdump to work in absence of ibm,dma-window

Christophe Leroy <christophe.leroy@csgroup.eu>
    video: fbdev: offb: Include missing linux/platform_device.h

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Do not allow selection of e5500 or e6500 CPUs on PPC32

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32s: Fix boot failure with KASAN + SMP + JUMP_LABEL_FEATURE_CHECK_DEBUG

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Call mmu_mark_initmem_nx() regardless of data block mapping.

Claudiu Beznea <claudiu.beznea@microchip.com>
    ASoC: mchp-spdifrx: disable end of block interrupt on failures

Rustam Subkhankulov <subkhankulov@ispras.ru>
    video: fbdev: sis: fix typos in SiS_GetModeID()

Liang He <windhl@126.com>
    video: fbdev: amba-clcd: Fix refcount leak bugs

Yong Zhi <yong.zhi@intel.com>
    ASoC: Intel: sof_rt5682: Perform quirk check first in card late probe

William Dean <williamsukatube@gmail.com>
    watchdog: armada_37xx_wdt: check the return value of devm_ioremap() in armada_37xx_wdt_probe()

Jean Delvare <jdelvare@suse.de>
    watchdog: sp5100_tco: Fix a memory leak of EFCH MMIO resource

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    watchdog: f71808e_wdt: Add check for platform_driver_register

Liang He <windhl@126.com>
    ASoC: audio-graph-card2: Add of_node_put() in fail path

Liang He <windhl@126.com>
    ASoC: audio-graph-card: Add of_node_put() in fail path

Xie Yongji <xieyongji@bytedance.com>
    fuse: Remove the control interface for virtio-fs

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: qcom: q6dsp: Fix an off-by-one in q6adm_alloc_copp()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: imx-card: use snd_pcm_format_t type for asrc_format

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_easrc: use snd_pcm_format_t type for sample_format

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl-asoc-card: force cast the asrc_format type

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_asrc: force cast the asrc_format type

Thomas Richter <tmricht@linux.ibm.com>
    perf test: Fix test case 83 ('perf stat CSV output linter') on s390

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/zcore: fix race when reading from hardware system area

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/crash: fix incorrect number of bytes to copy to user space

Sunil V L <sunilvl@ventanamicro.com>
    riscv: spinwait: Fix hartid variable type

Adrian Hunter <adrian.hunter@intel.com>
    perf tools: Fix dso_id inode generation comparison

Liang He <windhl@126.com>
    iommu/arm-smmu: qcom_iommu: Add of_node_put() when breaking out of loop

Mario Limonciello <mario.limonciello@amd.com>
    ASoC: amd: yc: Decrease level of error message

Miaoqian Lin <linmq006@gmail.com>
    mfd: max77620: Fix refcount leak in max77620_initialise_fps

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mfd: t7l66xb: Drop platform disable callback

Sibi Sankar <quic_sibis@quicinc.com>
    remoteproc: sysmon: Wait for SSCTL service to come up

Siddharth Gupta <sidgup@codeaurora.org>
    remoteproc: qcom: pas: Check if coredump is enabled

Zhihao Cheng <chengzhihao1@huawei.com>
    proc: fix a dentry lock race between release_task and lookup

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    lib/smp_processor_id: fix imbalanced instrumentation_end() call

Dan Carpenter <dan.carpenter@oracle.com>
    kfifo: fix kfifo_to_user() return type

Emil Renner Berthing <emil.renner.berthing@canonical.com>
    leds: pwm-multicolor: Don't show -EPROBE_DEFER as errors

Miaoqian Lin <linmq006@gmail.com>
    rpmsg: qcom_smd: Fix refcount leak in qcom_smd_parse_edge

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: Fixed __debug_virt_addr_valid()

Hangyu Hua <hbh25y@gmail.com>
    net: 9p: fix refcount leak in p9_read_work() error handling

Kent Overstreet <kent.overstreet@gmail.com>
    9p: Add client parameter to p9_req_put()

Kent Overstreet <kent.overstreet@gmail.com>
    9p: Drop kref usage

Sam Protsenko <semen.protsenko@linaro.org>
    iommu/exynos: Handle failed IOMMU device registration properly

Doug Berger <opendmb@gmail.com>
    serial: 8250_bcm7271: Save/restore RTS in suspend/resume

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: SOF: ipc-msg-injector: fix copy in sof_msg_inject_ipc4_dfs_write()

Liang He <windhl@126.com>
    ASoC: mt6359: Fix refcount leak bug

Liang He <windhl@126.com>
    ASoc: audio-graph-card2: Fix refcount leak bug in __graph_get_type()

Yang Yingliang <yangyingliang@huawei.com>
    cpufreq: mediatek: fix error return code in mtk_cpu_dvfs_info_init()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc3-topology: Prevent double freeing of ipc_control_data via load_bytes

Alexander Lobakin <alexandr.lobakin@intel.com>
    lib/bitmap: fix off-by-one in bitmap_to_arr64()

Robin Murphy <robin.murphy@arm.com>
    swiotlb: fail map correctly with failed io_tlb_default_mem

YC Hung <yc.hung@mediatek.com>
    ASoC: SOF: mediatek: fix mt8195 StatvectorSel wrong setting

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: vdso: Utilize __pa() for gic_pfn

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix missing corner cases in gsmld_poll()

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix flow control handling in tx path

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix DM command

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong T1 retry count handling

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    serial: 8250_fsl: Don't report FE, PE and OE twice

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: audio-graph-card2.c: use of_property_read_u32() for rate

Eric Farman <farman@linux.ibm.com>
    vfio/ccw: Do not change FSM state in subchannel event

Eric Farman <farman@linux.ibm.com>
    vfio/ccw: Fix FSM state if mdev probe fails

Michael Kawano <mkawano@linux.ibm.com>
    vfio/ccw: Remove UUID from s390 debug log

Sireesh Kodali <sireeshkodali1@gmail.com>
    remoteproc: qcom: wcnss: Fix handling of IRQs

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: imx-card: Fix DSD/PDM mclk frequency

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: Loongson64: Fix section mismatch warning

Liang He <windhl@126.com>
    ASoC: qcom: Fix missing of_node_put() in asoc_qcom_lpass_cpu_platform_probe()

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix resource allocation order in gsm_activate_mux()

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix deadlock and link starvation in outgoing data path

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix race condition in gsmld_write()

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix packet re-transmission without open control channel

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix non flow control frames during mux flow off

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix missing timer to handle stalled links

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong queuing behavior in gsm_dlci_data_output()

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix tty registration before control channel open

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix user open not possible at responder until initiator open

Alexander Lobakin <alexandr.lobakin@intel.com>
    net/ice: fix initializing the bitmap in the switch code

Yishai Hadas <yishaih@nvidia.com>
    vfio: Split migration ops from main device ops

Yishai Hadas <yishaih@nvidia.com>
    vfio/mlx5: Protect mlx5vf_disable_fds() upon close device

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wsa881x: handle timeouts in resume path

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dw: Take port lock while accessing LSR

Tom Rix <trix@redhat.com>
    ASoC: samsung: change gpiod_speaker_power and rx1950_audio from global to static variables

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-core.c: fixup snd_soc_of_get_dai_link_cpus()

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Optimize clearing the pending PMI and remove WARN_ON for PMI check in power_pmu_disable

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: samsung: h1940_uda1380: include proepr GPIO consumer header

Michael Ellerman <mpe@ellerman.id.au>
    selftests/powerpc: Skip energy_scale_info test on older firmware

Hangyu Hua <hbh25y@gmail.com>
    rpmsg: Fix possible refcount leak in rpmsg_register_device_override()

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: PPC: Book3s: Fix warning about xics_rm_h_xirr_x

Miaoqian Lin <linmq006@gmail.com>
    remoteproc: imx_rproc: Fix refcount leak in imx_rproc_addr_init

Chen Zhongjin <chenzhongjin@huawei.com>
    profiling: fix shift too large makes kernel panic

Joe Lawrence <joe.lawrence@redhat.com>
    selftests/livepatch: better synchronize test_klp_callbacks_busy

Miaoqian Lin <linmq006@gmail.com>
    remoteproc: k3-r5: Fix refcount leak in k3_r5_cluster_of_init

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    rpmsg: mtk_rpmsg: Fix circular locking dependency

Shengjiu Wang <shengjiu.wang@nxp.com>
    rpmsg: char: Add mutex protection for rpmsg_eptdev_open()

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs35l45: Add endianness flag in snd_soc_component_driver

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd9335: move gains from SX_TLV to S8_TLV

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: msm8916-wcd-digital: move gains from SX_TLV to S8_TLV

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: make ctx_store and ctx_restore as optional

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dw: Store LSR into lsr_saved_flags in dw8250_tx_wait_empty()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dw: Use serial_lsr_in() in dw8250_handle_irq()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Get preserved flags using serial_lsr_in()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Create serial_lsr_in()

Yang Yingliang <yangyingliang@huawei.com>
    serial: pic32: fix missing clk_disable_unprepare() on error in pic32_uart_startup()

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mediatek: mt8173-rt5650: Fix refcount leak in mt8173_rt5650_dev_probe

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: codecs: da7210: add check for i2c_add_driver

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mt6797-mt6351: Fix refcount leak in mt6797_mt6351_dev_probe

Randy Dunlap <rdunlap@infradead.org>
    ASoC: max98390: use linux/gpio/consumer.h to fix build

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mediatek: mt8173: Fix refcount leak in mt8173_rt5650_rt5676_dev_probe

Fabio Estevam <festevam@gmail.com>
    ASoC: imx-audmux: Silence a clang warning

Miaoqian Lin <linmq006@gmail.com>
    ASoC: samsung: Fix error handling in aries_audio_probe

Miaoqian Lin <linmq006@gmail.com>
    ASoC: cros_ec_codec: Fix refcount leak in cros_ec_codec_platform_probe

Tang Bin <tangbin@cmss.chinamobile.com>
    opp: Fix error check in dev_pm_opp_attach_genpd()

Nathan Chancellor <nathan@kernel.org>
    usb: cdns3: Don't use priv_dev uninitialized in cdns3_gadget_ep_enable()

Zhihao Cheng <chengzhihao1@huawei.com>
    jbd2: fix assertion 'jh->b_frozen_data == NULL' failure when journal aborted

Li Lingfeng <lilingfeng3@huawei.com>
    ext4: recover csum seed of tmp_inode after migrating to extents

Zhang Yi <yi.zhang@huawei.com>
    jbd2: fix outstanding credits assert in jbd2_journal_commit_transaction()

Keith Busch <kbusch@kernel.org>
    block: ensure iov_iter advances for added pages

Keith Busch <kbusch@kernel.org>
    block/bio: remove duplicate append pages code

Christoph Hellwig <hch@lst.de>
    nvme: catch -ENODEV from nvme_revalidate_zones again

Nick Bowler <nbowler@draconx.ca>
    nvme: define compat_ioctl again to unbreak 32-bit userspace.

Bean Huo <beanhuo@micron.com>
    nvme: use command_id instead of req->tag in trace_nvme_complete_rq()

Christoph Hellwig <hch@lst.de>
    mtip32xx: fix device removal

Yu Kuai <yukuai3@huawei.com>
    nbd: add missing definition of pr_fmt

Dan Carpenter <dan.carpenter@oracle.com>
    null_blk: fix ida error handling in null_add_dev()

Md Haris Iqbal <haris.iqbal@ionos.com>
    block/rnbd-srv: Set keep_id to true after mutex_trylock

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix error unwind in rxe_create_qp()

Maor Gottlieb <maorg@nvidia.com>
    RDMA/mlx5: Add missing check for return value in get namespace flow

Xu Qiang <xuqiang36@huawei.com>
    of/fdt: declared return type does not match actual return type

Andrei Vagin <avagin@google.com>
    selftests: kvm: set rax before vmcall

Juergen Gross <jgross@suse.com>
    xen: don't require virtio with grants for non-PV guests

Juergen Gross <jgross@suse.com>
    virtio: replace restricted mem access flag with callback

Andreas Schwab <schwab@suse.de>
    rtla: Fix double free

Daniel Bristot de Oliveira <bristot@kernel.org>
    rtla: Fix Makefile when called from -C tools/

Dan Carpenter <dan.carpenter@oracle.com>
    selftest/vm: uninitialized variable in main()

Dan Carpenter <dan.carpenter@oracle.com>
    tools/testing/selftests/vm/hugetlb-madvise.c: silence uninitialized variable warning

Adam Sindelar <adam@wowsignal.io>
    selftests/vm: fix errno handling in mrelease_test

Miaohe Lin <linmiaohe@huawei.com>
    mm/mmap.c: fix missing call to vm_unacct_memory in mmap_region

Liam R. Howlett <Liam.Howlett@oracle.com>
    android: binder: stop saving a pointer to the VMA

Bart Van Assche <bvanassche@acm.org>
    RDMA/srpt: Fix a use-after-free

Bart Van Assche <bvanassche@acm.org>
    RDMA/srpt: Introduce a reference count in struct srpt_device

Bart Van Assche <bvanassche@acm.org>
    RDMA/srpt: Duplicate port name members

Dan Carpenter <dan.carpenter@oracle.com>
    platform/olpc: Fix uninitialized data in debugfs write

Vadim Pasternak <vadimp@nvidia.com>
    platform/mellanox: mlxreg-lc: Fix error flow and extend verbosity

Hans de Goede <hdegoede@redhat.com>
    platform/x86: pmc_atom: Match all Lex BayTrail boards with critclk_systems DMI table

Dan Carpenter <dan.carpenter@oracle.com>
    tools/power/x86/intel-speed-select: Fix off by one check

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Set UMIP bit CR4_FIXED1 MSR when emulating UMIP

Peter Suti <peter.suti@streamunlimited.com>
    staging: fbtft: core: set smem_len before fb_deferred_io_init call

Patrice Chotard <patrice.chotard@foss.st.com>
    mtd: spi-nor: fix spi_nor_spimem_setup_op() call in spi_nor_erase_{sector,chip}()

Andrey Strachuk <strochuk@ispras.ru>
    usb: cdns3: change place of 'priv_ep' assignment in cdns3_gadget_ep_dequeue(), cdns3_gadget_ep_enable()

Alexey Sheplyakov <asheplyakov@basealt.ru>
    usb: xhci_plat_remove: avoid NULL dereference

Johan Hovold <johan@kernel.org>
    USB: serial: fix tty-port initialized comments

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Handle condition of "no sensors"

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Fix link up retry sequence

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Fix Root Port interrupt handling

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix rnr retry behavior

Md Haris Iqbal <haris.phnx@gmail.com>
    RDMA/rxe: For invalidate compare according to set keys in mr

Artem Borisov <dedsa2002@gmail.com>
    HID: alps: Declare U1_UNICORN_LEGACY support

Liang He <windhl@126.com>
    mmc: cavium-thunderx: Add of_node_put() when breaking out of loop

Liang He <windhl@126.com>
    mmc: cavium-octeon: Add of_node_put() when breaking out of loop

Liang He <windhl@126.com>
    mmc: core: quirks: Add of_node_put() when breaking out of loop

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix mw bind to allow any consumer key portion

Antonio Borneo <antonio.borneo@foss.st.com>
    scripts/gdb: fix 'lx-dmesg' on 32 bits arch

Fabio Estevam <festevam@denx.de>
    dmaengine: imx-dma: Cast of_device_get_match_data() with (uintptr_t)

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Add NULL check for hid device

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    HID: mcp2221: prevent a buffer overflow in mcp_smbus_write()

Dan Carpenter <dan.carpenter@oracle.com>
    iio: adc: max1027: unlock on error path in max1027_read_single_value()

Liang He <windhl@126.com>
    gpio: gpiolib-of: Fix refcount bugs in of_mm_gpiochip_add_data()

Jianglei Nie <niejianglei2021@163.com>
    RDMA/hfi1: fix potential memory leak in setup_base_ctxt()

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    clk: qcom: gcc-msm8939: Fix weird field spacing in ftbl_gcc_camss_cci_clk

Bjorn Andersson <bjorn.andersson@linaro.org>
    clk: qcom: gdsc: Bump parent usage count when GDSC is found enabled

Abel Vesa <abel.vesa@linaro.org>
    clk: qcom: Drop mmcx gdsc supply for dispcc and videocc

Gwendal Grignou <gwendal@chromium.org>
    iio: cros: Register FIFO callback after sensor is registered

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix BUG: KASAN: null-ptr-deref in rxe_qp_do_cleanup

Cheng Xu <chengyou@linux.alibaba.com>
    RDMA/siw: Fix duplicated reported IW_CM_EVENT_CONNECT_REPLY event

Haoyue Xu <xuhaoyue1@hisilicon.com>
    RDMA/hns: Fix incorrect clearing of interrupt status register

Jianglei Nie <niejianglei2021@163.com>
    RDMA/qedr: Fix potential memory leak in __qedr_alloc_mr()

Md Haris Iqbal <haris.iqbal@ionos.com>
    RDMA/rtrs-clt: Replace list_next_or_null_rr_rcu with an inline function

Jack Wang <jinpu.wang@ionos.com>
    RDMA/rtrs-srv: Fix modinfo output for stringify

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Fix setting of QP context err_rq_idx_valid field

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Fix VLAN connection with wildcard address

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Fix a window for use-after-free

Patrick Wang <patrick.wang.shcn@gmail.com>
    mm: percpu: use kmemleak_ignore_phys() instead of kmemleak_free()

Christopher Obbard <chris.obbard@collabora.com>
    um: random: Don't initialise hwrng struct with zero

Kalesh Singh <kaleshsingh@google.com>
    KVM: arm64: Fix hypervisor address symbolization

Peng Fan <peng.fan@nxp.com>
    interconnect: imx: fix max_node_id

Samuel Holland <samuel@sholland.org>
    phy: rockchip-inno-usb2: Ignore OTG IRQs in host mode

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    phy: stm32: fix error return in stm32_usbphyc_phy_init

Dan Carpenter <dan.carpenter@oracle.com>
    eeprom: idt_89hpesx: uninitialized data in idt_dbgfs_csr_write()

Johan Hovold <johan+linaro@kernel.org>
    usb: dwc3: qcom: fix missing optional irq warnings

Rohith Kollalsi <quic_rkollals@quicinc.com>
    usb: dwc3: core: Do not perform GCTL_CORE_SOFTRESET during bootup

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: core: Deprecate GCTL.CORESOFTRESET

Liang He <windhl@126.com>
    usb: aspeed-vhub: Fix refcount leak bug in ast_vhub_init_desc()

Randy Dunlap <rdunlap@infradead.org>
    usb: gadget: udc: amd5536 depends on HAS_DMA

Yang Yingliang <yangyingliang@huawei.com>
    xtensa: iss: fix handling error cases in iss_net_configure()

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: iss/network: provide release() callback

Mahesh Rajashekhara <Mahesh.Rajashekhara@microchip.com>
    scsi: smartpqi: Fix DMA direction for RAID requests

Christian Marangi <ansuelsmth@gmail.com>
    PCI: qcom: Set up rev 2.1.0 PARF_PHY before enabling clocks

Stefan Roese <sr@denx.de>
    PCI/portdrv: Don't disable AER reporting in get_port_device_capability()

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: pv: leak the topmost page table when destroy fails

Christian Loehle <CLoehle@hyperstone.com>
    mmc: block: Add single read for 4k sector cards

Liang He <windhl@126.com>
    of: device: Fix missing of_node_put() in of_dma_set_restricted_buffer

Eugen Hristev <eugen.hristev@microchip.com>
    mmc: sdhci-of-at91: fix set_uhs_signaling rewriting of MC1R

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    memstick/ms_block: Fix a memory leak

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    memstick/ms_block: Fix some incorrect memory allocation

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    mmc: renesas_sdhi: Get the reset handle early in the probe

Fabio Estevam <festevam@gmail.com>
    mmc: mxcmmc: Silence a clang warning

Miaoqian Lin <linmq006@gmail.com>
    mmc: sdhci-of-esdhc: Fix refcount leak in esdhc_signal_voltage_switch

Bhupesh Sharma <bhupesh.sharma@linaro.org>
    dt-bindings: mmc: sdhci-msm: Fix issues in yaml bindings

Dan Carpenter <dan.carpenter@oracle.com>
    habanalabs: fix double unlock on error in map_device_va()

jianchunfu <jianchunfu@cmss.chinamobile.com>
    rtla/utils: Use calloc and check the potential memory allocation failure

Duoming Zhou <duoming@zju.edu.cn>
    staging: rtl8192u: Fix sleep in atomic context bug in dm_fsync_timer_callback

Carlos Llamas <cmllamas@google.com>
    binder: fix redefinition of seq_file attributes

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: msu: Fix vmalloced buffers

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    intel_th: msu-sink: Potential dereference of null pointer

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    intel_th: Fix a resource leak in an error handling path

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Revert RSCN_MEMENTO workaround for misbehaved configuration

Bart Van Assche <bvanassche@acm.org>
    scsi: sd: Rework asynchronous resume support

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: qla2xxx: Check correct variable in qla24xx_async_gffid()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    phy: qcom-qmp: fix the QSERDES_V5_COM_CMN_MODE register

Shunsuke Mie <mie@igel.co.jp>
    PCI: endpoint: Don't stop controller when unbinding endpoint function

Viacheslav Mitrofanov <v.v.mitrofanov@yadro.com>
    dmaengine: sf-pdma: Add multithread support for a DMA channel

Quentin Perret <qperret@google.com>
    KVM: arm64: Don't return from void function

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: revisit driver bind/unbind and callbacks

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: bus_type: fix remove and shutdown support

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    PCI: dwc: Always enable CDM check if "snps,enable-cdm-check" exists

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    PCI: dwc: Deallocate EPC memory on dw_pcie_ep_init() errors

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    PCI: dwc: Set INCREASE_REGION_SIZE flag based on limit address

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    PCI: dwc: Disable outbound windows only for controllers using iATU

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    PCI: dwc: Add unroll iATU space support to dw_pcie_disable_atu()

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    PCI: dwc: Stop link on host_init errors and de-initialization

Peter Geis <pgwipeout@gmail.com>
    phy: rockchip-inno-usb2: Sync initial otg state

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    phy: ti: tusb1210: Don't check for write errors when powering on

Tianyu Li <tianyu.li@arm.com>
    mm/mempolicy: fix get_nodes out of bound access

Andrey Konovalov <andreyknvl@gmail.com>
    kasan: fix zeroing vmalloc memory with HW_TAGS

Andrey Konovalov <andreyknvl@gmail.com>
    mm: introduce clear_highpage_kasan_tagged

Miaohe Lin <linmiaohe@huawei.com>
    mm/migration: fix potential pte_unmap on an not mapped pte

Miaohe Lin <linmiaohe@huawei.com>
    mm/migration: return errno when isolate_huge_page failed

Yang Shi <shy828301@gmail.com>
    mm: rmap: use the correct parameter name for DEFINE_PAGE_VMA_WALK

Yushan Zhou <katrinzhou@tencent.com>
    kernfs: fix potential NULL dereference in __kernfs_remove

Nikita Travkin <nikita@trvn.ru>
    clk: qcom: clk-rcg2: Make sure to not write d=0 to the NMD register

Nikita Travkin <nikita@trvn.ru>
    clk: qcom: clk-rcg2: Fail Duty-Cycle configuration if MND divider is not enabled.

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    clk: qcom: camcc-sm8250: Fix topology around titan_top power domain

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    clk: qcom: camcc-sdm845: Fix topology around titan_top power domain

Robert Marko <robimarko@gmail.com>
    clk: qcom: ipq8074: set BRANCH_HALT_DELAY flag for UBI clocks

Robert Marko <robimarko@gmail.com>
    clk: qcom: ipq8074: fix NSS port frequency tables

Robert Marko <robimarko@gmail.com>
    clk: qcom: ipq8074: SW workaround for UBI32 PLL lock

Robert Marko <robimarko@gmail.com>
    clk: qcom: ipq8074: fix NSS core PLL-s

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix deadlock in rxe_do_local_ops()

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Add a responder state for atomic reply

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: host: xhci: use snprintf() in xhci_decode_trb()

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    clk: qcom: gcc-msm8939: Point MM peripherals to system_mm_noc clock

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    clk: qcom: gcc-msm8939: Add missing system_mm_noc_bfdcd_clk_src

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    clk: qcom: gcc-msm8939: Fix bimc_ddr_clk_src rcgr base address

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    clk: qcom: gcc-msm8939: Add missing SYSTEM_MM_NOC_BFDCD_CLK_SRC

Neal Liu <neal_liu@aspeedtech.com>
    usb: gadget: f_mass_storage: Make CD-ROM emulation works with Windows OS

Mike Leach <mike.leach@linaro.org>
    coresight: syscfg: Update load and unload operations

Mike Leach <mike.leach@linaro.org>
    coresight: configfs: Fix unload of configurations on module exit

Christian Marangi <ansuelsmth@gmail.com>
    clk: qcom: clk-krait: unlock spin after mux completion

Zhang Wensheng <zhangwensheng5@huawei.com>
    driver core: fix potential deadlock in __driver_attach

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    misc: rtsx: Fix an error handling path in rtsx_pci_probe()

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    clk: qcom: camcc-sm8250: Fix halt on boot by reducing driver's init level

Mark Brown <broonie@kernel.org>
    mtd: dataflash: Add SPI ID table

Geert Uytterhoeven <geert+renesas@glider.be>
    mtd: hyperbus: rpc-if: Fix RPM imbalance in probe error path

Ben Gardon <bgardon@google.com>
    KVM: x86: Fix errant brace in KVM capability handling

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    dmaengine: dw-edma: Fix eDMA Rd/Wr-channels and DMA-direction semantics

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix session removal on shutdown

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Add helper to remove a session from the kernel

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Allow iscsi_if_stop_conn() to be called from kernel

Duoming Zhou <duoming@zju.edu.cn>
    mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv

Duoming Zhou <duoming@zju.edu.cn>
    devcoredump: remove the useless gfp_t parameter in dev_coredumpv and dev_coredumpm

Sean Christopherson <seanjc@google.com>
    KVM: selftests: Use vm_create_with_vcpus() in max_guest_memory_test

Sean Christopherson <seanjc@google.com>
    KVM: selftests: Convert s390x/diag318_test_handler away from VCPU_ID

Sean Christopherson <seanjc@google.com>
    KVM: Don't set Accessed/Dirty bits for ZERO_PAGE

Miaohe Lin <linmiaohe@huawei.com>
    mm/memremap: fix memunmap_pages() race with get_dev_pagemap()

Miaohe Lin <linmiaohe@huawei.com>
    lib/test_hmm: avoid accessing uninitialized pages

Dongliang Mu <mudongliangabcd@gmail.com>
    RDMA/rxe: fix xa_alloc_cycle() error return value check again

Peng Fan <peng.fan@nxp.com>
    clk: imx: clk-fracn-gppll: correct rdiv

Liu Ying <victor.liu@nxp.com>
    clk: imx: clk-fracn-gppll: Return rate in rate table properly in ->recalc_rate()

Peng Fan <peng.fan@nxp.com>
    clk: imx: clk-fracn-gppll: fix mfd value

Peng Fan <peng.fan@nxp.com>
    clk: imx93: correct nic_media parent

Haibo Chen <haibo.chen@nxp.com>
    clk: imx93: use adc_root as the parent clock of adc1

Rex-BC Chen <rex-bc.chen@mediatek.com>
    clk: mediatek: reset: Fix written reset bit offset

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: temp: maxim_thermocouple: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: temp: max31865: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: temp: ltc2983: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: resolver: ad2s90: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: resolver: ad2s1200: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: proximity: as3935: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: potentiometer: mcp4131: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: potentiometer: mcp41010: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: potentiometer: max5481: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: potentiometer: ad5272: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: potentiometer: ad5110: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: imu: mpu6050: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: imu: inv_icm42600: Fix alignment for DMA safety in buffer code.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: imu: inv_icm42600: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: imu: fxos8700: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: gyro: fxas210002c: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: gyro: adxrs450: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: gyro: adis16130: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: gyro: adis16080: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: frequency: adrf6780: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: frequency: admv4420: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: frequency: admv1014: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: frequency: admv1013: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: frequency: adf4371: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: frequency: adf4350: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: frequency: ad9523: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ti-dac7612: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ti-dac7311: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ti-dac5571: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ti-dac082s085: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: mcp4922: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ltc2688: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad8801: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad7303: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad7293: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad5791: Fix alignment for DMA saftey

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad5770r: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad5766: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad5764: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad5761: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad5755: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad5686: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad5592r: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad5504: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad5449: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad5421: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad5360: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad5064: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: common: ssp: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: amplifiers: ad8366: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: addac: ad74413r: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ti-tlc4541: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ti-ads8688: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ti-ads8344: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ti-ads7950: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ti-ads131e08: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ti-ads124s08: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ti-adc161s626: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ti-adc128s052: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ti-adc12138: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ti-adc108s102: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ti-adc084s021: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ti-adc0832: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: mcp320x: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: max1241: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: max1118: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: max11100: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: max1027: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ltc2497: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ltc2496: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: hi8435: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7949: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7923: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7887: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7768-1: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7766: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7606: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7476: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7298: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7292: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7280a: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7266: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: sca3300: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: sca3000: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: bma220: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: adxl367: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: adxl355: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: adxl313: Fix alignment for DMA safety

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: core: Fix IIO_ALIGN and rename as it was not sufficiently large

Jagath Jog J <jagathjog1996@gmail.com>
    iio: accel: bma400: Add triggered buffer support

Jagath Jog J <jagathjog1996@gmail.com>
    iio: accel: bma400: conversion to device-managed function

Jagath Jog J <jagathjog1996@gmail.com>
    iio: accel: bma400: Reordering of header files

Gwendal Grignou <gwendal@chromium.org>
    iio: sx9324: Fix register field spelling

Stephen Boyd <swboyd@chromium.org>
    platform/chrome: cros_ec: Always expose last resume result

Jagath Jog J <jagathjog1996@gmail.com>
    iio: accel: bma400: Fix the scale min and max macro values

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Reduce N2N thrashing at app_start time

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Fix no logout on delete for N2N

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Fix session thrash

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Tear down session if keys have been removed

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Fix no login after app start

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Reduce disruption due to multiple app start

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Send LOGO for unexpected IKE message

Thomas Gleixner <tglx@linutronix.de>
    netfilter: xtables: Bring SPDX identifier back

Miquel Raynal <miquel.raynal@bootlin.com>
    dmaengine: dw: dmamux: Fix build without CONFIG_OF

Miquel Raynal <miquel.raynal@bootlin.com>
    dmaengine: dw: dmamux: Export the module device table

Tang Bin <tangbin@cmss.chinamobile.com>
    usb: xhci: tegra: Fix error check

Clément Léger <clement.leger@bootlin.com>
    usb: host: ohci-at91: add support to enter suspend using SMC

Dan Carpenter <dan.carpenter@oracle.com>
    usbip: vudc: Don't enable IRQs prematurely

Tang Bin <tangbin@cmss.chinamobile.com>
    usb: gadget: tegra-xudc: Fix error check in tegra_xudc_powerdomain_init()

Miaoqian Lin <linmq006@gmail.com>
    usb: ohci-nxp: Fix refcount leak in ohci_hcd_nxp_probe

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    usb: gadget: uvc: Fix comment blocks style

Frank Li <Frank.Li@nxp.com>
    usb: cdns3: fix random warning message when driver load

Miaoqian Lin <linmq006@gmail.com>
    usb: host: Fix refcount leak in ehci_hcd_ppc_of_probe

Marco Pagani <marpagan@redhat.com>
    fpga: altera-pr-ip: fix unsigned comparison with less than zero

Miaoqian Lin <linmq006@gmail.com>
    PCI: mediatek-gen3: Fix refcount leak in mtk_pcie_init_irq_domains()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mtd: st_spi_fsm: Disable clock only after device was unregistered

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mtd: st_spi_fsm: Warn about failure to unregister mtd device

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mtd: spear_smi: Drop if with an always false condition

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mtd: st_spi_fsm: Add a clk_disable_unprepare() in .probe()'s error path

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mtd: spear_smi: Don't skip cleanup after mtd_device_unregister() failed

Miaoqian Lin <linmq006@gmail.com>
    mtd: parsers: ofpart: Fix refcount leak in bcm4908_partitions_fw_offset

Miaoqian Lin <linmq006@gmail.com>
    mtd: partitions: Fix refcount leak in parse_redboot_of

Duoming Zhou <duoming@zju.edu.cn>
    mtd: sm_ftl: Fix deadlock caused by cancel_work_sync in sm_release

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    HID: cp2112: prevent a buffer overflow in cp2112_xfer()

Miaoqian Lin <linmq006@gmail.com>
    PCI: tegra194: Fix PM error handling in tegra_pcie_config_ep()

Miaoqian Lin <linmq006@gmail.com>
    PCI: microchip: Fix refcount leak in mc_pcie_init_irq_domains()

Chanho Park <chanho61.park@samsung.com>
    phy: samsung: exynosautov9-ufs: correct TSRV register configurations

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Drop RWX=0 SPTEs during ept_sync_page()

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Stuff next_rip on emulated INT3 injection if NRIPS is supported

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Unwind "speculative" RIP advancement if INTn injection "fails"

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Fix n2n login retry for secure device

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Fix n2n discovery issue with secure target

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Add retry for ELS passthrough

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Synchronize NPIV deletion with authentication application

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Fix potential stuck session in sa update

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Add bsg interface to read doorbell events

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Wait for app to ack on sess down

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: bsg refactor

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Reduce Initiator-Initiator thrashing

Vaibhav Jain <vaibhav@linux.ibm.com>
    of: check previous kernel's ima-kexec-buffer against memory bounds

Biju Das <biju.das.jz@bp.renesas.com>
    clk: renesas: rzg2l: Fix reset status function

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mtd: rawnand: meson: Fix a potential double free issue

Miaoqian Lin <linmq006@gmail.com>
    mtd: maps: Fix refcount leak in ap_flash_init

Miaoqian Lin <linmq006@gmail.com>
    mtd: maps: Fix refcount leak in of_flash_probe_versatile

Ralph Siemsen <ralph.siemsen@linaro.org>
    clk: renesas: r9a06g032: Fix UART clkgrp bitsel

Mario Limonciello <mario.limonciello@amd.com>
    HID: amd_sfh: Don't show client init failed as error when discovery fails

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: allowedips: don't corrupt stack when detecting overflow

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: ratelimiter: use hrtimer in selftest

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: xsk: Discard unaligned XSK frames on striding RQ

Maciej Żenczykowski <maze@google.com>
    net: usb: make USB_RTL8153_ECM non user configurable

Hangyu Hua <hbh25y@gmail.com>
    dccp: put dccp_qpolicy_full() and dccp_qpolicy_push() in the same lock

Jian Shen <shenjian15@huawei.com>
    net: ionic: fix error check for vlan flags in ionic_set_nic_features()

Jian Shen <shenjian15@huawei.com>
    net: ice: fix error NETIF_F_HW_VLAN_CTAG_FILTER check in ice_vsi_sync_fltr()

Eric Dumazet <edumazet@google.com>
    net: rose: fix netdev reference changes

Jakub Kicinski <kuba@kernel.org>
    netdevsim: Avoid allocation warnings triggered from user space

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    iavf: Fix 'tc qdisc show' listing too many queues

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    iavf: Fix max_rate limiting

William Dean <williamsukatube@gmail.com>
    wifi: rtw88: check the return value of alloc_workqueue()

Ido Schimmel <idosch@nvidia.com>
    netdevsim: fib: Fix reference count leak on route deletion failure

Mike Manning <mvrmanning@gmail.com>
    net: allow unbound socket for packets in VRF when tcp_l3mdev_accept set

Kai Ye <yekai13@huawei.com>
    crypto: hisilicon/sec - fix auth key size error

Pali Rohár <pali@kernel.org>
    crypto: inside-secure - Add missing MODULE_DEVICE_TABLE for of

Zhengchao Shao <shaozhengchao@huawei.com>
    crypto: hisilicon/hpre - don't use GFP_KERNEL to alloc mem during softirq

Eric Dumazet <edumazet@google.com>
    ax25: fix incorrect dev_tracker usage

Shay Drory <shayd@nvidia.com>
    net/mlx5: Fix driver use of uninitialized timeout

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: DR, Fix SMFS steering info dump format

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Adjust log_max_qp to be 18 at most

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5e: Modify slow path rules to go to slow fdb

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Fix calculations related to max MPWQE size

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: xsk: Account for XSK RQ UMRs when calculating ICOSQ size

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Fix the value of MLX5E_MAX_RQ_NUM_MTTS

Maor Dickman <maord@nvidia.com>
    net/mlx5e: TC, Fix post_act to not match on in_port metadata

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Remove WARN_ON when trying to offload an unsupported TLS cipher/version

Dan Carpenter <dan.carpenter@oracle.com>
    drm/amd/display: fix signedness bug in execute_synaptics_rc_command()

Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
    hantro: Remove incorrect HEVC SPS validation

Jernej Skrabec <jernej.skrabec@gmail.com>
    media: cedrus: hevc: Add check for invalid timestamp

Hangyu Hua <hbh25y@gmail.com>
    wifi: libertas: Fix possible refcount leak in if_usb_probe()

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    wifi: iwlwifi: mvm: fix double list_add at iwl_mvm_mac_wake_tx_queue

Ammar Faizi <ammarfaizi2@gnuweeb.org>
    wifi: wil6210: debugfs: fix uninitialized variable use in `wil_write_file_wmi()`

Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
    wifi: ath11k: Fix register write failure on QCN9074

Liang He <windhl@126.com>
    i2c: mux-gpmux: Add of_node_put() when breaking out of loop

Joanne Koong <joannelkoong@gmail.com>
    bpf: Fix bpf_xdp_pointer return pointer

Paul Chaignon <paul@isovalent.com>
    bpf: Set flow flag to allow any source IP in bpf_tunnel_key

Paul Chaignon <paul@isovalent.com>
    ip_tunnels: Add new flow flags field to ip_tunnel_key

Qu Wenruo <wqu@suse.com>
    btrfs: update stripe_sectors::uptodate in steal_rbio

Bjorn Andersson <bjorn.andersson@linaro.org>
    i2c: qcom-geni: Use the correct return value

Lars-Peter Clausen <lars@metafoo.de>
    i2c: cadence: Support PEC for SMBus block read

Ying Hsu <yinghsu@chromium.org>
    Bluetooth: Add default wakeup callback for HCI UART driver

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix not updating privacy_mode

Zhengping Jiang <jiangzp@google.com>
    Bluetooth: hci_sync: Fix resuming scan after suspend resume

Zhengping Jiang <jiangzp@google.com>
    Bluetooth: mgmt: Fix refresh cached connection info

Schspa Shi <schspa@gmail.com>
    Bluetooth: When HCI work queue is drained, only queue chained work

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    Bluetooth: hci_intel: Add check for platform_driver_register

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: pch_can: pch_can_error(): initialize errc before using it

Dan Carpenter <dan.carpenter@oracle.com>
    libbpf: Fix str_has_sfx()'s return value

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: error: specify the values of data[5..7] of CAN error frames

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: usb_8dev: do not report txerr and rxerr during bus-off

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: kvaser_usb_leaf: do not report txerr and rxerr during bus-off

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: kvaser_usb_hydra: do not report txerr and rxerr during bus-off

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: sun4i_can: do not report txerr and rxerr during bus-off

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: hi311x: do not report txerr and rxerr during bus-off

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: sja1000: do not report txerr and rxerr during bus-off

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: rcar_can: do not report txerr and rxerr during bus-off

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: pch_can: do not report txerr and rxerr during bus-off

Dan Carpenter <dan.carpenter@oracle.com>
    libbpf: fix an snprintf() overflow check

Dan Carpenter <dan.carpenter@oracle.com>
    selftests/bpf: fix a test for snprintf() overflow

Andrii Nakryiko <andrii@kernel.org>
    libbpf: make RINGBUF map size adjustments more eagerly

Andrii Nakryiko <andrii@kernel.org>
    bpf: fix potential 32-bit overflow when accessing ARRAY map element

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: restore original stable pstate on ctx fini

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: use the same HDP flush registers for all nbio 2.3.x

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: use the same HDP flush registers for all nbio 7.4.x

Rustam Subkhankulov <subkhankulov@ispras.ru>
    wifi: p54: add missing parentheses in p54_flush()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    wifi: p54: Fix an error handling path in p54spi_probe()

Dan Carpenter <dan.carpenter@oracle.com>
    wifi: wil6210: debugfs: fix info leak in wil_write_file_wmi()

Jernej Skrabec <jernej.skrabec@gmail.com>
    media: cedrus: h265: Fix logic for not low delay flag

Benjamin Gaignard <benjamin.gaignard@collabora.com>
    media: uapi: HEVC: Change pic_order_cnt definition in v4l2_hevc_dpb_entry

Jernej Skrabec <jernej.skrabec@gmail.com>
    media: cedrus: h265: Fix flag name

Jason A. Donenfeld <Jason@zx2c4.com>
    fs: check FMODE_LSEEK to control internal pipe splicing

Yang Yingliang <yangyingliang@huawei.com>
    media: ov7251: add missing disable functions on error in ov7251_set_power_on()

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l: async: Also match secondary fwnode endpoints

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: acquire wdev mutex for dump_survey

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix subprog names in stack traces.

Wolfram Sang <wsa+renesas@sang-engineering.com>
    selftests: timers: clocksource-switch: fix passing errors from child

Wolfram Sang <wsa+renesas@sang-engineering.com>
    selftests: timers: valid-adjtimex: build fix for newer toolchains

David Gow <davidgow@google.com>
    kunit: executor: Fix a memory leak on failure in kunit_filter_tests

Anquan Wu <leiqi96@hotmail.com>
    libbpf: Fix the name of a reused map

Yonglong Li <liyonglong@chinatelecom.cn>
    tcp: make retransmitted SKB fit into the send window

Song Liu <song@kernel.org>
    bpf, x86: fix freeing of not-finalized bpf_prog_pack

Tony Ambardar <tony.ambardar@gmail.com>
    bpf, x64: Add predicate for bpf2bpf with tailcalls support in JIT

Jian Zhang <zhangjian210@huawei.com>
    drm/exynos/exynos7_drm_decon: free resources when clk_set_parent() failed.

Liu Jian <liujian56@huawei.com>
    skmsg: Fix invalid last sg check in sk_msg_recvmsg()

Liang He <windhl@126.com>
    mediatek: mt76: eeprom: fix missing of_node_put() in mt76_find_power_limits_node()

Liang He <windhl@126.com>
    mediatek: mt76: mac80211: Fix missing of_node_put() in mt76_led_init()

Felix Fietkau <nbd@nbd.name>
    mt76: mt7615: fix throughput regression on DFS channels

Shayne Chen <shayne.chen@mediatek.com>
    mt76: mt7915: fix incorrect testmode ipg on band 1 caused by wmm_idx

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: connac: move connac2_mac_write_txwi in mt76_connac module

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: connac: move mac connac2 defs in mt76_connac2_mac.h

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7915: rely on mt76_dev in mt7915_mac_write_txwi signature

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: rely on mt76_dev in mt7921_mac_write_txwi signature

Deren Wu <deren.wu@mediatek.com>
    mt76: mt7921: enlarge maximum VHT MPDU length to 11454

Deren Wu <deren.wu@mediatek.com>
    mt76: mt7921: fix aggregation subframes setting to HE max

Deren Wu <deren.wu@mediatek.com>
    mt76: mt7921s: fix possible sdio deadlock in command fail

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: do not update pm states in case of error

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: do not update pm stats in case of error

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: move some future per-link data to bss_conf

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: do some rework towards MLO link APIs

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: reject WEP or pairwise keys with key ID > 3

Deren Wu <deren.wu@mediatek.com>
    mt76: mt7921: not support beacon offload disable command

YN Chen <yn.chen@mediatek.com>
    mt76: mt7921s: fix firmware download random fail

Dan Carpenter <dan.carpenter@oracle.com>
    mt76: mt7915: fix endian bug in mt7915_rf_regval_set()

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt76x02u: fix possible memory leak in __mt76x02u_mcu_send_msg

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7915: fix endianness in mt7915_rf_regval_get

Ming Qian <ming.qian@nxp.com>
    media: amphion: only insert the first sequence startcode for vc1l format

Ming Qian <ming.qian@nxp.com>
    media: amphion: sync buffer status with firmware during abort

Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
    media: hantro: Fix RK3399 H.264 format advertising

Benjamin Gaignard <benjamin.gaignard@collabora.com>
    media: hantro: Be more accurate on pixel formats step_width constraints

Ming Qian <ming.qian@nxp.com>
    media: amphion: defer setting last_buffer_dequeued until resolution changes are processed

Chen-Yu Tsai <wenst@chromium.org>
    media: mediatek: vcodec: Initialize decoder parameters for each instance

Chen-Yu Tsai <wenst@chromium.org>
    media: mediatek: vcodec: decoder: Drop max_{width,height} from mtk_vcodec_ctx

Chen-Yu Tsai <wenst@chromium.org>
    media: mediatek: vcodec: decoder: Skip alignment for default resolution

Chen-Yu Tsai <wenst@chromium.org>
    media: mediatek: vcodec: decoder: Fix resolution clamping in TRY_FMT

Chen-Yu Tsai <wenst@chromium.org>
    media: mediatek: vcodec: decoder: Fix 4K frame size enumeration

Hans de Goede <hdegoede@redhat.com>
    media: atomisp: revert "don't pass a pointer to a local variable"

Rob Clark <robdclark@chromium.org>
    drm/msm/dpu: Fix for non-visible planes

Ming Qian <ming.qian@nxp.com>
    media: amphion: release core lock before reset vpu core

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    media: platform: mtk-mdp: Fix mdp_ipi_comm structure alignment

Zhengchao Shao <shaozhengchao@huawei.com>
    crypto: hisilicon - Kunpeng916 crypto driver don't sleep when in softirq

Zhengchao Shao <shaozhengchao@huawei.com>
    crypto: hisilicon/sec - don't sleep when in softirq

Mateusz Jończyk <mat.jonczyk@o2.pl>
    drm/radeon: avoid bogus "vram limit (0) must be a power of 2" warning

Rob Clark <robdclark@chromium.org>
    drm/msm/mdp5: Fix global state lock backoff

Yixun Lan <dlan@gentoo.org>
    libbpf, riscv: Use a0 for RC register

Douglas Anderson <dianders@chromium.org>
    drm/msm: Avoid unclocked GMU register access in 6xx gpu_busy

Hsin-Yi Wang <hsinyi@chromium.org>
    drm/bridge: anx7625: Fix NULL pointer crash when using edp-panel

Qiao Ma <mqaio@linux.alibaba.com>
    net: hinic: avoid kernel hung in hinic_get_stats64()

Qiao Ma <mqaio@linux.alibaba.com>
    net: hinic: fix bug that ethtool get wrong stats

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    hinic: Use the bitmap API when applicable

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: build as module when tc-taprio is module

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: sched: provide shim definitions for taprio_offload_{get,free}

Rob Clark <robdclark@chromium.org>
    drm/msm: Fix fence rollover issue

Hangyu Hua <hbh25y@gmail.com>
    drm: bridge: sii8620: fix possible off-by-one

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/hdmi: fill the pwr_regs bulk regulators

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm/dpu: remove hard-coded linewidth limit for writeback

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm/dpu: fix maxlinewidth for writeback block

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm/dpu: move intf and wb assignment to dpu_encoder_setup_display()

Guillaume Ranquet <granquet@baylibre.com>
    drm/mediatek: dpi: Only enable dpi after the bridge is enabled

Bo-Chen Chen <rex-bc.chen@mediatek.com>
    drm/mediatek: dpi: Remove output format of YUV

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/rockchip: Fix an error handling path rockchip_dp_probe()

Brian Norris <briannorris@chromium.org>
    drm/rockchip: vop: Don't crash for invalid duplicate_state()

Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
    selftests: net: fib_rule_tests: fix support for running individual tests

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: drop oversized frames with tc-taprio instead of hanging the port

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: keep reference on entire tc-taprio config

Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
    net: dsa: felix: update base time of time-aware shaper when adjusting PTP time

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    selftests/xsk: Destroy BPF resources only when ctx refcount drops to 0

Qian Cai <quic_qiancai@quicinc.com>
    crypto: arm64/gcm - Select AEAD for GHASH_ARM64_CE

Matthew Wilcox (Oracle) <willy@infradead.org>
    mm: Account dirty folios properly during splits

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hdmi: Move pixel doubling from Pixelvalve to HDMI block

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hdmi: Correct HDMI timing registers for interlaced modes

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: Force modeset when bpc or format changes

Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>
    drm/vc4: hdmi: Fix timings for interlaced modes

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hdmi: Move HDMI reset to pm_resume

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hdmi: Switch to pm_runtime_status_suspended

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hdmi: Reset HDMI MISC_CONTROL register

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: Avoid full hdmi audio fifo writes

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: Clear unused infoframe packet RAM registers

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hdmi: Add all the vc5 HDMI registers into the debugfs dumps

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dsi: Add correct stop condition to vc4_dsi_encoder_disable iteration

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dsi: Fix dsi0 interrupt support

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dsi: Register dsi0 as the correct vc4 encoder type

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dsi: Correct pixel order for DSI0

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dsi: Correct DSI divider calculations

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dsi: Release workaround buffer and DMA

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: plane: Fix margin calculations for the right/bottom edges

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: plane: Remove subpixel positioning check

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: kms: Use maximum FIFO load for the HVS clock rate

Yunfei Dong <yunfei.dong@mediatek.com>
    media: mediatek: vcodec: Fix non subdev architecture open power fail

Miaoqian Lin <linmq006@gmail.com>
    media: tw686x: Fix memory leak in tw686x_video_init

Jian Zhang <zhangjian210@huawei.com>
    media: driver/nxp/imx-jpeg: fix a unexpected return value problem

Chen-Yu Tsai <wenst@chromium.org>
    media: mediatek: vcodec: Skip SOURCE_CHANGE & EOS events for stateless

Yunfei Dong <yunfei.dong@mediatek.com>
    media: mediatek: vcodec: Initialize decoder parameters after getting dec_capability

Arnd Bergmann <arnd@arndb.de>
    media: sta2x11: remove VIRT_TO_BUS dependency

Ming Qian <ming.qian@nxp.com>
    media: v4l2-mem2mem: prevent pollerr when last_buffer_dequeued is set

Niels Dossche <dossche.niels@gmail.com>
    media: hdpvr: fix error value returns in hdpvr_read

Miaoqian Lin <linmq006@gmail.com>
    drm/mcde: Fix refcount leak in mcde_dsi_bind

Ming Qian <ming.qian@nxp.com>
    media: amphion: output firmware error message

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Disable slot interrupt when frame done

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm: bridge: adv7511: Add check for mipi_dsi_driver_register

Tom Lendacky <thomas.lendacky@amd.com>
    crypto: ccp - During shutdown, check SEV data pointer before using

Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>
    selftests/bpf: Fix rare segfault in sock_fields prog test

YueHaibing <yuehaibing@huawei.com>
    drm/display: Fix build error without CONFIG_OF

Jian Shen <shenjian15@huawei.com>
    test_bpf: fix incorrect netdev features

Frederic Weisbecker <frederic@kernel.org>
    rcutorture: Fix ksoftirqd boosting timing and iteration

Paul E. McKenney <paulmck@kernel.org>
    torture: Adjust to again produce debugging information

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdkfd: correct sdma queue number of sdma 6.0.1

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Don't show warning on reading vbios values for SMU13 3.1

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix incorrrect SPDX-License-Identifiers

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: 8852a: rfk: fix div 0 exception

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    wifi: iwlegacy: 4965: fix potential off-by-one overflow in il4965_rs_fill_link_cmd()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: set STA deflink addresses

Pavel Skripkin <paskripkin@gmail.com>
    ath9k: fix use-after-free in ath9k_hif_usb_rx_cb

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: rcar-vin: Fix channel routing for Ebisu

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Implement drain using v4l2-mem2mem helpers

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Align upwards buffer size

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Leave a blank space before the configuration data

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Correct some definition according specification

Benjamin Gaignard <benjamin.gaignard@collabora.com>
    media: Hantro: Correct G2 init qp field

Ming Qian <ming.qian@nxp.com>
    media: amphion: return error if format is unsupported by vpu

Zheyu Ma <zheyuma97@gmail.com>
    media: tw686x: Register the irq at the end of probe

Yang Yingliang <yangyingliang@huawei.com>
    media: camss: csid: fix wrong size passed to devm_kmalloc_array()

Eugen Hristev <eugen.hristev@microchip.com>
    media: atmel: atmel-sama7g5-isc: fix warning in configs without OF

Kuniyuki Iwashima <kuniyu@amazon.com>
    raw: Fix mixed declarations error in raw_icmp_error().

Eric Dumazet <edumazet@google.com>
    raw: convert raw sockets to RCU

Eric Dumazet <edumazet@google.com>
    raw: use more conventional iterators

Eric Dumazet <edumazet@google.com>
    ping: convert to RCU lookups, get rid of rwlock

Oleksij Rempel <linux@rempel-privat.de>
    net: ag71xx: fix discards 'const' qualifier warning

Alexey Khoroshilov <khoroshilov@ispras.ru>
    crypto: sun8i-ss - fix infinite loop in sun8i_ss_setup_ivs()

Eric Dumazet <edumazet@google.com>
    tcp: fix possible freeze in tx path under memory pressure

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Don't force lld on non-x86 architectures

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix internal USDT address translation logic for shared libraries

Xu Wang <vulab@iscas.ac.cn>
    i2c: Fix a potential use after free

Zheng Bin <zhengbin13@huawei.com>
    drm/bridge: it6505: Add missing CRYPTO_HASH dependency

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: anx7625: Zero error variable when panel bridge not present

Marc Kleine-Budde <mkl@pengutronix.de>
    can: netlink: allow configuring of fixed data bit rates without need for do_set_data_bittiming callback

Tales Lelo da Aparecida <tales.aparecida@gmail.com>
    drm/vkms: check plane_composer->map[0] before using it

Marc Kleine-Budde <mkl@pengutronix.de>
    can: netlink: allow configuring of fixed bit rates without need for do_set_bittiming callback

Eric Dumazet <edumazet@google.com>
    net: fix sk_wmem_schedule() and sk_rmem_schedule() errors

Peng Wu <wupeng58@huawei.com>
    crypto: sun8i-ss - fix a NULL vs IS_ERR() check in sun8i_ss_hashkey

Dan Carpenter <dan.carpenter@oracle.com>
    crypto: sun8i-ss - Fix error codes for dma_mapping_error()

Dan Carpenter <dan.carpenter@oracle.com>
    crypto: sun8i-ss - fix error codes in allocate_flows()

Antonio Borneo <antonio.borneo@foss.st.com>
    drm: adv7511: override i2c address of cec before accessing it

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix uprobe symbol file offset calculation logic

Miaoqian Lin <linmq006@gmail.com>
    drm/virtio: Fix NULL vs IS_ERR checking in virtio_gpu_object_shmem_init

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    virtio-gpu: fix a missing check to avoid NULL dereference

Fabio Estevam <festevam@gmail.com>
    i2c: mxs: Silence a clang warning

Tali Perry <tali.perry1@gmail.com>
    i2c: npcm: Correct slave role behavior

Tali Perry <tali.perry1@gmail.com>
    i2c: npcm: Remove own slave addresses 2:10

Leung, Martin <Martin.Leung@amd.com>
    drm/amdgpu/display: Prepare for new interfaces

ZhenGuo Yin <zhenguo.yin@amd.com>
    drm/amdgpu: fix scratch register access method in SRIOV

Bjorn Andersson <bjorn.andersson@linaro.org>
    drm/bridge: lt9611uxc: Cancel only driver's work

Miaoqian Lin <linmq006@gmail.com>
    drm/meson: encoder_hdmi: Fix refcount leak in meson_encoder_hdmi_init

Miaoqian Lin <linmq006@gmail.com>
    drm/meson: encoder_cvbs: Fix refcount leak in meson_encoder_cvbs_init

Xinlei Lee <xinlei.lee@mediatek.com>
    drm/mediatek: Add pull-down MIPI operation in mtk_dsi_poweroff function

Jitao Shi <jitao.shi@mediatek.com>
    drm/mediatek: Separate poweron/poweroff from enable/disable and define new funcs

Xinlei Lee <xinlei.lee@mediatek.com>
    drm/mediatek: Modify dsi funcs to atomic operations

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    drm/radeon: fix potential buffer overflow in ni_set_mc_special_registers()

Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
    ath11k: Avoid REO CMD failed prints during firmware recovery

Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
    ath11k: Fix incorrect debug_mask mappings

Christian Marangi <ansuelsmth@gmail.com>
    ath11k: fix missing skb drop on htc_tx_completion error

Yuze Chi <chiyuze@google.com>
    libbpf: Fix is_pow_of_2

Martin KaFai Lau <kafai@fb.com>
    selftests/bpf: Fix tc_redirect_dtime

Lorenzo Bianconi <lorenzo@kernel.org>
    sample: bpf: xdp_router_ipv4: Allow the kernel to send arp requests

Yuntao Wang <ytcoode@gmail.com>
    selftests/bpf: Fix test_run logic in fexit_stress.c

Javier Martinez Canillas <javierm@redhat.com>
    drm/ssd130x: Only define a SPI device ID table when built as a module

Yunhao Tian <t123yh.xyz@gmail.com>
    drm/mipi-dbi: align max_chunk to 2 in spi_transfer

Johan Hovold <johan+linaro@kernel.org>
    ath11k: fix IRQ affinity warning on shutdown

Johan Hovold <johan+linaro@kernel.org>
    ath11k: fix netdev open race

Ajay Singh <ajay.kathat@microchip.com>
    wifi: wilc1000: use correct sequence of RESET for chip Power-UP/Down

Dan Carpenter <dan.carpenter@oracle.com>
    wifi: rtlwifi: fix error codes in rtl_debugfs_set_write_h2c()

Fabio Estevam <festevam@gmail.com>
    drm: bridge: adv7511: Move CEC definitions to adv7511_cec.c

Gao Chao <gaochao49@huawei.com>
    drm/panel: Fix build error when CONFIG_DRM_PANEL_SAMSUNG_ATNA33XC20=y && CONFIG_DRM_DISPLAY_HELPER=m

Javier Martinez Canillas <javierm@redhat.com>
    drm/st7735r: Fix module autoloading for Okaya RH128128T

John Stultz <jstultz@google.com>
    drm/bridge: lt9611: Use both bits for HDMI sensing

Jani Nikula <jani.nikula@intel.com>
    drm/edid: reset display info in drm_add_edid_modes() for NULL edid

Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
    ath11k: Init hw_params before setting up AHB resources

Baochen Qiang <quic_bqiang@quicinc.com>
    ath11k: Fix warning on variable 'sar' dereference before check

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ath10k: do not enforce interrupt trigger type

Marek Vasut <marex@denx.de>
    drm/bridge: tc358767: Make sure Refclk clock are enabled

Marek Vasut <marex@denx.de>
    drm/bridge: tc358767: Handle dsi_lanes == 0 as invalid

Douglas Anderson <dianders@chromium.org>
    drm/dp: Export symbol / kerneldoc fixes for DP AUX bus

Miaoqian Lin <linmq006@gmail.com>
    drm/meson: Fix refcount leak in meson_encoder_hdmi_init

Thomas Zimmermann <tzimmermann@suse.de>
    drm/mgag200: Acquire I/O lock while reading EDID

Xin Ji <xji@analogixsemi.com>
    drm/bridge: anx7625: Use DPI bus type

Geert Uytterhoeven <geert+renesas@glider.be>
    drm: bridge: DRM_FSL_LDB should depend on ARCH_MXC

Dan Carpenter <dan.carpenter@oracle.com>
    drm/rockchip: vop2: unlock on error path in vop2_crtc_atomic_enable()

Jani Nikula <jani.nikula@intel.com>
    drm/i915: remove unused GEM_DEBUG_DECL() and GEM_DEBUG_BUG_ON()

Marek Vasut <marex@denx.de>
    dt-bindings: display: bridge: ldb: Fill in reg property

Hongnan Li <hongnan.li@linux.alibaba.com>
    erofs: update ctx->pos for every emitted dirent

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: lpc18xx: Fix period handling

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sifive: Shut down hardware only after pwmchip_remove() completed

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sifive: Ensure the clk is enabled exactly once per running PWM

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sifive: Simplify offset calculation for PWMCMP registers

Mike Snitzer <snitzer@kernel.org>
    dm: return early from dm_pr_call() if DM device is suspended

Colin Ian King <colin.king@intel.com>
    tools/power turbostat: Fix file pointer leak

Markus Mayer <mmayer@broadcom.com>
    thermal/tools/tmon: Include pthread and time headers in tmon.h

YiFei Zhu <zhuyifei@google.com>
    selftests/seccomp: Fix compile warning when CC=clang

Michal Koutný <mkoutny@suse.com>
    io_uring: Don't require reinitable percpu_ref

Jens Axboe <axboe@kernel.dk>
    io_uring: define a 'prep' and 'issue' handler for each opcode

Jens Axboe <axboe@kernel.dk>
    io_uring: move to separate directory

Peter Zijlstra <peterz@infradead.org>
    x86/extable: Fix ex_handler_msr() print condition

Mel Gorman <mgorman@techsingularity.net>
    sched/numa: Initialise numa_migrate_retry

Christian Göttsche <cgzones@googlemail.com>
    sched: only perform capability check on privileged operation

Nicolas Saenz Julienne <nsaenzju@redhat.com>
    nohz/full, sched/rt: Fix missed tick-reenabling bug in dequeue_task_rt()

Anshuman Khandual <anshuman.khandual@arm.com>
    drivers/perf: arm_spe: Fix consistency of SYS_PMSCR_EL1.CX

Liang He <windhl@126.com>
    perf: RISC-V: Add of_node_put() when breaking out of for_each_of_cpu_node()

Xu Qiang <xuqiang36@huawei.com>
    irqdomain: Report irq number for NOMAP domains

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    ARM: dts: qcom: msm8974: Disable remoteprocs by default

Sumit Garg <sumit.garg@linaro.org>
    arm64: dts: qcom: qcs404: Fix incorrect USB2 PHYs assignment

Marijn Suijten <marijn.suijten@somainline.org>
    arm64: dts: qcom: msm8998: Make regulator voltages multiple of step-size

Parikshit Pareek <quic_ppareek@quicinc.com>
    soc: qcom: socinfo: Fix the id of SA8540P SoC

Konrad Dybcio <konrad.dybcio@somainline.org>
    soc: qcom: Make QCOM_RPMPD depend on PM

Liang He <windhl@126.com>
    regulator: of: Fix refcount leak bug in of_get_regulation_constraints()

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: count number of blocks discarded, not number of discard bios

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: count number of blocks written, not number of write bios

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: count number of blocks read, not number of read bios

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: return void from functions

Hsin-Yi Wang <hsinyi@chromium.org>
    PM: domains: Ensure genpd_debugfs_dir exists before remove

Bart Van Assche <bvanassche@acm.org>
    blktrace: Trace remapped requests correctly

Linus Walleij <linus.walleij@linaro.org>
    hwmon: (drivetemp) Add module alias

Armin Wolf <W_Armin@gmx.de>
    hwmon: (sch56xx-common) Add DMI override table

Yang Yingliang <yangyingliang@huawei.com>
    spi: tegra20-slink: fix UAF in tegra_slink_remove()

Yang Yingliang <yangyingliang@huawei.com>
    spi: Fix simplification of devm_spi_register_controller

Nandhini Srikandan <nandhini.srikandan@intel.com>
    spi: dw: Fix IP-core versions macro

Ming Lei <ming.lei@redhat.com>
    blk-mq: don't create hctx debugfs dir until q->debugfs_dir is created

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: Return deferred probe error when controller isn't yet available

Gao Xiang <xiang@kernel.org>
    erofs: avoid consecutive detection for Highmem memory

Yuwen Chen <chenyuwen1@meizu.com>
    erofs: wake up all waiters after z_erofs_lzma_head ready

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sc7280: fix PCIe clock reference

Tamás Szűcs <tszucs@protonmail.ch>
    arm64: tegra: Fix SDMMC1 CD on P2888

Mikko Perttunen <mperttunen@nvidia.com>
    arm64: tegra: Mark BPMP channels as no-memory-wc

Nick Hainke <vincent@systemli.org>
    arm64: dts: mt7622: fix BPI-R64 WPS button

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sm8250: add missing PCIe PHY clock-cells

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sc7280: drop PCIe PHY clock index

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8996: correct #clock-cells for QMP PHY nodes

Marijn Suijten <marijn.suijten@somainline.org>
    arm64: dts: qcom: sm6125: Append -state suffix to pinctrl nodes

Marijn Suijten <marijn.suijten@somainline.org>
    arm64: dts: qcom: sm6125: Move sdc2 pinctrl from seine-pdx201 to sm6125

Yang Yingliang <yangyingliang@huawei.com>
    m68k: virt: Fix missing platform_device_unregister() on error in virt_platform_init()

Eric Auger <eric.auger@redhat.com>
    ACPI: VIOT: Fix ACS setup

Chanho Park <chanho61.park@samsung.com>
    arm64: dts: exynosautov9: correct spi11 pin names

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix PEBS data source encoding for ADL

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix PEBS memory access info encoding for ADL

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: msm8994: add required ranges to OCMEM

Sireesh Kodali <sireeshkodali1@gmail.com>
    arm64: dts: qcom: msm8916: Fix typo in pronto remoteproc node

GONG, Ruiqi <gongruiqi1@huawei.com>
    stack: Declare {randomize_,}kstack_offset to fix Sparse warnings

Kees Cook <keescook@chromium.org>
    lib: overflow: Do not define 64-bit tests on 32-bit

Yang Yingliang <yangyingliang@huawei.com>
    bus: hisi_lpc: fix missing platform_device_put() in hisi_lpc_acpi_probe()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: qcom: pm8841: add required thermal-sensor-cells

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: qcom: msm8974: add required ranges to OCMEM

Miaoqian Lin <linmq006@gmail.com>
    soc: qcom: aoss: Fix refcount leak in qmp_cooling_devices_register

Miaoqian Lin <linmq006@gmail.com>
    soc: qcom: ocmem: Fix refcount leak in of_get_ocmem

Luca Weiss <luca@z3ntu.xyz>
    ARM: dts: qcom-msm8974: fix irq type on blsp2_uart1

Christian Marangi <ansuelsmth@gmail.com>
    ARM: dts: qcom: replace gcc PXO with pxo_board fixed clock

Dan Williams <dan.j.williams@intel.com>
    ACPI: APEI: Fix _EINJ vs EFI_MEMORY_SP

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    regulator: qcom_smd: Fix pm8916_pldo range

Chris Paterson <chris.paterson2@renesas.com>
    arm64: dts: renesas: r9a07g054l2-smarc: Correct SoC name in comment

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r8a779m8: Drop operating points above 1.5 GHz

Miaoqian Lin <linmq006@gmail.com>
    cpufreq: zynq: Fix refcount leak in zynq_get_revision

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sdm636-sony-xperia-ganges-mermaid: correct sdc2 pinconf

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sdm630: fix gpu's interconnect path

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sdm630: fix the qusb2phy ref clock

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sdm630: disable GPU by default

Miaoqian Lin <linmq006@gmail.com>
    ARM: OMAP2+: Fix refcount leak in omap3xxx_prm_late_init

Miaoqian Lin <linmq006@gmail.com>
    ARM: OMAP2+: Fix refcount leak in omapdss_init_of

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: qcom: mdm9615: add missing PMIC GPIO reg

Marijn Suijten <marijn.suijten@somainline.org>
    arm64: dts: qcom: sdm845-akatsuki: Round down l22a regulator voltage

Keith Busch <kbusch@kernel.org>
    block: fix infinite loop for invalid zone append

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    spi: s3c64xx: constify fsd_spi_port_config

Michael Walle <michael@walle.cc>
    soc: fsl: guts: machine variable might be unset

Stephen Boyd <swboyd@chromium.org>
    arm64: dts: qcom: sc7180: Remove ipa_fw_mem node on trogdor

Peter Zijlstra <peterz@infradead.org>
    locking/lockdep: Fix lockdep_init_map_*() confusion

Alexandru Elisei <alexandru.elisei@arm.com>
    arm64: cpufeature: Allow different PMU versions in ID_DFR0_EL1

Mark Rutland <mark.rutland@arm.com>
    arm64: select TRACE_IRQFLAGS_NMI_SUPPORT

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    arm64: dts: mt8192: Fix idle-states entry-method

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    arm64: dts: mt8192: Fix idle-states nodes naming scheme

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: ast2600-evb-a1: fix board compatible

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: ast2600-evb: fix board compatible

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: ast2500-evb: fix board compatible

Johan Hovold <johan@kernel.org>
    x86/pmem: Fix platform-device leak in error path

Max Krummenacher <max.krummenacher@toradex.com>
    Revert "ARM: dts: imx6qdl-apalis: Avoid underscore in node name"

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: Fix thermal-sensors on single-zone sensors

Liang He <windhl@126.com>
    soc: amlogic: Fix refcount leak in meson-secure-pwrc.c

Geert Uytterhoeven <geert+renesas@glider.be>
    soc: renesas: r8a779a0-sysc: Fix A2DP1 and A2CV[2357] PDR values

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ARM: dts: imx7-colibri-eval-v3: correct can controller comment

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ARM: dts: imx7-colibri: move aliases, chosen, extcon and gpio-keys

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ARM: dts: imx7-colibri: improve wake-up with gpio key

Philippe Schenker <philippe.schenker@toradex.com>
    ARM: dts: imx7-colibri: add usb dual-role switching using extcon

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ARM: dts: imx7-colibri: overhaul display/touch functionality

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ARM: dts: imx7d-colibri-emmc: add cpu1 supply

Guilherme G. Piccoli <gpiccoli@igalia.com>
    ACPI: processor/idle: Annotate more functions to live in cpuidle section

Miaoqian Lin <linmq006@gmail.com>
    ARM: bcm: Fix refcount leak in bcm_kona_smc_init

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    spi: spi-altera-dfl: Fix an error handling path

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: beacon: Fix regulator node names

Miaoqian Lin <linmq006@gmail.com>
    meson-mx-socinfo: Fix refcount leak in meson_mx_socinfo_init

Juri Lelli <juri.lelli@redhat.com>
    wait: Fix __wait_event_hrtimeout for RT/DL tasks

Kees Cook <keescook@chromium.org>
    kasan: test: Silence GCC 12 warnings

Dylan Yudaken <dylany@fb.com>
    io_uring: fix io_uring_cqe_overflow trace format

Xiu Jianfeng <xiujianfeng@huawei.com>
    selinux: Add boundary check in put_entry()

Xiu Jianfeng <xiujianfeng@huawei.com>
    selinux: fix memleak in security_read_state_kernel()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    PM: hibernate: defer device probing when resuming from hibernation

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    hwmon: (sht15) Fix wrong assumptions in device remove callback

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Use native backlight on Dell Inspiron N4010

Lukasz Luba <lukasz.luba@arm.com>
    PM: EM: convert power field to micro-Watts precision and align drivers

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm) Add Dell XPS 13 7390 to fan control whitelist

Lv Ruyi <lv.ruyi@zte.com.cn>
    firmware: tegra: Fix error check return value of debugfs_create_file()

Liang He <windhl@126.com>
    ARM: shmobile: rcar-gen2: Increase refcount for new reference

Samuel Holland <samuel@sholland.org>
    arm64: dts: allwinner: a64: orangepi-win: Fix LED node name

Robert Marko <robimarko@gmail.com>
    arm64: dts: qcom: ipq8074: fix NAND node name

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: add missing AOSS QMP compatible fallback

Gwendal Grignou <gwendal@chromium.org>
    arm64: dts: qcom: sc7280: Rename sar sensor labels

Manivannan Sadhasivam <mani@kernel.org>
    ARM: dts: qcom: sdx55: Fix the IRQ trigger type for UART

huhai <huhai@kylinos.cn>
    ACPI: LPSS: Fix missing check in register_device_clock()

Manyi Li <limanyi@uniontech.com>
    ACPI: PM: save NVS memory for Lenovo G40-45

Hans de Goede <hdegoede@redhat.com>
    ACPI: EC: Drop the EC_FLAGS_IGNORE_DSDT_GPE quirk

Hans de Goede <hdegoede@redhat.com>
    ACPI: EC: Remove duplicate ThinkPad X1 Carbon 6th entry from DMI quirks

Liang He <windhl@126.com>
    ARM: OMAP2+: pdata-quirks: Fix refcount leak bug

Liang He <windhl@126.com>
    ARM: OMAP2+: display: Fix refcount leak bug

Guo Mengqi <guomengqi3@huawei.com>
    spi: synquacer: Add missing clk_disable_unprepare()

David Heidelberg <david@ixit.cz>
    arm64: dts: qcom: timer should use only 32-bit size

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: ux500: Fix Gavini accelerometer mounting matrix

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: ux500: Fix Codina accelerometer mounting matrix

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: ux500: Fix Janice accelerometer mounting matrix

Christian Lamparter <chunkeey@gmail.com>
    ARM: dts: BCM5301X: Add DT for Meraki MR26

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6ul: fix qspi node compatible

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6ul: fix lcdif node compatible

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6ul: fix csi node compatible

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6ul: fix keypad compatible

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6ul: change operating-points to uint32-matrix

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6ul: add missing properties for sram

William Dean <williamsukatube@163.com>
    irqchip/mips-gic: Check the return value of ioremap() in gic_of_init()

John Keeping <john@metanate.com>
    sched/core: Always flush pending blk_plug

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: fix case with reduced capacity CPU

Samuel Holland <samuel@sholland.org>
    genirq: GENERIC_IRQ_IPI depends on SMP

Samuel Holland <samuel@sholland.org>
    irqchip/mips-gic: Only register IPI domain when SMP is enabled

Antonio Borneo <antonio.borneo@foss.st.com>
    genirq: Don't return error on missing optional irq_request_resources()

Chen Yu <yu.c.chen@intel.com>
    sched/fair: Introduce SIS_UTIL to search idle CPU based on sum of util_avg

Jan Kara <jack@suse.cz>
    ext2: Add more validity checks for inode counts

James Morse <james.morse@arm.com>
    arm64: errata: Remove AES hwcap for COMPAT tasks

Catalin Marinas <catalin.marinas@arm.com>
    arm64: kasan: Revert "arm64: mte: reset the page tag in page->flags"

haibinzhang (张海斌) <haibinzhang@tencent.com>
    arm64: fix oops in concurrently setting insn_emulation sysctls

Francis Laniel <flaniel@linux.microsoft.com>
    arm64: Do not forget syscall when starting a new thread.

Andrey Konovalov <andreyknvl@gmail.com>
    arm64: stacktrace: use non-atomic __set_bit

Andrey Konovalov <andreyknvl@gmail.com>
    arm64: kasan: do not instrument stacktrace.c

Mark Rutland <mark.rutland@arm.com>
    arch: make TRACE_IRQFLAGS_NMI_SUPPORT generic

Wyes Karny <wyes.karny@amd.com>
    x86: Handle idle=nomwait cmdline properly for x86_idle

Benjamin Segall <bsegall@google.com>
    epoll: autoremove wakers even more aggressively

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix null deref due to zeroed list head

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: disallow jump to implicit chain from set element

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: upfront validation of data via nft_data_init()

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    netfilter: nf_tables: do not allow RULE_ID to refer to another chain

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    netfilter: nf_tables: do not allow CHAIN_ID to refer to another table

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    netfilter: nf_tables: do not allow SET_ID to refer to another table

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: dwc3: gadget: fix high speed multiplier setting

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: dwc3: gadget: refactor dwc3_repare_one_trb

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    arm64: dts: uniphier: Fix USB interrupts for PXs3 SoC

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    ARM: dts: uniphier: Fix USB interrupts for PXs2 SoC

Jose Alonso <joalonsof@gmail.com>
    Revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP"

Weitao Wang <WeitaoWang-oc@zhaoxin.com>
    USB: HCD: Fix URB giveback issue in tasklet function

Linyu Yuan <quic_linyyuan@quicinc.com>
    usb: typec: ucsi: Acknowledge the GET_ERROR_STATUS command completion

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: Clear the connection field properly

Huacai Chen <chenhuacai@kernel.org>
    MIPS: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/powernv: Avoid crashing if rng is NULL

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/ptdump: Fix display of RW pages on FSL_BOOK3E

Pali Rohár <pali@kernel.org>
    powerpc/fsl-pci: Fix Class Code of PCIe Root Port

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/64e: Fix early TLB miss with KUAP

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc: Restore CONFIG_DEBUG_INFO in defconfigs

Alexander Lobakin <alexandr.lobakin@intel.com>
    ia64, processor: fix -Wincompatible-pointer-types in ia64_get_irr()

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    media: [PATCH] pci: atomisp_cmd: fix three missing checks on list iterator

Randy Dunlap <rdunlap@infradead.org>
    media: isl7998x: select V4L2_FWNODE to fix build error

Jan Kara <jack@suse.cz>
    mbcache: add functions to delete entry if unused

Jan Kara <jack@suse.cz>
    mbcache: don't reclaim used entries

Mikulas Patocka <mpatocka@redhat.com>
    md-raid10: fix KASAN warning

Mikulas Patocka <mpatocka@redhat.com>
    md-raid: destroy the bitmap after destroying the thread

Narendra Hadke <nhadke@marvell.com>
    serial: mvebu-uart: uart2 error bits clearing

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix deadlock between atomic O_TRUNC and page invalidation

Miklos Szeredi <mszeredi@redhat.com>
    fuse: write inode in fuse_release()

Miklos Szeredi <mszeredi@redhat.com>
    fuse: ioctl: translate ENOSYS

Miklos Szeredi <mszeredi@redhat.com>
    fuse: limit nsec

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix heap-based overflow in set_ntacl_dacl()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free bug in smb2_tree_disconect

Hyunchul Lee <hyc.lee@gmail.com>
    ksmbd: prevent out of bound read for SMB2_WRITE

Hyunchul Lee <hyc.lee@gmail.com>
    ksmbd: prevent out of bound read for SMB2_TREE_CONNNECT

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix memory leak in smb2_handle_negotiate

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soundwire: qcom: Check device status before reading devid

Bikash Hazarika <bhazarika@marvell.com>
    scsi: qla2xxx: Zero undefined mailbox IN registers

Bikash Hazarika <bhazarika@marvell.com>
    scsi: qla2xxx: Fix incorrect display of max frame size

Tony Battersby <tonyb@cybernetics.com>
    scsi: sg: Allow waiting for commands to complete on removed device

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Remove extra atomic_inc on cmd_pending in queuecommand after VMID

Zheyu Ma <zheyuma97@gmail.com>
    iio: light: isl29028: Fix the warning in isl29028_remove()

Fawzi Khaber <fawzi.khaber@tdk.com>
    iio: fix iio_format_avail_range() printing for none IIO_VAL_INT

Jason A. Donenfeld <Jason@zx2c4.com>
    um: seed rng using host OS rng

Benjamin Beichler <benjamin.beichler@uni-rostock.de>
    um: Remove straying parenthesis

Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
    mtd: rawnand: arasan: Update NAND bus clock instead of system clock

Olga Kitaina <okitain@gmail.com>
    mtd: rawnand: arasan: Fix clock rate in NV-DDR

Qu Wenruo <wqu@suse.com>
    btrfs: reject log replay if there is unsupported RO compat flag

Tadeusz Struk <tadeusz.struk@linaro.org>
    bpf: Fix KASAN use-after-free Read in compute_effective_progs

Leo Li <sunpeng.li@amd.com>
    drm/amdgpu: Check BO's requested pinning domains against its preferred_domains

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/tegra: Fix vmapping of prime buffers

Lyude Paul <lyude@redhat.com>
    drm/nouveau/kms: Fix failure path for creating DP connectors

Lyude Paul <lyude@redhat.com>
    drm/nouveau/acpi: Don't print error when we get -EINPROGRESS from pm_runtime

Lyude Paul <lyude@redhat.com>
    drm/nouveau: Don't pm_runtime_put_sync(), only pm_runtime_put_autosuspend()

Timur Tabi <ttabi@nvidia.com>
    drm/nouveau: fix another off-by-one in nvbios_addr

Imre Deak <imre.deak@intel.com>
    drm/dp/mst: Read the extended DPCD capabilities during system resume

Thomas Zimmermann <tzimmermann@suse.de>
    drm/hyperv-drm: Include framebuffer and EDID headers

Thomas Zimmermann <tzimmermann@suse.de>
    drm/fb-helper: Fix out-of-bounds access

Paul Cercueil <paul@crapouillou.net>
    drm/ingenic: Use the highest possible DMA burst size

Phil Elwell <phil@raspberrypi.org>
    drm/vc4: hdmi: Disable audio if dmas property is present but empty

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/shmem-helper: Add missing vunmap on error

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/gem: Properly annotate WW context on drm_gem_lock_reservations() error

Mathew McBride <matt@traverse.com.au>
    rtc: rx8025: fix 12/24 hour mode detection on RX-8035

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: selftests: set CONFIG_NONPORTABLE on riscv32

Atish Patra <atishp@rivosinc.com>
    RISC-V: Update user page mapping only once during start

Atish Patra <atishp@rivosinc.com>
    RISC-V: Fix SBI PMU calls for RV32

Atish Patra <atishp@rivosinc.com>
    RISC-V: Fix counter restart during overflow for RV32

Xianting Tian <xianting.tian@linux.alibaba.com>
    RISC-V: Add modules to virtual kernel memory layout dump

Xianting Tian <xianting.tian@linux.alibaba.com>
    RISC-V: Fixup schedule out issue in machine_crash_shutdown()

Xianting Tian <xianting.tian@linux.alibaba.com>
    RISC-V: Fixup get incorrect user mode PC for kernel mode regs

Xianting Tian <xianting.tian@linux.alibaba.com>
    RISC-V: kexec: Fixup use of smp_processor_id() in preemptible context

Ben Dooks <ben.dooks@sifive.com>
    RISC-V: Declare cpu_ops_spinwait in <asm/cpu_ops.h>

Ben Dooks <ben.dooks@sifive.com>
    RISC-V: cpu_ops_spinwait.c should include head.h

Mark Kettenis <kettenis@openbsd.org>
    riscv: dts: starfive: correct number of external interrupts

Conor Dooley <conor.dooley@microchip.com>
    dt-bindings: riscv: fix SiFive l2-cache's cache-sets

Chen Lifu <chenlifu@huawei.com>
    riscv: lib: uaccess: fix CSR_STATUS SR_SUM bit

Yipeng Zou <zouyipeng@huawei.com>
    riscv:uprobe fix SR_SPIE set/clear handling

Helge Deller <deller@gmx.de>
    parisc: io_pgetevents_time64() needs compat syscall in 32-bit compat mode

William Dean <williamsukatube@gmail.com>
    parisc: Check the return value of ioremap() in lba_driver_probe()

Helge Deller <deller@gmx.de>
    parisc: Drop pa_swapper_pg_lock spinlock

Helge Deller <deller@gmx.de>
    parisc: Fix device names in /proc/iomem

Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
    ovl: drop WARN_ON() dentry is NULL in ovl_encode_fh()

John Allen <john.allen@amd.com>
    crypto: ccp - Use kzalloc for sev ioctl interfaces to prevent kernel memory leak

Al Viro <viro@zeniv.linux.org.uk>
    fix short copy handling in copy_mc_pipe_to_iter()

Lukas Wunner <lukas@wunner.de>
    usbnet: smsc95xx: Fix deadlock on runtime resume

Lukas Wunner <lukas@wunner.de>
    usbnet: Fix linkwatch use-after-free on disconnect

Helge Deller <deller@gmx.de>
    fbcon: Fix accelerated fbdev scrolling while logo is still shown

Helge Deller <deller@gmx.de>
    fbcon: Fix boundary checks for fbcon=vc:n1-n2 parameters

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: sysfs: Fix cooling_device_stats_setup() error code path

Yang Xu <xuyang2018.jy@fujitsu.com>
    fs: Add missing umask strip in vfs_tmpfile

David Howells <dhowells@redhat.com>
    vfs: Check the truncate maximum size in inode_newsize_ok()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tty: vt: initialize unicode screen buffer

Cameron Williams <cang1@live.co.uk>
    tty: 8250: Add support for Brainboxes PX cards.

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Bedant Patnaik <bedant.patnaik@gmail.com>
    ALSA: hda/realtek: Add a quirk for HP OMEN 15 (8786) mute LED

Meng Tang <tangmeng@uniontech.com>
    ALSA: hda/realtek: Add quirk for another Asus K42JZ model

Allen Ballway <ballway@chromium.org>
    ALSA: hda/cirrus - support for iMac 12,1 model

Meng Tang <tangmeng@uniontech.com>
    ALSA: hda/conexant: Add quirk for LENOVO 20149 Notebook model

Coleman Dietsch <dietschc@csp.edu>
    KVM: x86/xen: Stop Xen timer before changing IRQ

Coleman Dietsch <dietschc@csp.edu>
    KVM: x86/xen: Initialize Xen timer only once

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: revalidate steal time cache if MSR value changes

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: do not report preemption if the steal time cache is stale

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Fully re-evaluate MMIO caching when SPTE masks change

Sean Christopherson <seanjc@google.com>
    KVM: x86: Tag kvm_mmu_x86_module_init() with __init

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Disable SEV-ES support if MMIO caching is disable

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Treat NX as a valid SPTE bit for NPT

Sean Christopherson <seanjc@google.com>
    KVM: x86: Set error code to segment selector on LLDT/LTR non-canonical #GP

Sean Christopherson <seanjc@google.com>
    KVM: x86: Mark TSS busy during LTR emulation _after_ all fault checks

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Inject #UD if VMXON is attempted with incompatible CR0/CR4

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Account for KVM reserved CR4 bits in consistency checks

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Let userspace set nVMX MSR to any _host_ supported value

Sean Christopherson <seanjc@google.com>
    KVM: x86: Split kvm_is_valid_cr4() and export only the non-vendor bits

Sean Christopherson <seanjc@google.com>
    KVM: Do not incorporate page offset into gfn=>pfn cache user address

Sean Christopherson <seanjc@google.com>
    KVM: Fix multiple races in gfn=>pfn cache refresh

Sean Christopherson <seanjc@google.com>
    KVM: Fully serialize gfn=>pfn cache refresh via mutex

Sean Christopherson <seanjc@google.com>
    KVM: Put the extra pfn reference when reusing a pfn in the gpc cache

Sean Christopherson <seanjc@google.com>
    KVM: Drop unused @gpa param from gfn=>pfn cache's __release_gpc() helper

Nico Boehr <nrb@linux.ibm.com>
    KVM: s390: pv: don't present the ecall interrupt twice

Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
    KVM: SVM: Don't BUG if userspace injects an interrupt with GIF=0

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Snapshot pre-VM-Enter DEBUGCTL for !nested_run_pending case

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Snapshot pre-VM-Enter BNDCFGS for !nested_run_pending case

Ping Cheng <pinglinux@gmail.com>
    HID: wacom: Don't register pad_input for touch switch

Ping Cheng <pinglinux@gmail.com>
    HID: wacom: Only report rotation for art pen

Guenter Roeck <linux@roeck-us.net>
    HID: nintendo: Add missing array termination

Maximilian Luz <luzmaximilian@gmail.com>
    HID: hid-input: add Surface Go battery quirk

Jeff Layton <jlayton@kernel.org>
    lockd: detect and reject lock arguments that overflow

Mikulas Patocka <mpatocka@redhat.com>
    add barriers to buffer_uptodate and set_buffer_uptodate

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211_hwsim: use 32-bit skb cookie

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211_hwsim: add back erroneously removed cast

Jeongik Cha <jeongik@google.com>
    wifi: mac80211_hwsim: fix race condition in pending packet

Zev Weiss <zev@bewilderbeest.net>
    hwmon: (nct6775) Fix platform driver suspend regression

syed sabakareem <Syed.SabaKareem@amd.com>
    ASoC: amd: yc: Update DMI table entries

Philipp Jungkamp <p.jungkamp@gmx.net>
    ALSA: hda/realtek: Add quirk for Lenovo Yoga9 14IAP7

Ivan Hasenkampf <ivan.hasenkampf@gmail.com>
    ALSA: hda/realtek: Add quirk for HP Spectre x360 15-eb0xxx

Tim Crawford <tcrawford@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo NV45PZ

Zheyu Ma <zheyuma97@gmail.com>
    ALSA: bcd2000: Fix a UAF bug on the error path of probing

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add quirk for Behringer UMC202HD

Jeff Layton <jlayton@kernel.org>
    nfsd: eliminate the NFSD_FILE_BREAK_* flags

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS/flexfiles: Report RDMA connection errors to the server

Nilesh Javali <njavali@marvell.com>
    scsi: Revert "scsi: qla2xxx: Fix disk failure to rediscover"

Trond Myklebust <trond.myklebust@hammerspace.com>
    Revert "pNFS: nfs3_set_ds_client should set NFS_CS_NOPING"

Nick Desaulniers <ndesaulniers@google.com>
    x86: link vdso and boot with -z noexecstack --no-warn-rwx-segments

Nick Desaulniers <ndesaulniers@google.com>
    Makefile: link with -z noexecstack --no-warn-rwx-segments


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-driver-xen-blkback |   2 +-
 .../ABI/testing/sysfs-driver-xen-blkfront          |   2 +-
 .../admin-guide/device-mapper/writecache.rst       |  16 +-
 Documentation/admin-guide/kernel-parameters.txt    |  29 +-
 Documentation/admin-guide/pm/cpuidle.rst           |  15 +-
 Documentation/arm64/silicon-errata.rst             |   4 +
 .../bindings/display/bridge/fsl,ldb.yaml           |  16 +-
 .../devicetree/bindings/mmc/sdhci-msm.yaml         |  52 +-
 .../devicetree/bindings/riscv/sifive-l2-cache.yaml |   6 +-
 Documentation/filesystems/ext4/blockmap.rst        |   2 +-
 .../userspace-api/media/v4l/ext-ctrls-codec.rst    |   2 +-
 MAINTAINERS                                        |   7 +-
 Makefile                                           |  10 +-
 arch/Kconfig                                       |   3 +
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/aspeed-ast2500-evb.dts           |   2 +-
 arch/arm/boot/dts/aspeed-ast2600-evb-a1.dts        |   1 +
 arch/arm/boot/dts/aspeed-ast2600-evb.dts           |   2 +-
 arch/arm/boot/dts/bcm53015-meraki-mr26.dts         | 166 ++++
 arch/arm/boot/dts/imx6qdl-apalis.dtsi              |   4 +-
 arch/arm/boot/dts/imx6ul.dtsi                      |  33 +-
 arch/arm/boot/dts/imx7-colibri-aster.dtsi          |  71 --
 arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi        |  91 +--
 arch/arm/boot/dts/imx7-colibri.dtsi                | 130 +++-
 arch/arm/boot/dts/imx7d-colibri-aster.dts          |  20 +
 arch/arm/boot/dts/imx7d-colibri-emmc.dtsi          |   4 +
 arch/arm/boot/dts/imx7d-colibri-eval-v3.dts        |  32 +
 arch/arm/boot/dts/imx7s-colibri-aster.dts          |  20 +
 arch/arm/boot/dts/imx7s-colibri-eval-v3.dts        |  32 +
 arch/arm/boot/dts/qcom-ipq8064.dtsi                |   2 +-
 arch/arm/boot/dts/qcom-mdm9615.dtsi                |   1 +
 arch/arm/boot/dts/qcom-msm8974.dtsi                |   7 +-
 .../arm/boot/dts/qcom-msm8974pro-fairphone-fp2.dts |   2 +
 arch/arm/boot/dts/qcom-msm8974pro-samsung-klte.dts |   2 +
 arch/arm/boot/dts/qcom-pm8841.dtsi                 |   1 +
 arch/arm/boot/dts/qcom-sdx55.dtsi                  |   2 +-
 arch/arm/boot/dts/ste-ux500-samsung-codina.dts     |   4 +-
 arch/arm/boot/dts/ste-ux500-samsung-gavini.dts     |   4 +-
 arch/arm/boot/dts/ste-ux500-samsung-janice.dts     |   4 +-
 arch/arm/boot/dts/uniphier-pxs2.dtsi               |   8 +-
 arch/arm/crypto/Kconfig                            |   2 +-
 arch/arm/crypto/Makefile                           |   4 +-
 arch/arm/crypto/blake2s-shash.c                    |  75 --
 arch/arm/mach-bcm/bcm_kona_smc.c                   |   1 +
 arch/arm/mach-dove/Kconfig                         |   1 +
 arch/arm/mach-dove/pcie.c                          |  11 +-
 arch/arm/mach-mv78xx0/pcie.c                       |  11 +-
 arch/arm/mach-omap2/display.c                      |   3 +
 arch/arm/mach-omap2/pdata-quirks.c                 |   2 +
 arch/arm/mach-omap2/prm3xxx.c                      |   1 +
 arch/arm/mach-orion5x/Kconfig                      |   1 +
 arch/arm/mach-orion5x/pci.c                        |  12 +-
 arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c |   5 +-
 arch/arm/mach-zynq/common.c                        |   1 +
 arch/arm/xen/enlighten.c                           |   4 +-
 arch/arm64/Kconfig                                 |  17 +
 .../boot/dts/allwinner/sun50i-a64-orangepi-win.dts |   2 +-
 .../boot/dts/exynos/exynosautov9-pinctrl.dtsi      |   6 +-
 .../boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts  |   2 +-
 arch/arm64/boot/dts/mediatek/mt8192.dtsi           |  26 +-
 arch/arm64/boot/dts/nvidia/tegra186.dtsi           |   1 +
 arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi     |   2 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           |   1 +
 arch/arm64/boot/dts/nvidia/tegra234.dtsi           |   1 +
 arch/arm64/boot/dts/qcom/ipq6018.dtsi              |  22 +-
 arch/arm64/boot/dts/qcom/ipq8074.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   4 +-
 arch/arm64/boot/dts/qcom/msm8994.dtsi              |   1 +
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |   6 +-
 .../qcom/msm8998-sony-xperia-yoshino-poplar.dts    |  10 +-
 arch/arm64/boot/dts/qcom/qcs404.dtsi               |   4 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi       |   1 +
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |  24 +-
 arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi     |   4 +-
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |  30 +-
 arch/arm64/boot/dts/qcom/sdm630.dtsi               |   7 +-
 .../dts/qcom/sdm636-sony-xperia-ganges-mermaid.dts |   2 +-
 .../dts/qcom/sdm845-sony-xperia-tama-akatsuki.dts  |   5 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |  22 +-
 .../dts/qcom/sm6125-sony-xperia-seine-pdx201.dts   |  36 +-
 arch/arm64/boot/dts/qcom/sm6125.dtsi               |  30 +-
 arch/arm64/boot/dts/qcom/sm6350.dtsi               |  22 +-
 arch/arm64/boot/dts/qcom/sm8150.dtsi               |  24 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |  30 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |  24 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |  22 +-
 .../boot/dts/renesas/beacon-renesom-baseboard.dtsi |   6 +-
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi          |   2 +-
 arch/arm64/boot/dts/renesas/r8a77990.dtsi          |   2 +-
 arch/arm64/boot/dts/renesas/r8a779m8.dtsi          |   5 +
 arch/arm64/boot/dts/renesas/r9a07g054l2-smarc.dts  |   2 +-
 arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi   |   8 +-
 arch/arm64/crypto/Kconfig                          |   1 +
 arch/arm64/include/asm/kexec.h                     |   4 +-
 arch/arm64/include/asm/processor.h                 |   3 +-
 arch/arm64/kernel/Makefile                         |   5 +
 arch/arm64/kernel/armv8_deprecated.c               |   9 +-
 arch/arm64/kernel/cpu_errata.c                     |  16 +
 arch/arm64/kernel/cpufeature.c                     |  16 +-
 arch/arm64/kernel/hibernate.c                      |   5 -
 arch/arm64/kernel/mte.c                            |   9 -
 arch/arm64/kernel/stacktrace.c                     |   6 +-
 arch/arm64/kvm/handle_exit.c                       |   4 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |   2 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |   2 +-
 arch/arm64/mm/copypage.c                           |   9 -
 arch/arm64/mm/mteswap.c                            |   9 -
 arch/arm64/tools/cpucaps                           |   1 +
 arch/csky/abiv1/inc/abi/string.h                   |   6 +
 arch/ia64/include/asm/processor.h                  |   2 +-
 arch/loongarch/kernel/proc.c                       |   2 +-
 arch/m68k/virt/platform.c                          |  58 +-
 arch/mips/kernel/proc.c                            |   2 +-
 arch/mips/kernel/vdso.c                            |   2 +-
 arch/mips/loongson64/numa.c                        |   1 -
 arch/mips/mm/physaddr.c                            |  14 +-
 arch/parisc/kernel/cache.c                         |   3 -
 arch/parisc/kernel/drivers.c                       |   9 +-
 arch/parisc/kernel/syscalls/syscall.tbl            |   2 +-
 arch/powerpc/configs/44x/akebono_defconfig         |   2 +-
 arch/powerpc/configs/44x/currituck_defconfig       |   2 +-
 arch/powerpc/configs/44x/fsp2_defconfig            |   2 +-
 arch/powerpc/configs/44x/iss476-smp_defconfig      |   2 +-
 arch/powerpc/configs/44x/warp_defconfig            |   2 +-
 arch/powerpc/configs/52xx/lite5200b_defconfig      |   2 +-
 arch/powerpc/configs/52xx/motionpro_defconfig      |   2 +-
 arch/powerpc/configs/52xx/tqm5200_defconfig        |   2 +-
 arch/powerpc/configs/adder875_defconfig            |   2 +-
 arch/powerpc/configs/ep8248e_defconfig             |   2 +-
 arch/powerpc/configs/ep88xc_defconfig              |   2 +-
 arch/powerpc/configs/fsl-emb-nonhw.config          |   2 +-
 arch/powerpc/configs/mgcoge_defconfig              |   2 +-
 arch/powerpc/configs/mpc5200_defconfig             |   2 +-
 arch/powerpc/configs/mpc8272_ads_defconfig         |   2 +-
 arch/powerpc/configs/mpc885_ads_defconfig          |   2 +-
 arch/powerpc/configs/ppc6xx_defconfig              |   2 +-
 arch/powerpc/configs/pq2fads_defconfig             |   2 +-
 arch/powerpc/configs/ps3_defconfig                 |   2 +-
 arch/powerpc/configs/tqm8xx_defconfig              |   2 +-
 arch/powerpc/include/asm/archrandom.h              |   5 -
 arch/powerpc/include/asm/kexec.h                   |   9 +
 arch/powerpc/include/asm/simple_spinlock.h         |  15 +-
 arch/powerpc/kernel/iommu.c                        |   5 +
 arch/powerpc/kernel/pci-common.c                   |  29 +-
 arch/powerpc/kernel/trace/ftrace.c                 |   8 +-
 arch/powerpc/kexec/file_load_64.c                  |  55 ++
 arch/powerpc/kvm/book3s_hv_builtin.c               |   7 +-
 arch/powerpc/kvm/book3s_xics.h                     |   1 +
 arch/powerpc/mm/kasan/init_32.c                    |   2 +-
 arch/powerpc/mm/nohash/8xx.c                       |   4 +-
 arch/powerpc/mm/nohash/tlb_low_64e.S               |  17 +-
 arch/powerpc/mm/pgtable_32.c                       |   6 +-
 arch/powerpc/mm/ptdump/shared.c                    |   6 +-
 arch/powerpc/perf/core-book3s.c                    |  35 +-
 arch/powerpc/platforms/Kconfig.cputype             |   4 +-
 arch/powerpc/platforms/cell/axon_msi.c             |   1 +
 arch/powerpc/platforms/cell/spufs/inode.c          |   1 +
 arch/powerpc/platforms/powernv/rng.c               |  34 +-
 arch/powerpc/platforms/pseries/iommu.c             |  89 ++-
 arch/powerpc/sysdev/fsl_pci.c                      |   8 +
 arch/powerpc/sysdev/fsl_pci.h                      |   1 +
 arch/powerpc/sysdev/xive/spapr.c                   |   1 +
 arch/riscv/boot/dts/starfive/jh7100.dtsi           |   2 +-
 arch/riscv/include/asm/cpu_ops.h                   |   1 +
 arch/riscv/kernel/cpu_ops.c                        |   4 +-
 arch/riscv/kernel/cpu_ops_spinwait.c               |   6 +-
 arch/riscv/kernel/crash_save_regs.S                |   2 +-
 arch/riscv/kernel/machine_kexec.c                  |  28 +-
 arch/riscv/kernel/probes/uprobes.c                 |   6 -
 arch/riscv/lib/uaccess.S                           |   4 +-
 arch/riscv/mm/init.c                               |   4 +
 arch/s390/include/asm/gmap.h                       |   2 +
 arch/s390/include/asm/kexec.h                      |   3 +
 arch/s390/include/asm/unwind.h                     |   2 +-
 arch/s390/kernel/crash_dump.c                      |   2 +-
 arch/s390/kernel/machine_kexec_file.c              |  18 +-
 arch/s390/kvm/intercept.c                          |  15 +
 arch/s390/kvm/pv.c                                 |   9 +-
 arch/s390/kvm/sigp.c                               |   4 +-
 arch/s390/mm/gmap.c                                |  86 +++
 arch/s390/mm/init.c                                |   4 +-
 arch/um/drivers/random.c                           |   2 +-
 arch/um/include/asm/archrandom.h                   |  30 +
 arch/um/include/asm/xor.h                          |   2 +-
 arch/um/include/shared/os.h                        |   7 +
 arch/um/kernel/um_arch.c                           |   8 +
 arch/um/os-Linux/util.c                            |   6 +
 arch/x86/Kconfig                                   |   1 +
 arch/x86/Kconfig.debug                             |   3 -
 arch/x86/boot/Makefile                             |   2 +-
 arch/x86/boot/compressed/Makefile                  |   4 +
 arch/x86/crypto/Makefile                           |   4 +-
 arch/x86/crypto/blake2s-glue.c                     |   3 +-
 arch/x86/crypto/blake2s-shash.c                    |  77 --
 arch/x86/entry/Makefile                            |   3 +-
 arch/x86/entry/thunk_32.S                          |   2 -
 arch/x86/entry/thunk_64.S                          |   4 -
 arch/x86/entry/vdso/Makefile                       |   2 +-
 arch/x86/events/intel/core.c                       |   7 +-
 arch/x86/events/intel/ds.c                         | 129 ++--
 arch/x86/events/perf_event.h                       |  14 +
 arch/x86/include/asm/kexec.h                       |   6 +
 arch/x86/include/asm/kvm_host.h                    |   3 +-
 arch/x86/kernel/cpu/bugs.c                         |  10 +-
 arch/x86/kernel/cpu/intel.c                        |  27 +-
 arch/x86/kernel/ftrace.c                           |   1 +
 arch/x86/kernel/kprobes/core.c                     |  18 +-
 arch/x86/kernel/pmem.c                             |   7 +-
 arch/x86/kernel/process.c                          |   9 +-
 arch/x86/kvm/emulate.c                             |  23 +-
 arch/x86/kvm/mmu.h                                 |   2 +
 arch/x86/kvm/mmu/mmu.c                             |   8 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |   9 +-
 arch/x86/kvm/mmu/spte.c                            |  22 +
 arch/x86/kvm/mmu/spte.h                            |   3 +-
 arch/x86/kvm/svm/nested.c                          |   3 +-
 arch/x86/kvm/svm/sev.c                             |  10 +
 arch/x86/kvm/svm/svm.c                             |  38 +-
 arch/x86/kvm/vmx/nested.c                          | 106 +--
 arch/x86/kvm/vmx/nested.h                          |   3 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |  13 +-
 arch/x86/kvm/vmx/vmx.c                             |   4 +-
 arch/x86/kvm/vmx/vmx.h                             |  12 +
 arch/x86/kvm/x86.c                                 |  33 +-
 arch/x86/kvm/x86.h                                 |   2 +-
 arch/x86/kvm/xen.c                                 |  31 +-
 arch/x86/mm/extable.c                              |  16 +-
 arch/x86/mm/mem_encrypt_amd.c                      |   4 +-
 arch/x86/mm/numa.c                                 |   4 +-
 arch/x86/net/bpf_jit_comp.c                        |  31 +
 arch/x86/platform/olpc/olpc-xo1-sci.c              |   2 +-
 arch/x86/um/Makefile                               |   3 +-
 arch/x86/xen/enlighten_hvm.c                       |   4 +-
 arch/x86/xen/enlighten_pv.c                        |   5 +-
 arch/xtensa/platforms/iss/network.c                |  42 +-
 block/bio.c                                        |  99 +--
 block/blk-iocost.c                                 |  20 +-
 block/blk-iolatency.c                              |  18 +-
 block/blk-mq-debugfs.c                             |   3 +
 block/blk-rq-qos.h                                 |  11 +-
 block/blk-wbt.c                                    |  12 +-
 crypto/Kconfig                                     |  20 +-
 crypto/Makefile                                    |   1 -
 crypto/asymmetric_keys/public_key.c                |   7 +-
 crypto/blake2s_generic.c                           |  75 --
 crypto/tcrypt.c                                    |  12 -
 crypto/testmgr.c                                   |  24 -
 crypto/testmgr.h                                   | 217 ------
 drivers/acpi/acpi_lpss.c                           |   3 +
 drivers/acpi/apei/einj.c                           |   2 +
 drivers/acpi/bus.c                                 |   1 +
 drivers/acpi/cppc_acpi.c                           |  54 +-
 drivers/acpi/ec.c                                  |  82 +-
 drivers/acpi/processor_idle.c                      |   6 +-
 drivers/acpi/sleep.c                               |   8 +
 drivers/acpi/video_detect.c                        |   8 +
 drivers/acpi/viot.c                                |  26 +-
 drivers/android/binder.c                           | 114 ++-
 drivers/android/binder_alloc.c                     |  30 +-
 drivers/android/binder_alloc.h                     |   2 +-
 drivers/android/binder_alloc_selftest.c            |   2 +-
 drivers/android/binder_internal.h                  |  46 +-
 drivers/android/binderfs.c                         |  47 +-
 drivers/base/dd.c                                  |   5 +-
 drivers/base/node.c                                |   4 +-
 drivers/base/power/domain.c                        |   3 +
 drivers/base/topology.c                            |  32 +-
 drivers/block/mtip32xx/mtip32xx.c                  | 157 ++--
 drivers/block/mtip32xx/mtip32xx.h                  |   1 -
 drivers/block/nbd.c                                |   6 +-
 drivers/block/null_blk/main.c                      |  14 +-
 drivers/block/rnbd/rnbd-srv.c                      |   3 +-
 drivers/block/xen-blkback/xenbus.c                 |  20 +-
 drivers/block/xen-blkfront.c                       |   4 +-
 drivers/bluetooth/hci_intel.c                      |   6 +-
 drivers/bluetooth/hci_serdev.c                     |  11 +
 drivers/bus/hisi_lpc.c                             |  10 +-
 drivers/char/tpm/tpm2-cmd.c                        |   6 +
 drivers/clk/imx/clk-fracn-gppll.c                  |  33 +-
 drivers/clk/imx/clk-imx93.c                        |   4 +-
 drivers/clk/mediatek/reset.c                       |   4 +-
 drivers/clk/qcom/camcc-sdm845.c                    |   4 +
 drivers/clk/qcom/camcc-sm8250.c                    |  16 +-
 drivers/clk/qcom/clk-krait.c                       |   7 +-
 drivers/clk/qcom/clk-rcg2.c                        |  16 +-
 drivers/clk/qcom/dispcc-sm8250.c                   |   1 -
 drivers/clk/qcom/gcc-ipq8074.c                     |  60 +-
 drivers/clk/qcom/gcc-msm8939.c                     |  33 +-
 drivers/clk/qcom/gdsc.c                            |   8 +
 drivers/clk/qcom/videocc-sm8250.c                  |   4 -
 drivers/clk/renesas/r9a06g032-clocks.c             |   8 +-
 drivers/clk/renesas/rzg2l-cpg.c                    |   2 +-
 drivers/cpufreq/mediatek-cpufreq-hw.c              |   7 +-
 drivers/cpufreq/mediatek-cpufreq.c                 |   1 +
 drivers/cpufreq/scmi-cpufreq.c                     |   6 +
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |   1 +
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |  16 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c  |  10 +-
 drivers/crypto/ccp/sev-dev.c                       |  12 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |   2 +-
 drivers/crypto/hisilicon/sec/sec_algs.c            |  14 +-
 drivers/crypto/hisilicon/sec/sec_drv.h             |   2 +-
 drivers/crypto/hisilicon/sec2/sec.h                |   2 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |  26 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.h         |   1 +
 drivers/crypto/inside-secure/safexcel.c            |   2 +
 drivers/dma/dw-edma/dw-edma-core.c                 |   2 +-
 drivers/dma/dw/rzn1-dmamux.c                       |   3 +
 drivers/dma/imx-dma.c                              |   2 +-
 drivers/dma/sf-pdma/sf-pdma.c                      |  44 +-
 drivers/firmware/arm_scpi.c                        |  61 +-
 drivers/firmware/tegra/bpmp-debugfs.c              |  10 +-
 drivers/fpga/altera-pr-ip-core.c                   |   2 +-
 drivers/gpio/gpiolib-of.c                          |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c            |  60 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   4 +
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   7 +-
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c             |  21 -
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.h             |   1 -
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c             |  21 -
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.h             |   1 -
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   2 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |   2 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |  17 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |  52 +-
 drivers/gpu/drm/amd/display/dc/dc.h                |   1 +
 .../amd/display/dc/dce110/dce110_hw_sequencer.c    |  23 +-
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dccg.c  |  13 +-
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dccg.h  |   2 +-
 drivers/gpu/drm/amd/display/dc/inc/hw/dccg.h       |   4 +-
 drivers/gpu/drm/amd/display/dc/inc/hw/mpc.h        |   5 +
 .../drm/amd/display/dc/inc/hw_sequencer_private.h  |   2 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |   2 +
 drivers/gpu/drm/bridge/Kconfig                     |   3 +
 drivers/gpu/drm/bridge/adv7511/adv7511.h           |  12 -
 drivers/gpu/drm/bridge/adv7511/adv7511_cec.c       |  12 +
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |  24 +-
 drivers/gpu/drm/bridge/analogix/anx7625.c          |  21 +-
 drivers/gpu/drm/bridge/lontium-lt9611.c            |   2 +-
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c         |   2 +-
 drivers/gpu/drm/bridge/sil-sii8620.c               |   4 +-
 drivers/gpu/drm/bridge/tc358767.c                  |  34 +-
 drivers/gpu/drm/display/Kconfig                    |   2 +-
 drivers/gpu/drm/display/drm_dp_aux_bus.c           |   4 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |   7 +-
 drivers/gpu/drm/drm_edid.c                         |   1 +
 drivers/gpu/drm/drm_fb_helper.c                    |  27 +-
 drivers/gpu/drm/drm_gem.c                          |   4 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c             |   1 +
 drivers/gpu/drm/drm_mipi_dbi.c                     |   7 +
 drivers/gpu/drm/exynos/exynos7_drm_decon.c         |  17 +-
 drivers/gpu/drm/hyperv/hyperv_drm_modeset.c        |   2 +
 drivers/gpu/drm/i915/i915_gem.h                    |   4 -
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c          |  10 +-
 drivers/gpu/drm/ingenic/ingenic-drm.h              |   3 +
 drivers/gpu/drm/mcde/mcde_dsi.c                    |   1 +
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |  33 +-
 drivers/gpu/drm/mediatek/mtk_dsi.c                 |  93 ++-
 drivers/gpu/drm/meson/meson_encoder_cvbs.c         |   1 +
 drivers/gpu/drm/meson/meson_encoder_hdmi.c         |  19 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c             |  10 +
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |   8 -
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |  13 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  12 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h              |   3 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c           |   6 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |  36 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c    |   6 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c     |   6 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c          |   3 +-
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   3 +
 drivers/gpu/drm/msm/msm_fence.c                    |  11 +-
 drivers/gpu/drm/msm/msm_gpu.h                      |  11 +-
 drivers/gpu/drm/msm/msm_gpu_devfreq.c              |  39 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   8 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |   4 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c    |   2 +-
 drivers/gpu/drm/panel/Kconfig                      |   2 +
 drivers/gpu/drm/radeon/.gitignore                  |   2 +-
 drivers/gpu/drm/radeon/Kconfig                     |   2 +-
 drivers/gpu/drm/radeon/Makefile                    |   2 +-
 drivers/gpu/drm/radeon/ni_dpm.c                    |   6 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   2 +-
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c    |  10 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |   3 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |   1 +
 drivers/gpu/drm/solomon/ssd130x-spi.c              |   2 +
 drivers/gpu/drm/tegra/gem.c                        |  11 +-
 drivers/gpu/drm/tiny/st7735r.c                     |   1 +
 drivers/gpu/drm/vc4/vc4_crtc.c                     |  14 +-
 drivers/gpu/drm/vc4/vc4_dsi.c                      | 152 +++-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     | 169 ++++-
 drivers/gpu/drm/vc4/vc4_hdmi.h                     |   8 +
 drivers/gpu/drm/vc4/vc4_hdmi_regs.h                |   7 +-
 drivers/gpu/drm/vc4/vc4_kms.c                      |   4 +-
 drivers/gpu/drm/vc4/vc4_plane.c                    |  30 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |   6 +-
 drivers/gpu/drm/virtio/virtgpu_object.c            |   4 +-
 drivers/gpu/drm/vkms/vkms_composer.c               |   2 +-
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |   2 +
 drivers/hid/amd-sfh-hid/amd_sfh_hid.c              |  12 +-
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c             |   3 +-
 drivers/hid/hid-alps.c                             |   2 +
 drivers/hid/hid-cp2112.c                           |   5 +
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-input.c                            |   2 +
 drivers/hid/hid-mcp2221.c                          |   3 +
 drivers/hid/hid-nintendo.c                         |   1 +
 drivers/hid/wacom_sys.c                            |   2 +-
 drivers/hid/wacom_wac.c                            |  72 +-
 drivers/hwmon/dell-smm-hwmon.c                     |   8 +
 drivers/hwmon/drivetemp.c                          |   1 +
 drivers/hwmon/nct6775-core.c                       |   3 +-
 drivers/hwmon/nct6775-platform.c                   |   2 +-
 drivers/hwmon/nct6775.h                            |   2 +
 drivers/hwmon/sch56xx-common.c                     |  44 +-
 drivers/hwmon/sht15.c                              |  17 +-
 drivers/hwtracing/coresight/coresight-config.h     |   2 +
 drivers/hwtracing/coresight/coresight-core.c       |   1 +
 drivers/hwtracing/coresight/coresight-syscfg.c     | 295 +++++--
 drivers/hwtracing/coresight/coresight-syscfg.h     |  13 +
 drivers/hwtracing/intel_th/msu-sink.c              |   3 +
 drivers/hwtracing/intel_th/msu.c                   |  14 +-
 drivers/hwtracing/intel_th/pci.c                   |  25 +-
 drivers/i2c/busses/i2c-cadence.c                   |  10 +-
 drivers/i2c/busses/i2c-mxs.c                       |   2 +-
 drivers/i2c/busses/i2c-npcm7xx.c                   |  50 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |   2 +-
 drivers/i2c/i2c-core-base.c                        |   3 +-
 drivers/i2c/muxes/i2c-mux-gpmux.c                  |   1 +
 drivers/idle/intel_idle.c                          |  24 +-
 drivers/iio/accel/Kconfig                          |   2 +
 drivers/iio/accel/adxl313_core.c                   |   2 +-
 drivers/iio/accel/adxl355_core.c                   |   2 +-
 drivers/iio/accel/adxl367.c                        |   2 +-
 drivers/iio/accel/adxl367_spi.c                    |   8 +-
 drivers/iio/accel/bma220_spi.c                     |   2 +-
 drivers/iio/accel/bma400.h                         |  35 +-
 drivers/iio/accel/bma400_core.c                    | 250 +++++-
 drivers/iio/accel/bma400_i2c.c                     |  10 +-
 drivers/iio/accel/bma400_spi.c                     |   8 +-
 drivers/iio/accel/cros_ec_accel_legacy.c           |   4 +-
 drivers/iio/accel/sca3000.c                        |   4 +-
 drivers/iio/accel/sca3300.c                        |   2 +-
 drivers/iio/adc/ad7266.c                           |   4 +-
 drivers/iio/adc/ad7280a.c                          |   2 +-
 drivers/iio/adc/ad7292.c                           |   2 +-
 drivers/iio/adc/ad7298.c                           |   2 +-
 drivers/iio/adc/ad7476.c                           |   5 +-
 drivers/iio/adc/ad7606.h                           |   4 +-
 drivers/iio/adc/ad7766.c                           |   5 +-
 drivers/iio/adc/ad7768-1.c                         |   4 +-
 drivers/iio/adc/ad7887.c                           |   5 +-
 drivers/iio/adc/ad7923.c                           |   4 +-
 drivers/iio/adc/ad7949.c                           |   2 +-
 drivers/iio/adc/adi-axi-adc.c                      |   7 +-
 drivers/iio/adc/hi8435.c                           |   2 +-
 drivers/iio/adc/ltc2496.c                          |   4 +-
 drivers/iio/adc/ltc2497.c                          |   4 +-
 drivers/iio/adc/max1027.c                          |   8 +-
 drivers/iio/adc/max11100.c                         |   4 +-
 drivers/iio/adc/max1118.c                          |   2 +-
 drivers/iio/adc/max1241.c                          |   2 +-
 drivers/iio/adc/mcp320x.c                          |   2 +-
 drivers/iio/adc/ti-adc0832.c                       |   2 +-
 drivers/iio/adc/ti-adc084s021.c                    |   4 +-
 drivers/iio/adc/ti-adc108s102.c                    |   4 +-
 drivers/iio/adc/ti-adc12138.c                      |   2 +-
 drivers/iio/adc/ti-adc128s052.c                    |   2 +-
 drivers/iio/adc/ti-adc161s626.c                    |   2 +-
 drivers/iio/adc/ti-ads124s08.c                     |   2 +-
 drivers/iio/adc/ti-ads131e08.c                     |   2 +-
 drivers/iio/adc/ti-ads7950.c                       |   4 +-
 drivers/iio/adc/ti-ads8344.c                       |   2 +-
 drivers/iio/adc/ti-ads8688.c                       |   2 +-
 drivers/iio/adc/ti-tlc4541.c                       |   4 +-
 drivers/iio/addac/ad74413r.c                       |   4 +-
 drivers/iio/amplifiers/ad8366.c                    |   4 +-
 .../iio/common/cros_ec_sensors/cros_ec_lid_angle.c |   4 +-
 .../iio/common/cros_ec_sensors/cros_ec_sensors.c   |   6 +-
 .../common/cros_ec_sensors/cros_ec_sensors_core.c  |  58 +-
 drivers/iio/common/ssp_sensors/ssp.h               |   3 +-
 drivers/iio/dac/ad5064.c                           |   4 +-
 drivers/iio/dac/ad5360.c                           |   4 +-
 drivers/iio/dac/ad5421.c                           |   4 +-
 drivers/iio/dac/ad5449.c                           |   4 +-
 drivers/iio/dac/ad5504.c                           |   2 +-
 drivers/iio/dac/ad5592r-base.h                     |   4 +-
 drivers/iio/dac/ad5686.h                           |   6 +-
 drivers/iio/dac/ad5755.c                           |   4 +-
 drivers/iio/dac/ad5761.c                           |   4 +-
 drivers/iio/dac/ad5764.c                           |   4 +-
 drivers/iio/dac/ad5766.c                           |   2 +-
 drivers/iio/dac/ad5770r.c                          |   2 +-
 drivers/iio/dac/ad5791.c                           |   2 +-
 drivers/iio/dac/ad7293.c                           |   2 +-
 drivers/iio/dac/ad7303.c                           |   4 +-
 drivers/iio/dac/ad8801.c                           |   2 +-
 drivers/iio/dac/ltc2688.c                          |   4 +-
 drivers/iio/dac/mcp4922.c                          |   2 +-
 drivers/iio/dac/ti-dac082s085.c                    |   2 +-
 drivers/iio/dac/ti-dac5571.c                       |   2 +-
 drivers/iio/dac/ti-dac7311.c                       |   2 +-
 drivers/iio/dac/ti-dac7612.c                       |   4 +-
 drivers/iio/frequency/ad9523.c                     |   6 +-
 drivers/iio/frequency/adf4350.c                    |   6 +-
 drivers/iio/frequency/adf4371.c                    |   2 +-
 drivers/iio/frequency/admv1013.c                   |   2 +-
 drivers/iio/frequency/admv1014.c                   |   2 +-
 drivers/iio/frequency/admv4420.c                   |   2 +-
 drivers/iio/frequency/adrf6780.c                   |   2 +-
 drivers/iio/gyro/adis16080.c                       |   2 +-
 drivers/iio/gyro/adis16130.c                       |   2 +-
 drivers/iio/gyro/adxrs450.c                        |   2 +-
 drivers/iio/gyro/fxas21002c_core.c                 |   6 +-
 drivers/iio/imu/fxos8700_core.c                    |   2 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600.h        |   2 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.h |   2 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h          |   2 +-
 drivers/iio/industrialio-core.c                    |  22 +-
 drivers/iio/light/cros_ec_light_prox.c             |   6 +-
 drivers/iio/light/isl29028.c                       |   2 +-
 drivers/iio/potentiometer/ad5110.c                 |   4 +-
 drivers/iio/potentiometer/ad5272.c                 |   2 +-
 drivers/iio/potentiometer/max5481.c                |   2 +-
 drivers/iio/potentiometer/mcp41010.c               |   2 +-
 drivers/iio/potentiometer/mcp4131.c                |   2 +-
 drivers/iio/pressure/cros_ec_baro.c                |   6 +-
 drivers/iio/proximity/as3935.c                     |   2 +-
 drivers/iio/proximity/sx9324.c                     |   4 +-
 drivers/iio/resolver/ad2s1200.c                    |   2 +-
 drivers/iio/resolver/ad2s90.c                      |   2 +-
 drivers/iio/temperature/ltc2983.c                  |   4 +-
 drivers/iio/temperature/max31865.c                 |   2 +-
 drivers/iio/temperature/maxim_thermocouple.c       |   2 +-
 drivers/infiniband/hw/hfi1/file_ops.c              |   4 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   4 +-
 drivers/infiniband/hw/irdma/cm.c                   |  11 +-
 drivers/infiniband/hw/irdma/hw.c                   |  15 +-
 drivers/infiniband/hw/irdma/verbs.c                |   2 +-
 drivers/infiniband/hw/mlx5/fs.c                    |   6 +-
 drivers/infiniband/hw/qedr/verbs.c                 |   8 +-
 drivers/infiniband/sw/rxe/rxe_comp.c               |   8 +-
 drivers/infiniband/sw/rxe/rxe_loc.h                |   2 +-
 drivers/infiniband/sw/rxe/rxe_mr.c                 |  12 +-
 drivers/infiniband/sw/rxe/rxe_mw.c                 |   7 -
 drivers/infiniband/sw/rxe/rxe_pool.c               |   4 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |  23 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |  23 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |  24 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |   1 +
 drivers/infiniband/sw/siw/siw_cm.c                 |   7 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c           |   4 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |  35 +-
 drivers/infiniband/ulp/rtrs/rtrs-pri.h             |  21 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              | 148 +++-
 drivers/infiniband/ulp/srpt/ib_srpt.h              |  18 +-
 drivers/input/serio/gscps2.c                       |   4 +
 drivers/interconnect/imx/imx.c                     |   8 +-
 drivers/iommu/arm/arm-smmu/qcom_iommu.c            |   7 +-
 drivers/iommu/exynos-iommu.c                       |   6 +-
 drivers/iommu/intel/dmar.c                         |   2 +-
 drivers/irqchip/Kconfig                            |   5 +-
 drivers/irqchip/irq-mips-gic.c                     |  84 +-
 drivers/leds/rgb/leds-pwm-multicolor.c             |   3 +-
 drivers/md/dm-raid.c                               |   5 +-
 drivers/md/dm-thin-metadata.c                      |   7 +-
 drivers/md/dm-thin.c                               |   4 +-
 drivers/md/dm-writecache.c                         |  43 +-
 drivers/md/dm.c                                    |  18 +-
 drivers/md/md.c                                    |   2 +-
 drivers/md/raid10.c                                |   5 +-
 drivers/media/i2c/Kconfig                          |   1 +
 drivers/media/i2c/ov7251.c                         |   2 +
 drivers/media/pci/sta2x11/Kconfig                  |   2 +-
 drivers/media/pci/tw686x/tw686x-core.c             |  18 +-
 drivers/media/pci/tw686x/tw686x-video.c            |   4 +-
 drivers/media/platform/amphion/vdec.c              |  47 +-
 drivers/media/platform/amphion/vpu.h               |   1 +
 drivers/media/platform/amphion/vpu_core.c          |   7 +-
 drivers/media/platform/amphion/vpu_malone.c        |   4 +
 drivers/media/platform/amphion/vpu_msgs.c          |   7 +-
 drivers/media/platform/amphion/vpu_rpc.h           |   7 +-
 drivers/media/platform/amphion/vpu_v4l2.c          |   6 +-
 drivers/media/platform/atmel/atmel-sama7g5-isc.c   |   2 +
 drivers/media/platform/mediatek/mdp/mtk_mdp_ipi.h  |   2 +
 .../platform/mediatek/vcodec/mtk_vcodec_dec.c      |  73 +-
 .../platform/mediatek/vcodec/mtk_vcodec_dec_drv.c  |   5 +
 .../mediatek/vcodec/mtk_vcodec_dec_stateless.c     |   7 +
 .../platform/mediatek/vcodec/mtk_vcodec_drv.h      |   4 -
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.c  |   5 +
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.h  |   9 +-
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c     | 264 +++----
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h     |   2 -
 drivers/media/platform/qcom/camss/camss-csid.c     |   2 +-
 .../media/platform/renesas/rcar-vin/rcar-core.c    |   2 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |   2 +-
 drivers/media/v4l2-core/v4l2-async.c               |  35 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   2 +-
 drivers/memstick/core/ms_block.c                   |  11 +-
 drivers/mfd/max77620.c                             |   2 +
 drivers/mfd/t7l66xb.c                              |   6 +-
 drivers/misc/cardreader/rtsx_pcr.c                 |   6 +-
 drivers/misc/eeprom/idt_89hpesx.c                  |   8 +-
 drivers/misc/habanalabs/common/memory.c            |   6 +-
 drivers/mmc/core/block.c                           |  28 +-
 drivers/mmc/core/quirks.h                          |   4 +-
 drivers/mmc/host/cavium-octeon.c                   |   1 +
 drivers/mmc/host/cavium-thunderx.c                 |   4 +-
 drivers/mmc/host/mxcmmc.c                          |   2 +-
 drivers/mmc/host/renesas_sdhi_core.c               |   8 +-
 drivers/mmc/host/sdhci-of-at91.c                   |   9 +-
 drivers/mmc/host/sdhci-of-esdhc.c                  |   1 +
 drivers/mtd/devices/mtd_dataflash.c                |   8 +
 drivers/mtd/devices/spear_smi.c                    |  10 +-
 drivers/mtd/devices/st_spi_fsm.c                   |  12 +-
 drivers/mtd/hyperbus/rpc-if.c                      |   8 +-
 drivers/mtd/maps/physmap-versatile.c               |   2 +
 drivers/mtd/nand/raw/arasan-nand-controller.c      |  16 +-
 drivers/mtd/nand/raw/meson_nand.c                  |   1 -
 drivers/mtd/parsers/ofpart_bcm4908.c               |   3 +
 drivers/mtd/parsers/redboot.c                      |   1 +
 drivers/mtd/sm_ftl.c                               |   2 +-
 drivers/mtd/spi-nor/core.c                         |   6 +-
 drivers/net/can/dev/netlink.c                      |   6 +-
 drivers/net/can/pch_can.c                          |   8 +-
 drivers/net/can/rcar/rcar_can.c                    |   8 +-
 drivers/net/can/sja1000/sja1000.c                  |   7 +-
 drivers/net/can/spi/hi311x.c                       |   5 +-
 drivers/net/can/sun4i_can.c                        |   9 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |  12 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |   6 +-
 drivers/net/can/usb/usb_8dev.c                     |   7 +-
 drivers/net/dsa/ocelot/Kconfig                     |   1 +
 drivers/net/dsa/ocelot/felix.c                     |   9 +
 drivers/net/dsa/ocelot/felix.h                     |   1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c             | 300 +++++++-
 drivers/net/ethernet/atheros/ag71xx.c              |   2 +-
 drivers/net/ethernet/huawei/hinic/hinic_dev.h      |   3 -
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |  68 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c       |   2 -
 drivers/net/ethernet/huawei/hinic/hinic_tx.c       |   2 -
 drivers/net/ethernet/intel/iavf/iavf.h             |   6 +
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  46 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  21 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  12 +
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.c   |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |  14 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  23 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   4 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_dbg.c  |  13 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   1 +
 drivers/net/ethernet/mscc/ocelot_ptp.c             |   8 +
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   2 +-
 drivers/net/netdevsim/bpf.c                        |   8 +-
 drivers/net/netdevsim/fib.c                        |  27 +-
 drivers/net/usb/Kconfig                            |   3 +-
 drivers/net/usb/ax88179_178a.c                     |  26 +-
 drivers/net/usb/smsc95xx.c                         |  26 +-
 drivers/net/usb/usbnet.c                           |   8 +-
 drivers/net/wireguard/allowedips.c                 |   9 +-
 drivers/net/wireguard/selftest/allowedips.c        |   6 +-
 drivers/net/wireguard/selftest/ratelimiter.c       |  25 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   2 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   8 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   5 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   2 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   2 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |  56 +-
 drivers/net/wireless/ath/ath11k/core.c             |  30 +-
 drivers/net/wireless/ath/ath11k/debug.h            |   4 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   5 +-
 drivers/net/wireless/ath/ath11k/htc.c              |   4 +-
 drivers/net/wireless/ath/ath11k/hw.h               |   2 -
 drivers/net/wireless/ath/ath11k/mac.c              |  25 +-
 drivers/net/wireless/ath/ath11k/pci.c              |  72 +-
 drivers/net/wireless/ath/ath11k/pcic.c             |  57 +-
 drivers/net/wireless/ath/ath11k/pcic.h             |   2 +
 drivers/net/wireless/ath/ath11k/wmi.c              |   4 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   6 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |   2 +-
 drivers/net/wireless/ath/ath9k/htc.h               |  10 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   3 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |   9 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |  18 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   4 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |   4 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      |   4 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   2 +-
 drivers/net/wireless/intersil/p54/main.c           |   2 +-
 drivers/net/wireless/intersil/p54/p54spi.c         |   3 +-
 drivers/net/wireless/mac80211_hwsim.c              |  36 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |   1 +
 drivers/net/wireless/marvell/libertas/mesh.c       |  10 +-
 drivers/net/wireless/marvell/mwifiex/11h.c         |   2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  18 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |   5 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |  21 -
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  14 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   1 -
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |   6 +
 .../net/wireless/mediatek/mt76/mt76_connac2_mac.h  | 167 ++++
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   | 284 +++++++
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |   2 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    | 260 +------
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    | 142 +---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  16 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |  17 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    | 213 +-----
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h    | 123 +--
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  25 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |  15 -
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |   4 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mcu.c    |   6 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mcu.c   |  10 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |   3 +-
 drivers/net/wireless/microchip/wilc1000/spi.c      |   6 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  14 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |   2 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c     |  15 +-
 drivers/net/wireless/realtek/rtlwifi/debug.c       |   8 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   4 +
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c  |   4 +-
 drivers/net/wireless/ti/wlcore/main.c              |   2 +-
 drivers/nvme/host/core.c                           |  14 +-
 drivers/nvme/host/multipath.c                      |   1 +
 drivers/nvme/host/trace.h                          |   2 +-
 drivers/of/device.c                                |   5 +-
 drivers/of/fdt.c                                   |   2 +-
 drivers/of/kexec.c                                 |  17 +
 drivers/opp/core.c                                 |   4 +-
 drivers/opp/of.c                                   |  15 +-
 drivers/parisc/lba_pci.c                           |   6 +-
 drivers/pci/controller/dwc/pcie-designware-ep.c    |  18 +-
 drivers/pci/controller/dwc/pcie-designware-host.c  |  30 +-
 drivers/pci/controller/dwc/pcie-designware.c       |  46 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |  58 +-
 drivers/pci/controller/dwc/pcie-tegra194.c         |  49 +-
 drivers/pci/controller/pcie-mediatek-gen3.c        |   7 +-
 drivers/pci/controller/pcie-microchip-host.c       |   2 +
 drivers/pci/endpoint/functions/pci-epf-test.c      |   1 -
 drivers/pci/pcie/aer.c                             |   7 +-
 drivers/pci/pcie/portdrv_core.c                    |   9 +-
 drivers/perf/arm_spe_pmu.c                         |  22 +-
 drivers/perf/riscv_pmu.c                           |   1 -
 drivers/perf/riscv_pmu_sbi.c                       |  21 +-
 drivers/phy/qualcomm/phy-qcom-qmp.h                |   3 +-
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c      |  10 +-
 drivers/phy/samsung/phy-exynosautov9-ufs.c         |  18 +-
 drivers/phy/st/phy-stm32-usbphyc.c                 |   4 +-
 drivers/phy/ti/phy-tusb1210.c                      |   5 +-
 drivers/platform/chrome/cros_ec.c                  |   8 +-
 drivers/platform/mellanox/mlxreg-lc.c              |  82 +-
 drivers/platform/olpc/olpc-ec.c                    |   2 +-
 drivers/platform/x86/pmc_atom.c                    |  19 +-
 drivers/powercap/dtpm_cpu.c                        |   5 +-
 drivers/pwm/pwm-lpc18xx-sct.c                      |  55 +-
 drivers/pwm/pwm-sifive.c                           |  61 +-
 drivers/regulator/of_regulator.c                   |   6 +-
 drivers/regulator/qcom_smd-regulator.c             |   4 +-
 drivers/remoteproc/imx_rproc.c                     |   7 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |   3 +
 drivers/remoteproc/qcom_sysmon.c                   |  10 +
 drivers/remoteproc/qcom_wcnss.c                    |  10 +-
 drivers/remoteproc/ti_k3_r5_remoteproc.c           |   2 +
 drivers/rpmsg/mtk_rpmsg.c                          |   2 +
 drivers/rpmsg/qcom_smd.c                           |   1 +
 drivers/rpmsg/rpmsg_char.c                         |   7 +-
 drivers/rpmsg/rpmsg_core.c                         |   1 +
 drivers/rtc/rtc-rx8025.c                           |  22 +-
 drivers/s390/char/zcore.c                          |  11 +-
 drivers/s390/cio/vfio_ccw_drv.c                    |  24 +-
 drivers/s390/cio/vfio_ccw_fsm.c                    |  26 +-
 drivers/s390/cio/vfio_ccw_ops.c                    |  10 +-
 drivers/s390/scsi/zfcp_fc.c                        |  29 +-
 drivers/s390/scsi/zfcp_fc.h                        |   6 +-
 drivers/s390/scsi/zfcp_fsf.c                       |   4 +-
 drivers/scsi/be2iscsi/be_main.c                    |   2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |   2 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |   2 +-
 drivers/scsi/iscsi_tcp.c                           |   4 +-
 drivers/scsi/libiscsi.c                            |   9 +-
 drivers/scsi/lpfc/lpfc.h                           |   1 -
 drivers/scsi/lpfc/lpfc_els.c                       |   8 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   3 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |   1 -
 drivers/scsi/qedi/qedi_main.c                      |   9 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |  24 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |  10 +-
 drivers/scsi/qla2xxx/qla_dbg.h                     |   2 +-
 drivers/scsi/qla2xxx/qla_def.h                     |  18 +-
 drivers/scsi/qla2xxx/qla_edif.c                    | 502 +++++++++---
 drivers/scsi/qla2xxx/qla_edif.h                    |   7 +-
 drivers/scsi/qla2xxx/qla_edif_bsg.h                | 106 ++-
 drivers/scsi/qla2xxx/qla_fw.h                      |   2 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |   6 +-
 drivers/scsi/qla2xxx/qla_gs.c                      | 129 +++-
 drivers/scsi/qla2xxx/qla_init.c                    |  93 ++-
 drivers/scsi/qla2xxx/qla_iocb.c                    |   5 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |  25 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |  19 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |   6 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   5 -
 drivers/scsi/qla2xxx/qla_os.c                      |  93 ++-
 drivers/scsi/qla2xxx/qla_target.c                  |  35 +-
 drivers/scsi/scsi_transport_iscsi.c                |  66 +-
 drivers/scsi/sd.c                                  |  84 +-
 drivers/scsi/sd.h                                  |   5 +
 drivers/scsi/sg.c                                  |  53 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |   4 +-
 drivers/soc/amlogic/meson-mx-socinfo.c             |   1 +
 drivers/soc/amlogic/meson-secure-pwrc.c            |   4 +-
 drivers/soc/fsl/guts.c                             |   2 +-
 drivers/soc/qcom/Kconfig                           |   1 +
 drivers/soc/qcom/ocmem.c                           |   3 +
 drivers/soc/qcom/qcom_aoss.c                       |   4 +-
 drivers/soc/qcom/socinfo.c                         |   3 +-
 drivers/soc/renesas/r8a779a0-sysc.c                |  10 +-
 drivers/soundwire/bus.c                            |  75 +-
 drivers/soundwire/bus_type.c                       |  38 +-
 drivers/soundwire/qcom.c                           |   4 +
 drivers/soundwire/slave.c                          |   3 +-
 drivers/soundwire/stream.c                         |  53 +-
 drivers/spi/spi-altera-dfl.c                       |  14 +-
 drivers/spi/spi-dw.h                               |   2 +-
 drivers/spi/spi-s3c64xx.c                          |   2 +-
 drivers/spi/spi-synquacer.c                        |   1 +
 drivers/spi/spi-tegra20-slink.c                    |   3 +-
 drivers/spi/spi.c                                  |  21 +-
 drivers/staging/fbtft/fbtft-core.c                 |   2 +-
 drivers/staging/media/atomisp/pci/atomisp_cmd.c    |  57 +-
 .../media/atomisp/pci/runtime/rmgr/src/rmgr_vbuf.c |   4 +-
 drivers/staging/media/hantro/hantro_g2_hevc_dec.c  |   7 +-
 drivers/staging/media/hantro/hantro_g2_regs.h      |   2 +-
 drivers/staging/media/hantro/hantro_hevc.c         |  25 +-
 drivers/staging/media/hantro/hantro_hw.h           |  17 +-
 drivers/staging/media/hantro/hantro_v4l2.c         |   2 +-
 drivers/staging/media/hantro/imx8m_vpu_hw.c        |  80 +-
 drivers/staging/media/hantro/rockchip_vpu_hw.c     | 164 ++--
 drivers/staging/media/hantro/sama5d4_vdec_hw.c     |  40 +-
 drivers/staging/media/hantro/sunxi_vpu_hw.c        |  24 +-
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c   |  36 +-
 drivers/staging/media/sunxi/cedrus/cedrus_regs.h   |   3 +-
 drivers/staging/rtl8192u/r8192U.h                  |   2 +-
 drivers/staging/rtl8192u/r8192U_dm.c               |  38 +-
 drivers/staging/rtl8192u/r8192U_dm.h               |   2 +-
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |   4 +-
 drivers/thermal/cpufreq_cooling.c                  |  13 +-
 drivers/thermal/devfreq_cooling.c                  |  19 +-
 drivers/thermal/thermal_sysfs.c                    |  10 +-
 drivers/tty/n_gsm.c                                | 757 ++++++++++++------
 drivers/tty/serial/8250/8250.h                     |  20 +
 drivers/tty/serial/8250/8250_bcm2835aux.c          |   6 +-
 drivers/tty/serial/8250/8250_bcm7271.c             |  24 +-
 drivers/tty/serial/8250/8250_core.c                |   3 +-
 drivers/tty/serial/8250/8250_dw.c                  |  10 +-
 drivers/tty/serial/8250/8250_fsl.c                 |   2 +-
 drivers/tty/serial/8250/8250_pci.c                 | 109 +++
 drivers/tty/serial/8250/8250_port.c                |  17 +-
 drivers/tty/serial/fsl_lpuart.c                    |  12 +-
 drivers/tty/serial/mvebu-uart.c                    |  11 +
 drivers/tty/serial/pic32_uart.c                    |   4 +-
 drivers/tty/serial/qcom_geni_serial.c              |  88 ++-
 drivers/tty/vt/vt.c                                |   2 +-
 drivers/ufs/core/ufshcd.c                          |   6 +-
 drivers/usb/cdns3/cdns3-gadget.c                   |  13 +-
 drivers/usb/core/hcd.c                             |  34 +-
 drivers/usb/dwc3/core.c                            |   9 +-
 drivers/usb/dwc3/dwc3-qcom.c                       |   4 +-
 drivers/usb/dwc3/gadget.c                          |  92 +--
 drivers/usb/gadget/function/f_mass_storage.c       |  11 +-
 drivers/usb/gadget/function/f_uvc.c                |  30 +-
 drivers/usb/gadget/function/uvc_queue.c            |   6 +-
 drivers/usb/gadget/function/uvc_video.c            |  12 +-
 drivers/usb/gadget/udc/Kconfig                     |   2 +-
 drivers/usb/gadget/udc/aspeed-vhub/hub.c           |   4 +-
 drivers/usb/gadget/udc/tegra-xudc.c                |   8 +-
 drivers/usb/host/ehci-ppc-of.c                     |   1 +
 drivers/usb/host/ohci-at91.c                       |  69 +-
 drivers/usb/host/ohci-nxp.c                        |   1 +
 drivers/usb/host/xhci-tegra.c                      |   8 +-
 drivers/usb/host/xhci.h                            |   2 +-
 drivers/usb/serial/sierra.c                        |   3 +-
 drivers/usb/serial/usb-serial.c                    |   2 +-
 drivers/usb/serial/usb_wwan.c                      |   3 +-
 drivers/usb/typec/ucsi/ucsi.c                      |   4 +
 drivers/usb/usbip/vudc_sysfs.c                     |  14 +-
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     |  11 +-
 drivers/vfio/pci/mlx5/cmd.c                        |  14 +-
 drivers/vfio/pci/mlx5/cmd.h                        |   4 +-
 drivers/vfio/pci/mlx5/main.c                       |  11 +-
 drivers/vfio/pci/vfio_pci_core.c                   |   7 +
 drivers/vfio/vfio.c                                |  11 +-
 drivers/video/fbdev/amba-clcd.c                    |  24 +-
 drivers/video/fbdev/arkfb.c                        |   9 +-
 drivers/video/fbdev/core/fbcon.c                   |  12 +-
 drivers/video/fbdev/offb.c                         |   1 +
 drivers/video/fbdev/s3fb.c                         |   2 +
 drivers/video/fbdev/sis/init.c                     |   4 +-
 drivers/video/fbdev/vt8623fb.c                     |   2 +
 drivers/virtio/Kconfig                             |   4 +
 drivers/virtio/Makefile                            |   1 +
 drivers/virtio/virtio.c                            |   4 +-
 drivers/virtio/virtio_anchor.c                     |  18 +
 drivers/watchdog/armada_37xx_wdt.c                 |   2 +
 drivers/watchdog/f71808e_wdt.c                     |   4 +-
 drivers/watchdog/sp5100_tco.c                      |   1 +
 drivers/xen/Kconfig                                |   9 +
 drivers/xen/grant-dma-ops.c                        |  10 +
 fs/Makefile                                        |   2 -
 fs/attr.c                                          |   2 +
 fs/btrfs/block-group.c                             |  29 +-
 fs/btrfs/ctree.h                                   |  34 +-
 fs/btrfs/delalloc-space.c                          |   6 +-
 fs/btrfs/disk-io.c                                 |  38 +-
 fs/btrfs/extent-tree.c                             |  71 +-
 fs/btrfs/extent_io.c                               |   4 +-
 fs/btrfs/file.c                                    |   2 +-
 fs/btrfs/inode.c                                   | 177 ++++-
 fs/btrfs/raid56.c                                  |  26 +-
 fs/btrfs/space-info.c                              | 108 ++-
 fs/btrfs/space-info.h                              |   8 +-
 fs/btrfs/tree-log.c                                |  27 +-
 fs/btrfs/tree-log.h                                |   3 +
 fs/btrfs/volumes.c                                 |  28 +-
 fs/btrfs/zoned.c                                   | 125 +++
 fs/btrfs/zoned.h                                   |  18 +
 fs/cifs/cifsglob.h                                 |   4 +-
 fs/cifs/file.c                                     |  34 +-
 fs/erofs/decompressor.c                            |  16 +-
 fs/erofs/decompressor_lzma.c                       |   1 +
 fs/erofs/dir.c                                     |  16 +-
 fs/eventpoll.c                                     |  22 +
 fs/exec.c                                          |   3 +
 fs/ext2/super.c                                    |  12 +-
 fs/ext4/ext4.h                                     |   1 +
 fs/ext4/inline.c                                   |  33 +
 fs/ext4/inode.c                                    |  24 +-
 fs/ext4/migrate.c                                  |   4 +-
 fs/ext4/namei.c                                    |  23 +
 fs/ext4/resize.c                                   |   1 +
 fs/ext4/symlink.c                                  |  15 +
 fs/ext4/xattr.c                                    | 168 ++--
 fs/ext4/xattr.h                                    |  14 +
 fs/f2fs/data.c                                     |   7 +-
 fs/f2fs/f2fs.h                                     |   2 +-
 fs/f2fs/file.c                                     |  19 +-
 fs/fuse/control.c                                  |   4 +-
 fs/fuse/dir.c                                      |   7 +-
 fs/fuse/file.c                                     |  39 +-
 fs/fuse/inode.c                                    |   6 +
 fs/fuse/ioctl.c                                    |  15 +-
 fs/jbd2/commit.c                                   |   2 +-
 fs/jbd2/transaction.c                              |  14 +-
 fs/kernfs/dir.c                                    |   7 +-
 fs/ksmbd/smb2misc.c                                |  12 +-
 fs/ksmbd/smb2pdu.c                                 |  52 +-
 fs/ksmbd/smbacl.c                                  | 130 +++-
 fs/ksmbd/smbacl.h                                  |   2 +-
 fs/ksmbd/vfs.c                                     |   5 +
 fs/lockd/svc4proc.c                                |   8 +
 fs/lockd/xdr4.c                                    |  19 +-
 fs/mbcache.c                                       |  76 +-
 fs/namei.c                                         |   4 +
 fs/nfs/flexfilelayout/flexfilelayout.c             |   4 +
 fs/nfs/nfs3client.c                                |   1 -
 fs/nfsd/filecache.c                                |  22 +-
 fs/nfsd/filecache.h                                |   4 +-
 fs/nfsd/trace.h                                    |   2 -
 fs/overlayfs/export.c                              |   2 +-
 fs/proc/base.c                                     |  46 +-
 fs/splice.c                                        |  10 +-
 include/acpi/cppc_acpi.h                           |   2 +-
 include/crypto/internal/blake2s.h                  | 108 ---
 include/dt-bindings/clock/qcom,gcc-msm8939.h       |   1 +
 include/linux/acpi_viot.h                          |   2 +
 include/linux/blkdev.h                             |   5 +
 include/linux/bpf.h                                |   1 -
 include/linux/buffer_head.h                        |  25 +-
 include/linux/cpumask.h                            |  18 +
 include/linux/device-mapper.h                      |   6 +
 include/linux/energy_model.h                       |  54 +-
 include/linux/filter.h                             |   9 +
 include/linux/highmem.h                            |  10 +
 include/linux/hugetlb.h                            |   6 +-
 include/linux/ieee80211.h                          |   3 +
 include/linux/iio/common/cros_ec_sensors_core.h    |   7 +-
 include/linux/iio/iio.h                            |  10 +-
 include/linux/kexec.h                              |  45 +-
 include/linux/kfifo.h                              |   2 +-
 include/linux/kvm_types.h                          |   2 +
 include/linux/lockd/xdr.h                          |   2 +
 include/linux/lockdep.h                            |  30 +-
 include/linux/mbcache.h                            |  10 +-
 include/linux/mdev.h                               |   5 -
 include/linux/mfd/t7l66xb.h                        |   1 -
 include/linux/once_lite.h                          |  20 +-
 include/linux/pipe_fs_i.h                          |   9 +
 include/linux/platform-feature.h                   |   6 +-
 include/linux/rmap.h                               |   4 +-
 include/linux/sched.h                              |   2 +-
 include/linux/sched/rt.h                           |   8 -
 include/linux/sched/topology.h                     |   1 +
 include/linux/soundwire/sdw.h                      |   6 +-
 include/linux/swapops.h                            |  12 +-
 include/linux/tpm_eventlog.h                       |   2 +-
 include/linux/trace_events.h                       |  18 +
 include/linux/usb/hcd.h                            |   1 +
 include/linux/vfio.h                               |  30 +-
 include/linux/virtio_anchor.h                      |  19 +
 include/linux/wait.h                               |   9 +-
 include/media/hevc-ctrls.h                         |   4 +-
 include/net/9p/client.h                            |   8 +-
 include/net/ax25.h                                 |   1 +
 include/net/bluetooth/hci.h                        |   1 +
 include/net/cfg80211.h                             |  99 ++-
 include/net/inet6_hashtables.h                     |   7 +-
 include/net/inet_hashtables.h                      |  19 +-
 include/net/inet_sock.h                            |  11 +
 include/net/ip_tunnels.h                           |   1 +
 include/net/mac80211.h                             |  40 +-
 include/net/netfilter/nf_tables.h                  |   9 +-
 include/net/pkt_sched.h                            |  17 +
 include/net/raw.h                                  |  16 +-
 include/net/rawv6.h                                |   7 +-
 include/net/sock.h                                 |  12 +-
 include/net/xdp_sock_drv.h                         |  11 +
 include/scsi/libiscsi.h                            |   2 +-
 include/scsi/scsi_transport_iscsi.h                |   1 +
 include/soc/mscc/ocelot.h                          |   6 +
 include/trace/events/io_uring.h                    |   2 +-
 include/trace/events/spmi.h                        |  12 +-
 include/trace/stages/stage1_struct_define.h        |   3 +
 include/trace/stages/stage2_data_offsets.h         |   3 +
 include/trace/stages/stage4_event_fields.h         |  11 +-
 include/trace/stages/stage5_get_offsets.h          |   4 +
 include/trace/stages/stage6_event_callback.h       |  12 +
 include/uapi/linux/can/error.h                     |   5 +-
 include/uapi/linux/dm-ioctl.h                      |   4 +-
 include/uapi/linux/netfilter/xt_IDLETIMER.h        |  17 +-
 include/uapi/linux/nl80211.h                       |  28 +
 include/xen/xen-ops.h                              |   9 +
 include/xen/xen.h                                  |   8 -
 init/main.c                                        |   1 +
 io_uring/Makefile                                  |   6 +
 {fs => io_uring}/io-wq.c                           |   0
 {fs => io_uring}/io-wq.h                           |   0
 {fs => io_uring}/io_uring.c                        | 844 +++++++++------------
 kernel/bpf/arraymap.c                              |  20 +-
 kernel/bpf/cgroup.c                                |  70 +-
 kernel/bpf/core.c                                  |  35 +-
 kernel/bpf/verifier.c                              |   7 +-
 kernel/cgroup/cpuset.c                             |   2 +-
 kernel/dma/swiotlb.c                               |   2 +-
 kernel/irq/Kconfig                                 |   1 +
 kernel/irq/chip.c                                  |   3 +-
 kernel/irq/irqdomain.c                             |   2 +
 kernel/kexec_file.c                                |  66 +-
 kernel/kprobes.c                                   |   3 +-
 kernel/locking/lockdep.c                           |   7 +-
 kernel/power/energy_model.c                        |  24 +-
 kernel/power/user.c                                |  13 +-
 kernel/profile.c                                   |   7 +
 kernel/rcu/rcutorture.c                            |  28 +-
 kernel/sched/core.c                                | 190 +++--
 kernel/sched/fair.c                                | 142 +++-
 kernel/sched/features.h                            |   3 +-
 kernel/sched/rt.c                                  |  15 +-
 kernel/sched/sched.h                               |   1 -
 kernel/smp.c                                       |   4 +-
 kernel/time/hrtimer.c                              |   1 +
 kernel/time/timekeeping.c                          |   7 +-
 kernel/trace/blktrace.c                            |   2 +-
 lib/bitmap.c                                       |   2 +-
 lib/crypto/blake2s-selftest.c                      |  41 +
 lib/crypto/blake2s.c                               |  37 +-
 lib/iov_iter.c                                     |  15 +-
 lib/kunit/executor.c                               |   4 +-
 lib/livepatch/test_klp_callbacks_busy.c            |   8 +
 lib/overflow_kunit.c                               |   6 +
 lib/smp_processor_id.c                             |   2 +-
 lib/test_bpf.c                                     |   4 +-
 lib/test_hmm.c                                     |  10 +-
 lib/test_kasan.c                                   |  10 +
 mm/damon/reclaim.c                                 |   4 +-
 mm/gup.c                                           |   2 +-
 mm/huge_memory.c                                   |  11 +-
 mm/hugetlb.c                                       |  15 +-
 mm/hugetlb_cgroup.c                                |   1 +
 mm/kasan/hw_tags.c                                 |  32 +-
 mm/memory-failure.c                                |   2 +-
 mm/memory_hotplug.c                                |   2 +-
 mm/mempolicy.c                                     |   4 +-
 mm/memremap.c                                      |   2 +-
 mm/migrate.c                                       |  30 +-
 mm/mmap.c                                          |   1 -
 mm/page_alloc.c                                    |   8 +-
 mm/percpu.c                                        |   6 +-
 mm/vmalloc.c                                       |  10 +-
 net/9p/client.c                                    |  36 +-
 net/9p/trans_fd.c                                  |  13 +-
 net/9p/trans_rdma.c                                |   2 +-
 net/9p/trans_virtio.c                              |   4 +-
 net/9p/trans_xen.c                                 |   2 +-
 net/ax25/af_ax25.c                                 |   4 +-
 net/batman-adv/trace.h                             |   9 +-
 net/bluetooth/hci_core.c                           |  10 +-
 net/bluetooth/hci_event.c                          |   5 +-
 net/bluetooth/hci_sync.c                           |   8 +-
 net/bluetooth/l2cap_core.c                         |  13 +-
 net/bluetooth/mgmt.c                               |  10 +-
 net/core/filter.c                                  |   3 +-
 net/core/skmsg.c                                   |   4 +-
 net/dccp/proto.c                                   |  10 +-
 net/ipv4/af_inet.c                                 |   2 +
 net/ipv4/ping.c                                    |  36 +-
 net/ipv4/raw.c                                     | 164 ++--
 net/ipv4/raw_diag.c                                |  53 +-
 net/ipv4/tcp.c                                     |  33 +-
 net/ipv4/tcp_output.c                              |  30 +-
 net/ipv6/af_inet6.c                                |   3 +
 net/ipv6/raw.c                                     | 120 ++-
 net/mac80211/airtime.c                             |   4 +-
 net/mac80211/cfg.c                                 |  48 +-
 net/mac80211/chan.c                                |  39 +-
 net/mac80211/driver-ops.h                          |   2 +-
 net/mac80211/ethtool.c                             |   4 +-
 net/mac80211/ibss.c                                |  10 +-
 net/mac80211/ieee80211_i.h                         |   6 +-
 net/mac80211/iface.c                               |   8 +-
 net/mac80211/key.c                                 |  18 +-
 net/mac80211/main.c                                |   4 +-
 net/mac80211/mesh.c                                |  14 +-
 net/mac80211/mlme.c                                |  44 +-
 net/mac80211/ocb.c                                 |   3 +-
 net/mac80211/offchannel.c                          |   6 +-
 net/mac80211/rate.c                                |   5 +-
 net/mac80211/rx.c                                  |   2 +-
 net/mac80211/sta_info.c                            |   4 +-
 net/mac80211/tdls.c                                |   6 +-
 net/mac80211/tx.c                                  |  28 +-
 net/mac80211/util.c                                |  16 +-
 net/mac80211/vht.c                                 |   6 +-
 net/mptcp/protocol.c                               |   3 +-
 net/netfilter/nf_tables_api.c                      | 100 +--
 net/netfilter/nft_bitwise.c                        |  66 +-
 net/netfilter/nft_cmp.c                            |  44 +-
 net/netfilter/nft_immediate.c                      |  22 +-
 net/netfilter/nft_range.c                          |  27 +-
 net/rose/af_rose.c                                 |  11 +-
 net/rose/rose_route.c                              |   2 +
 net/sched/cls_route.c                              |   2 +-
 net/wireless/ap.c                                  |  46 +-
 net/wireless/chan.c                                | 206 +++--
 net/wireless/core.c                                |  28 +-
 net/wireless/core.h                                |  13 +-
 net/wireless/ibss.c                                |  57 +-
 net/wireless/mesh.c                                |  31 +-
 net/wireless/mlme.c                                |  75 +-
 net/wireless/nl80211.c                             | 656 +++++++++++-----
 net/wireless/ocb.c                                 |   5 +-
 net/wireless/rdev-ops.h                            |  32 +-
 net/wireless/reg.c                                 | 139 ++--
 net/wireless/scan.c                                |   8 +-
 net/wireless/sme.c                                 | 102 +--
 net/wireless/trace.h                               |  86 ++-
 net/wireless/util.c                                |  44 +-
 net/wireless/wext-compat.c                         |  48 +-
 net/wireless/wext-sme.c                            |  29 +-
 samples/bpf/xdp_router_ipv4.bpf.c                  |   9 +
 scripts/faddr2line                                 |   4 +-
 scripts/gdb/linux/dmesg.py                         |   9 +-
 scripts/gdb/linux/utils.py                         |  14 +-
 security/selinux/ss/policydb.h                     |   2 +
 security/selinux/ss/services.c                     |   9 +-
 sound/pci/hda/patch_cirrus.c                       |   1 +
 sound/pci/hda/patch_conexant.c                     |  11 +-
 sound/pci/hda/patch_realtek.c                      | 124 +++
 sound/soc/amd/yc/acp6x-mach.c                      |  32 +-
 sound/soc/amd/yc/pci-acp6x.c                       |   2 +-
 sound/soc/atmel/mchp-spdifrx.c                     |   9 +-
 sound/soc/codecs/cros_ec_codec.c                   |   1 +
 sound/soc/codecs/cs35l45.c                         |   2 +
 sound/soc/codecs/da7210.c                          |   2 +
 sound/soc/codecs/max98390.c                        |   2 +-
 sound/soc/codecs/msm8916-wcd-digital.c             |  46 +-
 sound/soc/codecs/mt6359-accdet.c                   |   1 +
 sound/soc/codecs/mt6359.c                          |   1 +
 sound/soc/codecs/wcd9335.c                         |  81 +-
 sound/soc/codecs/wsa881x.c                         |  10 +-
 sound/soc/fsl/fsl-asoc-card.c                      |   5 +-
 sound/soc/fsl/fsl_asrc.c                           |   6 +-
 sound/soc/fsl/fsl_easrc.c                          |   9 +-
 sound/soc/fsl/fsl_easrc.h                          |   2 +-
 sound/soc/fsl/imx-audmux.c                         |   2 +-
 sound/soc/fsl/imx-card.c                           |  22 +-
 sound/soc/generic/audio-graph-card.c               |   4 +-
 sound/soc/generic/audio-graph-card2.c              |  44 +-
 sound/soc/intel/avs/path.c                         |  54 +-
 sound/soc/intel/boards/sof_rt5682.c                |  18 +-
 sound/soc/mediatek/mt6797/mt6797-mt6351.c          |   6 +-
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c   |  10 +-
 sound/soc/mediatek/mt8173/mt8173-rt5650.c          |   9 +-
 sound/soc/qcom/lpass-cpu.c                         |   1 +
 sound/soc/qcom/qdsp6/q6adm.c                       |   2 +-
 sound/soc/samsung/aries_wm8994.c                   |   6 +-
 sound/soc/samsung/h1940_uda1380.c                  |   2 +-
 sound/soc/samsung/rx1950_uda1380.c                 |   4 +-
 sound/soc/soc-core.c                               |  18 +-
 sound/soc/sof/ipc3-topology.c                      |   1 +
 sound/soc/sof/mediatek/mt8195/mt8195-loader.c      |   2 +-
 sound/soc/sof/sof-client-ipc-msg-injector.c        |  29 +-
 sound/soc/sof/sof-priv.h                           |   4 +-
 sound/usb/bcd2000/bcd2000.c                        |   3 +-
 sound/usb/quirks.c                                 |   2 +
 tools/lib/bpf/bpf_tracing.h                        |   2 +-
 tools/lib/bpf/gen_loader.c                         |   2 +-
 tools/lib/bpf/libbpf.c                             | 154 ++--
 tools/lib/bpf/libbpf_internal.h                    |  11 +-
 tools/lib/bpf/linker.c                             |   5 -
 tools/lib/bpf/usdt.c                               | 123 +--
 tools/lib/bpf/xsk.c                                |   9 +-
 tools/perf/builtin-stat.c                          |  30 -
 tools/perf/tests/shell/stat+csv_output.sh          |   7 +-
 tools/perf/util/dsos.c                             |  15 +-
 tools/perf/util/genelf.c                           |   6 +-
 tools/perf/util/symbol-elf.c                       |  27 +-
 tools/power/x86/intel-speed-select/isst-daemon.c   |   2 +-
 tools/power/x86/turbostat/turbostat.c              |   2 +-
 tools/testing/selftests/bpf/Makefile               |  21 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |   2 +-
 .../selftests/bpf/prog_tests/fexit_stress.c        |  32 +-
 .../testing/selftests/bpf/prog_tests/sock_fields.c |   1 -
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |   8 +-
 tools/testing/selftests/bpf/progs/test_tc_dtime.c  |  53 +-
 .../selftests/kvm/lib/s390x/diag318_test_handler.c |   9 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   2 +-
 .../testing/selftests/kvm/max_guest_memory_test.c  |  26 +-
 tools/testing/selftests/net/fib_rule_tests.sh      |  23 +
 tools/testing/selftests/powerpc/math/mma.S         |   3 +
 .../selftests/powerpc/papr_attributes/attr_test.c  |  30 +-
 tools/testing/selftests/rcutorture/bin/kvm.sh      |   6 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |   2 +-
 .../testing/selftests/timers/clocksource-switch.c  |   6 +-
 tools/testing/selftests/timers/valid-adjtimex.c    |   2 +-
 tools/testing/selftests/vm/hugepage-mremap.c       |   2 +-
 tools/testing/selftests/vm/hugetlb-madvise.c       |   5 +-
 tools/testing/selftests/vm/mrelease_test.c         |  16 +-
 .../selftests/wireguard/qemu/arch/riscv32.config   |   1 +
 tools/thermal/tmon/sysfs.c                         |  24 +-
 tools/thermal/tmon/tmon.h                          |   3 +
 tools/tracing/rtla/Makefile                        |   2 +-
 tools/tracing/rtla/src/trace.c                     |   9 +-
 tools/tracing/rtla/src/utils.c                     |   5 +-
 virt/kvm/kvm_main.c                                |  25 +-
 virt/kvm/pfncache.c                                | 207 +++--
 1281 files changed, 15085 insertions(+), 9103 deletions(-)


