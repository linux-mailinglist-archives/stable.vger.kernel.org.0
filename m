Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDE252193E
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiEJNoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244644AbiEJNmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:42:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0ECE2CDEEC;
        Tue, 10 May 2022 06:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 606266182F;
        Tue, 10 May 2022 13:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A50BC385C2;
        Tue, 10 May 2022 13:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189417;
        bh=KHNBd/6+8biMP7FyOFYBYh1KzVgeq5RLJ+u1NzTI3hI=;
        h=From:To:Cc:Subject:Date:From;
        b=WoMYNhBTtJ2H7DUKLOajGYfTtwpXqdRRcrLC5oD1yIld1sMvKH+K9X07rPpYcunRF
         OgarIBbdF2xS3q19rn0jOpH+31AoX496qRisk7mHitqL8z9hvszYKbCw05w+yuR83p
         /JU4wCgkZpJrBfML3cxud8YF4ttpSPBMK+37OgXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 000/135] 5.15.39-rc1 review
Date:   Tue, 10 May 2022 15:06:22 +0200
Message-Id: <20220510130740.392653815@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.39-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.39-rc1
X-KernelTest-Deadline: 2022-05-12T13:07+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.39 release.
There are 135 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.39-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.39-rc1

Marek Behún <kabel@kernel.org>
    PCI: aardvark: Update comment about link going down after link-up

Marek Behún <kabel@kernel.org>
    PCI: aardvark: Drop __maybe_unused from advk_pcie_disable_phy()

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Don't mask irq when mapping

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Remove irq_mask_ack() callback for INTx interrupts

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Use separate INTA interrupt for emulated root bridge

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix support for PME requester on emulated bridge

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Add support for PME interrupts

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Optimize writing PCI_EXP_RTCTL_PMEIE and PCI_EXP_RTSTA_PME on emulated bridge

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Add support for ERR interrupt on emulated bridge

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Enable MSI-X support

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix setting MSI address

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Add support for masking MSI interrupts

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Refactor unmasking summary MSI interrupt

Marek Behún <kabel@kernel.org>
    PCI: aardvark: Use dev_fwnode() instead of of_node_to_fwnode(dev->of_node)

Marek Behún <kabel@kernel.org>
    PCI: aardvark: Make msi_domain_info structure a static driver structure

Marek Behún <kabel@kernel.org>
    PCI: aardvark: Make MSI irq_chip structures static driver structures

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Check return value of generic_handle_domain_irq() when processing INTx IRQ

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Rewrite IRQ code to chained IRQ handler

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Replace custom PCIE_CORE_INT_* macros with PCI_INTERRUPT_*

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Disable common PHY when unbinding driver

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Disable link training when unbinding driver

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Assert PERST# when unbinding driver

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix memory leak in driver unbind

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Mask all interrupts when unbinding driver

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Disable bus mastering when unbinding driver

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Comment actions in driver remove method

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Clear all MSIs at setup

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Add support for DEVCAP2, DEVCTL2, LNKCAP2 and LNKCTL2 registers on emulated bridge

Pali Rohár <pali@kernel.org>
    PCI: pci-bridge-emul: Add definitions for missing capabilities registers

Pali Rohár <pali@kernel.org>
    PCI: pci-bridge-emul: Add description for class_revision field

Frederic Weisbecker <frederic@kernel.org>
    rcu: Apply callbacks processing time limit only on softirq

Frederic Weisbecker <frederic@kernel.org>
    rcu: Fix callbacks processing time limit retaining cond_resched()

Helge Deller <deller@gmx.de>
    Revert "parisc: Mark sched_clock unstable only if clocks are not syncronized"

Ricky WU <ricky_wu@realtek.com>
    mmc: rtsx: add 74 Clocks in power on flow

Sidhartha Kumar <sidhartha.kumar@oracle.com>
    selftest/vm: verify remap destination address in mremap_test

Sidhartha Kumar <sidhartha.kumar@oracle.com>
    selftest/vm: verify mmap addr in mremap_test

