Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC68E42399B
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 10:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237562AbhJFIVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 04:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237411AbhJFIVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 04:21:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EA42610A8;
        Wed,  6 Oct 2021 08:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633508401;
        bh=ViGrf64kMUjUYnnPfYQJjamqnui7kXslUUt/jOgEVLg=;
        h=From:To:Cc:Subject:Date:From;
        b=SoQkISmUN/J+dymMvjy2neMKnZhkvSk/SuKy4EnnwxZOmIHzbbCqiObOwCl9eaUiM
         Xx1U6LLH3ULNKVsZjRf5NK5GCUBepPrKDTndnqUUrHZGtXwm8Coy9nFf7Vl1gvp9Qe
         g3X68gZx/Xlqv72Ug17uuDSJnfak5YgsRje3QcPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.14 000/172] 5.14.10-rc3 review
Date:   Wed,  6 Oct 2021 10:19:58 +0200
Message-Id: <20211006073100.650368172@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.10-rc3.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.14.10-rc3
X-KernelTest-Deadline: 2021-10-08T07:31+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.14.10 release.
There are 172 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 08 Oct 2021 07:30:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.10-rc3.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.14.10-rc3

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Fix potential NULL pointer dereference - take 2

Linus Torvalds <torvalds@linux-foundation.org>
    objtool: print out the symbol type when complaining about it

Daniele Palmas <dnlplm@gmail.com>
    drivers: net: mhi: fix error path in mhi_net_newlink

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: Fix oversized kvmalloc() calls

Eric Dumazet <edumazet@google.com>
    netfilter: conntrack: serialize hash resizes and cleanups

Haimin Zhang <tcs_kernel@tencent.com>
    KVM: x86: Handle SRCU initialization failure during page track init

Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
    crypto: aesni - xts_crypt() return if walk.nbytes is 0

Anirudh Rayabharam <mail@anirudhrb.com>
    HID: usbhid: free raw_report buffers in usbhid_stop

Linus Torvalds <torvalds@linux-foundation.org>
    mm: don't allow oversized kvmalloc() calls

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Fix oversized kvmalloc() calls

F.A.Sulaiman <asha.16@itfac.mrt.ac.lk>
    HID: betop: fix slab-out-of-bounds Write in betop_probe

Dongliang Mu <mudongliangabcd@gmail.com>
    usb: hso: remove the bailout parameter

Randy Dunlap <rdunlap@infradead.org>
    NIOS2: setup.c: drop unused variable 'dram_start'

Eric Dumazet <edumazet@google.com>
    net: udp: annotate data race around udp_sk(sk)->corkflag

Andrej Shadura <andrew.shadura@collabora.co.uk>
    HID: u2fzero: ignore incomplete packets without data

yangerkun <yangerkun@huawei.com>
    ext4: flush s_error_work before journal destroy in ext4_fill_super

yangerkun <yangerkun@huawei.com>
    ext4: fix potential infinite loop in ext4_dx_readdir()

Theodore Ts'o <tytso@mit.edu>
    ext4: add error checking to ext4_ext_replay_set_iblocks()

Jeffle Xu <jefflexu@linux.alibaba.com>
    ext4: fix reserved space counter leakage

Hou Tao <houtao1@huawei.com>
    ext4: limit the number of blocks in one ADD_RANGE TLV

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: fix loff_t overflow in ext4_max_bitmap_size()

Johan Hovold <johan@kernel.org>
    ipack: ipoctal: fix module reference leak

Johan Hovold <johan@kernel.org>
    ipack: ipoctal: fix missing allocation-failure check

Johan Hovold <johan@kernel.org>
    ipack: ipoctal: fix tty-registration error handling

Johan Hovold <johan@kernel.org>
    ipack: ipoctal: fix tty registration race

Johan Hovold <johan@kernel.org>
    ipack: ipoctal: fix stack information leak

Nirmoy Das <nirmoy.das@amd.com>
    debugfs: debugfs_create_file_size(): use IS_ERR to check for error

Saravana Kannan <saravanak@google.com>
    driver core: fw_devlink: Improve handling of cyclic dependencies

Chen Jingwen <chenjingwen6@huawei.com>
    elf: don't use MAP_FIXED_NOREPLACE for elf interpreter mappings

Keith Busch <kbusch@kernel.org>
    nvme: add command id quirk for apple controllers

Linus Torvalds <torvalds@linux-foundation.org>
    kvm: fix objtool relocation warning

