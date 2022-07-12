Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E4A571D9B
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 17:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbiGLPAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 11:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbiGLO7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 10:59:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E271732EDC;
        Tue, 12 Jul 2022 07:59:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 638A561221;
        Tue, 12 Jul 2022 14:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D4CC341C0;
        Tue, 12 Jul 2022 14:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657637954;
        bh=O7NyGZZbbIhIMRI/4NgI00LfXCMllLBGa+1S6dBU/SQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Zm+mHVQYSuOJlUkcP8BrbPq74/8TX19XRi7QQaofi7/59FU4tJsGn9+w09m8b8cKr
         Y9jNsqAaV4ik/X2YRBSPeTxTlyjZ+caWJzbFnf5kJofKIVvY6SChPIag+XJD4RoElt
         pIf/AdCmPKQNDR5h/Oi3i2tXAjE/UWD8sBZTW9U0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.130
Date:   Tue, 12 Jul 2022 16:59:04 +0200
Message-Id: <165763794475103@kroah.com>
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

I'm announcing the release of the 5.10.130 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/dma/allwinner,sun50i-a64-dma.yaml |    2 
 Makefile                                                            |    2 
 arch/arm/boot/dts/at91-sam9x60ek.dts                                |    3 
 arch/arm/boot/dts/at91-sama5d2_icp.dts                              |    6 
 arch/arm/mach-at91/pm.c                                             |    6 
 arch/arm/mach-meson/platsmp.c                                       |    2 
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts                        |   18 
 arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts               |    2 
 arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts                   |    2 
 arch/arm64/boot/dts/qcom/msm8994.dtsi                               |    4 
 arch/powerpc/platforms/powernv/rng.c                                |   16 
 drivers/base/core.c                                                 |    3 
 drivers/base/power/runtime.c                                        |   20 
 drivers/dma/at_xdmac.c                                              |    5 
 drivers/dma/imx-sdma.c                                              |    2 
 drivers/dma/pl330.c                                                 |    2 
 drivers/dma/ti/dma-crossbar.c                                       |    5 
 drivers/i2c/busses/i2c-cadence.c                                    |    1 
 drivers/iommu/intel/dmar.c                                          |    2 
 drivers/misc/cardreader/rtsx_usb.c                                  |   27 -
 drivers/net/can/grcan.c                                             |    1 
 drivers/net/can/usb/gs_usb.c                                        |   23 
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h                         |   25 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c                    |  255 +++++-----
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c                   |    4 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c                    |  119 ++--
 drivers/net/ethernet/ibm/ibmvnic.c                                  |    9 
 drivers/net/ethernet/intel/i40e/i40e.h                              |   16 
 drivers/net/ethernet/intel/i40e/i40e_main.c                         |   73 ++
 drivers/net/ethernet/intel/i40e/i40e_register.h                     |   13 
 drivers/net/ethernet/intel/i40e/i40e_type.h                         |    1 
 drivers/net/ethernet/realtek/r8169_main.c                           |   10 
 drivers/net/usb/usbnet.c                                            |   17 
 drivers/pinctrl/sunxi/pinctrl-sun8i-a83t.c                          |   10 
 drivers/pinctrl/sunxi/pinctrl-sunxi.c                               |    2 
 drivers/video/fbdev/core/fbcon.c                                    |   33 +
 drivers/video/fbdev/core/fbmem.c                                    |   16 
 fs/xfs/xfs_inode.c                                                  |    1 
 include/linux/fbcon.h                                               |    4 
 include/linux/memregion.h                                           |    2 
 include/linux/pm_runtime.h                                          |    5 
 include/linux/rtsx_usb.h                                            |    2 
 include/video/of_display_timing.h                                   |    2 
 kernel/bpf/verifier.c                                               |  113 +---
 lib/idr.c                                                           |    3 
 mm/slub.c                                                           |    4 
 net/can/bcm.c                                                       |   18 
 net/netfilter/nf_tables_api.c                                       |    9 
 net/netfilter/nft_set_pipapo.c                                      |   48 +
 net/rose/rose_route.c                                               |    4 
 net/xdp/xsk_buff_pool.c                                             |    1 
 sound/pci/hda/patch_realtek.c                                       |    1 
 tools/testing/selftests/net/forwarding/lib.sh                       |    6 
 53 files changed, 631 insertions(+), 349 deletions(-)

