Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB3B4A423A
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349510AbiAaLLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53918 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359825AbiAaLIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:08:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4CA6B82A5C;
        Mon, 31 Jan 2022 11:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C92C340E8;
        Mon, 31 Jan 2022 11:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627277;
        bh=rCdzKnuGCcgWQTHgThxFmvg5yTdl4t152YKtf1HQpY0=;
        h=From:To:Cc:Subject:Date:From;
        b=hRpofqlYDCVBhF4E0Kfeuc5/RaHutVTYL0CZTNI12a6FaBwZ28DuaV3PG4wd6SOy+
         pkPtgfHJnQsdh6CfaxNM9nBSArcGNeZEiYV8XBkF53ArLa0AxsRsY7PQX3BI8tBNdN
         tfjNNSw4YN1Vx07zpeUJshLUnlewkxeswo5Kaz6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
Subject: [PATCH 5.15 000/171] 5.15.19-rc1 review
Date:   Mon, 31 Jan 2022 11:54:25 +0100
Message-Id: <20220131105229.959216821@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.19-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.19-rc1
X-KernelTest-Deadline: 2022-02-02T10:52+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.19 release.
There are 171 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.19-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.19-rc1

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    block: Fix wrong offset in bio_truncate()

Amir Goldstein <amir73il@gmail.com>
    fsnotify: invalidate dcache before IN_DELETE event

Dmitry V. Levin <ldv@altlinux.org>
    usr/include/Makefile: add linux/nfc.h to the compile-test coverage

Robert Hancock <robert.hancock@calian.com>
    usb: dwc3: xilinx: fix uninitialized return value

Suren Baghdasaryan <surenb@google.com>
    psi: fix "defined but not used" warnings when CONFIG_PROC_FS=n

Suren Baghdasaryan <surenb@google.com>
    psi: fix "no previous prototype" warnings when CONFIG_CGROUPS=n

Namhyung Kim <namhyung@kernel.org>
    perf/core: Fix cgroup event list management

Marc Kleine-Budde <mkl@pengutronix.de>
    dt-bindings: can: tcan4x5x: fix mram-cfg RX FIFO config

Sander Vanheule <sander@svanheule.net>
    irqchip/realtek-rtl: Fix off-by-one in routing

Sander Vanheule <sander@svanheule.net>
    irqchip/realtek-rtl: Map control data to virq

Brian Gix <brian.gix@intel.com>
    Bluetooth: refactor malicious adv data check

Tim Yi <tim.yi@pica8.com>
    net: bridge: vlan: fix memory leak in __allowed_ingress

Eric Dumazet <edumazet@google.com>
    ipv4: remove sparse error in ip_neigh_gw4()

Eric Dumazet <edumazet@google.com>
    ipv4: tcp: send zero IPID in SYNACK messages

Eric Dumazet <edumazet@google.com>
    ipv4: raw: lock the socket in raw_bind()

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: bridge: vlan: fix single net device option dumping

Guillaume Nault <gnault@redhat.com>
    Revert "ipv6: Honor all IPv6 PIO Valid Lifetime values"

Catherine Sullivan <csully@google.com>
    gve: Fix GFP flags when allocing pages

Xiubo Li <xiubli@redhat.com>
    ceph: put the requests/sessions when it fails to alloc memory

Sean Christopherson <seanjc@google.com>
    KVM: selftests: Don't skip L2's VMCALL in SMM test for SVM guest

Dave Airlie <airlied@redhat.com>
    Revert "drm/ast: Support 1600x900 with 108MHz PCLK"

Maxim Mikityanskiy <maximmi@nvidia.com>
    sch_htb: Fail on unsupported parameters when offload is requested

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: handle empty unknown interrupt for VF

Toke Høiland-Jørgensen <toke@redhat.com>
    net: cpsw: Properly initialise struct page_pool_params

Hangyu Hua <hbh25y@gmail.com>
    yam: fix a memory leak in yam_siocdevprivate()

