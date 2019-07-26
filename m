Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2839376BCE
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 16:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387512AbfGZOmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 10:42:05 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:33317 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387508AbfGZOmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 10:42:05 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A16A94EC;
        Fri, 26 Jul 2019 10:42:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 26 Jul 2019 10:42:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=fBUHvD
        dME1wCZ6FPhPpZYtvKRW69bnz2o7dJ/OFH+FA=; b=vWXYtd/MnJrbikZrtvkITc
        0T5zC3oAPZNkoyvatPsK2+pV7XMAat127TA2OvD4nuv32veYwRi5fHur0Y6CGwaX
        Q5efpZOiiRM2v53FPyQDEzp1apL1aRpsMHOBsJ0OKfHIIywX5tqQd4Cabkj4tuv6
        EBkOmwAmEUT1ClwiqAgwgBsjm/OB31Mb8K6YbVTygnQKT8iX9V/d8DaYUUWMmJI4
        1cflSo35qnJchU718oOcLK+SjrL0gPwtoapmhl5BksjnLKwlBpDileOtZ9Lkp9dB
        X+hawjAqG3oily53BEbKp0u2Jv7ctpIFDr9Xb6THMwWpkr7+9pwe0dOhXU0vb2kw
        ==
X-ME-Sender: <xms:OxE7XcbO7xrwn2UnWFntMU2B2ztPaXny1lSeKdNygALt1DQ_dveYhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkeeggdektdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:OxE7XaUMak594u586CVv0gWKcX6Zf-iSzHmxiiAjtG7hCpv_up5h7g>
    <xmx:OxE7XfL0Z8Wqk84YBaxMSx8IATHhIB7dGUbp0bhSjQpQu72nO7U9kg>
    <xmx:OxE7XVdbZruq5yCho_iSG3K9gpXBleXwl3rRfZr8rCcYr3bQz2QK-w>
    <xmx:OxE7XXAC40npPW2l_5Cm8kHmHupWOyTeAavd3Kvl6Y0yqERPZIx2Bw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C2DF1380074;
        Fri, 26 Jul 2019 10:42:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] perf/core: Fix exclusive events' grouping" failed to apply to 4.9-stable tree
To:     alexander.shishkin@linux.intel.com, acme@redhat.com,
        eranian@google.com, jolsa@redhat.com, mingo@kernel.org,
        peterz@infradead.org, stable@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vincent.weaver@maine.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 26 Jul 2019 16:42:01 +0200
Message-ID: <15641521212123@kroah.com>
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

From 8a58ddae23796c733c5dfbd717538d89d036c5bd Mon Sep 17 00:00:00 2001
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Date: Mon, 1 Jul 2019 14:07:55 +0300
Subject: [PATCH] perf/core: Fix exclusive events' grouping

So far, we tried to disallow grouping exclusive events for the fear of
complications they would cause with moving between contexts. Specifically,
moving a software group to a hardware context would violate the exclusivity
rules if both groups contain matching exclusive events.

This attempt was, however, unsuccessful: the check that we have in the
perf_event_open() syscall is both wrong (looks at wrong PMU) and
insufficient (group leader may still be exclusive), as can be illustrated
by running:

  $ perf record -e '{intel_pt//,cycles}' uname
  $ perf record -e '{cycles,intel_pt//}' uname

ultimately successfully.

Furthermore, we are completely free to trigger the exclusivity violation
by:

   perf -e '{cycles,intel_pt//}' -e '{intel_pt//,instructions}'

even though the helpful perf record will not allow that, the ABI will.

The warning later in the perf_event_open() path will also not trigger, because
it's also wrong.

Fix all this by validating the original group before moving, getting rid
of broken safeguards and placing a useful one to perf_install_in_context().

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: mathieu.poirier@linaro.org
Cc: will.deacon@arm.com
Fixes: bed5b25ad9c8a ("perf: Add a pmu capability for "exclusive" events")
Link: https://lkml.kernel.org/r/20190701110755.24646-1-alexander.shishkin@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 16e38c286d46..e8ad3c590a23 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1055,6 +1055,11 @@ static inline int in_software_context(struct perf_event *event)
 	return event->ctx->pmu->task_ctx_nr == perf_sw_context;
 }
 
+static inline int is_exclusive_pmu(struct pmu *pmu)
+{
+	return pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE;
+}
+
 extern struct static_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 extern void ___perf_sw_event(u32, u64, struct pt_regs *, u64);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5dd19bedbf64..eea9d52b010c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2553,6 +2553,9 @@ static int  __perf_install_in_context(void *info)
 	return ret;
 }
 
+static bool exclusive_event_installable(struct perf_event *event,
+					struct perf_event_context *ctx);
+
 /*
  * Attach a performance event to a context.
  *
@@ -2567,6 +2570,8 @@ perf_install_in_context(struct perf_event_context *ctx,
 
 	lockdep_assert_held(&ctx->mutex);
 
+	WARN_ON_ONCE(!exclusive_event_installable(event, ctx));
+
 	if (event->cpu != -1)
 		event->cpu = cpu;
 
@@ -4360,7 +4365,7 @@ static int exclusive_event_init(struct perf_event *event)
 {
 	struct pmu *pmu = event->pmu;
 
-	if (!(pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
+	if (!is_exclusive_pmu(pmu))
 		return 0;
 
 	/*
@@ -4391,7 +4396,7 @@ static void exclusive_event_destroy(struct perf_event *event)
 {
 	struct pmu *pmu = event->pmu;
 
-	if (!(pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
+	if (!is_exclusive_pmu(pmu))
 		return;
 
 	/* see comment in exclusive_event_init() */
@@ -4411,14 +4416,15 @@ static bool exclusive_event_match(struct perf_event *e1, struct perf_event *e2)
 	return false;
 }
 
-/* Called under the same ctx::mutex as perf_install_in_context() */
 static bool exclusive_event_installable(struct perf_event *event,
 					struct perf_event_context *ctx)
 {
 	struct perf_event *iter_event;
 	struct pmu *pmu = event->pmu;
 
-	if (!(pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
+	lockdep_assert_held(&ctx->mutex);
+
+	if (!is_exclusive_pmu(pmu))
 		return true;
 
 	list_for_each_entry(iter_event, &ctx->event_list, event_entry) {
@@ -10947,11 +10953,6 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_alloc;
 	}
 
-	if ((pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE) && group_leader) {
-		err = -EBUSY;
-		goto err_context;
-	}
-
 	/*
 	 * Look up the group leader (we will attach this event to it):
 	 */
@@ -11039,6 +11040,18 @@ SYSCALL_DEFINE5(perf_event_open,
 				move_group = 0;
 			}
 		}
+
+		/*
+		 * Failure to create exclusive events returns -EBUSY.
+		 */
+		err = -EBUSY;
+		if (!exclusive_event_installable(group_leader, ctx))
+			goto err_locked;
+
+		for_each_sibling_event(sibling, group_leader) {
+			if (!exclusive_event_installable(sibling, ctx))
+				goto err_locked;
+		}
 	} else {
 		mutex_lock(&ctx->mutex);
 	}
@@ -11075,9 +11088,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	 * because we need to serialize with concurrent event creation.
 	 */
 	if (!exclusive_event_installable(event, ctx)) {
-		/* exclusive and group stuff are assumed mutually exclusive */
-		WARN_ON_ONCE(move_group);
-
 		err = -EBUSY;
 		goto err_locked;
 	}