Vadim Pasternak <vadimp@nvidia.com>
    hwmon: (pmbus/mp2975) Add missed POUT attribute for page 1 mp2975 controller

Eddie James <eajames@linux.ibm.com>
    hwmon: (occ) Fix P10 VRM temp sensors

Mel Gorman <mgorman@techsingularity.net>
    sched/fair: Null terminate buffer when updating tunable_scaling

Michal Koutný <mkoutny@suse.com>
    sched/fair: Add ancestors of unthrottled undecayed cfs_rq

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Update event constraints for ICX

Peter Zijlstra <peterz@infradead.org>
    objtool: Teach get_alt_entry() about more relocation types

Eric Dumazet <edumazet@google.com>
    af_unix: fix races in sk_peer_pid and sk_peer_cred accesses

Wong Vee Khee <vee.khee.wong@linux.intel.com>
    net: stmmac: fix EEE init issue when paired with EEE capable PHYs

Vlad Buslov <vladbu@nvidia.com>
    net: sched: flower: protect fl_walk() with rcu

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: bcm7xxx: Fixed indirect MMD operations

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: disable firmware compatible features when uninstall PF

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: fix always enable rx vlan filter problem after selftest

Peng Li <lipeng321@huawei.com>
    net: hns3: reconstruct function hns3_self_test

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix show wrong state when add existing uc mac address

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix mixed flag HCLGE_FLAG_MQPRIO_ENABLE and HCLGE_FLAG_DCB_ENABLE

Jian Shen <shenjian15@huawei.com>
    net: hns3: don't rollback when destroy mqprio fail

Jian Shen <shenjian15@huawei.com>
    net: hns3: remove tc enable checking

Jian Shen <shenjian15@huawei.com>
    net: hns3: do not allow call hns3_nic_net_open repeatedly

Feng Zhou <zhoufeng.zf@bytedance.com>
    ixgbe: Fix NULL pointer dereference in ixgbe_xdp_setup

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    scsi: csiostor: Add module softdep on cxgb4

Jens Axboe <axboe@kernel.dk>
    Revert "block, bfq: honor already-setup queue merges"

Shannon Nelson <snelson@pensando.io>
    ionic: fix gathering of debug stats

Arnd Bergmann <arnd@arndb.de>
    net: ks8851: fix link error

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    bpf, x86: Fix bpf mapping of atomic fetch implementation

Jiri Benc <jbenc@redhat.com>
    selftests, bpf: test_lwt_ip_encap: Really disable rp_filter

Jiri Benc <jbenc@redhat.com>
    selftests, bpf: Fix makefile dependencies on libbpf

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    libbpf: Fix segfault in static linker for objects without BTF

Lorenz Bauer <lmb@cloudflare.com>
    bpf: Exempt CAP_BPF from checks against bpf_jit_limit

Wenpeng Liang <liangwenpeng@huawei.com>
    RDMA/hns: Add the check of the CQE size of the user space

Wenpeng Liang <liangwenpeng@huawei.com>
    RDMA/hns: Fix the size setting error when copying CQE in clean_cq()

Guo Zhi <qtxuning1999@sjtu.edu.cn>
    RDMA/hfi1: Fix kernel pointer leak

Jacob Keller <jacob.e.keller@intel.com>
    e100: fix buffer overrun in e100_get_regs

Jacob Keller <jacob.e.keller@intel.com>
    e100: fix length calculation in e100_get_regs_len

Andrew Lunn <andrew@lunn.ch>
    dsa: mv88e6xxx: Include tagger overhead when setting MTU for DSA and CPU ports

Andrew Lunn <andrew@lunn.ch>
    dsa: mv88e6xxx: Fix MTU definition

Andrew Lunn <andrew@lunn.ch>
    dsa: mv88e6xxx: 6161: Use chip wide MAX MTU

Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>
    drm/i915: Remove warning from the rps worker

Matthew Auld <matthew.auld@intel.com>
    drm/i915/request: fix early tracepoints

Aaro Koskinen <aaro.koskinen@iki.fi>
    smsc95xx: fix stalled rx after link change

Xiao Liang <shaw.leon@gmail.com>
    net: ipv4: Fix rtnexthop len when RTA_FLOW is present

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: fix the incorrect clearing of IF_MODE bits

Paul Fertser <fercerpav@gmail.com>
    hwmon: (tmp421) fix rounding for negative values