Rob Clark <robdclark@chromium.org>
    drm/msm/a6xx: Add missing suspend_count increment

José Expósito <jose.exposito89@gmail.com>
    drm/msm/dpu: invalid parameter check in dpu_setup_dspp_pcc

Miaoqian Lin <linmq006@gmail.com>
    drm/msm/hdmi: Fix missing put_device() call in msm_hdmi_get_phy

Marc Kleine-Budde <mkl@pengutronix.de>
    can: tcan4x5x: regmap: fix max register value

Michael Kelley <mikelley@microsoft.com>
    video: hyperv_fb: Fix validation of screen resolution

Wen Gu <guwen@linux.alibaba.com>
    net/smc: Transitional solution for clcsock race issue

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: don't spin in tasklet

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: init ->running_cap_crqs early

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: Allow extra failures before disabling

Jakub Kicinski <kuba@kernel.org>
    ipv4: fix ip option filtering for locally generated fragments

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Fix power_pmu_disable to call clear_pmi_irq_pending only if PMI is pending

Dan Carpenter <dan.carpenter@oracle.com>
    hwmon: (adt7470) Prevent divide by zero in adt7470_fan_write()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Fix sysfs and udev notifications

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Mark alert as broken for MAX6654

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Re-enable interrupts after alert clears

Yanming Liu <yanminglr@gmail.com>
    Drivers: hv: balloon: account for vmbus packet header in max_pkt_size

Dylan Yudaken <dylany@fb.com>
    io_uring: fix bug in slow unregistering of nodes

Mihai Carabas <mihai.carabas@oracle.com>
    efi/libstub: arm64: Fix image check alignment at entry

David Howells <dhowells@redhat.com>
    rxrpc: Adjust retransmission backoff

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-pf: Forward error codes to VF

Geetha sowjanya <gakula@marvell.com>
    octeontx2-af: cn10k: Do not enable RPM loopback for LPC interfaces

Geetha sowjanya <gakula@marvell.com>
    octeontx2-af: Increase link credit restore polling timeout

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: verify CQ context updates

Geetha sowjanya <gakula@marvell.com>
    octeontx2-pf: cn10k: Ensure valid pointers are freed to aura

Geetha sowjanya <gakula@marvell.com>
    octeontx2-af: Retry until RVU block reset complete

Sunil Goutham <sgoutham@marvell.com>
    octeontx2-af: Fix LBK backpressure id count

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Do not fixup all VF action entries

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: fix ipv6 routing setup

Geliang Tang <geliang.tang@suse.com>
    mptcp: fix removing ids bitmap setting

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix msk traversal in mptcp_nl_cmd_set_flags()

Paolo Abeni <pabeni@redhat.com>
    mptcp: keep track of local endpoint still available for each msk

Jean Sacren <sakiwit@gmail.com>
    mptcp: clean up harmless false expressions

Davide Caratti <dcaratti@redhat.com>
    mptcp: allow changing the "backup" bit by endpoint id

Marek Behún <kabel@kernel.org>
    phylib: fix potential use-after-free

Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
    net: stmmac: dwmac-visconti: Fix clock configuration for RMII mode

Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
    net: stmmac: dwmac-visconti: Fix bit definitions for ETHER_CLK_SEL

Robert Hancock <robert.hancock@calian.com>
    net: phy: broadcom: hook up soft_reset for BCM54616S

Vincent Guittot <vincent.guittot@linaro.org>
    sched/pelt: Relax the sync of util_sum with util_avg

Peter Zijlstra <peterz@infradead.org>
    perf: Fix perf_event_read_local() time

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: Mask SRR0 before checking against the masked NIP

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: don't increment invalid counter on NF_REPEAT

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc64/bpf: Limit 'ldbrx' to processors compliant with ISA v2.06

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Don't dereference xprt->snd_task if it's a cookie

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Use BIT() macro in rpc_show_xprt_state()

Marc Zyngier <maz@kernel.org>
    KVM: arm64: pkvm: Use the mm_ops indirection for cache maintenance

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Ensure the server has an up to date ctime before renaming

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Ensure the server has an up to date ctime before hardlinking

