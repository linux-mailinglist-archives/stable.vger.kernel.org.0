Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4B72D9FEB
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502621AbgLNTHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:07:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408586AbgLNRhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:12 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.9 000/105] 5.9.15-rc1 review
Date:   Mon, 14 Dec 2020 18:27:34 +0100
Message-Id: <20201214172555.280929671@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.9.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.9.15-rc1
X-KernelTest-Deadline: 2020-12-16T17:26+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.9.15 release.
There are 105 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 16 Dec 2020 17:25:32 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.15-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.9.15-rc1

Arvind Sankar <nivedita@alum.mit.edu>
    compiler.h: fix barrier_data() on clang

Masami Hiramatsu <mhiramat@kernel.org>
    x86/kprobes: Fix optprobe to detect INT3 padding correctly

Thomas Gleixner <tglx@linutronix.de>
    x86/apic/vector: Fix ordering in vector assignment

Andy Lutomirski <luto@kernel.org>
    x86/membarrier: Get rid of a dubious optimization

Arvind Sankar <nivedita@alum.mit.edu>
    x86/mm/mem_encrypt: Fix definition of PMD_FLAGS_DEC_WP

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: be2iscsi: Revert "Fix a theoretical leak in beiscsi_create_eqs()"

Damien Le Moal <damien.lemoal@wdc.com>
    zonefs: fix page reference and BIO leak

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    mm/hugetlb: clear compound_nr before freeing gigantic pages

Miles Chen <miles.chen@mediatek.com>
    proc: use untagged_addr() for pagemap_read addresses

Arnd Bergmann <arnd@arndb.de>
    kbuild: avoid static_assert for genksyms

Stanley.Yang <Stanley.Yang@amd.com>
    drm/amdgpu: fix sdma instance fw version and feature version init

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Cancel the preemption timeout on responding to it

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Ignore repeated attempts to suspend request flow across reset

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Declare gen9 has 64 mocs entries!

Manasi Navare <manasi.d.navare@intel.com>
    drm/i915/display/dp: Compute the correct slice count for VDSC on DP

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gem: Propagate error from cancelled submit due to context closure

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/disply: set num_crtc earlier

Bean Huo <beanhuo@micron.com>
    mmc: block: Fixup condition for CMD13 polling for RPMB requests

Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
    mmc: sdhci-of-arasan: Fix clock registration error for Keem Bay SOC

Coiby Xu <coiby.xu@gmail.com>
    pinctrl: amd: remove debounce filter setting in IRQ type setting

Evan Green <evgreen@chromium.org>
    pinctrl: jasperlake: Fix HOSTSW_OWN offset

Chris Chiu <chiu@endlessos.org>
    Input: i8042 - add Acer laptops to the i8042 reset list

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: cm109 - do not stomp on control URB

Juergen Gross <jgross@suse.com>
    xen: don't use page->lru for ZONE_DEVICE memory

Juergen Gross <jgross@suse.com>
    xen: add helpers for caching grant mapping pages

Libo Chen <libo.chen@oracle.com>
    ktest.pl: Fix incorrect reboot for grub2bls

yong mao <yong.mao@mediatek.com>
    mmc: mediatek: Extend recheck_sdio_irq fix to more variants

Wenbin Mei <wenbin.mei@mediatek.com>
    mmc: mediatek: Fix system suspend/resume support for CQHCI

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: pulse8-cec: add support for FW v10 and up

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: pulse8-cec: fix duplicate free at disconnect or probe error

Peter Zijlstra <peterz@infradead.org>
    intel_idle: Build fix

Heiko Carstens <hca@linux.ibm.com>
    s390: fix irq state tracing

Pankaj Sharma <pankj.sharma@samsung.com>
    can: m_can: m_can_dev_setup(): add support for bosch mcan version 3.3.0

Hans de Goede <hdegoede@redhat.com>
    platform/x86: touchscreen_dmi: Add info for the Irbis TW118 tablet

