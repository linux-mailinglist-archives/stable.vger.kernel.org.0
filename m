Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F05595CA0
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 15:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbiHPNAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 09:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbiHPM7m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 08:59:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2233EAF0C1;
        Tue, 16 Aug 2022 05:59:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA12F61341;
        Tue, 16 Aug 2022 12:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B75C433D6;
        Tue, 16 Aug 2022 12:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660654754;
        bh=61yu56Rv23TLemZ5Io28mmRoiLhTQQwQ+SpoOtPzeBE=;
        h=From:To:Cc:Subject:Date:From;
        b=PAmByEBzKkqww+mShoPCXzlnddPAyC87LbP2P2qLblhU4Mhjou+hHAYanLA0NOhkc
         jApTKRmtIic2F6MDLsThaTOkhLDX+qO+Z+XTESdOgJ64cwTl5NWcCsowcyPtXer5WL
         vcCq3u7F7G1911y+1C4B37UJJLMzXPOuj1LefYpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 000/778] 5.15.61-rc2 review
Date:   Tue, 16 Aug 2022 14:59:11 +0200
Message-Id: <20220816124544.577833376@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.61-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.61-rc2
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

This is the start of the stable review cycle for the 5.15.61 release.
There are 778 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 18 Aug 2022 12:43:40 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.61-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.61-rc2

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Resolve some cleanup issues following SLI path refactoring

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix element offset in __lpfc_sli_release_iocbq_s4()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix locking for lpfc_sli_iocbq_lookup()

Maxime Ripard <maxime@cerno.tech>
    drm/bridge: Move devm_drm_of_get_bridge to bridge/panel.c

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression

Jose Alonso <joalonsof@gmail.com>
    Revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP"

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: mem-account pbuf buckets

Miaoqian Lin <linmq006@gmail.com>
    drm/meson: Fix refcount leak in meson_encoder_hdmi_init

Rob Clark <robdclark@chromium.org>
    drm/msm: Fix dirtyfb refcounting

Kees Cook <keescook@chromium.org>
    tracing/perf: Avoid -Warray-bounds warning for __rel_loc macro

Tom Rix <trix@redhat.com>
    drm/vc4: change vc4_dma_range_matches from a global to static

Lukas Wunner <lukas@wunner.de>
    net: phy: smsc: Disable Energy Detect Power-Down in interrupt mode

Marek Vasut <marex@denx.de>
    drm/bridge: tc358767: Fix (e)DP bridge endpoint parsing in dedicated function

Alexander Gordeev <agordeev@linux.ibm.com>
    Revert "s390/smp: enforce lowcore protection on CPU restart"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv"

Jason A. Donenfeld <Jason@zx2c4.com>
    crypto: lib/blake2s - reduce stack frame usage in self test

Eric Dumazet <edumazet@google.com>
    tcp: fix over estimation in sk_forced_mem_schedule()

Ahmed Zaki <anzaki@gmail.com>
    mac80211: fix a memory leak where sta_info is not freed

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    net_sched: cls_route: remove from list when handle is 0

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Use a struct alignof to determine trace event field alignment

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc: Fix eh field when calling lwarx on PPC32

SeongJae Park <sj@kernel.org>
    xen-blkfront: Apply 'feature_persistent' parameter when connect

Maximilian Heyne <mheyne@amazon.de>
    xen-blkback: Apply 'feature_persistent' parameter when connect

SeongJae Park <sj@kernel.org>
    xen-blkback: fix persistent grants negotiation

Huacai Chen <chenhuacai@kernel.org>
    tpm: eventlog: Fix section mismatch for DEBUG_SECTION_MISMATCH

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    KEYS: asymmetric: enforce SM2 signature use pkey algo

Jan Kara <jack@suse.cz>
    ext4: fix race when reusing xattr blocks

Jan Kara <jack@suse.cz>
    ext4: unindent codeblock in ext4_xattr_block_set()

Shuqi Zhang <zhangshuqi3@huawei.com>
    ext4: use kmemdup() to replace kmalloc + memcpy

Jan Kara <jack@suse.cz>
    ext4: remove EA inode entry from mbcache on inode eviction

Lukas Czerner <lczerner@redhat.com>
    ext4: make sure ext4_append() always allocates new block

Lukas Czerner <lczerner@redhat.com>
    ext4: check if directory block is within i_size

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

Masami Hiramatsu <mhiramat@kernel.org>
    tracing: Avoid -Warray-bounds warning for __rel_loc macro

Masami Hiramatsu <mhiramat@kernel.org>
    tracing: Add '__rel_loc' using trace event macros

Mikulas Patocka <mpatocka@redhat.com>
    dm raid: fix address sanitizer warning in raid_resume

Mikulas Patocka <mpatocka@redhat.com>
    dm raid: fix address sanitizer warning in raid_status

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Attempt to load PERF_GLOBAL_CTRL on nVMX xfer iff it exists

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Add helper to check if the guest PMU has PERF_GLOBAL_CTRL

Like Xu <likexu@tencent.com>
    KVM: x86/pmu: Ignore pmu->global_ctrl check if vPMU doesn't support global_ctrl

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Mark all PERF_GLOBAL_(OVF)_CTRL bits reserved if there's no vPMU

Like Xu <like.xu@linux.intel.com>
    KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter

Jason A. Donenfeld <Jason@zx2c4.com>
    powerpc/powernv/kvm: Use darn for H_RANDOM on Power9

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: CPPC: Do not prevent CPPC from working in the future

Nikolay Borisov <nborisov@suse.com>
    btrfs: properly flag filesystem with BTRFS_FEATURE_INCOMPAT_BIG_METADATA

Josef Bacik <josef@toxicpanda.com>
    btrfs: reset block group chunk force if we have to wait

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: ensure pages are unlocked on cow_file_range() failure

Jinke Han <hanjinke.666@bytedance.com>
    block: don't allow the same type rq_qos add more than once

Christoph Hellwig <hch@lst.de>
    block: remove the struct blk_queue_ctx forward declaration

Chen Zhongjin <chenzhongjin@huawei.com>
    locking/csd_lock: Change csdlock_debug from early_param to __setup

Jason A. Donenfeld <Jason@zx2c4.com>
    timekeeping: contribute wall clock to rng on time change

Ard Biesheuvel <ardb@kernel.org>
    ARM: remove some dead code

Tyler Hicks <tyhicks@linux.microsoft.com>
    net/9p: Initialize the iounit field during fid creation

Luo Meng <luomeng12@huawei.com>
    dm thin: fix use-after-free crash in dm_sm_register_threshold_callback

Michal Suchanek <msuchanek@suse.de>
    kexec, KEYS, s390: Make use of built-in and secondary keyring for signature verification

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: set a default MAX_WRITEBACK_JOBS

Cameron Williams <cang1@live.co.uk>
    tty: 8250: Add support for Brainboxes PX cards.

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Add proper clock handling for OxSemi PCIe devices

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Fold EndRun device support into OxSemi Tornado code

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_pci: Replace dev_*() by pci_*() macros

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_pci: Refactor the loop in pci_ite887x_init()

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

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Remove extra atomic_inc on cmd_pending in queuecommand after VMID

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: SLI path split: Refactor SCSI paths

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: SLI path split: Refactor fast and slow paths to native SLI4

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: SLI path split: Refactor lpfc_iocbq

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix EEH support for NVMe I/O

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scpi: Ensure scpi_info is not assigned if the probe fails

Lukas Wunner <lukas@wunner.de>
    usbnet: smsc95xx: Fix deadlock on runtime resume

Lukas Wunner <lukas@wunner.de>
    usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid polling

Lukas Wunner <lukas@wunner.de>
    usbnet: smsc95xx: Avoid link settings race on interrupt reception

Lukas Wunner <lukas@wunner.de>
    usbnet: smsc95xx: Don't clear read-only PHY interrupt

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: drv: Adopt the dma configuration from the HVS or V3D component

Imre Deak <imre.deak@intel.com>
    drm/dp/mst: Read the extended DPCD capabilities during system resume

Jason A. Donenfeld <Jason@zx2c4.com>
    crypto: blake2s - remove shash module

Jitao Shi <jitao.shi@mediatek.com>
    drm/mediatek: Keep dsi as LP00 before dcs cmds transfer

Julien STEPHAN <jstephan@baylibre.com>
    drm/mediatek: Allow commands to be sent during video mode

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

Sungjong Seo <sj1557.seo@samsung.com>
    f2fs: allow compression for mmap files in compress_mode=user

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

Dietmar Eggemann <dietmar.eggemann@arm.com>
    sched/deadline: Merge dl_task_can_attach() and dl_cpu_busy()

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

Chao Liu <liuchao@coolpad.com>
    f2fs: fix to remove F2FS_COMPR_FL and tag F2FS_NOCOMP_FL at the same time

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/smp: enforce lowcore protection on CPU restart

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/maccess: rework absolute lowcore accessors

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/smp: cleanup control register update routines

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/smp: cleanup target CPU callback starting

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/dump: fix os_info virtual vs physical address confusion

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: correct the count of break characters

Pali Rohár <pali@kernel.org>
    powerpc/pci: Prefer PCI domain assignment via DT 'linux,pci-domain' and alias

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/iommu: Fix iommu_table_in_use for a small default DMA window case

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Do not allow selection of e5500 or e6500 CPUs on PPC32

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Call mmu_mark_initmem_nx() regardless of data block mapping.

Claudiu Beznea <claudiu.beznea@microchip.com>
    ASoC: mchp-spdifrx: disable end of block interrupt on failures

Rustam Subkhankulov <subkhankulov@ispras.ru>
    video: fbdev: sis: fix typos in SiS_GetModeID()

Liang He <windhl@126.com>
    video: fbdev: amba-clcd: Fix refcount leak bugs

William Dean <williamsukatube@gmail.com>
    watchdog: armada_37xx_wdt: check the return value of devm_ioremap() in armada_37xx_wdt_probe()

Jean Delvare <jdelvare@suse.de>
    watchdog: sp5100_tco: Fix a memory leak of EFCH MMIO resource

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

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/zcore: fix race when reading from hardware system area

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/crash: fix incorrect number of bytes to copy to user space

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/maccess: fix semantics of memcpy_real() and its callers

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/dump: fix old lowcore virtual vs physical address confusion

Adrian Hunter <adrian.hunter@intel.com>
    perf tools: Fix dso_id inode generation comparison

Liang He <windhl@126.com>
    iommu/arm-smmu: qcom_iommu: Add of_node_put() when breaking out of loop

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

Dominique Martinet <asmadeus@codewreck.org>
    9p: fix a bunch of checkpatch warnings

Sam Protsenko <semen.protsenko@linaro.org>
    iommu/exynos: Handle failed IOMMU device registration properly

Doug Berger <opendmb@gmail.com>
    serial: 8250_bcm7271: Save/restore RTS in suspend/resume

Liang He <windhl@126.com>
    ASoC: mt6359: Fix refcount leak bug

Robin Murphy <robin.murphy@arm.com>
    swiotlb: fail map correctly with failed io_tlb_default_mem

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: vdso: Utilize __pa() for gic_pfn

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix missing corner cases in gsmld_poll()

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix DM command

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong T1 retry count handling

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    serial: 8250_fsl: Don't report FE, PE and OE twice

Eric Farman <farman@linux.ibm.com>
    vfio/ccw: Do not change FSM state in subchannel event

Sireesh Kodali <sireeshkodali1@gmail.com>
    remoteproc: qcom: wcnss: Fix handling of IRQs

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: imx-card: Fix DSD/PDM mclk frequency

