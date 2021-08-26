Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25EA23F88C0
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 15:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241040AbhHZN0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 09:26:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhHZN0Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 09:26:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B5F4610A3;
        Thu, 26 Aug 2021 13:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629984338;
        bh=W6xJzzVg0n1fXC8dxzcmts6C8kReTRl4HdJ+0nCHrOY=;
        h=From:To:Cc:Subject:Date:From;
        b=fFw7zCk2G10MPmyyuXr74NGuCjq97fQ+TH/6GovdI38UB2Om+RZ9xNze9ZYKJ3cj5
         JYoFm7eueuw/Wx+wnnWFb4jt9iOzEWHxjaxTllAc/hAw5mUKLES9YIcJukJUVmfGXY
         rDPt/sORQkxv/SRtNisLHGzKK+KGa+VIvPtOlcqHiY4fYcEPRPIru3jVQbL7L4/Z4x
         4crDkxAlUUIauyYfUMS6fB9TwkT9M+styQK1DLWlMPn6xhJEPezc5+b6n/VjLNvMI6
         LFlSEtj5dtp50Sr4v8o65+n4YSEy8hlvR2sJEYta4XPErCxuAELho7mXqHatWjyW2Y
         Vw2UScnnnDqxA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 5.13.13
Date:   Thu, 26 Aug 2021 09:25:35 -0400
Message-Id: <20210826132536.804538-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 5.13.13 kernel.

All users of the 5.13 kernel series must upgrade.

The updated 5.13.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.13.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha

- ------------


 Makefile                                           |   2 +-
 arch/arm/boot/dts/am43x-epos-evm.dts               |   2 +-
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi         |   4 +-
 arch/arm64/Makefile                                |   2 +
 .../boot/dts/qcom/msm8992-bullhead-rev-101.dts     |  12 ++
 .../arm64/boot/dts/qcom/msm8994-angler-rev-101.dts |   4 +
 .../arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi |   4 +-
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |   4 +-
 arch/powerpc/include/asm/book3s/32/kup.h           |  41 +++++
 arch/powerpc/include/asm/book3s/32/mmu-hash.h      |  27 +++
 arch/powerpc/include/asm/kup.h                     |   5 +-
 arch/powerpc/mm/book3s32/Makefile                  |   1 +
 arch/powerpc/mm/book3s32/kuap.c                    |  11 ++
 arch/powerpc/mm/book3s32/kuep.c                    |  37 +---
 arch/powerpc/mm/book3s32/mmu.c                     |  20 ---
 arch/riscv/kernel/setup.c                          |   4 +-
 arch/s390/pci/pci.c                                |   6 +
 arch/s390/pci/pci_bus.h                            |   5 +
 arch/x86/events/core.c                             |  12 +-
 block/kyber-iosched.c                              |   2 +-
 drivers/bus/ti-sysc.c                              |   4 +-
 drivers/clk/imx/clk-imx6q.c                        |   2 +-
 drivers/clk/qcom/gdsc.c                            |  54 ++++--
 drivers/cpufreq/armada-37xx-cpufreq.c              |   6 +-
 drivers/cpufreq/scmi-cpufreq.c                     |   2 +-
 drivers/dma/of-dma.c                               |   9 +-
 drivers/dma/sh/usb-dmac.c                          |   2 +-
 drivers/dma/xilinx/xilinx_dma.c                    |  12 ++
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |  21 ++-
 .../drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c  |   4 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c  |   2 +-
 .../drm/amd/display/dc/dcn301/dcn301_resource.c    |  96 +---------
 drivers/gpu/drm/i915/display/intel_display_power.c |  16 +-
 drivers/gpu/drm/i915/i915_irq.c                    |  60 ++++---
 drivers/gpu/drm/mediatek/mtk_disp_color.c          |   2 +
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c            |   2 +
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c        |   2 +
 drivers/iommu/dma-iommu.c                          |   1 +
 drivers/iommu/intel/pasid.c                        |  10 +-
 drivers/iommu/intel/pasid.h                        |   6 +
 drivers/iommu/iommu.c                              |   3 +
 drivers/ipack/carriers/tpci200.c                   |  60 ++++---
 drivers/mmc/host/dw_mmc.c                          |   6 +-
 drivers/mmc/host/mmci_stm32_sdmmc.c                |   7 +-
 drivers/mmc/host/sdhci-iproc.c                     |  21 ++-
 drivers/mmc/host/sdhci-msm.c                       |  18 ++
 drivers/mtd/chips/cfi_cmdset_0002.c                |   2 +-
 drivers/mtd/nand/raw/nand_base.c                   |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 113 ++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |  36 ++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   3 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |   1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   1 +
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  47 ++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   5 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   1 +
 drivers/net/ethernet/qlogic/qede/qede.h            |   1 +
 drivers/net/ethernet/qlogic/qede/qede_main.c       |   8 +
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |   4 +-
 drivers/net/hamradio/6pack.c                       |   6 +
 drivers/net/mdio/mdio-mux.c                        |  36 ++--
 drivers/net/usb/asix.h                             |   3 +-
 drivers/net/usb/asix_common.c                      |  31 ++--
 drivers/net/usb/asix_devices.c                     |  15 +-
 drivers/net/usb/ax88172a.c                         |   5 +
 drivers/net/usb/lan78xx.c                          |  16 +-
 drivers/net/usb/pegasus.c                          | 108 ++++++++----
 drivers/net/usb/r8152.c                            |  23 ++-
 drivers/net/virtio_net.c                           |  14 +-
 drivers/net/vrf.c                                  |   4 +
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |   3 +-
 drivers/opp/core.c                                 |  15 --
 drivers/pci/pci-sysfs.c                            |   2 +-
 drivers/pci/quirks.c                               |   1 +
 drivers/ptp/Kconfig                                |   3 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c         |   4 +-
 drivers/scsi/megaraid/megaraid_mm.c                |  21 ++-
 drivers/scsi/pm8001/pm8001_sas.c                   |  32 ++--
 drivers/scsi/scsi_scan.c                           |   3 +-
 drivers/scsi/scsi_sysfs.c                          |   9 +-
 drivers/slimbus/messaging.c                        |   7 +-
 drivers/slimbus/qcom-ngd-ctrl.c                    |  22 ++-
 drivers/soc/fsl/qe/qe_ic.c                         |  84 +++++----
 drivers/spi/spi-cadence-quadspi.c                  |  21 ++-
 drivers/spi/spi-mux.c                              |   8 +
 drivers/usb/core/devio.c                           |   2 +-
 drivers/usb/core/message.c                         |   6 +
 drivers/usb/typec/tcpm/tcpm.c                      |  13 +-
 drivers/vdpa/ifcvf/ifcvf_main.c                    |   4 +-
 drivers/vdpa/mlx5/core/mr.c                        |   9 -
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  14 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   4 +-
 drivers/vdpa/virtio_pci/vp_vdpa.c                  |   4 +-
 drivers/vhost/vdpa.c                               |   3 +-
 drivers/vhost/vhost.c                              |  10 +-
 drivers/virtio/virtio.c                            |   1 +
 drivers/virtio/virtio_ring.c                       |   8 +
 fs/btrfs/inode.c                                   |  10 +-
 fs/io_uring.c                                      |  37 ++--
 fs/namespace.c                                     |   6 +-
 include/linux/kfence.h                             |   7 +-
 include/linux/memcontrol.h                         |  29 +--
 include/linux/mlx5/mlx5_ifc_vdpa.h                 |  10 +-
 include/linux/virtio.h                             |   1 +
 include/net/flow_offload.h                         |  12 +-
 kernel/bpf/verifier.c                              |   1 +
 kernel/cfi.c                                       |   8 +-
 kernel/trace/Kconfig                               |   5 +
 kernel/trace/trace.c                               |  18 +-
 kernel/trace/trace.h                               |  32 ----
 kernel/trace/trace_events_hist.c                   |   2 +
 mm/hugetlb.c                                       |  21 ++-
 mm/memory-failure.c                                | 196 ++++++++++++---------
 mm/vmscan.c                                        |  27 ++-
 net/dccp/dccp.h                                    |   6 +-
 net/mac80211/main.c                                |   2 +
 net/mptcp/options.c                                |  10 +-
 net/mptcp/pm_netlink.c                             |  44 ++---
 net/openvswitch/vport.c                            |   1 +
 net/sched/sch_cake.c                               |   2 +-
 net/xfrm/xfrm_ipcomp.c                             |   2 +-
 sound/pci/hda/hda_generic.c                        |  10 +-
 sound/pci/hda/patch_realtek.c                      |  12 +-
 sound/pci/hda/patch_via.c                          |   1 +
 sound/soc/intel/atom/sst-mfld-platform-pcm.c       |   2 +-
 129 files changed, 1190 insertions(+), 771 deletions(-)

