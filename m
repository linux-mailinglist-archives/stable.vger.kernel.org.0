Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7D532AFBB
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238742AbhCCA20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:28:26 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:36643 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1383905AbhCBMc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 07:32:29 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9ACC61940E99;
        Tue,  2 Mar 2021 07:30:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 02 Mar 2021 07:30:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZFMDMc
        gtg9XAfPABYSFQs+fmVSUElik1k0MS5t3hzNg=; b=f8AL7MlaDBrOGUHPAyJA7J
        9ONYZnaH+UdQUZusTPMaoGTVFgyS5P3EmoToP5jSJeefqq5G+YhaMteIY+Vb5c+l
        WSCE7giKnAX+5bm/obPuScSjK34c1NYTDjsAyCVnJYzOWKErwLbeW+cP/QPfQTLr
        on5n2xH1Qgfdr/5vLpxg2ATfGZ0wkZ7i4MrcQadtCqIthvNrxpOfXVpTDkwfIHF2
        EUxUtnjteMTbTts0QmCqkiHxq6dV30uIy4v7x40joMuop3Dwr3IWVWJYB6qjeKVC
        RKkD5QUMmwGbF4D9ccFjODZswCCgCEhU4lV5uLJ5GfLxy/YJhGa93i5VEj+MgPPA
        ==
X-ME-Sender: <xms:8S8-YEtWeqb-47yuziHuBl9vxO5nk-RngqBG1upI3pOeHFicDqKItg>
    <xme:8S8-YBc8uKqt-PCGKKpuqEORWox_lGaISrJrEiiB7kqFhGyy1HpOQWJ07PWSi98rd
    4wtFdRs4mGDow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddttddggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:8S8-YPyXAoUNbj3V_HCQ-pYEU2LUfNNdjU1PIFo8B-4mz3kucFw-2Q>
    <xmx:8S8-YHOK2t-Hdj4Emf_BunL_iBHjovQ0zIbNhtkTyrp8WKDdeVfphA>
    <xmx:8S8-YE8JuEAB02GzzhKCQMDxlXXewX3Z8U8g-Jzkb0kkN-a9rTLXMQ>
    <xmx:8i8-YGJRt8tjVgVeWE43pvBj7Xy-oymtGNmcL0pM8J6emgmnF7h0wg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 89FF024005B;
        Tue,  2 Mar 2021 07:30:41 -0500 (EST)
Subject: FAILED: patch "[PATCH] rcu/nocb: Trigger self-IPI on late deferred wake up before" failed to apply to 5.4-stable tree
To:     frederic@kernel.org, mingo@kernel.org, paulmck@kernel.org,
        peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Mar 2021 13:30:39 +0100
Message-ID: <161468823919340@kroah.com>
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