Liang He <windhl@126.com>
    ASoC: qcom: Fix missing of_node_put() in asoc_qcom_lpass_cpu_platform_probe()

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix resource allocation order in gsm_activate_mux()

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

Zhenguo Zhao <Zhenguo.Zhao1@unisoc.com>
    tty: n_gsm: Delete gsmtty open SABM frame when config requester

Tom Rix <trix@redhat.com>
    ASoC: samsung: change gpiod_speaker_power and rx1950_audio from global to static variables

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Optimize clearing the pending PMI and remove WARN_ON for PMI check in power_pmu_disable

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: samsung: h1940_uda1380: include proepr GPIO consumer header

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

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd9335: move gains from SX_TLV to S8_TLV

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: msm8916-wcd-digital: move gains from SX_TLV to S8_TLV

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dw: Store LSR into lsr_saved_flags in dw8250_tx_wait_empty()

Miquel Raynal <miquel.raynal@bootlin.com>
    serial: 8250: dma: Allow driver operations before starting DMA transfers

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Export ICR access helpers for internal use

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mediatek: mt8173-rt5650: Fix refcount leak in mt8173_rt5650_dev_probe

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: codecs: da7210: add check for i2c_add_driver

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mt6797-mt6351: Fix refcount leak in mt6797_mt6351_dev_probe

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

Christoph Hellwig <hch@lst.de>
    nvme: don't return an error from nvme_configure_metadata

Keith Busch <kbusch@kernel.org>
    nvme: disable namespace access for unsupported metadata

Nick Bowler <nbowler@draconx.ca>
    nvme: define compat_ioctl again to unbreak 32-bit userspace.

Bean Huo <beanhuo@micron.com>
    nvme: use command_id instead of req->tag in trace_nvme_complete_rq()

Dan Carpenter <dan.carpenter@oracle.com>
    null_blk: fix ida error handling in null_add_dev()

Md Haris Iqbal <haris.iqbal@ionos.com>
    block/rnbd-srv: Set keep_id to true after mutex_trylock

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix error unwind in rxe_create_qp()

Xiao Yang <yangx.jy@fujitsu.com>
    RDMA/rxe: Remove the is_user members of struct rxe_sq/rxe_rq/rxe_srq

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Add memory barriers to kernel queues

Maor Gottlieb <maorg@nvidia.com>
    RDMA/mlx5: Add missing check for return value in get namespace flow

Xu Qiang <xuqiang36@huawei.com>
    of/fdt: declared return type does not match actual return type

Andrei Vagin <avagin@google.com>
    selftests: kvm: set rax before vmcall

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

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Set UMIP bit CR4_FIXED1 MSR when emulating UMIP

Patrice Chotard <patrice.chotard@foss.st.com>
    mtd: spi-nor: fix spi_nor_spimem_setup_op() call in spi_nor_erase_{sector,chip}()

Andrey Strachuk <strochuk@ispras.ru>
    usb: cdns3: change place of 'priv_ep' assignment in cdns3_gadget_ep_dequeue(), cdns3_gadget_ep_enable()

Johan Hovold <johan@kernel.org>
    USB: serial: fix tty-port initialized comments

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Handle condition of "no sensors"

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Fix link up retry sequence

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Fix Root Port interrupt handling

Md Haris Iqbal <haris.phnx@gmail.com>
    RDMA/rxe: For invalidate compare according to set keys in mr

Artem Borisov <dedsa2002@gmail.com>
    HID: alps: Declare U1_UNICORN_LEGACY support

Liang He <windhl@126.com>
    mmc: cavium-thunderx: Add of_node_put() when breaking out of loop

Liang He <windhl@126.com>
    mmc: cavium-octeon: Add of_node_put() when breaking out of loop

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix mw bind to allow any consumer key portion

Antonio Borneo <antonio.borneo@foss.st.com>
    scripts/gdb: fix 'lx-dmesg' on 32 bits arch

John Ogness <john.ogness@linutronix.de>
    scripts/gdb: lx-dmesg: read records individually

Fabio Estevam <festevam@denx.de>
    dmaengine: imx-dma: Cast of_device_get_match_data() with (uintptr_t)

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Add NULL check for hid device

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    HID: mcp2221: prevent a buffer overflow in mcp_smbus_write()

Liang He <windhl@126.com>
    gpio: gpiolib-of: Fix refcount bugs in of_mm_gpiochip_add_data()

Jianglei Nie <niejianglei2021@163.com>
    RDMA/hfi1: fix potential memory leak in setup_base_ctxt()

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    clk: qcom: gcc-msm8939: Fix weird field spacing in ftbl_gcc_camss_cci_clk

Gwendal Grignou <gwendal@chromium.org>
    iio: cros: Register FIFO callback after sensor is registered

Cheng Xu <chengyou@linux.alibaba.com>
    RDMA/siw: Fix duplicated reported IW_CM_EVENT_CONNECT_REPLY event

Haoyue Xu <xuhaoyue1@hisilicon.com>
    RDMA/hns: Fix incorrect clearing of interrupt status register

Jianglei Nie <niejianglei2021@163.com>
    RDMA/qedr: Fix potential memory leak in __qedr_alloc_mr()

Md Haris Iqbal <haris.iqbal@ionos.com>
    RDMA/rtrs-clt: Replace list_next_or_null_rr_rcu with an inline function

Vaishali Thakkar <vaishali.thakkar@ionos.com>
    RDMA/rtrs-clt: Rename rtrs_clt_sess to rtrs_clt_path

Vaishali Thakkar <vaishali.thakkar@ionos.com>
    RDMA/rtrs-srv: Rename rtrs_srv_sess to rtrs_srv_path

Vaishali Thakkar <vaishali.thakkar@ionos.com>
    RDMA/rtrs: Rename rtrs_sess to rtrs_path

Md Haris Iqbal <haris.iqbal@ionos.com>
    RDMA/rtrs: Do not allow sessname to contain special symbols / and .

Md Haris Iqbal <haris.iqbal@ionos.com>
    RDMA/rtrs: Introduce destroy_cq helper

Jack Wang <jinpu.wang@ionos.com>
    RDMA/rtrs: Replace duplicate check with is_pollqueue helper

Jack Wang <jinpu.wang@ionos.com>
    RDMA/rtrs: Fix warning when use poll mode on client side.

Jack Wang <jinpu.wang@ionos.com>
    RDMA/rtrs-srv: Fix modinfo output for stringify

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Fix setting of QP context err_rq_idx_valid field

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Fix VLAN connection with wildcard address

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Fix a window for use-after-free

Christopher Obbard <chris.obbard@collabora.com>
    um: random: Don't initialise hwrng struct with zero

Peng Fan <peng.fan@nxp.com>
    interconnect: imx: fix max_node_id

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

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: qla2xxx: Check correct variable in qla24xx_async_gffid()

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

Tianyu Li <tianyu.li@arm.com>
    mm/mempolicy: fix get_nodes out of bound access

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

Ansuel Smith <ansuelsmth@gmail.com>
    clk: qcom: clk-krait: unlock spin after mux completion

Zhang Wensheng <zhangwensheng5@huawei.com>
    driver core: fix potential deadlock in __driver_attach

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    misc: rtsx: Fix an error handling path in rtsx_pci_probe()

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    clk: qcom: camcc-sm8250: Fix halt on boot by reducing driver's init level

Mark Brown <broonie@kernel.org>
    mtd: dataflash: Add SPI ID table

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

Jonas Dreßler <verdre@v0yd.nl>
    mwifiex: Ignore BTCOEX events from the 88W8897 firmware

Sean Christopherson <seanjc@google.com>
    KVM: Don't set Accessed/Dirty bits for ZERO_PAGE

Miaohe Lin <linmiaohe@huawei.com>
    mm/memremap: fix memunmap_pages() race with get_dev_pagemap()

Christoph Hellwig <hch@lst.de>
    memremap: remove support for external pgmap refcounts

Miaohe Lin <linmiaohe@huawei.com>
    lib/test_hmm: avoid accessing uninitialized pages

Rex-BC Chen <rex-bc.chen@mediatek.com>
    clk: mediatek: reset: Fix written reset bit offset

Jagath Jog J <jagathjog1996@gmail.com>
    iio: accel: bma400: Reordering of header files

Stephen Boyd <swboyd@chromium.org>
    platform/chrome: cros_ec: Always expose last resume result

Jagath Jog J <jagathjog1996@gmail.com>
    iio: accel: bma400: Fix the scale min and max macro values

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

Tang Bin <tangbin@cmss.chinamobile.com>
    usb: xhci: tegra: Fix error check

Tang Bin <tangbin@cmss.chinamobile.com>
    usb: gadget: tegra-xudc: Fix error check in tegra_xudc_powerdomain_init()

Miaoqian Lin <linmq006@gmail.com>
    usb: ohci-nxp: Fix refcount leak in ohci_hcd_nxp_probe

Miaoqian Lin <linmq006@gmail.com>
    usb: host: Fix refcount leak in ehci_hcd_ppc_of_probe

Marco Pagani <marpagan@redhat.com>
    fpga: altera-pr-ip: fix unsigned comparison with less than zero

Miaoqian Lin <linmq006@gmail.com>
    PCI: mediatek-gen3: Fix refcount leak in mtk_pcie_init_irq_domains()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mtd: st_spi_fsm: Add a clk_disable_unprepare() in .probe()'s error path

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
    scsi: qla2xxx: edif: Fix inconsistent check of db_flags

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Reduce connection thrash

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Fix potential stuck session in sa update

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Reduce Initiator-Initiator thrashing

Vaibhav Jain <vaibhav@linux.ibm.com>
    of: check previous kernel's ima-kexec-buffer against memory bounds

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

Maciej Żenczykowski <maze@google.com>
    net: usb: make USB_RTL8153_ECM non user configurable

Hangyu Hua <hbh25y@gmail.com>
    dccp: put dccp_qpolicy_full() and dccp_qpolicy_push() in the same lock

Jian Shen <shenjian15@huawei.com>
    net: ionic: fix error check for vlan flags in ionic_set_nic_features()

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

Eric Dumazet <edumazet@google.com>
    ipv6: add READ_ONCE(sk->sk_bound_dev_if) in INET6_MATCH()

Eric Dumazet <edumazet@google.com>
    inet: add READ_ONCE(sk->sk_bound_dev_if) in INET_MATCH()

Kai Ye <yekai13@huawei.com>
    crypto: hisilicon/sec - fix auth key size error

Pali Rohár <pali@kernel.org>
    crypto: inside-secure - Add missing MODULE_DEVICE_TABLE for of

Zhengchao Shao <shaozhengchao@huawei.com>
    crypto: hisilicon/hpre - don't use GFP_KERNEL to alloc mem during softirq

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Adjust log_max_qp to be 18 at most

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Fix the value of MLX5E_MAX_RQ_NUM_MTTS

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Remove WARN_ON when trying to offload an unsupported TLS cipher/version

Jernej Skrabec <jernej.skrabec@gmail.com>
    media: cedrus: hevc: Add check for invalid timestamp

Hangyu Hua <hbh25y@gmail.com>
    wifi: libertas: Fix possible refcount leak in if_usb_probe()

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    wifi: iwlwifi: mvm: fix double list_add at iwl_mvm_mac_wake_tx_queue

Ammar Faizi <ammarfaizi2@gnuweeb.org>
    wifi: wil6210: debugfs: fix uninitialized variable use in `wil_write_file_wmi()`

Liang He <windhl@126.com>
    i2c: mux-gpmux: Add of_node_put() when breaking out of loop

Lars-Peter Clausen <lars@metafoo.de>
    i2c: cadence: Support PEC for SMBus block read

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    Bluetooth: hci_intel: Add check for platform_driver_register

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: pch_can: pch_can_error(): initialize errc before using it

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

