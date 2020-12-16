Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A412F2DC0DF
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 14:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgLPNOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 08:14:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:35108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgLPNOB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Dec 2020 08:14:01 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.9.15
Date:   Wed, 16 Dec 2020 14:14:17 +0100
Message-Id: <160812445724124@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.9.15 kernel.

All users of the 5.9 kernel series must upgrade.

The updated 5.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                 |    5 
 arch/alpha/kernel/process.c                              |    2 
 arch/arc/kernel/stacktrace.c                             |   23 +-
 arch/arm/configs/omap2plus_defconfig                     |    1 
 arch/arm/kernel/process.c                                |    2 
 arch/arm/mach-omap1/board-osk.c                          |    2 
 arch/arm64/boot/dts/broadcom/stingray/stingray-usb.dtsi  |   20 +-
 arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts       |   12 -
 arch/arm64/boot/dts/rockchip/rk3326-odroid-go2.dts       |    1 
 arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi          |    4 
 arch/arm64/boot/dts/rockchip/rk3399.dtsi                 |    3 
 arch/arm64/kernel/process.c                              |    2 
 arch/csky/kernel/process.c                               |    2 
 arch/h8300/kernel/process.c                              |    2 
 arch/hexagon/kernel/process.c                            |    2 
 arch/ia64/kernel/process.c                               |    2 
 arch/microblaze/kernel/process.c                         |    2 
 arch/mips/kernel/idle.c                                  |   12 -
 arch/nios2/kernel/process.c                              |    2 
 arch/openrisc/kernel/process.c                           |    2 
 arch/parisc/kernel/process.c                             |    2 
 arch/powerpc/Makefile                                    |    1 
 arch/powerpc/kernel/idle.c                               |    4 
 arch/powerpc/mm/book3s64/hash_native.c                   |    2 
 arch/riscv/kernel/process.c                              |    2 
 arch/s390/kernel/entry.S                                 |   15 -
 arch/s390/kernel/idle.c                                  |    6 
 arch/s390/lib/delay.c                                    |    5 
 arch/sh/kernel/idle.c                                    |    2 
 arch/sparc/kernel/leon_pmc.c                             |    4 
 arch/sparc/kernel/process_32.c                           |    2 
 arch/sparc/kernel/process_64.c                           |    4 
 arch/um/kernel/process.c                                 |    2 
 arch/x86/events/intel/ds.c                               |    2 
 arch/x86/include/asm/mwait.h                             |    2 
 arch/x86/include/asm/pgtable_types.h                     |    1 
 arch/x86/include/asm/sync_core.h                         |    9 -
 arch/x86/kernel/apic/vector.c                            |   24 +-
 arch/x86/kernel/kprobes/opt.c                            |   22 ++
 arch/x86/kernel/process.c                                |   12 -
 arch/x86/mm/mem_encrypt_identity.c                       |    4 
 arch/x86/mm/tlb.c                                        |   10 -
 drivers/Makefile                                         |    1 
 drivers/block/xen-blkback/blkback.c                      |   89 ++--------
 drivers/block/xen-blkback/common.h                       |    4 
 drivers/block/xen-blkback/xenbus.c                       |    6 
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c                   |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c        |    9 -
 drivers/gpu/drm/exynos/Kconfig                           |    3 
 drivers/gpu/drm/i915/display/intel_dp.c                  |    2 
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c           |    7 
 drivers/gpu/drm/i915/gt/intel_lrc.c                      |    7 
 drivers/gpu/drm/i915/gt/intel_mocs.c                     |    7 
 drivers/gpu/drm/panel/panel-sony-acx565akm.c             |    2 
 drivers/gpu/drm/rockchip/rockchip_lvds.c                 |    2 
 drivers/idle/intel_idle.c                                |   37 ++--
 drivers/input/misc/cm109.c                               |    7 
 drivers/input/serio/i8042-x86ia64io.h                    |   42 +++++
 drivers/interconnect/qcom/msm8916.c                      |   12 -
 drivers/interconnect/qcom/qcs404.c                       |    4 
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c               |    4 
 drivers/irqchip/irq-gic-v3-its.c                         |   16 -
 drivers/media/cec/usb/pulse8/pulse8-cec.c                |   52 ++++--
 drivers/misc/habanalabs/gaudi/gaudi.c                    |    2 
 drivers/mmc/core/block.c                                 |    2 
 drivers/mmc/host/mtk-sd.c                                |   33 +++-
 drivers/mmc/host/sdhci-of-arasan.c                       |    3 
 drivers/net/can/c_can/c_can.c                            |   18 +-
 drivers/net/can/kvaser_pciefd.c                          |    4 
 drivers/net/can/m_can/m_can.c                            |    2 
 drivers/net/can/m_can/tcan4x5x.c                         |   11 -
 drivers/net/can/sja1000/sja1000.c                        |    1 
 drivers/net/can/sun4i_can.c                              |    1 
 drivers/net/ethernet/broadcom/Kconfig                    |    1 
 drivers/net/ethernet/ibm/ibmvnic.c                       |   98 +++++++----
 drivers/net/ethernet/ibm/ibmvnic.h                       |    1 
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h          |   10 -
 drivers/net/wireless/intel/iwlwifi/iwl-config.h          |    4 
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h             |   10 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c        |    2 
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c             |   18 ++
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c |   20 ++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c          |   36 +++-
 drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c        |    5 
 drivers/pinctrl/intel/pinctrl-jasperlake.c               |    2 
 drivers/pinctrl/pinctrl-amd.c                            |    7 
 drivers/platform/x86/acer-wmi.c                          |    1 
 drivers/platform/x86/intel-vbtn.c                        |    6 
 drivers/platform/x86/thinkpad_acpi.c                     |   12 +
 drivers/platform/x86/touchscreen_dmi.c                   |   50 ++++++
 drivers/scsi/be2iscsi/be_main.c                          |    4 
 drivers/scsi/storvsc_drv.c                               |    4 
 drivers/scsi/ufs/ufshcd.c                                |   31 ++-
 drivers/soc/fsl/dpio/dpio-driver.c                       |    5 
 drivers/spi/spi-nxp-fspi.c                               |    7 
 drivers/usb/host/ohci-omap.c                             |    4 
 drivers/vdpa/Kconfig                                     |    1 
 drivers/vhost/vdpa.c                                     |   80 +++++++--
 drivers/xen/grant-table.c                                |  123 +++++++++++++++
 drivers/xen/unpopulated-alloc.c                          |   20 +-
 drivers/xen/xen-scsiback.c                               |   60 +------
 fs/btrfs/ctree.h                                         |    5 
 fs/btrfs/qgroup.c                                        |   66 +++++++-
 fs/proc/task_mmu.c                                       |    8 
 fs/zonefs/super.c                                        |   14 -
 include/asm-generic/barrier.h                            |    1 
 include/linux/build_bug.h                                |    5 
 include/linux/compiler-clang.h                           |    6 
 include/linux/compiler-gcc.h                             |   19 --
 include/linux/compiler.h                                 |   18 +-
 include/linux/netdevice.h                                |   14 +
 include/linux/zsmalloc.h                                 |    1 
 include/xen/grant_table.h                                |   17 ++
 kernel/kprobes.c                                         |   41 +++--
 kernel/sched/idle.c                                      |   28 +++
 lib/zlib_dfltcc/dfltcc_inflate.c                         |    3 
 mm/Kconfig                                               |   13 -
 mm/hugetlb.c                                             |    1 
 mm/mmap.c                                                |   26 +--
 mm/zsmalloc.c                                            |   48 -----
 net/batman-adv/fragmentation.c                           |   26 +--
 net/batman-adv/hard-interface.c                          |    3 
 net/core/dev.c                                           |    8 
 net/netfilter/ipvs/ip_vs_ctl.c                           |   31 +++
 net/xdp/xsk.c                                            |    8 
 samples/ftrace/ftrace-direct-modify.c                    |    2 
 samples/ftrace/ftrace-direct-too.c                       |    1 
 samples/ftrace/ftrace-direct.c                           |    1 
 sound/soc/intel/boards/bytcr_rt5640.c                    |   17 +-
 tools/bootconfig/main.c                                  |   30 +++
 tools/bpf/bpftool/btf.c                                  |    1 
 tools/testing/ktest/ktest.pl                             |    2 
 132 files changed, 1094 insertions(+), 624 deletions(-)

