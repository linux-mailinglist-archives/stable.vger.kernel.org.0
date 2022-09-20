Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6375BE388
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 12:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiITKmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 06:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbiITKly (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 06:41:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D871E22B18;
        Tue, 20 Sep 2022 03:41:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43AAD62902;
        Tue, 20 Sep 2022 10:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29769C433C1;
        Tue, 20 Sep 2022 10:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663670500;
        bh=kU6fBWNc2rekED1d8jpDzBi5eAhEg8SIoOIk9jhtPoo=;
        h=From:To:Cc:Subject:Date:From;
        b=FaWSr1ajzBtvUBG/qmn9Ltb79t3v6Q0Qr0O/upB/+7LQsP4iXJhi57dCmzOffnDx0
         dwpSk+SoaW/dCyo+ErpIZXeeB3VQHvoZ5E6ddTD3TyUNUlkZPd+cjRv/cEvxFeQ9oK
         9wL88GaNY3yIRxpz7R7D2AgPVTLVYy/OT7Is+fyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.259
Date:   Tue, 20 Sep 2022 12:42:08 +0200
Message-Id: <166367052860111@kroah.com>
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

I'm announcing the release of the 4.19.259 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/input/joydev/joystick.rst     |    1 
 Makefile                                    |    2 -
 drivers/gpu/drm/msm/msm_rd.c                |    3 ++
 drivers/hid/intel-ish-hid/ishtp-hid.h       |    2 -
 drivers/input/joystick/iforce/iforce-main.c |    1 
 drivers/net/ethernet/broadcom/tg3.c         |    8 +++++--
 drivers/net/ieee802154/cc2520.c             |    1 
 drivers/net/phy/dp83822.c                   |    3 --
 drivers/perf/arm_pmu_platform.c             |    2 -
 drivers/platform/x86/acer-wmi.c             |    9 +++++++-
 drivers/usb/storage/unusual_uas.h           |    7 ++++++
 fs/tracefs/inode.c                          |   31 ++++++++++++++++++++--------
 mm/mmap.c                                   |    9 ++++++--
 13 files changed, 61 insertions(+), 18 deletions(-)

Brian Norris (1):
      tracefs: Only clobber mode/uid/gid on remount if asked

Enguerrand de Ribaucourt (1):
      net: dp83822: disable rx error interrupt

Greg Kroah-Hartman (1):
      Linux 4.19.259

Greg Tulli (1):
      Input: iforce - add support for Boeder Force Feedback Wheel

Hans de Goede (1):
      platform/x86: acer-wmi: Acer Aspire One AOD270/Packard Bell Dot keymap fixes

Hu Xiaoying (1):
      usb: storage: Add ASUS <0x0b05:0x1932> to IGNORE_UAS

Jann Horn (1):
      mm: Fix TLB flush for not-first PFNMAP mappings in unmap_region()

Jason Wang (1):
      HID: ishtp-hid-clientHID: ishtp-hid-client: Fix comment typo

Kai-Heng Feng (1):
      tg3: Disable tg3 device on system reboot to avoid triggering AER

Li Qiong (1):
      ieee802154: cc2520: add rc code in cc2520_tx()

Rob Clark (1):
      drm/msm/rd: Fix FIFO-full deadlock

Yu Zhe (1):
      perf/arm_pmu_platform: fix tests for platform_get_irq() failure

