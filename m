Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9DE1A9D04
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897465AbgDOLmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:42:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56041 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2897457AbgDOLmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:42:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id EF4335C0144;
        Wed, 15 Apr 2020 07:42:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:42:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=S2Ma3M
        eSVaXcTrgr5bQn4ePAj/9UJ1ToSx2SCMfvIUI=; b=cOqBMvNqDfGCSaYJn2ebhE
        dq+yVF60ta8DlK4RT3PQVu5lihUvBM3WoB+ydoQMzfVV6VYLrSHzR8HTDD/Ex6pJ
        M0Z0AwC7EnbWUEAHCVJW6a9uYmOpLWk8kvL1WAFHXPgg6N1P3Cf9sSc1Wig3+WSh
        bJKWtAygcCNGUWaHfP6LrAEU7TaDHcbJHZHkMDgZWLy7ER/DU5JjBjWMiO4PQ1Yk
        md34EaDPV7rEXXr7UqlKF7MqXze4lLJAOq8y5TF+vNF8bL3rUwDWgHAhGoS8hz9e
        Z9tDzUYLidaLDOCDsbfx3FPYuXtsoMbqorMQ/Ujmh0KT0AseiwN46uPDCXZj6IbQ
        ==
X-ME-Sender: <xms:H_OWXg01CNVrAKi-oqQOvqTVJVpZEHg1_0uwBAKQZsU6pc8EgWDO8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:H_OWXnJNaW1YrPFa0oU3eC-Zt6iNGjDZG5wWTuBztXYUhyIOzNkHVw>
    <xmx:H_OWXu0fIQnOF119pIxPIIwSOdr9OLkbzc5dzFJouoqQuE6AcNmLgQ>
    <xmx:H_OWXqyTl5DzFdiKE5QYy38TWzegI7Q4mJ-mIj1OwAyI5GwYKVcpdA>
    <xmx:H_OWXieYxSJ_6K8TdGpJlIkPaXNUcUwG90kyw7toBSnxV3MOmXhsqw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 523BD3060057;
        Wed, 15 Apr 2020 07:42:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] perf/core: Fix event cgroup tracking" failed to apply to 5.6-stable tree
To:     peterz@infradead.org, mingo@kernel.org, songliubraving@fb.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:42:14 +0200
Message-ID: <1586950934055@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 33238c50451596be86db1505ab65fee5172844d0 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 18 Mar 2020 20:33:37 +0100
Subject: [PATCH] perf/core: Fix event cgroup tracking

Song reports that installing cgroup events is broken since:

  db0503e4f675 ("perf/core: Optimize perf_install_in_event()")

The problem being that cgroup events try to track cpuctx->cgrp even
for disabled events, which is pointless and actively harmful since the
above commit. Rework the code to have explicit enable/disable hooks
for cgroup events, such that we can limit cgroup tracking to active
events.

More specifically, since the above commit disabled events are no
longer added to their context from the 'right' CPU, and we can't
access things like the current cgroup for a remote CPU.

Cc: <stable@vger.kernel.org> # v5.5+
Fixes: db0503e4f675 ("perf/core: Optimize perf_install_in_event()")
Reported-by: Song Liu <songliubraving@fb.com>
Tested-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/20200318193337.GB20760@hirez.programming.kicks-ass.net

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 55e44417f66d..7afd0b503406 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -983,16 +983,10 @@ perf_cgroup_set_shadow_time(struct perf_event *event, u64 now)
 	event->shadow_ctx_time = now - t->timestamp;
 }
 
-/*
- * Update cpuctx->cgrp so that it is set when first cgroup event is added and
- * cleared when last cgroup event is removed.
- */
 static inline void