Paul Fertser <fercerpav@gmail.com>
    hwmon: (tmp421) report /PVLD condition as fault

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/hns: Work around broken constant propagation in gcc 8

Davide Caratti <dcaratti@redhat.com>
    mptcp: allow changing the 'backup' bit when no sockets are open

Florian Westphal <fw@strlen.de>
    mptcp: don't return sockets in foreign netns

Xin Long <lucien.xin@gmail.com>
    sctp: break out if skb_header_pointer returns NULL in sctp_rcv_ootb

Saravana Kannan <saravanak@google.com>
    net: mdiobus: Set FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD for mdiobus parents

Saravana Kannan <saravanak@google.com>
    driver core: fw_devlink: Add support for FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD

Johannes Berg <johannes.berg@intel.com>
    mac80211-hwsim: fix late beacon hrtimer handling

Johannes Berg <johannes.berg@intel.com>
    mac80211: mesh: fix potentially unaligned access

Lorenzo Bianconi <lorenzo@kernel.org>
    mac80211: limit injected vht mcs/nss in ieee80211_parse_tx_radiotap

Chih-Kang Chang <gary.chang@realtek.com>
    mac80211: Fix ieee80211_amsdu_aggregate frag_tail bug

Felix Fietkau <nbd@nbd.name>
    Revert "mac80211: do not use low data rates for data frames with no ack flag"

Florian Westphal <fw@strlen.de>
    netfilter: log: work around missing softdep backend module

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: unlink table before deleting it

Sindhu Devale <sindhu.devale@intel.com>
    RDMA/irdma: Report correct WC error when there are MW bind errors

Sindhu Devale <sindhu.devale@intel.com>
    RDMA/irdma: Report correct WC error when transport retry counter is exceeded

Sindhu Devale <sindhu.devale@intel.com>
    RDMA/irdma: Validate number of CQ entries on create CQ

Sindhu Devale <sindhu.devale@intel.com>
    RDMA/irdma: Skip CQP ring during a reset

Vadim Pasternak <vadimp@nvidia.com>
    hwmon: (mlxreg-fan) Return non-zero value when fan current state is enforced from sysfs

Piotr Krysiuk <piotras@gmail.com>
    bpf, mips: Validate conditional branch offsets

Tao Liu <thomas.liu@ucloud.cn>
    RDMA/cma: Fix listener leak in rdma_cma_listen_on_all() failure

Christoph Lameter <cl@gentwo.de>
    IB/cma: Do not send IGMP leaves for sendonly Multicast groups

Hou Tao <houtao1@huawei.com>
    bpf: Handle return value of BPF_PROG_TYPE_STRUCT_OPS prog

Andrea Claudi <aclaudi@redhat.com>
    ipvs: check that ip_vs_conn_tab_bits is between 8 and 20

Zhi A Wang <zhi.wang.linux2@gmail.com>
    drm/i915/gvt: fix the usage of ww lock in gvt scheduler.

Shawn Guo <shawn.guo@linaro.org>
    interconnect: qcom: sdm660: Correct NOC_QOS_PRIORITY shift and mask

Shawn Guo <shawn.guo@linaro.org>
    interconnect: qcom: sdm660: Fix id of slv_cnoc_mnoc_cfg

Hawking Zhang <Hawking.Zhang@amd.com>
    drm/amdgpu: correct initial cp_hqd_quantum for gfx9

Simon Ser <contact@emersion.fr>
    drm/amdgpu: check tiling flags when creating FB on GFX8-

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: force exit gfxoff on sdma resume for rmb s0ix

Praful Swarnakar <Praful.Swarnakar@amd.com>
    drm/amd/display: Fix Display Flicker on embedded panels

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: Pass PCI deviceid into DC

Josip Pavic <Josip.Pavic@amd.com>
    drm/amd/display: initialize backlight_ramping_override to false

Nick Desaulniers <ndesaulniers@google.com>
    nbd: use shifts rather than multiplies

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/cma: Ensure rdma_addr_cancel() happens before issuing more requests

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/cma: Do not change route.addr.src_addr.ss_family

Sean Young <sean@mess.org>
    media: ir_toy: prevent device from hanging during transmit

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: renesas_sdhi: fix regression with hard reset on old SDHIs

Zhenzhong Duan <zhenzhong.duan@intel.com>
    KVM: VMX: Fix a TSX_CTRL_CPUID_CLEAR field mask issue

