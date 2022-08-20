Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C6959B279
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 09:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiHUHCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 03:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiHUHBj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 03:01:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9892AC50;
        Sun, 21 Aug 2022 00:01:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AE31B80BA7;
        Sun, 21 Aug 2022 07:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8539C433C1;
        Sun, 21 Aug 2022 07:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661065289;
        bh=/L4d7xwmLHek28p7WzwFL6Kk2QWBNdD1pqAnmXcjeCo=;
        h=From:To:Cc:Subject:Date:From;
        b=TaHzwj8on+Sp6kTd7MwHhWZn9rLxuA7Ev7Gji463CwFt3i8dx12+A20D/+s/Pxxg5
         qCgmWyqRbnwm4ib0qA4/YugXZ4hFNFQmo1y7yw3XBSnYCPOooZ4Qcy4jFjuL/UMNUP
         KGVUiF3mHF1VoPSDKdUMdiB0KSSD8o38TLI3CYr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 000/541] 5.10.137-rc2 review
Date:   Sat, 20 Aug 2022 20:39:26 +0200
Message-Id: <20220820182952.751374248@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.137-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.137-rc2
X-KernelTest-Deadline: 2022-08-22T18:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.137 release.
There are 541 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 22 Aug 2022 18:28:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.137-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.137-rc2

Qu Wenruo <wqu@suse.com>
    btrfs: raid56: don't trust any cached sector in __raid56_parity_recover()

Qu Wenruo <wqu@suse.com>
    btrfs: only write the sectors in the vertical stripe which has data stripes

Tadeusz Struk <tadeusz.struk@linaro.org>
    sched/fair: Fix fault in reweight_entity

Jamal Hadi Salim <jhs@mojatatu.com>
    net_sched: cls_route: disallow handle of 0

Tyler Hicks <tyhicks@linux.microsoft.com>
    net/9p: Initialize the iounit field during fid creation

Jens Wiklander <jens.wiklander@linaro.org>
    tee: add overflow check in register_shm_helper()

Aaron Lewis <aaronlewis@google.com>
    kvm: x86/pmu: Fix the compare function used by the pmu event filter

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: arasan: Prevent an unsupported configuration

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression

Jose Alonso <joalonsof@gmail.com>
    Revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP"

Tom Rix <trix@redhat.com>
    drm/vc4: change vc4_dma_range_matches from a global to static

Marek Vasut <marex@denx.de>
    drm/bridge: tc358767: Fix (e)DP bridge endpoint parsing in dedicated function

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv"

Eric Dumazet <edumazet@google.com>
    tcp: fix over estimation in sk_forced_mem_schedule()

Ahmed Zaki <anzaki@gmail.com>
    mac80211: fix a memory leak where sta_info is not freed

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: Avoid theoretical NULL pointer dereference in kvm_irq_delivery_to_apic_fast()

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: Check lapic_in_kernel() before attempting to set a SynIC irq

Sean Christopherson <seanjc@google.com>
    KVM: Add infrastructure and macro to mark VM as bugged

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    net_sched: cls_route: remove from list when handle is 0

Mikulas Patocka <mpatocka@redhat.com>
    dm raid: fix address sanitizer warning in raid_status

Mikulas Patocka <mpatocka@redhat.com>
    dm raid: fix address sanitizer warning in raid_resume

Baokun Li <libaokun1@huawei.com>
    ext4: correct the misjudgment in ext4_iget_extra_inode

Baokun Li <libaokun1@huawei.com>
    ext4: correct max_inline_xattr_value_size computing

Eric Whitney <enwlinux@gmail.com>
    ext4: fix extent status tree race in writeback error recovery path

Theodore Ts'o <tytso@mit.edu>
    ext4: update s_overhead_clusters in the superblock during an on-line resize

Baokun Li <libaokun1@huawei.com>
    ext4: fix use-after-free in ext4_xattr_set_entry

Lukas Czerner <lczerner@redhat.com>
    ext4: make sure ext4_append() always allocates new block

Ye Bin <yebin10@huawei.com>
    ext4: fix warning in ext4_iomap_begin as race between bmap and write

Baokun Li <libaokun1@huawei.com>
    ext4: add EXT4_INODE_HAS_XATTR_SPACE macro in xattr.h

Lukas Czerner <lczerner@redhat.com>
    ext4: check if directory block is within i_size

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Use a struct alignof to determine trace event field alignment

Huacai Chen <chenhuacai@loongson.cn>
    tpm: eventlog: Fix section mismatch for DEBUG_SECTION_MISMATCH

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    KEYS: asymmetric: enforce SM2 signature use pkey algo

SeongJae Park <sj@kernel.org>
    xen-blkfront: Apply 'feature_persistent' parameter when connect

Maximilian Heyne <mheyne@amazon.de>
    xen-blkback: Apply 'feature_persistent' parameter when connect

SeongJae Park <sj@kernel.org>
    xen-blkback: fix persistent grants negotiation

Like Xu <likexu@tencent.com>
    KVM: x86/pmu: Ignore pmu->global_ctrl check if vPMU doesn't support global_ctrl

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Mark all PERF_GLOBAL_(OVF)_CTRL bits reserved if there's no vPMU

Like Xu <like.xu@linux.intel.com>
    KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter

Jim Mattson <jmattson@google.com>
    KVM: x86/pmu: Use different raw event masks for AMD and Intel

Jim Mattson <jmattson@google.com>
    KVM: x86/pmu: Use binary search to check filtered events

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86/pmu: preserve IA32_PERF_CAPABILITIES across CPUID refresh

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Inject #UD if VMXON is attempted with incompatible CR0/CR4

Sean Christopherson <seanjc@google.com>
    KVM: x86: Move vendor CR4 validity check to dedicated kvm_x86_ops hook

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Drop VMXE check from svm_set_cr4()

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Drop explicit 'nested' check from vmx_set_cr4()

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Drop guest CPUID check for VMXE in vmx_set_cr4()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: CPPC: Do not prevent CPPC from working in the future

Josef Bacik <josef@toxicpanda.com>
    btrfs: reset block group chunk force if we have to wait

Qu Wenruo <wqu@suse.com>
    btrfs: reject log replay if there is unsupported RO compat flag

Jason A. Donenfeld <Jason@zx2c4.com>
    um: seed rng using host OS rng

Johannes Berg <johannes.berg@intel.com>
    um: Allow PM with suspend-to-idle

Jason A. Donenfeld <Jason@zx2c4.com>
    timekeeping: contribute wall clock to rng on time change

Luo Meng <luomeng12@huawei.com>
    dm thin: fix use-after-free crash in dm_sm_register_threshold_callback

Michal Suchanek <msuchanek@suse.de>
    kexec, KEYS, s390: Make use of built-in and secondary keyring for signature verification

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: set a default MAX_WRITEBACK_JOBS

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Fold EndRun device support into OxSemi Tornado code

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_pci: Replace dev_*() by pci_*() macros

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_pci: Refactor the loop in pci_ite887x_init()

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Correct the clock for OxSemi PCIe devices

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Dissociate 4MHz Titan ports from Oxford ports

Mohamed Khalfella <mkhalfella@purestorage.com>
    PCI/AER: Iterate over error counters instead of error strings

Sean V Kelley <sean.v.kelley@intel.com>
    PCI/ERR: Recover from RCEC AER errors

Sean V Kelley <sean.v.kelley@intel.com>
    PCI/ERR: Add pci_walk_bridge() to pcie_do_recovery()

Sean V Kelley <sean.v.kelley@intel.com>
    PCI/ERR: Avoid negated conditional for clarity

Sean V Kelley <sean.v.kelley@intel.com>
    PCI/ERR: Use "bridge" for clarity in pcie_do_recovery()

Sean V Kelley <sean.v.kelley@intel.com>
    PCI/ERR: Simplify by computing pci_pcie_type() once

Sean V Kelley <sean.v.kelley@intel.com>
    PCI/ERR: Simplify by using pci_upstream_bridge()

Sean V Kelley <sean.v.kelley@intel.com>
    PCI/ERR: Rename reset_link() to reset_subordinates()

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    PCI/ERR: Bind RCEC devices to the Root Port driver

Sean V Kelley <sean.v.kelley@intel.com>
    PCI/AER: Write AER Capability only when we control it

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

Lukas Wunner <lukas@wunner.de>
    usbnet: smsc95xx: Avoid link settings race on interrupt reception

Lukas Wunner <lukas@wunner.de>
    usbnet: smsc95xx: Don't clear read-only PHY interrupt

