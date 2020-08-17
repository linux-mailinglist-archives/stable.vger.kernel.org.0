Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14922464A0
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 12:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgHQKho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 06:37:44 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:44151 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726746AbgHQKhn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 06:37:43 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 84EB61941A5E;
        Mon, 17 Aug 2020 06:37:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 06:37:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5cmJ6p
        M3Ed04f3/00/3X2psP6tLwczVfwgLrbhZsaeI=; b=detM1cNmdKk43iooeUEOYM
        8R89tvcPnTGjNzCH9fvn+hPJbx9WWlYoAh12u1CLwEEN2Bub+ZiuKhpxyBWbjxyd
        T1Yru6GlkyNk8iy6oTiLh0pbt1DwjlaJBuC2g6A+R4tT1H3QMOPQBkfV1AGv8A7Y
        jC+JnYfYuCVB634YPF8eRGlvbUhv+EcjuylXao/+6GS0APDzepYHpDdjHKYG+Lhs
        Ema9Amvv+Xu6mDvgrTt/eqfzhGKqBMZquJMLVyCq138lYBQgcDwKx0OHepuxj178
        NEx6KQyEpI92sBJi5oH/MJoPAdgpD/TC7lNaM46E8Zg+a/amTexbgP2yFnl57ywQ
        ==
X-ME-Sender: <xms:9V06X3Nh2MggL7mfcSh9jaG88Cv-9WUjBPTekOquKfacTY2vetH9OA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgoufhushhpvggtthffohhmrghinhculdegledmne
    cujfgurhepuffvhfffkfggtgfgsehtkeertddttdflnecuhfhrohhmpeeoghhrvghgkhhh
    sehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgqeenucggtffrrghtthgvrhhnpeefge
    eugeegkefffeegkeevgeegffegleejkeejkeelueffgeehfeeiudffkeeuhfenucffohhm
    rghinheprghpphhsphhothdrtghomhdpkhgvrhhnvghlrdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:9V06Xx_sqMM2mkZyYEXx4CekpzuPglsVF9mLAVAISWyYndUPIVMKKg>
    <xmx:9V06X2S7BJkHK-A5g6wRR6FMfqA7PQ-iiw_p-BfMvRy05egKc2Ht2Q>
    <xmx:9V06X7sNcyQswa91rzKlLYIwpEVzVLtXT3T450ePnV08pLHnR6tulQ>
    <xmx:9l06Xwr0h_nbUW9IsIoxXV9IyIdGHglkolR-r9NphTltcG39Dg8LVw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8F37F328005E;
        Mon, 17 Aug 2020 06:37:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] driver core: Fix probe_count imbalance in really_probe()" failed to apply to 4.4-stable tree
To:     penguin-kernel@I-love.SAKURA.ne.jp, geert+renesas@glider.be,
        gregkh@linuxfoundation.org, stable@kernel.org,
        syzbot+805f5f6ae37411f15b64@syzkaller.appspotmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 12:38:00 +0200
Message-ID: <15976606805214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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
 

