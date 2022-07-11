Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B4056FAA4
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbiGKJUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbiGKJTj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:19:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C5A51A3A;
        Mon, 11 Jul 2022 02:12:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B70E5B80DB7;
        Mon, 11 Jul 2022 09:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB781C34115;
        Mon, 11 Jul 2022 09:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530737;
        bh=Vl9rrMyQGcFIXKJurtfkJGdUH3VLKKTBeINR3dYkIok=;
        h=From:To:Cc:Subject:Date:From;
        b=CTbOtLg5sONo+k1vAdzG7iyt7xwJMmtP2PhHsbNZczitQGKP1Kv7vsnt/jsmLu3En
         xLUAbDR4ju5XzyEsoZrNJBfmI0zbrCB2Iz2xmpzC8Xt8Ry0E18k98tc2q2pg7Y2vyY
         Bm/wKS0g6LR0a+9H6J3ew3/zw0ISuTnmGiSlu9Ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/55] 5.10.130-rc1 review
Date:   Mon, 11 Jul 2022 11:06:48 +0200
Message-Id: <20220711090541.764895984@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.130-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.130-rc1
X-KernelTest-Deadline: 2022-07-13T09:05+00:00
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

This is the start of the stable review cycle for the 5.10.130 release.
There are 55 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.130-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.130-rc1

Miaoqian Lin <linmq006@gmail.com>
    dmaengine: ti: Add missing put_device in ti_dra7_xbar_route_allocate

Miaoqian Lin <linmq006@gmail.com>
    dmaengine: ti: Fix refcount leak in ti_dra7_xbar_route_allocate

Michael Walle <michael@walle.cc>
    dmaengine: at_xdma: handle errors of at_xdmac_alloc_desc() correctly

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    dmaengine: pl330: Fix lockdep warning about non-static key

Linus Torvalds <torvalds@linux-foundation.org>
    ida: don't use BUG_ON() for debugging

Samuel Holland <samuel@sholland.org>
    dt-bindings: dma: allwinner,sun50i-a64-dma: Fix min/max typo

Shuah Khan <skhan@linuxfoundation.org>
    misc: rtsx_usb: set return value in rsp_buf alloc err path

Shuah Khan <skhan@linuxfoundation.org>
    misc: rtsx_usb: use separate command and response buffers

Shuah Khan <skhan@linuxfoundation.org>
    misc: rtsx_usb: fix use of dma mapped buffer for usb bulk transfer

Peter Robinson <pbrobinson@gmail.com>
    dmaengine: imx-sdma: Allow imx8m for imx7 FW revs

Satish Nagireddy <satish.nagireddy@getcruise.com>
    i2c: cadence: Unregister the clk notifier in error path

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix accessing unset transport header

Vladimir Oltean <vladimir.oltean@nxp.com>
    selftests: forwarding: fix error message in learning_test

Vladimir Oltean <vladimir.oltean@nxp.com>
    selftests: forwarding: fix learning_test when h1 supports IFF_UNICAST_FLT

Vladimir Oltean <vladimir.oltean@nxp.com>
    selftests: forwarding: fix flood_unicast_test when h2 supports IFF_UNICAST_FLT

Rick Lindsley <ricklind@us.ibm.com>
    ibmvnic: Properly dispose of all skbs during a failover.

Lukasz Cieplicki <lukaszx.cieplicki@intel.com>
    i40e: Fix dropped jumbo frames statistics

Ivan Malov <ivan.malov@oktetlabs.ru>
    xsk: Clear page contiguity bit when unmapping pool

Eugen Hristev <eugen.hristev@microchip.com>
    ARM: dts: at91: sama5d2_icp: fix eeprom compatibles

Eugen Hristev <eugen.hristev@microchip.com>
    ARM: dts: at91: sam9x60ek: fix eeprom compatible and size

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: at91: pm: use proper compatibles for sam9x60's rtc and rtt

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: at91: pm: use proper compatible for sama5d2's rtc

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    arm64: dts: qcom: msm8992-*: Fix vdd_lvs1_2-supply typo

Andrei Lalaev <andrey.lalaev@gmail.com>
    pinctrl: sunxi: sunxi_pconf_set: use correct offset

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-evk: correct I2C3 pad settings

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-evk: correct gpio-led pad settings

Sherry Sun <sherry.sun@nxp.com>
    arm64: dts: imx8mp-evk: correct the uart2 pinctl value

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-evk: correct mmc pad settings

Konrad Dybcio <konrad.dybcio@somainline.org>
    arm64: dts: qcom: msm8994: Fix CPU6/7 reg values

Samuel Holland <samuel@sholland.org>
    pinctrl: sunxi: a83t: Fix NAND function name for some pins

Miaoqian Lin <linmq006@gmail.com>
    ARM: meson: Fix refcount leak in meson_smp_prepare_cpus

Eric Sandeen <sandeen@redhat.com>
    xfs: remove incorrect ASSERT in xfs_rename

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: replace run-time checks with struct kvaser_usb_driver_info

