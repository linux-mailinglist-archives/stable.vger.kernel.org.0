Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D801B5640E3
	for <lists+stable@lfdr.de>; Sat,  2 Jul 2022 16:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbiGBO6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jul 2022 10:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiGBO5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jul 2022 10:57:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF368DED4;
        Sat,  2 Jul 2022 07:57:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D2DC60F6E;
        Sat,  2 Jul 2022 14:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4A1C34114;
        Sat,  2 Jul 2022 14:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656773870;
        bh=PbyL8oZy7GM9iX54z1XimXg4W/n0ZaJoLEpOXdJorD4=;
        h=From:To:Cc:Subject:Date:From;
        b=1g/0vwQLrOHFjCltpPt9qN9BUdiSCX65RvxY+kvSRQcwpRbZzarbLSY5oSlaN4Xl7
         +gGzklVI6HcFxHLfCEfN88VFAKXArWY1h/gnwYqcXamCMLaX0qzaiIErNLK5Z393HO
         GLJIsTLNE7DoVI3HGmSQeit5/ooaaFXiTMkugyVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.18.9
Date:   Sat,  2 Jul 2022 16:57:43 +0200
Message-Id: <1656773864192163@kroah.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.18.9 kernel.

All users of the 5.18 kernel series must upgrade.

The updated 5.18.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.18.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 -
 arch/powerpc/include/asm/ftrace.h                 |    4 +-
 arch/powerpc/kernel/trace/ftrace.c                |   15 +++++++--
 arch/powerpc/mm/mem.c                             |    2 +
 drivers/clocksource/Kconfig                       |    2 -
 drivers/clocksource/timer-ixp4xx.c                |   25 ----------------
 drivers/md/bcache/btree.c                         |    1 
 drivers/md/bcache/writeback.c                     |    1 
 drivers/net/ethernet/huawei/hinic/hinic_devlink.c |    4 --
 fs/io_uring.c                                     |   34 +++++++++++-----------
 include/linux/platform_data/timer-ixp4xx.h        |   11 -------
 kernel/time/tick-sched.c                          |    1 
 12 files changed, 40 insertions(+), 62 deletions(-)

Coly Li (1):
      bcache: memset on stack variables in bch_btree_check() and bch_sectors_dirty_init()

Greg Kroah-Hartman (1):
      Linux 5.18.9

Kees Cook (1):
      hinic: Replace memcpy() with direct assignment

Linus Walleij (1):
      clocksource/drivers/ixp4xx: Drop boardfile probe path

Masahiro Yamada (1):
      tick/nohz: unexport __init-annotated tick_nohz_full_setup()

Naveen N. Rao (1):
      powerpc/ftrace: Remove ftrace init tramp once kernel init is complete

Pavel Begunkov (1):
      io_uring: fix not locked access to fixed buf table

