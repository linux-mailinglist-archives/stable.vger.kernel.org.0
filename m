Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5806F2D9DC4
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 18:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440400AbgLNR17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:27:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439385AbgLNR16 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:27:58 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.4 00/36] 5.4.84-rc1 review
Date:   Mon, 14 Dec 2020 18:27:44 +0100
Message-Id: <20201214172543.302523401@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.84-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.84-rc1
X-KernelTest-Deadline: 2020-12-16T17:25+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.84 release.
There are 36 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 16 Dec 2020 17:25:32 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.84-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.84-rc1

Arvind Sankar <nivedita@alum.mit.edu>
    compiler.h: fix barrier_data() on clang

Minchan Kim <minchan@kernel.org>
    mm/zsmalloc.c: drop ZSMALLOC_PGTABLE_MAPPING

Thomas Gleixner <tglx@linutronix.de>
    x86/apic/vector: Fix ordering in vector assignment

Andy Lutomirski <luto@kernel.org>
    x86/membarrier: Get rid of a dubious optimization

Arvind Sankar <nivedita@alum.mit.edu>
    x86/mm/mem_encrypt: Fix definition of PMD_FLAGS_DEC_WP

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: be2iscsi: Revert "Fix a theoretical leak in beiscsi_create_eqs()"

Miles Chen <miles.chen@mediatek.com>
    proc: use untagged_addr() for pagemap_read addresses

Arnd Bergmann <arnd@arndb.de>
    kbuild: avoid static_assert for genksyms

Manasi Navare <manasi.d.navare@intel.com>
    drm/i915/display/dp: Compute the correct slice count for VDSC on DP

Bean Huo <beanhuo@micron.com>
    mmc: block: Fixup condition for CMD13 polling for RPMB requests

Coiby Xu <coiby.xu@gmail.com>
    pinctrl: amd: remove debounce filter setting in IRQ type setting

Chris Chiu <chiu@endlessos.org>
    Input: i8042 - add Acer laptops to the i8042 reset list

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: cm109 - do not stomp on control URB

Libo Chen <libo.chen@oracle.com>
    ktest.pl: Fix incorrect reboot for grub2bls

Pankaj Sharma <pankj.sharma@samsung.com>
    can: m_can: m_can_dev_setup(): add support for bosch mcan version 3.3.0

Hans de Goede <hdegoede@redhat.com>
    platform/x86: touchscreen_dmi: Add info for the Irbis TW118 tablet

Max Verevkin <me@maxverevkin.tk>
    platform/x86: intel-vbtn: Support for tablet mode on HP Pavilion 13 x360 PC

Timo Witte <timo.witte@gmail.com>
    platform/x86: acer-wmi: add automatic keyboard background light toggle key as KEY_LIGHTS_TOGGLE

Hans de Goede <hdegoede@redhat.com>
    platform/x86: thinkpad_acpi: Add BAT1 is primary battery quirk for Thinkpad Yoga 11e 4th gen

Hans de Goede <hdegoede@redhat.com>
    platform/x86: thinkpad_acpi: Do not report SW_TABLET_MODE on Yoga 11e

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Disable the ACONNECT for Jetson TX2

Hao Si <si.hao@zte.com.cn>
    soc: fsl: dpio: Get the cpumask through cpumask_of(cpu)

Ran Wang <ran.wang_1@nxp.com>
    spi: spi-nxp-fspi: fix fspi panic by unexpected interrupts

Xu Qiang <xuqiang36@huawei.com>
    irqchip/gic-v3-its: Unconditionally save/restore the ITS state on suspend

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: skip tx timeout reset while in resetting

Georgi Djakov <georgi.djakov@linaro.org>
    interconnect: qcom: qcs404: Remove GPU and display RPM IDs

Can Guo <cang@codeaurora.org>
    scsi: ufs: Make sure clk scaling happens only when HBA is runtime ACTIVE

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

Markus Reichl <m.reichl@fivetechno.de>
    arm64: dts: rockchip: Assign a fixed index to mmc devices on rk3399 boards.

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: limit memory read spin time

Fangrui Song <maskray@google.com>
    x86/lib: Change .weak to SYM_FUNC_START_WEAK for arch/x86/lib/mem*_64.S

Nick Desaulniers <ndesaulniers@google.com>
    Kbuild: do not emit debug info for assembly with LLVM_IAS=1


-------------

Diffstat:

 Makefile                                           |  7 +++-
 arch/arc/kernel/stacktrace.c                       | 23 +++++++----
 .../boot/dts/broadcom/stingray/stingray-usb.dtsi   | 20 +++++-----
 arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts | 12 ------
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |  3 ++
 arch/powerpc/Makefile                              |  1 -
 arch/x86/include/asm/pgtable_types.h               |  1 +
 arch/x86/include/asm/sync_core.h                   |  9 +++--
 arch/x86/kernel/apic/vector.c                      | 24 ++++++-----
 arch/x86/lib/memcpy_64.S                           |  4 +-
 arch/x86/lib/memmove_64.S                          |  4 +-
 arch/x86/lib/memset_64.S                           |  4 +-
 arch/x86/mm/mem_encrypt_identity.c                 |  4 +-
 arch/x86/mm/tlb.c                                  | 10 ++++-
 drivers/gpu/drm/i915/display/intel_dp.c            |  2 +-
 drivers/input/misc/cm109.c                         |  7 +++-
 drivers/input/serio/i8042-x86ia64io.h              | 42 ++++++++++++++++++++
 drivers/interconnect/qcom/qcs404.c                 |  4 +-
 drivers/irqchip/irq-gic-v3-its.c                   | 16 ++------
 drivers/mmc/core/block.c                           |  2 +-
 drivers/net/can/m_can/m_can.c                      |  2 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |  6 +++
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       | 10 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  2 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   | 20 ++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 36 ++++++++++++-----
 drivers/pinctrl/pinctrl-amd.c                      |  7 ----
 drivers/platform/x86/acer-wmi.c                    |  1 +
 drivers/platform/x86/intel-vbtn.c                  |  6 +++
 drivers/platform/x86/thinkpad_acpi.c               | 10 ++++-
 drivers/platform/x86/touchscreen_dmi.c             | 23 +++++++++++
 drivers/scsi/be2iscsi/be_main.c                    |  4 +-
 drivers/scsi/ufs/ufshcd.c                          |  7 ++++
 drivers/soc/fsl/dpio/dpio-driver.c                 |  5 +--
 drivers/spi/spi-nxp-fspi.c                         |  7 ++++
 fs/proc/task_mmu.c                                 |  8 +++-
 include/linux/build_bug.h                          |  5 +++
 include/linux/compiler-clang.h                     |  6 ---
 include/linux/compiler-gcc.h                       | 19 ---------
 include/linux/compiler.h                           | 18 ++++++++-
 include/linux/zsmalloc.h                           |  1 -
 mm/Kconfig                                         | 13 ------
 mm/zsmalloc.c                                      | 46 ----------------------
 tools/testing/ktest/ktest.pl                       |  2 +-
 44 files changed, 270 insertions(+), 193 deletions(-)


