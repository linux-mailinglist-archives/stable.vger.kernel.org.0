Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4325F5181
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 11:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiJEJI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 05:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiJEJIq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 05:08:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FD476952;
        Wed,  5 Oct 2022 02:08:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18FBCB81D48;
        Wed,  5 Oct 2022 09:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79771C433C1;
        Wed,  5 Oct 2022 09:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664960885;
        bh=omy0/pUp2MMqJkM5U7w06cKtRBXOXZXSECxfXHqI8hY=;
        h=From:To:Cc:Subject:Date:From;
        b=IEcv7UmkULkSEcY3NjGxTIbXrz9j9oMSYCxDvLPM0OWcFVHTvCwTLyYUYoEW8dH+H
         Qm/5bgV+pewuSYKKOQQMbHkW3SmQgqL27fPH0PTi9i/6Z7JHL8PIAfblPyaPgCJP81
         MFXn6KPFfaP50HGI0RSGO+5qxLrvpQ5W6Mui+ELw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.261
Date:   Wed,  5 Oct 2022 11:08:01 +0200
Message-Id: <1664960882137215@kroah.com>
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

I'm announcing the release of the 4.19.261 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arm/boot/dts/integratorap.dts                 |    1 
 drivers/ata/libata-core.c                          |    4 +
 drivers/clk/bcm/clk-iproc-pll.c                    |   12 ++-
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c |   13 ----
 drivers/input/touchscreen/melfas_mip4.c            |    2 
 drivers/mmc/host/moxart-mmc.c                      |   17 -----
 drivers/net/usb/qmi_wwan.c                         |    1 
 drivers/net/usb/usbnet.c                           |    7 +-
 drivers/nvme/host/core.c                           |    9 +-
 drivers/soc/sunxi/sunxi_sram.c                     |   23 +++----
 drivers/usb/storage/unusual_uas.h                  |   21 ++++++
 fs/ntfs/super.c                                    |    3 
 mm/migrate.c                                       |    5 -
 mm/page_alloc.c                                    |   65 +++++++++++++++++----
 security/integrity/ima/ima.h                       |    5 +
 security/integrity/ima/ima_policy.c                |   24 +++++--
 tools/testing/selftests/net/reuseport_bpf.c        |    2 
 18 files changed, 146 insertions(+), 70 deletions(-)

Alistair Popple (1):
      mm/migrate_device.c: flush TLB while holding PTL

Brian Norris (1):
      Revert "drm: bridge: analogix/dp: add panel prepare/unprepare in suspend/resume time"

Chaitanya Kulkarni (1):
      nvme: add new line after variable declatation

ChenXiaoSong (1):
      ntfs: fix BUG_ON in ntfs_lookup_inode_by_name()

Florian Fainelli (1):
      clk: iproc: Do not rely on node name for correct PLL setup

Frank Wunderlich (1):
      net: usb: qmi_wwan: Add new usb-id for Dell branded EM7455

Greg Kroah-Hartman (1):
      Linux 4.19.261

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

Niklas Cassel (1):
      libata: add ATA_HORKAGE_NOLPM for Pioneer BDR-207M and BDR-205

Peilin Ye (1):
      usbnet: Fix memory leak in usbnet_disconnect()

Samuel Holland (4):
      soc: sunxi: sram: Actually claim SRAM regions
      soc: sunxi: sram: Prevent the driver from being unbound
      soc: sunxi: sram: Fix probe function ordering issues
      soc: sunxi: sram: Fix debugfs info for A64 SRAM C

Sergei Antonov (1):
      mmc: moxart: fix 4-bit bus width and remove 8-bit bus width

Tyler Hicks (3):
      ima: Have the LSM free its audit rule
      ima: Free the entire rule when deleting a list of rules
      ima: Free the entire rule if it fails to parse

Wang Yufen (1):
      selftests: Fix the if conditions of in test_extra_filter()

Yang Yingliang (1):
      Input: melfas_mip4 - fix return value check in mip4_probe()

