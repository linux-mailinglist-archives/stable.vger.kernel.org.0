Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0E15F5188
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 11:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiJEJJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 05:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiJEJIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 05:08:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0EE77E91;
        Wed,  5 Oct 2022 02:08:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE925615ED;
        Wed,  5 Oct 2022 09:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04B3C433C1;
        Wed,  5 Oct 2022 09:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664960907;
        bh=3CCNanyN7oPqdoX+SjKsPcFBbmkjG3gYy0TPKgplPbc=;
        h=From:To:Cc:Subject:Date:From;
        b=GNpSFyEIjp67ldt3GC6CFhm3M4hsbzZ1x4cT9qHuZcKhmuIss8Iou/MLZAo4zsKua
         8Y8wWBKWt9VjGUjdYHFigJYpiSopUTPSJcbdtJZ//h+/0KMGHKdnHd9ggHl9QTZu9g
         t9HnLbLDTpWvYVlakohrB3+LcjUGcWgZkfBG3/MU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.147
Date:   Wed,  5 Oct 2022 11:08:12 +0200
Message-Id: <166496089229156@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.147 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arm/boot/dts/am33xx-l4.dtsi                   |    3 
 arch/arm/boot/dts/integratorap.dts                 |    1 
 arch/x86/kernel/alternative.c                      |   45 +++++-----
 arch/x86/kvm/cpuid.c                               |    2 
 drivers/ata/libata-core.c                          |    4 
 drivers/clk/bcm/clk-iproc-pll.c                    |   12 +-
 drivers/clk/imx/clk-imx6sx.c                       |    4 
 drivers/clk/ingenic/tcu.c                          |   15 +--
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c |   13 ---
 drivers/input/keyboard/snvs_pwrkey.c               |    2 
 drivers/input/touchscreen/melfas_mip4.c            |    2 
 drivers/media/dvb-core/dvb_vb2.c                   |   11 ++
 drivers/mmc/host/mmc_hsq.c                         |    2 
 drivers/mmc/host/moxart-mmc.c                      |   17 ----
 drivers/net/dsa/mt7530.c                           |   15 ++-
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c     |   28 ++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   23 +++--
 drivers/net/usb/qmi_wwan.c                         |    1 
 drivers/net/usb/usbnet.c                           |    7 +
 drivers/nvme/host/core.c                           |    9 +-
 drivers/reset/reset-imx7.c                         |    1 
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |    7 -
 drivers/soc/sunxi/sunxi_sram.c                     |   27 ++----
 drivers/staging/media/rkvdec/rkvdec-h264.c         |    4 
 drivers/thunderbolt/icm.c                          |   12 ++
 drivers/thunderbolt/nhi.h                          |    2 
 drivers/thunderbolt/switch.c                       |    1 
 drivers/usb/storage/unusual_uas.h                  |   21 +++++
 drivers/usb/typec/ucsi/ucsi.c                      |    2 
 fs/btrfs/disk-io.c                                 |   25 +++++
 fs/ntfs/super.c                                    |    3 
 kernel/dma/swiotlb.c                               |   13 ++-
 mm/madvise.c                                       |    7 +
 mm/migrate.c                                       |    5 -
 mm/page_alloc.c                                    |   65 +++++++++++++--
 net/sched/act_ct.c                                 |    5 -
 sound/pci/hda/hda_tegra.c                          |   88 ++++++---------------
 sound/pci/hda/patch_hdmi.c                         |   47 +++++++++--
 sound/soc/codecs/tas2770.c                         |    3 
 tools/testing/selftests/net/reuseport_bpf.c        |    2 
 41 files changed, 345 insertions(+), 213 deletions(-)

Aidan MacDonald (1):
      clk: ingenic-tcu: Properly enable registers before accessing timers

Alexander Couzens (1):
      net: mt7531: only do PLL once after the reset

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

Dmitry Osipenko (2):
      ALSA: hda/tegra: Use clk_bulk helpers
      ALSA: hda/tegra: Reset hardware

Filipe Manana (1):
      btrfs: fix hang during unmount when stopping a space reclaim worker

