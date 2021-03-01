Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25D0327D42
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbhCALaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:30:07 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:37987 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233661AbhCAL3z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:29:55 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 433BE1941406;
        Mon,  1 Mar 2021 06:28:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 06:28:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EpVxgq
        rg4IRTiQW5/BJW5kDux5DdqVpDr+50oTiT0ao=; b=FIyU33l2xVdf0xmNt+q9e7
        cuyWUF8avBVY89eJRSBtDUDl7cxTKej7FwMNH7sBxz3jjO+RmbKOm8CBIIRm+ZvS
        RGtNZ92fK0n/tgkYZlJJVA799T1bDLSRfPTWnu5afs4n/i2VlhQ9GNEzUgpFqstu
        ejuiRtFqRMlPZXvAzjUT9J+6T2eVwAbd4TVp+Hg0TtmvTsp1SVxAN8/cqCaIgKKi
        /wn0MABmJTOepl/WhA1rfV8hfABWIEEBpvLteWPjZwn2lpzoXogmNzvGlqr7puiP
        lkRg6rh2mwZXhVfnWiAWDYGDD3K7wAbBWW7o2XjRN4jZ3c9c5r7bo5wXonpbK9KQ
        ==
X-ME-Sender: <xms:2M88YDz3w_-kzgsith71GES1x-n6N4rUuWAV1_8TWEmyHKbRcRFHdw>
    <xme:2M88YLRI1jHzhwXkvCa0Suh8YLf8EvlmfKnI5kulDuN7hQgsA7t5ZNsWGcXKy_FKR
    IhYoDsT6KZf_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepjeenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:2M88YNUE39KWXLbk6XabDgiSwF_czSB2QAynzeaV4_7u2cBehTQpCw>
    <xmx:2M88YNjYi5axyFKy_lHB6CuXiviR1ZIlsjMtZuGMSjqXv1xSwkQibw>
    <xmx:2M88YFAowTF62w151RijCJhix3aCBepkGhKr9Uxs4d1Ej3aglTe76w>
    <xmx:2M88YIPvSqI8mbr2T-4KJlYUflyEQpgzf-UukfmD_w5iEJDfMeAe2A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E1A5324005A;
        Mon,  1 Mar 2021 06:28:23 -0500 (EST)
Subject: FAILED: patch "[PATCH] rcu/nocb: Trigger self-IPI on late deferred wake up before" failed to apply to 4.9-stable tree
To:     frederic@kernel.org, mingo@kernel.org, paulmck@kernel.org,
        peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 12:28:21 +0100
Message-ID: <16145981019961@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From f8bb5cae9616224a39cbb399de382d36ac41df10 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <frederic@kernel.org>
Date: Mon, 1 Feb 2021 00:05:46 +0100
Subject: [PATCH] rcu/nocb: Trigger self-IPI on late deferred wake up before
 user resume

Entering RCU idle mode may cause a deferred wake up of an RCU NOCB_GP
kthread (rcuog) to be serviced.

Unfortunately the call to rcu_user_enter() is already past the last
rescheduling opportunity before we resume to userspace or to guest mode.
We may escape there with the woken task ignored.

The ultimate resort to fix every callsites is to trigger a self-IPI
(nohz_full depends on arch to implement arch_irq_work_raise()) that will
trigger a reschedule on IRQ tail or guest exit.

Eventually every site that want a saner treatment will need to carefully
place a call to rcu_nocb_flush_deferred_wakeup() before the last explicit
need_resched() check upon resume.

Fixes: 96d3fd0d315a (rcu: Break call_rcu() deadlock involving scheduler and perf)
Reported-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210131230548.32970-4-frederic@kernel.org

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 82838e93b498..4b1e5bd16492 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -677,6 +677,18 @@ void rcu_idle_enter(void)
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
 
 #ifdef CONFIG_NO_HZ_FULL
+
+/*
+ * An empty function that will trigger a reschedule on
+ * IRQ tail once IRQs get re-enabled on userspace resume.
+ */
+static void late_wakeup_func(struct irq_work *work)
+{
+}
+
+static DEFINE_PER_CPU(struct irq_work, late_wakeup_work) =
+	IRQ_WORK_INIT(late_wakeup_func);
+
 /**
  * rcu_user_enter - inform RCU that we are resuming userspace.
  *
@@ -694,12 +706,19 @@ noinstr void rcu_user_enter(void)
 
 	lockdep_assert_irqs_disabled();
 
+	/*
+	 * We may be past the last rescheduling opportunity in the entry code.
+	 * Trigger a self IPI that will fire and reschedule once we resume to
+	 * user/guest mode.
+	 */
 	instrumentation_begin();
