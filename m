Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8579A2DC0DB
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 14:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgLPNNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 08:13:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:35020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgLPNNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Dec 2020 08:13:52 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.84
Date:   Wed, 16 Dec 2020 14:14:10 +0100
Message-Id: <16081244501780@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.84 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                 |    5 +
 arch/arc/kernel/stacktrace.c                             |   23 ++++---
 arch/arm64/boot/dts/broadcom/stingray/stingray-usb.dtsi  |   20 +++---
 arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts       |   12 ---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi                 |    3 
 arch/powerpc/Makefile                                    |    1 
 arch/x86/include/asm/pgtable_types.h                     |    1 
 arch/x86/include/asm/sync_core.h                         |    9 +-
 arch/x86/kernel/apic/vector.c                            |   24 ++++---
 arch/x86/lib/memcpy_64.S                                 |    4 -
 arch/x86/lib/memmove_64.S                                |    4 -
 arch/x86/lib/memset_64.S                                 |    4 -
 arch/x86/mm/mem_encrypt_identity.c                       |    4 -
 arch/x86/mm/tlb.c                                        |   10 ++-
 drivers/gpu/drm/i915/display/intel_dp.c                  |    2 
 drivers/input/misc/cm109.c                               |    7 +-
 drivers/input/serio/i8042-x86ia64io.h                    |   42 +++++++++++++
 drivers/interconnect/qcom/qcs404.c                       |    4 -
 drivers/irqchip/irq-gic-v3-its.c                         |   16 -----
 drivers/mmc/core/block.c                                 |    2 
 drivers/net/can/m_can/m_can.c                            |    2 
 drivers/net/ethernet/ibm/ibmvnic.c                       |    6 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h             |   10 +++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c        |    2 
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c |   20 ++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c          |   36 ++++++++---
 drivers/pinctrl/pinctrl-amd.c                            |    7 --
 drivers/platform/x86/acer-wmi.c                          |    1 
 drivers/platform/x86/intel-vbtn.c                        |    6 +
 drivers/platform/x86/thinkpad_acpi.c                     |   10 ++-
 drivers/platform/x86/touchscreen_dmi.c                   |   23 +++++++
 drivers/scsi/be2iscsi/be_main.c                          |    4 -
 drivers/scsi/ufs/ufshcd.c                                |    7 ++
 drivers/soc/fsl/dpio/dpio-driver.c                       |    5 -
 drivers/spi/spi-nxp-fspi.c                               |    7 ++
 fs/proc/task_mmu.c                                       |    8 +-
 include/linux/build_bug.h                                |    5 +
 include/linux/compiler-clang.h                           |    6 -
 include/linux/compiler-gcc.h                             |   19 ------
 include/linux/compiler.h                                 |   18 +++++
 include/linux/zsmalloc.h                                 |    1 
 mm/Kconfig                                               |   13 ----
 mm/zsmalloc.c                                            |   46 ---------------
 tools/testing/ktest/ktest.pl                             |    2 
 44 files changed, 269 insertions(+), 192 deletions(-)

Andy Lutomirski (1):
      x86/membarrier: Get rid of a dubious optimization

Arnd Bergmann (1):
      kbuild: avoid static_assert for genksyms

Arvind Sankar (2):
      x86/mm/mem_encrypt: Fix definition of PMD_FLAGS_DEC_WP
      compiler.h: fix barrier_data() on clang

Bean Huo (1):
      mmc: block: Fixup condition for CMD13 polling for RPMB requests

Can Guo (1):
      scsi: ufs: Make sure clk scaling happens only when HBA is runtime ACTIVE

Chris Chiu (1):
      Input: i8042 - add Acer laptops to the i8042 reset list

Coiby Xu (1):
      pinctrl: amd: remove debounce filter setting in IRQ type setting

Dan Carpenter (1):
      scsi: be2iscsi: Revert "Fix a theoretical leak in beiscsi_create_eqs()"

Dmitry Torokhov (1):
      Input: cm109 - do not stomp on control URB

Fangrui Song (1):
      x86/lib: Change .weak to SYM_FUNC_START_WEAK for arch/x86/lib/mem*_64.S

Georgi Djakov (1):
      interconnect: qcom: qcs404: Remove GPU and display RPM IDs

Greg Kroah-Hartman (1):
      Linux 5.4.84

Hans de Goede (3):
      platform/x86: thinkpad_acpi: Do not report SW_TABLET_MODE on Yoga 11e
      platform/x86: thinkpad_acpi: Add BAT1 is primary battery quirk for Thinkpad Yoga 11e 4th gen
      platform/x86: touchscreen_dmi: Add info for the Irbis TW118 tablet

Hao Si (1):
      soc: fsl: dpio: Get the cpumask through cpumask_of(cpu)

Johannes Berg (2):
      iwlwifi: pcie: limit memory read spin time
      iwlwifi: pcie: set LTR to avoid completion timeout

Jon Hunter (1):
      arm64: tegra: Disable the ACONNECT for Jetson TX2

Libo Chen (1):
      ktest.pl: Fix incorrect reboot for grub2bls

Lijun Pan (1):
      ibmvnic: skip tx timeout reset while in resetting

Manasi Navare (1):
      drm/i915/display/dp: Compute the correct slice count for VDSC on DP

Markus Reichl (1):
      arm64: dts: rockchip: Assign a fixed index to mmc devices on rk3399 boards.

Max Verevkin (1):
      platform/x86: intel-vbtn: Support for tablet mode on HP Pavilion 13 x360 PC

Michael Ellerman (1):
      powerpc: Drop -me200 addition to build flags

Miles Chen (1):
      proc: use untagged_addr() for pagemap_read addresses

Minchan Kim (1):
      mm/zsmalloc.c: drop ZSMALLOC_PGTABLE_MAPPING

Nick Desaulniers (1):
      Kbuild: do not emit debug info for assembly with LLVM_IAS=1

Pankaj Sharma (1):
      can: m_can: m_can_dev_setup(): add support for bosch mcan version 3.3.0

Ran Wang (1):
      spi: spi-nxp-fspi: fix fspi panic by unexpected interrupts

Sara Sharon (1):
      iwlwifi: mvm: fix kernel panic in case of assert during CSA

Thomas Gleixner (1):
      x86/apic/vector: Fix ordering in vector assignment

Timo Witte (1):
      platform/x86: acer-wmi: add automatic keyboard background light toggle key as KEY_LIGHTS_TOGGLE

Vineet Gupta (1):
      ARC: stack unwinding: don't assume non-current task is sleeping

Xu Qiang (1):
      irqchip/gic-v3-its: Unconditionally save/restore the ITS state on suspend

Zhen Lei (1):
      arm64: dts: broadcom: clear the warnings caused by empty dma-ranges

