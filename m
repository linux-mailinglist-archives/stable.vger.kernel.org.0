Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EA23ED5D1
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238999AbhHPNPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:15:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237521AbhHPNNE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:13:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5309632AE;
        Mon, 16 Aug 2021 13:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119444;
        bh=ZyGEIAHIa89jaPBE02BVw1koHoKGlL08c6CNtWkF1Og=;
        h=From:To:Cc:Subject:Date:From;
        b=A909/axNs9EGgptFHcWt/l34yhQpo1FAS0HSvEX0Qk7I0MI1xsntpeL6AaB1WirBD
         f40SYE+h7FaiCRSpAEJsEwiuK5am5BCkf407cYzt1Rk46nBXI88X1w6GhSSVb+IHe+
         /azpsU1q5sD3PdNp+foDkFvnQawLlwRGVDDsFzsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.13 000/151] 5.13.12-rc1 review
Date:   Mon, 16 Aug 2021 15:00:30 +0200
Message-Id: <20210816125444.082226187@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.12-rc1
X-KernelTest-Deadline: 2021-08-18T12:54+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.13.12 release.
There are 151 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 18 Aug 2021 12:54:12 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.13.12-rc1

Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
    kasan, slub: reset tag when printing address

Jeff Layton <jlayton@kernel.org>
    ceph: take snap_empty_lock atomically with snaprealm refcount change

Jeff Layton <jlayton@kernel.org>
    ceph: clean up locking annotation for ceph_get_snap_realm and __lookup_snap_realm

Jeff Layton <jlayton@kernel.org>
    ceph: add some lockdep assertions around snaprealm handling

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Protect marking SPs unsync when using TDP MMU with spinlock

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Don't leak non-leaf SPTEs when zapping all SPTEs

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Use vmx_need_pf_intercept() when deciding if L0 wants a #PF

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Use current VMCS to query WAITPKG support for MSR emulation

Zhen Lei <thunder.leizhen@huawei.com>
    locking/rtmutex: Use the correct rtmutex debugging config option

Ard Biesheuvel <ardb@kernel.org>
    efi/libstub: arm64: Double check image alignment at entry

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Fix critical and debug interrupts on BOOKE

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Do not skip CPU-less nodes when creating the IPIs

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/smp: Fix OOPS in topology_init()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32s: Fix napping restore in data storage interrupt (DSI)

Laurent Dufour <ldufour@linux.ibm.com>
    powerpc/pseries: Fix update of LPAR security flavor after LPM

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/interrupt: Do not call single_step_exception() from other exceptions

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Protect msi_desc::masked for multi-MSI

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Use msi_mask_irq() in pci_msi_shutdown()

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Correct misleading comments

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Do not set invalid bits in MSI mask

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Enforce MSI[X] entry updates to be visible

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Enforce that MSI-X table entry is masked for update

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Mask all unused MSI-X entries

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Enable and mask MSI-X early

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/interrupt: Fix OOPS by not calling do_IRQ() from timer_interrupt()

Ben Dai <ben.dai@unisoc.com>
    genirq/timings: Prevent potential array overflow in __irq_timings_store()

Bixuan Cui <cuibixuan@huawei.com>
    genirq/msi: Ensure deactivation on teardown

Babu Moger <Babu.Moger@amd.com>
    x86/resctrl: Fix default monitoring groups reporting

Thomas Gleixner <tglx@linutronix.de>
    x86/ioapic: Force affinity setup before startup

Thomas Gleixner <tglx@linutronix.de>
    x86/msi: Force affinity setup before startup

Thomas Gleixner <tglx@linutronix.de>
    genirq: Provide IRQCHIP_AFFINITY_PRE_STARTUP

Randy Dunlap <rdunlap@infradead.org>
    x86/tools: Fix objdump version check again

Dhananjay Phadke <dphadke@linux.microsoft.com>
    i2c: iproc: fix race between client unreg and tasklet

Pu Lehui <pulehui@huawei.com>
    powerpc/kprobes: Fix kprobe Oops happens in booke

Ard Biesheuvel <ardb@kernel.org>
    efi/libstub: arm64: Relax 2M alignment again for relocatable kernels

Ard Biesheuvel <ardb@kernel.org>
    efi/libstub: arm64: Force Image reallocation if BSS was not reserved

