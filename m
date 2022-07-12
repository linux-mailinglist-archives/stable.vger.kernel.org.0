Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E73571D88
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 16:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiGLO7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 10:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbiGLO7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 10:59:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD09011453;
        Tue, 12 Jul 2022 07:59:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 435BF60C70;
        Tue, 12 Jul 2022 14:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A879C341C0;
        Tue, 12 Jul 2022 14:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657637948;
        bh=1fdpy7J8Q7P8f1d0GgzVpevYZ0LFY3vAm0/xtFYhVcw=;
        h=From:To:Cc:Subject:Date:From;
        b=T5r/pParr+cVFCRYw+G2jBpzAxigzLQqAp4ejB9W6g+LJP434O4NWcCNp3XNTjzTF
         Xt4jCTyPAcW3sNVECyaPz/CfE1cKYc6kJZFeT5Cj5CUAUotGO1hzola2Q5diluu7z8
         ubrAiQTp/bYmTQ9kL0xWp0eSCdzKsdgEIphhvQ7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.205
Date:   Tue, 12 Jul 2022 16:58:58 +0200
Message-Id: <1657637939113252@kroah.com>
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

I'm announcing the release of the 5.4.205 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/dma/allwinner,sun50i-a64-dma.yaml |    2 
 Makefile                                                            |    2 
 arch/arm/mach-at91/pm.c                                             |    6 
 arch/arm/mach-meson/platsmp.c                                       |    2 
 arch/powerpc/platforms/powernv/rng.c                                |   16 
 drivers/dma/at_xdmac.c                                              |    5 
 drivers/dma/imx-sdma.c                                              |    2 
 drivers/dma/pl330.c                                                 |    2 
 drivers/dma/ti/dma-crossbar.c                                       |    5 
 drivers/i2c/busses/i2c-cadence.c                                    |    1 
 drivers/iommu/dmar.c                                                |    2 
 drivers/misc/cardreader/rtsx_usb.c                                  |   27 -
 drivers/net/can/grcan.c                                             |    1 
 drivers/net/can/usb/gs_usb.c                                        |   23 
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h                         |   25 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c                    |  255 +++++-----
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c                   |    4 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c                    |  119 ++--
 drivers/net/ethernet/ibm/ibmvnic.c                                  |    9 
 drivers/net/usb/usbnet.c                                            |   17 
 drivers/pinctrl/sunxi/pinctrl-sun8i-a83t.c                          |   10 
 drivers/pinctrl/sunxi/pinctrl-sunxi.c                               |    2 
 drivers/video/fbdev/core/fbcon.c                                    |   33 +
 drivers/video/fbdev/core/fbmem.c                                    |   16 
 fs/xfs/xfs_inode.c                                                  |    1 
 include/linux/fbcon.h                                               |    4 
 include/linux/rtsx_usb.h                                            |    2 
 include/net/esp.h                                                   |    2 
 include/video/of_display_timing.h                                   |    2 
 lib/idr.c                                                           |    3 
 mm/slub.c                                                           |    4 
 net/can/bcm.c                                                       |   18 
 net/ipv4/esp4.c                                                     |    5 
 net/ipv6/esp6.c                                                     |    5 
 net/rose/rose_route.c                                               |    4 
 tools/testing/selftests/net/forwarding/lib.sh                       |    6 
 36 files changed, 407 insertions(+), 235 deletions(-)

Andrei Lalaev (1):
      pinctrl: sunxi: sunxi_pconf_set: use correct offset

Claudiu Beznea (2):
      ARM: at91: pm: use proper compatible for sama5d2's rtc
      ARM: at91: pm: use proper compatibles for sam9x60's rtc and rtt

Dmitry Osipenko (1):
      dmaengine: pl330: Fix lockdep warning about non-static key

Duoming Zhou (1):
      net: rose: fix UAF bug caused by rose_t0timer_expiry

Eric Sandeen (1):
      xfs: remove incorrect ASSERT in xfs_rename

Greg Kroah-Hartman (1):
      Linux 5.4.205

Guiling Deng (1):
      fbdev: fbmem: Fix logo center image dx issue

Helge Deller (3):
      fbmem: Check virtual screen sizes in fb_set_var()
      fbcon: Disallow setting font bigger than screen size
      fbcon: Prevent that screen size is smaller than font size

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

Peter Robinson (1):
      dmaengine: imx-sdma: Allow imx8m for imx7 FW revs

Rhett Aultman (1):
      can: gs_usb: gs_usb_open/close(): fix memory leak

Rick Lindsley (1):
      ibmvnic: Properly dispose of all skbs during a failover.

Sabrina Dubroca (1):
      esp: limit skb_page_frag_refill use to a single page

Samuel Holland (2):
      pinctrl: sunxi: a83t: Fix NAND function name for some pins
      dt-bindings: dma: allwinner,sun50i-a64-dma: Fix min/max typo

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