Olga Kitaina <okitain@gmail.com>
    mtd: rawnand: arasan: Fix clock rate in NV-DDR

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: arasan: Support NV-DDR interface

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: arasan: Fix a macro parameter

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: Add NV-DDR timings

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: arasan: Check the proposed data interface is supported

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: Add a helper to clarify the interface configuration

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: drv: Adopt the dma configuration from the HVS or V3D component

Zoltan Tamas Vajda <zoltan.tamas.vajda@gmail.com>
    HID: hid-input: add Surface Go battery quirk

Elia Devito <eliadevito@gmail.com>
    HID: Ignore battery for Elan touchscreen on HP Spectre X360 15-df0xxx

Jitao Shi <jitao.shi@mediatek.com>
    drm/mediatek: Keep dsi as LP00 before dcs cmds transfer

Julien STEPHAN <jstephan@baylibre.com>
    drm/mediatek: Allow commands to be sent during video mode

Chuansheng Liu <chuansheng.liu@intel.com>
    drm/i915/dg1: Update DMC_DEBUG3 register

David Collins <quic_collinsd@quicinc.com>
    spmi: trace: fix stack-out-of-bound access in SPMI tracing functions

Al Viro <viro@zeniv.linux.org.uk>
    __follow_mount_rcu(): verify that mount_lock remains unchanged

Xie Shaowen <studentxswpy@163.com>
    Input: gscps2 - check return value of ioremap() in gscps2_probe()

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    posix-cpu-timers: Cleanup CPU timers before freeing them during exec

Alexander Lobakin <alexandr.lobakin@intel.com>
    x86/olpc: fix 'logical not is only applied to the left hand side'

Steven Rostedt (Google) <rostedt@goodmis.org>
    ftrace/x86: Add back ftrace_expected assignment

Kim Phillips <kim.phillips@amd.com>
    x86/bugs: Enable STIBP for IBPB mitigated RETBleed

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix losing FCP-2 targets during port perturbation tests

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix losing FCP-2 targets on long port disable with I/Os

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix erroneous mailbox timeout after PCI error injection

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Turn off multi-queue for 8G adapters

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix discovery issues in FC-AL topology

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: Fix missing auto port scan and thus missing target ports

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: s3fb: Check the size of screen before memset_io()

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: arkfb: Check the size of screen before memset_io()

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: vt8623fb: Check the size of screen before memset_io()

Andrea Righi <andrea.righi@canonical.com>
    x86/entry: Build thunk_$(BITS) only if CONFIG_PREEMPTION=y

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

Byungki Lee <dominicus79@gmail.com>
    f2fs: write checkpoint during FG_GC

Chao Yu <chao@kernel.org>
    f2fs: don't set GC_FAILURE_PIN for background GC

Pali Rohár <pali@kernel.org>
    powerpc/pci: Prefer PCI domain assignment via DT 'linux,pci-domain' and alias

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Do not allow selection of e5500 or e6500 CPUs on PPC32

Claudiu Beznea <claudiu.beznea@microchip.com>
    ASoC: mchp-spdifrx: disable end of block interrupt on failures

Rustam Subkhankulov <subkhankulov@ispras.ru>
    video: fbdev: sis: fix typos in SiS_GetModeID()

Liang He <windhl@126.com>
    video: fbdev: amba-clcd: Fix refcount leak bugs

William Dean <williamsukatube@gmail.com>
    watchdog: armada_37xx_wdt: check the return value of devm_ioremap() in armada_37xx_wdt_probe()

Liang He <windhl@126.com>
    ASoC: audio-graph-card: Add of_node_put() in fail path

Xie Yongji <xieyongji@bytedance.com>
    fuse: Remove the control interface for virtio-fs

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: qcom: q6dsp: Fix an off-by-one in q6adm_alloc_copp()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_easrc: use snd_pcm_format_t type for sample_format

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/zcore: fix race when reading from hardware system area

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

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    lib/smp_processor_id: fix imbalanced instrumentation_end() call

Dan Carpenter <dan.carpenter@oracle.com>
    kfifo: fix kfifo_to_user() return type

Miaoqian Lin <linmq006@gmail.com>
    rpmsg: qcom_smd: Fix refcount leak in qcom_smd_parse_edge

Sam Protsenko <semen.protsenko@linaro.org>
    iommu/exynos: Handle failed IOMMU device registration properly

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix missing corner cases in gsmld_poll()

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix DM command

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong T1 retry count handling

Eric Farman <farman@linux.ibm.com>
    vfio/ccw: Do not change FSM state in subchannel event

Jason Gunthorpe <jgg@ziepe.ca>
    vfio/mdev: Make to_mdev_device() into a static inline

Jason Gunthorpe <jgg@ziepe.ca>
    vfio: Split creation of a vfio_device into init and register ops

Jason Gunthorpe <jgg@ziepe.ca>
    vfio: Simplify the lifetime logic for vfio_device

Jason Gunthorpe <jgg@ziepe.ca>
    vfio: Remove extra put/gets around vfio_device->group

Sireesh Kodali <sireeshkodali1@gmail.com>
    remoteproc: qcom: wcnss: Fix handling of IRQs

Liang He <windhl@126.com>
    ASoC: qcom: Fix missing of_node_put() in asoc_qcom_lpass_cpu_platform_probe()

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix race condition in gsmld_write()

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix packet re-transmission without open control channel

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix non flow control frames during mux flow off

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong queuing behavior in gsm_dlci_data_output()

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

Chen Zhongjin <chenzhongjin@huawei.com>
    profiling: fix shift too large makes kernel panic

Joe Lawrence <joe.lawrence@redhat.com>
    selftests/livepatch: better synchronize test_klp_callbacks_busy

Miaoqian Lin <linmq006@gmail.com>
    remoteproc: k3-r5: Fix refcount leak in k3_r5_cluster_of_init

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    rpmsg: mtk_rpmsg: Fix circular locking dependency

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd9335: move gains from SX_TLV to S8_TLV

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: msm8916-wcd-digital: move gains from SX_TLV to S8_TLV

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dw: Store LSR into lsr_saved_flags in dw8250_tx_wait_empty()

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

Bean Huo <beanhuo@micron.com>
    nvme: use command_id instead of req->tag in trace_nvme_complete_rq()

Dan Carpenter <dan.carpenter@oracle.com>
    null_blk: fix ida error handling in null_add_dev()

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix error unwind in rxe_create_qp()

Maor Gottlieb <maorg@nvidia.com>
    RDMA/mlx5: Add missing check for return value in get namespace flow

Andrei Vagin <avagin@google.com>
    selftests: kvm: set rax before vmcall

Miaohe Lin <linmiaohe@huawei.com>
    mm/mmap.c: fix missing call to vm_unacct_memory in mmap_region

Bart Van Assche <bvanassche@acm.org>
    RDMA/srpt: Fix a use-after-free

Bart Van Assche <bvanassche@acm.org>
    RDMA/srpt: Introduce a reference count in struct srpt_device

Bart Van Assche <bvanassche@acm.org>
    RDMA/srpt: Duplicate port name members

Dan Carpenter <dan.carpenter@oracle.com>
    platform/olpc: Fix uninitialized data in debugfs write

Andrey Strachuk <strochuk@ispras.ru>
    usb: cdns3: change place of 'priv_ep' assignment in cdns3_gadget_ep_dequeue(), cdns3_gadget_ep_enable()

Johan Hovold <johan@kernel.org>
    USB: serial: fix tty-port initialized comments

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Fix link up retry sequence

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Fix Root Port interrupt handling

Artem Borisov <dedsa2002@gmail.com>
    HID: alps: Declare U1_UNICORN_LEGACY support

Liang He <windhl@126.com>
    mmc: cavium-thunderx: Add of_node_put() when breaking out of loop

Liang He <windhl@126.com>
    mmc: cavium-octeon: Add of_node_put() when breaking out of loop

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    HID: mcp2221: prevent a buffer overflow in mcp_smbus_write()

Liang He <windhl@126.com>
    gpio: gpiolib-of: Fix refcount bugs in of_mm_gpiochip_add_data()

Jianglei Nie <niejianglei2021@163.com>
    RDMA/hfi1: fix potential memory leak in setup_base_ctxt()

Cheng Xu <chengyou@linux.alibaba.com>
    RDMA/siw: Fix duplicated reported IW_CM_EVENT_CONNECT_REPLY event

Haoyue Xu <xuhaoyue1@hisilicon.com>
    RDMA/hns: Fix incorrect clearing of interrupt status register

Jianglei Nie <niejianglei2021@163.com>
    RDMA/qedr: Fix potential memory leak in __qedr_alloc_mr()