Eric Dumazet <edumazet@google.com>
    ipv6: annotate accesses to fn->fn_sernum

José Expósito <jose.exposito89@gmail.com>
    drm/msm/dsi: invalid parameter check in msm_dsi_phy_enable

Miaoqian Lin <linmq006@gmail.com>
    drm/msm/dsi: Fix missing put_device() call in dsi_get_phy

Xianting Tian <xianting.tian@linux.alibaba.com>
    drm/msm: Fix wrong size calculation

Jianguo Wu <wujianguo@chinatelecom.cn>
    net-procfs: show net devices bound packet types

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: nfs_atomic_open() can race when looking up a non-regular file

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Handle case where the lookup of a directory fails

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Reduce maximum conversion rate for G781

Eric Dumazet <edumazet@google.com>
    ipv4: avoid using shared IP generator for connected sockets

Xin Long <lucien.xin@gmail.com>
    ping: fix the sk_bound_dev_if match in ping_lookup

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Mark alert as broken for MAX6680

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Mark alert as broken for MAX6646/6647/6649

Congyu Liu <liu3101@purdue.edu>
    net: fix information leakage in /proc/net/ptype

sparkhuang <huangshaobo6@huawei.com>
    ARM: 9170/1: fix panic when kasan and kprobe are enabled

Ido Schimmel <idosch@nvidia.com>
    ipv6_tunnel: Rate limit warning messages

John Meneghini <jmeneghi@redhat.com>
    scsi: bnx2fc: Flush destroy_work queue before calling bnx2fc_interface_put()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: elx: efct: Don't use GFP_KERNEL under spin lock

Matthias Kaehlcke <mka@chromium.org>
    rpmsg: char: Fix race between the release of rpmsg_eptdev and cdev

Sujit Kautkar <sujitka@chromium.org>
    rpmsg: char: Fix race between the release of rpmsg_ctrldev and cdev

Linyu Yuan <quic_linyyuan@quicinc.com>
    usb: roles: fix include/linux/usb/role.h compile issue

Joe Damato <jdamato@fastly.com>
    i40e: fix unsigned stat widths

Karen Sornek <karen.sornek@intel.com>
    i40e: Fix for failed to init adminq while VF reset

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    i40e: Fix queues reservation for XDP

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    i40e: Fix issue when maximum queues is exceeded

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    i40e: Increase delay to 1 s after global EMP reset

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Fix boot failure with GCC latent entropy plugin

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32s: Fix kasan_init_region() for KASAN

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32s: Allocate one 256k IBAT instead of two consecutives 128k IBATs

Tony Luck <tony.luck@intel.com>
    x86/cpu: Add Xeon Icelake-D to list of CPUs that support PPIN

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/MCE/AMD: Allow thresholding interface updates after init

Bjorn Helgaas <bhelgaas@google.com>
    PCI/sysfs: Find shadow ROM before static attribute initialization

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    sched/membarrier: Fix membarrier-rseq fence command missing from query bitmask

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix a deadlock when commit trans

Joseph Qi <joseph.qi@linux.alibaba.com>
    jbd2: export jbd2_journal_[grab|put]_journal_head

Peter Collingbourne <pcc@google.com>
    mm, kasan: use compare-exchange operation to set KASAN page tag

Sing-Han Chen <singhanc@nvidia.com>
    ucsi_ccg: Check DEV_INT bit only when starting CCG4

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Do not disconnect when receiving VSAFE0V

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Do not disconnect while receiving VBUS off

Xu Yang <xu.yang_2@nxp.com>
    usb: typec: tcpci: don't touch CC line if it's Vconn source

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix hang in usb_kill_urb by adding memory barriers

Robert Hancock <robert.hancock@calian.com>
    usb: dwc3: xilinx: Fix error handling when getting USB3 PHY