Hans de Goede <hdegoede@redhat.com>
    platform/x86: touchscreen_dmi: Add info for the Predia Basic tablet

Max Verevkin <me@maxverevkin.tk>
    platform/x86: intel-vbtn: Support for tablet mode on HP Pavilion 13 x360 PC

Timo Witte <timo.witte@gmail.com>
    platform/x86: acer-wmi: add automatic keyboard background light toggle key as KEY_LIGHTS_TOGGLE

Matthias Maier <tamiko@43-1.org>
    platform/x86: thinkpad_acpi: Whitelist P15 firmware for dual fan control

Hans de Goede <hdegoede@redhat.com>
    platform/x86: thinkpad_acpi: Add BAT1 is primary battery quirk for Thinkpad Yoga 11e 4th gen

Hans de Goede <hdegoede@redhat.com>
    platform/x86: thinkpad_acpi: Do not report SW_TABLET_MODE on Yoga 11e

Iakov 'Jake' Kirilenko <jake.kirilenko@gmail.com>
    platform/x86: thinkpad_acpi: add P1 gen3 second fan support

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Disable the ACONNECT for Jetson TX2

Peter Zijlstra <peterz@infradead.org>
    intel_idle: Fix intel_idle() vs tracing

Peter Zijlstra <peterz@infradead.org>
    sched/idle: Fix arch_cpu_idle() vs tracing

Hao Si <si.hao@zte.com.cn>
    soc: fsl: dpio: Get the cpumask through cpumask_of(cpu)

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lockdep splat when enabling and disabling qgroups

Filipe Manana <fdmanana@suse.com>
    btrfs: do nofs allocations when adding and removing qgroup relations

Oded Gabbay <ogabbay@kernel.org>
    habanalabs/gaudi: fix missing code in ECC handling

John Stultz <john.stultz@linaro.org>
    arm-smmu-qcom: Ensure the qcom_scm driver has finished probing

Ran Wang <ran.wang_1@nxp.com>
    spi: spi-nxp-fspi: fix fspi panic by unexpected interrupts

Krzysztof Kozlowski <krzk@kernel.org>
    drm/exynos: depend on COMMON_CLK to fix compile tests

Xu Qiang <xuqiang36@huawei.com>
    irqchip/gic-v3-its: Unconditionally save/restore the ITS state on suspend

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: skip tx timeout reset while in resetting

Georgi Djakov <georgi.djakov@linaro.org>
    interconnect: qcom: qcs404: Remove GPU and display RPM IDs

Georgi Djakov <georgi.djakov@linaro.org>
    interconnect: qcom: msm8916: Remove rpm-ids from non-RPM nodes

Can Guo <cang@codeaurora.org>
    scsi: ufs: Make sure clk scaling happens only when HBA is runtime ACTIVE

Can Guo <cang@codeaurora.org>
    scsi: ufs: Fix unexpected values from ufshcd_read_desc_param()

Vineet Gupta <vgupta@synopsys.com>
    ARC: stack unwinding: don't assume non-current task is sleeping

Zhen Lei <thunder.leizhen@huawei.com>
    arm64: dts: broadcom: clear the warnings caused by empty dma-ranges

Michael Ellerman <mpe@ellerman.id.au>
    powerpc: Drop -me200 addition to build flags

Sara Sharon <sara.sharon@intel.com>
    iwlwifi: mvm: fix kernel panic in case of assert during CSA

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: set LTR to avoid completion timeout

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: sta: set max HE max A-MPDU according to HE capa

Markus Reichl <m.reichl@fivetechno.de>
    arm64: dts: rockchip: Reorder LED triggers from mmc devices on rk3399-roc-pc.

Markus Reichl <m.reichl@fivetechno.de>
    arm64: dts: rockchip: Assign a fixed index to mmc devices on rk3399 boards.

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: limit memory read spin time

Maciej Matuszczyk <maccraft123mc@gmail.com>
    arm64: dts: rockchip: Remove system-power-controller from pmic on Odroid Go Advance