Jason A. Donenfeld <Jason@zx2c4.com>
    powerpc/powernv: delay rng platform device creation until later in boot

Hsin-Yi Wang <hsinyi@chromium.org>
    video: of_display_timing.h: include errno.h

Dan Williams <dan.j.williams@intel.com>
    memregion: Fix memregion_free() fallback definition

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Redefine pm_runtime_release_supplier()

Helge Deller <deller@gmx.de>
    fbcon: Prevent that screen size is smaller than font size

Helge Deller <deller@gmx.de>
    fbcon: Disallow setting font bigger than screen size

Helge Deller <deller@gmx.de>
    fbmem: Check virtual screen sizes in fb_set_var()

Guiling Deng <greens9@163.com>
    fbdev: fbmem: Fix logo center image dx issue

Yian Chen <yian.chen@intel.com>
    iommu/vt-d: Fix PCI bus rescan device hot add

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: stricter validation of element data

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_pipapo: release elements in clone from abort path

Duoming Zhou <duoming@zju.edu.cn>
    net: rose: fix UAF bug caused by rose_t0timer_expiry

Oliver Neukum <oneukum@suse.com>
    usbnet: fix memory leak in error case

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix insufficient bounds propagation from adjust_scalar_min_max_vals

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix incorrect verifier simulation around jmp32's jeq/jne

Rhett Aultman <rhett.aultman@samsara.com>
    can: gs_usb: gs_usb_open/close(): fix memory leak

Liang He <windhl@126.com>
    can: grcan: grcan_probe(): remove extra of_node_get()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: use call_rcu() instead of costly synchronize_rcu()

Tim Crawford <tcrawford@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo L140PU

Jann Horn <jannh@google.com>
    mm/slub: add missing TID updates on slab deactivation


-------------

Diffstat:

 .../bindings/dma/allwinner,sun50i-a64-dma.yaml     |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/at91-sam9x60ek.dts               |   3 +-
 arch/arm/boot/dts/at91-sama5d2_icp.dts             |   6 +-
 arch/arm/mach-at91/pm.c                            |   6 +-
 arch/arm/mach-meson/platsmp.c                      |   2 +
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts       |  18 +-
 .../boot/dts/qcom/msm8992-bullhead-rev-101.dts     |   2 +-
 arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts  |   2 +-
 arch/arm64/boot/dts/qcom/msm8994.dtsi              |   4 +-
 arch/powerpc/platforms/powernv/rng.c               |  16 +-
 drivers/base/core.c                                |   3 +-
 drivers/base/power/runtime.c                       |  20 +-
 drivers/dma/at_xdmac.c                             |   5 +
 drivers/dma/imx-sdma.c                             |   2 +-
 drivers/dma/pl330.c                                |   2 +-
 drivers/dma/ti/dma-crossbar.c                      |   5 +
 drivers/i2c/busses/i2c-cadence.c                   |   1 +
 drivers/iommu/intel/dmar.c                         |   2 +-
 drivers/misc/cardreader/rtsx_usb.c                 |  27 ++-
 drivers/net/can/grcan.c                            |   1 -
 drivers/net/can/usb/gs_usb.c                       |  23 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h        |  25 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   | 255 ++++++++++++---------
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   4 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   | 119 +++++-----
 drivers/net/ethernet/ibm/ibmvnic.c                 |   9 +
 drivers/net/ethernet/intel/i40e/i40e.h             |  16 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  73 ++++++
 drivers/net/ethernet/intel/i40e/i40e_register.h    |  13 ++
 drivers/net/ethernet/intel/i40e/i40e_type.h        |   1 +
 drivers/net/ethernet/realtek/r8169_main.c          |  10 +-
 drivers/net/usb/usbnet.c                           |  17 +-
 drivers/pinctrl/sunxi/pinctrl-sun8i-a83t.c         |  10 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |   2 +
 drivers/video/fbdev/core/fbcon.c                   |  33 +++
 drivers/video/fbdev/core/fbmem.c                   |  16 +-
 fs/xfs/xfs_inode.c                                 |   1 -
 include/linux/fbcon.h                              |   4 +
 include/linux/memregion.h                          |   2 +-
 include/linux/pm_runtime.h                         |   5 +-
 include/linux/rtsx_usb.h                           |   2 -
 include/video/of_display_timing.h                  |   2 +
 kernel/bpf/verifier.c                              | 113 ++++-----
 lib/idr.c                                          |   3 +-
 mm/slub.c                                          |   4 +-
 net/can/bcm.c                                      |  18 +-
 net/netfilter/nf_tables_api.c                      |   9 +-
 net/netfilter/nft_set_pipapo.c                     |  48 ++--
 net/rose/rose_route.c                              |   4 +-
 net/xdp/xsk_buff_pool.c                            |   1 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 tools/testing/selftests/net/forwarding/lib.sh      |   6 +-
 53 files changed, 632 insertions(+), 350 deletions(-)


