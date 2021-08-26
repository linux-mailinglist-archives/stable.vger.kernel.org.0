Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3143F88C6
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 15:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242620AbhHZN0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 09:26:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242573AbhHZN0q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 09:26:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C732860F14;
        Thu, 26 Aug 2021 13:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629984359;
        bh=x1EpvPR76wWs/H9ox8JsdWsXZTtGtrc7djHOBBB/T94=;
        h=From:To:Cc:Subject:Date:From;
        b=kR6LEIbT7l0f/BVPmk17FKNnj9pQVlpHqznLJcChLg0P+hUzlRX1vV9xsZTJcRfLS
         HXKHjhPW9UmbgaHL6E6nubpuLID9p+7XJ+l5nN6g0tT9LEqDLqov8/r8EXSxKGrDNz
         BuY+Eo3gNTu4WxDoO6WWvZMMKitIIpvJVT50kwTCT4CjWaX6NEMAUjWkfavydZsvrV
         4n/05Ae7iX4znS87gL9h/VZI0bvBD5hG0r6Tdk/TPDgVXVoFqWgA2L4SPCAx49suM+
         hydbo/dgY4eikNhdZlcitSFHqsczT4SrCwiFCWW8FdA0C9+PhA1CdFRbR1Ji15TtoC
         xedJWTtXIqh9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 5.10.61
Date:   Thu, 26 Aug 2021 09:25:56 -0400
Message-Id: <20210826132557.804632-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 5.10.61 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha

- ------------


 Makefile                                           |   2 +-
 arch/arm/boot/dts/am43x-epos-evm.dts               |   2 +-
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi         |   4 +-
 .../boot/dts/qcom/msm8992-bullhead-rev-101.dts     |   4 +
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |   4 +-
 arch/s390/pci/pci.c                                |   6 ++
 arch/s390/pci/pci_bus.h                            |   5 +
 arch/x86/kvm/x86.c                                 |  62 ++++++-----
 arch/x86/kvm/x86.h                                 |   2 +
 drivers/bus/ti-sysc.c                              |   4 +-
 drivers/clk/imx/clk-imx6q.c                        |   2 +-
 drivers/clk/qcom/gdsc.c                            |  54 ++++++----
 drivers/cpufreq/armada-37xx-cpufreq.c              |   6 +-
 drivers/dma/of-dma.c                               |   9 +-
 drivers/dma/sh/usb-dmac.c                          |   2 +-
 drivers/dma/xilinx/xilinx_dma.c                    |  12 +++
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |  21 +++-
 .../drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c  |   4 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c  |   2 +-
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c        |   4 +-
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.h        |  34 +------
 drivers/iommu/intel/pasid.c                        |  26 ++---
 drivers/iommu/intel/pasid.h                        |   6 ++
 drivers/iommu/intel/svm.c                          |  55 ++--------
 drivers/iommu/iommu.c                              |   3 +
 drivers/ipack/carriers/tpci200.c                   |  60 ++++++-----
 drivers/media/usb/zr364xx/zr364xx.c                |  77 +++++++++-----
 drivers/mmc/host/dw_mmc.c                          |   6 +-
 drivers/mmc/host/mmci_stm32_sdmmc.c                |   7 +-
 drivers/mmc/host/sdhci-iproc.c                     |  21 +++-
 drivers/mmc/host/sdhci-msm.c                       |  18 ++++
 drivers/mtd/chips/cfi_cmdset_0002.c                |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 113 ++++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   3 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |   1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   1 +
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  47 ++++++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   5 +-
 drivers/net/ethernet/qlogic/qede/qede.h            |   1 +
 drivers/net/ethernet/qlogic/qede/qede_main.c       |   8 ++
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |   4 +-
 drivers/net/hamradio/6pack.c                       |   6 ++
 drivers/net/mdio/mdio-mux.c                        |  36 ++++---
 drivers/net/usb/lan78xx.c                          |  16 ++-
 drivers/net/usb/pegasus.c                          | 108 ++++++++++++++------
 drivers/net/usb/r8152.c                            |   2 +-
 drivers/net/virtio_net.c                           |  76 ++++++++++----
 drivers/net/vrf.c                                  |   4 +
 drivers/net/wireless/ath/ath.h                     |   3 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   2 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   1 +
 drivers/net/wireless/ath/ath9k/main.c              |  95 ++++++++++++++++-
 drivers/net/wireless/ath/key.c                     |  41 +++++---
 drivers/pci/quirks.c                               |   1 +
 drivers/ptp/Kconfig                                |   3 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c         |   4 +-
 drivers/scsi/megaraid/megaraid_mm.c                |  21 ++--
 drivers/scsi/pm8001/pm8001_sas.c                   |  32 +++---
 drivers/scsi/scsi_scan.c                           |   3 +-
 drivers/scsi/scsi_sysfs.c                          |   9 +-
 drivers/slimbus/messaging.c                        |   7 +-
 drivers/slimbus/qcom-ngd-ctrl.c                    |   5 +-
 drivers/soc/mediatek/mtk-mmsys.c                   |   4 +-
 drivers/spi/spi-mux.c                              |   8 ++
 drivers/usb/core/devio.c                           |   2 +-
 drivers/usb/core/message.c                         |   6 ++
 drivers/vdpa/mlx5/core/mr.c                        |   9 --
 drivers/vhost/vdpa.c                               |   3 +-
 drivers/vhost/vhost.c                              |  10 +-
 drivers/virtio/virtio.c                            |   1 +
 drivers/virtio/virtio_ring.c                       |   8 ++
 fs/btrfs/inode.c                                   |  10 +-
 fs/io_uring.c                                      |  16 +--
 fs/namespace.c                                     |   6 +-
 include/linux/memcontrol.h                         |  29 +++---
 include/linux/soc/mediatek/mtk-mmsys.h             |  33 ++++++
 include/linux/virtio.h                             |   1 +
 include/net/flow_offload.h                         |  12 +--
 kernel/bpf/verifier.c                              |   1 +
 kernel/trace/trace_events_hist.c                   |   2 +
 mm/vmscan.c                                        |  27 +++--
 net/bluetooth/hidp/core.c                          |   2 +-
 net/dccp/dccp.h                                    |   6 +-
 net/openvswitch/vport.c                            |   1 +
 net/sched/sch_cake.c                               |   2 +-
 net/xfrm/xfrm_ipcomp.c                             |   2 +-
 sound/pci/hda/hda_generic.c                        |  10 +-
 sound/pci/hda/patch_realtek.c                      |  12 ++-
 sound/pci/hda/patch_via.c                          |   1 +
 sound/soc/intel/atom/sst-mfld-platform-pcm.c       |   2 +-
 92 files changed, 965 insertions(+), 448 deletions(-)

