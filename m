Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700E3571D82
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 16:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbiGLO7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 10:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbiGLO7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 10:59:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4C131936;
        Tue, 12 Jul 2022 07:59:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67DC7B819AC;
        Tue, 12 Jul 2022 14:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7C2C3411C;
        Tue, 12 Jul 2022 14:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657637944;
        bh=ldkrw/LwK1DTHKp7u2Zp2D/raa4Vtjs8SHf6Dtm+rZ0=;
        h=From:To:Cc:Subject:Date:From;
        b=Ek8eoI3qAQbOpHw6WbtaFrfeCpBKwqqaGNnKuxDJ9x5ArBFhwxJwTFEgAlpT1hIh6
         Xpza7ZFRJeSCWyQ0LEMJSLMcgvhzAYp5sESCx5HFvdoz8kEHwDIT+D/a5BRbuc0a8v
         LiyexAUuDd/2nwrHoFCub8h9oW0hcbuVfaS/tU9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.252
Date:   Tue, 12 Jul 2022 16:58:50 +0200
Message-Id: <16576379311388@kroah.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
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

I'm announcing the release of the 4.19.252 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/arm/mach-at91/pm.c                           |    2 
 arch/arm/mach-meson/platsmp.c                     |    2 
 arch/powerpc/platforms/powernv/rng.c              |   16 -
 drivers/dma/at_xdmac.c                            |    5 
 drivers/dma/pl330.c                               |    2 
 drivers/dma/ti/dma-crossbar.c                     |    5 
 drivers/i2c/busses/i2c-cadence.c                  |    1 
 drivers/iommu/dmar.c                              |    2 
 drivers/misc/cardreader/rtsx_usb.c                |   27 +-
 drivers/net/can/grcan.c                           |    1 
 drivers/net/can/usb/gs_usb.c                      |   23 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h       |   25 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c  |  255 ++++++++++++----------
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c |    4 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  |  119 +++++-----
 drivers/net/ethernet/ibm/ibmvnic.c                |    9 
 drivers/net/usb/usbnet.c                          |   17 +
 drivers/pinctrl/sunxi/pinctrl-sun8i-a83t.c        |   10 
 drivers/video/fbdev/core/fbcon.c                  |    5 
 fs/xfs/xfs_inode.c                                |    1 
 include/linux/rtsx_usb.h                          |    2 
 include/net/esp.h                                 |    2 
 include/video/of_display_timing.h                 |    2 
 lib/idr.c                                         |    4 
 mm/slub.c                                         |    4 
 net/can/bcm.c                                     |   18 +
 net/ipv4/esp4.c                                   |    5 
 net/ipv6/esp6.c                                   |    5 
 net/rose/rose_route.c                             |    4 
 tools/testing/selftests/net/forwarding/lib.sh     |    6 
 31 files changed, 356 insertions(+), 229 deletions(-)

Claudiu Beznea (1):
      ARM: at91: pm: use proper compatible for sama5d2's rtc

Dmitry Osipenko (1):
      dmaengine: pl330: Fix lockdep warning about non-static key

Duoming Zhou (1):
      net: rose: fix UAF bug caused by rose_t0timer_expiry

Eric Sandeen (1):
      xfs: remove incorrect ASSERT in xfs_rename

Greg Kroah-Hartman (1):
      Linux 4.19.252

Helge Deller (1):
      fbcon: Disallow setting font bigger than screen size

Hsin-Yi Wang (1):
      video: of_display_timing.h: include errno.h

Jann Horn (1):
      mm/slub: add missing TID updates on slab deactivation

Jason A. Donenfeld (1):
      powerpc/powernv: delay rng platform device creation until later in boot

Jimmy Assarsson (3):
      can: kvaser_usb: replace run-time checks with struct kvaser_usb_driver_info
      can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression
      can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits

Liang He (1):
      can: grcan: grcan_probe(): remove extra of_node_get()

Linus Torvalds (1):
      ida: don't use BUG_ON() for debugging

Miaoqian Lin (3):
      ARM: meson: Fix refcount leak in meson_smp_prepare_cpus
      dmaengine: ti: Fix refcount leak in ti_dra7_xbar_route_allocate
      dmaengine: ti: Add missing put_device in ti_dra7_xbar_route_allocate

Michael Walle (1):
      dmaengine: at_xdma: handle errors of at_xdmac_alloc_desc() correctly

Oliver Hartkopp (1):
      can: bcm: use call_rcu() instead of costly synchronize_rcu()

Oliver Neukum (1):
      usbnet: fix memory leak in error case

Rhett Aultman (1):
      can: gs_usb: gs_usb_open/close(): fix memory leak

Rick Lindsley (1):
      ibmvnic: Properly dispose of all skbs during a failover.

Sabrina Dubroca (1):
      esp: limit skb_page_frag_refill use to a single page

Samuel Holland (1):
      pinctrl: sunxi: a83t: Fix NAND function name for some pins

Satish Nagireddy (1):
      i2c: cadence: Unregister the clk notifier in error path

Shuah Khan (3):
      misc: rtsx_usb: fix use of dma mapped buffer for usb bulk transfer
      misc: rtsx_usb: use separate command and response buffers
      misc: rtsx_usb: set return value in rsp_buf alloc err path

Vladimir Oltean (3):
      selftests: forwarding: fix flood_unicast_test when h2 supports IFF_UNICAST_FLT
      selftests: forwarding: fix learning_test when h1 supports IFF_UNICAST_FLT
      selftests: forwarding: fix error message in learning_test

Yian Chen (1):
      iommu/vt-d: Fix PCI bus rescan device hot add

