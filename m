Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B19D2464A4
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 12:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgHQKhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 06:37:50 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:38281 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726830AbgHQKht (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 06:37:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 879361941B3A;
        Mon, 17 Aug 2020 06:37:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 06:37:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Y9hFyp
        dZ1saK1EJBu2fcqRnE8usx+2xICpwQ3Zq1jTE=; b=mOXVDcSghXsz/D9H0mmFd9
        iIoa97dCLzaExEXLh4cU3B1pItBuJbcT55tKqxMEjthKx11rc0glnzNbUWVk/BcC
        JVaACgxdoYbNOXcMAMmFxl2RRpLAc1aD62XQcZ1dI5BXOjEyvKRX7kqMDDm0lVdP
        s0UfePfRDIf5w1y/TqxbSJ2w4YiqfU19zaNpPkqd7bepeecUFDRy+A/ztO5hUc5N
        RoBmOIlnRw6fyuh9NPmPCqzkhoozOEyn44m9HoIPfnbuWrLTfhxXULqKb2xGkCN/
        qKrRFKH4BCTWP6EUbVuQ/JpOUBQq6YioRUUqW4fOrG14OXYNTuOOYIhCBBE8BblA
        ==
X-ME-Sender: <xms:_F06XyJvt1KsxUUZUPpI1y7Psf6x698A-2TgzmP4JrFLjkfuO7ZiaQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgoufhushhpvggtthffohhmrghinhculdegledmne
    cujfgurhepuffvhfffkfggtgfgsehtkeertddttdflnecuhfhrohhmpeeoghhrvghgkhhh
    sehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgqeenucggtffrrghtthgvrhhnpeefge
    eugeegkefffeegkeevgeegffegleejkeejkeelueffgeehfeeiudffkeeuhfenucffohhm
    rghinheprghpphhsphhothdrtghomhdpkhgvrhhnvghlrdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:_F06X6L5QD0Vzhloh8IkwCPr1tIG7YFAfn0d8my9iO1Xqp5M2xApjA>
    <xmx:_F06XysuqglYavIahCAgTwvFJWOqr6SSwxVWa-CaKY1oM9xzpkGZlA>
    <xmx:_F06X3a2dyFVBemHeJlJqkW_wsLsDf719AphNPUy5M2RTJJKJdloog>
    <xmx:_F06X4nCn96fJk2_9HWnSDOFX2hMsV10-FY-cvzNbXhdGRj2R6Bj-g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 330B7328005A;
        Mon, 17 Aug 2020 06:37:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] driver core: Fix probe_count imbalance in really_probe()" failed to apply to 4.19-stable tree
To:     penguin-kernel@I-love.SAKURA.ne.jp, geert+renesas@glider.be,
        gregkh@linuxfoundation.org, stable@kernel.org,
        syzbot+805f5f6ae37411f15b64@syzkaller.appspotmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 12:38:03 +0200
Message-ID: <159766068382205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b292b50b0efcc7095d8bf15505fba6909bb35dce Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 13 Jul 2020 11:12:54 +0900
Subject: [PATCH] driver core: Fix probe_count imbalance in really_probe()

syzbot is reporting hung task in wait_for_device_probe() [1]. At least,
we always need to decrement probe_count if we incremented probe_count in
really_probe().

However, since I can't find "Resources present before probing" message in
the console log, both "this message simply flowed off" and "syzbot is not
hitting this path" will be possible. Therefore, while we are at it, let's
also prepare for concurrent wait_for_device_probe() calls by replacing
wake_up() with wake_up_all().

[1] https://syzkaller.appspot.com/bug?id=25c833f1983c9c1d512f4ff860dd0d7f5a2e2c0f

Reported-by: syzbot <syzbot+805f5f6ae37411f15b64@syzkaller.appspotmail.com>
Fixes: 7c35e699c88bd607 ("driver core: Print device when resources present in really_probe()")
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20200713021254.3444-1-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 2306b481109a..fce8e35b6367 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -276,7 +276,7 @@ static void deferred_probe_timeout_work_func(struct work_struct *work)
 
 	list_for_each_entry_safe(private, p, &deferred_probe_pending_list, deferred_probe)
 		dev_info(private->device, "deferred probe pending\n");
-	wake_up(&probe_timeout_waitqueue);
+	wake_up_all(&probe_timeout_waitqueue);
 }
 static DECLARE_DELAYED_WORK(deferred_probe_timeout_work, deferred_probe_timeout_work_func);
 
@@ -498,7 +498,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 		 drv->bus->name, __func__, drv->name, dev_name(dev));
 	if (!list_empty(&dev->devres_head)) {
 		dev_crit(dev, "Resources present before probing\n");
-		return -EBUSY;
+		ret = -EBUSY;
+		goto done;
 	}
 
 re_probe:
@@ -627,7 +628,7 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	ret = 0;
 done:
 	atomic_dec(&probe_count);
-	wake_up(&probe_waitqueue);
+	wake_up_all(&probe_waitqueue);
 	return ret;
 }
 