Adrian Larumbe (1):
      dmaengine: xilinx_dma: Fix read-after-free bug when terminating transfers

Alan Stern (2):
      USB: core: Avoid WARNings for 0-length descriptor requests
      USB: core: Fix incorrect pipe calculation in do_proc_control()

Andreas Persson (1):
      mtd: cfi_cmdset_0002: fix crash when erasing/writing AMD cards

Andy Shevchenko (1):
      ptp_pch: Restore dependency on PCI

Arkadiusz Kubalewski (1):
      i40e: Fix ATR queue selection

Bing Guo (1):
      drm/amd/display: Fix Dynamic bpp issue with 8K30 with Navi 1X

Bjorn Andersson (1):
      clk: qcom: gdsc: Ensure regulator init state matches GDSC state

Christophe Kerello (1):
      mmc: mmci: stm32: Check when the voltage switch procedure should be done

Dan Carpenter (1):
      media: zr364xx: fix memory leaks in probe()

Dave Gerlach (1):
      ARM: dts: am43x-epos-evm: Reduce i2c0 bus speed for tps65218

Dinghao Liu (1):
      net: qlcnic: add missed unlock in qlcnic_83xx_flash_read32

Dong Aisheng (1):
      clk: imx6q: fix uart earlycon unwork

Dongliang Mu (2):
      ipack: tpci200: fix many double free issues in tpci200_pci_probe
      ipack: tpci200: fix memory leak in the tpci200_register

Eli Cohen (1):
      vdpa/mlx5: Avoid destroying MR on empty iotlb

Evgeny Novikov (1):
      media: zr364xx: propagate errors from zr364xx_start_readpipe()

Frank Wunderlich (1):
      iommu: Check if group is NULL before remove device

Harshvardhan Jha (2):
      net: xfrm: Fix end of loop tests for list_for_each_entry
      scsi: megaraid_mm: Fix end of loop tests for list_for_each_entry()

Hayes Wang (1):
      r8152: fix writing USB_BP2_EN

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
      io_uring: fix xa_alloc_cycle() error return value check
      io_uring: only assign io_uring_enter() SQPOLL error in actual error case

Johannes Weiner (1):
      mm: memcontrol: fix occasional OOMs due to proportional memory.low reclaim

Jouni Malinen (5):
      ath: Use safer key clearing with key cache entries
      ath9k: Clear key cache explicitly on disabling hardware
      ath: Export ath_hw_keysetmac()
      ath: Modify ath_key_delete() to not need full key entry
      ath9k: Postpone key cache entry deletion for TXQ frames reference it

Kai-Heng Feng (1):
      ALSA: hda/realtek: Limit mic boost on HP ProBook 445 G8

Kristin Paget (1):
      ALSA: hda/realtek: Enable 4-speaker output for Dell XPS 15 9510 laptop

Lahav Schlesinger (1):
      vrf: Reset skb conntrack connection on VRF rcv

Liu Yi L (1):
      iommu/vt-d: Fix incomplete cache flush in intel_pasid_tear_down_entry()

Lu Baolu (1):
      iommu/vt-d: Consolidate duplicate cache invaliation code

Marcin Bachry (1):
      PCI: Increase D3 delay for AMD Renoir/Cezanne XHCI