Prabhakar Kushwaha <pkushwaha@marvell.com>
    RDMA/qedr: Improve error logs for rdma_alloc_tid error return

Jack Wang <jinpu.wang@ionos.com>
    RDMA/rtrs-srv: Fix modinfo output for stringify

Jack Wang <jinpu.wang@ionos.com>
    RDMA/rtrs: Avoid Wtautological-constant-out-of-range-compare

Gioh Kim <gi-oh.kim@cloud.ionos.com>
    RDMA/rtrs: Define MIN_CHUNK_SIZE

Christopher Obbard <chris.obbard@collabora.com>
    um: random: Don't initialise hwrng struct with zero

Peng Fan <peng.fan@nxp.com>
    interconnect: imx: fix max_node_id

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

Eugen Hristev <eugen.hristev@microchip.com>
    mmc: sdhci-of-at91: fix set_uhs_signaling rewriting of MC1R

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    memstick/ms_block: Fix a memory leak

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    memstick/ms_block: Fix some incorrect memory allocation

Miaoqian Lin <linmq006@gmail.com>
    mmc: sdhci-of-esdhc: Fix refcount leak in esdhc_signal_voltage_switch

Duoming Zhou <duoming@zju.edu.cn>
    staging: rtl8192u: Fix sleep in atomic context bug in dm_fsync_timer_callback

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: msu: Fix vmalloced buffers

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    intel_th: msu-sink: Potential dereference of null pointer

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    intel_th: Fix a resource leak in an error handling path

Shunsuke Mie <mie@igel.co.jp>
    PCI: endpoint: Don't stop controller when unbinding endpoint function

Viacheslav Mitrofanov <v.v.mitrofanov@yadro.com>
    dmaengine: sf-pdma: Add multithread support for a DMA channel

Austin Kim <austin.kim@lge.com>
    dmaengine: sf-pdma: apply proper spinlock flags in sf_pdma_prep_dma_memcpy()

Quentin Perret <qperret@google.com>
    KVM: arm64: Don't return from void function

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: bus_type: fix remove and shutdown support

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    PCI: dwc: Always enable CDM check if "snps,enable-cdm-check" exists

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    PCI: dwc: Deallocate EPC memory on dw_pcie_ep_init() errors

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    PCI: dwc: Add unroll iATU space support to dw_pcie_disable_atu()

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

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: host: xhci: use snprintf() in xhci_decode_trb()

Ansuel Smith <ansuelsmth@gmail.com>
    clk: qcom: clk-krait: unlock spin after mux completion

Zhang Wensheng <zhangwensheng5@huawei.com>
    driver core: fix potential deadlock in __driver_attach

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    misc: rtsx: Fix an error handling path in rtsx_pci_probe()

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    dmaengine: dw-edma: Fix eDMA Rd/Wr-channels and DMA-direction semantics

Duoming Zhou <duoming@zju.edu.cn>
    mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv

Jonas Dreßler <verdre@v0yd.nl>
    mwifiex: Ignore BTCOEX events from the 88W8897 firmware

Sean Christopherson <seanjc@google.com>
    KVM: Don't set Accessed/Dirty bits for ZERO_PAGE

Rex-BC Chen <rex-bc.chen@mediatek.com>
    clk: mediatek: reset: Fix written reset bit offset

Jagath Jog J <jagathjog1996@gmail.com>
    iio: accel: bma400: Reordering of header files

Stephen Boyd <swboyd@chromium.org>
    platform/chrome: cros_ec: Always expose last resume result

Jagath Jog J <jagathjog1996@gmail.com>
    iio: accel: bma400: Fix the scale min and max macro values

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

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mtd: st_spi_fsm: Add a clk_disable_unprepare() in .probe()'s error path

Miaoqian Lin <linmq006@gmail.com>
    mtd: partitions: Fix refcount leak in parse_redboot_of

Duoming Zhou <duoming@zju.edu.cn>
    mtd: sm_ftl: Fix deadlock caused by cancel_work_sync in sm_release

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    HID: cp2112: prevent a buffer overflow in cp2112_xfer()

Miaoqian Lin <linmq006@gmail.com>
    PCI: tegra194: Fix PM error handling in tegra_pcie_config_ep()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mtd: rawnand: meson: Fix a potential double free issue

Miaoqian Lin <linmq006@gmail.com>
    mtd: maps: Fix refcount leak in ap_flash_init

Miaoqian Lin <linmq006@gmail.com>
    mtd: maps: Fix refcount leak in of_flash_probe_versatile

Ralph Siemsen <ralph.siemsen@linaro.org>
    clk: renesas: r9a06g032: Fix UART clkgrp bitsel

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: allowedips: don't corrupt stack when detecting overflow

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: ratelimiter: use hrtimer in selftest

Hangyu Hua <hbh25y@gmail.com>
    dccp: put dccp_qpolicy_full() and dccp_qpolicy_push() in the same lock

Jian Shen <shenjian15@huawei.com>
    net: ionic: fix error check for vlan flags in ionic_set_nic_features()

Eric Dumazet <edumazet@google.com>
    net: rose: fix netdev reference changes

Jakub Kicinski <kuba@kernel.org>
    netdevsim: Avoid allocation warnings triggered from user space

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    iavf: Fix max_rate limiting

Mike Manning <mvrmanning@gmail.com>
    net: allow unbound socket for packets in VRF when tcp_l3mdev_accept set

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_l3mdev_accept.

Eric Dumazet <edumazet@google.com>
    ipv6: add READ_ONCE(sk->sk_bound_dev_if) in INET6_MATCH()

Eric Dumazet <edumazet@google.com>
    tcp: sk->sk_bound_dev_if once in inet_request_bound_dev_if()

Eric Dumazet <edumazet@google.com>
    inet: add READ_ONCE(sk->sk_bound_dev_if) in INET_MATCH()

Kai Ye <yekai13@huawei.com>
    crypto: hisilicon/sec - fix auth key size error

Pali Rohár <pali@kernel.org>
    crypto: inside-secure - Add missing MODULE_DEVICE_TABLE for of

Zhengchao Shao <shaozhengchao@huawei.com>
    crypto: hisilicon/hpre - don't use GFP_KERNEL to alloc mem during softirq

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
    selftests/bpf: fix a test for snprintf() overflow

Rustam Subkhankulov <subkhankulov@ispras.ru>
    wifi: p54: add missing parentheses in p54_flush()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    wifi: p54: Fix an error handling path in p54spi_probe()

Dan Carpenter <dan.carpenter@oracle.com>
    wifi: wil6210: debugfs: fix info leak in wil_write_file_wmi()

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

Liang He <windhl@126.com>
    mediatek: mt76: mac80211: Fix missing of_node_put() in mt76_led_init()

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt76x02u: fix possible memory leak in __mt76x02u_mcu_send_msg

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    media: platform: mtk-mdp: Fix mdp_ipi_comm structure alignment

Zhengchao Shao <shaozhengchao@huawei.com>
    crypto: hisilicon - Kunpeng916 crypto driver don't sleep when in softirq

Zhengchao Shao <shaozhengchao@huawei.com>
    crypto: hisilicon/sec - don't sleep when in softirq

Longfang Liu <liulongfang@huawei.com>
    crypto: hisilicon/sec - fixes some coding style

Rob Clark <robdclark@chromium.org>
    drm/msm/mdp5: Fix global state lock backoff

Qiao Ma <mqaio@linux.alibaba.com>
    net: hinic: avoid kernel hung in hinic_get_stats64()

Qiao Ma <mqaio@linux.alibaba.com>
    net: hinic: fix bug that ethtool get wrong stats

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    hinic: Use the bitmap API when applicable

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    lib: bitmap: provide devm_bitmap_alloc() and devm_bitmap_zalloc()

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    lib: bitmap: order includes alphabetically

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

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Limit the BCM2711 to the max without scrambling

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Don't access the connector state in reset if kmalloc fails

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: Avoid full hdmi audio fifo writes

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: Remove firmware logic for MAI threshold setting

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dsi: Add correct stop condition to vc4_dsi_encoder_disable iteration

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dsi: Fix dsi0 interrupt support

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dsi: Register dsi0 as the correct vc4 encoder type

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: dsi: Introduce a variant structure

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: dsi: Use snprintf for the PHY clocks instead of an array

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: drv: Remove the DSI pointer in vc4_drv

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dsi: Correct pixel order for DSI0

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dsi: Correct DSI divider calculations

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: plane: Fix margin calculations for the right/bottom edges

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: plane: Remove subpixel positioning check

