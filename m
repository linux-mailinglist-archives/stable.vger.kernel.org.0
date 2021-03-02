Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DAE32AFD3
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239203AbhCCA3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:29:00 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:52171 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1443668AbhCBMdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 07:33:14 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id A1A1C19409A5;
        Tue,  2 Mar 2021 07:32:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 02 Mar 2021 07:32:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=piDZ1f
        bDMDw3PKfyKvHldEtTNfNtRxggsBqm4HyULcA=; b=H49e7BV3Ki8fruv9NPmqtO
        G6Hf4L4Q7Pd21Ci/5knyMLjgY3Up0GUe0+6DMbhWLIHX9nQAHN1c4TV+zMM4RJ/r
        3frxiXCixuRJxjiMvB84nBSJCLiI3F2pt3nZv0mNY+u8awSP7s92O3ut8V6KAo6i
        4OEePayccckI/JwFDghB/jydSFkkYO2YL/cIJY/D35KW8Ptk0Rb20isPmX6Fr/4k
        9bENN4VHYVMEr9La0yQx7c9CcIvFRiWL8o6r9rwueYVxAk889wseuOTgRLlToMwZ
        a02909WfkKgC6vAPt3p9bhalPxLhb5ieGA/PuGiDto2Is2RJpvfFzYpZ3mwVfC2Q
        ==
X-ME-Sender: <xms:RjA-YIVMPMC9Qbh_TzHxXpxWa5IRSKV1ZAh2-NKwpCh3iIcquo9a3w>
    <xme:RjA-YHgxOHYrfpHKQh7jBNrBUKkordiP_TOSOVfoyFUbYZntpdkJVkeIKVjp6zyVE
    UsFn2gbP0HCGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddttddggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:RjA-YLZWB4v6DKpcECVfg--wzjqfhIdiI_drLPco6JAEPHoGSBNMUw>
    <xmx:RjA-YMpznYx1CWx76t9hdp64t3PIfICHB8is5Qe1bxsUL3cQbHo3pQ>
    <xmx:RjA-YAOljSo31xdOn-fToy1tjFd16qFV_-dxb-CaeR9NYzmbd3sqnw>
    <xmx:RzA-YNJgf0jV0BRTKrPT7MeT5Ppxd8mZ0L6dw2qFjeBraXrQ9m5_ow>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8E6091080068;
        Tue,  2 Mar 2021 07:32:06 -0500 (EST)
Subject: FAILED: patch "[PATCH] entry: Explicitly flush pending rcuog wakeup before last" failed to apply to 5.10-stable tree
To:     frederic@kernel.org, mingo@kernel.org, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Mar 2021 13:32:04 +0100
Message-ID: <1614688324199209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 47b8ff194c1fd73d58dc339b597d466fe48c8958 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <frederic@kernel.org>
Date: Mon, 1 Feb 2021 00:05:47 +0100
Subject: [PATCH] entry: Explicitly flush pending rcuog wakeup before last
 rescheduling point

Following the idle loop model, cleanly check for pending rcuog wakeup
before the last rescheduling point on resuming to user mode. This
way we can avoid to do it from rcu_user_enter() with the last resort
self-IPI hack that enforces rescheduling.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210131230548.32970-5-frederic@kernel.org

diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index f09cae37ddd5..8442e5c9cfa2 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -184,6 +184,10 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 		 * enabled above.
 		 */
 		local_irq_disable_exit_to_user();
+
+		/* Check if any of the above work has queued a deferred wakeup */
+		rcu_nocb_flush_deferred_wakeup();
+
 		ti_work = READ_ONCE(current_thread_info()->flags);
 	}
 
@@ -197,6 +201,9 @@ static void exit_to_user_mode_prepare(struct pt_regs *regs)
 
 	lockdep_assert_irqs_disabled();
 
+	/* Flush pending rcuog wakeup before the last need_resched() check */
+	rcu_nocb_flush_deferred_wakeup();
+
 	if (unlikely(ti_work & EXIT_TO_USER_MODE_WORK))
 		ti_work = exit_to_user_mode_loop(regs, ti_work);
 
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 4b1e5bd16492..2ebc211fffcb 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -707,13 +707,15 @@ noinstr void rcu_user_enter(void)
 	lockdep_assert_irqs_disabled();
 
 	/*
-	 * We may be past the last rescheduling opportunity in the entry code.
-	 * Trigger a self IPI that will fire and reschedule once we resume to
-	 * user/guest mode.
+	 * Other than generic entry implementation, we may be past the last
+	 * rescheduling opportunity in the entry code. Trigger a self IPI
+	 * that will fire and reschedule once we resume in user/guest mode.
 	 */
 	instrumentation_begin();
-	if (do_nocb_deferred_wakeup(rdp) && need_resched())
-		irq_work_queue(this_cpu_ptr(&late_wakeup_work));
+	if (!IS_ENABLED(CONFIG_GENERIC_ENTRY) || (current->flags & PF_VCPU)) {
+		if (do_nocb_deferred_wakeup(rdp) && need_resched())
+			irq_work_queue(this_cpu_ptr(&late_wakeup_work));
+	}
 	instrumentation_end();
 
 	rcu_eqs_enter(true);

