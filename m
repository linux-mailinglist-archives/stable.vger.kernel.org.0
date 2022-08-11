Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26FDC58F82A
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 09:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbiHKHNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 03:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiHKHNv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 03:13:51 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3B48E451;
        Thu, 11 Aug 2022 00:13:49 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id uj29so32078596ejc.0;
        Thu, 11 Aug 2022 00:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=7xLmChUbR+sbQTU3eoxUwM1fyr+o1U5qC9sWeD1/mPc=;
        b=bbWAhOiep8Wld6q4bDTLSbrUyOY5g8WqKycPZz03Ow58K+wDOvrzzytV8x6y8m5I4H
         GDiEWl+hejalcsujFBzlDG9xn4ej6GMfMp+f5El35MeCabzDStYXzBcHW8gX5xhIDwrZ
         x4HhzIZR3JFKRZiC1DGRhoXXETDwfKJRzgZ9bqNGfQGvDfIdVtH+lRjyUmoolkKfY6J5
         2KGMPhxqsOKnIpE+rKhq0wngGP/RDK6DJC2b16WCnrNFizN4mCkBYIJbUDvVPplYVydj
         65llJKcB7/hrGuubaasJe8sUUwX2RsOpm3dBLy3KtO0tzv2axrBul65Fiym3/WhltzwE
         beBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=7xLmChUbR+sbQTU3eoxUwM1fyr+o1U5qC9sWeD1/mPc=;
        b=D6Y0kDz80JFq2jq+jLFwZbHaMqqC9dlcMQKyknoL7fcwrzKXruE1KCJT08SaXcOGPd
         SjlcXz13xcIvbhE6oGSdue94KRSIc/DUvfMLCdmp8Sh76tgHWXnfuzplOKAoNnMuOMtu
         nXZ91g3qw2c71hdhPcGhwl8AcxgH0SxhRYGIp7myZPbFprIobktU2rNLLMQfinf9xsjS
         kSWUQ6U55ZFOJS4BI+Nb2520KZpmhQCG2NB7QU9z+njho0nao2ZwgBkaKXcszDbpzIyo
         Kgb/5AFz/DjG9kZTl/rm3K+du1REereX5/5/5Jko3su/i/0LZlloW49beq0h+Hx3xlrM
         N6wg==
X-Gm-Message-State: ACgBeo3ZiDW+wO0ocdxRVt6I3Mgt/bvrJB0hbMAbjQ4Y7hk/2khjqlpz
        UYcd+o0CvyqPQ/wpG6Q/NHQ=
X-Google-Smtp-Source: AA6agR7GD0q8OsfhqzQwuGsXOKWBclQAb128JqH7qr++nP/TkAFqCRn7FW8RklyLMJ9W6D2mD2NP7A==
X-Received: by 2002:a17:907:6e17:b0:731:2426:f606 with SMTP id sd23-20020a1709076e1700b007312426f606mr17346600ejc.162.1660202028207;
        Thu, 11 Aug 2022 00:13:48 -0700 (PDT)
Received: from gmail.com (195-38-113-148.pool.digikabel.hu. [195.38.113.148])
        by smtp.gmail.com with ESMTPSA id d5-20020a170906304500b007262b9f7120sm3157407ejd.167.2022.08.11.00.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 00:13:47 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Thu, 11 Aug 2022 09:13:45 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH] sched/all: Change BUG_ON() instances to WARN_ON()
Message-ID: <YvSsKcAXISmshtHo@gmail.com>
References: <20220808073232.8808-1-david@redhat.com>
 <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
 <1a48d71d-41ee-bf39-80d2-0102f4fe9ccb@redhat.com>
 <CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com>
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I just tried to find a valid BUG_ON() that would make me go "yeah, that's 
> actually worth it", and couldn't really find one. Yeah, there are several 
> ones in the scheduler that make me go "ok, if that triggers, the machine 
> is dead anyway", so in that sense there are certainly BUG_ON()s that 
> don't _hurt_.

That's a mostly accidental, historical accumulation of BUG_ON()s - I 
believe we can change all of them to WARN_ON() via the patch below.

As far as the scheduler is concerned, we don't need any BUG_ON()s.

[ This assumes that printk() itself is atomic and non-recursive wrt. the 
  scheduler in these code paths ... ]

Thanks,

	Ingo

===============>
From: Ingo Molnar <mingo@kernel.org>
Date: Thu, 11 Aug 2022 08:54:52 +0200
Subject: [PATCH] sched/all: Change BUG_ON() instances to WARN_ON()

There's no good reason to crash a user's system with a BUG_ON(),
chances are high that they'll never even see the crash message on
Xorg, and it won't make it into the syslog either.

