Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE35E4E4E26
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 09:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbiCWI2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 04:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbiCWI2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 04:28:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F01E6E7BE;
        Wed, 23 Mar 2022 01:26:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF8646146B;
        Wed, 23 Mar 2022 08:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C1BC340E8;
        Wed, 23 Mar 2022 08:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648023999;
        bh=pXRhpT15ifaZqqj9+7NRM8LpEtLAdKZQkYEyv3l9Jpg=;
        h=From:To:Cc:Subject:Date:From;
        b=Z2lip2i4l1tDUXsV9luUvxxGpiv7aWReXaEOlFfv45WNM9ZNvfiix/pcOQoexBQDN
         /dMnYwZdk2sKlj1s2td/9y5QkmRmlIRq8b91seC0KpVp6ELju2gle7He0I4L0pwR2Q
         MIhLYEFHAQtOLTO8TWvjMEckrPH+ogLtQY/YIvvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.308
Date:   Wed, 23 Mar 2022 09:26:34 +0100
Message-Id: <164802399518826@kroah.com>
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

I'm announcing the release of the 4.9.308 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 +-
 arch/arm/boot/dts/rk3288.dtsi            |    2 +-
 arch/mips/kernel/smp.c                   |    6 +++---
 drivers/atm/eni.c                        |    2 ++
 drivers/atm/firestream.c                 |    2 ++
 drivers/input/tablet/aiptek.c            |   10 ++++------
 drivers/net/can/rcar/rcar_canfd.c        |    6 +++---
 drivers/net/ethernet/sfc/mcdi.c          |    2 +-
 drivers/usb/gadget/function/rndis.c      |    1 +
 drivers/usb/gadget/udc/core.c            |    3 ---
 fs/sysfs/file.c                          |    3 +--
 lib/Kconfig                              |    1 -
 net/ipv4/tcp.c                           |   10 ++++++----
 net/packet/af_packet.c                   |   11 ++++++++++-
 net/wireless/nl80211.c                   |    3 ++-
 net/xfrm/xfrm_state.c                    |    8 +++++---
 tools/testing/selftests/vm/userfaultfd.c |    1 +
 17 files changed, 43 insertions(+), 30 deletions(-)

Alan Stern (1):
      usb: gadget: Fix use-after-free bug by not setting udc->dev.driver

Alexander Lobakin (1):
      MIPS: smp: fill in sibling and core maps earlier

Chengming Zhou (1):
      kselftest/vm: fix tests build with old libc

Corentin Labbe (1):
      ARM: dts: rockchip: fix a typo on rk3288 crypto-controller

Dan Carpenter (1):
      usb: gadget: rndis: prevent integer overflow in rndis_set_response()

Eric Dumazet (2):
      tcp: make tcp_read_sock() more robust
      net/packet: fix slab-out-of-bounds access in packet_recvmsg()

Greg Kroah-Hartman (1):
      Linux 4.9.308

Jia-Ju Bai (1):
      atm: firestream: check the return value of ioremap() in fs_init()

Jiasheng Jiang (1):
      atm: eni: Add check for dma_map_single

Julian Braha (1):
      ARM: 9178/1: fix unmet dependency on BITREVERSE for HAVE_ARCH_BITREVERSE

Lad Prabhakar (1):
      can: rcar_canfd: rcar_canfd_channel_probe(): register the CAN device when fully ready

Lucas Wei (1):
      fs: sysfs_emit: Remove PAGE_SIZE alignment check

Niels Dossche (1):
      sfc: extend the locking on mcdi->seqno

Pavel Skripkin (1):
      Input: aiptek - properly check endpoint type

Sreeramya Soratkal (1):
      nl80211: Update bss channel on channel switch for P2P_CLIENT

Yan Yan (1):
      xfrm: Fix xfrm migrate issues when address family changes