David Brazdil <dbrazdil@google.com>
    KVM: arm64: Fix off-by-one in range_is_memory

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    arm64: efi: kaslr: Fix occasional random alloc (and boot) failure

Xie Yongji <xieyongji@bytedance.com>
    nbd: Aovid double completion of a request

Longpeng(Mike) <longpeng2@huawei.com>
    vsock/virtio: avoid potential deadlock when vsock device remove

Maximilian Heyne <mheyne@amazon.de>
    xen/events: Fix race in set_evtchn_to_irq

Matt Roper <matthew.d.roper@intel.com>
    drm/i915: Only access SFC_DONE when media domain is not fused off

Eric Dumazet <edumazet@google.com>
    net: igmp: increase size of mr_ifc_count

Neal Cardwell <ncardwell@google.com>
    tcp_bbr: fix u32 wrap bug in round logic if bbr_init() called after 2B packets

Willy Tarreau <w@1wt.eu>
    net: linkwatch: fix failure to restore device state across suspend/resume

Yang Yingliang <yangyingliang@huawei.com>
    net: bridge: fix memleak in br_add_if()

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: bridge: fix flags interpretation for extern learn fdb entries

Andre Przywara <andre.przywara@arm.com>
    pinctrl: sunxi: Don't underestimate number of functions

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: fix broken backpressure in .port_fdb_dump

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: lantiq: fix broken backpressure in .port_fdb_dump

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: lan9303: fix broken backpressure in .port_fdb_dump

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: hellcreek: fix broken backpressure in .port_fdb_dump

Eric Dumazet <edumazet@google.com>
    net: igmp: fix data-race in igmp_ifc_timer_expire()

Takeshi Misawa <jeliantsurux@gmail.com>
    net: Fix memory leak in ieee802154_raw_deliver

Ben Hutchings <ben.hutchings@mind.be>
    net: dsa: microchip: ksz8795: Don't use phy_port_cnt in VLAN table lookup

Ben Hutchings <ben.hutchings@mind.be>
    net: dsa: microchip: ksz8795: Fix VLAN filtering

Ben Hutchings <ben.hutchings@mind.be>
    net: dsa: microchip: ksz8795: Use software untagging on CPU port

Ben Hutchings <ben.hutchings@mind.be>
    net: dsa: microchip: ksz8795: Fix VLAN untagged flag change on deletion

Ben Hutchings <ben.hutchings@mind.be>
    net: dsa: microchip: ksz8795: Reject unsupported VLAN configuration

Ben Hutchings <ben.hutchings@mind.be>
    net: dsa: microchip: ksz8795: Fix PVID tag insertion

Ben Hutchings <ben.hutchings@mind.be>
    net: dsa: microchip: Fix ksz_read64()

Yonghong Song <yhs@fb.com>
    bpf: Fix potentially incorrect results with bpf_get_local_storage()

Miklos Szeredi <mszeredi@redhat.com>
    ovl: fix deadlock in splice write

Christian Hewitt <christianshewitt@gmail.com>
    drm/meson: fix colour distortion from HDR set during vendor u-boot

Aya Levin <ayal@nvidia.com>
    net/mlx5: Fix return value from tracer initialization

Shay Drory <shayd@nvidia.com>
    net/mlx5: Synchronize correct IRQ when destroying CQ

Chris Mi <cmi@nvidia.com>
    net/mlx5e: TC, Fix error handling memory leak

Aya Levin <ayal@nvidia.com>
    net/mlx5: Block switchdev mode while devlink traps are active

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Destroy page pool after XDP SQ to fix use-after-free

Roi Dayan <roid@nvidia.com>
    net/mlx5e: Avoid creating tunnel headers for local route

Alex Vesker <valex@nvidia.com>
    net/mlx5: DR, Add fail on error check on decap

Leon Romanovsky <leon@kernel.org>
    net/mlx5: Don't skip subfunction cleanup in case of error in module init

Hao Xu <haoxu@linux.alibaba.com>
    io-wq: fix IO_WORKER_F_FIXED issue in create_io_worker()

Hao Xu <haoxu@linux.alibaba.com>
    io-wq: fix bug of creating io-wokers unconditionally

Guillaume Nault <gnault@redhat.com>
    bareudp: Fix invalid read beyond skb's linear data

Roi Dayan <roid@nvidia.com>
    psample: Add a fwd declaration for skbuff

Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>
    iavf: Set RSS LUT and key in reset handle path