Al Cooper <alcooperx@gmail.com>
    phy: usb: Fix incorrect clearing of tca_drv_sel bit in SETUP reg for 7211

Liu Zixian <liuzixian4@huawei.com>
    mm/mmap.c: fix mmap return value when vma is merged after call_mmap()

Randy Dunlap <rdunlap@infradead.org>
    zlib: export S390 symbols for zlib modules

Linus Walleij <linus.walleij@linaro.org>
    usb: ohci-omap: Fix descriptor conversion

Namhyung Kim <namhyung@kernel.org>
    perf/x86/intel: Fix a warning on x86_pmu_stop() with large PEBS

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: pcie: invert values of NO_160 device config entries

Randy Dunlap <rdunlap@infradead.org>
    vdpa: mlx5: fix vdpa/vhost dependencies

Randy Dunlap <rdunlap@infradead.org>
    net: broadcom CNIC: requires MMU

Jing Xiangfeng <jingxiangfeng@huawei.com>
    scsi: storvsc: Fix error return in storvsc_probe()

Sami Tolvanen <samitolvanen@google.com>
    samples/ftrace: Mark my_tramp[12]? global

Zhang Qilong <zhangqilong3@huawei.com>
    can: kvaser_pciefd: kvaser_pciefd_open(): fix error handling

Zhang Qilong <zhangqilong3@huawei.com>
    can: c_can: c_can_power_up(): fix error handling

Jeroen Hofstee <jhofstee@victronenergy.com>
    can: sun4i_can: sun4i_can_err(): don't count arbitration lose as an error

Jeroen Hofstee <jhofstee@victronenergy.com>
    can: sja1000: sja1000_err(): don't count arbitration lose as an error

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: tcan4x5x_can_probe(): fix error path: remove erroneous clk_disable_unprepare()

Sebastian Reichel <sebastian.reichel@collabora.com>
    drm/panel: sony-acx565akm: Fix race condition in probe

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    drm/rockchip: Avoid uninitialized use of endpoint id in LVDS

Dany Madden <drt@linux.ibm.com>
    ibmvnic: reduce wait for completion time

Dany Madden <drt@linux.ibm.com>
    ibmvnic: send_login should check for crq errors

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: track pending login

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: delay next reset if hard reset fails

Dany Madden <drt@linux.ibm.com>
    ibmvnic: avoid memset null scrq msgs

Dany Madden <drt@linux.ibm.com>
    ibmvnic: stop free_all_rwi on failed reset

Dany Madden <drt@linux.ibm.com>
    ibmvnic: handle inconsistent login with reset

Wang Hai <wanghai38@huawei.com>
    ipvs: fix possible memory leak in ip_vs_control_net_init

Sven Eckelmann <sven@narfation.org>
    batman-adv: Don't always reallocate the fragmentation skb head

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reserve needed_*room for fragments

Sven Eckelmann <sven@narfation.org>
    batman-adv: Consider fragmentation for needed_headroom

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: Fix hash ISA v3.0 TLBIEL instruction generation

Si-Wei Liu <si-wei.liu@oracle.com>
    vhost-vdpa: fix page pinning leakage in error path (rework)

Zhen Lei <thunder.leizhen@huawei.com>
    bpftool: Fix error return value in build_btf_type_table

Björn Töpel <bjorn.topel@intel.com>
    net, xsk: Avoid taking multiple skbuff references

Masami Hiramatsu <mhiramat@kernel.org>
    tools/bootconfig: Fix to check the write failure correctly

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Fix HP Pavilion x2 Detachable quirks

Steven Rostedt (VMware) <rostedt@goodmis.org>
    kprobes: Tell lockdep about kprobe nesting

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Remove NMI context check

Minchan Kim <minchan@kernel.org>
    mm/zsmalloc.c: drop ZSMALLOC_PGTABLE_MAPPING

Nick Desaulniers <ndesaulniers@google.com>
    Kbuild: do not emit debug info for assembly with LLVM_IAS=1


-------------