Miaoqian Lin <linmq006@gmail.com>
    media: tw686x: Fix memory leak in tw686x_video_init

Ming Qian <ming.qian@nxp.com>
    media: v4l2-mem2mem: prevent pollerr when last_buffer_dequeued is set

Niels Dossche <dossche.niels@gmail.com>
    media: hdpvr: fix error value returns in hdpvr_read

Miaoqian Lin <linmq006@gmail.com>
    drm/mcde: Fix refcount leak in mcde_dsi_bind

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm: bridge: adv7511: Add check for mipi_dsi_driver_register

Tom Lendacky <thomas.lendacky@amd.com>
    crypto: ccp - During shutdown, check SEV data pointer before using

Jian Shen <shenjian15@huawei.com>
    test_bpf: fix incorrect netdev features

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix incorrrect SPDX-License-Identifiers

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    wifi: iwlegacy: 4965: fix potential off-by-one overflow in il4965_rs_fill_link_cmd()

Pavel Skripkin <paskripkin@gmail.com>
    ath9k: fix use-after-free in ath9k_hif_usb_rx_cb

Zheyu Ma <zheyuma97@gmail.com>
    media: tw686x: Register the irq at the end of probe

Alexey Khoroshilov <khoroshilov@ispras.ru>
    crypto: sun8i-ss - fix infinite loop in sun8i_ss_setup_ivs()

Xu Wang <vulab@iscas.ac.cn>
    i2c: Fix a potential use after free

Eric Dumazet <edumazet@google.com>
    net: fix sk_wmem_schedule() and sk_rmem_schedule() errors

Dan Carpenter <dan.carpenter@oracle.com>
    crypto: sun8i-ss - fix error codes in allocate_flows()

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun8i-ss - do not allocate memory when handling hash requests

Antonio Borneo <antonio.borneo@foss.st.com>
    drm: adv7511: override i2c address of cec before accessing it

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    virtio-gpu: fix a missing check to avoid NULL dereference

Tali Perry <tali.perry1@gmail.com>
    i2c: npcm: Correct slave role behavior

Tali Perry <tali.perry1@gmail.com>
    i2c: npcm: Remove own slave addresses 2:10

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

Javier Martinez Canillas <javierm@redhat.com>
    drm/st7735r: Fix module autoloading for Okaya RH128128T

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ath10k: do not enforce interrupt trigger type

Marek Vasut <marex@denx.de>
    drm/bridge: tc358767: Make sure Refclk clock are enabled

Marek Vasut <marex@denx.de>
    drm/bridge: tc358767: Move (e)DP bridge endpoint parsing into dedicated function

Yangtao Li <tiny.windzz@gmail.com>
    pwm: lpc18xx-sct: Convert to devm_platform_ioremap_resource()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sifive: Shut down hardware only after pwmchip_remove() completed

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sifive: Ensure the clk is enabled exactly once per running PWM

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sifive: Simplify offset calculation for PWMCMP registers

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sifive: Don't check the return code of pwmchip_remove()

Mike Snitzer <snitzer@kernel.org>
    dm: return early from dm_pr_call() if DM device is suspended

Markus Mayer <mmayer@broadcom.com>
    thermal/tools/tmon: Include pthread and time headers in tmon.h

YiFei Zhu <zhuyifei@google.com>
    selftests/seccomp: Fix compile warning when CC=clang

Nicolas Saenz Julienne <nsaenzju@redhat.com>
    nohz/full, sched/rt: Fix missed tick-reenabling bug in dequeue_task_rt()

Anshuman Khandual <anshuman.khandual@arm.com>
    drivers/perf: arm_spe: Fix consistency of SYS_PMSCR_EL1.CX

Sumit Garg <sumit.garg@linaro.org>
    arm64: dts: qcom: qcs404: Fix incorrect USB2 PHYs assignment

Konrad Dybcio <konrad.dybcio@somainline.org>
    soc: qcom: Make QCOM_RPMPD depend on PM

Liang He <windhl@126.com>
    regulator: of: Fix refcount leak bug in of_get_regulation_constraints()

Bart Van Assche <bvanassche@acm.org>
    blktrace: Trace remapped requests correctly

Christoph Hellwig <hch@lst.de>
    block: remove the request_queue to argument request based tracepoints

Linus Walleij <linus.walleij@linaro.org>
    hwmon: (drivetemp) Add module alias

Ming Lei <ming.lei@redhat.com>
    blk-mq: don't create hctx debugfs dir until q->debugfs_dir is created

Gao Xiang <hsiangkao@linux.alibaba.com>
    erofs: avoid consecutive detection for Highmem memory

Tamás Szűcs <tszucs@protonmail.ch>
    arm64: tegra: Fix SDMMC1 CD on P2888

Nick Hainke <vincent@systemli.org>
    arm64: dts: mt7622: fix BPI-R64 WPS button

Yang Yingliang <yangyingliang@huawei.com>
    bus: hisi_lpc: fix missing platform_device_put() in hisi_lpc_acpi_probe()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: qcom: pm8841: add required thermal-sensor-cells

Miaoqian Lin <linmq006@gmail.com>
    soc: qcom: aoss: Fix refcount leak in qmp_cooling_devices_register

Miaoqian Lin <linmq006@gmail.com>
    soc: qcom: ocmem: Fix refcount leak in of_get_ocmem

Dan Williams <dan.j.williams@intel.com>
    ACPI: APEI: Fix _EINJ vs EFI_MEMORY_SP

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    regulator: qcom_smd: Fix pm8916_pldo range

Miaoqian Lin <linmq006@gmail.com>
    cpufreq: zynq: Fix refcount leak in zynq_get_revision

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

Peter Zijlstra <peterz@infradead.org>
    locking/lockdep: Fix lockdep_init_map_*() confusion

Alexandru Elisei <alexandru.elisei@arm.com>
    arm64: cpufeature: Allow different PMU versions in ID_DFR0_EL1

Nathan Chancellor <nathan@kernel.org>
    hexagon: select ARCH_WANT_LD_ORPHAN_WARN

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

Geert Uytterhoeven <geert+renesas@glider.be>
    soc: renesas: r8a779a0-sysc: Fix A2DP1 and A2CV[2357] PDR values

Linus Walleij <linus.walleij@linaro.org>
    Input: atmel_mxt_ts - fix up inverted RESET handler

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ARM: dts: imx7d-colibri-emmc: add cpu1 supply

Guilherme G. Piccoli <gpiccoli@igalia.com>
    ACPI: processor/idle: Annotate more functions to live in cpuidle section

Miaoqian Lin <linmq006@gmail.com>
    ARM: bcm: Fix refcount leak in bcm_kona_smc_init

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

Xiu Jianfeng <xiujianfeng@huawei.com>
    selinux: Add boundary check in put_entry()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    PM: hibernate: defer device probing when resuming from hibernation

Lv Ruyi <lv.ruyi@zte.com.cn>
    firmware: tegra: Fix error check return value of debugfs_create_file()

Liang He <windhl@126.com>
    ARM: shmobile: rcar-gen2: Increase refcount for new reference

Samuel Holland <samuel@sholland.org>
    arm64: dts: allwinner: a64: orangepi-win: Fix LED node name

Robert Marko <robimarko@gmail.com>
    arm64: dts: qcom: ipq8074: fix NAND node name

huhai <huhai@kylinos.cn>
    ACPI: LPSS: Fix missing check in register_device_clock()

Manyi Li <limanyi@uniontech.com>
    ACPI: PM: save NVS memory for Lenovo G40-45

Hans de Goede <hdegoede@redhat.com>
    ACPI: EC: Drop the EC_FLAGS_IGNORE_DSDT_GPE quirk

Hans de Goede <hdegoede@redhat.com>
    ACPI: EC: Remove duplicate ThinkPad X1 Carbon 6th entry from DMI quirks

Liang He <windhl@126.com>
    ARM: OMAP2+: display: Fix refcount leak bug

Guo Mengqi <guomengqi3@huawei.com>
    spi: synquacer: Add missing clk_disable_unprepare()

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

Samuel Holland <samuel@sholland.org>
    genirq: GENERIC_IRQ_IPI depends on SMP

Samuel Holland <samuel@sholland.org>
    irqchip/mips-gic: Only register IPI domain when SMP is enabled

Antonio Borneo <antonio.borneo@foss.st.com>
    genirq: Don't return error on missing optional irq_request_resources()

Jan Kara <jack@suse.cz>
    ext2: Add more validity checks for inode counts

