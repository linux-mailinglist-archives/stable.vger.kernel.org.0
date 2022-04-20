Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74911508255
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 09:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376263AbiDTHk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 03:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376270AbiDTHkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 03:40:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919AF1C126;
        Wed, 20 Apr 2022 00:37:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A8E6B81D57;
        Wed, 20 Apr 2022 07:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84342C385A9;
        Wed, 20 Apr 2022 07:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650440251;
        bh=nlma1+ykDHIlM+FgM9O7Sm8t8eLqtnf86DumF6AI3Uw=;
        h=From:To:Cc:Subject:Date:From;
        b=sYjD63MMOoCtKOQdF4hsVZPCYTRP3uiWjo4uzVLD68iJv6F2ycckjtoTfn7XpYIlK
         s+dxMKotCU4/mW7Pme9hKlRYP9+gRfJR7r7ZmJrKso3+9k3txB9FOsJM7LgtbjWP2j
         4iv3Pa0nvVAO/20l0escydqJCI9i7Wwt4EgqyFYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.190
Date:   Wed, 20 Apr 2022 09:37:24 +0200
Message-Id: <165044024478193@kroah.com>
X-Mailer: git-send-email 2.35.3
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

I'm announcing the release of the 5.4.190 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                      |    2 
 arch/arm/mach-davinci/board-da850-evm.c                       |    4 
 arch/arm64/kernel/alternative.c                               |    6 -
 arch/powerpc/include/asm/page.h                               |    6 +
 drivers/ata/libata-core.c                                     |    3 
 drivers/gpio/gpiolib-acpi.c                                   |    4 
 drivers/gpu/drm/amd/amdgpu/ObjectID.h                         |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                       |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_device.c                       |   11 --
 drivers/gpu/drm/amd/amdkfd/kfd_events.c                       |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c             |    3 
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c             |    4 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c     |   14 ++-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c            |   14 ++-
 drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c |    5 -
 drivers/gpu/drm/msm/dsi/dsi_manager.c                         |    2 
 drivers/gpu/ipu-v3/ipu-di.c                                   |    5 -
 drivers/hv/ring_buffer.c                                      |   11 ++
 drivers/i2c/busses/i2c-pasemi.c                               |    6 +
 drivers/md/dm-integrity.c                                     |    7 +
 drivers/memory/atmel-ebi.c                                    |   23 +++--
 drivers/net/ethernet/mellanox/mlxsw/i2c.c                     |    1 
 drivers/net/ethernet/micrel/Kconfig                           |    1 
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c            |    8 -
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h            |    4 
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c           |   13 +-
 drivers/net/slip/slip.c                                       |    2 
 drivers/net/usb/aqc111.c                                      |    9 +-
 drivers/net/veth.c                                            |    2 
 drivers/net/wireless/ath/ath9k/main.c                         |    2 
 drivers/net/wireless/ath/ath9k/xmit.c                         |   33 ++++---
 drivers/perf/fsl_imx8_ddr_perf.c                              |    2 
 drivers/regulator/wm8994-regulator.c                          |   42 ++++++++-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c                      |    2 
 drivers/scsi/megaraid/megaraid_sas.h                          |    3 
 drivers/scsi/megaraid/megaraid_sas_base.c                     |    7 +
 drivers/scsi/mvsas/mv_init.c                                  |    1 
 drivers/target/target_core_user.c                             |    3 
 fs/btrfs/block-group.c                                        |    4 
 fs/btrfs/volumes.c                                            |    2 
 fs/cifs/link.c                                                |    3 
 include/asm-generic/tlb.h                                     |   10 +-
 include/net/ax25.h                                            |   12 ++
 include/net/flow_dissector.h                                  |    2 
 kernel/dma/direct.c                                           |    3 
 kernel/irq/affinity.c                                         |    5 -
 kernel/smp.c                                                  |    2 
 kernel/time/tick-sched.c                                      |    2 
 mm/kmemleak.c                                                 |    8 -
 mm/page_alloc.c                                               |    2 
 net/ax25/af_ax25.c                                            |   38 ++++++--
 net/ax25/ax25_dev.c                                           |   28 +++++-
 net/ax25/ax25_route.c                                         |   13 ++
 net/ax25/ax25_subr.c                                          |   20 +++-
 net/core/flow_dissector.c                                     |    1 
 net/ipv6/ip6_output.c                                         |    2 
 net/nfc/nci/core.c                                            |    4 
 net/sched/cls_api.c                                           |    2 
 net/sched/cls_flower.c                                        |   18 ++--
 net/sched/sch_taprio.c                                        |    3 
 net/sctp/socket.c                                             |    2 
 net/smc/smc_pnet.c                                            |    5 -
 net/wireless/scan.c                                           |    2 
 scripts/gcc-plugins/latent_entropy_plugin.c                   |   44 ++++++----
 sound/core/pcm_misc.c                                         |    2 
 sound/pci/hda/patch_realtek.c                                 |    1 
 tools/testing/selftests/mqueue/mq_perf_tests.c                |   25 +++--
 67 files changed, 377 insertions(+), 158 deletions(-)

Alexey Galakhov (1):
      scsi: mvsas: Add PCI ID of RocketRaid 2640

Athira Rajeev (1):
      testing/selftests/mqueue: Fix mq_perf_tests to free the allocated cpu set

Aurabindo Pillai (1):
      drm/amd: Add USBC connector ID

Benedikt Spranger (1):
      net/sched: taprio: Check if socket flags are valid

