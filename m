Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB3E524B66
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 13:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352974AbiELLSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 07:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353104AbiELLSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 07:18:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E1B2E9DA;
        Thu, 12 May 2022 04:16:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6770861E15;
        Thu, 12 May 2022 11:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B21AC34113;
        Thu, 12 May 2022 11:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652354200;
        bh=OqWUVWVHs4uIuFqKymzYx/xYRhFY3q2vsnExWRFTtlM=;
        h=From:To:Cc:Subject:Date:From;
        b=yQ+Ny5uy09avercSSO1Gj0FOBqzilafpG4swtXITNJ8CueDCJyraaT2nZWj5R7T7i
         RVYH9G0Gdhenf6N/Yf+jWu6F8/Ee050eWj1TIL///rZ2jjEjYS5FRp3LPLBpc+oQzQ
         A26g60f0X3szlSCfOw90GGvRMjo3Y0TjrdPhrhNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.39
Date:   Thu, 12 May 2022 13:16:22 +0200
Message-Id: <165235418220997@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.39 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/mips/include/asm/timex.h                                  |    8 
 arch/mips/kernel/time.c                                        |   11 
 arch/parisc/kernel/processor.c                                 |    3 
 arch/parisc/kernel/setup.c                                     |    2 
 arch/parisc/kernel/time.c                                      |    6 
 arch/riscv/mm/init.c                                           |   21 
 arch/x86/kernel/fpu/core.c                                     |   67 -
 arch/x86/kernel/kvm.c                                          |   13 
 arch/x86/kvm/cpuid.c                                           |    5 
 arch/x86/kvm/lapic.c                                           |   10 
 arch/x86/kvm/mmu/mmu.c                                         |    2 
 arch/x86/kvm/svm/pmu.c                                         |   28 
 drivers/firewire/core-card.c                                   |    3 
 drivers/firewire/core-cdev.c                                   |    4 
 drivers/firewire/core-topology.c                               |    9 
 drivers/firewire/core-transaction.c                            |   30 
 drivers/firewire/sbp2.c                                        |   13 
 drivers/gpio/gpio-mvebu.c                                      |    7 
 drivers/gpio/gpio-pca953x.c                                    |    4 
 drivers/gpio/gpio-visconti.c                                   |    7 
 drivers/gpio/gpiolib-of.c                                      |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c                    |    8 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                     |   30 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                        |   24 
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                     |   23 
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.h                     |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                        |   30 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h                        |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c                       |    4 
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c               |    2 
 drivers/gpu/drm/msm/dp/dp_display.c                            |    6 
 drivers/gpu/drm/msm/dp/dp_panel.c                              |   11 
 drivers/gpu/drm/msm/dp/dp_panel.h                              |    1 
 drivers/hwmon/adt7470.c                                        |    4 
 drivers/hwmon/pmbus/pmbus_core.c                               |    3 
 drivers/infiniband/hw/irdma/cm.c                               |   26 
 drivers/infiniband/hw/irdma/utils.c                            |   21 
 drivers/infiniband/hw/irdma/verbs.c                            |    4 
 drivers/infiniband/sw/siw/siw_cm.c                             |    7 
 drivers/iommu/apple-dart.c                                     |   10 
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c                |    9 
 drivers/iommu/intel/iommu.c                                    |   27 
 drivers/iommu/intel/svm.c                                      |    4 
 drivers/mmc/core/mmc.c                                         |   23 
 drivers/mmc/host/rtsx_pci_sdmmc.c                              |   29 
 drivers/mmc/host/sdhci-msm.c                                   |   42 
 drivers/mmc/host/sunxi-mmc.c                                   |    5 
 drivers/net/can/grcan.c                                        |   46 -
 drivers/net/dsa/mt7530.c                                       |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                      |   13 
 drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c                |    7 
 drivers/net/ethernet/mediatek/mtk_sgmii.c                      |    1 
 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c        |   31 
 drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c       |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c             |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c             |   10 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                |   11 
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c             |   60 -
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c               |   38 
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h               |    7 
 drivers/net/ethernet/smsc/smsc911x.c                           |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c              |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c              |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c              |    2 
 drivers/net/ethernet/ti/cpsw_new.c                             |    5 
 drivers/net/ethernet/xilinx/xilinx_emaclite.c                  |   15 
 drivers/net/mdio/mdio-mux-bcm6368.c                            |    2 
 drivers/nfc/nfcmrvl/main.c                                     |    2 
 drivers/pci/controller/pci-aardvark.c                          |  428 +++++++---
 drivers/pci/pci-bridge-emul.c                                  |   49 +
 drivers/s390/block/dasd.c                                      |   18 
 drivers/s390/block/dasd_eckd.c                                 |   28 
 drivers/s390/block/dasd_int.h                                  |   14 
 drivers/video/fbdev/core/fbmem.c                               |    5 
 fs/btrfs/disk-io.c                                             |   11 
 fs/btrfs/tree-log.c                                            |   14 
 fs/btrfs/xattr.c                                               |    6 
 fs/nfs/nfs4proc.c                                              |   12 
 include/linux/stmmac.h                                         |    1 
 kernel/irq/internals.h                                         |    2 
 kernel/irq/irqdesc.c                                           |    2 
 kernel/irq/manage.c                                            |   39 
 kernel/rcu/tree.c                                              |   31 
 kernel/time/timekeeping.c                                      |    4 
 net/can/isotp.c                                                |   22 
 net/ipv4/igmp.c                                                |    9 
 net/ipv6/mcast.c                                               |    8 
 net/nfc/core.c                                                 |   29 
 net/nfc/netlink.c                                              |    4 
 net/rxrpc/local_object.c                                       |    3 
 net/sunrpc/clnt.c                                              |   11 
 net/sunrpc/xprtsock.c                                          |    3 
 sound/firewire/fireworks/fireworks_hwdep.c                     |    1 
 sound/pci/hda/patch_realtek.c                                  |    1 
 sound/soc/codecs/da7219.c                                      |   14 
 sound/soc/codecs/wm8958-dsp2.c                                 |    8 
 sound/soc/meson/aiu-acodec-ctrl.c                              |    2 
 sound/soc/meson/aiu-codec-ctrl.c                               |    2 
 sound/soc/meson/g12a-tohdmitx.c                                |    2 
 sound/soc/soc-generic-dmaengine-pcm.c                          |    6 
 sound/soc/soc-ops.c                                            |    2 
 tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh |    2 
 tools/testing/selftests/kvm/include/x86_64/processor.h         |   15 
 tools/testing/selftests/kvm/kvm_page_table_test.c              |    2 
 tools/testing/selftests/kvm/lib/x86_64/processor.c             |  192 +---
 tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh |    3 
 tools/testing/selftests/net/so_txtime.c                        |    4 
 tools/testing/selftests/seccomp/seccomp_bpf.c                  |   10 
 tools/testing/selftests/vm/mremap_test.c                       |   53 +
 110 files changed, 1292 insertions(+), 655 deletions(-)