Brett Creeley <brett.creeley@intel.com>
    ice: don't remove netdev->dev_addr from uc sync list

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    ice: Stop processing VF messages during teardown

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    ice: Prevent probing virtual functions

Hangbin Liu <liuhangbin@gmail.com>
    net: sched: act_mirred: Reset ct info when mirror/redirect skb

Guvenc Gulce <guvenc@linux.ibm.com>
    net/smc: Correct smc link connection counter in case of smc client

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: fix wait on already cleared link

Nadav Amit <namit@vmware.com>
    io_uring: clear TIF_NOTIFY_SIGNAL when running task work

Pali Rohár <pali@kernel.org>
    ppp: Fix generating ifname when empty IFLA_IFNAME is specified

Ben Hutchings <ben.hutchings@mind.be>
    net: phy: micrel: Fix link detection on ksz87xx switch"

Oleksij Rempel <linux@rempel-privat.de>
    net: dsa: qca: ar9331: make proper initial port defaults

Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
    bpf: Fix integer overflow involving bucket_size

Daniel Xu <dxu@dxuuu.xyz>
    libbpf: Do not close un-owned FD 0 on errors

Robin Gögge <r.goegge@googlemail.com>
    libbpf: Fix probe for BPF_PROG_TYPE_CGROUP_SOCKOPT

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/amd/pm: Fix a memory leak in an error handling path in 'vangogh_tables_init()'

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Apply mid ACK for small core

Hans de Goede <hdegoede@redhat.com>
    platform/x86: pcengines-apuv2: Add missing terminating entries to gpio-lookup tables

John Hubbard <jhubbard@nvidia.com>
    net: mvvp2: fix short frame size on s390

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mt7530: add the missing RxUnicast MIB counter

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Fix mono playback

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Fix LRCLK frame start edge

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: PLL must be running when changing MCLK_SRC_SEL

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: tigerlake: Fix GPIO mapping for newer version of software

Yajun Deng <yajun.deng@linux.dev>
    netfilter: nf_conntrack_bridge: Fix memory leak when error

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Remove duplicate control for WNF filter frequency

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Fix inversion of ADC Notch Switch control

Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
    ASoC: SOF: Intel: hda-ipc: fix reply size checking

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: Kconfig: fix SoundWire dependencies

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    selftests/sgx: Fix Q1 and Q2 calculation in sigstruct.c

Mike Tipton <mdtipton@codeaurora.org>
    interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Fix bclk calculation for mono

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Don't allow SND_SOC_DAIFMT_LEFT_J

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Correct definition of ADC Volume control

Hsin-Yi Wang <hsinyi@chromium.org>
    pinctrl: mediatek: Fix fallback behavior for bias_set_combo

jason-jh.lin <jason-jh.lin@mediatek.com>
    drm/mediatek: Fix cursor plane no update

Dongliang Mu <mudongliangabcd@gmail.com>
    ieee802154: hwsim: fix GPF in hwsim_new_edge_nl

