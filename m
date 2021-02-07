Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EAF3124F3
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 16:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhBGPHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 10:07:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:54598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229981AbhBGPHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Feb 2021 10:07:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58C6764E54;
        Sun,  7 Feb 2021 15:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612710361;
        bh=BU6rS7EcJ9M6E8c7jQayUj5JGfClqgN8KAFGXJRX82s=;
        h=From:To:Cc:Subject:Date:From;
        b=B51ao5UeV/mLHaPS7YuBErhR8iZZ8OFlwY3QOItIWJyFlPXglrz4Hzx3TKmSxXxth
         iOjrTO+LVcC526jC3on3F5eieRHgIHhOw+J/1gRhWDIMFlh0/8zdKKCihwf+j8u8mq
         mUEnHKOSPfsaKoZNRe1tMaDoV2qA30scQcWW27uI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.14
Date:   Sun,  7 Feb 2021 16:05:50 +0100
Message-Id: <161271035125056@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.14 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                      |    2 
 arch/arm/mm/Kconfig                                           |    1 
 arch/arm64/boot/dts/amlogic/meson-g12b.dtsi                   |    4 
 arch/arm64/include/asm/memory.h                               |   10 +-
 arch/arm64/mm/physaddr.c                                      |    2 
 arch/x86/include/asm/intel-family.h                           |    1 
 arch/x86/include/asm/msr.h                                    |    4 
 arch/x86/kernel/setup.c                                       |   20 ++--
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c  |    6 -
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c              |    7 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c     |   18 +++-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c            |    9 +-
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c         |    2 
 drivers/gpu/drm/panfrost/panfrost_device.h                    |    1 
 drivers/gpu/drm/panfrost/panfrost_drv.c                       |    2 
 drivers/gpu/drm/panfrost/panfrost_gem.c                       |    2 
 drivers/gpu/drm/panfrost/panfrost_mmu.c                       |    1 
 drivers/i2c/busses/i2c-tegra.c                                |   22 ++++-
 drivers/iommu/intel/iommu.c                                   |    5 +
 drivers/iommu/io-pgtable-arm.c                                |   11 ++
 drivers/misc/habanalabs/common/device.c                       |    9 ++
 drivers/misc/habanalabs/common/firmware_if.c                  |    5 +
 drivers/misc/habanalabs/common/habanalabs_ioctl.c             |    2 
 drivers/misc/habanalabs/gaudi/gaudi.c                         |    3 
 drivers/misc/habanalabs/goya/goya.c                           |    3 
 drivers/net/dsa/bcm_sf2.c                                     |    8 +
 drivers/net/dsa/microchip/ksz_common.c                        |    2 
 drivers/net/ethernet/freescale/fec_main.c                     |    3 
 drivers/net/ethernet/ibm/ibmvnic.c                            |    6 +
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c      |    3 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c           |    6 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h           |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c        |    4 
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c             |    2 
 drivers/nvme/host/core.c                                      |   17 +++
 drivers/nvme/host/pci.c                                       |   14 +++
 drivers/nvme/host/rdma.c                                      |   15 ++-
 drivers/nvme/host/tcp.c                                       |   14 ++-
 drivers/nvme/target/admin-cmd.c                               |    8 +
 drivers/phy/motorola/phy-cpcap-usb.c                          |   19 ++--
 drivers/platform/x86/intel-vbtn.c                             |    6 +
 drivers/platform/x86/thinkpad_acpi.c                          |    1 
 drivers/platform/x86/touchscreen_dmi.c                        |   18 ++++
 drivers/scsi/fnic/vnic_dev.c                                  |    8 +
 drivers/scsi/ibmvscsi/ibmvfc.c                                |    4 
 drivers/scsi/libfc/fc_exch.c                                  |   16 +++
 drivers/scsi/scsi_transport_srp.c                             |    9 +-
 fs/udf/super.c                                                |    7 -
 include/linux/kthread.h                                       |    3 
 include/linux/nvme.h                                          |    6 +
 kernel/kthread.c                                              |   27 +++++-
 kernel/locking/lockdep.c                                      |    7 +
 kernel/smpboot.c                                              |    1 
 kernel/workqueue.c                                            |    9 --
 net/mac80211/debugfs.c                                        |   44 ++++------
 net/mac80211/rx.c                                             |    2 
 net/mac80211/tx.c                                             |   27 +++---
 net/switchdev/switchdev.c                                     |   23 ++---
 sound/pci/hda/hda_intel.c                                     |    6 +
 sound/pci/hda/patch_hdmi.c                                    |    1 
 sound/soc/sof/intel/hda-codec.c                               |    3 
 tools/objtool/check.c                                         |   14 +--
 tools/objtool/elf.c                                           |    7 +
 tools/power/x86/intel-speed-select/isst-config.c              |   32 +++++++
 tools/testing/selftests/powerpc/alignment/alignment_handler.c |    5 -
 65 files changed, 426 insertions(+), 134 deletions(-)

Aric Cyr (1):
      drm/amd/display: Allow PSTATE chnage when no displays are enabled

Arnold Gozum (1):
      platform/x86: intel-vbtn: Support for tablet mode on Dell Inspiron 7352