Diffstat:

 Makefile                                           |   7 +-
 arch/alpha/kernel/process.c                        |   2 +-
 arch/arc/kernel/stacktrace.c                       |  23 ++--
 arch/arm/configs/omap2plus_defconfig               |   1 -
 arch/arm/kernel/process.c                          |   2 +-
 arch/arm/mach-omap1/board-osk.c                    |   2 +-
 .../boot/dts/broadcom/stingray/stingray-usb.dtsi   |  20 ++--
 arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts |  12 --
 arch/arm64/boot/dts/rockchip/rk3326-odroid-go2.dts |   1 -
 arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi    |   4 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   3 +
 arch/arm64/kernel/process.c                        |   2 +-
 arch/csky/kernel/process.c                         |   2 +-
 arch/h8300/kernel/process.c                        |   2 +-
 arch/hexagon/kernel/process.c                      |   2 +-
 arch/ia64/kernel/process.c                         |   2 +-
 arch/microblaze/kernel/process.c                   |   2 +-
 arch/mips/kernel/idle.c                            |  12 +-
 arch/nios2/kernel/process.c                        |   2 +-
 arch/openrisc/kernel/process.c                     |   2 +-
 arch/parisc/kernel/process.c                       |   2 +-
 arch/powerpc/Makefile                              |   1 -
 arch/powerpc/kernel/idle.c                         |   4 +-
 arch/powerpc/mm/book3s64/hash_native.c             |   2 +-
 arch/riscv/kernel/process.c                        |   2 +-
 arch/s390/kernel/entry.S                           |  15 ---
 arch/s390/kernel/idle.c                            |   6 +-
 arch/s390/lib/delay.c                              |   5 +-
 arch/sh/kernel/idle.c                              |   2 +-
 arch/sparc/kernel/leon_pmc.c                       |   4 +-
 arch/sparc/kernel/process_32.c                     |   2 +-
 arch/sparc/kernel/process_64.c                     |   4 +-
 arch/um/kernel/process.c                           |   2 +-
 arch/x86/events/intel/ds.c                         |   2 +-
 arch/x86/include/asm/mwait.h                       |   2 -
 arch/x86/include/asm/pgtable_types.h               |   1 +
 arch/x86/include/asm/sync_core.h                   |   9 +-
 arch/x86/kernel/apic/vector.c                      |  24 ++--
 arch/x86/kernel/kprobes/opt.c                      |  22 +++-
 arch/x86/kernel/process.c                          |  12 +-
 arch/x86/mm/mem_encrypt_identity.c                 |   4 +-
 arch/x86/mm/tlb.c                                  |  10 +-
 drivers/Makefile                                   |   1 +
 drivers/block/xen-blkback/blkback.c                |  89 +++------------
 drivers/block/xen-blkback/common.h                 |   4 +-
 drivers/block/xen-blkback/xenbus.c                 |   6 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c             |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   9 +-
 drivers/gpu/drm/exynos/Kconfig                     |   3 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   7 +-
 drivers/gpu/drm/i915/gt/intel_lrc.c                |   7 +-
 drivers/gpu/drm/i915/gt/intel_mocs.c               |   7 +-
 drivers/gpu/drm/panel/panel-sony-acx565akm.c       |   2 +-
 drivers/gpu/drm/rockchip/rockchip_lvds.c           |   2 +-
 drivers/idle/intel_idle.c                          |  37 ++++---
 drivers/input/misc/cm109.c                         |   7 +-
 drivers/input/serio/i8042-x86ia64io.h              |  42 +++++++
 drivers/interconnect/qcom/msm8916.c                |  12 +-
 drivers/interconnect/qcom/qcs404.c                 |   4 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |   4 +
 drivers/irqchip/irq-gic-v3-its.c                   |  16 +--
 drivers/media/cec/usb/pulse8/pulse8-cec.c          |  52 ++++++---
 drivers/misc/habanalabs/gaudi/gaudi.c              |   2 +
 drivers/mmc/core/block.c                           |   2 +-
 drivers/mmc/host/mtk-sd.c                          |  33 ++++--
 drivers/mmc/host/sdhci-of-arasan.c                 |   3 +
 drivers/net/can/c_can/c_can.c                      |  18 ++-
 drivers/net/can/kvaser_pciefd.c                    |   4 +-
 drivers/net/can/m_can/m_can.c                      |   2 +
 drivers/net/can/m_can/tcan4x5x.c                   |  11 +-
 drivers/net/can/sja1000/sja1000.c                  |   1 -
 drivers/net/can/sun4i_can.c                        |   1 -
 drivers/net/ethernet/broadcom/Kconfig              |   1 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |  98 ++++++++++------
 drivers/net/ethernet/ibm/ibmvnic.h                 |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h    |  10 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |  10 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  18 +++
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |  20 ++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  36 ++++--
 drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c  |   5 -
 drivers/pinctrl/intel/pinctrl-jasperlake.c         |   2 +-
 drivers/pinctrl/pinctrl-amd.c                      |   7 --
 drivers/platform/x86/acer-wmi.c                    |   1 +
 drivers/platform/x86/intel-vbtn.c                  |   6 +
 drivers/platform/x86/thinkpad_acpi.c               |  12 +-
 drivers/platform/x86/touchscreen_dmi.c             |  50 +++++++++
 drivers/scsi/be2iscsi/be_main.c                    |   4 +-
 drivers/scsi/storvsc_drv.c                         |   4 +-
 drivers/scsi/ufs/ufshcd.c                          |  31 ++++--
 drivers/soc/fsl/dpio/dpio-driver.c                 |   5 +-
 drivers/spi/spi-nxp-fspi.c                         |   7 ++
 drivers/usb/host/ohci-omap.c                       |   4 +-
 drivers/vdpa/Kconfig                               |   1 +
 drivers/vhost/vdpa.c                               |  80 +++++++++++---
 drivers/xen/grant-table.c                          | 123 +++++++++++++++++++++
 drivers/xen/unpopulated-alloc.c                    |  20 ++--
 drivers/xen/xen-scsiback.c                         |  60 ++--------
 fs/btrfs/ctree.h                                   |   5 +-
 fs/btrfs/qgroup.c                                  |  66 +++++++++--
 fs/proc/task_mmu.c                                 |   8 +-
 fs/zonefs/super.c                                  |  14 ++-
 include/asm-generic/barrier.h                      |   1 +
 include/linux/build_bug.h                          |   5 +
 include/linux/compiler-clang.h                     |   6 -
 include/linux/compiler-gcc.h                       |  19 ----
 include/linux/compiler.h                           |  18 ++-
 include/linux/netdevice.h                          |  14 ++-
 include/linux/zsmalloc.h                           |   1 -
 include/xen/grant_table.h                          |  17 +++
 kernel/kprobes.c                                   |  41 ++++---
 kernel/sched/idle.c                                |  28 ++++-
 lib/zlib_dfltcc/dfltcc_inflate.c                   |   3 +
 mm/Kconfig                                         |  13 ---
 mm/hugetlb.c                                       |   1 +
 mm/mmap.c                                          |  26 ++---
 mm/zsmalloc.c                                      |  48 --------
 net/batman-adv/fragmentation.c                     |  26 +++--
 net/batman-adv/hard-interface.c                    |   3 +
 net/core/dev.c                                     |   8 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  31 +++++-
 net/xdp/xsk.c                                      |   8 +-
 samples/ftrace/ftrace-direct-modify.c              |   2 +
 samples/ftrace/ftrace-direct-too.c                 |   1 +
 samples/ftrace/ftrace-direct.c                     |   1 +
 sound/soc/intel/boards/bytcr_rt5640.c              |  17 ++-
 tools/bootconfig/main.c                            |  30 ++++-
 tools/bpf/bpftool/btf.c                            |   1 +
 tools/testing/ktest/ktest.pl                       |   2 +-
 132 files changed, 1095 insertions(+), 625 deletions(-)