Marek Behún (1):
      cpufreq: armada-37xx: forbid cpufreq for 1.2 GHz variant

Michael Chan (2):
      bnxt_en: Disable aRFS if running on 212 firmware
      bnxt_en: Add missing DMA memory barriers

NeilBrown (1):
      btrfs: prevent rename2 from exchanging a subvol with a directory from different parents

Nicolas Saenz Julienne (2):
      mmc: sdhci-iproc: Cap min clock frequency on BCM2711
      mmc: sdhci-iproc: Set SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN on BCM2711

Niklas Schnelle (1):
      s390/pci: fix use after free of zpci_dev

Ole Bjørn Midtbø (1):
      Bluetooth: hidp: use correct wait queue when removing ctrl_wait

Parav Pandit (1):
      virtio: Protect vqs list access

Pavel Skripkin (2):
      media: drivers/media/usb: fix memory leak in zr364xx_probe
      net: 6pack: fix slab-out-of-bounds in decode_data

Peter Ujfalusi (1):
      dmaengine: of-dma: router_xlate to return -EPROBE_DEFER if controller is not yet available

Petko Manolov (1):
      net: usb: pegasus: Check the return value of get_geristers() and friends;

Petr Vorel (1):
      arm64: dts: qcom: msm8992-bullhead: Remove PSCI

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
      Linux 5.10.61

Shaik Sajida Bhanu (1):
      mmc: sdhci-msm: Update the software timeout value for sdhc

Sreekanth Reddy (1):
      scsi: core: Avoid printing an error if target_alloc() returns -ENXIO

Srinivas Kandagatla (4):
      arm64: dts: qcom: c630: fix correct powerdown pin for WSA881x
      slimbus: messaging: start transaction ids from 1 instead of zero
      slimbus: messaging: check for valid transaction id
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

Vincent Whitchurch (1):
      mmc: dw_mmc: Fix hang on data CRC error

Wang Hai (1):
      ixgbe, xsk: clean up the resources in ixgbe_xsk_pool_enable error path

Wanpeng Li (1):
      KVM: X86: Fix warning caused by stale emulation context

Wei Huang (1):
      KVM: x86: Factor out x86 instruction emulation with decoding

Xie Yongji (2):
      vhost-vdpa: Fix integer overflow in vhost_vdpa_process_iotlb_update()
      vhost: Fix the calculation in vhost_overflow()

Xuan Zhuo (1):
      virtio-net: support XDP when not more queues

Ye Bin (1):
      scsi: scsi_dh_rdac: Avoid crash during rdac_bus_attach()

Yifan Zhang (1):
      drm/amdgpu: fix the doorbell missing when in CGPG issue for renoir.

Yongqiang Niu (2):
      soc / drm: mediatek: Move DDP component defines into mtk-mmsys.h
      drm/mediatek: Fix aal size config

Yu Kuai (1):
      dmaengine: usb-dmac: Fix PM reference leak in usb_dmac_probe()

jason-jh.lin (1):
      drm/mediatek: Add AAL output size configuration

kaixi.fan (1):
      ovs: clear skb->tstamp in forwarding path

lijinlin (1):
      scsi: core: Fix capacity set to zero after offlinining device

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAmEnll0ACgkQ3qZv95d3
LNyAbg//QiFsXXCStPZdxLBlkSEYdBw7Wi5RhrhsRCWwkvkyLsQVHN6yt9hPMAj7
+Yee2H5WjCYK+Hm9g50JMv4p8LK17OqGhs208PlSM0IyFk4cdx01XzR07nJdTd9u
sTSURmN4e44n9kjcupJZaqyIIWWtsxX7yfXBacFUMBQK0LQ4CXuIk7jN09GB36CE
fnzr9maRJodPyoZMi0q6U/8rype12lnj+j/DpgZQLWFGf28gWrWrWtAKUcX62IpM
YnHyhhwslBXEQ7CI0E1OGPRobi5XlkjLJYEQk1xW7ojeBQ2yeFUUTZeVuC/Ahhuh
3AnxGcCNK7okFs9z+dWX+mxIxG9hagbU4/BNueVWnDAGhBhFQA17/EmsmH2lSRQV
Hp1FKwfoTZX6IijOhObSSLaQ5vekHcyv8OVdSxDeG5PnDM9/uJk1bSPvoSo2pPds
QutpI97Avj/7SZ3UhhwG6S6ftYdT73PBlBlXq5gAQrFQYrgboDNyS6RgBPcHPjvo
AiPzwbbpLXl9O82DU+M6JFX33aIITFbr5lnLRO9+qQEAF2pGqZW56MZyRKQiQ+sL
BhNzTyHCDHTxwHB0JuK0ruYH7G8va6YfI9+mZdMfVyDexzu8N+WuH2KbUtZS2xmc
woGJnBnljV1thrcyNWdCfspemPziI5i1zzfPNXsAofPiOR8JP5o=
=p96D
-----END PGP SIGNATURE-----
