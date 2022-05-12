Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC9D524B53
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 13:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350754AbiELLR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 07:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352974AbiELLQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 07:16:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA2922BE4;
        Thu, 12 May 2022 04:16:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 139A961E56;
        Thu, 12 May 2022 11:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBC2C385B8;
        Thu, 12 May 2022 11:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652354186;
        bh=ms1am4vBb+FNv8/xqwZwwHqhyUedJzLh/IptVOR3hCE=;
        h=From:To:Cc:Subject:Date:From;
        b=u8ABRPOTxDpfUn0bYWydN8oVnheHzTN0d7Fte7WPwLvx6H70NUH1ETohPpixPpmbx
         WPyiDgQgr3PJv+cRszDMr1wnzkgwC7D3pPa6SSql/aU9DN9Z/qRWEaVTZfcVMXyLb9
         D5M9bChxVYt31XK30P+ih3aH5ef4HfHE7gISPAYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.193
Date:   Thu, 12 May 2022 13:16:09 +0200
Message-Id: <16523541695441@kroah.com>
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

I'm announcing the release of the 5.4.193 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/mips/include/asm/timex.h                                  |    8 
 arch/mips/kernel/time.c                                        |   11 -
 arch/parisc/kernel/processor.c                                 |    3 
 arch/x86/kernel/kvm.c                                          |   13 +
 arch/x86/kvm/cpuid.c                                           |    5 
 arch/x86/kvm/lapic.c                                           |    3 
 block/bio.c                                                    |    2 
 drivers/acpi/acpica/nsaccess.c                                 |    3 
 drivers/firewire/core-card.c                                   |    3 
 drivers/firewire/core-cdev.c                                   |    4 
 drivers/firewire/core-topology.c                               |    9 
 drivers/firewire/core-transaction.c                            |   30 +-
 drivers/firewire/sbp2.c                                        |   13 -
 drivers/gpio/gpiolib-of.c                                      |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c               |   10 
 drivers/hwmon/adt7470.c                                        |    4 
 drivers/infiniband/sw/siw/siw_cm.c                             |    7 
 drivers/md/dm.c                                                |   25 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c                              |   31 +-
 drivers/net/can/grcan.c                                        |    8 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                      |    9 
 drivers/net/ethernet/mediatek/mtk_sgmii.c                      |    1 
 drivers/net/ethernet/smsc/smsc911x.c                           |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c              |    1 
 drivers/net/ethernet/xilinx/xilinx_emaclite.c                  |   15 +
 drivers/nfc/nfcmrvl/main.c                                     |    2 
 drivers/pci/controller/pci-aardvark.c                          |   16 -
 drivers/s390/block/dasd.c                                      |   18 +
 drivers/s390/block/dasd_eckd.c                                 |   28 +-
 drivers/s390/block/dasd_int.h                                  |   14 +
 fs/btrfs/tree-log.c                                            |   14 +
 fs/nfs/nfs4proc.c                                              |   12 +
 include/net/tcp.h                                              |    5 
 include/sound/pcm.h                                            |    2 
 kernel/irq/internals.h                                         |    2 
 kernel/irq/irqdesc.c                                           |    2 
 kernel/irq/manage.c                                            |   39 ++-
 mm/page_io.c                                                   |   54 ----
 net/ipv4/igmp.c                                                |    9 
 net/ipv4/syncookies.c                                          |    1 
 net/ipv4/tcp_ipv4.c                                            |    2 
 net/ipv6/addrconf.c                                            |    8 
 net/ipv6/syncookies.c                                          |    1 
 net/ipv6/tcp_ipv6.c                                            |    2 
 net/nfc/core.c                                                 |   29 +-
 net/nfc/netlink.c                                              |    4 
 net/sunrpc/xprtsock.c                                          |    3 
 sound/core/pcm.c                                               |    3 
 sound/core/pcm_lib.c                                           |    5 
 sound/core/pcm_memory.c                                        |   11 -
 sound/core/pcm_native.c                                        |  110 +++++++---
 sound/firewire/fireworks/fireworks_hwdep.c                     |    1 
 sound/soc/codecs/da7219.c                                      |   14 -
 sound/soc/codecs/wm8958-dsp2.c                                 |    8 
 sound/soc/meson/g12a-tohdmitx.c                                |    2 
 sound/soc/soc-generic-dmaengine-pcm.c                          |    6 
 tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh |    3 
 58 files changed, 408 insertions(+), 246 deletions(-)

Andrei Lalaev (1):
      gpiolib: of: fix bounds check for 'gpio-reserved-ranges'

Armin Wolf (1):
      hwmon: (adt7470) Fix warning on module removal

