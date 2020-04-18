Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902931AEBA7
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 12:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgDRKVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 06:21:53 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:35879 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725891AbgDRKVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Apr 2020 06:21:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 05B3E67B;
        Sat, 18 Apr 2020 06:21:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 18 Apr 2020 06:21:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1/5EIM
        uvqCqGKnNg/wZocdHuILsRRaDWjaZsEhYuy7I=; b=iP12NYZ9uk0+Xflw5L4X2+
        /Y6caiaexvNpUNs4YyiYKwIDgbYgR4Lk3Hi4WtuiYsO8LSv95NcFiwvlvLho1zi6
        CBKIPB2OQIjL2CLyKbeoL8l9O7CFTa5y4YxykohJUYfTLiW8w6tLRTPjW1QmADDU
        4MrlPKLm6fZEkzB09p9YU4PvgcJsM+0JtartlZXIDku4H3mZvv/wgz66WqEWlMtw
        bFbNZ5uEm8qG9IZayrM7C8mT2Gn4rCFQkJBVO4JLNZx2OmM9Ri/oo2dNFSK/qNv9
        NYVzB2xQesupmveTGvksOuWGfGtrjkL6dG18jbIJSJ0d76823/Z/ih3WcH23hCyw
        ==
X-ME-Sender: <xms:ktSaXmEBfHeNFq_KoncfFXiO21wvd9bSvpMJvadKJBanB65oPsS1jw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeelgddvlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdgtphhurdhpihgunecukfhppeekfe
    drkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ktSaXi5jh3LPepD7fRaYF7KGhUQYuDvH3CQaQr1T0pSImKi7ozVcsQ>
    <xmx:ktSaXgIrI4c2VSxV2tTvwbpM9CxHsSlGLUOSLsXbg_33tyRABXuifQ>
    <xmx:ktSaXlAPxoa3LFu4mypMRbjqDIRlr77gUEhvS1Y-xebgpO9nhWrEcw>
    <xmx:ktSaXo0nPBfYfPwwqR29XEj3pio8Qsd0bEe1SZ_2xztqNDtWKbDg2aPFqzI>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 538F93280059;
        Sat, 18 Apr 2020 06:21:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] posix-cpu-timers: Store a reference to a pid not a task" failed to apply to 5.4-stable tree
To:     ebiederm@xmission.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Apr 2020 12:21:03 +0200
Message-ID: <15872052636618@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 55e8c8eb2c7b6bf30e99423ccfe7ca032f498f59 Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 28 Feb 2020 11:11:06 -0600
Subject: [PATCH] posix-cpu-timers: Store a reference to a pid not a task

posix cpu timers do not handle the death of a process well.

This is most clearly seen when a multi-threaded process calls exec from a
thread that is not the leader of the thread group.  The posix cpu timer code
continues to pin the old thread group leader and is unable to find the
siglock from there.

This results in posix_cpu_timer_del being unable to delete a timer,
posix_cpu_timer_set being unable to set a timer.  Further to compensate for
the problems in posix_cpu_timer_del on a multi-threaded exec all timers
that point at the multi-threaded task are stopped.

The code for the timers fundamentally needs to check if the target
process/thread is alive.  This needs an extra level of indirection. This
level of indirection is already available in struct pid.

So replace cpu.task with cpu.pid to get the needed extra layer of
indirection.

In addition to handling things more cleanly this reduces the amount of
memory a timer can pin when a process exits and then is reaped from
a task_struct to the vastly smaller struct pid.

Fixes: e0a70217107e ("posix-cpu-timers: workaround to suppress the problems with mt exec")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/87wo86tz6d.fsf@x220.int.ebiederm.org

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 3d10c84a97a9..e3f0f8585da4 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -69,7 +69,7 @@ static inline int clockid_to_fd(const clockid_t clk)
 struct cpu_timer {
 	struct timerqueue_node	node;
 	struct timerqueue_head	*head;
-	struct task_struct	*task;
+	struct pid		*pid;
 	struct list_head	elist;
 	int			firing;
 };
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index ef936c5a910b..6df468a622fe 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -118,6 +118,16 @@ static inline int validate_clock_permissions(const clockid_t clock)
 	return __get_task_for_clock(clock, false, false) ? 0 : -EINVAL;
 }
 
+static inline enum pid_type cpu_timer_pid_type(struct k_itimer *timer)
+{
+	return CPUCLOCK_PERTHREAD(timer->it_clock) ? PIDTYPE_PID : PIDTYPE_TGID;
+}
+
+static inline struct task_struct *cpu_timer_task_rcu(struct k_itimer *timer)
+{
+	return pid_task(timer->it.cpu.pid, cpu_timer_pid_type(timer));
+}
+
 /*
  * Update expiry time from increment, and increase overrun count,
  * given the current clock sample.
@@ -391,7 +401,12 @@ static int posix_cpu_timer_create(struct k_itimer *new_timer)
 
 	new_timer->kclock = &clock_posix_cpu;
 	timerqueue_init(&new_timer->it.cpu.node);
-	new_timer->it.cpu.task = p;
+	new_timer->it.cpu.pid = get_task_pid(p, cpu_timer_pid_type(new_timer));
+	/*
+	 * get_task_for_clock() took a reference on @p. Drop it as the timer
+	 * holds a reference on the pid of @p.
+	 */
+	put_task_struct(p);
 	return 0;
 }
 