Adrian Larumbe (1):
      dmaengine: xilinx_dma: Fix read-after-free bug when terminating transfers

Alan Stern (2):
      USB: core: Avoid WARNings for 0-length descriptor requests
      USB: core: Fix incorrect pipe calculation in do_proc_control()

Andreas Persson (1):
      mtd: cfi_cmdset_0002: fix crash when erasing/writing AMD cards

Andrew Delgadillo (1):
      arm64: clean vdso & vdso32 files

Andy Shevchenko (1):
      ptp_pch: Restore dependency on PCI

Anshuman Gupta (1):
      drm/i915: Tweaked Wa_14010685332 for all PCHs

Apurva Nandan (1):
      spi: cadence-quadspi: Fix check condition for DTR ops

Arkadiusz Kubalewski (1):
      i40e: Fix ATR queue selection

Arnd Bergmann (1):
      mt76: fix enum type mismatch

Bing Guo (1):
      drm/amd/display: Fix Dynamic bpp issue with 8K30 with Navi 1X

Bjorn Andersson (1):
      clk: qcom: gdsc: Ensure regulator init state matches GDSC state

Caleb Connolly (1):
      arm64: dts: qcom: sdm845-oneplus: fix reserved-mem

Christophe Kerello (1):
      mmc: mmci: stm32: Check when the voltage switch procedure should be done

Christophe Leroy (3):
      powerpc/32s: Move setup_{kuep/kuap}() into {kuep/kuap}.c
      powerpc/32s: Refactor update of user segment registers
      powerpc/32s: Fix random crashes by adding isync() after locking/unlocking KUEP

Dan Carpenter (1):
      mtd: rawnand: Add a check in of_get_nand_secure_regions()

Dave Gerlach (1):
      ARM: dts: am43x-epos-evm: Reduce i2c0 bus speed for tps65218

Dinghao Liu (1):
      net: qlcnic: add missed unlock in qlcnic_83xx_flash_read32

Dmitry Osipenko (1):
      opp: Drop empty-table checks from _put functions

Dong Aisheng (1):
      clk: imx6q: fix uart earlycon unwork

Dongliang Mu (2):
      ipack: tpci200: fix many double free issues in tpci200_pci_probe
      ipack: tpci200: fix memory leak in the tpci200_register

Eli Cohen (2):
      vdpa/mlx5: Avoid destroying MR on empty iotlb
      vdpa/mlx5: Fix queue type selection logic

Elliot Berman (1):
      cfi: Use rcu_read_{un}lock_sched_notrace

Ezequiel Garcia (1):
      iommu/dma: Fix leak in non-contiguous API

Frank Wunderlich (1):
      iommu: Check if group is NULL before remove device

Hans de Goede (1):
      usb: typec: tcpm: Fix VDMs sometimes not being forwarded to alt-mode drivers

Harshvardhan Jha (2):
      net: xfrm: Fix end of loop tests for list_for_each_entry
      scsi: megaraid_mm: Fix end of loop tests for list_for_each_entry()

Hayes Wang (2):
      r8152: fix writing USB_BP2_EN
      r8152: fix the maximum number of PLA bp for RTL8153C

Ido Schimmel (1):
      Revert "flow_offload: action should not be NULL when it is referenced"

Igor Pylypiv (1):
      scsi: pm80xx: Fix TMF task completion race condition

Ilya Leoshkevich (1):
      bpf: Clear zext_dst of dead insns

Ivan T. Ivanov (1):
      net: usb: lan78xx: don't modify phy_device state concurrently

Jakub Kicinski (4):
      bnxt: don't lock the tx queue from napi poll
      bnxt: disable napi before canceling DIM
      bnxt: make sure xmit_more + errors does not miss doorbells
      bnxt: count Tx drops

Jaroslav Kysela (1):
      ALSA: hda - fix the 'Capture Switch' value change notifications

Jason Wang (1):
      virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO

Jeff Layton (1):
      fs: warn about impending deprecation of mandatory locks

Jens Axboe (2):
      io_uring: only assign io_uring_enter() SQPOLL error in actual error case
      io_uring: fix xa_alloc_cycle() error return value check

Johannes Berg (1):
      mac80211: fix locking in ieee80211_restart_work()

Johannes Weiner (1):
      mm: memcontrol: fix occasional OOMs due to proportional memory.low reclaim

José Roberto de Souza (1):
      drm/i915: Skip display interruption setup when display is not available