Chenyi Qiang <chenyi.qiang@intel.com>
    KVM: nVMX: Fix nested bus lock VM exit

Mingwei Zhang <mizhang@google.com>
    KVM: SVM: fix missing sev_decommission in sev_receive_start

Peter Gonda <pgonda@google.com>
    KVM: SEV: Allow some commands for mirror VM

Peter Gonda <pgonda@google.com>
    KVM: SEV: Acquire vcpu mutex when updating VMSA

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Pin guest memory for write for RECEIVE_UPDATE_DATA

Peter Gonda <pgonda@google.com>
    KVM: SEV: Update svm_vm_copy_asid_from for SEV-ES

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: nVMX: Filter out all unsupported controls when eVMCS was activated

Sean Christopherson <seanjc@google.com>
    KVM: x86: Swap order of CPUID entry "index" vs. "significant flag" checks

Sean Christopherson <seanjc@google.com>
    KVM: x86: Clear KVM's cached guest CR3 at RESET/INIT

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: nSVM: don't copy virt_ext from vmcb12

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: Fix stack-out-of-bounds memory access from ioapic_write_indirect()

Zelin Deng <zelin.deng@linux.alibaba.com>
    ptp: Fix ptp_kvm_getcrosststamp issue for x86 ptp_kvm

Zelin Deng <zelin.deng@linux.alibaba.com>
    x86/kvmclock: Move this_cpu_pvti into kvmclock.h

José Expósito <jose.exposito89@gmail.com>
    platform/x86/intel: hid: Add DMI switches allow list

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix use-after-free in CCMP/GCMP RX

Jonathan Hsu <jonathan.hsu@mediatek.com>
    scsi: ufs: Fix illegal offset in UPIU event trace

Andrey Gusakov <andrey.gusakov@cogentembedded.com>
    gpio: pca953x: do not ignore i2c errors

Nadezda Lutovinova <lutovinova@ispras.ru>
    hwmon: (w83791d) Fix NULL pointer dereference by removing unnecessary structure field

Nadezda Lutovinova <lutovinova@ispras.ru>
    hwmon: (w83792d) Fix NULL pointer dereference by removing unnecessary structure field

Nadezda Lutovinova <lutovinova@ispras.ru>
    hwmon: (w83793) Fix NULL pointer dereference by removing unnecessary structure field

Paul Fertser <fercerpav@gmail.com>
    hwmon: (tmp421) handle I2C errors

Eric Biggers <ebiggers@google.com>
    fs-verity: fix signed integer overflow with i_size near S64_MAX

Jia He <justin.he@arm.com>
    ACPI: NFIT: Use fallback node id when numa info in NFIT table is incorrect

Cameron Berkenpas <cam@neo-zeon.de>
    ALSA: hda/realtek: Quirks to enable speaker output for Lenovo Legion 7i 15IMHG05, Yoga 7i 14ITL5/15ITL5, and 13s Gen2 laptops.

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-motu: fix truncated bytes in message tracepoints

Jaroslav Kysela <perex@perex.cz>
    ALSA: rawmidi: introduce SNDRV_RAWMIDI_IOCTL_USER_PVERSION

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: ufs-pci: Fix Intel LKF link stability

James Morse <james.morse@arm.com>
    cpufreq: schedutil: Destroy mutex before kobject_put() frees the memory

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: stop scheduler when calling hw_fini (v2)

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: avoid over-handle of fence driver fini in s3 test (v2)

Likun Gao <Likun.Gao@amd.com>
    drm/amdgpu: adjust fence driver enable sequence

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Changes to support kdump kernel for NVMe BFS

Kevin Hao <haokexin@gmail.com>
    cpufreq: schedutil: Use kobject release() method to free sugov_tunables

Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
    tty: Fix out-of-bound vmalloc access in imageblit

Jackie Liu <liuyun01@kylinos.cn>
    watchdog/sb_watchdog: fix compilation problem due to COMPILE_TEST

Like Xu <likexu@tencent.com>
    perf iostat: Fix Segmentation fault from NULL 'struct perf_counts_values *'

Like Xu <likexu@tencent.com>
    perf iostat: Use system-wide mode if the target cpu_list is unspecified

Ian Rogers <irogers@google.com>
    perf test: Fix DWARF unwind for optimized builds.

Evgeny Novikov <novikov@ispras.ru>
    HID: amd_sfh: Fix potential NULL pointer dereference

