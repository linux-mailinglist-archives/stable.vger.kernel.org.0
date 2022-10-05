Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0BEF5F517B
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 11:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiJEJIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 05:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiJEJIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 05:08:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1594B76949;
        Wed,  5 Oct 2022 02:08:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D748B81D4C;
        Wed,  5 Oct 2022 09:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CE9C43140;
        Wed,  5 Oct 2022 09:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664960894;
        bh=Di4Eog33Os8tVOVoJID5VJf+VPBQUmMyAO0+LWTvecg=;
        h=From:To:Cc:Subject:Date:From;
        b=uNLYCn9klvyJJAEZNsybV1MSNVmL2ZYzh62IMXSIPzG+2yS8vdDQXmDQj/IJLC57c
         gl+0JJ8TAGTS8bpsVxWnKNxKP/qBO8yxT5c6YcQh7exRHa88Ie2KcRuOUsZqxvd1M3
         VqZPdAwuZML2aRRM3biJiXzSAR/Kscpxmjt2HK+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.216
Date:   Wed,  5 Oct 2022 11:08:07 +0200
Message-Id: <1664960888218245@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.216 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arm/boot/dts/am335x-baltos.dtsi               |    2 
 arch/arm/boot/dts/am335x-boneblack-common.dtsi     |    1 
 arch/arm/boot/dts/am335x-boneblack-wireless.dts    |    1 
 arch/arm/boot/dts/am335x-boneblue.dts              |    1 
 arch/arm/boot/dts/am335x-bonegreen-wireless.dts    |    1 
 arch/arm/boot/dts/am335x-evm.dts                   |    3 
 arch/arm/boot/dts/am335x-evmsk.dts                 |    2 
 arch/arm/boot/dts/am335x-lxm.dts                   |    2 
 arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi  |    2 
 arch/arm/boot/dts/am335x-moxa-uc-8100-me-t.dts     |    2 
 arch/arm/boot/dts/am335x-pepper.dts                |    4 -
 arch/arm/boot/dts/am335x-phycore-som.dtsi          |    2 
 arch/arm/boot/dts/am33xx-l4.dtsi                   |    9 --
 arch/arm/boot/dts/am33xx.dtsi                      |    3 
 arch/arm/boot/dts/am4372.dtsi                      |    3 
 arch/arm/boot/dts/am437x-cm-t43.dts                |    2 
 arch/arm/boot/dts/am437x-gp-evm.dts                |    4 -
 arch/arm/boot/dts/am437x-l4.dtsi                   |    5 -
 arch/arm/boot/dts/am437x-sk-evm.dts                |    2 
 arch/arm/boot/dts/integratorap.dts                 |    1 
 drivers/ata/libata-core.c                          |    4 +
 drivers/clk/bcm/clk-iproc-pll.c                    |   12 ++-
 drivers/clk/imx/clk-imx6sx.c                       |    4 -
 drivers/clk/ingenic/tcu.c                          |   15 +---
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c |   13 ----
 drivers/input/touchscreen/melfas_mip4.c            |    2 
 drivers/media/dvb-core/dvb_vb2.c                   |   11 +++
 drivers/mmc/host/moxart-mmc.c                      |   17 -----
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c |    4 -
 drivers/net/usb/qmi_wwan.c                         |    1 
 drivers/net/usb/usbnet.c                           |    7 +-
 drivers/nvme/host/core.c                           |    9 +-
 drivers/soc/sunxi/sunxi_sram.c                     |   27 +++-----
 drivers/usb/storage/unusual_uas.h                  |   21 ++++++
 fs/ntfs/super.c                                    |    3 
 mm/madvise.c                                       |    7 +-
 mm/migrate.c                                       |    5 -
 mm/page_alloc.c                                    |   65 +++++++++++++++++----
 tools/testing/selftests/net/reuseport_bpf.c        |    2 
 40 files changed, 172 insertions(+), 111 deletions(-)

Aidan MacDonald (1):
      clk: ingenic-tcu: Properly enable registers before accessing timers

Alistair Popple (1):
      mm/migrate_device.c: flush TLB while holding PTL

Brian Norris (1):
      Revert "drm: bridge: analogix/dp: add panel prepare/unprepare in suspend/resume time"

Cai Huoqing (1):
      soc: sunxi_sram: Make use of the helper function devm_platform_ioremap_resource()

Chaitanya Kulkarni (1):
      nvme: add new line after variable declatation

ChenXiaoSong (1):
      ntfs: fix BUG_ON in ntfs_lookup_inode_by_name()

Faiz Abbas (1):
      ARM: dts: Move am33xx and am43xx mmc nodes to sdhci-omap driver

Florian Fainelli (1):
      clk: iproc: Do not rely on node name for correct PLL setup

Frank Wunderlich (1):
      net: usb: qmi_wwan: Add new usb-id for Dell branded EM7455

Greg Kroah-Hartman (1):
      Linux 5.4.216

Han Xu (1):
      clk: imx: imx6sx: remove the SET_RATE_PARENT flag for QSPI clocks

Hangyu Hua (1):
      media: dvb_vb2: fix possible out of bound access

Hongling Zeng (3):
      uas: add no-uas quirk for Hiksemi usb_disk
      usb-storage: Add Hiksemi USB3-FW to IGNORE_UAS
      uas: ignore UAS for Thinkplus chips

Linus Walleij (1):
      ARM: dts: integrator: Tag PCI host with device_type

Maurizio Lombardi (1):
      mm: prevent page_frag_alloc() from corrupting the memory

Mel Gorman (1):
      mm/page_alloc: fix race condition between build_all_zonelists and page allocation

Michael Kelley (1):
      nvme: Fix IOC_PR_CLEAR and IOC_PR_RELEASE ioctls for nvme devices

Minchan Kim (1):
      mm: fix madivse_pageout mishandling on non-LRU page

Niklas Cassel (1):
      libata: add ATA_HORKAGE_NOLPM for Pioneer BDR-207M and BDR-205

Peilin Ye (1):
      usbnet: Fix memory leak in usbnet_disconnect()

Samuel Holland (4):
      soc: sunxi: sram: Actually claim SRAM regions
      soc: sunxi: sram: Prevent the driver from being unbound
      soc: sunxi: sram: Fix probe function ordering issues
      soc: sunxi: sram: Fix debugfs info for A64 SRAM C

Sasha Levin (1):
      Revert "net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()"

Sergei Antonov (1):
      mmc: moxart: fix 4-bit bus width and remove 8-bit bus width

Wang Yufen (1):
      selftests: Fix the if conditions of in test_extra_filter()

Yang Yingliang (1):
      Input: melfas_mip4 - fix return value check in mip4_probe()

YuTong Chang (1):
      ARM: dts: am33xx: Fix MMCHS0 dma properties