Robert Hancock <robert.hancock@calian.com>
    usb: dwc3: xilinx: Skip resets and USB3 register settings for USB2.0 mode

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix segmentation fault in cdns_lost_power function

Pavankumar Kondeti <quic_pkondeti@quicinc.com>
    usb: gadget: f_sourcesink: Fix isoc transfer for USB_SPEED_SUPER_PLUS

Jon Hunter <jonathanh@nvidia.com>
    usb: common: ulpi: Fix crash in ulpi_match()

Frank Li <Frank.Li@nxp.com>
    usb: xhci-plat: fix crash when suspend if remote wake enable

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: Add unusual-devs entry for VL817 USB-SATA bridge

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kbuild: remove include/linux/cyclades.h from header file check

Cameron Williams <cang1@live.co.uk>
    tty: Add support for Brainboxes UC cards.

Maciej W. Rozycki <macro@embecosm.com>
    tty: Partially revert the removal of the Cyclades public API

daniel.starke@siemens.com <daniel.starke@siemens.com>
    tty: n_gsm: fix SW flow control encoding/handling

Valentin Caron <valentin.caron@foss.st.com>
    serial: stm32: fix software flow control transfer

Robert Hancock <robert.hancock@calian.com>
    serial: 8250: of: Fix mapped region size when using reg-offset property

Jochen Mades <jochen@mades.net>
    serial: pl011: Fix incorrect rs485 RTS polarity on set_mctrl

Mike Snitzer <snitzer@redhat.com>
    dm: properly fix redundant bio-based IO accounting

Mike Snitzer <snitzer@redhat.com>
    block: add bio_start_io_acct_time() to control start_time

Mike Snitzer <snitzer@redhat.com>
    dm: revert partial fix for redundant bio-based IO accounting

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Book3S HV Nested: Fix nested HFSCR being clobbered with multiple vCPUs

Like Xu <likexu@tencent.com>
    KVM: x86: Sync the states size with the XCR0/IA32_XSS at, any time

Like Xu <likexu@tencent.com>
    KVM: x86: Update vCPU's runtime CPUID on write to MSR_IA32_XSS

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: x86: Keep MSR_IA32_XSS unchanged for INIT

Sean Christopherson <seanjc@google.com>
    KVM: x86: Forcibly leave nested virt when SMM state is toggled

Denis Valeev <lemniscattaden@gmail.com>
    KVM: x86: nSVM: skip eax alignment check for non-SVM instructions

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Don't intercept #GP for SEV guests

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Never reject emulation due to SMAP errata for !SEV guests

Wanpeng Li <wanpengli@tencent.com>
    KVM: LAPIC: Also cancel preemption timer during SET_LAPIC

Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
    drm/amd/display: Fix FP start/end for dcn30_internal_validate_bw.

Manasi Navare <manasi.d.navare@intel.com>
    drm/atomic: Add the crtc to affected crtc only if uapi.enable = true

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: relax submit size limits

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Add a quirk for the calculation of the number of counters on Alder Lake

Zhengjun Xing <zhengjun.xing@linux.intel.com>
    perf/x86/intel/uncore: Fix CAS_COUNT_WRITE issue for ICX

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/audit: Fix syscall_get_arch()

Suren Baghdasaryan <surenb@google.com>
    psi: Fix uaf issue when psi trigger is destroyed while being polled

Sean Christopherson <seanjc@google.com>
    Revert "KVM: SVM: avoid infinite loop on NPF from bad address"

Amir Goldstein <amir73il@gmail.com>
    fsnotify: fix fsnotify hooks in pseudo filesystems

Jeff Layton <jlayton@kernel.org>
    ceph: set pool_ns in new inode layout for async creates

Jeff Layton <jlayton@kernel.org>
    ceph: properly put ceph_string reference after async create attempt

Tom Zanussi <zanussi@kernel.org>
    tracing: Don't inc err_log entry count if entry allocation fails

Xiaoke Wang <xkernel.wang@foxmail.com>
    tracing/histogram: Fix a potential memory leak for kstrdup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    PM: wakeup: simplify the output logic of pm_show_wakelocks()

