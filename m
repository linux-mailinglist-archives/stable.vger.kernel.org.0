Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D2F311372
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 22:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbhBEVYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 16:24:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232954AbhBEPCI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:02:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81C1565006;
        Fri,  5 Feb 2021 14:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534231;
        bh=qinzSEomoLqOYngZ3E/HjaeNS2mwpgTcYDaCIBDnO6M=;
        h=From:To:Cc:Subject:Date:From;
        b=sGhnX89HmvF0Lu320cA8BTMO39MYkdkc5V+pcAFD49LBudASN2rxpe8TMBNi9cglU
         BD2WivVwfA4JEP2tLqzIq0GCiEUJpDv5ylihqsZ3VshvB3vXrJmRjOVMbSFyD8z1dh
         LMa4to8cf5teKakVvl4JdxUmdWzNO80N8/EOMLp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 5.10 00/57] 5.10.14-rc1 review
Date:   Fri,  5 Feb 2021 15:06:26 +0100
Message-Id: <20210205140655.982616732@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.10.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.14-rc1
X-KernelTest-Deadline: 2021-02-07T14:06+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.14 release.
There are 57 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 07 Feb 2021 14:06:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.14-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.14-rc1

Peter Zijlstra <peterz@infradead.org>
    workqueue: Restrict affinity change to rescuer

Peter Zijlstra <peterz@infradead.org>
    kthread: Extract KTHREAD_IS_PER_CPU

Gayatri Kammela <gayatri.kammela@intel.com>
    x86/cpu: Add another Alder Lake CPU to the Intel family

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Don't fail the kernel build on fatal errors

Oded Gabbay <ogabbay@kernel.org>
    habanalabs: disable FW events on device removal

Oded Gabbay <ogabbay@kernel.org>
    habanalabs: fix backward compatibility of idle check

Ofir Bitton <obitton@habana.ai>
    habanalabs: zero pci counters packet before submit to FW

Vladimir Stempen <vladimir.stempen@amd.com>
    drm/amd/display: Fixed corruptions on HPDRX link loss restore

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Use hardware sequencer functions for PG control

Bing Guo <bing.guo@amd.com>
    drm/amd/display: Change function decide_dp_link_settings to avoid infinite looping

Aric Cyr <aric.cyr@amd.com>
    drm/amd/display: Allow PSTATE chnage when no displays are enabled

Jake Wang <haonan.wang2@amd.com>
    drm/amd/display: Update dram_clock_change_latency for DCN2.1

Michael Ellerman <mpe@ellerman.id.au>
    selftests/powerpc: Only test lwm/stmw on big endian

Jeannie Stevenson <jeanniestevenson@protonmail.com>
    platform/x86: thinkpad_acpi: Add P53/73 firmware to fan_quirk_table for dual fan control

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvmet: set right status on error in id-ns handler

Klaus Jensen <k.jensen@samsung.com>
    nvme-pci: allow use of cmb on v1.4 controllers

Chao Leng <lengchao@huawei.com>
    nvme-tcp: avoid request double completion for concurrent nvme_tcp_timeout

Chao Leng <lengchao@huawei.com>
    nvme-rdma: avoid request double completion for concurrent nvme_rdma_timeout

Revanth Rajashekar <revanth.rajashekar@intel.com>
    nvme: check the PRINFO bit before deciding the host buffer length

lianzhi chang <changlianzhi@uniontech.com>
    udf: fix the problem that the disc content is not displayed

Sowjanya Komatineni <skomatineni@nvidia.com>
    i2c: tegra: Create i2c_writesl_vi() to use with VI I2C for filling TX FIFO

Kai-Chuan Hsieh <kaichuan.hsieh@canonical.com>
    ALSA: hda: Add Cometlake-R PCI ID

Brian King <brking@linux.vnet.ibm.com>
    scsi: ibmvfc: Set default timeout to avoid crash during migration