haibinzhang (张海斌) <haibinzhang@tencent.com>
    arm64: fix oops in concurrently setting insn_emulation sysctls

Francis Laniel <flaniel@linux.microsoft.com>
    arm64: Do not forget syscall when starting a new thread.

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

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    lockdep: Allow tuning tracing capacity constants.

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

Huacai Chen <chenhuacai@loongson.cn>
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

Mikulas Patocka <mpatocka@redhat.com>
    md-raid10: fix KASAN warning

Mikulas Patocka <mpatocka@redhat.com>
    md-raid: destroy the bitmap after destroying the thread

Narendra Hadke <nhadke@marvell.com>
    serial: mvebu-uart: uart2 error bits clearing

Miklos Szeredi <mszeredi@redhat.com>
    fuse: limit nsec

Bikash Hazarika <bhazarika@marvell.com>
    scsi: qla2xxx: Zero undefined mailbox IN registers

Bikash Hazarika <bhazarika@marvell.com>
    scsi: qla2xxx: Fix incorrect display of max frame size

Tony Battersby <tonyb@cybernetics.com>
    scsi: sg: Allow waiting for commands to complete on removed device

Zheyu Ma <zheyuma97@gmail.com>
    iio: light: isl29028: Fix the warning in isl29028_remove()

Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
    mtd: rawnand: arasan: Update NAND bus clock instead of system clock

Leo Li <sunpeng.li@amd.com>
    drm/amdgpu: Check BO's requested pinning domains against its preferred_domains

Lyude Paul <lyude@redhat.com>
    drm/nouveau/acpi: Don't print error when we get -EINPROGRESS from pm_runtime

Lyude Paul <lyude@redhat.com>
    drm/nouveau: Don't pm_runtime_put_sync(), only pm_runtime_put_autosuspend()

Timur Tabi <ttabi@nvidia.com>
    drm/nouveau: fix another off-by-one in nvbios_addr

Phil Elwell <phil@raspberrypi.org>
    drm/vc4: hdmi: Disable audio if dmas property is present but empty

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/gem: Properly annotate WW context on drm_gem_lock_reservations() error

Helge Deller <deller@gmx.de>
    parisc: io_pgetevents_time64() needs compat syscall in 32-bit compat mode

William Dean <williamsukatube@gmail.com>
    parisc: Check the return value of ioremap() in lba_driver_probe()

Helge Deller <deller@gmx.de>
    parisc: Fix device names in /proc/iomem

Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
    ovl: drop WARN_ON() dentry is NULL in ovl_encode_fh()

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

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    mm/mremap: hold the rmap lock in write mode when moving page table entries.

Dave Chinner <dchinner@redhat.com>
    xfs: fix I_DONTCACHE

Darrick J. Wong <djwong@kernel.org>
    xfs: only set IOMAP_F_SHARED when providing a srcmap to a write

Dave Chinner <dchinner@redhat.com>
    mm: Add kvrealloc()

Dimitri John Ledkov <dimitri.ledkov@canonical.com>
    riscv: set default pm_power_off to NULL

Sean Christopherson <seanjc@google.com>
    KVM: x86: Tag kvm_mmu_x86_module_init() with __init

Sean Christopherson <seanjc@google.com>
    KVM: x86: Set error code to segment selector on LLDT/LTR non-canonical #GP

