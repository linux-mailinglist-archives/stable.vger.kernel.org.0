Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F63524B44
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 13:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353062AbiELLQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 07:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353121AbiELLQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 07:16:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C96020192;
        Thu, 12 May 2022 04:16:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43D4CB8277C;
        Thu, 12 May 2022 11:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629C3C385B8;
        Thu, 12 May 2022 11:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652354193;
        bh=tVzzCW1SaDyEUPmQF4TA7rKcjbAJoLV4gyqrzyQ9D3o=;
        h=From:To:Cc:Subject:Date:From;
        b=yIVL3iIm/s0QKoYNH1woFoAL95YxkDAF/bz8gZNgZ4b9BcRY4jFYl/R26J9AAgHYK
         gT1iYB1c1XNjsaMLq7JvBqT6KkIwueWU+eGGZKEkIiet1gms8UlxNvXKvxGP6NmBeM
         eTolZlMkjviv1LRtF5eOb8wByMb5KeCmYUlXt0LQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.115
Date:   Thu, 12 May 2022 13:16:16 +0200
Message-Id: <16523541776176@kroah.com>
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

I'm announcing the release of the 5.10.115 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/mips/include/asm/timex.h                                  |    8 -
 arch/mips/kernel/time.c                                        |   11 --
 arch/parisc/kernel/processor.c                                 |    3 
 arch/x86/kernel/kvm.c                                          |   13 ++
 arch/x86/kvm/cpuid.c                                           |    5 +
 arch/x86/kvm/lapic.c                                           |   10 +-
 arch/x86/kvm/mmu/mmu.c                                         |    2 
 arch/x86/kvm/svm/pmu.c                                         |   28 +++++-
 block/blk-map.c                                                |    2 
 drivers/firewire/core-card.c                                   |    3 
 drivers/firewire/core-cdev.c                                   |    4 
 drivers/firewire/core-topology.c                               |    9 -
 drivers/firewire/core-transaction.c                            |   30 +++---
 drivers/firewire/sbp2.c                                        |   13 +-
 drivers/gpio/gpio-pca953x.c                                    |    4 
 drivers/gpio/gpiolib-of.c                                      |    2 
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c               |    2 
 drivers/hwmon/adt7470.c                                        |    4 
 drivers/infiniband/sw/siw/siw_cm.c                             |    7 -
 drivers/iommu/intel/iommu.c                                    |   27 +++++
 drivers/md/dm.c                                                |    8 +
 drivers/mmc/core/mmc.c                                         |   23 ++++-
 drivers/mmc/host/rtsx_pci_sdmmc.c                              |   31 ++++--
 drivers/mmc/host/sdhci-msm.c                                   |   42 +++++++++
 drivers/net/can/grcan.c                                        |   46 +++++-----
 drivers/net/dsa/mt7530.c                                       |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                      |   13 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c                |    7 +
 drivers/net/ethernet/mediatek/mtk_sgmii.c                      |    1 
 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c        |   31 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c       |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c             |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c             |   10 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                |   11 ++
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c             |   28 ++++--
 drivers/net/ethernet/smsc/smsc911x.c                           |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c              |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c              |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c              |    2 
 drivers/net/ethernet/ti/cpsw_new.c                             |    5 -
 drivers/net/ethernet/xilinx/xilinx_emaclite.c                  |   15 ++-
 drivers/nfc/nfcmrvl/main.c                                     |    2 
 drivers/pci/controller/pci-aardvark.c                          |   16 +--
 drivers/s390/block/dasd.c                                      |   18 +++
 drivers/s390/block/dasd_eckd.c                                 |   28 ++++--
 drivers/s390/block/dasd_int.h                                  |   14 +++
 fs/btrfs/tree-log.c                                            |   14 ++-
 fs/nfs/nfs4proc.c                                              |   12 ++
 include/linux/stmmac.h                                         |    1 
 kernel/irq/internals.h                                         |    2 
 kernel/irq/irqdesc.c                                           |    2 
 kernel/irq/manage.c                                            |   39 ++++++--
 kernel/rcu/tree.c                                              |   32 +++---
 net/can/isotp.c                                                |   22 +---
 net/ipv4/igmp.c                                                |    9 +
 net/nfc/core.c                                                 |   29 +++---
 net/nfc/netlink.c                                              |    4 
 net/sunrpc/xprtsock.c                                          |    3 
 sound/firewire/fireworks/fireworks_hwdep.c                     |    1 
 sound/pci/hda/patch_realtek.c                                  |    1 
 sound/soc/codecs/da7219.c                                      |   14 ++-
 sound/soc/codecs/wm8958-dsp2.c                                 |    8 -
 sound/soc/meson/aiu-acodec-ctrl.c                              |    2 
 sound/soc/meson/aiu-codec-ctrl.c                               |    2 
 sound/soc/meson/g12a-tohdmitx.c                                |    2 
 sound/soc/soc-generic-dmaengine-pcm.c                          |    6 -
 tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh |    2 
 tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh |    3 
 tools/testing/selftests/seccomp/seccomp_bpf.c                  |   10 +-
 70 files changed, 536 insertions(+), 237 deletions(-)

Andreas Larsson (2):
      can: grcan: grcan_probe(): fix broken system id check for errata workaround needs
      can: grcan: only use the NAPI poll budget for RX

Andrei Lalaev (1):
      gpiolib: of: fix bounds check for 'gpio-reserved-ranges'

