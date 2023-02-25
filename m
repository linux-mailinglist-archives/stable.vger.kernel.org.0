Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354D26A2937
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 12:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjBYLIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 06:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBYLIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 06:08:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C3213D56;
        Sat, 25 Feb 2023 03:08:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EECF360AF2;
        Sat, 25 Feb 2023 11:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2543C433EF;
        Sat, 25 Feb 2023 11:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677323314;
        bh=jynge7toSoN/O8J0o0RHWsDpyc53tx7I+R8xCUCH2lc=;
        h=From:To:Cc:Subject:Date:From;
        b=tlQl3KDERadH5q5L4dt8Wnej7ZxXt2+uON6vYigTzibugYPb8yKdEXP44mXP91DwF
         kgmv8ddmt7truIgyGkQ9hkOeIVVwxytsZUQzET5IZzCHHxiHkvdPeL67GO/HzgcOS6
         p/hQz3k6Q87gg9lMZGu75cI2eMRNmiL835GUM234=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.307
Date:   Sat, 25 Feb 2023 12:08:30 +0100
Message-Id: <16773233111052@kroah.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.307 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi    |   44 ++++++++++++++++++
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi    |   44 ++++++++++++++++++
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi           |   20 +++++++-
 drivers/net/wireless/marvell/mwifiex/sdio.c           |    1 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c |    8 ---
 include/linux/nospec.h                                |    4 +
 include/linux/random.h                                |    6 +-
 kernel/time/alarmtimer.c                              |   33 +++++++++++--
 lib/usercopy.c                                        |    7 ++
 10 files changed, 153 insertions(+), 16 deletions(-)

Bitterblue Smith (1):
      wifi: rtl8xxxu: gen2: Turn on the rate control

Dave Hansen (1):
      uaccess: Add speculation barrier to copy_from_user()

Greg Kroah-Hartman (1):
      Linux 4.14.307

Jason A. Donenfeld (1):
      random: always mix cycle counter in add_latent_entropy()

Lukas Wunner (1):
      wifi: mwifiex: Add missing compatible string for SD8787

Sean Anderson (2):
      powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G
      powerpc: dts: t208x: Disable 10G on MAC1 and MAC2

Thomas Gleixner (1):
      alarmtimer: Prevent starvation by small intervals and SIG_IGN

