Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A84150824F
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 09:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350256AbiDTHkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 03:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359860AbiDTHkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 03:40:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6149A1AD9C;
        Wed, 20 Apr 2022 00:37:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D917661868;
        Wed, 20 Apr 2022 07:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975F0C385A0;
        Wed, 20 Apr 2022 07:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650440243;
        bh=geazsf0281HIqb0carNfaVlhJB0vkIL00mxJyAYCkDs=;
        h=From:To:Cc:Subject:Date:From;
        b=nv9nEp9n+tGsnyFYTddmmKiL2mTN6TW0HmwE9hBz7Bs4CnhvqlnUvqJR+srQsPfrB
         iUfVOn4C+1EsxWLJ1qJ4a3f1nMKXmQeWzdFFaexDtlHVAS2Chg/aD9T+GCqN1HhNbB
         dIiMk+D0I24Q3DjgXvW+8VfHdMPZWVmBZFNkDcns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.239
Date:   Wed, 20 Apr 2022 09:37:19 +0200
Message-Id: <1650440239205164@kroah.com>
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

I'm announcing the release of the 4.19.239 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/arm/mach-davinci/board-da850-evm.c             |    4 +
 arch/arm64/kernel/alternative.c                     |    6 +-
 drivers/ata/libata-core.c                           |    3 +
 drivers/gpio/gpiolib-acpi.c                         |    4 -
 drivers/gpu/drm/amd/amdgpu/ObjectID.h               |    1 
 drivers/gpu/drm/amd/amdkfd/kfd_events.c             |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c   |    3 -
 drivers/gpu/ipu-v3/ipu-di.c                         |    5 +-
 drivers/hv/ring_buffer.c                            |   11 ++++-
 drivers/i2c/busses/i2c-pasemi.c                     |    6 ++
 drivers/memory/atmel-ebi.c                          |   23 +++++++---
 drivers/net/ethernet/mellanox/mlxsw/i2c.c           |    1 
 drivers/net/ethernet/micrel/Kconfig                 |    1 
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c  |    8 ---
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h  |    4 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c |   13 ++---
 drivers/net/slip/slip.c                             |    2 
 drivers/net/veth.c                                  |    2 
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c            |    2 
 drivers/scsi/mvsas/mv_init.c                        |    1 
 drivers/target/target_core_user.c                   |    3 -
 fs/cifs/link.c                                      |    3 +
 include/net/flow_dissector.h                        |    2 
 kernel/smp.c                                        |    2 
 mm/kmemleak.c                                       |    8 +--
 mm/page_alloc.c                                     |    2 
 net/core/flow_dissector.c                           |    1 
 net/ipv6/ip6_output.c                               |    2 
 net/nfc/nci/core.c                                  |    4 +
 net/sched/cls_flower.c                              |   18 +++++---
 net/sctp/socket.c                                   |    2 
 scripts/gcc-plugins/latent_entropy_plugin.c         |   44 ++++++++++++--------
 sound/core/pcm_misc.c                               |    2 
 sound/pci/hda/patch_realtek.c                       |    1 
 tools/testing/selftests/mqueue/mq_perf_tests.c      |   25 +++++++----
 36 files changed, 147 insertions(+), 76 deletions(-)

Alexey Galakhov (1):
      scsi: mvsas: Add PCI ID of RocketRaid 2640

Athira Rajeev (1):
      testing/selftests/mqueue: Fix mq_perf_tests to free the allocated cpu set

Aurabindo Pillai (1):
      drm/amd: Add USBC connector ID

Christian Lamparter (1):
      ata: libata-core: Disable READ LOG DMA EXT for Samsung 840 EVOs

Dinh Nguyen (1):
      net: ethernet: stmmac: fix altr_tse_pcs function when using a fixed-link

Duoming Zhou (1):
      drivers: net: slip: fix NPD bug in sl_tx_timeout()

Fabio M. De Francesco (1):
      ALSA: pcm: Test for "silence" field in struct "pcm_format_data"

Greg Kroah-Hartman (1):
      Linux 4.19.239

Guillaume Nault (1):
      veth: Ensure eth header is in skb's linear part

Harshit Mogalapalli (1):
      cifs: potential buffer overflow in handling symlinks

Jason A. Donenfeld (1):
      gcc-plugins: latent_entropy: use /dev/urandom

Joey Gouly (1):
      arm64: alternatives: mark patch_alternative() as `noinstr`

Juergen Gross (1):
      mm, page_alloc: fix build_zonerefs_node()

Leo Ruan (1):
      gpu: ipu-v3: Fix dev_dbg frequency output

Lin Ma (1):
      nfc: nci: add flush_workqueue to prevent uaf

Linus Torvalds (1):
      gpiolib: acpi: use correct format characters

Martin Povišer (1):
      i2c: pasemi: Wait for write xfers to finish

Miaoqian Lin (1):
      memory: atmel-ebi: Fix missing of_node_put in atmel_ebi_probe

Michael Kelley (1):
      Drivers: hv: vmbus: Prevent load re-ordering when reading ring buffer

Nadav Amit (1):
      smp: Fix offline cpu check in flush_smp_call_function_queue()

Nathan Chancellor (1):
      ARM: davinci: da850-evm: Avoid NULL pointer dereference

Nicolas Dichtel (1):
      ipv6: fix panic when forwarding a pkt with no in6 dev

Patrick Wang (1):
      mm: kmemleak: take a full lowmem check in kmemleak_*_phys()

Petr Malat (1):
      sctp: Initialize daddr on peeled off socket

QintaoShen (1):
      drm/amdkfd: Check for potential null return of kmalloc_array()

Randy Dunlap (1):
      net: micrel: fix KS8851_MLL Kconfig

Roman Li (1):
      drm/amd/display: Fix allocate_mst_payload assert on resume

Tim Crawford (1):
      ALSA: hda/realtek: Add quirk for Clevo PD50PNT

Tyrel Datwyler (1):
      scsi: ibmvscsis: Increase INITIAL_SRP_LIMIT to 1024

Vadim Pasternak (1):
      mlxsw: i2c: Fix initialization error flow

Vlad Buslov (1):
      net/sched: flower: fix parsing of ethertype following VLAN header

Xiaoguang Wang (1):
      scsi: target: tcmu: Fix possible page UAF