Rustam Subkhankulov <subkhankulov@ispras.ru>
    wifi: p54: add missing parentheses in p54_flush()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    wifi: p54: Fix an error handling path in p54spi_probe()

Dan Carpenter <dan.carpenter@oracle.com>
    wifi: wil6210: debugfs: fix info leak in wil_write_file_wmi()

Sebastian Fricke <sebastian.fricke@collabora.com>
    media: staging: media: hantro: Fix typos

Benjamin Gaignard <benjamin.gaignard@collabora.com>
    media: hevc: Embedded indexes in RPS

Ezequiel Garcia <ezequiel@collabora.com>
    media: hantro: Simplify postprocessor

Ezequiel Garcia <ezequiel@collabora.com>
    media: hantro: postproc: Fix motion vector space size

Jernej Skrabec <jernej.skrabec@gmail.com>
    media: cedrus: h265: Fix flag name

Jason A. Donenfeld <Jason@zx2c4.com>
    fs: check FMODE_LSEEK to control internal pipe splicing

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix subprog names in stack traces.

Wolfram Sang <wsa+renesas@sang-engineering.com>
    selftests: timers: clocksource-switch: fix passing errors from child

Wolfram Sang <wsa+renesas@sang-engineering.com>
    selftests: timers: valid-adjtimex: build fix for newer toolchains

Anquan Wu <leiqi96@hotmail.com>
    libbpf: Fix the name of a reused map

Yonglong Li <liyonglong@chinatelecom.cn>
    tcp: make retransmitted SKB fit into the send window

Jian Zhang <zhangjian210@huawei.com>
    drm/exynos/exynos7_drm_decon: free resources when clk_set_parent() failed.

Liu Jian <liujian56@huawei.com>
    skmsg: Fix invalid last sg check in sk_msg_recvmsg()

Liang He <windhl@126.com>
    mediatek: mt76: eeprom: fix missing of_node_put() in mt76_find_power_limits_node()

Liang He <windhl@126.com>
    mediatek: mt76: mac80211: Fix missing of_node_put() in mt76_led_init()

Deren Wu <deren.wu@mediatek.com>
    mt76: mt7921: enlarge maximum VHT MPDU length to 11454

Deren Wu <deren.wu@mediatek.com>
    mt76: mt7921: fix aggregation subframes setting to HE max

Mordechay Goodstein <mordechay.goodstein@intel.com>
    ieee80211: add EHT 1K aggregation definitions

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: do not update pm stats in case of error

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt76x02u: fix possible memory leak in __mt76x02u_mcu_send_msg

Rob Clark <robdclark@chromium.org>
    drm/msm/dpu: Fix for non-visible planes

Rob Clark <robdclark@chromium.org>
    drm/msm: Avoid dirtyfb stalls on video mode displays (v2)

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    media: platform: mtk-mdp: Fix mdp_ipi_comm structure alignment

Zhengchao Shao <shaozhengchao@huawei.com>
    crypto: hisilicon - Kunpeng916 crypto driver don't sleep when in softirq

Zhengchao Shao <shaozhengchao@huawei.com>
    crypto: hisilicon/sec - don't sleep when in softirq

Rob Clark <robdclark@chromium.org>
    drm/msm/mdp5: Fix global state lock backoff

Qiao Ma <mqaio@linux.alibaba.com>
    net: hinic: avoid kernel hung in hinic_get_stats64()

Qiao Ma <mqaio@linux.alibaba.com>
    net: hinic: fix bug that ethtool get wrong stats

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    hinic: Use the bitmap API when applicable

Hangyu Hua <hbh25y@gmail.com>
    drm: bridge: sii8620: fix possible off-by-one

Guillaume Ranquet <granquet@baylibre.com>
    drm/mediatek: dpi: Only enable dpi after the bridge is enabled

Bo-Chen Chen <rex-bc.chen@mediatek.com>
    drm/mediatek: dpi: Remove output format of YUV

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/rockchip: Fix an error handling path rockchip_dp_probe()

Brian Norris <briannorris@chromium.org>
    drm/rockchip: vop: Don't crash for invalid duplicate_state()

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    selftests/xsk: Destroy BPF resources only when ctx refcount drops to 0

Qian Cai <quic_qiancai@quicinc.com>
    crypto: arm64/gcm - Select AEAD for GHASH_ARM64_CE

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hdmi: Correct HDMI timing registers for interlaced modes

Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>
    drm/vc4: hdmi: Fix timings for interlaced modes

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hdmi: Reset HDMI MISC_CONTROL register

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: Avoid full hdmi audio fifo writes

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Fix HPD GPIO detection

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

Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
    drm/vc4: Use of_device_get_match_data()

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: dsi: Switch to devm_drm_of_get_bridge

Maxime Ripard <maxime@cerno.tech>
    drm/bridge: Add a function to abstract away panels

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: plane: Fix margin calculations for the right/bottom edges

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: plane: Remove subpixel positioning check

Miaoqian Lin <linmq006@gmail.com>
    media: tw686x: Fix memory leak in tw686x_video_init

Jian Zhang <zhangjian210@huawei.com>
    media: driver/nxp/imx-jpeg: fix a unexpected return value problem

Ming Qian <ming.qian@nxp.com>
    media: v4l2-mem2mem: prevent pollerr when last_buffer_dequeued is set

Niels Dossche <dossche.niels@gmail.com>
    media: hdpvr: fix error value returns in hdpvr_read

Miaoqian Lin <linmq006@gmail.com>
    drm/mcde: Fix refcount leak in mcde_dsi_bind

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Disable slot interrupt when frame done

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm: bridge: adv7511: Add check for mipi_dsi_driver_register

Tom Lendacky <thomas.lendacky@amd.com>
    crypto: ccp - During shutdown, check SEV data pointer before using

Jian Shen <shenjian15@huawei.com>
    test_bpf: fix incorrect netdev features

Frederic Weisbecker <frederic@kernel.org>
    rcutorture: Fix ksoftirqd boosting timing and iteration

Paul E. McKenney <paulmck@kernel.org>
    rcutorture: Don't cpuhp_remove_state() if cpuhp_setup_state() failed

Paul E. McKenney <paulmck@kernel.org>
    rcutorture: Warn on individual rcu_torture_init() error conditions

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix incorrrect SPDX-License-Identifiers

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    wifi: iwlegacy: 4965: fix potential off-by-one overflow in il4965_rs_fill_link_cmd()

Pavel Skripkin <paskripkin@gmail.com>
    ath9k: fix use-after-free in ath9k_hif_usb_rx_cb

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Implement drain using v4l2-mem2mem helpers

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Align upwards buffer size

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Support dynamic resolution change

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Handle source change in a function

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Identify and handle precision correctly

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Refactor function mxc_jpeg_parse

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Set V4L2_BUF_FLAG_LAST at eos

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: use NV12M to represent non contiguous NV12

Mirela Rabulea <mirela.rabulea@oss.nxp.com>
    media: imx-jpeg: Add pm-runtime support for imx-jpeg

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Leave a blank space before the configuration data

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Correct some definition according specification

Zheyu Ma <zheyuma97@gmail.com>
    media: tw686x: Register the irq at the end of probe

Eugen Hristev <eugen.hristev@microchip.com>
    media: atmel: atmel-sama7g5-isc: fix warning in configs without OF

Alexey Khoroshilov <khoroshilov@ispras.ru>
    crypto: sun8i-ss - fix infinite loop in sun8i_ss_setup_ivs()

Xu Wang <vulab@iscas.ac.cn>
    i2c: Fix a potential use after free

Marc Kleine-Budde <mkl@pengutronix.de>
    can: netlink: allow configuring of fixed data bit rates without need for do_set_data_bittiming callback

Marc Kleine-Budde <mkl@pengutronix.de>
    can: netlink: allow configuring of fixed bit rates without need for do_set_bittiming callback

Eric Dumazet <edumazet@google.com>
    net: fix sk_wmem_schedule() and sk_rmem_schedule() errors

Dan Carpenter <dan.carpenter@oracle.com>
    crypto: sun8i-ss - fix error codes in allocate_flows()

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun8i-ss - do not allocate memory when handling hash requests

Antonio Borneo <antonio.borneo@foss.st.com>
    drm: adv7511: override i2c address of cec before accessing it

Miaoqian Lin <linmq006@gmail.com>
    drm/virtio: Fix NULL vs IS_ERR checking in virtio_gpu_object_shmem_init

Thomas Zimmermann <tzimmermann@suse.de>
    drm/shmem-helper: Pass GEM shmem object in public interfaces

Thomas Zimmermann <tzimmermann@suse.de>
    drm/shmem-helper: Export dedicated wrappers for GEM object functions

Thomas Zimmermann <tzimmermann@suse.de>
    drm/shmem-helper: Unexport drm_gem_shmem_create_with_handle()

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    virtio-gpu: fix a missing check to avoid NULL dereference

Fabio Estevam <festevam@gmail.com>
    i2c: mxs: Silence a clang warning

Tali Perry <tali.perry1@gmail.com>
    i2c: npcm: Correct slave role behavior

Tali Perry <tali.perry1@gmail.com>
    i2c: npcm: Remove own slave addresses 2:10

Bjorn Andersson <bjorn.andersson@linaro.org>
    drm/bridge: lt9611uxc: Cancel only driver's work

Miaoqian Lin <linmq006@gmail.com>
    drm/meson: encoder_hdmi: Fix refcount leak in meson_encoder_hdmi_init

Neil Armstrong <narmstrong@baylibre.com>
    drm/meson: encoder_hdmi: switch to bridge DRM_BRIDGE_ATTACH_NO_CONNECTOR

Xinlei Lee <xinlei.lee@mediatek.com>
    drm/mediatek: Add pull-down MIPI operation in mtk_dsi_poweroff function

Jitao Shi <jitao.shi@mediatek.com>
    drm/mediatek: Separate poweron/poweroff from enable/disable and define new funcs

Xinlei Lee <xinlei.lee@mediatek.com>
    drm/mediatek: Modify dsi funcs to atomic operations

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    drm/radeon: fix potential buffer overflow in ni_set_mc_special_registers()

Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
    ath11k: Fix incorrect debug_mask mappings

Yunhao Tian <t123yh.xyz@gmail.com>
    drm/mipi-dbi: align max_chunk to 2 in spi_transfer

Johan Hovold <johan+linaro@kernel.org>
    ath11k: fix netdev open race

Dan Carpenter <dan.carpenter@oracle.com>
    wifi: rtlwifi: fix error codes in rtl_debugfs_set_write_h2c()

Gao Chao <gaochao49@huawei.com>
    drm/panel: Fix build error when CONFIG_DRM_PANEL_SAMSUNG_ATNA33XC20=y && CONFIG_DRM_DISPLAY_HELPER=m

Javier Martinez Canillas <javierm@redhat.com>
    drm/st7735r: Fix module autoloading for Okaya RH128128T

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ath10k: do not enforce interrupt trigger type

Marek Vasut <marex@denx.de>
    drm/bridge: tc358767: Move (e)DP bridge endpoint parsing into dedicated function

Douglas Anderson <dianders@chromium.org>
    drm/dp: Export symbol / kerneldoc fixes for DP AUX bus

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: lpc18xx: Fix period handling

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: lpc18xx-sct: Simplify driver by not using pwm_[gs]et_chip_data()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: lpc18xx-sct: Reduce number of devm memory allocations

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sifive: Shut down hardware only after pwmchip_remove() completed

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sifive: Ensure the clk is enabled exactly once per running PWM

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sifive: Simplify offset calculation for PWMCMP registers

