Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A717576082
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 13:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbiGOLbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 07:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbiGOLbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 07:31:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDB7FD35;
        Fri, 15 Jul 2022 04:30:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB3AB622A5;
        Fri, 15 Jul 2022 11:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFCAC34115;
        Fri, 15 Jul 2022 11:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657884603;
        bh=n4oeHO2qOw19Hz/zJnP2KQEXgK/Eto9ZEdGd2nqIoAI=;
        h=From:To:Cc:Subject:Date:From;
        b=zXp3zKf0SIe6+0fORyADqWjbRuvBDKGYvXav9za3tCjy2v7nFjjYLNciJgnX25BI4
         uU7Vex3LoPxRMi/frJIUN+N6BBVeVdarbSOdJCxaba6axDRI5a4zlz3X4YYRA34cX+
         fsAJtcmKd7WpujKCCNPFTTTDUlh2dNde3bMoRB04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.18.12
Date:   Fri, 15 Jul 2022 13:29:59 +0200
Message-Id: <1657884524138103@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.18.12 kernel.

This, and the 5.15.55, 5.10.131, and 5.4.206 releases are only for those users
of the drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c driver, to prevent known data
loss issues with that codebase.  If you don't use this driver, no need to
upgrade.

The updated 5.18.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.18.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                   |    2 +-
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Greg Kroah-Hartman (2):
      Revert "mtd: rawnand: gpmi: Fix setting busy timeout setting"
      Linux 5.18.12