Kai-Heng Feng (1):
      ALSA: hda/realtek: Limit mic boost on HP ProBook 445 G8

Kristin Paget (1):
      ALSA: hda/realtek: Enable 4-speaker output for Dell XPS 15 9510 laptop

Krzysztof Wilczyński (1):
      PCI/sysfs: Use correct variable for the legacy_mem sysfs object

Lahav Schlesinger (1):
      vrf: Reset skb conntrack connection on VRF rcv

Liu Yi L (1):
      iommu/vt-d: Fix incomplete cache flush in intel_pasid_tear_down_entry()

Lukas Bulwahn (1):
      tracing: define needed config DYNAMIC_FTRACE_WITH_ARGS

Lukasz Luba (1):
      cpufreq: arm_scmi: Fix error path when allocation failed

Manivannan Sadhasivam (1):
      mtd: rawnand: Fix probe failure due to of_get_nand_secure_regions()

Marcin Bachry (1):
      PCI: Increase D3 delay for AMD Renoir/Cezanne XHCI

Marco Elver (1):
      kfence: fix is_kfence_address() for addresses below KFENCE_POOL_SIZE

Marek Behún (1):
      cpufreq: armada-37xx: forbid cpufreq for 1.2 GHz variant

Matthieu Baerts (1):
      mptcp: full fully established support after ADD_ADDR

Maxim Kochetkov (2):
      soc: fsl: qe: convert QE interrupt controller to platform_device
      soc: fsl: qe: fix static checker warning

Michael Chan (2):
      bnxt_en: Disable aRFS if running on 212 firmware
      bnxt_en: Add missing DMA memory barriers

Mike Kravetz (1):
      hugetlb: don't pass page cache pages to restore_reserve_on_error

Nadav Amit (1):
      io_uring: Use WRITE_ONCE() when writing to sq_flags

Naoya Horiguchi (2):
      mm,hwpoison: make get_hwpoison_page() call get_any_page()
      mm/hwpoison: retry with shake_page() for unhandlable pages

NeilBrown (1):
      btrfs: prevent rename2 from exchanging a subvol with a directory from different parents

Nicolas Saenz Julienne (2):
      mmc: sdhci-iproc: Cap min clock frequency on BCM2711
      mmc: sdhci-iproc: Set SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN on BCM2711

Niklas Schnelle (1):
      s390/pci: fix use after free of zpci_dev

Oleksij Rempel (1):
      net: usb: asix: refactor asix_read_phy_addr() and handle errors on return

Paolo Abeni (1):
      mptcp: fix memory leak on address flush

Parav Pandit (1):
      virtio: Protect vqs list access

Pavel Begunkov (1):
      io_uring: fix code style problems

Pavel Skripkin (1):
      net: 6pack: fix slab-out-of-bounds in decode_data

Peter Ujfalusi (1):
      dmaengine: of-dma: router_xlate to return -EPROBE_DEFER if controller is not yet available

Peter Zijlstra (1):
      perf/x86: Fix out of bound MSR access

Petko Manolov (1):
      net: usb: pegasus: Check the return value of get_geristers() and friends;

Petr Pavlu (1):
      riscv: Fix a number of free'd resources in init_resources()

Petr Vorel (3):
      arm64: dts: qcom: msm8992-bullhead: Remove PSCI
      arm64: dts: qcom: msm8992-bullhead: Fix cont_splash_mem mapping
      arm64: dts: qcom: msm8994-angler: Disable cont_splash_mem

Pingfan Liu (1):
      tracing: Apply trace filters on all output channels

Prabhakar Kushwaha (1):
      qede: fix crash in rmmod qede while automatic debug collection

Qingqing Zhuo (1):
      drm/amd/display: workaround for hard hang on HPD on native DP

Randy Dunlap (1):
      dccp: add do-while-0 stubs for dccp_pr_debug macros

Saravana Kannan (2):
      net: mdio-mux: Don't ignore memory allocation errors
      net: mdio-mux: Handle -EPROBE_DEFER correctly

Sasha Levin (1):
      Linux 5.13.13

Shaik Sajida Bhanu (1):
      mmc: sdhci-msm: Update the software timeout value for sdhc

Sreekanth Reddy (1):
      scsi: core: Avoid printing an error if target_alloc() returns -ENXIO