Ard Biesheuvel <ardb@kernel.org>
    efi: runtime: avoid EFIv2 runtime services on Apple x86 machines

Jan Kara <jack@suse.cz>
    udf: Fix NULL ptr deref when converting from inline format

Jan Kara <jack@suse.cz>
    udf: Restore i_lenAlloc when inode expansion fails

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: Fix failed recovery on gone remote port with non-NPIV FCP devices

Eric W. Biederman <ebiederm@xmission.com>
    ucount: Make get_ucount a safe get_user replacement

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Update ldimm64 instructions during extra pass

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc32/bpf: Fix codegen for bpf-to-bpf calls

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    bpf: Guard against accessing NULL pt_regs in bpf_get_task_stack()

Christian Borntraeger <borntraeger@linux.ibm.com>
    s390/nmi: handle vector validity failures for KVM guests

Christian Borntraeger <borntraeger@linux.ibm.com>
    s390/nmi: handle guarded storage validity failures for KVM guests

Vasily Gorbik <gor@linux.ibm.com>
    s390/hypfs: include z/VM guests with access control group set

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/module: fix loading modules with a lot of relocations

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Use shadow SPSR_EL1 when injecting exceptions on !VHE

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9180/1: Thumb2: align ALT_UP() sections in modules sufficiently

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9179/1: uaccess: avoid alignment faults in copy_[from|to]_kernel_nofault

Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
    net: stmmac: skip only stmmac_ptp_register when resume from suspend

Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
    net: stmmac: configure PTP clock source prior to PTP initialization

Marek Behún <kabel@kernel.org>
    net: sfp: ignore disabled SFP node

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_fifo_{read,write}: don't read or write from/to FIFO if length is 0


-------------