Adam Wujek (1):
      hwmon: (pmbus) disable PEC if not enabled

Andreas Larsson (2):
      can: grcan: grcan_probe(): fix broken system id check for errata workaround needs
      can: grcan: only use the NAPI poll budget for RX

Andrei Lalaev (1):
      gpiolib: of: fix bounds check for 'gpio-reserved-ranges'

Armin Wolf (1):
      hwmon: (adt7470) Fix warning on module removal

Aya Levin (1):
      net/mlx5: Fix slab-out-of-bounds while reading resource dump menu

Baruch Siach (1):
      gpio: mvebu: drop pwm base assignment

Brian Norris (1):
      mmc: core: Set HS clock speed before sending HS CMD13

Cheng Xu (1):
      RDMA/siw: Fix a condition race issue in MPA request processing

Chengfeng Ye (1):
      firewire: fix potential uaf in outbound_phy_packet_callback()

Codrin Ciubotariu (1):
      ASoC: dmaengine: Restore NULL prepare_slave_config() callback

Daniel Hellstrom (1):
      can: grcan: use ofdev->dev when allocating DMA memory

David Howells (1):
      rxrpc: Enable IPv6 checksums on transport socket

David Stevens (1):
      iommu/vt-d: Calculate mask for non-aligned flushes

Duoming Zhou (4):
      can: grcan: grcan_close(): fix deadlock
      nfc: replace improper check device_is_registered() in netlink related functions
      nfc: nfcmrvl: main: reorder destructive operations in nfcmrvl_nci_unregister_dev to avoid bugs
      NFC: netlink: fix sleep in atomic bug when firmware download timeout

Eric Dumazet (2):
      net: igmp: respect RCU rules in ip_mc_source() and ip_mc_msfilter()
      mld: respect RCU rules in ip6_mc_source() and ip6_mc_msfilter()

Filipe Manana (2):
      btrfs: do not BUG_ON() on failure to update inode when setting xattr
      btrfs: always log symlinks in full mode

Frederic Weisbecker (2):
      rcu: Fix callbacks processing time limit retaining cond_resched()
      rcu: Apply callbacks processing time limit only on softirq

Greg Kroah-Hartman (1):
      Linux 5.15.39

Harry Wentland (1):
      drm/amd/display: Avoid reading audio pattern past AUDIO_CHANNELS_COUNT

Hector Martin (1):
      iommu/dart: Add missing module owner to ops structure

