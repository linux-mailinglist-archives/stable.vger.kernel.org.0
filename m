Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D232464A1
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 12:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgHQKhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 06:37:46 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:35535 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726830AbgHQKhp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 06:37:45 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id ACE1D1941B24;
        Mon, 17 Aug 2020 06:37:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 06:37:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=PKtTjE
        tLKjuluzClGpPel3VtlueoUdtPFkke/hg0h/Q=; b=MWrzDuL1HXNYApeZVfqq9t
        Koi+fQgUvNOk9qXuYLhTBd6Ay/HNIPoMZoFtq3s0z7RK4LNnLwj+7h/foHb70s7b
        hFPQ6coJjhhB07NCpV4ZL8mBXgybA1CDCxKSX9ZZEU6GCo1gux/04lfUSwGlQbrk
        EdRgjzToz3zyRE2X8U1ZIN4MZQoKheXPVNqukA1TMnLR0iFZE2Bk7ZyqON6Kp3zO
        FZZitk2/vDb7dyTE6mTm2PTQbhOCQVv7P5mIE3yd9cOCdv972USSiMbQ2mKQo2ju
        3cfs/f72aSHG/92S8XBs90eg8zBL9+zEHqOB/RI/j6UBlPWYNc1daGEdXrx2u7zw
        ==
X-ME-Sender: <xms:9106Xxd3uO1oE10l2dCzRzDa7RotAQOHTUSPKFkJasBIsGP0oNQCOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgoufhushhpvggtthffohhmrghinhculdegledmne
    cujfgurhepuffvhfffkfggtgfgsehtkeertddttdflnecuhfhrohhmpeeoghhrvghgkhhh
    sehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgqeenucggtffrrghtthgvrhhnpeefge
    eugeegkefffeegkeevgeegffegleejkeejkeelueffgeehfeeiudffkeeuhfenucffohhm
    rghinheprghpphhsphhothdrtghomhdpkhgvrhhnvghlrdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:9106X_N6s_UF_lm6ZqkWmsF_r0RAY5bnxwnPZ2Mz4Ga_wG1ASbxZdA>
    <xmx:9106X6gDRud_G0m6zwo38JvDR1-mFF6nDGbyEUSLYbGtDTbkZFtJJw>
    <xmx:9106X6_q27MT04k8WFpyUlmdATaKS5HSgiz5TX7RScHGT-fOhDx-9w>
    <xmx:9106X25Y4bVi2-EFkZTEjsHGgNz5LrumbGijvIlWYrd-g-DR8eBhbw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 40026328005A;
        Mon, 17 Aug 2020 06:37:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] driver core: Fix probe_count imbalance in really_probe()" failed to apply to 4.9-stable tree
To:     penguin-kernel@I-love.SAKURA.ne.jp, geert+renesas@glider.be,
        gregkh@linuxfoundation.org, stable@kernel.org,
        syzbot+805f5f6ae37411f15b64@syzkaller.appspotmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 12:38:01 +0200
Message-ID: <1597660681240171@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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
 

