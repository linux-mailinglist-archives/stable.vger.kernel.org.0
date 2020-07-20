Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CA8225E2E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgGTMIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:08:19 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:55099 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728633AbgGTMIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 08:08:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id C28BE1940AA7;
        Mon, 20 Jul 2020 08:08:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 20 Jul 2020 08:08:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=lRVXu2
        PFAl4kHe8Lb+CR4CaRcdM3x3SAPr+Fb/rbtek=; b=h27/zH5TRqCs/QFXlyoIGF
        OygS0BUdXo9qNABCrAZn0bEQn5cTE59g9dLFhUao/NglQIplF5GE56N8B53y+ae7
        zULohOWdhsQQ1KbBHqoFhPSS7aheicXhViTMMPR/amel/06O7PT8jwcnB4p8+Dby
        psd6nGRXE7tmpy6q4+bYwZzI7V8kE1ndOp48jig90jRCUlZEFoapFB5XWpjrHC8O
        wfJVVJpErxyuQgfEbUwI4IlfCw4D98mXnoRrF+QKJiwHFiyCz2jVTh6Xz4Rjhnu8
        G4OjdbVmmuqflm2sEUVsnBiITVtrACWyjSBtXIhwZFZXrdWLyf0aA8wv5q+oWggw
        ==
X-ME-Sender: <xms:MYkVX9RPKCGKK_52xnnAnsPpQzQPsKrmTYIDOBaJP93zQC-SgdMqXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeeggddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:MYkVX2yRSA2EIhRcU7MH2pSgdfe2VmG3c8NNsNaUo6kluIW5x_Zz6g>
    <xmx:MYkVXy1LfYnZKGUfkj8o1aZpCIhmT5WTafMxs83jROhIY4ud_lc-5Q>
    <xmx:MYkVX1DcQrQvSUwqD3icxTVF0zIFPxRhB9ccdNUI4Ns6TEfSLPkTaw>
    <xmx:MYkVX7Zus-Gnex9Of1q4_aD0d1EpQlXKnJQjukuOkiqQhJBEdPyeL9GK4cU>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 480A63280064;
        Mon, 20 Jul 2020 08:08:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] timers: Forward the wheel clock whenever possible" failed to apply to 4.9-stable tree
To:     tglx@linutronix.de, arjan@infradead.org, clm@fb.com,
        edumazet@google.com, fweisbec@gmail.com, josh@joshtriplett.org,
        lenb@kernel.org, linux@sciencehorizons.net, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org, riel@redhat.com,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 14:08:20 +0200
Message-ID: <159524690091121@kroah.com>
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

From a683f390b93f4d1292f849fc48d28e322046120f Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 4 Jul 2016 09:50:36 +0000
Subject: [PATCH] timers: Forward the wheel clock whenever possible

The wheel clock is stale when a CPU goes into a long idle sleep. This has the
side effect that timers which are queued end up in the outer wheel levels.
That results in coarser granularity.

To solve this, we keep track of the idle state and forward the wheel clock
whenever possible.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Chris Mason <clm@fb.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: George Spelvin <linux@sciencehorizons.net>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: rt@linutronix.de
Link: http://lkml.kernel.org/r/20160704094342.512039360@linutronix.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 966a5a6fdd0a..f738251000fe 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -164,3 +164,4 @@ static inline void timers_update_migration(bool update_nohz) { }
 DECLARE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases);
 
 extern u64 get_next_timer_interrupt(unsigned long basej, u64 basem);
+void timer_clear_idle(void);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 69abc7bfe80f..5d81f9aa30d2 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -700,6 +700,12 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 	delta = next_tick - basemono;
 	if (delta <= (u64)TICK_NSEC) {
 		tick.tv64 = 0;
+
+		/*
+		 * Tell the timer code that the base is not idle, i.e. undo
+		 * the effect of get_next_timer_interrupt():
+		 */
+		timer_clear_idle();
 		/*
 		 * We've not stopped the tick yet, and there's a timer in the
 		 * next period, so no point in stopping it either, bail.
@@ -809,6 +815,12 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 	tick_do_update_jiffies64(now);
 	cpu_load_update_nohz_stop();
 
+	/*
+	 * Clear the timer idle flag, so we avoid IPIs on remote queueing and
+	 * the clock forward checks in the enqueue path:
+	 */
+	timer_clear_idle();
+
 	calc_load_exit_idle();
 	touch_softlockup_watchdog_sched();
 	/*
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 658051c97a3c..9339d71ee998 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -196,9 +196,11 @@ struct timer_base {
 	spinlock_t		lock;
 	struct timer_list	*running_timer;
 	unsigned long		clk;
+	unsigned long		next_expiry;
 	unsigned int		cpu;
 	bool			migration_enabled;
 	bool			nohz_active;
+	bool			is_idle;
 	DECLARE_BITMAP(pending_map, WHEEL_SIZE);
 	struct hlist_head	vectors[WHEEL_SIZE];
 } ____cacheline_aligned;
@@ -519,24 +521,37 @@ static void internal_add_timer(struct timer_base *base, struct timer_list *timer
 {
 	__internal_add_timer(base, timer);
 
+	if (!IS_ENABLED(CONFIG_NO_HZ_COMMON) || !base->nohz_active)
+		return;
+
 	/*
-	 * Check whether the other CPU is in dynticks mode and needs
-	 * to be triggered to reevaluate the timer wheel.  We are
-	 * protected against the other CPU fiddling with the timer by
-	 * holding the timer base lock. This also makes sure that a
-	 * CPU on the way to stop its tick can not evaluate the timer
-	 * wheel.
-	 *
-	 * Spare the IPI for deferrable timers on idle targets though.
-	 * The next busy ticks will take care of it. Except full dynticks
-	 * require special care against races with idle_cpu(), lets deal
-	 * with that later.
+	 * TODO: This wants some optimizing similar to the code below, but we
+	 * will do that when we switch from push to pull for deferrable timers.
 	 */
-	if (IS_ENABLED(CONFIG_NO_HZ_COMMON) && base->nohz_active) {
-		if (!(timer->flags & TIMER_DEFERRABLE) ||
-		    tick_nohz_full_cpu(base->cpu))
+	if (timer->flags & TIMER_DEFERRABLE) {
+		if (tick_nohz_full_cpu(base->cpu))
 			wake_up_nohz_cpu(base->cpu);
+		return;
 	}
+
+	/*
+	 * We might have to IPI the remote CPU if the base is idle and the
+	 * timer is not deferrable. If the other CPU is on the way to idle
+	 * then it can't set base->is_idle as we hold the base lock:
+	 */
+	if (!base->is_idle)
+		return;
+
+	/* Check whether this is the new first expiring timer: */
+	if (time_after_eq(timer->expires, base->next_expiry))
+		return;
+
+	/*
+	 * Set the next expiry time and kick the CPU so it can reevaluate the
+	 * wheel:
+	 */
+	base->next_expiry = timer->expires;
+	wake_up_nohz_cpu(base->cpu);
 }
 
 #ifdef CONFIG_TIMER_STATS
@@ -844,10 +859,11 @@ static inline struct timer_base *get_timer_base(u32 tflags)
 	return get_timer_cpu_base(tflags, tflags & TIMER_CPUMASK);
 }
 