Mike Snitzer <snitzer@kernel.org>
    dm: return early from dm_pr_call() if DM device is suspended

Markus Mayer <mmayer@broadcom.com>
    thermal/tools/tmon: Include pthread and time headers in tmon.h

YiFei Zhu <zhuyifei@google.com>
    selftests/seccomp: Fix compile warning when CC=clang

Peter Zijlstra <peterz@infradead.org>
    x86/extable: Fix ex_handler_msr() print condition

Nicolas Saenz Julienne <nsaenzju@redhat.com>
    nohz/full, sched/rt: Fix missed tick-reenabling bug in dequeue_task_rt()

Anshuman Khandual <anshuman.khandual@arm.com>
    drivers/perf: arm_spe: Fix consistency of SYS_PMSCR_EL1.CX

Xu Qiang <xuqiang36@huawei.com>
    irqdomain: Report irq number for NOMAP domains

Sumit Garg <sumit.garg@linaro.org>
    arm64: dts: qcom: qcs404: Fix incorrect USB2 PHYs assignment

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

Yang Yingliang <yangyingliang@huawei.com>
    spi: tegra20-slink: fix UAF in tegra_slink_remove()

Yang Yingliang <yangyingliang@huawei.com>
    spi: Fix simplification of devm_spi_register_controller

Ming Lei <ming.lei@redhat.com>
    blk-mq: don't create hctx debugfs dir until q->debugfs_dir is created

Gao Xiang <hsiangkao@linux.alibaba.com>
    erofs: avoid consecutive detection for Highmem memory

Tamás Szűcs <tszucs@protonmail.ch>
    arm64: tegra: Fix SDMMC1 CD on P2888

Mikko Perttunen <mperttunen@nvidia.com>
    arm64: tegra: Mark BPMP channels as no-memory-wc

Mikko Perttunen <mperttunen@nvidia.com>
    arm64: tegra: Update Tegra234 BPMP channel addresses

Thierry Reding <treding@nvidia.com>
    arm64: tegra: Fixup SYSRAM references

Nick Hainke <vincent@systemli.org>
    arm64: dts: mt7622: fix BPI-R64 WPS button

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sm8250: add missing PCIe PHY clock-cells

Marijn Suijten <marijn.suijten@somainline.org>
    arm64: dts: qcom: sm6125: Append -state suffix to pinctrl nodes

Marijn Suijten <marijn.suijten@somainline.org>
    arm64: dts: qcom: sm6125: Move sdc2 pinctrl from seine-pdx201 to sm6125

Eric Auger <eric.auger@redhat.com>
    ACPI: VIOT: Fix ACS setup

Len Baker <len.baker@gmx.com>
    drivers/iio: Remove all strcpy() uses

Shuai Xue <xueshuai@linux.alibaba.com>
    ACPI: APEI: explicit init of HEST and GHES in apci_init()

Sireesh Kodali <sireeshkodali1@gmail.com>
    arm64: dts: qcom: msm8916: Fix typo in pronto remoteproc node

GONG, Ruiqi <gongruiqi1@huawei.com>
    stack: Declare {randomize_,}kstack_offset to fix Sparse warnings

Yang Yingliang <yangyingliang@huawei.com>
    bus: hisi_lpc: fix missing platform_device_put() in hisi_lpc_acpi_probe()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: qcom: pm8841: add required thermal-sensor-cells

Miaoqian Lin <linmq006@gmail.com>
    soc: qcom: aoss: Fix refcount leak in qmp_cooling_devices_register

Miaoqian Lin <linmq006@gmail.com>
    soc: qcom: ocmem: Fix refcount leak in of_get_ocmem

Luca Weiss <luca@z3ntu.xyz>
    ARM: dts: qcom-msm8974: fix irq type on blsp2_uart1

Dan Williams <dan.j.williams@intel.com>
    ACPI: APEI: Fix _EINJ vs EFI_MEMORY_SP

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    regulator: qcom_smd: Fix pm8916_pldo range

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

Keith Busch <kbusch@kernel.org>
    block: fix infinite loop for invalid zone append

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

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: Fix thermal-sensors on single-zone sensors

Liang He <windhl@126.com>
    soc: amlogic: Fix refcount leak in meson-secure-pwrc.c

Puranjay Mohan <puranjay12@gmail.com>
    dt-bindings: iio: accel: Add DT binding doc for ADXL355

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: hisi_sas: Use managed PCI functions

Geert Uytterhoeven <geert+renesas@glider.be>
    soc: renesas: r8a779a0-sysc: Fix A2DP1 and A2CV[2357] PDR values

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

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: findbit: fix overflowing offset

Biju Das <biju.das.jz@bp.renesas.com>
    spi: spi-rspi: Fix PIO fallback on RZ platforms

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Disable stack variable initialisation for prom_init

xinhui pan <xinhui.pan@amd.com>
    drm/amdgpu: Remove one duplicated ef removal

Kees Cook <keescook@chromium.org>
    kasan: test: Silence GCC 12 warnings

Xiu Jianfeng <xiujianfeng@huawei.com>
    selinux: Add boundary check in put_entry()

Xiu Jianfeng <xiujianfeng@huawei.com>
    selinux: fix memleak in security_read_state_kernel()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    PM: hibernate: defer device probing when resuming from hibernation

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    hwmon: (sht15) Fix wrong assumptions in device remove callback

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

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: ux500: Fix Gavini accelerometer mounting matrix

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: ux500: Fix Codina accelerometer mounting matrix

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

Juri Lelli <juri.lelli@redhat.com>
    wait: Fix __wait_event_hrtimeout for RT/DL tasks

William Dean <williamsukatube@163.com>
    irqchip/mips-gic: Check the return value of ioremap() in gic_of_init()

John Keeping <john@metanate.com>
    sched/core: Always flush pending blk_plug

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

Catalin Marinas <catalin.marinas@arm.com>
    arm64: kasan: Revert "arm64: mte: reset the page tag in page->flags"

haibinzhang (张海斌) <haibinzhang@tencent.com>
    arm64: fix oops in concurrently setting insn_emulation sysctls

Francis Laniel <flaniel@linux.microsoft.com>
    arm64: Do not forget syscall when starting a new thread.

Mark Rutland <mark.rutland@arm.com>
    arch: make TRACE_IRQFLAGS_NMI_SUPPORT generic

Wyes Karny <wyes.karny@amd.com>
    x86: Handle idle=nomwait cmdline properly for x86_idle

Benjamin Segall <bsegall@google.com>
    epoll: autoremove wakers even more aggressively

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix null deref due to zeroed list head

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

Pali Rohár <pali@kernel.org>
    PCI: Add defines for normal and subtractive PCI bridges

Alexander Lobakin <alexandr.lobakin@intel.com>
    ia64, processor: fix -Wincompatible-pointer-types in ia64_get_irr()

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    media: [PATCH] pci: atomisp_cmd: fix three missing checks on list iterator

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
    fuse: ioctl: translate ENOSYS

Miklos Szeredi <mszeredi@redhat.com>
    fuse: limit nsec

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free bug in smb2_tree_disconect

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

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix check in fbdev init

Leo Li <sunpeng.li@amd.com>
    drm/amdgpu: Check BO's requested pinning domains against its preferred_domains

Lyude Paul <lyude@redhat.com>
    drm/nouveau/kms: Fix failure path for creating DP connectors

Lyude Paul <lyude@redhat.com>
    drm/nouveau/acpi: Don't print error when we get -EINPROGRESS from pm_runtime

Lyude Paul <lyude@redhat.com>
    drm/nouveau: Don't pm_runtime_put_sync(), only pm_runtime_put_autosuspend()

Timur Tabi <ttabi@nvidia.com>
    drm/nouveau: fix another off-by-one in nvbios_addr

Thomas Zimmermann <tzimmermann@suse.de>
    drm/hyperv-drm: Include framebuffer and EDID headers

Phil Elwell <phil@raspberrypi.org>
    drm/vc4: hdmi: Disable audio if dmas property is present but empty

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/shmem-helper: Add missing vunmap on error

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/gem: Properly annotate WW context on drm_gem_lock_reservations() error

Mathew McBride <matt@traverse.com.au>
    rtc: rx8025: fix 12/24 hour mode detection on RX-8035

Xianting Tian <xianting.tian@linux.alibaba.com>
    RISC-V: Add modules to virtual kernel memory layout dump

Xianting Tian <xianting.tian@linux.alibaba.com>
    RISC-V: Fixup schedule out issue in machine_crash_shutdown()

Xianting Tian <xianting.tian@linux.alibaba.com>
    RISC-V: Fixup get incorrect user mode PC for kernel mode regs

Xianting Tian <xianting.tian@linux.alibaba.com>
    RISC-V: kexec: Fixup use of smp_processor_id() in preemptible context

Conor Dooley <conor.dooley@microchip.com>
    dt-bindings: riscv: fix SiFive l2-cache's cache-sets

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

Bedant Patnaik <bedant.patnaik@gmail.com>
    ALSA: hda/realtek: Add a quirk for HP OMEN 15 (8786) mute LED

Meng Tang <tangmeng@uniontech.com>
    ALSA: hda/realtek: Add quirk for another Asus K42JZ model

Allen Ballway <ballway@chromium.org>
    ALSA: hda/cirrus - support for iMac 12,1 model

Meng Tang <tangmeng@uniontech.com>
    ALSA: hda/conexant: Add quirk for LENOVO 20149 Notebook model

Dimitri John Ledkov <dimitri.ledkov@canonical.com>
    riscv: set default pm_power_off to NULL

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: revalidate steal time cache if MSR value changes

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: do not report preemption if the steal time cache is stale