Andrei Lalaev (1):
      pinctrl: sunxi: sunxi_pconf_set: use correct offset

Claudiu Beznea (2):
      ARM: at91: pm: use proper compatible for sama5d2's rtc
      ARM: at91: pm: use proper compatibles for sam9x60's rtc and rtt

Dan Williams (1):
      memregion: Fix memregion_free() fallback definition

Daniel Borkmann (2):
      bpf: Fix incorrect verifier simulation around jmp32's jeq/jne
      bpf: Fix insufficient bounds propagation from adjust_scalar_min_max_vals

Dmitry Osipenko (1):
      dmaengine: pl330: Fix lockdep warning about non-static key

Duoming Zhou (1):
      net: rose: fix UAF bug caused by rose_t0timer_expiry

Eric Sandeen (1):
      xfs: remove incorrect ASSERT in xfs_rename

Eugen Hristev (2):
      ARM: dts: at91: sam9x60ek: fix eeprom compatible and size
      ARM: dts: at91: sama5d2_icp: fix eeprom compatibles

Greg Kroah-Hartman (1):
      Linux 5.10.130

Guiling Deng (1):
      fbdev: fbmem: Fix logo center image dx issue

Heiner Kallweit (1):
      r8169: fix accessing unset transport header

Helge Deller (3):
      fbmem: Check virtual screen sizes in fb_set_var()
      fbcon: Disallow setting font bigger than screen size
      fbcon: Prevent that screen size is smaller than font size

Hsin-Yi Wang (1):
      video: of_display_timing.h: include errno.h

Ivan Malov (1):
      xsk: Clear page contiguity bit when unmapping pool

Jann Horn (1):
      mm/slub: add missing TID updates on slab deactivation

Jason A. Donenfeld (1):
      powerpc/powernv: delay rng platform device creation until later in boot

Jimmy Assarsson (3):
      can: kvaser_usb: replace run-time checks with struct kvaser_usb_driver_info
      can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression
      can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits

Konrad Dybcio (1):
      arm64: dts: qcom: msm8994: Fix CPU6/7 reg values

Liang He (1):
      can: grcan: grcan_probe(): remove extra of_node_get()

Linus Torvalds (1):
      ida: don't use BUG_ON() for debugging

Lukasz Cieplicki (1):
      i40e: Fix dropped jumbo frames statistics

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

Pablo Neira Ayuso (2):
      netfilter: nft_set_pipapo: release elements in clone from abort path
      netfilter: nf_tables: stricter validation of element data

Peng Fan (3):
      arm64: dts: imx8mp-evk: correct mmc pad settings
      arm64: dts: imx8mp-evk: correct gpio-led pad settings
      arm64: dts: imx8mp-evk: correct I2C3 pad settings

Peter Robinson (1):
      dmaengine: imx-sdma: Allow imx8m for imx7 FW revs

Rafael J. Wysocki (1):
      PM: runtime: Redefine pm_runtime_release_supplier()

Rhett Aultman (1):
      can: gs_usb: gs_usb_open/close(): fix memory leak

Rick Lindsley (1):
      ibmvnic: Properly dispose of all skbs during a failover.

Samuel Holland (2):
      pinctrl: sunxi: a83t: Fix NAND function name for some pins
      dt-bindings: dma: allwinner,sun50i-a64-dma: Fix min/max typo

Satish Nagireddy (1):
      i2c: cadence: Unregister the clk notifier in error path

Sherry Sun (1):
      arm64: dts: imx8mp-evk: correct the uart2 pinctl value

Shuah Khan (3):
      misc: rtsx_usb: fix use of dma mapped buffer for usb bulk transfer
      misc: rtsx_usb: use separate command and response buffers
      misc: rtsx_usb: set return value in rsp_buf alloc err path

Stephan Gerhold (1):
      arm64: dts: qcom: msm8992-*: Fix vdd_lvs1_2-supply typo

Tim Crawford (1):
      ALSA: hda/realtek: Add quirk for Clevo L140PU

Vladimir Oltean (3):
      selftests: forwarding: fix flood_unicast_test when h2 supports IFF_UNICAST_FLT
      selftests: forwarding: fix learning_test when h1 supports IFF_UNICAST_FLT
      selftests: forwarding: fix error message in learning_test

Yian Chen (1):
      iommu/vt-d: Fix PCI bus rescan device hot add

