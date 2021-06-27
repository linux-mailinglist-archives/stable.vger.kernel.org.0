Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D31B3B53BC
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 16:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhF0O03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 10:26:29 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:55525 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230288AbhF0O02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Jun 2021 10:26:28 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 61D1C194062C;
        Sun, 27 Jun 2021 10:24:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 27 Jun 2021 10:24:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/War6s
        qaWIl7iBI9RyaW2fi2jxtJospEDF0jAMINXj0=; b=m1QR5E7HYZW+GWBxYcKmuV
        R181xTFhf6OqvrCIr1maehvt0QYs+l82vGhHNBwJR3AVMkSoZXAEJ0XaCusX/BSl
        RglGoa8+4p+vo4TRvTVgATkJm0EjkqSeZfNWZ1BsQAGkdWr2vEOs2Bl+BLiBhDMC
        PAF8sw5cyFmWDLKUPU26jDx6sc+VbRx03n5q/um6gXPJvfrq5A+MY9gSkxwVKdeW
        Soe8BNos+j//zj2kdk7BVoU8UN00Z03o0y0mI/tcI+p83KHPcI6HrCmirGsbTdeV
        FEPs/QVOyKr1BpEDSp9K4f8aTVqQWMwBcnYIFZN9/E5Sc2bh4PdyE/Eo0+qTinvA
        ==
X-ME-Sender: <xms:BIrYYF9f-e5R2lB7j2RbSfV_FtuqPdJH7WXoeH6UD5KoIvXiS5WS9A>
    <xme:BIrYYJsRZ2FbbMEbVUuivQJFvabmJ5g_C8Xhp0JktSezf_bDlH19aLsgD6xCjpDFm
    SzP9kyWIhGebA>
X-ME-Received: <xmr:BIrYYDAZ-K608HTJwVgrD_GlAvsjm8RwAFyDb3PuZPibgrXdFhFHH2jtbHKjYAm6jm6XhEov8_UhImVSEGyB-G-RSCI6UYnx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehvddgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:BIrYYJdFZ4PdgtqpjwuF4vNhbv8irgGm4oVFQBszNsWZQvVKrRxN9w>
    <xmx:BIrYYKMP9hB9q8GC4RofDU4xvbbwIquUDxGhk_ZPitoexHHYghkQQg>
    <xmx:BIrYYLm2-48hbFWSdbrNuiqXG2hZx9kwvBZq9kx_BjJ9mU_C39WaHA>
    <xmx:BIrYYLHQ2wA0UGfpRWEpVec4C7yDSUOwaSpX6ORpHH8mTXwQ8RkFklrwvNA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 27 Jun 2021 10:24:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] kthread_worker: split code for canceling the delayed work" failed to apply to 4.14-stable tree
To:     pmladek@suse.com, akpm@linux-foundation.org, jenhaochen@google.com,
        liumartin@google.com, minchan@google.com, nathan@kernel.org,
        ndesaulniers@google.com, oleg@redhat.com, stable@vger.kernel.org,
        tj@kernel.org, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Jun 2021 16:23:54 +0200
Message-ID: <1624803834160108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

