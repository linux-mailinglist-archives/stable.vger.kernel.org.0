Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF0C5F225D
	for <lists+stable@lfdr.de>; Sun,  2 Oct 2022 11:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiJBJtu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 05:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJBJts (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 05:49:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2B71A207
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 02:49:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EDD360DF5
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 09:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963A0C433C1;
        Sun,  2 Oct 2022 09:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664704185;
        bh=52l3Wp6DguI34FeX7maZ5Dt3sxaSs1DMr/lxP8m2Rqk=;
        h=Subject:To:Cc:From:Date:From;
        b=ZAEolaRWli7KoCpd4nUeEc6Bc7VpzfoMsax/jDZIMka+TT2ASM26QNmi6sF7fcc9U
         KTkXWFDRM4fgDASn60JIdGQR2BWptgd4RtLmdpNkG0gXijlp01dOBSmdsKvigvGaDj
         WBb+KFxNGv4Jl//pRUQpTZZuzx7dTRKEQaHm5YeU=
Subject: FAILED: patch "[PATCH] drm/i915/gt: Restrict forced preemption to the active context" failed to apply to 5.10-stable tree
To:     chris@chris-wilson.co.uk, andi.shyti@linux.intel.com,
        andrzej.hajda@intel.com, rodrigo.vivi@intel.com,
        stable@vger.kernel.org, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 02 Oct 2022 11:50:23 +0200
Message-ID: <166470422313792@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

6ef7d362123e ("drm/i915/gt: Restrict forced preemption to the active context")
3e28d37146db ("drm/i915: Move priolist to new i915_sched_engine object")
2913fa4d7d42 ("drm/i915/gt: use new tasklet API for execution list")
eb5c10cbbc2f ("drm/i915: Remove I915_USER_PRIORITY_SHIFT")
2867ff6ceb25 ("drm/i915: Strip out internal priorities")
a829f033e966 ("drm/i915: Wedge the GPU if command parser setup fails")
f99e67f1b929 ("drm/i915/display: Apply interactive priority to explicit flip fences")
007c45787650 ("drm/i915/guc: stop calling execlists_set_default_submission")
43aaadc67e6f ("drm/i915/guc: init engine directly in GuC submission mode")
7e5299cebe91 ("drm/i915/guc: Delete GuC code unused in future patches")
baa7c2cd99c6 ("drm/i915: Refactor marking a request as EIO")
751f82b353a6 ("drm/i915/gt: Only disable preemption on gen8 render engines")
4386b8e5ad71 ("drm/i915/gt: Remove timeslice suppression")
fe7bcfaeb2b7 ("drm/i915/gt: Refactor heartbeat request construction and submission")
f81475bb5bb4 ("drm/i915/gt: Resubmit the virtual engine on schedule-out")
bab0557c8dca ("drm/i915/gt: Remove virtual breadcrumb before transfer")
6f0726b4807c ("drm/i915/gt: Defer schedule_out until after the next dequeue")
2efa2c522ab0 ("drm/i915/gt: Decouple inflight virtual engines")
64b7a3fa7e3e ("drm/i915/gt: Use virtual_engine during execlists_dequeue")
16f2941ad307 ("drm/i915/gt: Replace direct submit with direct call to tasklet")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6ef7d362123ecb5bf6d163bb9c7fd6ba2d8c968c Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Wed, 21 Sep 2022 15:52:58 +0200
Subject: [PATCH] drm/i915/gt: Restrict forced preemption to the active context

When we submit a new pair of contexts to ELSP for execution, we start a
timer by which point we expect the HW to have switched execution to the
pending contexts. If the promotion to the new pair of contexts has not
occurred, we declare the executing context to have hung and force the
preemption to take place by resetting the engine and resubmitting the
new contexts.

This can lead to an unfair situation where almost all of the preemption
timeout is consumed by the first context which just switches into the
second context immediately prior to the timer firing and triggering the
preemption reset (assuming that the timer interrupts before we process
the CS events for the context switch). The second context hasn't yet had
a chance to yield to the incoming ELSP (and send the ACk for the
promotion) and so ends up being blamed for the reset.

If we see that a context switch has occurred since setting the
preemption timeout, but have not yet received the ACK for the ELSP
promotion, rearm the preemption timer and check again. This is
especially significant if the first context was not schedulable and so
we used the shortest timer possible, greatly increasing the chance of
accidentally blaming the second innocent context.

Fixes: 3a7a92aba8fb ("drm/i915/execlists: Force preemption")
Fixes: d12acee84ffb ("drm/i915/execlists: Cancel banned contexts on schedule-out")
Reported-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Tested-by: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220921135258.1714873-1-andrzej.hajda@intel.com
(cherry picked from commit 107ba1a2c705f4358f2602ec2f2fd821bb651f42)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index 633a7e5dba3b..6b5d4ea22b67 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -165,6 +165,21 @@ struct intel_engine_execlists {
 	 */
 	struct timer_list preempt;
 
+	/**
+	 * @preempt_target: active request at the time of the preemption request
+	 *
+	 * We force a preemption to occur if the pending contexts have not
+	 * been promoted to active upon receipt of the CS ack event within
+	 * the timeout. This timeout maybe chosen based on the target,
+	 * using a very short timeout if the context is no longer schedulable.
+	 * That short timeout may not be applicable to other contexts, so
+	 * if a context switch should happen within before the preemption
+	 * timeout, we may shoot early at an innocent context. To prevent this,
+	 * we record which context was active at the time of the preemption
+	 * request and only reset that context upon the timeout.
+	 */
+	const struct i915_request *preempt_target;
+
 	/**
 	 * @ccid: identifier for contexts submitted to this engine
 	 */
diff --git a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
index 4b909cb88cdf..c718e6dc40b5 100644
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -1241,6 +1241,9 @@ static unsigned long active_preempt_timeout(struct intel_engine_cs *engine,
 	if (!rq)
 		return 0;
 
+	/* Only allow ourselves to force reset the currently active context */
+	engine->execlists.preempt_target = rq;
+
 	/* Force a fast reset for terminated contexts (ignoring sysfs!) */
 	if (unlikely(intel_context_is_banned(rq->context) || bad_request(rq)))
 		return INTEL_CONTEXT_BANNED_PREEMPT_TIMEOUT_MS;
@@ -2427,8 +2430,24 @@ static void execlists_submission_tasklet(struct tasklet_struct *t)
 	GEM_BUG_ON(inactive - post > ARRAY_SIZE(post));
 
 	if (unlikely(preempt_timeout(engine))) {
+		const struct i915_request *rq = *engine->execlists.active;
+
+		/*
+		 * If after the preempt-timeout expired, we are still on the
+		 * same active request/context as before we initiated the
+		 * preemption, reset the engine.
+		 *
+		 * However, if we have processed a CS event to switch contexts,
+		 * but not yet processed the CS event for the pending
+		 * preemption, reset the timer allowing the new context to
+		 * gracefully exit.
+		 */
 		cancel_timer(&engine->execlists.preempt);
-		engine->execlists.error_interrupt |= ERROR_PREEMPT;
+		if (rq == engine->execlists.preempt_target)
+			engine->execlists.error_interrupt |= ERROR_PREEMPT;
+		else
+			set_timer_ms(&engine->execlists.preempt,
+				     active_preempt_timeout(engine, rq));
 	}
 
 	if (unlikely(READ_ONCE(engine->execlists.error_interrupt))) {

