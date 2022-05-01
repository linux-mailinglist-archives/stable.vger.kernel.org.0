Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05665164F1
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 17:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243963AbiEAP1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 11:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiEAP1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 11:27:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CBD3054E;
        Sun,  1 May 2022 08:24:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11C3C60F04;
        Sun,  1 May 2022 15:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E03C385AA;
        Sun,  1 May 2022 15:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651418648;
        bh=CHunxDgVf1HuXc+Ni/6ri8VWgAwFx966pPD9sBs4W1w=;
        h=From:To:Cc:Subject:Date:From;
        b=BNT/cqEbaaUnLqkAhEJcF5ji36kn9NwD5WEQrmYXTmjAsBTO0N+Rw7j20fw+Sakqe
         oByg/v7rEbBq4QQVxP7/ixG6QjHJShgE3rOJl6B+O0hx2+kHWqbBVcTzHeVmeqZz9v
         Z73MQdS8N0jyUJ0gGC149w8iIsgewoYX74mELQBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.241
Date:   Sun,  1 May 2022 17:23:59 +0200
Message-Id: <165141863986144@kroah.com>
X-Mailer: git-send-email 2.36.0
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

I'm announcing the release of the 4.19.241 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/ia64/kernel/kprobes.c                          |   78 +++++++++++++++++++-
 arch/powerpc/include/asm/exception-64s.h            |   37 +++++----
 drivers/block/Kconfig                               |   16 ++++
 drivers/block/floppy.c                              |   43 ++++++++---
 drivers/lightnvm/Kconfig                            |    2 
 drivers/media/platform/vicodec/vicodec-core.c       |    6 -
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c  |    8 ++
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h  |    4 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c |   13 ++-
 drivers/net/hamradio/6pack.c                        |    5 -
 net/sched/cls_u32.c                                 |   18 ++--
 12 files changed, 180 insertions(+), 52 deletions(-)

Dafna Hirschfeld (1):
      media: vicodec: upon release, call m2m release before freeing ctrl handler

Eric Dumazet (1):
      net/sched: cls_u32: fix netns refcount changes in u32_change()

Greg Kroah-Hartman (3):
      Revert "net: ethernet: stmmac: fix altr_tse_pcs function when using a fixed-link"
      lightnvm: disable the subsystem
      Linux 4.19.241

Lin Ma (2):
      hamradio: defer 6pack kfree after unregister_netdev
      hamradio: remove needs_free_netdev to avoid UAF

Masami Hiramatsu (3):
      Revert "ia64: kprobes: Fix to pass correct trampoline address to the handler"
      Revert "ia64: kprobes: Use generic kretprobe trampoline handler"
      ia64: kprobes: Fix to pass correct trampoline address to the handler

Michael Ellerman (1):
      powerpc/64s: Unmerge EX_LR and EX_DAR

Nicholas Piggin (1):
      powerpc/64/interrupt: Temporarily save PPR on stack to fix register corruption due to SLB miss

Willy Tarreau (1):
      floppy: disable FDRAWCMD by default

