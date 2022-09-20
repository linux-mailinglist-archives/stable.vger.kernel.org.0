Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC5C5BE389
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 12:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiITKmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 06:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiITKl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 06:41:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFDF6717C;
        Tue, 20 Sep 2022 03:41:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CB066289E;
        Tue, 20 Sep 2022 10:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E04DC433D6;
        Tue, 20 Sep 2022 10:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663670509;
        bh=Z40D9iLLlXDGHdxDILgfbdcrhVoXp0Sk6ryWIknLIPk=;
        h=From:To:Cc:Subject:Date:From;
        b=B8mvM4vv3GRPoxViWssbNEfhZrQWzChgUk+JuDp0Z+YP/Cq5ANmCpNZA0ZdtGhtwJ
         tl6+Iob/BgLLdsoi3gQSxuueTwHv2DwyY8r0uLhukgCjUKwmWTOhj2DnKrm7XqWvCM
         Iv3CDOjRY4fPQBv1grJkkQOATIwT+/3Im+nqpCEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.214
Date:   Tue, 20 Sep 2022 12:42:14 +0200
Message-Id: <1663670534215131@kroah.com>
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

I'm announcing the release of the 5.4.214 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/input/joydev/joystick.rst     |    1 
 Makefile                                    |    2 
 drivers/gpu/drm/msm/msm_rd.c                |    3 +
 drivers/hid/intel-ish-hid/ishtp-hid.h       |    2 
 drivers/hid/intel-ish-hid/ishtp/client.c    |   68 ++++++++++++++++------------
 drivers/input/joystick/iforce/iforce-main.c |    1 
 drivers/net/ethernet/broadcom/tg3.c         |    8 ++-
 drivers/net/ieee802154/cc2520.c             |    1 
 drivers/net/phy/dp83822.c                   |    3 -
 drivers/nvme/target/tcp.c                   |    3 +
 drivers/perf/arm_pmu_platform.c             |    2 
 drivers/platform/x86/acer-wmi.c             |    9 +++
 drivers/soc/fsl/Kconfig                     |    1 
 drivers/usb/storage/unusual_uas.h           |    7 ++
 fs/tracefs/inode.c                          |   31 +++++++++---
 mm/mmap.c                                   |    9 ++-
 16 files changed, 104 insertions(+), 47 deletions(-)

Brian Norris (1):
      tracefs: Only clobber mode/uid/gid on remount if asked

Enguerrand de Ribaucourt (1):
      net: dp83822: disable rx error interrupt

Even Xu (1):
      hid: intel-ish-hid: ishtp: Fix ishtp client sending disordered message

Greg Kroah-Hartman (1):
      Linux 5.4.214

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

Mathew McBride (1):
      soc: fsl: select FSL_GUTS driver for DPIO

Maurizio Lombardi (1):
      nvmet-tcp: fix unhandled tcp states in nvmet_tcp_state_change()

Rob Clark (1):
      drm/msm/rd: Fix FIFO-full deadlock

Yu Zhe (1):
      perf/arm_pmu_platform: fix tests for platform_get_irq() failure