Dongliang Mu <mudongliangabcd@gmail.com>
    ieee802154: hwsim: fix GPF in hwsim_set_edge_lqi

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: handle VCN instances when harvesting (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: don't enable baco on boco platforms in runpm

Solomon Chiu <solomon.chiu@amd.com>
    drm/amdgpu: Add preferred mode in modeset when freesync video mode's enabled.

Anson Jacob <Anson.Jacob@amd.com>
    drm/amd/display: use GFP_ATOMIC in amdgpu_dm_irq_schedule_work

Eric Bernstein <eric.bernstein@amd.com>
    drm/amd/display: Remove invalid assert for ODM + MPC case

Ankit Nautiyal <ankit.k.nautiyal@intel.com>
    drm/i915/display: Fix the 12 BPC bits for PIPE_MISC reg

Zhenyu Wang <zhenyuw@linux.intel.com>
    drm/i915/gvt: Fix cached atomics setting for Windows VM

Nathan Chancellor <nathan@kernel.org>
    vmlinux.lds.h: Handle clang's module.{c,d}tor sections

Changbin Du <changbin.du@intel.com>
    riscv: kexec: do not add '-mno-relax' flag if compiler doesn't support it

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/region: Fix label activation vs errors

Dan Williams <dan.j.williams@intel.com>
    ACPI: NFIT: Fix support for virtual SPA ranges

Damien Le Moal <damien.lemoal@wdc.com>
    pinctrl: k210: Fix k210_fpioa_probe()

Luis Henriques <lhenriques@suse.de>
    ceph: reduce contention in ceph_check_delayed_caps()

Vineet Gupta <vgupta@synopsys.com>
    ARC: fp: set FPU_STATUS.FWE to enable FPU_STATUS update on context switch

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: cpsw: fix min eth packet size for non-switch use-cases

Loic Poulain <loic.poulain@linaro.org>
    net: wwan: mhi_wwan_ctrl: Fix possible deadlock

Hsuan-Chi Kuo <hsuanchikuo@gmail.com>
    seccomp: Fix setting loaded filter count during TSYNC

Tejun Heo <tj@kernel.org>
    cgroup: rstat: fix A-A deadlock on 32bit around u64_stats_sync

Ewan D. Milne <emilne@redhat.com>
    scsi: lpfc: Move initialization of phba->poll_list earlier to avoid crash

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix ctx-exit io_rsrc_put_work() deadlock

Jens Axboe <axboe@kernel.dk>
    io_uring: drop ctx->uring_lock before flushing work item

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: use the correct max-length for dentry_path_raw()

Rohith Surabattula <rohiths@microsoft.com>
    cifs: Call close synchronously during unlink/rename/lease break.

Shyam Prasad N <sprasad@microsoft.com>
    cifs: create sd context must be a multiple of 8

Rohith Surabattula <rohiths@microsoft.com>
    cifs: Handle race conditions during rename

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    i2c: dev: zero out array used for i2c reads from userspace

Takashi Iwai <tiwai@suse.de>
    ASoC: intel: atom: Fix reference to PCM buffer address

Takashi Iwai <tiwai@suse.de>
    ASoC: kirkwood: Fix reference to PCM buffer address

Mark Brown <broonie@kernel.org>
    ASoC: tlv320aic31xx: Fix jack detection after suspend

Takashi Iwai <tiwai@suse.de>
    ASoC: uniphier: Fix reference to PCM buffer address

Takashi Iwai <tiwai@suse.de>
    ASoC: xilinx: Fix reference to PCM buffer address

Takashi Iwai <tiwai@suse.de>
    ASoC: amd: Fix reference to PCM buffer address

Colin Ian King <colin.king@canonical.com>
    iio: adc: Fix incorrect exit of for-loop

Chris Lesiak <chris.lesiak@licor.com>
    iio: humidity: hdc100x: Add margin to the conversion time

Antti Keränen <detegr@rbx.email>
    iio: adis: set GPIO reset pin direction

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    iio: adc: ti-ads7950: Ensure CS is deasserted after reading channels

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usb: dwc3: gadget: Use list_replace_init() before traversing lists"

Liang Wang <wangliang101@huawei.com>
    lib: use PFN_PHYS() in devmem_is_allowed()


-------------

Diffstat:

 Documentation/virt/kvm/locking.rst                 |   8 +-
 Makefile                                           |   4 +-
 arch/arc/kernel/fpu.c                              |   9 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   2 +-
 arch/powerpc/include/asm/interrupt.h               |   3 +
 arch/powerpc/include/asm/irq.h                     |   2 +-
 arch/powerpc/include/asm/ptrace.h                  |  16 +++
 arch/powerpc/kernel/asm-offsets.c                  |  31 +++--
 arch/powerpc/kernel/head_book3s_32.S               |   2 +-
 arch/powerpc/kernel/head_booke.h                   |  27 +----
 arch/powerpc/kernel/irq.c                          |   7 +-
 arch/powerpc/kernel/kprobes.c                      |   3 +-
 arch/powerpc/kernel/sysfs.c                        |   2 +-
 arch/powerpc/kernel/time.c                         |   2 +-
 arch/powerpc/kernel/traps.c                        |   9 +-
 arch/powerpc/platforms/pseries/setup.c             |   5 +-
 arch/powerpc/sysdev/xive/common.c                  |  35 ++++--
 arch/riscv/kernel/Makefile                         |   2 +-
 arch/x86/events/intel/core.c                       |  23 ++--
 arch/x86/events/perf_event.h                       |  15 +++
 arch/x86/include/asm/kvm_host.h                    |   7 ++
 arch/x86/kernel/apic/io_apic.c                     |   6 +-
 arch/x86/kernel/apic/msi.c                         |  11 +-
 arch/x86/kernel/cpu/resctrl/monitor.c              |  27 +++--
 arch/x86/kernel/hpet.c                             |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |  28 +++++
 arch/x86/kvm/mmu/tdp_mmu.c                         |  26 +++--
 arch/x86/kvm/vmx/nested.c                          |   3 +-
 arch/x86/kvm/vmx/vmx.h                             |   2 +-
 arch/x86/tools/chkobjdump.awk                      |   1 +
 block/blk-cgroup.c                                 |  14 ++-
 drivers/acpi/nfit/core.c                           |   3 +
 drivers/base/core.c                                |   1 +
 drivers/block/nbd.c                                |  14 ++-
 drivers/firmware/efi/libstub/arm64-stub.c          |  69 ++++++++++--
 drivers/firmware/efi/libstub/randomalloc.c         |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   2 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   7 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c  |   2 +-
 .../gpu/drm/amd/display/dc/dcn30/dcn30_resource.c  |   1 -
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c   |   2 +-
 drivers/gpu/drm/i915/display/intel_display.c       |  34 ++++--
 drivers/gpu/drm/i915/gvt/handlers.c                |   1 +
 drivers/gpu/drm/i915/gvt/mmio_context.c            |   2 +
 drivers/gpu/drm/i915/i915_gpu_error.c              |  19 +++-
 drivers/gpu/drm/i915/i915_reg.h                    |  16 ++-
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c            |   3 -
 drivers/gpu/drm/mediatek/mtk_drm_plane.c           |  60 +++++-----
 drivers/gpu/drm/meson/meson_registers.h            |   5 +
 drivers/gpu/drm/meson/meson_viu.c                  |   7 +-
 drivers/i2c/busses/i2c-bcm-iproc.c                 |   4 +-
 drivers/i2c/i2c-dev.c                              |   5 +-
 drivers/iio/adc/palmas_gpadc.c                     |   4 +-
 drivers/iio/adc/ti-ads7950.c                       |   1 -
 drivers/iio/humidity/hdc100x.c                     |   6 +-
 drivers/iio/imu/adis.c                             |   3 +-
 drivers/infiniband/hw/mlx5/cq.c                    |   4 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   3 +-
 drivers/interconnect/qcom/icc-rpmh.c               |  10 +-
 drivers/net/bareudp.c                              |  16 ++-
 drivers/net/dsa/hirschmann/hellcreek.c             |   7 +-
 drivers/net/dsa/lan9303-core.c                     |  34 +++---
 drivers/net/dsa/lantiq_gswip.c                     |  14 ++-
 drivers/net/dsa/microchip/ksz8795.c                |  82 +++++++++++---
 drivers/net/dsa/microchip/ksz8795_reg.h            |   4 +
 drivers/net/dsa/microchip/ksz_common.h             |   9 +-
 drivers/net/dsa/mt7530.c                           |   1 +
 drivers/net/dsa/qca/ar9331.c                       |  73 +++++++++++-
 drivers/net/dsa/sja1105/sja1105_main.c             |   4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  13 ++-
 drivers/net/ethernet/intel/ice/ice.h               |   1 +
 drivers/net/ethernet/intel/ice/ice_main.c          |  28 +++--
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |   7 ++
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h         |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |   1 +
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  11 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  33 ++----
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  20 +++-
 .../net/ethernet/mellanox/mlx5/core/esw/sample.c   |   1 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  14 ++-
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  12 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   5 +
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   4 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |   2 +
 drivers/net/ethernet/ti/cpsw_new.c                 |   7 +-
 drivers/net/ethernet/ti/cpsw_priv.h                |   4 +-
 drivers/net/ieee802154/mac802154_hwsim.c           |   6 +-
 drivers/net/phy/micrel.c                           |   2 -
 drivers/net/ppp/ppp_generic.c                      |   2 +-
 drivers/net/wwan/mhi_wwan_ctrl.c                   |  12 +-
 drivers/nvdimm/namespace_devs.c                    |  17 ++-
 drivers/pci/msi.c                                  | 125 +++++++++++++--------
 drivers/pinctrl/intel/pinctrl-tigerlake.c          |  26 ++---
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c   |   8 +-
 drivers/pinctrl/pinctrl-k210.c                     |  26 ++++-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |   8 +-
 drivers/platform/x86/pcengines-apuv2.c             |   2 +
 drivers/scsi/lpfc/lpfc_init.c                      |   3 +-
 drivers/usb/dwc3/gadget.c                          |  18 +--
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |   3 +-
 drivers/xen/events/events_base.c                   |  20 +++-
 fs/ceph/caps.c                                     |  17 ++-
 fs/ceph/mds_client.c                               |  25 +++--
 fs/ceph/snap.c                                     |  54 +++++----
 fs/ceph/super.h                                    |   2 +-
 fs/cifs/cifsglob.h                                 |   5 +
 fs/cifs/dir.c                                      |   2 +-
 fs/cifs/file.c                                     |  35 +++---
 fs/cifs/inode.c                                    |  19 +++-
 fs/cifs/misc.c                                     |  50 +++++++--
 fs/cifs/smb2pdu.c                                  |   2 +-
 fs/io-wq.c                                         |  26 +++--
 fs/io_uring.c                                      |  26 +++--
 fs/overlayfs/file.c                                |  47 +++++++-
 include/asm-generic/vmlinux.lds.h                  |   1 +
 include/linux/bpf-cgroup.h                         |   4 +-
 include/linux/device.h                             |   1 +
 include/linux/inetdevice.h                         |   2 +-
 include/linux/irq.h                                |   2 +
 include/linux/mlx5/driver.h                        |   3 +-
 include/linux/msi.h                                |   2 +-
 include/net/psample.h                              |   2 +
 include/uapi/linux/neighbour.h                     |   7 +-
 kernel/bpf/hashtab.c                               |   4 +-
 kernel/bpf/helpers.c                               |   4 +-
 kernel/cgroup/rstat.c                              |  19 ++--
 kernel/irq/chip.c                                  |   5 +-
 kernel/irq/msi.c                                   |  13 ++-
 kernel/irq/timings.c                               |   5 +
 kernel/locking/rtmutex.c                           |   2 +-
 kernel/seccomp.c                                   |   2 +-
 lib/devmem_is_allowed.c                            |   2 +-
 mm/slub.c                                          |   4 +-
 net/bridge/br.c                                    |   3 +-
 net/bridge/br_fdb.c                                |  11 +-
 net/bridge/br_if.c                                 |   2 +
 net/bridge/br_private.h                            |   2 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |   6 +
 net/core/link_watch.c                              |   5 +-
 net/ieee802154/socket.c                            |   7 +-
 net/ipv4/igmp.c                                    |  21 ++--
 net/ipv4/tcp_bbr.c                                 |   2 +-
 net/sched/act_mirred.c                             |   3 +
 net/smc/af_smc.c                                   |   2 +-
 net/smc/smc_core.c                                 |   4 +-
 net/smc/smc_core.h                                 |   4 +
 net/smc/smc_llc.c                                  |  10 +-
 net/smc/smc_tx.c                                   |  18 ++-
 net/smc/smc_wr.c                                   |  10 ++
 net/vmw_vsock/virtio_transport.c                   |   7 +-
 sound/soc/amd/acp-pcm-dma.c                        |   2 +-
 sound/soc/amd/raven/acp3x-pcm-dma.c                |   2 +-
 sound/soc/amd/renoir/acp3x-pdm-dma.c               |   2 +-
 sound/soc/codecs/cs42l42.c                         |  83 ++++++++------
 sound/soc/codecs/cs42l42.h                         |   3 +
 sound/soc/codecs/tlv320aic31xx.c                   |  10 ++
 sound/soc/intel/atom/sst-mfld-platform-pcm.c       |   3 +-
 sound/soc/kirkwood/kirkwood-dma.c                  |  26 +++--
 sound/soc/sof/intel/Kconfig                        |   4 +-
 sound/soc/sof/intel/hda-ipc.c                      |   4 +-
 sound/soc/uniphier/aio-dma.c                       |   2 +-
 sound/soc/xilinx/xlnx_formatter_pcm.c              |   4 +-
 tools/lib/bpf/btf.c                                |   3 +-
 tools/lib/bpf/libbpf_probes.c                      |   4 +-
 tools/testing/selftests/sgx/sigstruct.c            |  41 +++----
 169 files changed, 1382 insertions(+), 656 deletions(-)