Sean Christopherson <seanjc@google.com>
    KVM: x86: Mark TSS busy during LTR emulation _after_ all fault checks

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Let userspace set nVMX MSR to any _host_ supported value

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
 Documentation/admin-guide/kernel-parameters.txt    |  29 +-
 Documentation/admin-guide/pm/cpuidle.rst           |  15 +-
 Documentation/driver-api/vfio.rst                  |  31 ++-
 Makefile                                           |   7 +-
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/aspeed-ast2500-evb.dts           |   2 +-
 arch/arm/boot/dts/aspeed-ast2600-evb.dts           |   2 +-
 arch/arm/boot/dts/bcm53015-meraki-mr26.dts         | 166 +++++++++++
 arch/arm/boot/dts/imx53-ppd.dts                    |   2 +-
 arch/arm/boot/dts/imx6dl-colibri-eval-v3.dts       |   2 +-
 arch/arm/boot/dts/imx6q-apalis-eval.dts            |   2 +-
 arch/arm/boot/dts/imx6q-apalis-ixora-v1.1.dts      |   2 +-
 arch/arm/boot/dts/imx6q-apalis-ixora.dts           |   2 +-
 arch/arm/boot/dts/imx6ul.dtsi                      |  33 +--
 arch/arm/boot/dts/imx7-colibri-aster.dtsi          |   2 +-
 arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi        |   2 +-
 arch/arm/boot/dts/imx7d-colibri-emmc.dtsi          |   4 +
 arch/arm/boot/dts/motorola-mapphone-common.dtsi    |   2 +-
 arch/arm/boot/dts/qcom-mdm9615.dtsi                |   1 +
 arch/arm/boot/dts/qcom-pm8841.dtsi                 |   1 +
 arch/arm/boot/dts/s5pv210-aries.dtsi               |   2 +-
 arch/arm/boot/dts/tegra20-acer-a500-picasso.dts    |   2 +-
 arch/arm/boot/dts/uniphier-pxs2.dtsi               |   8 +-
 arch/arm/lib/findbit.S                             |  16 +-
 arch/arm/mach-bcm/bcm_kona_smc.c                   |   1 +
 arch/arm/mach-omap2/display.c                      |   3 +
 arch/arm/mach-omap2/prm3xxx.c                      |   1 +
 arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c |   5 +-
 arch/arm/mach-zynq/common.c                        |   1 +
 .../boot/dts/allwinner/sun50i-a64-orangepi-win.dts |   2 +-
 .../boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts  |   2 +-
 arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi     |   2 +-
 arch/arm64/boot/dts/qcom/ipq8074.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/qcs404.dtsi               |   4 +-
 .../boot/dts/renesas/beacon-renesom-baseboard.dtsi |   6 +-
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi          |   2 +-
 arch/arm64/boot/dts/renesas/r8a77990.dtsi          |   2 +-
 arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi   |   8 +-
 arch/arm64/crypto/Kconfig                          |   1 +
 arch/arm64/include/asm/processor.h                 |   3 +-
 arch/arm64/kernel/armv8_deprecated.c               |   9 +-
 arch/arm64/kernel/cpufeature.c                     |   2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |   2 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |   2 +-
 arch/hexagon/Kconfig                               |   1 +
 arch/ia64/include/asm/processor.h                  |   2 +-
 arch/mips/kernel/proc.c                            |   2 +-
 arch/parisc/kernel/drivers.c                       |   9 +-
 arch/parisc/kernel/syscalls/syscall.tbl            |   2 +-
 arch/powerpc/kernel/Makefile                       |   1 +
 arch/powerpc/kernel/pci-common.c                   |  29 +-
 arch/powerpc/mm/ptdump/shared.c                    |   6 +-
 arch/powerpc/perf/core-book3s.c                    |  35 +--
 arch/powerpc/platforms/Kconfig.cputype             |   4 +-
 arch/powerpc/platforms/cell/axon_msi.c             |   1 +
 arch/powerpc/platforms/cell/spufs/inode.c          |   1 +
 arch/powerpc/platforms/powernv/rng.c               |   2 +
 arch/powerpc/sysdev/fsl_pci.c                      |   8 +
 arch/powerpc/sysdev/fsl_pci.h                      |   1 +
 arch/powerpc/sysdev/xive/spapr.c                   |   1 +
 arch/riscv/kernel/reset.c                          |  12 +-
 arch/s390/include/asm/gmap.h                       |   2 +
 arch/s390/kernel/asm-offsets.c                     |   2 +
 arch/s390/kernel/crash_dump.c                      |   2 +-
 arch/s390/kernel/machine_kexec_file.c              |  18 +-
 arch/s390/kernel/os_info.c                         |   3 +-
 arch/s390/kvm/intercept.c                          |  15 +
 arch/s390/kvm/pv.c                                 |   9 +-
 arch/s390/kvm/sigp.c                               |   4 +-
 arch/s390/mm/gmap.c                                |  86 ++++++
 arch/um/Kconfig                                    |   5 +
 arch/um/drivers/random.c                           |   2 +-
 arch/um/include/asm/archrandom.h                   |  30 ++
 arch/um/include/shared/kern_util.h                 |   2 +
 arch/um/include/shared/os.h                        |   8 +
 arch/um/kernel/um_arch.c                           |  33 +++
 arch/um/os-Linux/signal.c                          |  14 +-
 arch/um/os-Linux/util.c                            |   6 +
 arch/x86/boot/Makefile                             |   2 +-
 arch/x86/boot/compressed/Makefile                  |   2 +
 arch/x86/entry/Makefile                            |   3 +-
 arch/x86/entry/thunk_32.S                          |   2 -
 arch/x86/entry/thunk_64.S                          |   4 -
 arch/x86/entry/vdso/Makefile                       |   2 +-
 arch/x86/include/asm/kvm_host.h                    |   7 +-
 arch/x86/kernel/cpu/bugs.c                         |  10 +-
 arch/x86/kernel/ftrace.c                           |   1 +
 arch/x86/kernel/pmem.c                             |   7 +-
 arch/x86/kernel/process.c                          |   9 +-
 arch/x86/kvm/emulate.c                             |  23 +-
 arch/x86/kvm/hyperv.c                              |   3 +
 arch/x86/kvm/lapic.c                               |   4 +
 arch/x86/kvm/mmu/mmu.c                             |   2 +-
 arch/x86/kvm/pmu.c                                 |  36 ++-
 arch/x86/kvm/svm/pmu.c                             |   1 +
 arch/x86/kvm/svm/svm.c                             |  14 +-
 arch/x86/kvm/svm/svm.h                             |   2 +-
 arch/x86/kvm/vmx/nested.c                          |  99 ++++---
 arch/x86/kvm/vmx/pmu_intel.c                       |  28 +-
 arch/x86/kvm/vmx/vmx.c                             |  35 +--
 arch/x86/kvm/vmx/vmx.h                             |   2 +-
 arch/x86/kvm/x86.c                                 |  17 +-
 arch/x86/mm/numa.c                                 |   4 +-
 arch/x86/platform/olpc/olpc-xo1-sci.c              |   2 +-
 arch/x86/um/Makefile                               |   3 +-
 arch/xtensa/platforms/iss/network.c                |  42 +--
 block/bio.c                                        |   3 -
 block/blk-merge.c                                  |   2 +-
 block/blk-mq-debugfs.c                             |   3 +
 block/blk-mq-sched.c                               |   2 +-
 block/blk-mq.c                                     |   8 +-
 crypto/asymmetric_keys/public_key.c                |   7 +-
 drivers/acpi/acpi_lpss.c                           |   3 +
 drivers/acpi/apei/einj.c                           |   2 +
 drivers/acpi/cppc_acpi.c                           |  54 ++--
 drivers/acpi/ec.c                                  |  82 +-----
 drivers/acpi/processor_idle.c                      |   6 +-
 drivers/acpi/sleep.c                               |   8 +
 drivers/base/dd.c                                  |   5 +-
 drivers/block/null_blk_main.c                      |  14 +-
 drivers/block/xen-blkback/xenbus.c                 |  20 +-
 drivers/block/xen-blkfront.c                       |   4 +-
 drivers/bluetooth/hci_intel.c                      |   6 +-
 drivers/bus/hisi_lpc.c                             |  10 +-
 drivers/clk/mediatek/reset.c                       |   4 +-
 drivers/clk/qcom/camcc-sdm845.c                    |   4 +
 drivers/clk/qcom/clk-krait.c                       |   7 +-
 drivers/clk/qcom/gcc-ipq8074.c                     |  60 +++-
 drivers/clk/renesas/r9a06g032-clocks.c             |   8 +-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |   1 +
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |  22 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c  |  15 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h       |   4 +
 drivers/crypto/ccp/sev-dev.c                       |   2 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |   2 +-
 drivers/crypto/hisilicon/sec/sec_algs.c            |  14 +-
 drivers/crypto/hisilicon/sec/sec_drv.h             |   2 +-
 drivers/crypto/hisilicon/sec2/sec.h                |   7 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |  97 ++++---
 drivers/crypto/hisilicon/sec2/sec_crypto.h         |   3 +-
 drivers/crypto/inside-secure/safexcel.c            |   2 +
 drivers/dma/dw-edma/dw-edma-core.c                 |   2 +-
 drivers/dma/sf-pdma/sf-pdma.c                      |  49 ++--
 drivers/firmware/arm_scpi.c                        |  61 ++--
 drivers/firmware/tegra/bpmp-debugfs.c              |  10 +-
 drivers/fpga/altera-pr-ip-core.c                   |   2 +-
 drivers/gpio/gpiolib-of.c                          |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   4 +
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |  24 +-
 drivers/gpu/drm/bridge/sil-sii8620.c               |   4 +-
 drivers/gpu/drm/bridge/tc358767.c                  |  62 +++--
 drivers/gpu/drm/drm_gem.c                          |   4 +-
 drivers/gpu/drm/drm_mipi_dbi.c                     |   7 +
 drivers/gpu/drm/exynos/exynos7_drm_decon.c         |  17 +-
 .../gpu/drm/i915/display/intel_display_debugfs.c   |   4 +-
 drivers/gpu/drm/i915/i915_reg.h                    |   3 +-
 drivers/gpu/drm/mcde/mcde_dsi.c                    |   1 +
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |  33 +--
 drivers/gpu/drm/mediatek/mtk_dsi.c                 | 126 ++++++---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c          |   3 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |   4 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c    |   2 +-
 drivers/gpu/drm/radeon/.gitignore                  |   2 +-
 drivers/gpu/drm/radeon/Kconfig                     |   2 +-
 drivers/gpu/drm/radeon/Makefile                    |   2 +-
 drivers/gpu/drm/radeon/ni_dpm.c                    |   6 +-
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c    |  10 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |   3 +
 drivers/gpu/drm/tiny/st7735r.c                     |   1 +
 drivers/gpu/drm/vc4/vc4_crtc.c                     |  10 +-
 drivers/gpu/drm/vc4/vc4_drv.c                      |  19 ++
 drivers/gpu/drm/vc4/vc4_drv.h                      |   1 -
 drivers/gpu/drm/vc4/vc4_dsi.c                      | 208 +++++++++-----
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  50 ++--
 drivers/gpu/drm/vc4/vc4_plane.c                    |  30 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |   6 +-
 drivers/hid/hid-alps.c                             |   2 +
 drivers/hid/hid-cp2112.c                           |   5 +
 drivers/hid/hid-ids.h                              |   2 +
 drivers/hid/hid-input.c                            |   4 +
 drivers/hid/hid-mcp2221.c                          |   3 +
 drivers/hid/wacom_sys.c                            |   2 +-
 drivers/hid/wacom_wac.c                            |  72 +++--
 drivers/hwmon/drivetemp.c                          |   1 +
 drivers/hwtracing/coresight/coresight-core.c       |   1 +
 drivers/hwtracing/intel_th/msu-sink.c              |   3 +
 drivers/hwtracing/intel_th/msu.c                   |  14 +-
 drivers/hwtracing/intel_th/pci.c                   |  25 +-
 drivers/i2c/busses/i2c-cadence.c                   |  10 +-
 drivers/i2c/busses/i2c-npcm7xx.c                   |  50 ++--
 drivers/i2c/i2c-core-base.c                        |   3 +-
 drivers/i2c/muxes/i2c-mux-gpmux.c                  |   1 +
 drivers/iio/accel/bma400.h                         |  23 +-
 drivers/iio/accel/bma400_core.c                    |   4 +-
 drivers/iio/light/isl29028.c                       |   2 +-
 drivers/infiniband/hw/hfi1/file_ops.c              |   4 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   4 +-
 drivers/infiniband/hw/mlx5/fs.c                    |   6 +-
 drivers/infiniband/hw/qedr/verbs.c                 |  26 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |  12 +-
 drivers/infiniband/sw/siw/siw_cm.c                 |   7 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |   5 -
 drivers/infiniband/ulp/rtrs/rtrs-pri.h             |  22 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |   4 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              | 148 +++++++---
 drivers/infiniband/ulp/srpt/ib_srpt.h              |  18 +-
 drivers/input/serio/gscps2.c                       |   4 +
 drivers/input/touchscreen/atmel_mxt_ts.c           |   6 +-
 drivers/interconnect/imx/imx.c                     |   8 +-
 drivers/iommu/arm/arm-smmu/qcom_iommu.c            |   7 +-
 drivers/iommu/exynos-iommu.c                       |   6 +-
 drivers/iommu/intel/dmar.c                         |   2 +-
 drivers/irqchip/Kconfig                            |   5 +-
 drivers/irqchip/irq-mips-gic.c                     |  84 ++++--
 drivers/md/dm-raid.c                               |   4 +-
 drivers/md/dm-rq.c                                 |   2 +-
 drivers/md/dm-thin-metadata.c                      |   7 +-
 drivers/md/dm-thin.c                               |   4 +-
 drivers/md/dm-writecache.c                         |   2 +-
 drivers/md/dm.c                                    |   5 +
 drivers/md/md.c                                    |   2 +-
 drivers/md/raid10.c                                |   5 +-
 drivers/media/pci/tw686x/tw686x-core.c             |  18 +-
 drivers/media/pci/tw686x/tw686x-video.c            |   4 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h       |   2 +
 drivers/media/usb/hdpvr/hdpvr-video.c              |   2 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   2 +-
 drivers/memstick/core/ms_block.c                   |  11 +-
 drivers/mfd/max77620.c                             |   2 +
 drivers/mfd/t7l66xb.c                              |   6 +-
 drivers/misc/cardreader/rtsx_pcr.c                 |   6 +-
 drivers/misc/eeprom/idt_89hpesx.c                  |   8 +-
 drivers/mmc/core/block.c                           |  28 +-
 drivers/mmc/host/cavium-octeon.c                   |   1 +
 drivers/mmc/host/cavium-thunderx.c                 |   4 +-
 drivers/mmc/host/sdhci-of-at91.c                   |   9 +-
 drivers/mmc/host/sdhci-of-esdhc.c                  |   1 +
 drivers/mtd/devices/st_spi_fsm.c                   |   8 +-
 drivers/mtd/maps/physmap-versatile.c               |   2 +
 drivers/mtd/nand/raw/arasan-nand-controller.c      |  57 +++-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |   2 +-
 drivers/mtd/nand/raw/meson_nand.c                  |   1 -
 drivers/mtd/nand/raw/nand_timings.c                | 255 +++++++++++++++++
 drivers/mtd/parsers/redboot.c                      |   1 +
 drivers/mtd/sm_ftl.c                               |   2 +-
 drivers/net/can/pch_can.c                          |   8 +-
 drivers/net/can/rcar/rcar_can.c                    |   8 +-
 drivers/net/can/sja1000/sja1000.c                  |   7 +-
 drivers/net/can/spi/hi311x.c                       |   5 +-
 drivers/net/can/sun4i_can.c                        |   9 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |  12 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |   6 +-
 drivers/net/can/usb/usb_8dev.c                     |   7 +-
 drivers/net/ethernet/huawei/hinic/hinic_dev.h      |   3 -
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |  68 ++---
 drivers/net/ethernet/huawei/hinic/hinic_rx.c       |   2 -
 drivers/net/ethernet/huawei/hinic/hinic_tx.c       |   2 -
 drivers/net/ethernet/intel/iavf/iavf.h             |   1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  25 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |   2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   2 +-
 drivers/net/netdevsim/bpf.c                        |   8 +-
 drivers/net/usb/ax88179_178a.c                     |  20 +-
 drivers/net/usb/smsc95xx.c                         |  20 +-
 drivers/net/usb/usbnet.c                           |   8 +-
 drivers/net/wireguard/allowedips.c                 |   9 +-
 drivers/net/wireguard/selftest/allowedips.c        |   6 +-
 drivers/net/wireguard/selftest/ratelimiter.c       |  25 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   5 +-
 drivers/net/wireless/ath/ath11k/core.c             |  16 +-
 drivers/net/wireless/ath/ath11k/debug.h            |   4 +-
 drivers/net/wireless/ath/ath9k/htc.h               |  10 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   3 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |  18 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   1 +
 drivers/net/wireless/intersil/p54/main.c           |   2 +-
 drivers/net/wireless/intersil/p54/p54spi.c         |   3 +-
 drivers/net/wireless/mac80211_hwsim.c              |  14 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |   1 +
 drivers/net/wireless/marvell/mwifiex/main.h        |   2 +
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   3 +
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |   3 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   1 +
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |   2 +-
 drivers/net/wireless/realtek/rtlwifi/debug.c       |   8 +-
 drivers/nvme/host/trace.h                          |   2 +-
 drivers/opp/core.c                                 |   4 +-
 drivers/parisc/lba_pci.c                           |   6 +-
 drivers/pci/controller/dwc/pcie-designware-ep.c    |  18 +-
 drivers/pci/controller/dwc/pcie-designware.c       |  30 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |  10 +-
 drivers/pci/controller/dwc/pcie-tegra194.c         |  49 ++--
 drivers/pci/endpoint/functions/pci-epf-test.c      |   1 -
 drivers/pci/pci.h                                  |   4 +-
 drivers/pci/pcie/aer.c                             |  79 ++++--
 drivers/pci/pcie/err.c                             |  85 ++++--
 drivers/pci/pcie/portdrv_core.c                    |   9 +-
 drivers/pci/pcie/portdrv_pci.c                     |  10 +-
 drivers/perf/arm_spe_pmu.c                         |  22 +-
 drivers/platform/chrome/cros_ec.c                  |   8 +-
 drivers/platform/olpc/olpc-ec.c                    |   2 +-
 drivers/pwm/pwm-lpc18xx-sct.c                      |   4 +-
 drivers/pwm/pwm-sifive.c                           |  65 +++--
 drivers/regulator/of_regulator.c                   |   6 +-
 drivers/regulator/qcom_smd-regulator.c             |   4 +-
 drivers/remoteproc/qcom_sysmon.c                   |  10 +
 drivers/remoteproc/qcom_wcnss.c                    |  10 +-
 drivers/remoteproc/ti_k3_r5_remoteproc.c           |   2 +
 drivers/rpmsg/mtk_rpmsg.c                          |   2 +
 drivers/rpmsg/qcom_smd.c                           |   1 +
 drivers/s390/char/zcore.c                          |  11 +-
 drivers/s390/cio/vfio_ccw_drv.c                    |  14 +-
 drivers/s390/scsi/zfcp_fc.c                        |  29 +-
 drivers/s390/scsi/zfcp_fc.h                        |   6 +-
 drivers/s390/scsi/zfcp_fsf.c                       |   7 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   5 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |   3 +-
 drivers/scsi/qla2xxx/qla_gs.c                      |  11 +-
 drivers/scsi/qla2xxx/qla_init.c                    |  48 +++-
 drivers/scsi/qla2xxx/qla_isr.c                     |  20 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |  19 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   5 -
 drivers/scsi/sg.c                                  |  53 ++--
 drivers/scsi/smartpqi/smartpqi_init.c              |   4 +-
 drivers/soc/amlogic/meson-mx-socinfo.c             |   1 +
 drivers/soc/amlogic/meson-secure-pwrc.c            |   4 +-
 drivers/soc/fsl/guts.c                             |   2 +-
 drivers/soc/qcom/Kconfig                           |   1 +
 drivers/soc/qcom/ocmem.c                           |   3 +
 drivers/soc/qcom/qcom_aoss.c                       |   4 +-
 drivers/soc/renesas/r8a779a0-sysc.c                |  10 +-
 drivers/soundwire/bus_type.c                       |   8 +-
 drivers/spi/spi-rspi.c                             |   4 +
 drivers/spi/spi-synquacer.c                        |   1 +
 drivers/staging/media/atomisp/pci/atomisp_cmd.c    |  57 ++--
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c   |   3 +
 drivers/staging/rtl8192u/r8192U.h                  |   2 +-
 drivers/staging/rtl8192u/r8192U_dm.c               |  38 ++-
 drivers/staging/rtl8192u/r8192U_dm.h               |   2 +-
 drivers/tee/tee_shm.c                              |   3 +
 drivers/thermal/thermal_sysfs.c                    |  10 +-
 drivers/tty/n_gsm.c                                | 199 ++++++++++---
 drivers/tty/serial/8250/8250.h                     |  22 ++
 drivers/tty/serial/8250/8250_dw.c                  |   3 +
 drivers/tty/serial/8250/8250_pci.c                 | 308 ++++++++++-----------
 drivers/tty/serial/8250/8250_port.c                |  21 --
 drivers/tty/serial/mvebu-uart.c                    |  11 +
 drivers/tty/vt/vt.c                                |   2 +-
 drivers/usb/cdns3/gadget.c                         |  11 +-
 drivers/usb/core/hcd.c                             |  26 +-
 drivers/usb/dwc3/core.c                            |   9 +-
 drivers/usb/dwc3/dwc3-qcom.c                       |   4 +-
 drivers/usb/dwc3/gadget.c                          |  92 +++---
 drivers/usb/gadget/udc/Kconfig                     |   2 +-
 drivers/usb/gadget/udc/aspeed-vhub/hub.c           |   4 +-
 drivers/usb/gadget/udc/tegra-xudc.c                |   8 +-
 drivers/usb/host/ehci-ppc-of.c                     |   1 +
 drivers/usb/host/ohci-nxp.c                        |   1 +
 drivers/usb/host/xhci-tegra.c                      |   8 +-
 drivers/usb/host/xhci.h                            |   2 +-
 drivers/usb/serial/sierra.c                        |   3 +-
 drivers/usb/serial/usb-serial.c                    |   2 +-
 drivers/usb/serial/usb_wwan.c                      |   3 +-
 drivers/usb/typec/ucsi/ucsi.c                      |   4 +
 drivers/vfio/mdev/mdev_private.h                   |   5 +-
 drivers/vfio/vfio.c                                | 207 ++++++--------
 drivers/video/fbdev/amba-clcd.c                    |  24 +-
 drivers/video/fbdev/arkfb.c                        |   9 +-
 drivers/video/fbdev/core/fbcon.c                   |  12 +-
 drivers/video/fbdev/s3fb.c                         |   2 +
 drivers/video/fbdev/sis/init.c                     |   4 +-
 drivers/video/fbdev/vt8623fb.c                     |   2 +
 drivers/watchdog/armada_37xx_wdt.c                 |   2 +
 fs/attr.c                                          |   2 +
 fs/btrfs/block-group.c                             |   1 +
 fs/btrfs/disk-io.c                                 |  14 +
 fs/btrfs/raid56.c                                  |  74 +++--
 fs/erofs/decompressor.c                            |  16 +-
 fs/eventpoll.c                                     |  22 ++
 fs/exec.c                                          |   3 +
 fs/ext2/super.c                                    |  12 +-
 fs/ext4/inline.c                                   |   3 +
 fs/ext4/inode.c                                    |  22 +-
 fs/ext4/migrate.c                                  |   4 +-
 fs/ext4/namei.c                                    |  23 ++
 fs/ext4/resize.c                                   |   1 +
 fs/ext4/xattr.c                                    |   6 +-
 fs/ext4/xattr.h                                    |  13 +
 fs/f2fs/file.c                                     |   9 +-
 fs/f2fs/gc.c                                       |  41 +--
 fs/fuse/control.c                                  |   4 +-
 fs/fuse/inode.c                                    |   6 +
 fs/jbd2/commit.c                                   |   2 +-
 fs/jbd2/transaction.c                              |  14 +-
 fs/namei.c                                         |   4 +
 fs/nfs/nfs3client.c                                |   1 -
 fs/overlayfs/export.c                              |   2 +-
 fs/splice.c                                        |  10 +-
 fs/xfs/xfs_icache.c                                |   3 +-
 fs/xfs/xfs_iomap.c                                 |   8 +-
 fs/xfs/xfs_iops.c                                  |   2 +-
 fs/xfs/xfs_log_recover.c                           |   4 +-
 include/acpi/cppc_acpi.h                           |   2 +-
 include/linux/bitmap.h                             |  12 +-
 include/linux/blktrace_api.h                       |   5 +-
 include/linux/buffer_head.h                        |  25 +-
 include/linux/kfifo.h                              |   2 +-
 include/linux/kvm_host.h                           |  28 +-
 include/linux/lockdep.h                            |  30 +-
 include/linux/mfd/t7l66xb.h                        |   1 -
 include/linux/mm.h                                 |   2 +
 include/linux/mtd/rawnand.h                        | 123 +++++++-
 include/linux/pci_ids.h                            |   3 +
 include/linux/sched.h                              |   2 +-
 include/linux/tpm_eventlog.h                       |   2 +-
 include/linux/usb/hcd.h                            |   1 +
 include/linux/vfio.h                               |  16 ++
 include/linux/wait.h                               |   9 +-
 include/net/inet6_hashtables.h                     |  27 +-
 include/net/inet_hashtables.h                      |  44 +--
 include/net/inet_sock.h                            |  18 +-
 include/net/sock.h                                 |  15 +-
 include/trace/events/block.h                       |  30 +-
 include/trace/events/spmi.h                        |  12 +-
 include/trace/trace_events.h                       |   8 +-
 include/uapi/linux/can/error.h                     |   5 +-
 include/uapi/linux/netfilter/xt_IDLETIMER.h        |  17 +-
 include/uapi/linux/pci_regs.h                      |   7 +
 kernel/bpf/verifier.c                              |   4 +-
 kernel/cgroup/cpuset.c                             |   2 +-
 kernel/irq/Kconfig                                 |   1 +
 kernel/irq/chip.c                                  |   3 +-
 kernel/kprobes.c                                   |   3 +-
 kernel/locking/lockdep.c                           |   9 +-
 kernel/locking/lockdep_internals.h                 |   8 +-
 kernel/power/user.c                                |  13 +-
 kernel/profile.c                                   |   7 +
 kernel/sched/core.c                                |  34 ++-
 kernel/sched/deadline.c                            |  52 +---
 kernel/sched/rt.c                                  |  15 +-
 kernel/sched/sched.h                               |   3 +-
 kernel/time/hrtimer.c                              |   1 +
 kernel/time/timekeeping.c                          |   7 +-
 kernel/trace/blktrace.c                            |  46 ++-
 lib/Kconfig.debug                                  |  40 +++
 lib/bitmap.c                                       |  42 ++-
 lib/livepatch/test_klp_callbacks_busy.c            |   8 +
 lib/smp_processor_id.c                             |   2 +-
 lib/test_bpf.c                                     |   4 +-
 mm/mmap.c                                          |   1 -
 mm/mremap.c                                        |   6 +-
 mm/util.c                                          |  15 +
 net/9p/client.c                                    |   5 +-
 net/bluetooth/l2cap_core.c                         |  13 +-
 net/dccp/proto.c                                   |  10 +-
 net/ipv4/inet_hashtables.c                         |  17 +-
 net/ipv4/tcp_output.c                              |  30 +-
 net/ipv4/udp.c                                     |   3 +-
 net/ipv6/inet6_hashtables.c                        |   6 +-
 net/ipv6/udp.c                                     |   2 +-
 net/mac80211/sta_info.c                            |   6 +-
 net/netfilter/nf_tables_api.c                      |  18 +-
 net/rose/af_rose.c                                 |  11 +-
 net/rose/rose_route.c                              |   2 +
 net/sched/cls_route.c                              |  12 +-
 scripts/faddr2line                                 |   4 +-
 security/selinux/ss/policydb.h                     |   2 +
 sound/pci/hda/patch_cirrus.c                       |   1 +
 sound/pci/hda/patch_conexant.c                     |  11 +-
 sound/pci/hda/patch_realtek.c                      |  15 +
 sound/soc/atmel/mchp-spdifrx.c                     |   9 +-
 sound/soc/codecs/cros_ec_codec.c                   |   1 +
 sound/soc/codecs/da7210.c                          |   2 +
 sound/soc/codecs/msm8916-wcd-digital.c             |  46 +--
 sound/soc/codecs/wcd9335.c                         |  81 +++---
 sound/soc/fsl/fsl_easrc.c                          |   9 +-
 sound/soc/fsl/fsl_easrc.h                          |   2 +-
 sound/soc/generic/audio-graph-card.c               |   4 +-
 sound/soc/mediatek/mt6797/mt6797-mt6351.c          |   6 +-
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c   |  10 +-
 sound/soc/mediatek/mt8173/mt8173-rt5650.c          |   9 +-
 sound/soc/qcom/lpass-cpu.c                         |   1 +
 sound/soc/qcom/qdsp6/q6adm.c                       |   2 +-
 sound/soc/samsung/aries_wm8994.c                   |   6 +-
 sound/soc/samsung/h1940_uda1380.c                  |   2 +-
 sound/soc/samsung/rx1950_uda1380.c                 |   4 +-
 sound/usb/bcd2000/bcd2000.c                        |   3 +-
 tools/lib/bpf/libbpf.c                             |   9 +-
 tools/lib/bpf/xsk.c                                |   9 +-
 tools/perf/util/dsos.c                             |  15 +-
 tools/perf/util/genelf.c                           |   6 +-
 tools/perf/util/symbol-elf.c                       |  27 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |   2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   2 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |   2 +-
 .../testing/selftests/timers/clocksource-switch.c  |   6 +-
 tools/testing/selftests/timers/valid-adjtimex.c    |   2 +-
 tools/thermal/tmon/sysfs.c                         |  24 +-
 tools/thermal/tmon/tmon.h                          |   3 +
 virt/kvm/kvm_main.c                                |  26 +-
 505 files changed, 4771 insertions(+), 2498 deletions(-)