Bing Guo (1):
      drm/amd/display: Change function decide_dp_link_settings to avoid infinite looping

Brian King (1):
      scsi: ibmvfc: Set default timeout to avoid crash during migration

Catalin Marinas (1):
      arm64: Do not pass tagged addresses to __is_lm_address()

Chaitanya Kulkarni (1):
      nvmet: set right status on error in id-ns handler

Chao Leng (2):
      nvme-rdma: avoid request double completion for concurrent nvme_rdma_timeout
      nvme-tcp: avoid request double completion for concurrent nvme_tcp_timeout

Dinghao Liu (1):
      scsi: fnic: Fix memleak in vnic_dev_init_devcmd2

Felix Fietkau (2):
      mac80211: fix fast-rx encryption check
      mac80211: fix encryption key selection for 802.3 xmit

Gayatri Kammela (1):
      x86/cpu: Add another Alder Lake CPU to the Intel family

Greg Kroah-Hartman (1):
      Linux 5.10.14

Hans de Goede (1):
      platform/x86: touchscreen_dmi: Add swap-x-y quirk for Goodix touchscreen on Estar Beauty HD tablet

Ido Schimmel (1):
      mlxsw: spectrum_span: Do not overwrite policer configuration

Jake Wang (1):
      drm/amd/display: Update dram_clock_change_latency for DCN2.1

Javed Hasan (1):
      scsi: libfc: Avoid invoking response handler twice if ep is already completed

Jeannie Stevenson (1):
      platform/x86: thinkpad_acpi: Add P53/73 firmware to fan_quirk_table for dual fan control

Josh Poimboeuf (2):
      objtool: Don't add empty symbols to the rbtree
      objtool: Don't fail the kernel build on fatal errors

Kai Vehmanen (1):
      ALSA: hda: Add AlderLake-P PCI ID and HDMI codec vid

Kai-Chuan Hsieh (1):
      ALSA: hda: Add Cometlake-R PCI ID

Kai-Heng Feng (1):
      ASoC: SOF: Intel: hda: Resume codec to do jack detection

Kevin Hao (1):
      net: octeontx2: Make sure the buffer is 128 byte aligned

Klaus Jensen (1):
      nvme-pci: allow use of cmb on v1.4 controllers

Lijun Pan (1):
      ibmvnic: Ensure that CRQ entry read are correctly ordered

Marek Vasut (1):
      net: dsa: microchip: Adjust reset release timing to match reference reset circuit

Martin Wilck (1):
      scsi: scsi_transport_srp: Don't block target in failfast state

Michael Ellerman (1):
      selftests/powerpc: Only test lwm/stmw on big endian

Mike Rapoport (1):
      Revert "x86/setup: don't remove E820_TYPE_RAM for pfn 0"

Nadav Amit (1):
      iommu/vt-d: Do not use flush-queue when caching-mode is on

Nicholas Kazlauskas (1):
      drm/amd/display: Use hardware sequencer functions for PG control

Nick Desaulniers (1):
      ARM: 9025/1: Kconfig: CPU_BIG_ENDIAN depends on !LD_IS_LLD

Oded Gabbay (3):
      habanalabs: fix dma_addr passed to dma_mmap_coherent
      habanalabs: fix backward compatibility of idle check
      habanalabs: disable FW events on device removal

Ofir Bitton (1):
      habanalabs: zero pci counters packet before submit to FW

Pan Bian (3):
      net: stmmac: dwmac-intel-plat: remove config data on error
      net: fec: put child node on error path
      net: dsa: bcm_sf2: put device node before return

Peter Zijlstra (4):
      locking/lockdep: Avoid noinstr warning for DEBUG_LOCKDEP
      x86: __always_inline __{rd,wr}msr()
      kthread: Extract KTHREAD_IS_PER_CPU
      workqueue: Restrict affinity change to rescuer

Rasmus Villemoes (1):
      net: switchdev: don't set port_obj_info->handled true when -EOPNOTSUPP

Revanth Rajashekar (1):
      nvme: check the PRINFO bit before deciding the host buffer length

Robin Murphy (3):
      iommu/io-pgtable-arm: Support coherency for Mali LPAE
      drm/panfrost: Support cache-coherent integrations
      arm64: dts: meson: Describe G12b GPU as coherent

Shayne Chen (1):
      mac80211: fix incorrect strlen of .write in debugfs

Sowjanya Komatineni (1):
      i2c: tegra: Create i2c_writesl_vi() to use with VI I2C for filling TX FIFO

Srinivas Pandruvada (2):
      tools/power/x86/intel-speed-select: Set scaling_max_freq to base_frequency
      tools/power/x86/intel-speed-select: Set higher of cpuinfo_max_freq or base_frequency

Tony Lindgren (1):
      phy: cpcap-usb: Fix warning for missing regulator_disable

Vincenzo Frascino (1):
      arm64: Fix kernel address detection of __is_lm_address()

Vladimir Stempen (1):
      drm/amd/display: Fixed corruptions on HPDRX link loss restore

Voon Weifeng (1):
      stmmac: intel: Configure EHL PSE0 GbE and PSE1 GbE to 32 bits DMA addressing

lianzhi chang (1):
      udf: fix the problem that the disc content is not displayed

