Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5D64E4E40
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 09:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242773AbiCWIab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 04:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242753AbiCWI32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 04:29:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC9CC1C;
        Wed, 23 Mar 2022 01:27:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15036B81E42;
        Wed, 23 Mar 2022 08:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80099C340E8;
        Wed, 23 Mar 2022 08:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648024075;
        bh=3tJXgxMDe9g+6QodXWhBcwsCeXZ99HXzDStAefqhMyY=;
        h=From:To:Cc:Subject:Date:From;
        b=rlkN+drwLjtQSgx3aXBYa1UcfQvt0NB3HOZfLYOCjB5G2b/4mp9XbbDfYladhtgEI
         JzrGvCggevyqsdif5bZqeh5x3Ur/hghvKKrigL9CSfKLAlnZJcESSyx5rwMP+dwPeF
         N7l8A1TKzuEpV9rpkcSqOWtgs++AzmE6NA847wH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.16.17
Date:   Wed, 23 Mar 2022 09:27:38 +0100
Message-Id: <1648024059176135@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.16.17 kernel.

All users of the 5.16 kernel series must upgrade.

The updated 5.16.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.16.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    2 -
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi   |   24 +++++++-------
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi   |   24 +++++++-------
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi   |   24 +++++++-------
 arch/arm64/include/asm/vectors.h                 |    4 +-
 arch/arm64/kernel/cpu_errata.c                   |    1 
 block/blk-core.c                                 |    4 ++
 drivers/atm/eni.c                                |    2 +
 drivers/crypto/qcom-rng.c                        |   17 +++++-----
 drivers/firmware/efi/apple-properties.c          |    2 -
 drivers/firmware/efi/efi.c                       |    2 -
 drivers/gpu/drm/bridge/Kconfig                   |    2 -
 drivers/gpu/drm/imx/parallel-display.c           |    8 ----
 drivers/gpu/drm/mgag200/mgag200_pll.c            |    6 +--
 drivers/gpu/drm/panel/Kconfig                    |    1 
 drivers/gpu/drm/panel/panel-simple.c             |    2 -
 drivers/input/tablet/aiptek.c                    |   10 ++---
 drivers/net/ethernet/atheros/alx/main.c          |    5 ++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h      |    2 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c  |   28 ++++++++++------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |   15 +-------
 drivers/net/ethernet/broadcom/genet/bcmgenet.c   |    6 ++-
 drivers/net/ethernet/intel/iavf/iavf_main.c      |   15 ++++++++
 drivers/net/ethernet/intel/ice/ice_main.c        |    5 +-
 drivers/net/ethernet/mscc/ocelot_flower.c        |   16 ++++++++-
 drivers/net/hyperv/netvsc_drv.c                  |    3 +
 drivers/net/phy/marvell.c                        |    8 ++--
 drivers/net/phy/mscc/mscc_main.c                 |    3 +
 drivers/net/wireless/ath/ath10k/wmi.c            |   27 ---------------
 drivers/nvme/target/configfs.c                   |   39 -----------------------
 drivers/nvme/target/core.c                       |    3 -
 drivers/scsi/mpt3sas/mpt3sas_base.c              |    5 +-
 drivers/usb/class/usbtmc.c                       |   13 +++++--
 drivers/usb/gadget/function/rndis.c              |    1 
 drivers/usb/gadget/udc/core.c                    |    3 -
 drivers/vhost/vsock.c                            |    3 +
 fs/btrfs/block-group.c                           |   26 ++++++++++++++-
 fs/btrfs/ctree.h                                 |    7 ++++
 fs/btrfs/tree-log.c                              |   23 +++++++++++++
 fs/ocfs2/super.c                                 |   22 ++++++------
 include/linux/if_arp.h                           |    1 
 include/net/af_vsock.h                           |    3 +
 mm/swap_state.c                                  |    2 -
 net/dsa/dsa2.c                                   |    1 
 net/ipv6/esp6.c                                  |    3 -
 net/packet/af_packet.c                           |   11 +++++-
 net/vmw_vsock/af_vsock.c                         |    9 ++++-
 net/vmw_vsock/virtio_transport.c                 |    7 ++--
 net/vmw_vsock/vmci_transport.c                   |    5 ++
 tools/perf/util/symbol.c                         |    2 -
 50 files changed, 252 insertions(+), 205 deletions(-)

