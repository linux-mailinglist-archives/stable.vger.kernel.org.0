Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC474DB037
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 13:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355961AbiCPNBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 09:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355963AbiCPNA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 09:00:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2836C4D62E;
        Wed, 16 Mar 2022 05:59:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6FE3617AB;
        Wed, 16 Mar 2022 12:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B49FC340E9;
        Wed, 16 Mar 2022 12:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647435581;
        bh=dbD++lW9Tr1+BL/UUfYy+iGVAouthSAwSpl2YxzDMA8=;
        h=From:To:Cc:Subject:Date:From;
        b=TlxKC01X+t6CZ79mJ1QYJt1h5RK8Q1eG3mmDCxI3GHu2Ua77/V7AbaPVxiSfBQ6Y4
         l8ru0Ag5EJBLo9pWIji2t1gGPj6RHNWngvT0nqHWFkAJhEs8DZr1QWh0cjtm6eM34i
         l/ZNhJobWN3PbCRTRx2J+WNGiYGU8gfmJgXyy3yI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.235
Date:   Wed, 16 Mar 2022 13:59:36 +0100
Message-Id: <1647435576128162@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.235 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    2 -
 arch/arm/include/asm/spectre.h                   |    6 +++
 arch/arm/kernel/entry-armv.S                     |    4 +-
 arch/riscv/kernel/module.c                       |   21 +++++++++---
 drivers/gpio/gpio-ts4900.c                       |   24 ++++++++++---
 drivers/net/ethernet/cadence/macb_main.c         |   25 +++++++++++++-
 drivers/net/ethernet/freescale/gianfar_ethtool.c |    1 
 drivers/net/ethernet/nxp/lpc_eth.c               |    5 ++
 drivers/net/ethernet/qlogic/qed/qed_sriov.c      |   18 ++++++----
 drivers/net/ethernet/qlogic/qed/qed_vf.c         |    7 ++++
 drivers/net/ethernet/ti/cpts.c                   |    4 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c    |    4 +-
 drivers/net/phy/dp83822.c                        |    2 -
 drivers/net/xen-netback/xenbus.c                 |   13 ++-----
 drivers/nfc/port100.c                            |    2 +
 drivers/staging/gdm724x/gdm_lte.c                |    5 +-
 drivers/virtio/virtio.c                          |   40 ++++++++++++-----------
 fs/btrfs/extent-tree.c                           |    1 
 fs/ext4/resize.c                                 |    5 ++
 include/linux/mlx5/mlx5_ifc.h                    |    4 +-
 include/linux/virtio.h                           |    1 
 include/linux/virtio_config.h                    |    3 +
 kernel/trace/trace.c                             |   10 +++--
 net/ax25/af_ax25.c                               |    7 ++++
 net/core/net-sysfs.c                             |    2 -
 net/sctp/diag.c                                  |    9 +----
 tools/testing/selftests/memfd/memfd_test.c       |    1 
 27 files changed, 157 insertions(+), 69 deletions(-)

Clément Léger (1):
      net: phy: DP83822: clear MISR2 register to disable interrupts

Dan Carpenter (1):
      staging: gdm724x: fix use after free in gdm_lte_rx()

Duoming Zhou (1):
      ax25: Fix NULL pointer dereference in ax25_kill_by_device

Emil Renner Berthing (1):
      riscv: Fix auipc+jalr relocation range checks

Eric Dumazet (1):
      sctp: fix kernel-infoleak for SCTP sockets

Greg Kroah-Hartman (1):
      Linux 4.19.235

Jia-Ju Bai (1):
      net: qlogic: check the return value of dma_alloc_coherent() in qed_vf_hw_prepare()

Jiasheng Jiang (2):
      net: ethernet: ti: cpts: Handle error for clk_enable
      net: ethernet: lpc_eth: Handle error for clk_enable

Josh Triplett (1):
      ext4: add check to prevent attempting to resize an fs with sparse_super2

Marek Marczykowski-Górecki (2):
      Revert "xen-netback: remove 'hotplug-status' once it has served its purpose"
      Revert "xen-netback: Check for hotplug-status existence before watching"

Mark Featherston (1):
      gpio: ts4900: Do not set DAT and OE together

Miaoqian Lin (2):
      ethernet: Fix error handling in xemaclite_of_probe
      gianfar: ethtool: Fix refcount leak in gfar_get_ts_info

Michael S. Tsirkin (2):
      virtio: unexport virtio_finalize_features
      virtio: acknowledge all features before access

Mike Kravetz (1):
      selftests/memfd: clean up mapping in mfd_fail_write

Mohammad Kabat (1):
      net/mlx5: Fix size field in bufferx_reg struct

Pavel Skripkin (1):
      NFC: port100: fix use-after-free in port100_send_complete

Qu Wenruo (1):
      btrfs: unlock newly allocated extent buffer after error

Randy Dunlap (1):
      ARM: Spectre-BHB: provide empty stub for non-config

Robert Hancock (1):
      net: macb: Fix lost RX packet wakeup race in NAPI receive

Russell King (Oracle) (1):
      ARM: fix Thumb2 regression with Spectre BHB

Sven Schnelle (1):
      tracing: Ensure trace buffer is at least 4096 bytes large

Tom Rix (1):
      qed: return status of qed_iov_get_link

suresh kumar (1):
      net-sysfs: add check for netdevice being present to speed_show

