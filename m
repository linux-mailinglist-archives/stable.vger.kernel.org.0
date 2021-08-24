Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141A23F6574
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239642AbhHXRNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:13:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240300AbhHXRLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:11:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94D1B6115A;
        Tue, 24 Aug 2021 17:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824468;
        bh=eFkVeNGMI299DpxPgL6UUYpRGowMaIauZtidnTS7xsg=;
        h=From:To:Cc:Subject:Date:From;
        b=jkaHoFVBjjgG+92Ob4QW0R94vYT5S1ukGrLJEmsKszkbvh+zsc/d7tyuzoo8GcZ7U
         +RWAb1Q9SlLFAOOVXCExdt1LGWBGbWofljeukaiKCDBnah7R7448yjLeUrpra/3J+B
         XEk7Q2rTfk0tVpyuIZWRFNqqbQIX0Bz80w1JV/aEE/YKSswHEbuS50MJa370TUO6oG
         PTO2Slmn3s9qu3IA7qvT2vzQWx9FWLSMcv01XqARKhtQr7I85q68qF+ngpeuIxQtM7
         y+8cnvGQCJOJ3nGYtxTQV8bpBgFLy28H1D7yF08LOD/oUAPQw5LVg73vZYANUpsdto
         TftivwmwChNFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de
Subject: [PATCH 5.4 00/61] 5.4.143-rc1 review
Date:   Tue, 24 Aug 2021 13:00:05 -0400
Message-Id: <20210824170106.710221-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is the start of the stable review cycle for the 5.4.143 release.
There are 61 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu 26 Aug 2021 05:01:01 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.4.y&id2=v5.4.142
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

Adrian Larumbe (1):
  dmaengine: xilinx_dma: Fix read-after-free bug when terminating
    transfers

Alan Stern (1):
  USB: core: Avoid WARNings for 0-length descriptor requests

Andreas Persson (1):
  mtd: cfi_cmdset_0002: fix crash when erasing/writing AMD cards

Andy Shevchenko (1):
  ptp_pch: Restore dependency on PCI

Arkadiusz Kubalewski (1):
  i40e: Fix ATR queue selection

Bing Guo (1):
  drm/amd/display: Fix Dynamic bpp issue with 8K30 with Navi 1X

Dan Carpenter (1):
  media: zr364xx: fix memory leaks in probe()

Dave Gerlach (1):
  ARM: dts: am43x-epos-evm: Reduce i2c0 bus speed for tps65218

Dinghao Liu (1):
  net: qlcnic: add missed unlock in qlcnic_83xx_flash_read32

Dongliang Mu (2):
  ipack: tpci200: fix many double free issues in tpci200_pci_probe
  ipack: tpci200: fix memory leak in the tpci200_register

Evgeny Novikov (1):
  media: zr364xx: propagate errors from zr364xx_start_readpipe()

Frank Wunderlich (1):
  iommu: Check if group is NULL before remove device

Harshvardhan Jha (1):
  scsi: megaraid_mm: Fix end of loop tests for list_for_each_entry()

Ilya Leoshkevich (1):
  bpf: Clear zext_dst of dead insns

Ivan T. Ivanov (1):
  net: usb: lan78xx: don't modify phy_device state concurrently

Jakub Kicinski (2):
  bnxt: don't lock the tx queue from napi poll
  bnxt: disable napi before canceling DIM

Jaroslav Kysela (1):
  ALSA: hda - fix the 'Capture Switch' value change notifications

Jason Wang (1):
  virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO

Jeff Layton (1):
  fs: warn about impending deprecation of mandatory locks

Johannes Weiner (1):
  mm: memcontrol: fix occasional OOMs due to proportional memory.low
    reclaim

Jouni Malinen (5):
  ath: Use safer key clearing with key cache entries
  ath9k: Clear key cache explicitly on disabling hardware
  ath: Export ath_hw_keysetmac()
  ath: Modify ath_key_delete() to not need full key entry
  ath9k: Postpone key cache entry deletion for TXQ frames reference it

Lahav Schlesinger (1):
  vrf: Reset skb conntrack connection on VRF rcv

Marcin Bachry (1):
  PCI: Increase D3 delay for AMD Renoir/Cezanne XHCI

Marek Behún (1):
  cpufreq: armada-37xx: forbid cpufreq for 1.2 GHz variant

Michael Chan (1):
  bnxt_en: Add missing DMA memory barriers

Murphy Zhou (1):
  ovl: add splice file read write helper

NeilBrown (1):
  btrfs: prevent rename2 from exchanging a subvol with a directory from
    different parents

Ole Bjørn Midtbø (1):
  Bluetooth: hidp: use correct wait queue when removing ctrl_wait

Parav Pandit (1):
  virtio: Protect vqs list access

Pavel Skripkin (2):
  media: drivers/media/usb: fix memory leak in zr364xx_probe
  net: 6pack: fix slab-out-of-bounds in decode_data

Peter Ujfalusi (1):
  dmaengine: of-dma: router_xlate to return -EPROBE_DEFER if controller
    is not yet available

Randy Dunlap (1):
  dccp: add do-while-0 stubs for dccp_pr_debug macros

Ritesh Harjani (1):
  ext4: fix EXT4_MAX_LOGICAL_BLOCK macro

Saravana Kannan (2):
  net: mdio-mux: Don't ignore memory allocation errors
  net: mdio-mux: Handle -EPROBE_DEFER correctly

