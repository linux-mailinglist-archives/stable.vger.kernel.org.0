Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCC94DAF75
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 13:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348955AbiCPMQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 08:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbiCPMQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 08:16:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10262366B4;
        Wed, 16 Mar 2022 05:14:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9EED61718;
        Wed, 16 Mar 2022 12:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FCEC340E9;
        Wed, 16 Mar 2022 12:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647432889;
        bh=xfe6fawAHAkl5Uzn0mnpGStrj8UaKDT6ybQ9RW4PpXY=;
        h=From:To:Cc:Subject:Date:From;
        b=AK66XecNk8uCGeV02/+6nLmTyTycncrVLj5LH9NcuzJiIP28H8pJAG8dXO2HQIMHS
         lCf7k2nBqm+5ajWzkde9WDWlr5OUujareCcwsEwDtSFbRODUqZys8iPHt4ijv7Gt2l
         4spI0AJRDddSPCWtdRtmSo7OpkeamNnizUINHYco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.307
Date:   Wed, 16 Mar 2022 13:14:44 +0100
Message-Id: <1647432884267@kroah.com>
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

I'm announcing the release of the 4.9.307 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                      |    2 +-
 arch/arm/include/asm/spectre.h                |    6 ++++++
 arch/arm/kernel/entry-armv.S                  |    4 ++--
 drivers/gpio/gpio-ts4900.c                    |   24 +++++++++++++++++++-----
 drivers/net/ethernet/nxp/lpc_eth.c            |    5 ++++-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c   |   18 +++++++++++-------
 drivers/net/ethernet/qlogic/qed/qed_vf.c      |    7 +++++++
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |    4 +++-
 drivers/net/xen-netback/xenbus.c              |   12 ++++--------
 drivers/nfc/port100.c                         |    2 ++
 drivers/staging/gdm724x/gdm_lte.c             |    5 +++--
 fs/btrfs/extent-tree.c                        |    1 +
 include/linux/mlx5/mlx5_ifc.h                 |    4 ++--
 kernel/trace/trace.c                          |   10 ++++++----
 net/ax25/af_ax25.c                            |    7 +++++++
 net/batman-adv/hard-interface.c               |   13 ++++++++-----
 net/core/net-sysfs.c                          |    2 +-
 net/sctp/sctp_diag.c                          |    9 +++------
 tools/testing/selftests/memfd/memfd_test.c    |    1 +
 19 files changed, 91 insertions(+), 45 deletions(-)

Dan Carpenter (1):
      staging: gdm724x: fix use after free in gdm_lte_rx()

Duoming Zhou (1):
      ax25: Fix NULL pointer dereference in ax25_kill_by_device

Eric Dumazet (1):
      sctp: fix kernel-infoleak for SCTP sockets

Greg Kroah-Hartman (1):
      Linux 4.9.307

Jia-Ju Bai (1):
      net: qlogic: check the return value of dma_alloc_coherent() in qed_vf_hw_prepare()

Jiasheng Jiang (1):
      net: ethernet: lpc_eth: Handle error for clk_enable

Marek Marczykowski-Górecki (1):
      Revert "xen-netback: Check for hotplug-status existence before watching"

Mark Featherston (1):
      gpio: ts4900: Do not set DAT and OE together

Miaoqian Lin (1):
      ethernet: Fix error handling in xemaclite_of_probe

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

Russell King (Oracle) (1):
      ARM: fix Thumb2 regression with Spectre BHB

Sven Eckelmann (2):
      batman-adv: Request iflink once in batadv-on-batadv check
      batman-adv: Don't expect inter-netns unique iflink indices

Sven Schnelle (1):
      tracing: Ensure trace buffer is at least 4096 bytes large

Tom Rix (1):
      qed: return status of qed_iov_get_link

suresh kumar (1):
      net-sysfs: add check for netdevice being present to speed_show

