Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EB44ADFF9
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 18:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384429AbiBHRzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 12:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384457AbiBHRzX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 12:55:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4065FC0612C1;
        Tue,  8 Feb 2022 09:55:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03C37B81CB8;
        Tue,  8 Feb 2022 17:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B49BC340EC;
        Tue,  8 Feb 2022 17:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644342914;
        bh=UuVL8Z7/jrC5OnVPB6PgBHDeub2K7lCzr9ygqM9zNXg=;
        h=From:To:Cc:Subject:Date:From;
        b=NDOVcnz/oO7BLRPcbN6FBZy9u7xujyM6D6lDtZw6t1eDPatkmxGrxh2WEIyoi2EmI
         JTfhw7qhF5+SR7XnD43tVND+Yb/FmigQ7ZycwIV7NbHrG3XbhLoXNT0/0VsMU7PfB4
         eLGNuBclnx5IToI+PaXWkFEDk5BhRmHRhzJI4lNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.178
Date:   Tue,  8 Feb 2022 18:54:56 +0100
Message-Id: <16443428969390@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.178 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 block/bio-integrity.c                                 |    2 
 drivers/edac/altera_edac.c                            |    2 
 drivers/edac/xgene_edac.c                             |    2 
 drivers/gpu/drm/i915/display/intel_overlay.c          |    3 
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c       |    2 
 drivers/infiniband/hw/mlx4/main.c                     |    2 
 drivers/infiniband/sw/rdmavt/qp.c                     |    2 
 drivers/infiniband/sw/siw/siw.h                       |    7 --
 drivers/infiniband/sw/siw/siw_qp_rx.c                 |   20 +++--
 drivers/iommu/amd_iommu_init.c                        |    2 
 drivers/iommu/intel_irq_remapping.c                   |   13 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h       |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c  |   19 ++++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c |   19 +++--
 drivers/net/ieee802154/ca8210.c                       |    1 
 drivers/net/ieee802154/mac802154_hwsim.c              |    1 
 drivers/net/ieee802154/mcr20a.c                       |    4 -
 drivers/net/macsec.c                                  |    9 ++
 drivers/pinctrl/bcm/pinctrl-bcm2835.c                 |   23 ++++--
 drivers/rtc/rtc-mc146818-lib.c                        |    2 
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                     |   21 +++---
 drivers/soc/mediatek/mtk-scpsys.c                     |   15 +---
 drivers/spi/spi-bcm-qspi.c                            |    2 
 drivers/spi/spi-meson-spicc.c                         |    5 +
 drivers/spi/spi-mt65xx.c                              |    2 
 fs/btrfs/qgroup.c                                     |   21 +++++-
 fs/ext4/inline.c                                      |   10 ++
 fs/fs_context.c                                       |    4 -
 fs/nfsd/nfs4state.c                                   |    4 -
 kernel/audit.c                                        |   62 ++++++++++++------
 kernel/cgroup/cpuset.c                                |   10 ++
 mm/kmemleak.c                                         |   13 ++-
 net/ieee802154/nl802154.c                             |    8 +-
 sound/pci/hda/patch_realtek.c                         |    6 +
 sound/soc/codecs/cpcap.c                              |    2 
 sound/soc/codecs/max9759.c                            |    3 
 sound/soc/fsl/pcm030-audio-fabric.c                   |   11 ++-
 sound/soc/soc-ops.c                                   |   29 +++++++-
 sound/soc/xilinx/xlnx_formatter_pcm.c                 |   27 ++++++-
 sound/usb/quirks-table.h                              |   10 ++
 tools/testing/selftests/futex/Makefile                |    4 -
 42 files changed, 294 insertions(+), 113 deletions(-)

Albert Geantă (1):
      ALSA: hda/realtek: Add quirk for ASUS GU603

Benjamin Gaignard (1):
      spi: mediatek: Avoid NULL pointer crash in interrupt

Bernard Metzler (1):
      RDMA/siw: Fix broken RDMA Read Fence/Resume logic.