Florian Fainelli (1):
      clk: iproc: Do not rely on node name for correct PLL setup

Frank Wunderlich (1):
      net: usb: qmi_wwan: Add new usb-id for Dell branded EM7455

Gil Fine (1):
      thunderbolt: Add support for Intel Maple Ridge single port controller

Greg Kroah-Hartman (1):
      Linux 5.10.147

Han Xu (1):
      clk: imx: imx6sx: remove the SET_RATE_PARENT flag for QSPI clocks

Hangyu Hua (2):
      media: dvb_vb2: fix possible out of bound access
      net: sched: act_ct: fix possible refcount leak in tcf_ct_init()

Heikki Krogerus (1):
      usb: typec: ucsi: Remove incorrect warning

Hongling Zeng (3):
      uas: add no-uas quirk for Hiksemi usb_disk
      usb-storage: Add Hiksemi USB3-FW to IGNORE_UAS
      uas: ignore UAS for Thinkplus chips

Hui Wang (1):
      ALSA: hda/hdmi: let new platforms assign the pcm slot dynamically

Jim Mattson (1):
      KVM: x86: Hide IA32_PLATFORM_DCA_CAP[31:0] from the guest

Junxiao Chang (1):
      net: stmmac: power up/down serdes in stmmac_open/release

Kai Vehmanen (1):
      ALSA: hda/hdmi: fix warning about PCM count when used with SOF

Linus Walleij (1):
      ARM: dts: integrator: Tag PCI host with device_type

Mario Limonciello (1):
      thunderbolt: Explicitly reset plug events delay back to USB4 spec value

Martin Povišer (1):
      ASoC: tas2770: Reinit regcache on reset

Maurizio Lombardi (1):
      mm: prevent page_frag_alloc() from corrupting the memory

Mel Gorman (1):
      mm/page_alloc: fix race condition between build_all_zonelists and page allocation

Michael Kelley (1):
      nvme: Fix IOC_PR_CLEAR and IOC_PR_RELEASE ioctls for nvme devices

Mika Westerberg (1):
      thunderbolt: Add support for Intel Maple Ridge

Minchan Kim (1):
      mm: fix madivse_pageout mishandling on non-LRU page

Mohan Kumar (1):
      ALSA: hda: Fix Nvidia dp infoframe

Nadav Amit (1):
      x86/alternative: Fix race in try_get_desc()

Nicolas Dufresne (1):
      media: rkvdec: Disable H.264 error detection

Niklas Cassel (1):
      libata: add ATA_HORKAGE_NOLPM for Pioneer BDR-207M and BDR-205

Peilin Ye (1):
      usbnet: Fix memory leak in usbnet_disconnect()

Rafael Mendonca (1):
      cxgb4: fix missing unlock on ETHOFLD desc collect fail path

Richard Zhu (1):
      reset: imx7: Fix the iMX8MP PCIe PHY PERST support

Samuel Holland (4):
      soc: sunxi: sram: Actually claim SRAM regions
      soc: sunxi: sram: Prevent the driver from being unbound
      soc: sunxi: sram: Fix probe function ordering issues
      soc: sunxi: sram: Fix debugfs info for A64 SRAM C

Sebastian Krzyszkowiak (1):
      Input: snvs_pwrkey - fix SNVS_HPVIDR1 register address

Sergei Antonov (1):
      mmc: moxart: fix 4-bit bus width and remove 8-bit bus width

Tianyu Lan (1):
      swiotlb: max mapping size takes min align mask into account

Wang Yufen (1):
      selftests: Fix the if conditions of in test_extra_filter()

Wenchao Chen (1):
      mmc: hsq: Fix data stomping during mmc recovery

Yang Yingliang (1):
      Input: melfas_mip4 - fix return value check in mip4_probe()

Yu Kuai (1):
      scsi: hisi_sas: Revert "scsi: hisi_sas: Limit max hw sectors for v3 HW"

YuTong Chang (1):
      ARM: dts: am33xx: Fix MMCHS0 dma properties