Cheng Xu (1):
      RDMA/siw: Fix a condition race issue in MPA request processing

Chengfeng Ye (1):
      firewire: fix potential uaf in outbound_phy_packet_callback()

Codrin Ciubotariu (1):
      ASoC: dmaengine: Restore NULL prepare_slave_config() callback

Daniel Hellstrom (1):
      can: grcan: use ofdev->dev when allocating DMA memory

Duoming Zhou (4):
      can: grcan: grcan_close(): fix deadlock
      nfc: replace improper check device_is_registered() in netlink related functions
      nfc: nfcmrvl: main: reorder destructive operations in nfcmrvl_nci_unregister_dev to avoid bugs
      NFC: netlink: fix sleep in atomic bug when firmware download timeout

Eric Dumazet (2):
      net: igmp: respect RCU rules in ip_mc_source() and ip_mc_msfilter()
      tcp: make sure treq->af_specific is initialized

Felix Kuehling (1):
      drm/amdkfd: Use drm_priv to pass VM from KFD to amdgpu

Filipe Manana (1):
      btrfs: always log symlinks in full mode

Greg Kroah-Hartman (1):
      Linux 5.4.193

Haimin Zhang (1):
      block-map: add __GFP_ZERO flag for alloc_page in function bio_copy_kern

Helge Deller (1):
      parisc: Merge model and model name into one line in /proc/cpuinfo

Ido Schimmel (1):
      selftests: mirror_gre_bridge_1q: Avoid changing PVID while interface is operational

Jakob Koschel (1):
      firewire: remove check of list iterator against head past the loop body

Jan Höppner (2):
      s390/dasd: Fix read for ESE with blksize < 4k
      s390/dasd: Fix read inconsistency for ESE DASD devices

Jiazi Li (1):
      dm: fix mempool NULL pointer race when completing IO

Maciej W. Rozycki (1):
      MIPS: Fix CP0 counter erratum detection for R4k CPUs

Mark Brown (3):
      ASoC: da7219: Fix change notifications for tone generator frequency
      ASoC: wm8958: Fix change notifications for DSP controls
      ASoC: meson: Fix event generation for G12A tohdmi mux

Mike Snitzer (1):
      dm: interlock pending dm_io and dm_wait_for_bios_completion

Minchan Kim (1):
      mm: fix unexpected zeroed page mapping with zram swap

Niels Dossche (1):
      firewire: core: extend card->lock in fw_core_handle_bus_reset

Pali Rohár (2):
      PCI: aardvark: Clear all MSIs at setup
      PCI: aardvark: Fix reading MSI interrupt number

Ricky WU (1):
      mmc: rtsx: add 74 Clocks in power on flow

Sandipan Das (1):
      kvm: x86/cpuid: Only provide CPUID leaf 0xA if host has architectural PMU

Sergey Shtylyov (1):
      smsc911x: allow using IRQ0

Shravya Kumbham (1):
      net: emaclite: Add error handling for of_address_to_resource()

Somnath Kotur (1):
      bnxt_en: Fix possible bnxt_open() failure caused by wrong RFS flag

Stefan Haberland (2):
      s390/dasd: fix data corruption for ESE devices
      s390/dasd: prevent double format of tracks for ESE devices

Takashi Iwai (5):
      ALSA: pcm: Fix races among concurrent hw_params and hw_free calls
      ALSA: pcm: Fix races among concurrent read/write and buffer changes
      ALSA: pcm: Fix races among concurrent prepare and hw_params/hw_free calls
      ALSA: pcm: Fix races among concurrent prealloc proc writes
      ALSA: pcm: Fix potential AB/BA lock with buffer_mutex and mmap_lock

Takashi Sakamoto (1):
      ALSA: fireworks: fix wrong return count shorter than expected by 4 bytes

Thomas Pfaff (1):
      genirq: Synchronize interrupt thread startup

Trond Myklebust (2):
      Revert "SUNRPC: attempt AF_LOCAL connect on setup"
      NFSv4: Don't invalidate inode attributes on delegation return

Vegard Nossum (1):
      ACPICA: Always create namespace nodes using acpi_ns_create_node()

Wanpeng Li (2):
      x86/kvm: Preserve BSP MSR_KVM_POLL_CONTROL across suspend/resume
      KVM: LAPIC: Enable timer posted-interrupt only when mwait/hlt is advertised

Yang Yingliang (2):
      net: ethernet: mediatek: add missing of_node_put() in mtk_sgmii_init()
      net: stmmac: dwmac-sun8i: add missing of_node_put() in sun8i_dwmac_register_mdio_mux()

j.nixdorf@avm.de (1):
      net: ipv6: ensure we call ipv6_mc_down() at most once