Sasha Levin (1):
  Linux 5.4.143-rc1

Sergey Marinkevich (1):
  netfilter: nft_exthdr: fix endianness of tcp option cast

Sreekanth Reddy (1):
  scsi: core: Avoid printing an error if target_alloc() returns -ENXIO

Srinivas Kandagatla (3):
  slimbus: messaging: start transaction ids from 1 instead of zero
  slimbus: messaging: check for valid transaction id
  slimbus: ngd: reset dma setup during runtime pm

Steven Rostedt (VMware) (1):
  tracing / histogram: Fix NULL pointer dereference on strcmp() on NULL
    event name

Sudeep Holla (1):
  ARM: dts: nomadik: Fix up interrupt controller node names

Sylwester Dziedziuch (1):
  iavf: Fix ping is lost after untrusted VF had tried to change MAC

Takashi Iwai (1):
  ASoC: intel: atom: Fix breakage for PCM buffer address setup

Thomas Gleixner (1):
  x86/fpu: Make init_fpstate correct with optimized XSAVE

Vincent Whitchurch (1):
  mmc: dw_mmc: Fix hang on data CRC error

Xie Yongji (1):
  vhost: Fix the calculation in vhost_overflow()

Xuan Zhuo (1):
  virtio-net: support XDP when not more queues

Yafang Shao (1):
  mm, memcg: avoid stale protection values when cgroup is above
    protection

Ye Bin (1):
  scsi: scsi_dh_rdac: Avoid crash during rdac_bus_attach()

Yu Kuai (1):
  dmaengine: usb-dmac: Fix PM reference leak in usb_dmac_probe()

kaixi.fan (1):
  ovs: clear skb->tstamp in forwarding path

lijinlin (1):
  scsi: core: Fix capacity set to zero after offlinining device

 Makefile                                      |  4 +-
 arch/arm/boot/dts/am43x-epos-evm.dts          |  2 +-
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi    |  4 +-
 arch/x86/include/asm/fpu/internal.h           | 30 ++----
 arch/x86/kernel/fpu/xstate.c                  | 38 +++++++-
 drivers/cpufreq/armada-37xx-cpufreq.c         |  6 +-
 drivers/dma/of-dma.c                          |  9 +-
 drivers/dma/sh/usb-dmac.c                     |  2 +-
 drivers/dma/xilinx/xilinx_dma.c               | 12 +++
 .../gpu/drm/amd/display/dc/dcn20/dcn20_optc.c |  2 +-
 drivers/iommu/iommu.c                         |  3 +
 drivers/ipack/carriers/tpci200.c              | 60 ++++++------
 drivers/media/usb/zr364xx/zr364xx.c           | 77 ++++++++++-----
 drivers/mmc/host/dw_mmc.c                     |  6 +-
 drivers/mtd/chips/cfi_cmdset_0002.c           |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 69 +++++++++-----
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  3 +-
 drivers/net/ethernet/intel/iavf/iavf.h        |  1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  1 +
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 47 ++++++++-
 .../ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c   |  4 +-
 drivers/net/hamradio/6pack.c                  |  6 ++
 drivers/net/phy/mdio-mux.c                    | 36 ++++---
 drivers/net/usb/lan78xx.c                     | 16 +++-
 drivers/net/virtio_net.c                      | 76 +++++++++++----
 drivers/net/vrf.c                             |  4 +
 drivers/net/wireless/ath/ath.h                |  3 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  2 +-
 drivers/net/wireless/ath/ath9k/hw.h           |  1 +
 drivers/net/wireless/ath/ath9k/main.c         | 95 ++++++++++++++++++-
 drivers/net/wireless/ath/key.c                | 41 ++++----
 drivers/pci/quirks.c                          |  1 +
 drivers/ptp/Kconfig                           |  3 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c    |  4 +-
 drivers/scsi/megaraid/megaraid_mm.c           | 21 ++--
 drivers/scsi/scsi_scan.c                      |  3 +-
 drivers/scsi/scsi_sysfs.c                     |  9 +-
 drivers/slimbus/messaging.c                   |  7 +-
 drivers/slimbus/qcom-ngd-ctrl.c               |  5 +-
 drivers/usb/core/message.c                    |  6 ++
 drivers/vhost/vhost.c                         | 10 +-
 drivers/virtio/virtio.c                       |  1 +
 drivers/virtio/virtio_ring.c                  |  8 ++
 fs/btrfs/inode.c                              | 10 +-
 fs/ext4/ext4.h                                |  2 +-
 fs/namespace.c                                |  6 +-
 fs/overlayfs/file.c                           | 47 +++++++++
 include/linux/memcontrol.h                    | 59 ++++++++++--
 include/linux/virtio.h                        |  1 +
 kernel/bpf/verifier.c                         |  1 +
 kernel/trace/trace_events_hist.c              |  2 +
 mm/memcontrol.c                               |  8 ++
 mm/vmscan.c                                   | 26 +++--
 net/bluetooth/hidp/core.c                     |  2 +-
 net/dccp/dccp.h                               |  6 +-
 net/netfilter/nft_exthdr.c                    |  8 +-
 net/openvswitch/vport.c                       |  1 +
 sound/pci/hda/hda_generic.c                   | 10 +-
 sound/soc/intel/atom/sst-mfld-platform-pcm.c  |  2 +-
 60 files changed, 702 insertions(+), 231 deletions(-)

-- 
2.30.2