By using a WARN_ON() we at least give the user a chance to report
any bugs triggered here - instead of getting silent hangs.

None of these WARN_ON()s are supposed to trigger, ever - so we ignore
cases where a NULL check is done via a BUG_ON() and we let a NULL
pointer through after a WARN_ON().

There's one exception: WARN_ON() arguments with side-effects,
such as locking - in this case we use the return value of the
WARN_ON(), such as in:

 -       BUG_ON(!lock_task_sighand(p, &flags));
 +       if (WARN_ON(!lock_task_sighand(p, &flags)))
 +               return;

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/autogroup.c |  3 ++-
 kernel/sched/core.c      |  2 +-
 kernel/sched/cpupri.c    |  2 +-
 kernel/sched/deadline.c  | 26 +++++++++++++-------------
 kernel/sched/fair.c      | 10 +++++-----
 kernel/sched/rt.c        |  2 +-
 kernel/sched/sched.h     |  6 +++---
 7 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/kernel/sched/autogroup.c b/kernel/sched/autogroup.c
index 4ebaf97f7bd8..13f6b6da35a0 100644
--- a/kernel/sched/autogroup.c
+++ b/kernel/sched/autogroup.c
@@ -161,7 +161,8 @@ autogroup_move_group(struct task_struct *p, struct autogroup *ag)
 	struct task_struct *t;
 	unsigned long flags;
 