-list_update_cgroup_event(struct perf_event *event,
-			 struct perf_event_context *ctx, bool add)
+perf_cgroup_event_enable(struct perf_event *event, struct perf_event_context *ctx)
 {
 	struct perf_cpu_context *cpuctx;
-	struct list_head *cpuctx_entry;
 
 	if (!is_cgroup_event(event))
 		return;
@@ -1009,28 +1003,41 @@ list_update_cgroup_event(struct perf_event *event,
 	 * because if the first would mismatch, the second would not try again
 	 * and we would leave cpuctx->cgrp unset.
 	 */
-	if (add && !cpuctx->cgrp) {
+	if (ctx->is_active && !cpuctx->cgrp) {
 		struct perf_cgroup *cgrp = perf_cgroup_from_task(current, ctx);
 
 		if (cgroup_is_descendant(cgrp->css.cgroup, event->cgrp->css.cgroup))
 			cpuctx->cgrp = cgrp;
 	}
 
-	if (add && ctx->nr_cgroups++)
+	if (ctx->nr_cgroups++)
 		return;
-	else if (!add && --ctx->nr_cgroups)
+
+	list_add(&cpuctx->cgrp_cpuctx_entry,
+			per_cpu_ptr(&cgrp_cpuctx_list, event->cpu));
+}
+
+static inline void
+perf_cgroup_event_disable(struct perf_event *event, struct perf_event_context *ctx)
+{
+	struct perf_cpu_context *cpuctx;
+
+	if (!is_cgroup_event(event))
 		return;
 
-	/* no cgroup running */
-	if (!add)
+	/*
+	 * Because cgroup events are always per-cpu events,
+	 * @ctx == &cpuctx->ctx.
+	 */
+	cpuctx = container_of(ctx, struct perf_cpu_context, ctx);
+
+	if (--ctx->nr_cgroups)
+		return;
+
+	if (ctx->is_active && cpuctx->cgrp)
 		cpuctx->cgrp = NULL;
 
-	cpuctx_entry = &cpuctx->cgrp_cpuctx_entry;
-	if (add)
-		list_add(cpuctx_entry,
-			 per_cpu_ptr(&cgrp_cpuctx_list, event->cpu));
-	else
-		list_del(cpuctx_entry);
+	list_del(&cpuctx->cgrp_cpuctx_entry);
 }
 
 #else /* !CONFIG_CGROUP_PERF */
@@ -1096,11 +1103,14 @@ static inline u64 perf_cgroup_event_time(struct perf_event *event)
 }
 
 static inline void
-list_update_cgroup_event(struct perf_event *event,
-			 struct perf_event_context *ctx, bool add)
+perf_cgroup_event_enable(struct perf_event *event, struct perf_event_context *ctx)
 {
 }
 
+static inline void
+perf_cgroup_event_disable(struct perf_event *event, struct perf_event_context *ctx)
+{
+}
 #endif
 
 /*
@@ -1791,13 +1801,14 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 		add_event_to_groups(event, ctx);
 	}
 
-	list_update_cgroup_event(event, ctx, true);
-
 	list_add_rcu(&event->event_entry, &ctx->event_list);
 	ctx->nr_events++;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat++;
 
+	if (event->state > PERF_EVENT_STATE_OFF)
+		perf_cgroup_event_enable(event, ctx);
+
 	ctx->generation++;
 }
 
@@ -1976,8 +1987,6 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 
 	event->attach_state &= ~PERF_ATTACH_CONTEXT;
 
-	list_update_cgroup_event(event, ctx, false);
-
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat--;
@@ -1994,8 +2003,10 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 	 * of error state is by explicit re-enabling
 	 * of the event
 	 */
-	if (event->state > PERF_EVENT_STATE_OFF)
+	if (event->state > PERF_EVENT_STATE_OFF) {
+		perf_cgroup_event_disable(event, ctx);
 		perf_event_set_state(event, PERF_EVENT_STATE_OFF);
+	}
 
 	ctx->generation++;
 }
@@ -2226,6 +2237,7 @@ event_sched_out(struct perf_event *event,
 
 	if (READ_ONCE(event->pending_disable) >= 0) {
 		WRITE_ONCE(event->pending_disable, -1);
+		perf_cgroup_event_disable(event, ctx);
 		state = PERF_EVENT_STATE_OFF;
 	}
 	perf_event_set_state(event, state);
@@ -2363,6 +2375,7 @@ static void __perf_event_disable(struct perf_event *event,
 		event_sched_out(event, cpuctx, ctx);
 
 	perf_event_set_state(event, PERF_EVENT_STATE_OFF);
+	perf_cgroup_event_disable(event, ctx);
 }
 
 /*
@@ -2746,7 +2759,7 @@ static int  __perf_install_in_context(void *info)
 	}
 
 #ifdef CONFIG_CGROUP_PERF
-	if (is_cgroup_event(event)) {
+	if (event->state > PERF_EVENT_STATE_OFF && is_cgroup_event(event)) {
 		/*
 		 * If the current cgroup doesn't match the event's
 		 * cgroup, we should not try to schedule it.
@@ -2906,6 +2919,7 @@ static void __perf_event_enable(struct perf_event *event,
 		ctx_sched_out(ctx, cpuctx, EVENT_TIME);
 
 	perf_event_set_state(event, PERF_EVENT_STATE_INACTIVE);
+	perf_cgroup_event_enable(event, ctx);
 
 	if (!ctx->is_active)
 		return;
@@ -3616,8 +3630,10 @@ static int merge_sched_in(struct perf_event *event, void *data)
 	}
 
 	if (event->state == PERF_EVENT_STATE_INACTIVE) {
-		if (event->attr.pinned)
+		if (event->attr.pinned) {
+			perf_cgroup_event_disable(event, ctx);
 			perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
+		}
 
 		*can_add_hw = 0;
 		ctx->rotate_necessary = 1;

