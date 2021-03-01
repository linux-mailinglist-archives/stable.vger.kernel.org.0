Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6D9327D4B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhCALbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:31:19 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:46003 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232676AbhCALbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:31:16 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 00409194148F;
        Mon,  1 Mar 2021 06:29:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 06:29:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=2plbD+
        q46tZP67mz/FqmKonz8qabgeBs/S8MqKJym1k=; b=BRNYGYENQmYLa5qTIyi0k8
        Bkqg6zTKFaE+uOrvcWeWoaYJAM3LkBQLVUOwjO5Lzp9nfGnrtZbzC+OGiIJ1NbP7
        yZJKPIEWBq1ouMVFHu1EmWTvg3rr8mZipoLKho2F/7zeFbAZlUMHd7AK39daZ6O/
        hOD+0c43y239Ey5Muh6WV9qWYog4Hd5dPFaMe1wFS9KMWIVXumYYtaoEO9cEMfkC
        URjh18SBcnWGs6km9b7Re1SXa5c5ElqA8svT9fApDrjA5o0FYZjPcfxj4uHmGml/
        p2vqN6IqDmlHvv97M8VCbZTIyXArP3Rx8TM4orhYClOGF5H5kw1Z8EoJSEgg5lFg
        ==
X-ME-Sender: <xms:JtA8YJbd3pTowNcK8iPssNV_9zMpm2LY1mAZZs3Z-IOYxoIxI7DLyw>
    <xme:JtA8YAY5N0AhjAEVJCsSEZuMlmyFjY0Y0fzgoUPjCtbbzXSAbasbFoePWx-4-3yCu
    qwAsz_MuS03Uw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudegnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:JtA8YL8Dp7GROn5l7-ldCpzl7H4rH4SxK1Eq1CqFOOL4WGJkqrKi2w>
    <xmx:JtA8YHqecQzgFoIttru9bcpt5uzrM8xT5iy5YLH_fkU97d0MQ3GPEg>
    <xmx:JtA8YErafYFyIIjxuiw2w2CSE2XzyiQBm2Jk-DDZJ2u4lWdeVPUwPw>
    <xmx:JtA8YBA_DPVwPGQa1nW7MW3zplhjltJsDS3pawqGZAlzt2GTl0MuQw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A341F1080057;
        Mon,  1 Mar 2021 06:29:42 -0500 (EST)
Subject: FAILED: patch "[PATCH] entry: Explicitly flush pending rcuog wakeup before last" failed to apply to 5.4-stable tree
To:     frederic@kernel.org, mingo@kernel.org, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 12:29:34 +0100
Message-ID: <161459817451216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