Al Cooper (1):
      phy: usb: Fix incorrect clearing of tca_drv_sel bit in SETUP reg for 7211

Alex Deucher (1):
      drm/amdgpu/disply: set num_crtc earlier

Andy Lutomirski (1):
      x86/membarrier: Get rid of a dubious optimization

Arnd Bergmann (1):
      kbuild: avoid static_assert for genksyms

Arvind Sankar (2):
      x86/mm/mem_encrypt: Fix definition of PMD_FLAGS_DEC_WP
      compiler.h: fix barrier_data() on clang

Bean Huo (1):
      mmc: block: Fixup condition for CMD13 polling for RPMB requests

Björn Töpel (1):
      net, xsk: Avoid taking multiple skbuff references

Can Guo (2):
      scsi: ufs: Fix unexpected values from ufshcd_read_desc_param()
      scsi: ufs: Make sure clk scaling happens only when HBA is runtime ACTIVE

Chris Chiu (1):
      Input: i8042 - add Acer laptops to the i8042 reset list

Chris Wilson (4):
      drm/i915/gem: Propagate error from cancelled submit due to context closure
      drm/i915/gt: Declare gen9 has 64 mocs entries!
      drm/i915/gt: Ignore repeated attempts to suspend request flow across reset
      drm/i915/gt: Cancel the preemption timeout on responding to it