Helge Deller (2):
      parisc: Merge model and model name into one line in /proc/cpuinfo
      Revert "parisc: Mark sched_clock unstable only if clocks are not syncronized"

Ido Schimmel (1):
      selftests: mirror_gre_bridge_1q: Avoid changing PVID while interface is operational

Jakob Koschel (1):
      firewire: remove check of list iterator against head past the loop body

Jan Höppner (2):
      s390/dasd: Fix read for ESE with blksize < 4k
      s390/dasd: Fix read inconsistency for ESE DASD devices

Jann Horn (1):
      selftests/seccomp: Don't call read() on TTY from background pgrp

Javier Martinez Canillas (1):
      fbdev: Make fb_release() return -ENODEV if fbdev was unregistered

Kai-Heng Feng (1):
      drm/amdgpu: Ensure HDA function is suspended before ASIC reset

Kuogee Hsieh (1):
      drm/msm/dp: remove fail safe mode related code

Kurt Kanzenbach (1):
      timekeeping: Mark NMI safe time accessors as notrace

Kyle Huey (1):
      KVM: x86/svm: Account for family 17h event renumberings in amd_pmc_perf_hw_id

Lu Baolu (1):
      iommu/vt-d: Drop stop marker messages

Maciej W. Rozycki (1):
      MIPS: Fix CP0 counter erratum detection for R4k CPUs

Marc Kleine-Budde (2):
      selftests/net: so_txtime: fix parsing of start time stamp on 32 bit systems
      selftests/net: so_txtime: usage(): fix documentation of default clock

Marek Behún (5):
      PCI: aardvark: Make MSI irq_chip structures static driver structures
      PCI: aardvark: Make msi_domain_info structure a static driver structure
      PCI: aardvark: Use dev_fwnode() instead of of_node_to_fwnode(dev->of_node)
      PCI: aardvark: Drop __maybe_unused from advk_pcie_disable_phy()
      PCI: aardvark: Update comment about link going down after link-up

Marek Marczykowski-Górecki (1):
      drm/amdgpu: do not use passthrough mode in Xen dom0

Mario Limonciello (2):
      drm/amdgpu: explicitly check for s0ix when evicting resources
      drm/amdgpu: don't set s3 and s0ix at the same time

Mark Brown (5):
      ASoC: da7219: Fix change notifications for tone generator frequency
      ASoC: wm8958: Fix change notifications for DSP controls
      ASoC: meson: Fix event generation for AUI ACODEC mux
      ASoC: meson: Fix event generation for G12A tohdmi mux
      ASoC: meson: Fix event generation for AUI CODEC mux

Mark Zhang (1):
      net/mlx5e: Fix the calling of update_buffer_lossy() API

Michael Chan (1):
      bnxt_en: Fix unnecessary dropping of RX packets

Moshe Shemesh (2):
      net/mlx5: Avoid double clear or set of sync reset requested
      net/mlx5: Fix deadlock in sync reset flow

Moshe Tal (1):
      net/mlx5e: Fix trust state reset in reload

Mustafa Ismail (1):
      RDMA/irdma: Fix possible crash due to NULL netdev in notifier

Nick Kossifidis (1):
      RISC-V: relocate DTB if it's outside memory region

Nicolin Chen (1):
      iommu/arm-smmu-v3: Fix size calculation in arm_smmu_mm_invalidate_range()

Niels Dossche (2):
      firewire: core: extend card->lock in fw_core_handle_bus_reset
      net: mdio: Fix ENOMEM return value in BCM6368 mux bus controller

Nirmoy Das (1):
      drm/amdgpu: unify BO evicting method in amdgpu_ttm

Nobuhiro Iwamatsu (1):
      gpio: visconti: Fix fwnode of GPIO IRQ

Olga Kornievskaia (1):
      SUNRPC release the transport of a relocated task with an assigned transport

Oliver Hartkopp (1):
      can: isotp: remove re-binding of bound socket

Pali Rohár (25):
      PCI: pci-bridge-emul: Add description for class_revision field
      PCI: pci-bridge-emul: Add definitions for missing capabilities registers
      PCI: aardvark: Add support for DEVCAP2, DEVCTL2, LNKCAP2 and LNKCTL2 registers on emulated bridge
      PCI: aardvark: Clear all MSIs at setup
      PCI: aardvark: Comment actions in driver remove method
      PCI: aardvark: Disable bus mastering when unbinding driver
      PCI: aardvark: Mask all interrupts when unbinding driver
      PCI: aardvark: Fix memory leak in driver unbind
      PCI: aardvark: Assert PERST# when unbinding driver
      PCI: aardvark: Disable link training when unbinding driver
      PCI: aardvark: Disable common PHY when unbinding driver
      PCI: aardvark: Replace custom PCIE_CORE_INT_* macros with PCI_INTERRUPT_*
      PCI: aardvark: Rewrite IRQ code to chained IRQ handler
      PCI: aardvark: Check return value of generic_handle_domain_irq() when processing INTx IRQ
      PCI: aardvark: Refactor unmasking summary MSI interrupt
      PCI: aardvark: Add support for masking MSI interrupts
      PCI: aardvark: Fix setting MSI address
      PCI: aardvark: Enable MSI-X support
      PCI: aardvark: Add support for ERR interrupt on emulated bridge
      PCI: aardvark: Optimize writing PCI_EXP_RTCTL_PMEIE and PCI_EXP_RTSTA_PME on emulated bridge
      PCI: aardvark: Add support for PME interrupts
      PCI: aardvark: Fix support for PME requester on emulated bridge
      PCI: aardvark: Use separate INTA interrupt for emulated root bridge
      PCI: aardvark: Remove irq_mask_ack() callback for INTx interrupts
      PCI: aardvark: Don't mask irq when mapping

