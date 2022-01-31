Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC20F4A4211
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358604AbiAaLKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:10:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53620 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348313AbiAaLFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:05:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2F3BB82A62;
        Mon, 31 Jan 2022 11:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0210C340E8;
        Mon, 31 Jan 2022 11:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627141;
        bh=8fNIaFx9lhn2hazd1oRZnR9hgJM4vILphr4g949FZmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=egM2xsFYX2o0/Ij2KVcj6L89RpGmyE8OPOq3vh+PPGD4rCLs3iCgGOvw7PJ1eGfSn
         2bartePYwsKX9EJk2g8OZmWcLd0oZ2ga5HQR9+E/VxijAl2CWV/wxwyuDvOtRoVa3M
         qA3ez2kYKwDSLdns0+KOsOiusMAPXlF10bG6UkG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/100] kernel: delete repeated words in comments
Date:   Mon, 31 Jan 2022 11:56:31 +0100
Message-Id: <20220131105222.784795044@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit c034f48e99907d5be147ac8f0f3e630a9307c2be ]

Drop repeated words in kernel/events/.
{if, the, that, with, time}

Drop repeated words in kernel/locking/.
{it, no, the}

Drop repeated words in kernel/sched/.
{in, not}

Link: https://lkml.kernel.org/r/20210127023412.26292-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Will Deacon <will@kernel.org>	[kernel/locking/]
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c       | 8 ++++----
 kernel/events/uprobes.c    | 2 +-
 kernel/locking/rtmutex.c   | 4 ++--
 kernel/locking/rwsem.c     | 2 +-
 kernel/locking/semaphore.c | 2 +-
 kernel/sched/fair.c        | 2 +-
 kernel/sched/membarrier.c  | 2 +-
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e2d774cc470ee..8dc7c4d12b789 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -266,7 +266,7 @@ static void event_function_call(struct perf_event *event, event_f func, void *da
 	if (!event->parent) {
 		/*
 		 * If this is a !child event, we must hold ctx::mutex to
-		 * stabilize the the event->ctx relation. See
+		 * stabilize the event->ctx relation. See
 		 * perf_event_ctx_lock().
 		 */
 		lockdep_assert_held(&ctx->mutex);
@@ -1300,7 +1300,7 @@ static void put_ctx(struct perf_event_context *ctx)
  * life-time rules separate them. That is an exiting task cannot fork, and a
  * spawning task cannot (yet) exit.
  *
- * But remember that that these are parent<->child context relations, and
+ * But remember that these are parent<->child context relations, and
  * migration does not affect children, therefore these two orderings should not
  * interact.
  *
@@ -1439,7 +1439,7 @@ static u64 primary_event_id(struct perf_event *event)
 /*
  * Get the perf_event_context for a task and lock it.
  *
- * This has to cope with with the fact that until it is locked,
+ * This has to cope with the fact that until it is locked,
  * the context could get moved to another task.
  */
 static struct perf_event_context *
@@ -2492,7 +2492,7 @@ static void perf_set_shadow_time(struct perf_event *event,
 	 * But this is a bit hairy.
 	 *
 	 * So instead, we have an explicit cgroup call to remain
-	 * within the time time source all along. We believe it
+	 * within the time source all along. We believe it
 	 * is cleaner and simpler to understand.
 	 */
 	if (is_cgroup_event(event))
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 00b0358739ab3..e1bbb3b92921d 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1735,7 +1735,7 @@ void uprobe_free_utask(struct task_struct *t)
 }
 
 /*
- * Allocate a uprobe_task object for the task if if necessary.
+ * Allocate a uprobe_task object for the task if necessary.
  * Called when the thread hits a breakpoint.
  *
  * Returns:
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 2f8cd616d3b29..f00dd928fc711 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1438,7 +1438,7 @@ rt_mutex_fasttrylock(struct rt_mutex *lock,
 }
 
 /*
- * Performs the wakeup of the the top-waiter and re-enables preemption.
+ * Performs the wakeup of the top-waiter and re-enables preemption.
  */
 void rt_mutex_postunlock(struct wake_q_head *wake_q)
 {
@@ -1832,7 +1832,7 @@ struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock)
  *			been started.
  * @waiter:		the pre-initialized rt_mutex_waiter
  *
- * Wait for the the lock acquisition started on our behalf by
+ * Wait for the lock acquisition started on our behalf by
  * rt_mutex_start_proxy_lock(). Upon failure, the caller must call
  * rt_mutex_cleanup_proxy_lock().
  *
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index a163542d178ee..cc5cc889b5b7f 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1177,7 +1177,7 @@ rwsem_down_write_slowpath(struct rw_semaphore *sem, int state)
 
 		/*
 		 * If there were already threads queued before us and:
-		 *  1) there are no no active locks, wake the front
+		 *  1) there are no active locks, wake the front
 		 *     queued process(es) as the handoff bit might be set.
 		 *  2) there are no active writers and some readers, the lock
 		 *     must be read owned; so we try to wake any read lock
diff --git a/kernel/locking/semaphore.c b/kernel/locking/semaphore.c
index d9dd94defc0a9..9aa855a96c4ae 100644
--- a/kernel/locking/semaphore.c
+++ b/kernel/locking/semaphore.c
@@ -119,7 +119,7 @@ EXPORT_SYMBOL(down_killable);
  * @sem: the semaphore to be acquired
  *
  * Try to acquire the semaphore atomically.  Returns 0 if the semaphore has
- * been acquired successfully or 1 if it it cannot be acquired.
+ * been acquired successfully or 1 if it cannot be acquired.
  *
  * NOTE: This return value is inverted from both spin_trylock and
  * mutex_trylock!  Be careful about this when converting code.
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2a33cb5a10e59..8d2f238fdd2ac 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5149,7 +5149,7 @@ static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
 /*
  * When a group wakes up we want to make sure that its quota is not already
  * expired/exceeded, otherwise it may be allowed to steal additional ticks of
- * runtime as update_curr() throttling can not not trigger until it's on-rq.
+ * runtime as update_curr() throttling can not trigger until it's on-rq.
  */
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq)
 {
diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index 4d4dd349c05be..cc7cd512e4e33 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -316,7 +316,7 @@ static int sync_runqueues_membarrier_state(struct mm_struct *mm)
 
 	/*
 	 * For each cpu runqueue, if the task's mm match @mm, ensure that all
-	 * @mm's membarrier state set bits are also set in in the runqueue's
+	 * @mm's membarrier state set bits are also set in the runqueue's
 	 * membarrier state. This ensures that a runqueue scheduling
 	 * between threads which are users of @mm has its membarrier state
 	 * updated.
-- 
2.34.1