Srinivas Kandagatla (5):
      arm64: dts: qcom: c630: fix correct powerdown pin for WSA881x
      slimbus: messaging: start transaction ids from 1 instead of zero
      slimbus: messaging: check for valid transaction id
      slimbus: ngd: set correct device for pm
      slimbus: ngd: reset dma setup during runtime pm

Steven Rostedt (VMware) (1):
      tracing / histogram: Fix NULL pointer dereference on strcmp() on NULL event name

Sudeep Holla (1):
      ARM: dts: nomadik: Fix up interrupt controller node names

Sylwester Dziedziuch (1):
      iavf: Fix ping is lost after untrusted VF had tried to change MAC

Takashi Iwai (2):
      ALSA: hda/via: Apply runtime PM workaround for ASUS B23E
      ASoC: intel: atom: Fix breakage for PCM buffer address setup

Toke Høiland-Jørgensen (1):
      sch_cake: fix srchost/dsthost hashing mode

Tony Lindgren (1):
      bus: ti-sysc: Fix error handling for sysc_check_active_timer()

Uwe Kleine-König (1):
      spi: spi-mux: Add module info needed for autoloading

Vincent Fu (1):
      kyber: make trace_block_rq call consistent with documentation

Vincent Whitchurch (1):
      mmc: dw_mmc: Fix hang on data CRC error

Vladimir Oltean (2):
      net: mscc: ocelot: allow forwarding from bridge ports to the tag_8021q CPU port
      net: dpaa2-switch: disable the control interface on error path

Wang Hai (1):
      ixgbe, xsk: clean up the resources in ixgbe_xsk_pool_enable error path

Xie Yongji (5):
      vhost-vdpa: Fix integer overflow in vhost_vdpa_process_iotlb_update()
      vhost: Fix the calculation in vhost_overflow()
      vdpa_sim: Fix return value check for vdpa_alloc_device()
      vp_vdpa: Fix return value check for vdpa_alloc_device()
      vDPA/ifcvf: Fix return value check for vdpa_alloc_device()

Ye Bin (1):
      scsi: scsi_dh_rdac: Avoid crash during rdac_bus_attach()

Yifan Zhang (1):
      drm/amdgpu: fix the doorbell missing when in CGPG issue for renoir.

Yu Kuai (1):
      dmaengine: usb-dmac: Fix PM reference leak in usb_dmac_probe()

Zhan Liu (1):
      drm/amd/display: Use DCN30 watermark calc for DCN301

jason-jh.lin (2):
      drm/mediatek: Add AAL output size configuration
      drm/mediatek: Add component_del in OVL and COLOR remove function

kaixi.fan (1):
      ovs: clear skb->tstamp in forwarding path

lijinlin (1):
      scsi: core: Fix capacity set to zero after offlinining device

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAmEnliQACgkQ3qZv95d3
LNy7sw/+IaMODMfhfgjotr9kTJ3HlSgxSo7R79dYPZPwK8Lr4M8UpMuIKVkrDVEz
ItDNGt9x3FeG34LeLzMWla/qpigYcf2oyL2W3ESDkWAicZ99BOMNMiUE+3zjHzs2
6QUOYPMrQKMv6Rp53ALnsMdq2MZ90DW22jOKgMOUp2MkR+V4wL+RrKCFuPxmC7DE
gN1sEWVBJeOUtMLyMCJ5sOIOpQ7bObGhMG14BrJQ4MYFhaROiXQt6TdMJnKMNCfD
Ip42h7F8pI4gj2MQMXJmAU0mrxXDJ1DHyhkfbkI/wLAR+/JZUZvg0J9PWeMaIiJ1
CbCDEEz/iTQbKoGe/av4eQaPxw6i5W8patIQob/dOqVeSsqBMzk49TT6m4NfD2qg
gPCGKG/Fee0N6fqboGANTTJ4xxIn5PiGEGklQD4/YTPQzU8fmHPpWgnEh1JUgfSm
12s9kN/BK5MUBtCkPCePsy8OTfYwGoHwlxyhJ4hnCbtfLS24KWSthGDUesPmBD+c
3L1vIH6cJ0M2cWul9ZqftJe/O5MJSYiUjSo5bZRcKxSQy6LcI8kWHGDXxTQPdEd2
Xg8ujhNAC4Ub80+Z52SmMoQ2jvTfQm9c28L5qsWQyL9arRQMWPuRdCK12eijmf3R
EALUtIrge3PGfNgAL+1oBVCCtxCNdDrEBVacqUd48zHHMOyUS0Y=
=+THc
-----END PGP SIGNATURE-----
