Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAD8327D47
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbhCALbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:31:04 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:39165 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233724AbhCALax (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:30:53 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 497DD1941489;
        Mon,  1 Mar 2021 06:29:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 06:29:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Vfy8qZ
        ncdjOgGZ6ChAYFEk97ypXyx3AsCJXpBM+aqE0=; b=r0bCsDRtcru294ZyRAjIFA
        wsXR/egPo/7TkktMgTSthd6j4vVuS8Hrg6uhTSnwA6npCRrN+uyK5TvHEFARUP/j
        kGCPAtDCZn1x6zdZ1I6JLxFnjSYKbfrp4QblcokgC2POhVNZll/kXDzuvnw1svMq
        zhZ1fht0+CbS65BKm6jF2C0DH3rP2tWm1SDPY5WzYRqck2jxg9NySFGLUN5ZLQ2l
        CfekVw+ksjXvShLPXEhtOl7qbgAi7/UtFAasazlxGCooR+sew1WZcVgHBxiymuFy
        codbGX/I1bIiUQu+fxQJiDM2M1q3KBEhfl9eoYXkLSoPUsV4OVx0QIfvgviZ/7Ag
        ==
X-ME-Sender: <xms:JdA8YLc9YNS7xnHi0IEfLKGp6wr9K6vfYcxodmS-v809u_aLRHZ3EQ>
    <xme:JdA8YBPNFsPlHUqDdT93VeYW6UHLWQ3WAskUH-mo-0f2JmU7MvuGlKag7EUf9vp_x
    eU4JUvFipZftA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudegnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:JdA8YEi72Au5IdGRfkpEirbi8gcwUjwbXPPz5VSXDHZw_eGMR9oQrw>
    <xmx:JdA8YM_ZzR6NaWg7hWQ77YA6_or72vKKQAu9oQfPnCsYVIU9zj3HFQ>
    <xmx:JdA8YHt7bZgB0X4CByqx-xmjQM2XPkTnx8MjglQbgtPKR4E2IpfYmw>
    <xmx:JdA8YAWwEvpiB46VbPCDru5fUHYdzprArmZab9E9SP0YJequoOWIjA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EBA4B240054;
        Mon,  1 Mar 2021 06:29:40 -0500 (EST)
Subject: FAILED: patch "[PATCH] entry: Explicitly flush pending rcuog wakeup before last" failed to apply to 4.14-stable tree
To:     frederic@kernel.org, mingo@kernel.org, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 12:29:33 +0100
Message-ID: <161459817371188@kroah.com>
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