Sean Christopherson <seanjc@google.com>
    KVM: x86: Tag kvm_mmu_x86_module_init() with __init

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: nVMX: Always enable TSC scaling for L2 when it was enabled for L1

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

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up the show_nf_flags() macro

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

 Documentation/ABI/testing/sysfs-driver-xen-blkback |    2 +-
 .../ABI/testing/sysfs-driver-xen-blkfront          |    2 +-
 .../admin-guide/device-mapper/writecache.rst       |   16 +-
 Documentation/admin-guide/kernel-parameters.txt    |   29 +-
 Documentation/admin-guide/pm/cpuidle.rst           |   15 +-
 .../devicetree/bindings/iio/accel/adi,adxl355.yaml |   88 ++
 .../devicetree/bindings/riscv/sifive-l2-cache.yaml |    6 +-
 .../tty/device_drivers/oxsemi-tornado.rst          |  129 +++
 .../userspace-api/media/v4l/ext-ctrls-codec.rst    |    6 +-
 Makefile                                           |    9 +-
 arch/Kconfig                                       |    3 +
 arch/arm/boot/dts/Makefile                         |    1 +
 arch/arm/boot/dts/aspeed-ast2500-evb.dts           |    2 +-
 arch/arm/boot/dts/aspeed-ast2600-evb-a1.dts        |    1 +
 arch/arm/boot/dts/aspeed-ast2600-evb.dts           |    2 +-
 arch/arm/boot/dts/bcm53015-meraki-mr26.dts         |  166 +++
 arch/arm/boot/dts/imx6ul.dtsi                      |   33 +-
 arch/arm/boot/dts/imx7d-colibri-emmc.dtsi          |    4 +
 arch/arm/boot/dts/qcom-mdm9615.dtsi                |    1 +
 arch/arm/boot/dts/qcom-msm8974.dtsi                |    2 +-
 arch/arm/boot/dts/qcom-pm8841.dtsi                 |    1 +
 arch/arm/boot/dts/qcom-sdx55.dtsi                  |    2 +-
 arch/arm/boot/dts/ste-ux500-samsung-codina.dts     |    4 +-
 arch/arm/boot/dts/ste-ux500-samsung-gavini.dts     |    4 +-
 arch/arm/boot/dts/uniphier-pxs2.dtsi               |    8 +-
 arch/arm/crypto/Kconfig                            |    2 +-
 arch/arm/crypto/Makefile                           |    4 +-
 arch/arm/crypto/blake2s-shash.c                    |   75 --
 arch/arm/include/asm/entry-macro-multi.S           |   24 -
 arch/arm/include/asm/smp.h                         |    5 -
 arch/arm/kernel/smp.c                              |    5 -
 arch/arm/lib/findbit.S                             |   16 +-
 arch/arm/mach-bcm/bcm_kona_smc.c                   |    1 +
 arch/arm/mach-omap2/display.c                      |    3 +
 arch/arm/mach-omap2/pdata-quirks.c                 |    2 +
 arch/arm/mach-omap2/prm3xxx.c                      |    1 +
 arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c |    5 +-
 arch/arm/mach-zynq/common.c                        |    1 +
 arch/arm64/Kconfig                                 |    1 +
 .../boot/dts/allwinner/sun50i-a64-orangepi-win.dts |    2 +-
 .../boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts  |    2 +-
 arch/arm64/boot/dts/mediatek/mt8192.dtsi           |   26 +-
 arch/arm64/boot/dts/nvidia/tegra186.dtsi           |    3 +-
 arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi     |    2 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           |    3 +-
 arch/arm64/boot/dts/nvidia/tegra234.dtsi           |   17 +-
 arch/arm64/boot/dts/qcom/ipq8074.dtsi              |    2 +-
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |    4 +-
 arch/arm64/boot/dts/qcom/qcs404.dtsi               |    4 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi       |    1 +
 arch/arm64/boot/dts/qcom/sdm630.dtsi               |    7 +-
 .../dts/qcom/sdm636-sony-xperia-ganges-mermaid.dts |    2 +-
 .../dts/qcom/sm6125-sony-xperia-seine-pdx201.dts   |   36 +-
 arch/arm64/boot/dts/qcom/sm6125.dtsi               |   30 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |    6 +
 .../boot/dts/renesas/beacon-renesom-baseboard.dtsi |    6 +-
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi          |    2 +-
 arch/arm64/boot/dts/renesas/r8a77990.dtsi          |    2 +-
 arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi   |    8 +-
 arch/arm64/crypto/Kconfig                          |    1 +
 arch/arm64/include/asm/processor.h                 |    3 +-
 arch/arm64/kernel/armv8_deprecated.c               |    9 +-
 arch/arm64/kernel/cpufeature.c                     |    2 +-
 arch/arm64/kernel/hibernate.c                      |    5 -
 arch/arm64/kernel/mte.c                            |    9 -
 arch/arm64/kvm/hyp/nvhe/switch.c                   |    2 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |    2 +-
 arch/arm64/mm/copypage.c                           |    9 -
 arch/arm64/mm/mteswap.c                            |    9 -
 arch/ia64/include/asm/processor.h                  |    2 +-
 arch/mips/kernel/proc.c                            |    2 +-
 arch/mips/kernel/vdso.c                            |    2 +-
 arch/mips/mm/physaddr.c                            |   14 +-
 arch/parisc/kernel/cache.c                         |    3 -
 arch/parisc/kernel/drivers.c                       |    9 +-
 arch/parisc/kernel/syscalls/syscall.tbl            |    2 +-
 arch/powerpc/include/asm/archrandom.h              |    5 -
 arch/powerpc/include/asm/simple_spinlock.h         |   15 +-
 arch/powerpc/kernel/Makefile                       |    1 +
 arch/powerpc/kernel/iommu.c                        |    5 +
 arch/powerpc/kernel/pci-common.c                   |   29 +-
 arch/powerpc/kvm/book3s_hv_builtin.c               |    7 +-
 arch/powerpc/mm/nohash/8xx.c                       |    4 +-
 arch/powerpc/mm/pgtable_32.c                       |    6 +-
 arch/powerpc/mm/ptdump/shared.c                    |    6 +-
 arch/powerpc/perf/core-book3s.c                    |   35 +-
 arch/powerpc/platforms/Kconfig.cputype             |    4 +-
 arch/powerpc/platforms/cell/axon_msi.c             |    1 +
 arch/powerpc/platforms/cell/spufs/inode.c          |    1 +
 arch/powerpc/platforms/powernv/rng.c               |   34 +-
 arch/powerpc/sysdev/fsl_pci.c                      |    8 +
 arch/powerpc/sysdev/fsl_pci.h                      |    1 +
 arch/powerpc/sysdev/xive/spapr.c                   |    1 +
 arch/riscv/kernel/crash_save_regs.S                |    2 +-
 arch/riscv/kernel/machine_kexec.c                  |   28 +-
 arch/riscv/kernel/probes/uprobes.c                 |    6 -
 arch/riscv/kernel/reset.c                          |   12 +-
 arch/riscv/mm/init.c                               |    4 +
 arch/s390/include/asm/ctl_reg.h                    |   16 +-
 arch/s390/include/asm/gmap.h                       |    2 +
 arch/s390/include/asm/os_info.h                    |    2 +-
 arch/s390/include/asm/processor.h                  |   19 +-
 arch/s390/include/asm/uaccess.h                    |    2 +-
 arch/s390/kernel/asm-offsets.c                     |    2 +
 arch/s390/kernel/crash_dump.c                      |   58 +-
 arch/s390/kernel/ipl.c                             |    4 +-
 arch/s390/kernel/machine_kexec.c                   |    2 +-
 arch/s390/kernel/machine_kexec_file.c              |   18 +-
 arch/s390/kernel/os_info.c                         |   12 +-
 arch/s390/kernel/setup.c                           |   19 +-
 arch/s390/kernel/smp.c                             |   57 +-
 arch/s390/kvm/intercept.c                          |   15 +
 arch/s390/kvm/pv.c                                 |    9 +-
 arch/s390/kvm/sigp.c                               |    4 +-
 arch/s390/mm/gmap.c                                |   86 ++
 arch/s390/mm/maccess.c                             |    4 +-
 arch/um/drivers/random.c                           |    2 +-
 arch/um/include/asm/archrandom.h                   |   30 +
 arch/um/include/asm/xor.h                          |    2 +-
 arch/um/include/shared/os.h                        |    7 +
 arch/um/kernel/um_arch.c                           |    8 +
 arch/um/os-Linux/util.c                            |    6 +
 arch/x86/Kconfig                                   |    1 +
 arch/x86/Kconfig.debug                             |    3 -
 arch/x86/boot/Makefile                             |    2 +-
 arch/x86/boot/compressed/Makefile                  |    4 +
 arch/x86/crypto/Makefile                           |    4 +-
 arch/x86/crypto/blake2s-glue.c                     |    3 +-
 arch/x86/crypto/blake2s-shash.c                    |   77 --
 arch/x86/entry/Makefile                            |    3 +-
 arch/x86/entry/thunk_32.S                          |    2 -
 arch/x86/entry/thunk_64.S                          |    4 -
 arch/x86/entry/vdso/Makefile                       |    2 +-
 arch/x86/include/asm/kvm_host.h                    |    3 +-
 arch/x86/kernel/cpu/bugs.c                         |   10 +-
 arch/x86/kernel/cpu/intel.c                        |   27 +-
 arch/x86/kernel/ftrace.c                           |    1 +
 arch/x86/kernel/kprobes/core.c                     |   18 +-
 arch/x86/kernel/pmem.c                             |    7 +-
 arch/x86/kernel/process.c                          |    9 +-
 arch/x86/kvm/emulate.c                             |   23 +-
 arch/x86/kvm/mmu/mmu.c                             |    2 +-
 arch/x86/kvm/svm/nested.c                          |    3 +-
 arch/x86/kvm/svm/svm.c                             |   29 +-
 arch/x86/kvm/vmx/nested.c                          |  107 +-
 arch/x86/kvm/vmx/nested.h                          |    3 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   13 +-
 arch/x86/kvm/vmx/vmx.c                             |    4 +-
 arch/x86/kvm/vmx/vmx.h                             |   12 +
 arch/x86/kvm/x86.c                                 |   31 +-
 arch/x86/kvm/x86.h                                 |    2 +-
 arch/x86/mm/extable.c                              |   16 +-
 arch/x86/mm/numa.c                                 |    4 +-
 arch/x86/platform/olpc/olpc-xo1-sci.c              |    2 +-
 arch/x86/um/Makefile                               |    3 +-
 arch/xtensa/platforms/iss/network.c                |   42 +-
 block/bio.c                                        |   99 +-
 block/blk-iocost.c                                 |   20 +-
 block/blk-iolatency.c                              |   18 +-
 block/blk-mq-debugfs.c                             |    3 +
 block/blk-rq-qos.h                                 |   11 +-
 block/blk-wbt.c                                    |   12 +-
 crypto/Kconfig                                     |   20 +-
 crypto/Makefile                                    |    1 -
 crypto/asymmetric_keys/public_key.c                |    7 +-
 crypto/blake2s_generic.c                           |   75 --
 crypto/tcrypt.c                                    |   12 -
 crypto/testmgr.c                                   |   24 -
 crypto/testmgr.h                                   |  217 ----
 drivers/acpi/acpi_lpss.c                           |    3 +
 drivers/acpi/apei/einj.c                           |    2 +
 drivers/acpi/apei/ghes.c                           |   19 +-
 drivers/acpi/bus.c                                 |    3 +
 drivers/acpi/cppc_acpi.c                           |   54 +-
 drivers/acpi/ec.c                                  |   82 +-
 drivers/acpi/pci_root.c                            |    3 -
 drivers/acpi/processor_idle.c                      |    6 +-
 drivers/acpi/sleep.c                               |    8 +
 drivers/acpi/viot.c                                |   26 +-
 drivers/android/binder.c                           |  114 ++-
 drivers/android/binder_alloc.c                     |   30 +-
 drivers/android/binder_alloc.h                     |    2 +-
 drivers/android/binder_alloc_selftest.c            |    2 +-
 drivers/android/binder_internal.h                  |   46 +-
 drivers/android/binderfs.c                         |   47 +-
 drivers/base/dd.c                                  |    5 +-
 drivers/base/power/domain.c                        |    3 +
 drivers/block/null_blk/main.c                      |   14 +-
 drivers/block/rnbd/rnbd-srv.c                      |   15 +-
 drivers/block/xen-blkback/xenbus.c                 |   20 +-
 drivers/block/xen-blkfront.c                       |    4 +-
 drivers/bluetooth/hci_intel.c                      |    6 +-
 drivers/bus/hisi_lpc.c                             |   10 +-
 drivers/clk/mediatek/reset.c                       |    4 +-
 drivers/clk/qcom/camcc-sdm845.c                    |    4 +
 drivers/clk/qcom/camcc-sm8250.c                    |   16 +-
 drivers/clk/qcom/clk-krait.c                       |    7 +-
 drivers/clk/qcom/clk-rcg2.c                        |   16 +-
 drivers/clk/qcom/gcc-ipq8074.c                     |   60 +-
 drivers/clk/qcom/gcc-msm8939.c                     |   33 +-
 drivers/clk/renesas/r9a06g032-clocks.c             |    8 +-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |    1 +
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |   22 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c  |   15 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h       |    4 +
 drivers/crypto/ccp/sev-dev.c                       |   12 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |    2 +-
 drivers/crypto/hisilicon/sec/sec_algs.c            |   14 +-
 drivers/crypto/hisilicon/sec/sec_drv.h             |    2 +-
 drivers/crypto/hisilicon/sec2/sec.h                |    2 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |   26 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.h         |    1 +
 drivers/crypto/inside-secure/safexcel.c            |    2 +
 drivers/dma/dw-edma/dw-edma-core.c                 |    2 +-
 drivers/dma/imx-dma.c                              |    2 +-
 drivers/dma/sf-pdma/sf-pdma.c                      |   44 +-
 drivers/firmware/Kconfig                           |    1 +
 drivers/firmware/arm_scpi.c                        |   61 +-
 drivers/firmware/arm_sdei.c                        |   13 +-
 drivers/firmware/tegra/bpmp-debugfs.c              |   10 +-
 drivers/fpga/altera-pr-ip-core.c                   |    2 +-
 drivers/gpio/gpiolib-of.c                          |    4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |    6 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c             |    3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |    4 +
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |   24 +-
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c         |    2 +-
 drivers/gpu/drm/bridge/panel.c                     |   37 +
 drivers/gpu/drm/bridge/sil-sii8620.c               |    4 +-
 drivers/gpu/drm/bridge/tc358767.c                  |   30 +-
 drivers/gpu/drm/drm_bridge.c                       |    7 +-
 drivers/gpu/drm/drm_dp_aux_bus.c                   |    4 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |    7 +-
 drivers/gpu/drm/drm_gem.c                          |    4 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c             |  132 +--
 drivers/gpu/drm/drm_mipi_dbi.c                     |    7 +
 drivers/gpu/drm/drm_of.c                           |    3 +
 drivers/gpu/drm/exynos/exynos7_drm_decon.c         |   17 +-
 drivers/gpu/drm/hyperv/hyperv_drm_modeset.c        |    2 +
 drivers/gpu/drm/lima/lima_gem.c                    |   18 +-
 drivers/gpu/drm/lima/lima_sched.c                  |    4 +-
 drivers/gpu/drm/mcde/mcde_dsi.c                    |    1 +
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |   33 +-
 drivers/gpu/drm/mediatek/mtk_dsi.c                 |  126 ++-
 drivers/gpu/drm/meson/Kconfig                      |    2 +
 drivers/gpu/drm/meson/meson_dw_hdmi.c              |    1 +
 drivers/gpu/drm/meson/meson_encoder_hdmi.c         |   96 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c           |   26 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c          |    5 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.h          |    3 +
 drivers/gpu/drm/msm/disp/mdp4/mdp4_plane.c         |   19 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c          |    8 +
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.h           |    5 +
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c          |    3 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c         |   21 +-
 drivers/gpu/drm/msm/msm_atomic.c                   |   15 -
 drivers/gpu/drm/msm/msm_drv.h                      |    6 +-
 drivers/gpu/drm/msm/msm_fb.c                       |   43 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |    8 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |    4 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |    2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c    |    2 +-
 drivers/gpu/drm/panel/Kconfig                      |    2 +
 drivers/gpu/drm/panfrost/panfrost_drv.c            |    2 +-
 drivers/gpu/drm/panfrost/panfrost_gem.c            |   20 +-
 drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c   |    2 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |    5 +-
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c        |    6 +-
 drivers/gpu/drm/radeon/.gitignore                  |    2 +-
 drivers/gpu/drm/radeon/Kconfig                     |    2 +-
 drivers/gpu/drm/radeon/Makefile                    |    2 +-
 drivers/gpu/drm/radeon/ni_dpm.c                    |    6 +-
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c    |   10 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |    3 +
 drivers/gpu/drm/tiny/st7735r.c                     |    1 +
 drivers/gpu/drm/v3d/v3d_bo.c                       |   22 +-
 drivers/gpu/drm/vc4/vc4_crtc.c                     |   10 +-
 drivers/gpu/drm/vc4/vc4_drv.c                      |   19 +
 drivers/gpu/drm/vc4/vc4_dsi.c                      |  187 ++--
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   40 +-
 drivers/gpu/drm/vc4/vc4_hdmi_regs.h                |    3 +
 drivers/gpu/drm/vc4/vc4_plane.c                    |   30 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |    6 +-
 drivers/gpu/drm/virtio/virtgpu_object.c            |   31 +-
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |    2 +
 drivers/hid/amd-sfh-hid/amd_sfh_hid.c              |   12 +-
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c             |    3 +-
 drivers/hid/hid-alps.c                             |    2 +
 drivers/hid/hid-cp2112.c                           |    5 +
 drivers/hid/hid-ids.h                              |    1 +
 drivers/hid/hid-input.c                            |    2 +
 drivers/hid/hid-mcp2221.c                          |    3 +
 drivers/hid/wacom_sys.c                            |    2 +-
 drivers/hid/wacom_wac.c                            |   72 +-
 drivers/hwmon/dell-smm-hwmon.c                     |    8 +
 drivers/hwmon/drivetemp.c                          |    1 +
 drivers/hwmon/sht15.c                              |   17 +-
 drivers/hwtracing/coresight/coresight-core.c       |    1 +
 drivers/hwtracing/intel_th/msu-sink.c              |    3 +
 drivers/hwtracing/intel_th/msu.c                   |   14 +-
 drivers/hwtracing/intel_th/pci.c                   |   25 +-
 drivers/i2c/busses/i2c-cadence.c                   |   10 +-
 drivers/i2c/busses/i2c-mxs.c                       |    2 +-
 drivers/i2c/busses/i2c-npcm7xx.c                   |   50 +-
 drivers/i2c/i2c-core-base.c                        |    3 +-
 drivers/i2c/muxes/i2c-mux-gpmux.c                  |    1 +
 drivers/iio/accel/bma400.h                         |   23 +-
 drivers/iio/accel/bma400_core.c                    |    4 +-
 drivers/iio/accel/cros_ec_accel_legacy.c           |    4 +-
 .../iio/common/cros_ec_sensors/cros_ec_lid_angle.c |    4 +-
 .../iio/common/cros_ec_sensors/cros_ec_sensors.c   |    6 +-
 .../common/cros_ec_sensors/cros_ec_sensors_core.c  |   58 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_magn.c         |   36 +-
 drivers/iio/industrialio-core.c                    |   18 +-
 drivers/iio/light/cros_ec_light_prox.c             |    6 +-
 drivers/iio/light/isl29028.c                       |    2 +-
 drivers/iio/pressure/cros_ec_baro.c                |    6 +-
 drivers/infiniband/hw/hfi1/file_ops.c              |    4 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |    4 +-
 drivers/infiniband/hw/irdma/cm.c                   |   11 +-
 drivers/infiniband/hw/irdma/hw.c                   |   15 +-
 drivers/infiniband/hw/irdma/verbs.c                |    2 +-
 drivers/infiniband/hw/mlx5/fs.c                    |    6 +-
 drivers/infiniband/hw/qedr/verbs.c                 |    8 +-
 drivers/infiniband/sw/rxe/rxe_comp.c               |   12 +-
 drivers/infiniband/sw/rxe/rxe_cq.c                 |   25 +-
 drivers/infiniband/sw/rxe/rxe_loc.h                |    2 +-
 drivers/infiniband/sw/rxe/rxe_mr.c                 |   12 +-
 drivers/infiniband/sw/rxe/rxe_mw.c                 |    7 -
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   26 +-
 drivers/infiniband/sw/rxe/rxe_queue.c              |   30 +-
 drivers/infiniband/sw/rxe/rxe_queue.h              |  292 +++---
 drivers/infiniband/sw/rxe/rxe_req.c                |   45 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |   40 +-
 drivers/infiniband/sw/rxe/rxe_srq.c                |    3 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   56 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |    3 -
 drivers/infiniband/sw/siw/siw_cm.c                 |    7 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c           |    4 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt-stats.c       |    8 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c       |  123 +--
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             | 1062 ++++++++++----------
 drivers/infiniband/ulp/rtrs/rtrs-clt.h             |   22 +-
 drivers/infiniband/ulp/rtrs/rtrs-pri.h             |   39 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c       |  121 +--
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |  659 ++++++------
 drivers/infiniband/ulp/rtrs/rtrs-srv.h             |   12 +-
 drivers/infiniband/ulp/rtrs/rtrs.c                 |  127 ++-
 drivers/infiniband/ulp/rtrs/rtrs.h                 |    7 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  148 ++-
 drivers/infiniband/ulp/srpt/ib_srpt.h              |   18 +-
 drivers/input/serio/gscps2.c                       |    4 +
 drivers/interconnect/imx/imx.c                     |    8 +-
 drivers/iommu/arm/arm-smmu/qcom_iommu.c            |    7 +-
 drivers/iommu/exynos-iommu.c                       |    6 +-
 drivers/iommu/intel/dmar.c                         |    2 +-
 drivers/irqchip/Kconfig                            |    5 +-
 drivers/irqchip/irq-mips-gic.c                     |   84 +-
 drivers/md/dm-raid.c                               |    4 +-
 drivers/md/dm-thin-metadata.c                      |    7 +-
 drivers/md/dm-thin.c                               |    4 +-
 drivers/md/dm-writecache.c                         |   43 +-
 drivers/md/dm.c                                    |    5 +
 drivers/md/md.c                                    |    2 +-
 drivers/md/raid10.c                                |    5 +-
 drivers/media/pci/tw686x/tw686x-core.c             |   18 +-
 drivers/media/pci/tw686x/tw686x-video.c            |    4 +-
 drivers/media/platform/atmel/atmel-sama7g5-isc.c   |    2 +
 drivers/media/platform/imx-jpeg/mxc-jpeg-hw.c      |    5 +
 drivers/media/platform/imx-jpeg/mxc-jpeg-hw.h      |    9 +-
 drivers/media/platform/imx-jpeg/mxc-jpeg.c         |  523 ++++++----
 drivers/media/platform/imx-jpeg/mxc-jpeg.h         |    7 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h       |    2 +
 drivers/media/usb/hdpvr/hdpvr-video.c              |    2 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |    2 +-
 drivers/memstick/core/ms_block.c                   |   11 +-
 drivers/mfd/max77620.c                             |    2 +
 drivers/mfd/t7l66xb.c                              |    6 +-
 drivers/misc/cardreader/rtsx_pcr.c                 |    6 +-
 drivers/misc/eeprom/idt_89hpesx.c                  |    8 +-
 drivers/mmc/core/block.c                           |   28 +-
 drivers/mmc/host/cavium-octeon.c                   |    1 +
 drivers/mmc/host/cavium-thunderx.c                 |    4 +-
 drivers/mmc/host/mxcmmc.c                          |    2 +-
 drivers/mmc/host/renesas_sdhi_core.c               |    8 +-
 drivers/mmc/host/sdhci-of-at91.c                   |    9 +-
 drivers/mmc/host/sdhci-of-esdhc.c                  |    1 +
 drivers/mtd/devices/mtd_dataflash.c                |    8 +
 drivers/mtd/devices/st_spi_fsm.c                   |    8 +-
 drivers/mtd/maps/physmap-versatile.c               |    2 +
 drivers/mtd/nand/raw/arasan-nand-controller.c      |   16 +-
 drivers/mtd/nand/raw/meson_nand.c                  |    1 -
 drivers/mtd/parsers/ofpart_bcm4908.c               |    3 +
 drivers/mtd/parsers/redboot.c                      |    1 +
 drivers/mtd/sm_ftl.c                               |    2 +-
 drivers/mtd/spi-nor/core.c                         |    6 +-
 drivers/net/can/dev/netlink.c                      |    6 +-
 drivers/net/can/pch_can.c                          |    8 +-
 drivers/net/can/rcar/rcar_can.c                    |    8 +-
 drivers/net/can/sja1000/sja1000.c                  |    7 +-
 drivers/net/can/spi/hi311x.c                       |    5 +-
 drivers/net/can/sun4i_can.c                        |    9 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   12 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |    6 +-
 drivers/net/can/usb/usb_8dev.c                     |    7 +-
 drivers/net/ethernet/huawei/hinic/hinic_dev.h      |    3 -
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |   68 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c       |    2 -
 drivers/net/ethernet/huawei/hinic/hinic_tx.c       |    2 -
 drivers/net/ethernet/intel/iavf/iavf.h             |    6 +
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   46 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |    2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |    2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |    2 +-
 drivers/net/netdevsim/bpf.c                        |    8 +-
 drivers/net/netdevsim/fib.c                        |   27 +-
 drivers/net/phy/smsc.c                             |    6 +-
 drivers/net/usb/Kconfig                            |    3 +-
 drivers/net/usb/ax88179_178a.c                     |   20 +-
 drivers/net/usb/smsc95xx.c                         |  157 +--
 drivers/net/usb/usbnet.c                           |    8 +-
 drivers/net/wireguard/allowedips.c                 |    9 +-
 drivers/net/wireguard/selftest/allowedips.c        |    6 +-
 drivers/net/wireguard/selftest/ratelimiter.c       |   25 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |    5 +-
 drivers/net/wireless/ath/ath11k/core.c             |   16 +-
 drivers/net/wireless/ath/ath11k/debug.h            |    4 +-
 drivers/net/wireless/ath/ath11k/mac.c              |    2 +-
 drivers/net/wireless/ath/ath9k/htc.h               |   10 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    3 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |   18 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |    5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |    1 +
 drivers/net/wireless/intersil/p54/main.c           |    2 +-
 drivers/net/wireless/intersil/p54/p54spi.c         |    3 +-
 drivers/net/wireless/mac80211_hwsim.c              |   14 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |    1 +
 drivers/net/wireless/marvell/mwifiex/main.h        |    2 +
 drivers/net/wireless/marvell/mwifiex/pcie.c        |    3 +
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |    3 +
 drivers/net/wireless/mediatek/mt76/eeprom.c        |    5 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |    1 +
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |    9 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |    4 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |    6 +-
 drivers/net/wireless/realtek/rtlwifi/debug.c       |    8 +-
 drivers/net/wireless/realtek/rtw88/main.c          |    4 +
 drivers/nvme/host/core.c                           |   44 +-
 drivers/nvme/host/multipath.c                      |    1 +
 drivers/nvme/host/trace.h                          |    2 +-
 drivers/of/device.c                                |    5 +-
 drivers/of/fdt.c                                   |    2 +-
 drivers/of/kexec.c                                 |   17 +
 drivers/opp/core.c                                 |    4 +-
 drivers/parisc/lba_pci.c                           |    6 +-
 drivers/pci/controller/dwc/pcie-designware-ep.c    |   18 +-
 drivers/pci/controller/dwc/pcie-designware-host.c  |   30 +-
 drivers/pci/controller/dwc/pcie-designware.c       |   46 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |   58 +-
 drivers/pci/controller/dwc/pcie-tegra194.c         |   49 +-
 drivers/pci/controller/pcie-mediatek-gen3.c        |    6 +-
 drivers/pci/controller/pcie-microchip-host.c       |    2 +
 drivers/pci/endpoint/functions/pci-epf-test.c      |    1 -
 drivers/pci/p2pdma.c                               |    2 +-
 drivers/pci/pcie/aer.c                             |    7 +-
 drivers/pci/pcie/portdrv_core.c                    |    9 +-
 drivers/perf/arm_spe_pmu.c                         |   22 +-
 drivers/phy/samsung/phy-exynosautov9-ufs.c         |   18 +-
 drivers/phy/st/phy-stm32-usbphyc.c                 |    4 +-
 drivers/platform/chrome/cros_ec.c                  |    8 +-
 drivers/platform/olpc/olpc-ec.c                    |    2 +-
 drivers/pwm/pwm-lpc18xx-sct.c                      |   88 +-
 drivers/pwm/pwm-sifive.c                           |   61 +-
 drivers/regulator/of_regulator.c                   |    6 +-
 drivers/regulator/qcom_smd-regulator.c             |    4 +-
 drivers/remoteproc/imx_rproc.c                     |    7 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |    3 +
 drivers/remoteproc/qcom_sysmon.c                   |   10 +
 drivers/remoteproc/qcom_wcnss.c                    |   10 +-
 drivers/remoteproc/ti_k3_r5_remoteproc.c           |    2 +
 drivers/rpmsg/mtk_rpmsg.c                          |    2 +
 drivers/rpmsg/qcom_smd.c                           |    1 +
 drivers/rpmsg/rpmsg_char.c                         |    7 +-
 drivers/rtc/rtc-rx8025.c                           |   22 +-
 drivers/s390/char/zcore.c                          |   14 +-
 drivers/s390/cio/vfio_ccw_drv.c                    |   14 +-
 drivers/s390/scsi/zfcp_fc.c                        |   29 +-
 drivers/s390/scsi/zfcp_fc.h                        |    6 +-
 drivers/s390/scsi/zfcp_fsf.c                       |    4 +-
 drivers/scsi/be2iscsi/be_main.c                    |    2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |    2 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |    2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   20 +-
 drivers/scsi/iscsi_tcp.c                           |    4 +-
 drivers/scsi/libiscsi.c                            |    9 +-
 drivers/scsi/lpfc/lpfc.h                           |   41 +
 drivers/scsi/lpfc/lpfc_bsg.c                       |   50 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |    3 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |    8 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  139 ++-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |    1 +
 drivers/scsi/lpfc/lpfc_hw4.h                       |    7 +
 drivers/scsi/lpfc/lpfc_init.c                      |   44 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |    4 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |   87 +-
 drivers/scsi/lpfc/lpfc_nvme.h                      |    6 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |   83 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  501 +++++----
 drivers/scsi/lpfc/lpfc_sli.c                       |  907 ++++++++---------
 drivers/scsi/lpfc/lpfc_sli.h                       |   26 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |    2 +
 drivers/scsi/qedi/qedi_main.c                      |    9 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |   31 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |   10 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   16 +-
 drivers/scsi/qla2xxx/qla_edif.c                    |  154 ++-
 drivers/scsi/qla2xxx/qla_edif.h                    |   13 +-
 drivers/scsi/qla2xxx/qla_edif_bsg.h                |    2 +
 drivers/scsi/qla2xxx/qla_fw.h                      |    2 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |    6 +-
 drivers/scsi/qla2xxx/qla_gs.c                      |  129 ++-
 drivers/scsi/qla2xxx/qla_init.c                    |  124 ++-
 drivers/scsi/qla2xxx/qla_iocb.c                    |    8 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |   25 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   19 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |    6 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |    5 -
 drivers/scsi/qla2xxx/qla_os.c                      |   93 +-
 drivers/scsi/qla2xxx/qla_target.c                  |    2 +-
 drivers/scsi/scsi_transport_iscsi.c                |   66 +-
 drivers/scsi/sg.c                                  |   53 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |    4 +-
 drivers/scsi/ufs/ufshcd.c                          |    6 +-
 drivers/soc/amlogic/meson-mx-socinfo.c             |    1 +
 drivers/soc/amlogic/meson-secure-pwrc.c            |    4 +-
 drivers/soc/fsl/guts.c                             |    2 +-
 drivers/soc/qcom/Kconfig                           |    1 +
 drivers/soc/qcom/ocmem.c                           |    3 +
 drivers/soc/qcom/qcom_aoss.c                       |    4 +-
 drivers/soc/renesas/r8a779a0-sysc.c                |   10 +-
 drivers/soundwire/bus.c                            |   75 +-
 drivers/soundwire/bus_type.c                       |   38 +-
 drivers/soundwire/qcom.c                           |    4 +
 drivers/soundwire/slave.c                          |    3 +-
 drivers/soundwire/stream.c                         |   53 +-
 drivers/spi/spi-altera-dfl.c                       |   14 +-
 drivers/spi/spi-rspi.c                             |    4 +
 drivers/spi/spi-synquacer.c                        |    1 +
 drivers/spi/spi-tegra20-slink.c                    |    3 +-
 drivers/spi/spi.c                                  |   19 +-
 drivers/staging/media/atomisp/pci/atomisp_cmd.c    |   57 +-
 drivers/staging/media/hantro/hantro.h              |    2 +
 drivers/staging/media/hantro/hantro_g2_hevc_dec.c  |   27 +-
 drivers/staging/media/hantro/hantro_hevc.c         |    2 +-
 drivers/staging/media/hantro/hantro_postproc.c     |   15 +-
 drivers/staging/media/hantro/imx8m_vpu_hw.c        |    1 +
 drivers/staging/media/hantro/rockchip_vpu_hw.c     |    1 +
 drivers/staging/media/hantro/sama5d4_vdec_hw.c     |    1 +
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c   |    7 +-
 drivers/staging/media/sunxi/cedrus/cedrus_regs.h   |    3 +-
 drivers/staging/rtl8192u/r8192U.h                  |    2 +-
 drivers/staging/rtl8192u/r8192U_dm.c               |   38 +-
 drivers/staging/rtl8192u/r8192U_dm.h               |    2 +-
 drivers/thermal/thermal_sysfs.c                    |   10 +-
 drivers/tty/n_gsm.c                                |  360 +++++--
 drivers/tty/serial/8250/8250.h                     |   40 +
 drivers/tty/serial/8250/8250_bcm7271.c             |   24 +-
 drivers/tty/serial/8250/8250_dma.c                 |    4 +
 drivers/tty/serial/8250/8250_dw.c                  |    3 +
 drivers/tty/serial/8250/8250_fsl.c                 |    2 +-
 drivers/tty/serial/8250/8250_pci.c                 |  582 ++++++++---
 drivers/tty/serial/8250/8250_port.c                |   21 -
 drivers/tty/serial/fsl_lpuart.c                    |   12 +-
 drivers/tty/serial/mvebu-uart.c                    |   11 +
 drivers/tty/vt/vt.c                                |    2 +-
 drivers/usb/cdns3/cdns3-gadget.c                   |   11 +-
 drivers/usb/core/hcd.c                             |   26 +-
 drivers/usb/dwc3/core.c                            |    9 +-
 drivers/usb/dwc3/dwc3-qcom.c                       |    4 +-
 drivers/usb/dwc3/gadget.c                          |   92 +-
 drivers/usb/gadget/udc/Kconfig                     |    2 +-
 drivers/usb/gadget/udc/aspeed-vhub/hub.c           |    4 +-
 drivers/usb/gadget/udc/tegra-xudc.c                |    8 +-
 drivers/usb/host/ehci-ppc-of.c                     |    1 +
 drivers/usb/host/ohci-nxp.c                        |    1 +
 drivers/usb/host/xhci-tegra.c                      |    8 +-
 drivers/usb/host/xhci.h                            |    2 +-
 drivers/usb/serial/sierra.c                        |    3 +-
 drivers/usb/serial/usb-serial.c                    |    2 +-
 drivers/usb/serial/usb_wwan.c                      |    3 +-
 drivers/usb/typec/ucsi/ucsi.c                      |    4 +
 drivers/video/fbdev/amba-clcd.c                    |   24 +-
 drivers/video/fbdev/arkfb.c                        |    9 +-
 drivers/video/fbdev/core/fbcon.c                   |   12 +-
 drivers/video/fbdev/s3fb.c                         |    2 +
 drivers/video/fbdev/sis/init.c                     |    4 +-
 drivers/video/fbdev/vt8623fb.c                     |    2 +
 drivers/watchdog/armada_37xx_wdt.c                 |    2 +
 drivers/watchdog/sp5100_tco.c                      |    1 +
 fs/9p/acl.c                                        |    1 +
 fs/9p/acl.h                                        |   17 +-
 fs/9p/cache.c                                      |    4 +-
 fs/9p/v9fs.c                                       |    4 +
 fs/9p/v9fs_vfs.h                                   |   11 +-
 fs/9p/vfs_addr.c                                   |    6 +-
 fs/9p/vfs_dentry.c                                 |    2 +
 fs/9p/vfs_file.c                                   |    1 +
 fs/9p/vfs_inode.c                                  |   14 +-
 fs/9p/vfs_inode_dotl.c                             |    9 +-
 fs/9p/vfs_super.c                                  |    7 +-
 fs/9p/xattr.h                                      |   19 +-
 fs/attr.c                                          |    2 +
 fs/btrfs/block-group.c                             |    1 +
 fs/btrfs/disk-io.c                                 |   35 +-
 fs/btrfs/inode.c                                   |   72 +-
 fs/cifs/file.c                                     |   20 +-
 fs/erofs/decompressor.c                            |   16 +-
 fs/eventpoll.c                                     |   22 +
 fs/exec.c                                          |    3 +
 fs/ext2/super.c                                    |   12 +-
 fs/ext4/inline.c                                   |    3 +
 fs/ext4/inode.c                                    |   24 +-
 fs/ext4/migrate.c                                  |    4 +-
 fs/ext4/namei.c                                    |   23 +
 fs/ext4/resize.c                                   |    1 +
 fs/ext4/xattr.c                                    |  169 ++--
 fs/ext4/xattr.h                                    |   14 +
 fs/f2fs/file.c                                     |   17 +-
 fs/fuse/control.c                                  |    4 +-
 fs/fuse/inode.c                                    |    6 +
 fs/fuse/ioctl.c                                    |   15 +-
 fs/io_uring.c                                      |    3 +-
 fs/jbd2/commit.c                                   |    2 +-
 fs/jbd2/transaction.c                              |   14 +-
 fs/ksmbd/smb2misc.c                                |    5 -
 fs/ksmbd/smb2pdu.c                                 |    5 +
 fs/lockd/svc4proc.c                                |    8 +
 fs/lockd/xdr4.c                                    |   19 +-
 fs/mbcache.c                                       |   76 +-
 fs/namei.c                                         |    4 +
 fs/nfs/flexfilelayout/flexfilelayout.c             |    4 +
 fs/nfs/nfs3client.c                                |    1 -
 fs/nfsd/filecache.c                                |   22 +-
 fs/nfsd/filecache.h                                |    4 +-
 fs/nfsd/trace.h                                    |    8 -
 fs/overlayfs/export.c                              |    2 +-
 fs/proc/base.c                                     |   46 +-
 fs/splice.c                                        |   10 +-
 include/acpi/apei.h                                |    4 +-
 include/acpi/cppc_acpi.h                           |    2 +-
 include/crypto/internal/blake2s.h                  |  108 --
 include/drm/drm_bridge.h                           |    2 +
 include/drm/drm_gem_shmem_helper.h                 |  168 +++-
 include/dt-bindings/clock/qcom,gcc-msm8939.h       |    1 +
 include/linux/acpi_viot.h                          |    2 +
 include/linux/arm_sdei.h                           |    2 +
 include/linux/blkdev.h                             |    2 -
 include/linux/buffer_head.h                        |   25 +-
 include/linux/ieee80211.h                          |    6 +-
 include/linux/iio/common/cros_ec_sensors_core.h    |    7 +-
 include/linux/kfifo.h                              |    2 +-
 include/linux/lockd/xdr.h                          |    2 +
 include/linux/lockdep.h                            |   30 +-
 include/linux/mbcache.h                            |   10 +-
 include/linux/memremap.h                           |   18 +-
 include/linux/mfd/t7l66xb.h                        |    1 -
 include/linux/once_lite.h                          |   20 +-
 include/linux/pci_ids.h                            |    2 +
 include/linux/pipe_fs_i.h                          |    9 +
 include/linux/sched.h                              |    2 +-
 include/linux/sched/rt.h                           |    8 -
 include/linux/sched/topology.h                     |    1 +
 include/linux/soundwire/sdw.h                      |    6 +-
 include/linux/torture.h                            |    8 +
 include/linux/tpm_eventlog.h                       |    2 +-
 include/linux/usb/hcd.h                            |    1 +
 include/linux/wait.h                               |    9 +-
 include/net/9p/9p.h                                |   10 +-
 include/net/9p/client.h                            |   30 +-
 include/net/9p/transport.h                         |   18 +-
 include/net/inet6_hashtables.h                     |   27 +-
 include/net/inet_hashtables.h                      |   44 +-
 include/net/inet_sock.h                            |   11 +
 include/net/sock.h                                 |   15 +-
 include/scsi/libiscsi.h                            |    2 +-
 include/scsi/scsi_transport_iscsi.h                |    1 +
 include/trace/bpf_probe.h                          |   16 +
 include/trace/events/spmi.h                        |   12 +-
 include/trace/perf.h                               |   17 +
 include/trace/trace_events.h                       |  131 ++-
 include/uapi/linux/can/error.h                     |    5 +-
 include/uapi/linux/netfilter/xt_IDLETIMER.h        |   17 +-
 init/main.c                                        |    1 +
 kernel/bpf/cgroup.c                                |   70 +-
 kernel/bpf/verifier.c                              |    4 +-
 kernel/cgroup/cpuset.c                             |    2 +-
 kernel/dma/swiotlb.c                               |    2 +-
 kernel/irq/Kconfig                                 |    1 +
 kernel/irq/chip.c                                  |    3 +-
 kernel/irq/irqdomain.c                             |    2 +
 kernel/kprobes.c                                   |    3 +-
 kernel/locking/lockdep.c                           |    7 +-
 kernel/power/user.c                                |   13 +-
 kernel/profile.c                                   |    7 +
 kernel/rcu/rcutorture.c                            |   62 +-
 kernel/sched/core.c                                |   59 +-
 kernel/sched/deadline.c                            |   52 +-
 kernel/sched/fair.c                                |   87 ++
 kernel/sched/features.h                            |    3 +-
 kernel/sched/rt.c                                  |   15 +-
 kernel/sched/sched.h                               |    4 +-
 kernel/smp.c                                       |    4 +-
 kernel/time/hrtimer.c                              |    1 +
 kernel/time/timekeeping.c                          |    7 +-
 kernel/trace/blktrace.c                            |    2 +-
 kernel/trace/trace.h                               |    3 +
 lib/crypto/blake2s-selftest.c                      |   41 +
 lib/crypto/blake2s.c                               |   37 +-
 lib/iov_iter.c                                     |   15 +-
 lib/livepatch/test_klp_callbacks_busy.c            |    8 +
 lib/smp_processor_id.c                             |    2 +-
 lib/test_bpf.c                                     |    4 +-
 lib/test_hmm.c                                     |   10 +-
 lib/test_kasan.c                                   |   10 +
 mm/mempolicy.c                                     |    2 +-
 mm/memremap.c                                      |   59 +-
 mm/mmap.c                                          |    1 -
 net/9p/client.c                                    |  462 +++++----
 net/9p/error.c                                     |    2 +-
 net/9p/mod.c                                       |    9 +-
 net/9p/protocol.c                                  |   36 +-
 net/9p/protocol.h                                  |    2 +-
 net/9p/trans_common.h                              |    2 +-
 net/9p/trans_fd.c                                  |   13 +-
 net/9p/trans_rdma.c                                |    2 +-
 net/9p/trans_virtio.c                              |    4 +-
 net/9p/trans_xen.c                                 |    2 +-
 net/bluetooth/l2cap_core.c                         |   13 +-
 net/core/skmsg.c                                   |    4 +-
 net/dccp/proto.c                                   |   10 +-
 net/ipv4/inet_hashtables.c                         |   17 +-
 net/ipv4/tcp_output.c                              |   30 +-
 net/ipv4/udp.c                                     |    3 +-
 net/ipv6/inet6_hashtables.c                        |    6 +-
 net/ipv6/udp.c                                     |    2 +-
 net/mac80211/agg-rx.c                              |    2 +-
 net/mac80211/sta_info.c                            |    6 +-
 net/netfilter/nf_tables_api.c                      |   18 +-
 net/rose/af_rose.c                                 |   11 +-
 net/rose/rose_route.c                              |    2 +
 net/sched/cls_route.c                              |    2 +-
 scripts/faddr2line                                 |    4 +-
 scripts/gdb/linux/dmesg.py                         |   42 +-
 scripts/gdb/linux/utils.py                         |   14 +-
 security/selinux/ss/policydb.h                     |    2 +
 security/selinux/ss/services.c                     |    9 +-
 sound/pci/hda/patch_cirrus.c                       |    1 +
 sound/pci/hda/patch_conexant.c                     |   11 +-
 sound/pci/hda/patch_realtek.c                      |   15 +
 sound/soc/atmel/mchp-spdifrx.c                     |    9 +-
 sound/soc/codecs/cros_ec_codec.c                   |    1 +
 sound/soc/codecs/da7210.c                          |    2 +
 sound/soc/codecs/msm8916-wcd-digital.c             |   46 +-
 sound/soc/codecs/mt6359-accdet.c                   |    1 +
 sound/soc/codecs/mt6359.c                          |    1 +
 sound/soc/codecs/wcd9335.c                         |   81 +-
 sound/soc/fsl/fsl-asoc-card.c                      |    5 +-
 sound/soc/fsl/fsl_asrc.c                           |    6 +-
 sound/soc/fsl/fsl_easrc.c                          |    9 +-
 sound/soc/fsl/fsl_easrc.h                          |    2 +-
 sound/soc/fsl/imx-audmux.c                         |    2 +-
 sound/soc/fsl/imx-card.c                           |   22 +-
 sound/soc/generic/audio-graph-card.c               |    4 +-
 sound/soc/mediatek/mt6797/mt6797-mt6351.c          |    6 +-
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c   |   10 +-
 sound/soc/mediatek/mt8173/mt8173-rt5650.c          |    9 +-
 sound/soc/qcom/lpass-cpu.c                         |    1 +
 sound/soc/qcom/qdsp6/q6adm.c                       |    2 +-
 sound/soc/samsung/aries_wm8994.c                   |    6 +-
 sound/soc/samsung/h1940_uda1380.c                  |    2 +-
 sound/soc/samsung/rx1950_uda1380.c                 |    4 +-
 sound/usb/bcd2000/bcd2000.c                        |    3 +-
 sound/usb/quirks.c                                 |    2 +
 tools/lib/bpf/gen_loader.c                         |    2 +-
 tools/lib/bpf/libbpf.c                             |    9 +-
 tools/lib/bpf/xsk.c                                |    9 +-
 tools/perf/util/dsos.c                             |   15 +-
 tools/perf/util/genelf.c                           |    6 +-
 tools/perf/util/symbol-elf.c                       |   27 +-
 tools/testing/nvdimm/test/iomap.c                  |   43 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |    2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c |    2 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |    2 +-
 .../testing/selftests/timers/clocksource-switch.c  |    6 +-
 tools/testing/selftests/timers/valid-adjtimex.c    |    2 +-
 tools/thermal/tmon/sysfs.c                         |   24 +-
 tools/thermal/tmon/tmon.h                          |    3 +
 virt/kvm/kvm_main.c                                |   16 +-
 801 files changed, 10565 insertions(+), 7357 deletions(-)