Coiby Xu (1):
      pinctrl: amd: remove debounce filter setting in IRQ type setting

Damien Le Moal (1):
      zonefs: fix page reference and BIO leak

Dan Carpenter (1):
      scsi: be2iscsi: Revert "Fix a theoretical leak in beiscsi_create_eqs()"

Dany Madden (5):
      ibmvnic: handle inconsistent login with reset
      ibmvnic: stop free_all_rwi on failed reset
      ibmvnic: avoid memset null scrq msgs
      ibmvnic: send_login should check for crq errors
      ibmvnic: reduce wait for completion time

Dmitry Torokhov (1):
      Input: cm109 - do not stomp on control URB

Evan Green (1):
      pinctrl: jasperlake: Fix HOSTSW_OWN offset

Filipe Manana (2):
      btrfs: do nofs allocations when adding and removing qgroup relations
      btrfs: fix lockdep splat when enabling and disabling qgroups

Georgi Djakov (2):
      interconnect: qcom: msm8916: Remove rpm-ids from non-RPM nodes
      interconnect: qcom: qcs404: Remove GPU and display RPM IDs

Gerald Schaefer (1):
      mm/hugetlb: clear compound_nr before freeing gigantic pages

Greg Kroah-Hartman (1):
      Linux 5.9.15

Hans Verkuil (2):
      media: pulse8-cec: fix duplicate free at disconnect or probe error
      media: pulse8-cec: add support for FW v10 and up

Hans de Goede (5):
      ASoC: Intel: bytcr_rt5640: Fix HP Pavilion x2 Detachable quirks
      platform/x86: thinkpad_acpi: Do not report SW_TABLET_MODE on Yoga 11e
      platform/x86: thinkpad_acpi: Add BAT1 is primary battery quirk for Thinkpad Yoga 11e 4th gen
      platform/x86: touchscreen_dmi: Add info for the Predia Basic tablet
      platform/x86: touchscreen_dmi: Add info for the Irbis TW118 tablet

Hao Si (1):
      soc: fsl: dpio: Get the cpumask through cpumask_of(cpu)

Heiko Carstens (1):
      s390: fix irq state tracing

Iakov 'Jake' Kirilenko (1):
      platform/x86: thinkpad_acpi: add P1 gen3 second fan support

Jeroen Hofstee (2):
      can: sja1000: sja1000_err(): don't count arbitration lose as an error
      can: sun4i_can: sun4i_can_err(): don't count arbitration lose as an error

Jing Xiangfeng (1):
      scsi: storvsc: Fix error return in storvsc_probe()

Johannes Berg (2):
      iwlwifi: pcie: limit memory read spin time
      iwlwifi: pcie: set LTR to avoid completion timeout

John Stultz (1):
      arm-smmu-qcom: Ensure the qcom_scm driver has finished probing

Jon Hunter (1):
      arm64: tegra: Disable the ACONNECT for Jetson TX2

Juergen Gross (2):
      xen: add helpers for caching grant mapping pages
      xen: don't use page->lru for ZONE_DEVICE memory

Krzysztof Kozlowski (1):
      drm/exynos: depend on COMMON_CLK to fix compile tests

Libo Chen (1):
      ktest.pl: Fix incorrect reboot for grub2bls

Lijun Pan (1):
      ibmvnic: skip tx timeout reset while in resetting

Linus Walleij (1):
      usb: ohci-omap: Fix descriptor conversion

Liu Zixian (1):
      mm/mmap.c: fix mmap return value when vma is merged after call_mmap()

Luca Coelho (1):
      iwlwifi: pcie: invert values of NO_160 device config entries

Maciej Matuszczyk (1):
      arm64: dts: rockchip: Remove system-power-controller from pmic on Odroid Go Advance

