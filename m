Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9CAA6A9A30
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 16:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjCCPIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 10:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjCCPIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 10:08:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AC8DBC6;
        Fri,  3 Mar 2023 07:08:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A059FB8184D;
        Fri,  3 Mar 2023 15:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C8BC433EF;
        Fri,  3 Mar 2023 15:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677856081;
        bh=M0ZwhAHrhW1evpz3kl5vl2JFg0ukacwznqjLQqQ9Yg8=;
        h=From:To:Cc:Subject:Date:From;
        b=IZaecL7qXdWmPAq84M7ua42LMGHh5EzorNr+fMdgtjNIsG5Jf2KLCyOEN+6xMcDRv
         s267KBe8y0T/gtHn2AGAhyVtvlXSMMEf8c5Yb/SqRxSVuQsHiMIdxfeJZUEteH4zD/
         tlHqsGJL2wpXuGf4DzgMu0MVa9QHNp7daxqOYRM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.172
Date:   Fri,  3 Mar 2023 16:07:57 +0100
Message-Id: <167785607757205@kroah.com>
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

I'm announcing the release of the 5.10.172 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile            |    2 +-
 io_uring/io_uring.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

Greg Kroah-Hartman (1):
      Linux 5.10.172

Jens Axboe (1):
      io_uring: ensure that io_init_req() passes in the right issue_flags