-static inline struct timer_base *get_target_base(struct timer_base *base,
-						 unsigned tflags)
+#ifdef CONFIG_NO_HZ_COMMON
+static inline struct timer_base *
+__get_target_base(struct timer_base *base, unsigned tflags)
 {
-#if defined(CONFIG_NO_HZ_COMMON) && defined(CONFIG_SMP)
+#ifdef CONFIG_SMP
 	if ((tflags & TIMER_PINNED) || !base->migration_enabled)
 		return get_timer_this_cpu_base(tflags);
 	return get_timer_cpu_base(tflags, get_nohz_timer_target());
@@ -856,6 +872,43 @@ static inline struct timer_base *get_target_base(struct timer_base *base,
 #endif
 }
 
+static inline void forward_timer_base(struct timer_base *base)
+{
+	/*
+	 * We only forward the base when it's idle and we have a delta between
+	 * base clock and jiffies.
+	 */
+	if (!base->is_idle || (long) (jiffies - base->clk) < 2)
+		return;
+
+	/*
+	 * If the next expiry value is > jiffies, then we fast forward to
+	 * jiffies otherwise we forward to the next expiry value.
+	 */
+	if (time_after(base->next_expiry, jiffies))
+		base->clk = jiffies;
+	else
+		base->clk = base->next_expiry;
+}
+#else
+static inline struct timer_base *
+__get_target_base(struct timer_base *base, unsigned tflags)
+{
+	return get_timer_this_cpu_base(tflags);
+}
+
+static inline void forward_timer_base(struct timer_base *base) { }
+#endif
+
+static inline struct timer_base *
+get_target_base(struct timer_base *base, unsigned tflags)
+{
+	struct timer_base *target = __get_target_base(base, tflags);
+
+	forward_timer_base(target);
+	return target;
+}
+
 /*
  * We are using hashed locking: Holding per_cpu(timer_bases[x]).lock means
  * that all timers which are tied to this base are locked, and the base itself
@@ -1417,16 +1470,49 @@ u64 get_next_timer_interrupt(unsigned long basej, u64 basem)
 
 	spin_lock(&base->lock);
 	nextevt = __next_timer_interrupt(base);
-	spin_unlock(&base->lock);
+	base->next_expiry = nextevt;
+	/*
+	 * We have a fresh next event. Check whether we can forward the base:
+	 */
+	if (time_after(nextevt, jiffies))
+		base->clk = jiffies;
+	else if (time_after(nextevt, base->clk))
+		base->clk = nextevt;
 
-	if (time_before_eq(nextevt, basej))
+	if (time_before_eq(nextevt, basej)) {
 		expires = basem;
-	else
+		base->is_idle = false;
+	} else {
 		expires = basem + (nextevt - basej) * TICK_NSEC;
+		/*
+		 * If we expect to sleep more than a tick, mark the base idle:
+		 */
+		if ((expires - basem) > TICK_NSEC)
+			base->is_idle = true;
+	}
+	spin_unlock(&base->lock);
 
 	return cmp_next_hrtimer_event(basem, expires);
 }
 
+/**
+ * timer_clear_idle - Clear the idle state of the timer base
+ *
+ * Called with interrupts disabled
+ */
+void timer_clear_idle(void)
+{
+	struct timer_base *base = this_cpu_ptr(&timer_bases[BASE_STD]);
+
+	/*
+	 * We do this unlocked. The worst outcome is a remote enqueue sending
+	 * a pointless IPI, but taking the lock would just make the window for
+	 * sending the IPI a few instructions smaller for the cost of taking
+	 * the lock in the exit from idle path.
+	 */
+	base->is_idle = false;
+}
+
 static int collect_expired_timers(struct timer_base *base,
 				  struct hlist_head *heads)
 {
@@ -1440,7 +1526,7 @@ static int collect_expired_timers(struct timer_base *base,
 
 		/*
 		 * If the next timer is ahead of time forward to current
-		 * jiffies, otherwise forward to the next expiry time.
+		 * jiffies, otherwise forward to the next expiry time:
 		 */
 		if (time_after(next, jiffies)) {
 			/* The call site will increment clock! */