Borislav Petkov (1):
      perf/imx_ddr: Fix undefined behavior due to shift overflowing the constant

Chandrakanth patil (1):
      scsi: megaraid_sas: Target with invalid LUN ID is deleted during scan

Chao Gao (1):
      dma-direct: avoid redundant memory sync for swiotlb

Charlene Liu (1):
      drm/amd/display: fix audio format not updated after edid updated

Christian Lamparter (1):
      ata: libata-core: Disable READ LOG DMA EXT for Samsung 840 EVOs

Dinh Nguyen (1):
      net: ethernet: stmmac: fix altr_tse_pcs function when using a fixed-link

Duoming Zhou (9):
      drivers: net: slip: fix NPD bug in sl_tx_timeout()
      ax25: add refcount in ax25_dev to avoid UAF bugs
      ax25: fix reference count leaks of ax25_dev
      ax25: fix UAF bugs of net_device caused by rebinding operation
      ax25: Fix refcount leaks caused by ax25_cb_del()
      ax25: fix UAF bug in ax25_send_control()
      ax25: fix NPD bug in ax25_disconnect
      ax25: Fix NULL pointer dereferences in ax25 timers
      ax25: Fix UAF bugs in ax25 timers

Fabio M. De Francesco (1):
      ALSA: pcm: Test for "silence" field in struct "pcm_format_data"

Greg Kroah-Hartman (1):
      Linux 5.4.190

Guillaume Nault (1):
      veth: Ensure eth header is in skb's linear part

Harshit Mogalapalli (1):
      cifs: potential buffer overflow in handling symlinks

Jason A. Donenfeld (1):
      gcc-plugins: latent_entropy: use /dev/urandom

Joey Gouly (1):
      arm64: alternatives: mark patch_alternative() as `noinstr`

Jonathan Bakker (1):
      regulator: wm8994: Add an off-on delay for WM8994 variant

Juergen Gross (1):
      mm, page_alloc: fix build_zonerefs_node()

Karsten Graul (1):
      net/smc: Fix NULL pointer dereference in smc_pnet_find_ib()

Kefeng Wang (1):
      powerpc: Fix virt_addr_valid() for 64-bit Book3E & 32-bit

Leo (Hanghong) Ma (1):
      drm/amd/display: Update VTEM Infopacket definition

Leo Ruan (1):
      gpu: ipu-v3: Fix dev_dbg frequency output

Lin Ma (1):
      nfc: nci: add flush_workqueue to prevent uaf

Linus Torvalds (1):
      gpiolib: acpi: use correct format characters

Marcelo Ricardo Leitner (1):
      net/sched: fix initialization order when updating chain 0 head

Marcin Kozlowski (1):
      net: usb: aqc111: Fix out-of-bounds accesses in RX fixup

Martin Povišer (1):
      i2c: pasemi: Wait for write xfers to finish

Melissa Wen (1):
      drm/amd/display: don't ignore alpha property on pre-multiplied mode

Miaoqian Lin (1):
      memory: atmel-ebi: Fix missing of_node_put in atmel_ebi_probe

Michael Kelley (1):
      Drivers: hv: vmbus: Prevent load re-ordering when reading ring buffer

Mikulas Patocka (1):
      dm integrity: fix memory corruption when tag_size is less than digest size

Nadav Amit (1):
      smp: Fix offline cpu check in flush_smp_call_function_queue()

Naohiro Aota (1):
      btrfs: mark resumed async balance as writing

Nathan Chancellor (2):
      btrfs: remove unused variable in btrfs_{start,write}_dirty_block_groups()
      ARM: davinci: da850-evm: Avoid NULL pointer dereference

Nicolas Dichtel (1):
      ipv6: fix panic when forwarding a pkt with no in6 dev

Patrick Wang (1):
      mm: kmemleak: take a full lowmem check in kmemleak_*_phys()

Paul Gortmaker (1):
      tick/nohz: Use WARN_ON_ONCE() to prevent console saturation

Petr Malat (1):
      sctp: Initialize daddr on peeled off socket

QintaoShen (1):
      drm/amdkfd: Check for potential null return of kmalloc_array()

Rameshkumar Sundaram (1):
      cfg80211: hold bss_lock while updating nontrans_list

Randy Dunlap (1):
      net: micrel: fix KS8851_MLL Kconfig

Rei Yamamoto (1):
      genirq/affinity: Consider that CPUs on nodes can be unbalanced

Roman Li (1):
      drm/amd/display: Fix allocate_mst_payload assert on resume

Stephen Boyd (1):
      drm/msm/dsi: Use connector directly in msm_dsi_manager_connector_init()

Steve Capper (1):
      tlb: hugetlb: Add more sizes to tlb_remove_huge_tlb_entry

Tim Crawford (1):
      ALSA: hda/realtek: Add quirk for Clevo PD50PNT

Toke Høiland-Jørgensen (2):
      ath9k: Properly clear TX status area before reporting to mac80211
      ath9k: Fix usage of driver-private space in tx_info

Tushar Patel (1):
      drm/amdkfd: Fix Incorrect VMIDs passed to HWS

Tyrel Datwyler (1):
      scsi: ibmvscsis: Increase INITIAL_SRP_LIMIT to 1024

Vadim Pasternak (1):
      mlxsw: i2c: Fix initialization error flow

Vlad Buslov (1):
      net/sched: flower: fix parsing of ethertype following VLAN header

Xiaoguang Wang (1):
      scsi: target: tcmu: Fix possible page UAF