Alan Stern (2):
      usb: gadget: Fix use-after-free bug by not setting udc->dev.driver
      usb: usbtmc: Fix bug in pipe direction for control transfers

Arnd Bergmann (2):
      arm64: fix clang warning about TRAMP_VALIAS
      arm64: errata: avoid duplicate field initializer

Brian Masney (1):
      crypto: qcom-rng - ensure buffer for generate is completely filled

Christoph Niedermaier (1):
      drm/imx: parallel-display: Remove bus flags check in imx_pd_bridge_atomic_check()

Dan Carpenter (1):
      usb: gadget: rndis: prevent integer overflow in rndis_set_response()

Doug Berger (1):
      net: bcmgenet: skip invalid partial checksums

Eric Dumazet (1):
      net/packet: fix slab-out-of-bounds access in packet_recvmsg()

Filipe Manana (1):
      btrfs: skip reserved bytes warning on unmount after log cleanup failure

Greg Kroah-Hartman (1):
      Linux 5.16.17

Guo Ziliang (1):
      mm: swap: get rid of livelock in swapin readahead

Hannes Reinecke (1):
      nvmet: revert "nvmet: make discovery NQN configurable"

Ivan Vecera (1):
      iavf: Fix hang during reboot/shutdown

Jiasheng Jiang (2):
      atm: eni: Add check for dma_map_single
      hv_netvsc: Add check for kvmalloc_array

Jiyong Park (1):
      vsock: each transport cycles only on its own sockets

Jocelyn Falempe (1):
      drm/mgag200: Fix PLL setup for g200wb and g200ew

Joseph Qi (1):
      ocfs2: fix crash when initialize filecheck kobj fails

Juerg Haefliger (1):
      net: phy: mscc: Add MODULE_FIRMWARE macros

Kalle Valo (1):
      Revert "ath10k: drop beacon and probe response which leak from other channel"

Kurt Cancemi (1):
      net: phy: marvell: Fix invalid comparison in the resume and suspend functions

Maciej Fijalkowski (1):
      ice: fix NULL pointer dereference in ice_update_vsi_tx_ring_stats()

Manish Chopra (1):
      bnx2x: fix built-in kernel driver load failure

Marek Vasut (1):
      drm/panel: simple: Fix Innolux G070Y2-L01 BPP settings

Matt Lupfer (1):
      scsi: mpt3sas: Page fault in reply q processing

Miaoqian Lin (1):
      net: dsa: Add missing of_node_put() in dsa_port_parse_of

Michael Petlan (1):
      perf symbols: Fix symbol size calculation condition

Ming Lei (1):
      block: release rq qos structures for queue without disk

Nicolas Dichtel (1):
      net: handle ARPHRD_PIMREG in dev_is_mac_header_xmit()

Niels Dossche (1):
      alx: acquire mutex for alx_reinit in alx_change_mtu

Pavel Skripkin (1):
      Input: aiptek - properly check endpoint type

Przemyslaw Patynowski (1):
      iavf: Fix double free in iavf_reset_task

Randy Dunlap (1):
      efi: fix return value of __setup handlers

Sabrina Dubroca (1):
      esp6: fix check on ipv6_skip_exthdr's return value

Thomas Zimmermann (1):
      drm: Don't make DRM_PANEL_BRIDGE dependent on DRM_KMS_HELPERS

Vladimir Oltean (2):
      net: mscc: ocelot: fix backwards compatibility with single-chain tc-flower offload
      Revert "arm64: dts: freescale: Fix 'interrupt-map' parent address cells"