Camel Guo (1):
      net: stmmac: dump gmac4 DMA registers correctly

Christian Lachner (3):
      ALSA: hda/realtek: Add missing fixup-model entry for Gigabyte X570 ALC1220 quirks
      ALSA: hda/realtek: Fix silent output on Gigabyte X570S Aorus Master (newer chipset)
      ALSA: hda/realtek: Fix silent output on Gigabyte X570 Aorus Xtreme after reboot from Windows

Dai Ngo (1):
      nfsd: nfsd4_setclientid_confirm mistakenly expires confirmed client.

Dan Carpenter (2):
      drm/i915/overlay: Prevent divide by zero bugs in scaling
      ASoC: max9759: fix underflow in speaker_gain_control_put()

Florian Fainelli (1):
      pinctrl: bcm2835: Fix a few error paths

Greg Kroah-Hartman (1):
      Linux 5.4.178

Guenter Roeck (1):
      Revert "ASoC: mediatek: Check for error clk pointer"

Guoqing Jiang (1):
      iommu/vt-d: Fix potential memory leak in intel_setup_irq_remapping()

Jiasheng Jiang (1):
      ASoC: cpcap: Check for NULL pointer after calling of_get_child_by_name

Joerg Roedel (1):
      iommu/amd: Fix loop timeout issue in iommu_ga_log_enable()

John Meneghini (1):
      scsi: bnx2fc: Make bnx2fc_recv_frame() mp safe

Kamal Dasu (1):
      spi: bcm-qspi: check for valid cs before applying chip select

Lang Yu (1):
      mm/kmemleak: avoid scanning potential huge holes

Leon Romanovsky (1):
      RDMA/mlx4: Don't continue event handler after memory allocation failure

Lior Nahmanson (1):
      net: macsec: Verify that send_sci is on when setting Tx sci explicitly

Mark Brown (3):
      ASoC: ops: Reject out of bounds values in snd_soc_put_volsw()
      ASoC: ops: Reject out of bounds values in snd_soc_put_volsw_sx()
      ASoC: ops: Reject out of bounds values in snd_soc_put_xr_sx()

Martin K. Petersen (1):
      block: bio-integrity: Advance seed correctly for larger interval sizes

Miaoqian Lin (2):
      spi: meson-spicc: add IRQ check in meson_spicc_probe
      ASoC: fsl: Add missing error handling in pcm030_fabric_probe

Mike Marciniszyn (1):
      IB/rdmavt: Validate remote_addr during loopback atomic tests

Miquel Raynal (4):
      net: ieee802154: hwsim: Ensure proper channel selection at probe time
      net: ieee802154: mcr20a: Fix lifs/sifs periods
      net: ieee802154: ca8210: Stop leaking skb's
      net: ieee802154: Return meaningful error codes from the netlink helpers

Muhammad Usama Anjum (1):
      selftests: futex: Use variable MAKE instead of make

Nick Lopez (1):
      drm/nouveau: fix off by one in BIOS boundary checking

Paul Moore (1):
      audit: improve audit queue handling when "audit=1" on cmdline

Ritesh Harjani (1):
      ext4: fix error handling in ext4_restore_inline_data()

Riwen Lu (1):
      rtc: cmos: Evaluate century appropriate

Robert Hancock (1):
      ASoC: xilinx: xlnx_formatter_pcm: Make buffer bytes multiple of period bytes

Sergey Shtylyov (2):
      EDAC/altera: Fix deferred probing
      EDAC/xgene: Fix deferred probing

Shin'ichiro Kawasaki (1):
      btrfs: fix deadlock between quota disable and qgroup rescan worker

Takashi Iwai (1):
      ALSA: usb-audio: Simplify quirk entries with a macro

Waiman Long (1):
      cgroup/cpuset: Fix "suspicious RCU usage" lockdep warning

Yannick Vignon (1):
      net: stmmac: ensure PTP time register reads are consistent

Yutian Yang (1):
      memcg: charge fs_context and legacy_fs_context