Armin Wolf (1):
      hwmon: (adt7470) Fix warning on module removal

Aya Levin (1):
      net/mlx5: Fix slab-out-of-bounds while reading resource dump menu

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

David Stevens (1):
      iommu/vt-d: Calculate mask for non-aligned flushes

Duoming Zhou (4):
      can: grcan: grcan_close(): fix deadlock
      nfc: replace improper check device_is_registered() in netlink related functions
      nfc: nfcmrvl: main: reorder destructive operations in nfcmrvl_nci_unregister_dev to avoid bugs
      NFC: netlink: fix sleep in atomic bug when firmware download timeout

Eric Dumazet (1):
      net: igmp: respect RCU rules in ip_mc_source() and ip_mc_msfilter()

Filipe Manana (1):
      btrfs: always log symlinks in full mode

Frederic Weisbecker (2):
      rcu: Fix callbacks processing time limit retaining cond_resched()
      rcu: Apply callbacks processing time limit only on softirq

Greg Kroah-Hartman (1):
      Linux 5.10.115

Haimin Zhang (1):
      block-map: add __GFP_ZERO flag for alloc_page in function bio_copy_kern

Harry Wentland (1):
      drm/amd/display: Avoid reading audio pattern past AUDIO_CHANNELS_COUNT

Helge Deller (1):
      parisc: Merge model and model name into one line in /proc/cpuinfo

Ido Schimmel (1):
      selftests: mirror_gre_bridge_1q: Avoid changing PVID while interface is operational

Jakob Koschel (1):
      firewire: remove check of list iterator against head past the loop body

Jan Höppner (2):
      s390/dasd: Fix read for ESE with blksize < 4k
      s390/dasd: Fix read inconsistency for ESE DASD devices

Jann Horn (1):
      selftests/seccomp: Don't call read() on TTY from background pgrp

Kyle Huey (1):
      KVM: x86/svm: Account for family 17h event renumberings in amd_pmc_perf_hw_id

Maciej W. Rozycki (1):
      MIPS: Fix CP0 counter erratum detection for R4k CPUs

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

Mike Snitzer (1):
      dm: interlock pending dm_io and dm_wait_for_bios_completion

Moshe Shemesh (1):
      net/mlx5: Avoid double clear or set of sync reset requested

Moshe Tal (1):
      net/mlx5e: Fix trust state reset in reload

Niels Dossche (1):
      firewire: core: extend card->lock in fw_core_handle_bus_reset

Oliver Hartkopp (1):
      can: isotp: remove re-binding of bound socket

Pali Rohár (2):
      PCI: aardvark: Clear all MSIs at setup
      PCI: aardvark: Fix reading MSI interrupt number

Paolo Bonzini (2):
      KVM: x86: Do not change ICR on write to APIC_SELF_IPI
      KVM: x86/mmu: avoid NULL-pointer dereference on page freeing bugs

Paul Blakey (1):
      net/mlx5e: CT: Fix queued up restore put() executing after relevant ft release

Puyou Lu (1):
      gpio: pca953x: fix irq_stat not updated when irq is disabled (irq_mask not set)

Qiao Ma (1):
      hinic: fix bug of wq out of bound access

Ricky WU (1):
      mmc: rtsx: add 74 Clocks in power on flow

Sandipan Das (1):
      kvm: x86/cpuid: Only provide CPUID leaf 0xA if host has architectural PMU

Sergey Shtylyov (1):
      smsc911x: allow using IRQ0

Shaik Sajida Bhanu (1):
      mmc: sdhci-msm: Reset GCC_SDCC_BCR register for SDHC

Shravya Kumbham (1):
      net: emaclite: Add error handling for of_address_to_resource()

Somnath Kotur (1):
      bnxt_en: Fix possible bnxt_open() failure caused by wrong RFS flag

Stefan Haberland (2):
      s390/dasd: fix data corruption for ESE devices
      s390/dasd: prevent double format of tracks for ESE devices

Takashi Sakamoto (1):
      ALSA: fireworks: fix wrong return count shorter than expected by 4 bytes

Tan Tee Min (1):
      net: stmmac: disable Split Header (SPH) for Intel platforms

Thomas Pfaff (1):
      genirq: Synchronize interrupt thread startup

Trond Myklebust (2):
      Revert "SUNRPC: attempt AF_LOCAL connect on setup"
      NFSv4: Don't invalidate inode attributes on delegation return

Vlad Buslov (1):
      net/mlx5e: Don't match double-vlan packets if cvlan is not set

Vladimir Oltean (1):
      selftests: ocelot: tc_flower_chains: specify conform-exceed action for policer

Wanpeng Li (2):
      x86/kvm: Preserve BSP MSR_KVM_POLL_CONTROL across suspend/resume
      KVM: LAPIC: Enable timer posted-interrupt only when mwait/hlt is advertised

Yang Yingliang (4):
      net: ethernet: mediatek: add missing of_node_put() in mtk_sgmii_init()
      net: dsa: mt7530: add missing of_node_put() in mt7530_setup()
      net: stmmac: dwmac-sun8i: add missing of_node_put() in sun8i_dwmac_register_mdio_mux()
      net: cpsw: add missing of_node_put() in cpsw_probe_dt()

Zihao Wang (1):
      ALSA: hda/realtek: Add quirk for Yoga Duet 7 13ITL6 speakers