Wanpeng Li <wanpengli@tencent.com>
    KVM: LAPIC: Enable timer posted-interrupt only when mwait/hlt is advertised

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86/mmu: avoid NULL-pointer dereference on page freeing bugs

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: Do not change ICR on write to APIC_SELF_IPI

Wanpeng Li <wanpengli@tencent.com>
    x86/kvm: Preserve BSP MSR_KVM_POLL_CONTROL across suspend/resume

Thomas Huth <thuth@redhat.com>
    KVM: selftests: Silence compiler warning in the kvm_page_table_test

Paolo Bonzini <pbonzini@redhat.com>
    kvm: selftests: do not use bitfields larger than 32-bits for PTEs

Hector Martin <marcan@marcan.st>
    iommu/dart: Add missing module owner to ops structure

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5e: Lag, Don't skip fib events on current dst

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5e: Lag, Fix fib_info pointer assignment

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5e: Lag, Fix use-after-free in fib event handler

Aya Levin <ayal@nvidia.com>
    net/mlx5: Fix slab-out-of-bounds while reading resource dump menu

Javier Martinez Canillas <javierm@redhat.com>
    fbdev: Make fb_release() return -ENODEV if fbdev was unregistered

Sandipan Das <sandipan.das@amd.com>
    kvm: x86/cpuid: Only provide CPUID leaf 0xA if host has architectural PMU

Baruch Siach <baruch@tkos.co.il>
    gpio: mvebu: drop pwm base assignment

Kai-Heng Feng <kai.heng.feng@canonical.com>
    drm/amdgpu: Ensure HDA function is suspended before ASIC reset

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdgpu: don't set s3 and s0ix at the same time

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdgpu: explicitly check for s0ix when evicting resources

Nirmoy Das <nirmoy.das@amd.com>
    drm/amdgpu: unify BO evicting method in amdgpu_ttm

Filipe Manana <fdmanana@suse.com>
    btrfs: always log symlinks in full mode

Qu Wenruo <wqu@suse.com>
    btrfs: force v2 space cache usage for subpage mount

Sergey Shtylyov <s.shtylyov@omp.ru>
    smsc911x: allow using IRQ0

Vladimir Oltean <vladimir.oltean@nxp.com>
    selftests: ocelot: tc_flower_chains: specify conform-exceed action for policer

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix unnecessary dropping of RX packets

Somnath Kotur <somnath.kotur@broadcom.com>
    bnxt_en: Fix possible bnxt_open() failure caused by wrong RFS flag

Ido Schimmel <idosch@nvidia.com>
    selftests: mirror_gre_bridge_1q: Avoid changing PVID while interface is operational

David Howells <dhowells@redhat.com>
    rxrpc: Enable IPv6 checksums on transport socket

Eric Dumazet <edumazet@google.com>
    mld: respect RCU rules in ip6_mc_source() and ip6_mc_msfilter()

Qiao Ma <mqaio@linux.alibaba.com>
    hinic: fix bug of wq out of bound access

Filipe Manana <fdmanana@suse.com>
    btrfs: do not BUG_ON() on failure to update inode when setting xattr

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: remove fail safe mode related code

Marc Kleine-Budde <mkl@pengutronix.de>
    selftests/net: so_txtime: usage(): fix documentation of default clock

Marc Kleine-Budde <mkl@pengutronix.de>
    selftests/net: so_txtime: fix parsing of start time stamp on 32 bit systems

Shravya Kumbham <shravya.kumbham@xilinx.com>
    net: emaclite: Add error handling for of_address_to_resource()

Eric Dumazet <edumazet@google.com>
    net: igmp: respect RCU rules in ip_mc_source() and ip_mc_msfilter()

Yang Yingliang <yangyingliang@huawei.com>
    net: cpsw: add missing of_node_put() in cpsw_probe_dt()

Niels Dossche <dossche.niels@gmail.com>
    net: mdio: Fix ENOMEM return value in BCM6368 mux bus controller

Yang Yingliang <yangyingliang@huawei.com>
    net: stmmac: dwmac-sun8i: add missing of_node_put() in sun8i_dwmac_register_mdio_mux()