-	do_nocb_deferred_wakeup(rdp);
+	if (do_nocb_deferred_wakeup(rdp) && need_resched())
+		irq_work_queue(this_cpu_ptr(&late_wakeup_work));
 	instrumentation_end();
 
 	rcu_eqs_enter(true);
 }
+
 #endif /* CONFIG_NO_HZ_FULL */
 
 /**
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 7708ed161f4a..9226f4021a36 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -433,7 +433,7 @@ static bool rcu_nocb_try_bypass(struct rcu_data *rdp, struct rcu_head *rhp,
 static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_empty,
 				 unsigned long flags);
 static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp);
-static void do_nocb_deferred_wakeup(struct rcu_data *rdp);
+static bool do_nocb_deferred_wakeup(struct rcu_data *rdp);
 static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_cpu_nocb_kthread(int cpu);
 static void __init rcu_spawn_nocb_kthreads(void);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index d5b38c28abd1..384856e4d13e 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1631,8 +1631,8 @@ bool rcu_is_nocb_cpu(int cpu)
  * Kick the GP kthread for this NOCB group.  Caller holds ->nocb_lock
  * and this function releases it.
  */
-static void wake_nocb_gp(struct rcu_data *rdp, bool force,
-			   unsigned long flags)
+static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
+			 unsigned long flags)
 	__releases(rdp->nocb_lock)
 {
 	bool needwake = false;
@@ -1643,7 +1643,7 @@ static void wake_nocb_gp(struct rcu_data *rdp, bool force,
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu,
 				    TPS("AlreadyAwake"));
 		rcu_nocb_unlock_irqrestore(rdp, flags);
-		return;
+		return false;
 	}
 	del_timer(&rdp->nocb_timer);
 	rcu_nocb_unlock_irqrestore(rdp, flags);
@@ -1656,6 +1656,8 @@ static void wake_nocb_gp(struct rcu_data *rdp, bool force,
 	raw_spin_unlock_irqrestore(&rdp_gp->nocb_gp_lock, flags);
 	if (needwake)
 		wake_up_process(rdp_gp->nocb_gp_kthread);
+
+	return needwake;
 }
 
 /*
@@ -2152,20 +2154,23 @@ static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
 }
 
 /* Do a deferred wakeup of rcu_nocb_kthread(). */
-static void do_nocb_deferred_wakeup_common(struct rcu_data *rdp)
+static bool do_nocb_deferred_wakeup_common(struct rcu_data *rdp)
 {
 	unsigned long flags;
 	int ndw;
+	int ret;
 
 	rcu_nocb_lock_irqsave(rdp, flags);
 	if (!rcu_nocb_need_deferred_wakeup(rdp)) {
 		rcu_nocb_unlock_irqrestore(rdp, flags);
-		return;
+		return false;
 	}
 	ndw = READ_ONCE(rdp->nocb_defer_wakeup);
 	WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
-	wake_nocb_gp(rdp, ndw == RCU_NOCB_WAKE_FORCE, flags);
+	ret = wake_nocb_gp(rdp, ndw == RCU_NOCB_WAKE_FORCE, flags);
 	trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("DeferredWake"));
+
+	return ret;
 }
 
 /* Do a deferred wakeup of rcu_nocb_kthread() from a timer handler. */
@@ -2181,10 +2186,11 @@ static void do_nocb_deferred_wakeup_timer(struct timer_list *t)
  * This means we do an inexact common-case check.  Note that if
  * we miss, ->nocb_timer will eventually clean things up.
  */
-static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
+static bool do_nocb_deferred_wakeup(struct rcu_data *rdp)
 {
 	if (rcu_nocb_need_deferred_wakeup(rdp))
-		do_nocb_deferred_wakeup_common(rdp);
+		return do_nocb_deferred_wakeup_common(rdp);
+	return false;
 }
 
 void rcu_nocb_flush_deferred_wakeup(void)
@@ -2523,8 +2529,9 @@ static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
 	return false;
 }
 
-static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
+static bool do_nocb_deferred_wakeup(struct rcu_data *rdp)
 {
+	return false;
 }
 
 static void rcu_spawn_cpu_nocb_kthread(int cpu)