@@ -404,13 +419,15 @@ static int posix_cpu_timer_create(struct k_itimer *new_timer)
 static int posix_cpu_timer_del(struct k_itimer *timer)
 {
 	struct cpu_timer *ctmr = &timer->it.cpu;
-	struct task_struct *p = ctmr->task;
 	struct sighand_struct *sighand;
+	struct task_struct *p;
 	unsigned long flags;
 	int ret = 0;
 
-	if (WARN_ON_ONCE(!p))
-		return -EINVAL;
+	rcu_read_lock();
+	p = cpu_timer_task_rcu(timer);
+	if (!p)
+		goto out;
 
 	/*
 	 * Protect against sighand release/switch in exit/exec and process/
@@ -432,8 +449,10 @@ static int posix_cpu_timer_del(struct k_itimer *timer)
 		unlock_task_sighand(p, &flags);
 	}
 
+out:
+	rcu_read_unlock();
 	if (!ret)
-		put_task_struct(p);
+		put_pid(ctmr->pid);
 
 	return ret;
 }
@@ -561,13 +580,21 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int timer_flags,
 	clockid_t clkid = CPUCLOCK_WHICH(timer->it_clock);
 	u64 old_expires, new_expires, old_incr, val;
 	struct cpu_timer *ctmr = &timer->it.cpu;
-	struct task_struct *p = ctmr->task;
 	struct sighand_struct *sighand;
+	struct task_struct *p;
 	unsigned long flags;
 	int ret = 0;
 
-	if (WARN_ON_ONCE(!p))
-		return -EINVAL;
+	rcu_read_lock();
+	p = cpu_timer_task_rcu(timer);
+	if (!p) {
+		/*
+		 * If p has just been reaped, we can no
+		 * longer get any information about it at all.
+		 */
+		rcu_read_unlock();
+		return -ESRCH;
+	}
 
 	/*
 	 * Use the to_ktime conversion because that clamps the maximum
@@ -584,8 +611,10 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int timer_flags,
 	 * If p has just been reaped, we can no
 	 * longer get any information about it at all.
 	 */
-	if (unlikely(sighand == NULL))
+	if (unlikely(sighand == NULL)) {
+		rcu_read_unlock();
 		return -ESRCH;
+	}
 
 	/*
 	 * Disarm any old timer after extracting its expiry time.
@@ -690,6 +719,7 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int timer_flags,
 
 	ret = 0;
  out:
+	rcu_read_unlock();
 	if (old)
 		old->it_interval = ns_to_timespec64(old_incr);
 
@@ -701,10 +731,12 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec64 *itp
 	clockid_t clkid = CPUCLOCK_WHICH(timer->it_clock);
 	struct cpu_timer *ctmr = &timer->it.cpu;
 	u64 now, expires = cpu_timer_getexpires(ctmr);
-	struct task_struct *p = ctmr->task;
+	struct task_struct *p;
 
-	if (WARN_ON_ONCE(!p))
-		return;
+	rcu_read_lock();
+	p = cpu_timer_task_rcu(timer);
+	if (!p)
+		goto out;
 
 	/*
 	 * Easy part: convert the reload time.
@@ -712,7 +744,7 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec64 *itp
 	itp->it_interval = ktime_to_timespec64(timer->it_interval);
 
 	if (!expires)
-		return;
+		goto out;
 
 	/*
 	 * Sample the clock to take the difference with the expiry time.
@@ -732,6 +764,8 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec64 *itp
 		itp->it_value.tv_nsec = 1;
 		itp->it_value.tv_sec = 0;
 	}
+out:
+	rcu_read_unlock();
 }
 
 #define MAX_COLLECTED	20
@@ -952,14 +986,15 @@ static void check_process_timers(struct task_struct *tsk,
 static void posix_cpu_timer_rearm(struct k_itimer *timer)
 {
 	clockid_t clkid = CPUCLOCK_WHICH(timer->it_clock);
-	struct cpu_timer *ctmr = &timer->it.cpu;
-	struct task_struct *p = ctmr->task;
+	struct task_struct *p;
 	struct sighand_struct *sighand;
 	unsigned long flags;
 	u64 now;
 
-	if (WARN_ON_ONCE(!p))
-		return;
+	rcu_read_lock();
+	p = cpu_timer_task_rcu(timer);
+	if (!p)
+		goto out;
 
 	/*
 	 * Fetch the current sample and update the timer's expiry time.
@@ -974,13 +1009,15 @@ static void posix_cpu_timer_rearm(struct k_itimer *timer)
 	/* Protect timer list r/w in arm_timer() */
 	sighand = lock_task_sighand(p, &flags);
 	if (unlikely(sighand == NULL))
-		return;
+		goto out;
 
 	/*
 	 * Now re-arm for the new expiry time.
 	 */
 	arm_timer(timer, p);
 	unlock_task_sighand(p, &flags);
+out:
+	rcu_read_unlock();
 }
 
 /**