Felix Fietkau <nbd@nbd.name>
    mac80211: fix encryption key selection for 802.3 xmit

Felix Fietkau <nbd@nbd.name>
    mac80211: fix fast-rx encryption check

Shayne Chen <shayne.chen@mediatek.com>
    mac80211: fix incorrect strlen of .write in debugfs

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Don't add empty symbols to the rbtree

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: Add AlderLake-P PCI ID and HDMI codec vid

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ASoC: SOF: Intel: hda: Resume codec to do jack detection

Dinghao Liu <dinghao.liu@zju.edu.cn>
    scsi: fnic: Fix memleak in vnic_dev_init_devcmd2

Javed Hasan <jhasan@marvell.com>
    scsi: libfc: Avoid invoking response handler twice if ep is already completed

Martin Wilck <mwilck@suse.com>
    scsi: scsi_transport_srp: Don't block target in failfast state

Peter Zijlstra <peterz@infradead.org>
    x86: __always_inline __{rd,wr}msr()

Peter Zijlstra <peterz@infradead.org>
    locking/lockdep: Avoid noinstr warning for DEBUG_LOCKDEP

Oded Gabbay <ogabbay@kernel.org>
    habanalabs: fix dma_addr passed to dma_mmap_coherent

Arnold Gozum <arngozum@gmail.com>
    platform/x86: intel-vbtn: Support for tablet mode on Dell Inspiron 7352

Hans de Goede <hdegoede@redhat.com>
    platform/x86: touchscreen_dmi: Add swap-x-y quirk for Goodix touchscreen on Estar Beauty HD tablet

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    tools/power/x86/intel-speed-select: Set higher of cpuinfo_max_freq or base_frequency

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    tools/power/x86/intel-speed-select: Set scaling_max_freq to base_frequency

Tony Lindgren <tony@atomide.com>
    phy: cpcap-usb: Fix warning for missing regulator_disable

Nadav Amit <namit@vmware.com>
    iommu/vt-d: Do not use flush-queue when caching-mode is on

Nick Desaulniers <ndesaulniers@google.com>
    ARM: 9025/1: Kconfig: CPU_BIG_ENDIAN depends on !LD_IS_LLD

Mike Rapoport <rppt@kernel.org>
    Revert "x86/setup: don't remove E820_TYPE_RAM for pfn 0"

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Do not pass tagged addresses to __is_lm_address()

Vincenzo Frascino <vincenzo.frascino@arm.com>
    arm64: Fix kernel address detection of __is_lm_address()

Robin Murphy <robin.murphy@arm.com>
    arm64: dts: meson: Describe G12b GPU as coherent

Robin Murphy <robin.murphy@arm.com>
    drm/panfrost: Support cache-coherent integrations

Robin Murphy <robin.murphy@arm.com>
    iommu/io-pgtable-arm: Support coherency for Mali LPAE

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: Ensure that CRQ entry read are correctly ordered

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    net: switchdev: don't set port_obj_info->handled true when -EOPNOTSUPP

Pan Bian <bianpan2016@163.com>
    net: dsa: bcm_sf2: put device node before return

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_span: Do not overwrite policer configuration

Voon Weifeng <weifeng.voon@intel.com>
    stmmac: intel: Configure EHL PSE0 GbE and PSE1 GbE to 32 bits DMA addressing

Kevin Hao <haokexin@gmail.com>
    net: octeontx2: Make sure the buffer is 128 byte aligned

Pan Bian <bianpan2016@163.com>
    net: fec: put child node on error path

Pan Bian <bianpan2016@163.com>
    net: stmmac: dwmac-intel-plat: remove config data on error