Paolo Bonzini (3):
      kvm: selftests: do not use bitfields larger than 32-bits for PTEs
      KVM: x86: Do not change ICR on write to APIC_SELF_IPI
      KVM: x86/mmu: avoid NULL-pointer dereference on page freeing bugs

Paul Blakey (1):
      net/mlx5e: CT: Fix queued up restore put() executing after relevant ft release

Pierre-Louis Bossart (1):
      ASoC: soc-ops: fix error handling

Puyou Lu (1):
      gpio: pca953x: fix irq_stat not updated when irq is disabled (irq_mask not set)

Qiao Ma (1):
      hinic: fix bug of wq out of bound access

Qu Wenruo (1):
      btrfs: force v2 space cache usage for subpage mount

Ricky WU (1):
      mmc: rtsx: add 74 Clocks in power on flow

Samuel Holland (1):
      mmc: sunxi-mmc: Fix DMA descriptors allocated above 32 bits

Sandipan Das (1):
      kvm: x86/cpuid: Only provide CPUID leaf 0xA if host has architectural PMU

Sergey Shtylyov (1):
      smsc911x: allow using IRQ0

Shaik Sajida Bhanu (1):
      mmc: sdhci-msm: Reset GCC_SDCC_BCR register for SDHC

Shiraz Saleem (1):
      RDMA/irdma: Reduce iWARP QP destroy time

Shravya Kumbham (1):
      net: emaclite: Add error handling for of_address_to_resource()

Sidhartha Kumar (2):
      selftest/vm: verify mmap addr in mremap_test
      selftest/vm: verify remap destination address in mremap_test

Somnath Kotur (1):
      bnxt_en: Fix possible bnxt_open() failure caused by wrong RFS flag

Stefan Haberland (2):
      s390/dasd: fix data corruption for ESE devices
      s390/dasd: prevent double format of tracks for ESE devices

Takashi Sakamoto (1):
      ALSA: fireworks: fix wrong return count shorter than expected by 4 bytes

Tan Tee Min (1):
      net: stmmac: disable Split Header (SPH) for Intel platforms

Tatyana Nikolova (1):
      RDMA/irdma: Flush iWARP QP if modified to ERR from RTR state

Thomas Gleixner (1):
      x86/fpu: Prevent FPU state corruption

Thomas Huth (1):
      KVM: selftests: Silence compiler warning in the kvm_page_table_test

Thomas Pfaff (1):
      genirq: Synchronize interrupt thread startup

Trond Myklebust (2):
      Revert "SUNRPC: attempt AF_LOCAL connect on setup"
      NFSv4: Don't invalidate inode attributes on delegation return

Vlad Buslov (4):
      net/mlx5e: Don't match double-vlan packets if cvlan is not set
      net/mlx5e: Lag, Fix use-after-free in fib event handler
      net/mlx5e: Lag, Fix fib_info pointer assignment
      net/mlx5e: Lag, Don't skip fib events on current dst

Vladimir Oltean (1):
      selftests: ocelot: tc_flower_chains: specify conform-exceed action for policer

Wanpeng Li (2):
      x86/kvm: Preserve BSP MSR_KVM_POLL_CONTROL across suspend/resume
      KVM: LAPIC: Enable timer posted-interrupt only when mwait/hlt is advertised

Yang Yingliang (5):
      iommu/dart: check return value after calling platform_get_resource()
      net: ethernet: mediatek: add missing of_node_put() in mtk_sgmii_init()
      net: dsa: mt7530: add missing of_node_put() in mt7530_setup()
      net: stmmac: dwmac-sun8i: add missing of_node_put() in sun8i_dwmac_register_mdio_mux()
      net: cpsw: add missing of_node_put() in cpsw_probe_dt()

Zihao Wang (1):
      ALSA: hda/realtek: Add quirk for Yoga Duet 7 13ITL6 speakers

