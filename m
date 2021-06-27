Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FF93B53BD
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 16:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhF0O0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 10:26:30 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:34873 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230288AbhF0O0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Jun 2021 10:26:30 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 281A21940629;
        Sun, 27 Jun 2021 10:24:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 27 Jun 2021 10:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=bQGZTS
        xl04HeUA6S4AWxPtHz3Nm783yJ5tQFGt48ZhM=; b=sky/CIEN7Ifuz4gBDKlPT2
        F+LRbQzuNy9LitJpM3pAukm4rtflyd+KCLX+o7bOct8pP1x1WB4f/AMj6lCxmLuU
        AyjnSfgbO/iYEvJMp2NZgYAkA31HmyG4oOyg6lgPTNsCo32gK1VzyVCpo0ZvrxV6
        DdcHN3gwtvtL9jc+tmVtxoq3RR4l2dV7JPcaBcsAMrr6YyN/xD0zTEHtKQtYUoJu
        cq00xCNO404kfmQmW2Dv0AKyTdk/tPMnvbIKDcHn3MJQ0rM/o1K2u3sIJOvjY7ar
        yA/3nu9lv6N0qJaD5plO6S9wip7g3kF4vo9MEPFez4tgq1Hkb9eAYdO0s3cIulIw
        ==
X-ME-Sender: <xms:BorYYAsukUkcHyyJiehDpiR0WLTK7x32YQZhDs6Lw1Y34aqHlsr2Aw>
    <xme:BorYYNeYSAavNQql976mTgxEWzWQpJIdjzbASDZhLYjfGy5B33xjQadz2fd72dfgI
    2a_O10W02g1wQ>
X-ME-Received: <xmr:BorYYLyVzjUb_sDxTNBN_dY80JfMvi5ML0TpApZtjUIHZUrMUobp_UF6MYSAbQQtcYq3ORWoeNZR2j8ukzdHZ3zKGoEqqdT9>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehvddgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:BorYYDMVsNkHte0HsckNSdjyJJ-pL_-jDOh5DxhrPbO2d5vDdGMRNQ>
    <xmx:BorYYA-dTOTf11Er3XR3T8TWB3pE2uf9fxCoHEY_aomOaCUuYlZp8g>
    <xmx:BorYYLX1dFZNnWbmfA7boGTM3DfOqB8FrEkYTzw9gTkf0IHteXAvhA>
    <xmx:BorYYB2R4OuDX8ujHtPsoNzW9eYiG0CnW4L6cw27jijVDIYNjMQJeCU-t2Y>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 27 Jun 2021 10:24:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] kthread_worker: split code for canceling the delayed work" failed to apply to 4.19-stable tree
To:     pmladek@suse.com, akpm@linux-foundation.org, jenhaochen@google.com,
        liumartin@google.com, minchan@google.com, nathan@kernel.org,
        ndesaulniers@google.com, oleg@redhat.com, stable@vger.kernel.org,
        tj@kernel.org, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Jun 2021 16:23:55 +0200
Message-ID: <162480383515619@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 34b3d5344719d14fd2185b2d9459b3abcb8cf9d8 Mon Sep 17 00:00:00 2001
From: Petr Mladek <pmladek@suse.com>
Date: Thu, 24 Jun 2021 18:39:45 -0700
Subject: [PATCH] kthread_worker: split code for canceling the delayed work
 timer

Patch series "kthread_worker: Fix race between kthread_mod_delayed_work()
and kthread_cancel_delayed_work_sync()".

This patchset fixes the race between kthread_mod_delayed_work() and
kthread_cancel_delayed_work_sync() including proper return value
handling.

This patch (of 2):

Simple code refactoring as a preparation step for fixing a race between
kthread_mod_delayed_work() and kthread_cancel_delayed_work_sync().

It does not modify the existing behavior.

Link: https://lkml.kernel.org/r/20210610133051.15337-2-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: <jenhaochen@google.com>
Cc: Martin Liu <liumartin@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/kernel/kthread.c b/kernel/kthread.c
index fe3f2a40d61e..121a0e1fc659 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -1092,6 +1092,33 @@ void kthread_flush_work(struct kthread_work *work)
 }
 EXPORT_SYMBOL_GPL(kthread_flush_work);
 
+/*
+ * Make sure that the timer is neither set nor running and could
+ * not manipulate the work list_head any longer.
+ *
+ * The function is called under worker->lock. The lock is temporary
+ * released but the timer can't be set again in the meantime.
+ */
+static void kthread_cancel_delayed_work_timer(struct kthread_work *work,
+					      unsigned long *flags)
+{
+	struct kthread_delayed_work *dwork =
+		container_of(work, struct kthread_delayed_work, work);
+	struct kthread_worker *worker = work->worker;
+
+	/*
+	 * del_timer_sync() must be called to make sure that the timer
+	 * callback is not running. The lock must be temporary released
+	 * to avoid a deadlock with the callback. In the meantime,
+	 * any queuing is blocked by setting the canceling counter.
+	 */
+	work->canceling++;
+	raw_spin_unlock_irqrestore(&worker->lock, *flags);
+	del_timer_sync(&dwork->timer);
+	raw_spin_lock_irqsave(&worker->lock, *flags);
+	work->canceling--;
+}
+
 /*
  * This function removes the work from the worker queue. Also it makes sure
  * that it won't get queued later via the delayed work's timer.
@@ -1106,23 +1133,8 @@ static bool __kthread_cancel_work(struct kthread_work *work, bool is_dwork,
 				  unsigned long *flags)
 {
 	/* Try to cancel the timer if exists. */
-	if (is_dwork) {
-		struct kthread_delayed_work *dwork =
-			container_of(work, struct kthread_delayed_work, work);
-		struct kthread_worker *worker = work->worker;
-
-		/*
-		 * del_timer_sync() must be called to make sure that the timer
-		 * callback is not running. The lock must be temporary released
-		 * to avoid a deadlock with the callback. In the meantime,
-		 * any queuing is blocked by setting the canceling counter.
-		 */
-		work->canceling++;
-		raw_spin_unlock_irqrestore(&worker->lock, *flags);
-		del_timer_sync(&dwork->timer);
-		raw_spin_lock_irqsave(&worker->lock, *flags);
-		work->canceling--;
-	}
+	if (is_dwork)
+		kthread_cancel_delayed_work_timer(work, flags);
 
 	/*
 	 * Try to remove the work from a worker list. It might either