Marek Vasut <marex@denx.de>
    net: dsa: microchip: Adjust reset release timing to match reference reset circuit


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/mm/Kconfig                                |  1 +
 arch/arm64/boot/dts/amlogic/meson-g12b.dtsi        |  4 ++
 arch/arm64/include/asm/memory.h                    | 10 ++---
 arch/arm64/mm/physaddr.c                           |  2 +-
 arch/x86/include/asm/intel-family.h                |  1 +
 arch/x86/include/asm/msr.h                         |  4 +-
 arch/x86/kernel/setup.c                            | 20 +++++-----
 .../amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c   |  6 ++-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |  7 +++-
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  | 18 +++++++--
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |  9 ++++-
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |  2 +-
 drivers/gpu/drm/panfrost/panfrost_device.h         |  1 +
 drivers/gpu/drm/panfrost/panfrost_drv.c            |  2 +
 drivers/gpu/drm/panfrost/panfrost_gem.c            |  2 +
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |  1 +
 drivers/i2c/busses/i2c-tegra.c                     | 22 ++++++++++-
 drivers/iommu/intel/iommu.c                        |  5 +++
 drivers/iommu/io-pgtable-arm.c                     | 11 +++++-
 drivers/misc/habanalabs/common/device.c            |  9 +++++
 drivers/misc/habanalabs/common/firmware_if.c       |  5 +++
 drivers/misc/habanalabs/common/habanalabs_ioctl.c  |  2 +
 drivers/misc/habanalabs/gaudi/gaudi.c              |  3 +-
 drivers/misc/habanalabs/goya/goya.c                |  3 +-
 drivers/net/dsa/bcm_sf2.c                          |  8 +++-
 drivers/net/dsa/microchip/ksz_common.c             |  2 +-
 drivers/net/ethernet/freescale/fec_main.c          |  3 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  6 +++
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  3 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |  6 +++
 .../net/ethernet/mellanox/mlxsw/spectrum_span.h    |  1 +
 .../net/ethernet/stmicro/stmmac/dwmac-intel-plat.c |  4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |  2 +
 drivers/nvme/host/core.c                           | 17 ++++++++-
 drivers/nvme/host/pci.c                            | 14 +++++++
 drivers/nvme/host/rdma.c                           | 15 ++++++--
 drivers/nvme/host/tcp.c                            | 14 +++++--
 drivers/nvme/target/admin-cmd.c                    |  8 +++-
 drivers/phy/motorola/phy-cpcap-usb.c               | 19 +++++++---
 drivers/platform/x86/intel-vbtn.c                  |  6 +++
 drivers/platform/x86/thinkpad_acpi.c               |  1 +
 drivers/platform/x86/touchscreen_dmi.c             | 18 +++++++++
 drivers/scsi/fnic/vnic_dev.c                       |  8 ++--
 drivers/scsi/ibmvscsi/ibmvfc.c                     |  4 +-
 drivers/scsi/libfc/fc_exch.c                       | 16 +++++++-
 drivers/scsi/scsi_transport_srp.c                  |  9 ++++-
 fs/udf/super.c                                     |  7 ++--
 include/linux/kthread.h                            |  3 ++
 include/linux/nvme.h                               |  6 +++
 kernel/kthread.c                                   | 27 ++++++++++++-
 kernel/locking/lockdep.c                           |  7 +++-
 kernel/smpboot.c                                   |  1 +
 kernel/workqueue.c                                 |  9 ++---
 net/mac80211/debugfs.c                             | 44 ++++++++++------------
 net/mac80211/rx.c                                  |  2 +
 net/mac80211/tx.c                                  | 27 +++++++------
 net/switchdev/switchdev.c                          | 23 ++++++-----
 sound/pci/hda/hda_intel.c                          |  6 +++
 sound/pci/hda/patch_hdmi.c                         |  1 +
 sound/soc/sof/intel/hda-codec.c                    |  3 +-
 tools/objtool/check.c                              | 14 +++----
 tools/objtool/elf.c                                |  7 ++++
 tools/power/x86/intel-speed-select/isst-config.c   | 32 ++++++++++++++++
 .../powerpc/alignment/alignment_handler.c          |  5 ++-
 65 files changed, 427 insertions(+), 135 deletions(-)