Marco Elver <elver@google.com>
    kasan: fix Kconfig check of CC_HAS_WORKING_NOSANITIZE_ADDRESS

Randy Dunlap <rdunlap@infradead.org>
    NIOS2: fix kconfig unmet dependency warning for SERIAL_CORE_CONSOLE

Al Viro <viro@zeniv.linux.org.uk>
    m68k: Update ->thread.esp0 before calling syscall_trace() in ret_from_signal

Dan Carpenter <dan.carpenter@oracle.com>
    crypto: ccp - fix resource leaks in ccp_run_aes_gcm_cmd()

Alexandra Winter <wintera@linux.ibm.com>
    s390/qeth: fix deadlock during failing recovery

Alexandra Winter <wintera@linux.ibm.com>
    s390/qeth: Fix deadlock in remove_discipline

Lama Kayal <lkayal@nvidia.com>
    net/mlx4_en: Resolve bad operstate value

David Collins <collinsd@codeaurora.org>
    pinctrl: qcom: spmi-gpio: correct parent irqspec translation

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: imx: imx8m: Bar index is only valid for IRAM and SRAM types

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: imx: imx8: Bar index is only valid for IRAM and SRAM types

Yong Zhi <yong.zhi@intel.com>
    ASoC: SOF: Fix DSP oops stack dump output contents

James Smart <jsmart2021@gmail.com>
    scsi: elx: efct: Fix void-pointer-to-enum-cast warning for efc_nport_topology

Trevor Wu <trevor.wu@mediatek.com>
    ASoC: mediatek: common: handle NULL case in suspend/resume function

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_xcvr: register platform component before registering cpu dai

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_spdif: register platform component before registering cpu dai

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: register platform component before registering cpu dai

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_esai: register platform component before registering cpu dai

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: register platform component before registering cpu dai

Randy Dunlap <rdunlap@infradead.org>
    media: s5p-jpeg: rename JPEG marker constants to prevent build warnings

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: cedrus: Fix SUNXI tile size calculation