Yang Yingliang <yangyingliang@huawei.com>
    net: dsa: mt7530: add missing of_node_put() in mt7530_setup()

Yang Yingliang <yangyingliang@huawei.com>
    net: ethernet: mediatek: add missing of_node_put() in mtk_sgmii_init()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Don't invalidate inode attributes on delegation return

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Fix possible crash due to NULL netdev in notifier

Shiraz Saleem <shiraz.saleem@intel.com>
    RDMA/irdma: Reduce iWARP QP destroy time

Tatyana Nikolova <tatyana.e.nikolova@intel.com>
    RDMA/irdma: Flush iWARP QP if modified to ERR from RTR state

Cheng Xu <chengyou@linux.alibaba.com>
    RDMA/siw: Fix a condition race issue in MPA request processing

Olga Kornievskaia <kolga@netapp.com>
    SUNRPC release the transport of a relocated task with an assigned transport

Jann Horn <jannh@google.com>
    selftests/seccomp: Don't call read() on TTY from background pgrp

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Fix deadlock in sync reset flow

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Avoid double clear or set of sync reset requested

Mark Zhang <markzhang@nvidia.com>
    net/mlx5e: Fix the calling of update_buffer_lossy() API

Paul Blakey <paulb@nvidia.com>
    net/mlx5e: CT: Fix queued up restore put() executing after relevant ft release

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5e: Don't match double-vlan packets if cvlan is not set

Moshe Tal <moshet@nvidia.com>
    net/mlx5e: Fix trust state reset in reload

Yang Yingliang <yangyingliang@huawei.com>
    iommu/dart: check return value after calling platform_get_resource()

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Drop stop marker messages

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: soc-ops: fix error handling

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    ASoC: dmaengine: Restore NULL prepare_slave_config() callback

Adam Wujek <dev_public@wujek.eu>
    hwmon: (pmbus) disable PEC if not enabled

Armin Wolf <W_Armin@gmx.de>
    hwmon: (adt7470) Fix warning on module removal

Puyou Lu <puyou.lu@gmail.com>
    gpio: pca953x: fix irq_stat not updated when irq is disabled (irq_mask not set)

Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
    gpio: visconti: Fix fwnode of GPIO IRQ

Duoming Zhou <duoming@zju.edu.cn>
    NFC: netlink: fix sleep in atomic bug when firmware download timeout

Duoming Zhou <duoming@zju.edu.cn>
    nfc: nfcmrvl: main: reorder destructive operations in nfcmrvl_nci_unregister_dev to avoid bugs

Duoming Zhou <duoming@zju.edu.cn>
    nfc: replace improper check device_is_registered() in netlink related functions

Andreas Larsson <andreas@gaisler.com>
    can: grcan: only use the NAPI poll budget for RX

Andreas Larsson <andreas@gaisler.com>
    can: grcan: grcan_probe(): fix broken system id check for errata workaround needs

Daniel Hellstrom <daniel@gaisler.com>
    can: grcan: use ofdev->dev when allocating DMA memory

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: remove re-binding of bound socket

Duoming Zhou <duoming@zju.edu.cn>
    can: grcan: grcan_close(): fix deadlock

Jan Höppner <hoeppner@linux.ibm.com>
    s390/dasd: Fix read inconsistency for ESE DASD devices

Jan Höppner <hoeppner@linux.ibm.com>
    s390/dasd: Fix read for ESE with blksize < 4k

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: prevent double format of tracks for ESE devices

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix data corruption for ESE devices

Mark Brown <broonie@kernel.org>
    ASoC: meson: Fix event generation for AUI CODEC mux

Mark Brown <broonie@kernel.org>
    ASoC: meson: Fix event generation for G12A tohdmi mux

Mark Brown <broonie@kernel.org>
    ASoC: meson: Fix event generation for AUI ACODEC mux

Mark Brown <broonie@kernel.org>
    ASoC: wm8958: Fix change notifications for DSP controls

Mark Brown <broonie@kernel.org>
    ASoC: da7219: Fix change notifications for tone generator frequency

