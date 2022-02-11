Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0930C4B20B6
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 09:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348227AbiBKIxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 03:53:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348220AbiBKIxg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 03:53:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4981021;
        Fri, 11 Feb 2022 00:53:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95F97B828BF;
        Fri, 11 Feb 2022 08:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A7AC340E9;
        Fri, 11 Feb 2022 08:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644569608;
        bh=rr5dFkqOe0e+xJSmOhQaAoNX8YcPQJez69NMfx3zTEw=;
        h=From:To:Cc:Subject:Date:From;
        b=qB1egXHO1df5LKjj0iDZa8j0X5JZuZLxVitBLraDtw8sKg6491nGlDTWdEE8hvPtV
         SBahmHB3Q9hLuQ55/RemT3h8J006rhdmyerKdK1W+LF4FPpCXhD8gWfRZxodnpEzPL
         d5MrbDKS2Q8hmOIMaUHae+9iJkCw0/i7Rk5FF19U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.179
Date:   Fri, 11 Feb 2022 09:53:16 +0100
Message-Id: <1644569597160132@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
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

I'm announcing the release of the 5.4.179 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                      |    2 +-
 drivers/mmc/host/moxart-mmc.c |    2 +-
 net/tipc/link.c               |   10 +++++++---
 net/tipc/monitor.c            |    2 ++
 4 files changed, 11 insertions(+), 5 deletions(-)

Greg Kroah-Hartman (2):
      moxart: fix potential use-after-free on remove path
      Linux 5.4.179

Jon Maloy (1):
      tipc: improve size validations for received domain records