Manasi Navare (1):
      drm/i915/display/dp: Compute the correct slice count for VDSC on DP

Marc Kleine-Budde (1):
      can: m_can: tcan4x5x_can_probe(): fix error path: remove erroneous clk_disable_unprepare()

Markus Reichl (2):
      arm64: dts: rockchip: Assign a fixed index to mmc devices on rk3399 boards.
      arm64: dts: rockchip: Reorder LED triggers from mmc devices on rk3399-roc-pc.

Masami Hiramatsu (3):
      kprobes: Remove NMI context check
      tools/bootconfig: Fix to check the write failure correctly
      x86/kprobes: Fix optprobe to detect INT3 padding correctly

Matthias Maier (1):
      platform/x86: thinkpad_acpi: Whitelist P15 firmware for dual fan control

Max Verevkin (1):
      platform/x86: intel-vbtn: Support for tablet mode on HP Pavilion 13 x360 PC

Michael Ellerman (1):
      powerpc: Drop -me200 addition to build flags

Miles Chen (1):
      proc: use untagged_addr() for pagemap_read addresses

Minchan Kim (1):
      mm/zsmalloc.c: drop ZSMALLOC_PGTABLE_MAPPING

Mordechay Goodstein (1):
      iwlwifi: sta: set max HE max A-MPDU according to HE capa

Muhammad Husaini Zulkifli (1):
      mmc: sdhci-of-arasan: Fix clock registration error for Keem Bay SOC

Namhyung Kim (1):
      perf/x86/intel: Fix a warning on x86_pmu_stop() with large PEBS

Nicholas Piggin (1):
      powerpc/64s: Fix hash ISA v3.0 TLBIEL instruction generation

Nick Desaulniers (1):
      Kbuild: do not emit debug info for assembly with LLVM_IAS=1

Oded Gabbay (1):
      habanalabs/gaudi: fix missing code in ECC handling

Pankaj Sharma (1):
      can: m_can: m_can_dev_setup(): add support for bosch mcan version 3.3.0

Paul Kocialkowski (1):
      drm/rockchip: Avoid uninitialized use of endpoint id in LVDS

Peter Zijlstra (3):
      sched/idle: Fix arch_cpu_idle() vs tracing
      intel_idle: Fix intel_idle() vs tracing
      intel_idle: Build fix

Ran Wang (1):
      spi: spi-nxp-fspi: fix fspi panic by unexpected interrupts

Randy Dunlap (3):
      net: broadcom CNIC: requires MMU
      vdpa: mlx5: fix vdpa/vhost dependencies
      zlib: export S390 symbols for zlib modules

Sami Tolvanen (1):
      samples/ftrace: Mark my_tramp[12]? global

Sara Sharon (1):
      iwlwifi: mvm: fix kernel panic in case of assert during CSA

Sebastian Reichel (1):
      drm/panel: sony-acx565akm: Fix race condition in probe

Si-Wei Liu (1):
      vhost-vdpa: fix page pinning leakage in error path (rework)

Stanley.Yang (1):
      drm/amdgpu: fix sdma instance fw version and feature version init

Steven Rostedt (VMware) (1):
      kprobes: Tell lockdep about kprobe nesting

Sukadev Bhattiprolu (2):
      ibmvnic: delay next reset if hard reset fails
      ibmvnic: track pending login

Sven Eckelmann (3):
      batman-adv: Consider fragmentation for needed_headroom
      batman-adv: Reserve needed_*room for fragments
      batman-adv: Don't always reallocate the fragmentation skb head

Thomas Gleixner (1):
      x86/apic/vector: Fix ordering in vector assignment

Timo Witte (1):
      platform/x86: acer-wmi: add automatic keyboard background light toggle key as KEY_LIGHTS_TOGGLE

Vineet Gupta (1):
      ARC: stack unwinding: don't assume non-current task is sleeping

Wang Hai (1):
      ipvs: fix possible memory leak in ip_vs_control_net_init

Wenbin Mei (1):
      mmc: mediatek: Fix system suspend/resume support for CQHCI

Xu Qiang (1):
      irqchip/gic-v3-its: Unconditionally save/restore the ITS state on suspend

Zhang Qilong (2):
      can: c_can: c_can_power_up(): fix error handling
      can: kvaser_pciefd: kvaser_pciefd_open(): fix error handling

Zhen Lei (2):
      bpftool: Fix error return value in build_btf_type_table
      arm64: dts: broadcom: clear the warnings caused by empty dma-ranges

yong mao (1):
      mmc: mediatek: Extend recheck_sdio_irq fix to more variants