-	BUG_ON(!lock_task_sighand(p, &flags));
+	if (WARN_ON(!lock_task_sighand(p, &flags)))
+		return;
 
 	prev = p->signal->autogroup;
 	if (prev == ag) {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d3d61cbb6b3c..f84206bf42cd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2328,7 +2328,7 @@ static struct rq *move_queued_task(struct rq *rq, struct rq_flags *rf,
 	rq = cpu_rq(new_cpu);
 
 	rq_lock(rq, rf);
-	BUG_ON(task_cpu(p) != new_cpu);
+	WARN_ON(task_cpu(p) != new_cpu);
 	activate_task(rq, p, 0);
 	check_preempt_curr(rq, p, 0);
 
diff --git a/kernel/sched/cpupri.c b/kernel/sched/cpupri.c
index fa9ce9d83683..9f719e4ea081 100644
--- a/kernel/sched/cpupri.c
+++ b/kernel/sched/cpupri.c
@@ -147,7 +147,7 @@ int cpupri_find_fitness(struct cpupri *cp, struct task_struct *p,
 	int task_pri = convert_prio(p->prio);
 	int idx, cpu;
 
-	BUG_ON(task_pri >= CPUPRI_NR_PRIORITIES);
+	WARN_ON(task_pri >= CPUPRI_NR_PRIORITIES);
 
 	for (idx = 0; idx < task_pri; idx++) {
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 1d9c90958baa..fb234077c317 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -310,7 +310,7 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 {
 	struct rq *rq;
 
-	BUG_ON(p->dl.flags & SCHED_FLAG_SUGOV);
+	WARN_ON(p->dl.flags & SCHED_FLAG_SUGOV);
 
 	if (task_on_rq_queued(p))
 		return;
@@ -607,7 +607,7 @@ static void enqueue_pushable_dl_task(struct rq *rq, struct task_struct *p)
 {
 	struct rb_node *leftmost;
 
-	BUG_ON(!RB_EMPTY_NODE(&p->pushable_dl_tasks));
+	WARN_ON(!RB_EMPTY_NODE(&p->pushable_dl_tasks));
 
 	leftmost = rb_add_cached(&p->pushable_dl_tasks,
 				 &rq->dl.pushable_dl_tasks_root,
@@ -684,7 +684,7 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 			 * Failed to find any suitable CPU.
 			 * The task will never come back!
 			 */
-			BUG_ON(dl_bandwidth_enabled());
+			WARN_ON(dl_bandwidth_enabled());
 
 			/*
 			 * If admission control is disabled we
@@ -830,7 +830,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
-	BUG_ON(pi_of(dl_se)->dl_runtime <= 0);
+	WARN_ON(pi_of(dl_se)->dl_runtime <= 0);
 
 	/*
 	 * This could be the case for a !-dl task that is boosted.
@@ -1616,7 +1616,7 @@ static void __enqueue_dl_entity(struct sched_dl_entity *dl_se)
 {
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 
-	BUG_ON(!RB_EMPTY_NODE(&dl_se->rb_node));
+	WARN_ON(!RB_EMPTY_NODE(&dl_se->rb_node));
 
 	rb_add_cached(&dl_se->rb_node, &dl_rq->root, __dl_less);
 
@@ -1640,7 +1640,7 @@ static void __dequeue_dl_entity(struct sched_dl_entity *dl_se)
 static void
 enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 {
-	BUG_ON(on_dl_rq(dl_se));
+	WARN_ON(on_dl_rq(dl_se));
 
 	update_stats_enqueue_dl(dl_rq_of_se(dl_se), dl_se, flags);
 
@@ -2017,7 +2017,7 @@ static struct task_struct *pick_task_dl(struct rq *rq)
 		return NULL;
 
 	dl_se = pick_next_dl_entity(dl_rq);
-	BUG_ON(!dl_se);
+	WARN_ON(!dl_se);
 	p = dl_task_of(dl_se);
 
 	return p;
@@ -2277,12 +2277,12 @@ static struct task_struct *pick_next_pushable_dl_task(struct rq *rq)
 
 	p = __node_2_pdl(rb_first_cached(&rq->dl.pushable_dl_tasks_root));
 
-	BUG_ON(rq->cpu != task_cpu(p));
-	BUG_ON(task_current(rq, p));
-	BUG_ON(p->nr_cpus_allowed <= 1);
+	WARN_ON(rq->cpu != task_cpu(p));
+	WARN_ON(task_current(rq, p));
+	WARN_ON(p->nr_cpus_allowed <= 1);
 
-	BUG_ON(!task_on_rq_queued(p));
-	BUG_ON(!dl_task(p));
+	WARN_ON(!task_on_rq_queued(p));
+	WARN_ON(!dl_task(p));
 
 	return p;
 }
@@ -2492,7 +2492,7 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 	struct root_domain *src_rd;
 	struct rq *rq;
 
-	BUG_ON(!dl_task(p));
+	WARN_ON(!dl_task(p));
 
 	rq = task_rq(p);
 	src_rd = rq->rd;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index da388657d5ac..00c01b3232b9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2600,7 +2600,7 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 	if (!join)
 		return;
 
-	BUG_ON(irqs_disabled());
+	WARN_ON(irqs_disabled());
 	double_lock_irq(&my_grp->lock, &grp->lock);
 
 	for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++) {
@@ -7279,7 +7279,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 		return;
 
 	find_matching_se(&se, &pse);
-	BUG_ON(!pse);
+	WARN_ON(!pse);
 
 	cse_is_idle = se_is_idle(se);
 	pse_is_idle = se_is_idle(pse);
@@ -8159,7 +8159,7 @@ static void attach_task(struct rq *rq, struct task_struct *p)
 {
 	lockdep_assert_rq_held(rq);
 
-	BUG_ON(task_rq(p) != rq);
+	WARN_ON(task_rq(p) != rq);
 	activate_task(rq, p, ENQUEUE_NOCLOCK);
 	check_preempt_curr(rq, p, 0);
 }
@@ -10134,7 +10134,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		goto out_balanced;
 	}
 
-	BUG_ON(busiest == env.dst_rq);
+	WARN_ON(busiest == env.dst_rq);
 
 	schedstat_add(sd->lb_imbalance[idle], env.imbalance);
 
@@ -10430,7 +10430,7 @@ static int active_load_balance_cpu_stop(void *data)
 	 * we need to fix it. Originally reported by
 	 * Bjorn Helgaas on a 128-CPU setup.
 	 */
-	BUG_ON(busiest_rq == target_rq);
+	WARN_ON(busiest_rq == target_rq);
 
 	/* Search for an sd spanning us and the target CPU. */
 	rcu_read_lock();
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 054b6711e961..acf9f5ce0c4a 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -843,7 +843,7 @@ static void __disable_runtime(struct rq *rq)
 		 * We cannot be left wanting - that would mean some runtime
 		 * leaked out of the system.
 		 */
-		BUG_ON(want);
+		WARN_ON(want);
 balanced:
 		/*
 		 * Disable all the borrow logic by pretending we have inf
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b0bf2287dd9d..8e5df3bc3483 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2699,8 +2699,8 @@ static inline void double_rq_lock(struct rq *rq1, struct rq *rq2)
 	__acquires(rq1->lock)
 	__acquires(rq2->lock)
 {
-	BUG_ON(!irqs_disabled());
-	BUG_ON(rq1 != rq2);
+	WARN_ON(!irqs_disabled());
+	WARN_ON(rq1 != rq2);
 	raw_spin_rq_lock(rq1);
 	__acquire(rq2->lock);	/* Fake it out ;) */
 	double_rq_clock_clear_update(rq1, rq2);
@@ -2716,7 +2716,7 @@ static inline void double_rq_unlock(struct rq *rq1, struct rq *rq2)
 	__releases(rq1->lock)
 	__releases(rq2->lock)
 {
-	BUG_ON(rq1 != rq2);
+	WARN_ON(rq1 != rq2);
 	raw_spin_rq_unlock(rq1);
 	__release(rq2->lock);
 }