Thomas Pfaff <tpfaff@pcs.com>
    genirq: Synchronize interrupt thread startup

Tan Tee Min <tee.min.tan@linux.intel.com>
    net: stmmac: disable Split Header (SPH) for Intel platforms

Niels Dossche <dossche.niels@gmail.com>
    firewire: core: extend card->lock in fw_core_handle_bus_reset

Jakob Koschel <jakobkoschel@gmail.com>
    firewire: remove check of list iterator against head past the loop body

Chengfeng Ye <cyeaa@connect.ust.hk>
    firewire: fix potential uaf in outbound_phy_packet_callback()

Kurt Kanzenbach <kurt@linutronix.de>
    timekeeping: Mark NMI safe time accessors as notrace

Trond Myklebust <trond.myklebust@hammerspace.com>
    Revert "SUNRPC: attempt AF_LOCAL connect on setup"

Nick Kossifidis <mick@ics.forth.gr>
    RISC-V: relocate DTB if it's outside memory region

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    drm/amdgpu: do not use passthrough mode in Xen dom0

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Avoid reading audio pattern past AUDIO_CHANNELS_COUNT

Nicolin Chen <nicolinc@nvidia.com>
    iommu/arm-smmu-v3: Fix size calculation in arm_smmu_mm_invalidate_range()

David Stevens <stevensd@chromium.org>
    iommu/vt-d: Calculate mask for non-aligned flushes

Kyle Huey <me@kylehuey.com>
    KVM: x86/svm: Account for family 17h event renumberings in amd_pmc_perf_hw_id

Thomas Gleixner <tglx@linutronix.de>
    x86/fpu: Prevent FPU state corruption

Andrei Lalaev <andrei.lalaev@emlid.com>
    gpiolib: of: fix bounds check for 'gpio-reserved-ranges'

Brian Norris <briannorris@chromium.org>
    mmc: core: Set HS clock speed before sending HS CMD13

Samuel Holland <samuel@sholland.org>
    mmc: sunxi-mmc: Fix DMA descriptors allocated above 32 bits

Shaik Sajida Bhanu <quic_c_sbhanu@quicinc.com>
    mmc: sdhci-msm: Reset GCC_SDCC_BCR register for SDHC

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: fireworks: fix wrong return count shorter than expected by 4 bytes

Zihao Wang <wzhd@ustc.edu>
    ALSA: hda/realtek: Add quirk for Yoga Duet 7 13ITL6 speakers