Diffstat:

 Documentation/accounting/psi.rst                   |   3 +-
 .../devicetree/bindings/net/can/tcan4x5x.txt       |   2 +-
 Makefile                                           |   4 +-
 arch/arm/include/asm/assembler.h                   |   2 +
 arch/arm/include/asm/processor.h                   |   1 +
 arch/arm/include/asm/uaccess.h                     |  10 +-
 arch/arm/probes/kprobes/Makefile                   |   3 +
 arch/arm64/kvm/hyp/exception.c                     |   5 +-
 arch/arm64/kvm/hyp/pgtable.c                       |  18 +-
 arch/ia64/pci/fixup.c                              |   4 +-
 arch/mips/loongson64/vbios_quirk.c                 |   9 +-
 arch/powerpc/include/asm/book3s/32/mmu-hash.h      |   2 +
 arch/powerpc/include/asm/kvm_book3s_64.h           |   1 -
 arch/powerpc/include/asm/kvm_host.h                |   1 +
 arch/powerpc/include/asm/ppc-opcode.h              |   1 +
 arch/powerpc/include/asm/syscall.h                 |   4 +-
 arch/powerpc/include/asm/thread_info.h             |   2 +
 arch/powerpc/kernel/Makefile                       |   1 +
 arch/powerpc/kernel/interrupt_64.S                 |   2 +
 arch/powerpc/kvm/book3s_hv.c                       |   3 +-
 arch/powerpc/kvm/book3s_hv_nested.c                |   2 +-
 arch/powerpc/lib/Makefile                          |   3 +
 arch/powerpc/mm/book3s32/mmu.c                     |  15 +-
 arch/powerpc/mm/kasan/book3s_32.c                  |  59 ++---
 arch/powerpc/net/bpf_jit_comp.c                    |  29 ++-
 arch/powerpc/net/bpf_jit_comp32.c                  |   9 +
 arch/powerpc/net/bpf_jit_comp64.c                  |  29 ++-
 arch/powerpc/perf/core-book3s.c                    |  17 +-
 arch/s390/hypfs/hypfs_vm.c                         |   6 +-
 arch/s390/kernel/module.c                          |  37 ++-
 arch/s390/kernel/nmi.c                             |  27 ++-
 arch/x86/events/intel/core.c                       |  13 ++
 arch/x86/events/intel/uncore_snbep.c               |   2 +-
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/kernel/cpu/mce/amd.c                      |   2 +-
 arch/x86/kernel/cpu/mce/intel.c                    |   1 +
 arch/x86/kvm/lapic.c                               |   2 +-
 arch/x86/kvm/svm/nested.c                          |   9 +-
 arch/x86/kvm/svm/svm.c                             |  41 ++--
 arch/x86/kvm/svm/svm.h                             |   2 +-
 arch/x86/kvm/vmx/nested.c                          |   1 +
 arch/x86/kvm/x86.c                                 |  10 +-
 arch/x86/pci/fixup.c                               |   4 +-
 block/bio.c                                        |   3 +-
 block/blk-core.c                                   |  25 +-
 drivers/firmware/efi/efi.c                         |   7 +
 drivers/firmware/efi/libstub/arm64-stub.c          |   6 +-
 .../gpu/drm/amd/display/dc/dcn30/dcn30_resource.c  |   4 +-
 drivers/gpu/drm/ast/ast_tables.h                   |   2 -
 drivers/gpu/drm/drm_atomic.c                       |  12 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c       |   4 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   2 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dspp.c        |  11 +-
 drivers/gpu/drm/msm/dsi/dsi.c                      |   7 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c              |   4 +-
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   7 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   2 +-
 drivers/hv/hv_balloon.c                            |   7 +
 drivers/hwmon/adt7470.c                            |   3 +
 drivers/hwmon/lm90.c                               |  21 +-
 drivers/irqchip/irq-realtek-rtl.c                  |  10 +-
 drivers/md/dm.c                                    |  20 +-
 drivers/net/can/m_can/m_can.c                      |   6 +
 drivers/net/can/m_can/tcan4x5x-regmap.c            |   2 +-
 drivers/net/ethernet/google/gve/gve.h              |   2 +-
 drivers/net/ethernet/google/gve/gve_main.c         |   6 +-
 drivers/net/ethernet/google/gve/gve_rx.c           |   3 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |   2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   3 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 | 133 +++++++----
 drivers/net/ethernet/intel/i40e/i40e.h             |   9 +-
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  44 ++--
 drivers/net/ethernet/intel/i40e/i40e_register.h    |   3 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 103 ++++++++-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   1 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   3 +
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    |  27 +--
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   7 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  88 ++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  22 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |  20 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   7 +-
 .../net/ethernet/stmicro/stmmac/dwmac-visconti.c   |  42 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  23 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   3 -
 drivers/net/ethernet/ti/cpsw_priv.c                |   2 +-
 drivers/net/hamradio/yam.c                         |   4 +-
 drivers/net/phy/broadcom.c                         |   1 +
 drivers/net/phy/phy_device.c                       |   6 +-
 drivers/net/phy/sfp-bus.c                          |   5 +
 drivers/rpmsg/rpmsg_char.c                         |  22 +-
 drivers/s390/scsi/zfcp_fc.c                        |  13 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |  20 +-
 drivers/scsi/elx/libefc/efc_els.c                  |   8 +-
 drivers/tty/n_gsm.c                                |   4 +-
 drivers/tty/serial/8250/8250_of.c                  |  11 +-
 drivers/tty/serial/8250/8250_pci.c                 | 100 +++++++-
 drivers/tty/serial/amba-pl011.c                    |   8 +-
 drivers/tty/serial/stm32-usart.c                   |   2 +-
 drivers/usb/cdns3/drd.c                            |   6 +-
 drivers/usb/common/ulpi.c                          |   7 +-
 drivers/usb/core/hcd.c                             |  14 ++
 drivers/usb/core/urb.c                             |  12 +
 drivers/usb/dwc3/dwc3-xilinx.c                     |  25 +-
 drivers/usb/gadget/function/f_sourcesink.c         |   1 +
 drivers/usb/host/xhci-plat.c                       |   3 +
 drivers/usb/storage/unusual_devs.h                 |  10 +
 drivers/usb/typec/tcpm/tcpci.c                     |  26 +++
 drivers/usb/typec/tcpm/tcpci.h                     |   1 +
 drivers/usb/typec/tcpm/tcpm.c                      |   7 +-
 drivers/usb/typec/ucsi/ucsi_ccg.c                  |   2 +-
 drivers/video/fbdev/hyperv_fb.c                    |  16 +-
 fs/btrfs/ioctl.c                                   |   6 +-
 fs/ceph/caps.c                                     |  55 +++--
 fs/ceph/file.c                                     |   9 +
 fs/configfs/dir.c                                  |   6 +-
 fs/devpts/inode.c                                  |   2 +-
 fs/io_uring.c                                      |   7 +-
 fs/jbd2/journal.c                                  |   2 +
 fs/namei.c                                         |  10 +-
 fs/nfs/dir.c                                       |  22 ++
 fs/nfsd/nfsctl.c                                   |   5 +-
 fs/ocfs2/suballoc.c                                |  25 +-
 fs/udf/inode.c                                     |   9 +-
 include/linux/blkdev.h                             |   1 +
 include/linux/fsnotify.h                           |  48 +++-
 include/linux/mm.h                                 |  17 +-
 include/linux/netdevice.h                          |   1 +
 include/linux/perf_event.h                         |  15 +-
 include/linux/psi.h                                |  13 +-
 include/linux/psi_types.h                          |   3 -
 include/linux/usb/role.h                           |   6 +
 include/net/addrconf.h                             |   2 +
 include/net/ip.h                                   |  21 +-
 include/net/ip6_fib.h                              |   2 +-
 include/net/route.h                                |   2 +-
 include/trace/events/sunrpc.h                      |  40 ++--
 include/uapi/linux/cyclades.h                      |  35 +++
 kernel/bpf/stackmap.c                              |   5 +-
 kernel/cgroup/cgroup.c                             |  11 +-
 kernel/events/core.c                               | 257 +++++++++++++--------
 kernel/power/wakelock.c                            |  11 +-
 kernel/sched/fair.c                                |  16 +-
 kernel/sched/membarrier.c                          |   9 +-
 kernel/sched/pelt.h                                |   4 +-
 kernel/sched/psi.c                                 | 145 ++++++------
 kernel/trace/trace.c                               |   3 +-
 kernel/trace/trace_events_hist.c                   |   1 +
 kernel/ucount.c                                    |   2 +
 net/bluetooth/hci_event.c                          |  10 +-
 net/bridge/br_vlan.c                               |   9 +-
 net/core/net-procfs.c                              |  38 ++-
 net/ipv4/ip_output.c                               |  26 ++-
 net/ipv4/ping.c                                    |   3 +-
 net/ipv4/raw.c                                     |   5 +-
 net/ipv6/addrconf.c                                |  27 ++-
 net/ipv6/ip6_fib.c                                 |  23 +-
 net/ipv6/ip6_tunnel.c                              |   8 +-
 net/ipv6/route.c                                   |   2 +-
 net/mptcp/pm.c                                     |   1 +
 net/mptcp/pm_netlink.c                             | 176 ++++++++------
 net/mptcp/protocol.c                               |   3 +-
 net/mptcp/protocol.h                               |  12 +-
 net/netfilter/nf_conntrack_core.c                  |   8 +-
 net/packet/af_packet.c                             |   2 +
 net/rxrpc/call_event.c                             |   8 +-
 net/rxrpc/output.c                                 |   2 +-
 net/sched/sch_htb.c                                |  20 ++
 net/smc/af_smc.c                                   |  63 ++++-
 net/sunrpc/rpc_pipe.c                              |   4 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c      |   1 -
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  10 +-
 usr/include/Makefile                               |   2 +-
 virt/kvm/kvm_main.c                                |   1 -
 177 files changed, 1862 insertions(+), 886 deletions(-)