Jernej Skrabec <jernej.skrabec@gmail.com>
    media: hantro: Fix check for single irq


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/m68k/kernel/entry.S                           |   2 +
 arch/mips/net/bpf_jit.c                            |  57 ++++++---
 arch/nios2/Kconfig.debug                           |   3 +-
 arch/nios2/kernel/setup.c                          |   2 -
 arch/s390/include/asm/ccwgroup.h                   |   2 +-
 arch/x86/crypto/aesni-intel_glue.c                 |   2 +-
 arch/x86/events/intel/core.c                       |   1 +
 arch/x86/include/asm/kvm_page_track.h              |   2 +-
 arch/x86/include/asm/kvmclock.h                    |  14 +++
 arch/x86/kernel/kvmclock.c                         |  13 +--
 arch/x86/kvm/cpuid.c                               |   4 +-
 arch/x86/kvm/emulate.c                             |   1 -
 arch/x86/kvm/ioapic.c                              |  10 +-
 arch/x86/kvm/mmu/page_track.c                      |   4 +-
 arch/x86/kvm/svm/nested.c                          |   1 -
 arch/x86/kvm/svm/sev.c                             |  92 ++++++++++-----
 arch/x86/kvm/vmx/evmcs.c                           |  12 +-
 arch/x86/kvm/vmx/nested.c                          |   6 +
 arch/x86/kvm/vmx/vmx.c                             |  11 +-
 arch/x86/kvm/x86.c                                 |  10 +-
 arch/x86/net/bpf_jit_comp.c                        |  66 ++++++++---
 block/bfq-iosched.c                                |  16 +--
 drivers/acpi/nfit/core.c                           |  12 ++
 drivers/base/core.c                                |  36 +++++-
 drivers/block/nbd.c                                |  29 +++--
 drivers/cpufreq/cpufreq_governor_attr_set.c        |   2 +-
 drivers/crypto/ccp/ccp-ops.c                       |  14 ++-
 drivers/gpio/gpio-pca953x.c                        |  11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  15 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |  31 +++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          |  62 +++-------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h           |   9 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   2 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c             |   8 ++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   2 +
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |  15 ++-
 drivers/gpu/drm/i915/gt/intel_rps.c                |   2 -
 drivers/gpu/drm/i915/gvt/scheduler.c               |   4 +-
 drivers/gpu/drm/i915/i915_request.c                |  11 +-
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c             |   8 +-
 drivers/hid/hid-betopff.c                          |  13 ++-
 drivers/hid/hid-u2fzero.c                          |   4 +-
 drivers/hid/usbhid/hid-core.c                      |  13 ++-
 drivers/hwmon/mlxreg-fan.c                         |  12 +-
 drivers/hwmon/occ/common.c                         |  17 +--
 drivers/hwmon/pmbus/mp2975.c                       |   2 +-
 drivers/hwmon/tmp421.c                             |  71 +++++++-----
 drivers/hwmon/w83791d.c                            |  29 ++---
 drivers/hwmon/w83792d.c                            |  28 ++---
 drivers/hwmon/w83793.c                             |  26 ++---
 drivers/infiniband/core/cma.c                      |  51 +++++++-
 drivers/infiniband/core/cma_priv.h                 |   1 +
 drivers/infiniband/hw/hfi1/ipoib_tx.c              |   8 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |  31 +++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  13 ++-
 drivers/infiniband/hw/irdma/cm.c                   |   4 +-
 drivers/infiniband/hw/irdma/hw.c                   |  14 ++-
 drivers/infiniband/hw/irdma/i40iw_if.c             |   2 +-
 drivers/infiniband/hw/irdma/main.h                 |   1 -
 drivers/infiniband/hw/irdma/user.h                 |   2 +
 drivers/infiniband/hw/irdma/utils.c                |   2 +-
 drivers/infiniband/hw/irdma/verbs.c                |   9 +-
 drivers/interconnect/qcom/sdm660.c                 |  11 +-
 drivers/ipack/devices/ipoctal.c                    |  63 +++++++---
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  18 +--
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |  28 ++---
 drivers/media/rc/ir_toy.c                          |  21 +++-
 drivers/mmc/host/renesas_sdhi_core.c               |   2 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |  17 +--
 drivers/net/dsa/mv88e6xxx/chip.h                   |   1 +
 drivers/net/dsa/mv88e6xxx/global1.c                |   2 +
 drivers/net/dsa/mv88e6xxx/port.c                   |   2 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |   3 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 -
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  16 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 105 +++++++++++------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  21 ++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |  29 ++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  19 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  33 +-----
 drivers/net/ethernet/intel/e100.c                  |  22 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   8 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |  47 +++++---
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |   1 -
 drivers/net/ethernet/micrel/Makefile               |   6 +-
 drivers/net/ethernet/micrel/ks8851_common.c        |   8 ++
 drivers/net/ethernet/pensando/ionic/ionic_stats.c  |   9 --
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +
 drivers/net/mhi/net.c                              |   6 +-
 drivers/net/phy/bcm7xxx.c                          | 114 +++++++++++++++++-
 drivers/net/phy/mdio_bus.c                         |   4 +
 drivers/net/usb/hso.c                              |   6 +-
 drivers/net/usb/smsc95xx.c                         |   3 +
 drivers/net/wireless/mac80211_hwsim.c              |   4 +-
 drivers/nvme/host/core.c                           |   4 +-
 drivers/nvme/host/nvme.h                           |   6 +
 drivers/nvme/host/pci.c                            |   3 +-
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |  37 +++++-
 drivers/platform/x86/intel-hid.c                   |  27 ++++-
 drivers/ptp/ptp_kvm_x86.c                          |   9 +-
 drivers/s390/cio/ccwgroup.c                        |  10 +-
 drivers/s390/net/qeth_core.h                       |   1 -
 drivers/s390/net/qeth_core_main.c                  |  19 +--
 drivers/s390/net/qeth_l2_main.c                    |   1 -
 drivers/s390/net/qeth_l3_main.c                    |   1 -
 drivers/scsi/csiostor/csio_init.c                  |   1 +
 drivers/scsi/elx/libefc/efc_device.c               |   7 +-
 drivers/scsi/elx/libefc/efc_fabric.c               |   3 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   1 -
 drivers/scsi/qla2xxx/qla_isr.c                     |   2 +
 drivers/scsi/qla2xxx/qla_nvme.c                    |  40 +++----
 drivers/scsi/ufs/ufshcd-pci.c                      |  78 +++++++++++++
 drivers/scsi/ufs/ufshcd.c                          |   6 +-
 drivers/scsi/ufs/ufshcd.h                          |   1 +
 drivers/staging/media/hantro/hantro_drv.c          |   2 +-
 drivers/staging/media/sunxi/cedrus/cedrus_video.c  |   2 +-
 drivers/tty/vt/vt.c                                |  21 +++-
 drivers/watchdog/Kconfig                           |   2 +-
 fs/binfmt_elf.c                                    |   2 +-
 fs/debugfs/inode.c                                 |   2 +-
 fs/ext4/dir.c                                      |   6 +-
 fs/ext4/extents.c                                  |  19 ++-
 fs/ext4/fast_commit.c                              |   6 +
 fs/ext4/inode.c                                    |   5 +
 fs/ext4/super.c                                    |  21 +++-
 fs/verity/enable.c                                 |   2 +-
 fs/verity/open.c                                   |   2 +-
 include/linux/bpf.h                                |   2 +
 include/linux/fwnode.h                             |  11 +-
 include/net/ip_fib.h                               |   2 +-
 include/net/nexthop.h                              |   2 +-
 include/net/sock.h                                 |   2 +
 include/sound/rawmidi.h                            |   1 +
 include/uapi/sound/asound.h                        |   1 +
 kernel/bpf/bpf_struct_ops.c                        |   7 +-
 kernel/bpf/core.c                                  |   2 +-
 kernel/sched/cpufreq_schedutil.c                   |  16 ++-
 kernel/sched/debug.c                               |   8 +-
 kernel/sched/fair.c                                |   6 +-
 lib/Kconfig.kasan                                  |   2 +
 mm/util.c                                          |   4 +
 net/core/sock.c                                    |  32 ++++-
 net/ipv4/fib_semantics.c                           |  16 +--
 net/ipv4/udp.c                                     |  10 +-
 net/ipv6/route.c                                   |   5 +-
 net/ipv6/udp.c                                     |   2 +-
 net/mac80211/mesh_ps.c                             |   3 +-
 net/mac80211/rate.c                                |   4 -
 net/mac80211/tx.c                                  |  12 ++
 net/mac80211/wpa.c                                 |   6 +
 net/mptcp/mptcp_diag.c                             |   2 +-
 net/mptcp/pm_netlink.c                             |   4 +-
 net/mptcp/protocol.h                               |   2 +-
 net/mptcp/subflow.c                                |   2 +-
 net/mptcp/syncookies.c                             |  13 +--
 net/mptcp/token.c                                  |  11 +-
 net/mptcp/token_test.c                             |  14 ++-
 net/netfilter/ipset/ip_set_hash_gen.h              |   4 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   4 +
 net/netfilter/nf_conntrack_core.c                  |  70 +++++------
 net/netfilter/nf_tables_api.c                      |  30 +++--
 net/netfilter/nft_compat.c                         |  17 ++-
 net/netfilter/xt_LOG.c                             |  10 +-
 net/netfilter/xt_NFLOG.c                           |  10 +-
 net/sched/cls_flower.c                             |   6 +
 net/sctp/input.c                                   |   2 +-
 net/unix/af_unix.c                                 |  34 +++++-
 sound/core/rawmidi.c                               |   9 ++
 sound/firewire/motu/amdtp-motu.c                   |   7 +-
 sound/pci/hda/patch_realtek.c                      | 129 +++++++++++++++++++++
 sound/soc/fsl/fsl_esai.c                           |  16 ++-
 sound/soc/fsl/fsl_micfil.c                         |  15 ++-
 sound/soc/fsl/fsl_sai.c                            |  14 ++-
 sound/soc/fsl/fsl_spdif.c                          |  14 ++-
 sound/soc/fsl/fsl_xcvr.c                           |  15 ++-
 sound/soc/mediatek/common/mtk-afe-fe-dai.c         |  19 +--
 sound/soc/sof/imx/imx8.c                           |   9 +-
 sound/soc/sof/imx/imx8m.c                          |   9 +-
 sound/soc/sof/xtensa/core.c                        |   4 +-
 tools/lib/bpf/linker.c                             |   8 +-
 tools/objtool/special.c                            |  38 ++++--
 tools/perf/arch/x86/util/iostat.c                  |   2 +-
 tools/perf/builtin-stat.c                          |   2 +
 tools/perf/tests/dwarf-unwind.c                    |  39 +++++--
 tools/testing/selftests/bpf/Makefile               |   3 +-
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh   |  13 ++-
 188 files changed, 1840 insertions(+), 862 deletions(-)