Helge Deller <deller@gmx.de>
    parisc: Merge model and model name into one line in /proc/cpuinfo

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Fix CP0 counter erratum detection for R4k CPUs


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/mips/include/asm/timex.h                      |   8 +-
 arch/mips/kernel/time.c                            |  11 +-
 arch/parisc/kernel/processor.c                     |   3 +-
 arch/parisc/kernel/setup.c                         |   2 +
 arch/parisc/kernel/time.c                          |   6 +-
 arch/riscv/mm/init.c                               |  21 +-
 arch/x86/kernel/fpu/core.c                         |  67 ++--
 arch/x86/kernel/kvm.c                              |  13 +
 arch/x86/kvm/cpuid.c                               |   5 +
 arch/x86/kvm/lapic.c                               |  10 +-
 arch/x86/kvm/mmu/mmu.c                             |   2 +
 arch/x86/kvm/svm/pmu.c                             |  28 +-
 drivers/firewire/core-card.c                       |   3 +
 drivers/firewire/core-cdev.c                       |   4 +-
 drivers/firewire/core-topology.c                   |   9 +-
 drivers/firewire/core-transaction.c                |  30 +-
 drivers/firewire/sbp2.c                            |  13 +-
 drivers/gpio/gpio-mvebu.c                          |   7 -
 drivers/gpio/gpio-pca953x.c                        |   4 +-
 drivers/gpio/gpio-visconti.c                       |   7 +-
 drivers/gpio/gpiolib-of.c                          |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  30 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  24 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |  23 --
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.h         |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  30 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |   4 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |   2 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |   6 -
 drivers/gpu/drm/msm/dp/dp_panel.c                  |  11 -
 drivers/gpu/drm/msm/dp/dp_panel.h                  |   1 -
 drivers/hwmon/adt7470.c                            |   4 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |   3 +
 drivers/infiniband/hw/irdma/cm.c                   |  26 +-
 drivers/infiniband/hw/irdma/utils.c                |  21 +-
 drivers/infiniband/hw/irdma/verbs.c                |   4 +-
 drivers/infiniband/sw/siw/siw_cm.c                 |   7 +-
 drivers/iommu/apple-dart.c                         |  10 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c    |   9 +-
 drivers/iommu/intel/iommu.c                        |  27 +-
 drivers/iommu/intel/svm.c                          |   4 +
 drivers/mmc/core/mmc.c                             |  23 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |  29 +-
 drivers/mmc/host/sdhci-msm.c                       |  42 ++
 drivers/mmc/host/sunxi-mmc.c                       |   5 +-
 drivers/net/can/grcan.c                            |  46 +--
 drivers/net/dsa/mt7530.c                           |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  13 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c    |   7 +-
 drivers/net/ethernet/mediatek/mtk_sgmii.c          |   1 +
 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.c    |  31 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  10 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  11 +
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  60 +--
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |  38 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h   |   7 +-
 drivers/net/ethernet/smsc/smsc911x.c               |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |   5 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |  15 +-
 drivers/net/mdio/mdio-mux-bcm6368.c                |   2 +-
 drivers/nfc/nfcmrvl/main.c                         |   2 +-
 drivers/pci/controller/pci-aardvark.c              | 428 ++++++++++++++++-----
 drivers/pci/pci-bridge-emul.c                      |  49 ++-
 drivers/s390/block/dasd.c                          |  18 +-
 drivers/s390/block/dasd_eckd.c                     |  28 +-
 drivers/s390/block/dasd_int.h                      |  14 +
 drivers/video/fbdev/core/fbmem.c                   |   5 +-
 fs/btrfs/disk-io.c                                 |  11 +
 fs/btrfs/tree-log.c                                |  14 +-
 fs/btrfs/xattr.c                                   |   6 +-
 fs/nfs/nfs4proc.c                                  |  12 +-
 include/linux/stmmac.h                             |   1 +
 kernel/irq/internals.h                             |   2 +
 kernel/irq/irqdesc.c                               |   2 +
 kernel/irq/manage.c                                |  39 +-
 kernel/rcu/tree.c                                  |  31 +-
 kernel/time/timekeeping.c                          |   4 +-
 net/can/isotp.c                                    |  22 +-
 net/ipv4/igmp.c                                    |   9 +-
 net/ipv6/mcast.c                                   |   8 +-
 net/nfc/core.c                                     |  29 +-
 net/nfc/netlink.c                                  |   4 +-
 net/rxrpc/local_object.c                           |   3 +
 net/sunrpc/clnt.c                                  |  11 +-
 net/sunrpc/xprtsock.c                              |   3 -
 sound/firewire/fireworks/fireworks_hwdep.c         |   1 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/da7219.c                          |  14 +-
 sound/soc/codecs/wm8958-dsp2.c                     |   8 +-
 sound/soc/meson/aiu-acodec-ctrl.c                  |   2 +-
 sound/soc/meson/aiu-codec-ctrl.c                   |   2 +-
 sound/soc/meson/g12a-tohdmitx.c                    |   2 +-
 sound/soc/soc-generic-dmaengine-pcm.c              |   6 +-
 sound/soc/soc-ops.c                                |   2 +-
 .../drivers/net/ocelot/tc_flower_chains.sh         |   2 +-
 .../selftests/kvm/include/x86_64/processor.h       |  15 +
 tools/testing/selftests/kvm/kvm_page_table_test.c  |   2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 192 ++++-----
 .../net/forwarding/mirror_gre_bridge_1q.sh         |   3 +
 tools/testing/selftests/net/so_txtime.c            |   4 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |  10 +-
 tools/testing/selftests/vm/mremap_test.c           |  53 +++
 110 files changed, 1293 insertions(+), 656 deletions(-)


