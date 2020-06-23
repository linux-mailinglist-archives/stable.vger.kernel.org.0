Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17532204B7A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 09:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731158AbgFWHql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 03:46:41 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:57643 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731041AbgFWHql (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 03:46:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 91127CB3;
        Tue, 23 Jun 2020 03:46:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 23 Jun 2020 03:46:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9sFcf3
        +wNOSTpxWqfL4cz6XyXCtCSRUPyDb24g5zwh0=; b=YCQ8DLWPA2zqQrWPTuB9Ch
        MrFwvs7319A11v36rn4rZMMct4XP9vPIqy/P9LU6aT0McLU2rKIBKCfzPRlwZCdv
        coZGHHgfLmPIeqgN4X/xM9NzTstl+F7n7m+bUQvc3DCJC//cVvh4qf784AQ6QnnC
        xVhAouYxrGyeVImrxdOB0QhG48ocabT++QkOAgF4V9NcqA2q4esYwO1/9WJGaWCI
        LZLmeglP3dxu/2/AbWVkgSVvLJbHXq7AVYYEs8jOPN9oFWV+zCDXg92AYDBn03F6
        wD9Ua5al4/VUPwvjhlwSYChLkQTi17r1Hg/4hbyTF7xQLSEgsTFAyq74AEQhW44Q
        ==
X-ME-Sender: <xms:X7PxXqxAKnifC2JRboCTG7mubAkWOONch2ifGGomv5WJ3jxJaAvEig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekfedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtud
    eujefhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhr
    ghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:X7PxXmQtni6oH3OEhjwfhOrXIV8I9Rd72ja6e7MI9EFJi9K_BlQpcQ>
    <xmx:X7PxXsWDsX3_WAFp-X5rN_Zitbt9jRes6fc4w_UhuP4tvZ8FFw-yew>
    <xmx:X7PxXgiFd5VJ7uWcJiZ90hVOZ_PbiY_czNCks8QpsrTFv8sbb505XQ>
    <xmx:YLPxXr8ozVuztShh1V9xsXifDPY_qXi36c74E1dCzIqTpppg4AYVinpyLxQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 137983067491;
        Tue, 23 Jun 2020 03:46:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/execlists: Track inflight CCID" failed to apply to 5.7-stable tree
To:     chris@chris-wilson.co.uk, mika.kuoppala@linux.intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 09:46:30 +0200
Message-ID: <15928983908104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5c4a53e3b1cbc38d0906e382f1037290658759bb Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Tue, 28 Apr 2020 19:47:50 +0100
Subject: [PATCH] drm/i915/execlists: Track inflight CCID

The presumption is that by using a circular counter that is twice as
large as the maximum ELSP submission, we would never reuse the same CCID
for two inflight contexts.

However, if we continually preempt an active context such that it always
remains inflight, it can be resubmitted with an arbitrary number of
paired contexts. As each of its paired contexts will use a new CCID,
eventually it will wrap and submit two ELSP with the same CCID.

Rather than use a simple circular counter, switch over to a small bitmap
of inflight ids so we can avoid reusing one that is still potentially
active.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1796
Fixes: 2935ed5339c4 ("drm/i915: Remove logical HW ID")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200428184751.11257-2-chris@chris-wilson.co.uk

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index 470bdc73220a..cfe4feaee982 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -309,8 +309,7 @@ struct intel_engine_cs {
 	u32 context_size;
 	u32 mmio_base;
 
-	unsigned int context_tag;
-#define NUM_CONTEXT_TAG roundup_pow_of_two(2 * EXECLIST_MAX_PORTS)
+	unsigned long context_tag;
 
 	struct rb_node uabi_node;
 
diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 7d56207276d5..05e2bb483db3 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1389,13 +1389,17 @@ __execlists_schedule_in(struct i915_request *rq)
 
 	if (ce->tag) {
 		/* Use a fixed tag for OA and friends */
+		GEM_BUG_ON(ce->tag <= BITS_PER_LONG);
 		ce->lrc.ccid = ce->tag;
 	} else {
 		/* We don't need a strict matching tag, just different values */
-		ce->lrc.ccid =
-			(++engine->context_tag % NUM_CONTEXT_TAG) <<
-			(GEN11_SW_CTX_ID_SHIFT - 32);
-		BUILD_BUG_ON(NUM_CONTEXT_TAG > GEN12_MAX_CONTEXT_HW_ID);
+		unsigned int tag = ffs(engine->context_tag);
+
+		GEM_BUG_ON(tag == 0 || tag >= BITS_PER_LONG);
+		clear_bit(tag - 1, &engine->context_tag);
+		ce->lrc.ccid = tag << (GEN11_SW_CTX_ID_SHIFT - 32);
+
+		BUILD_BUG_ON(BITS_PER_LONG > GEN12_MAX_CONTEXT_HW_ID);
 	}
 
 	ce->lrc.ccid |= engine->execlists.ccid;
@@ -1439,7 +1443,8 @@ static void kick_siblings(struct i915_request *rq, struct intel_context *ce)
 
 static inline void
 __execlists_schedule_out(struct i915_request *rq,
-			 struct intel_engine_cs * const engine)
+			 struct intel_engine_cs * const engine,
+			 unsigned int ccid)
 {
 	struct intel_context * const ce = rq->context;
 
@@ -1457,6 +1462,14 @@ __execlists_schedule_out(struct i915_request *rq,
 	    i915_request_completed(rq))
 		intel_engine_add_retire(engine, ce->timeline);
 
+	ccid >>= GEN11_SW_CTX_ID_SHIFT - 32;
+	ccid &= GEN12_MAX_CONTEXT_HW_ID;
+	if (ccid < BITS_PER_LONG) {
+		GEM_BUG_ON(ccid == 0);
+		GEM_BUG_ON(test_bit(ccid - 1, &engine->context_tag));
+		set_bit(ccid - 1, &engine->context_tag);
+	}
+
 	intel_context_update_runtime(ce);
 	intel_engine_context_out(engine);
 	execlists_context_status_change(rq, INTEL_CONTEXT_SCHEDULE_OUT);
@@ -1482,15 +1495,17 @@ execlists_schedule_out(struct i915_request *rq)
 {
 	struct intel_context * const ce = rq->context;
 	struct intel_engine_cs *cur, *old;
+	u32 ccid;
 
 	trace_i915_request_out(rq);
 
+	ccid = rq->context->lrc.ccid;
 	old = READ_ONCE(ce->inflight);
 	do
 		cur = ptr_unmask_bits(old, 2) ? ptr_dec(old) : NULL;
 	while (!try_cmpxchg(&ce->inflight, &old, cur));
 	if (!cur)
-		__execlists_schedule_out(rq, old);
+		__execlists_schedule_out(rq, old, ccid);
 
 	i915_request_put(rq);
 }
@@ -3990,7 +4005,7 @@ static void enable_execlists(struct intel_engine_cs *engine)
 
 	enable_error_interrupt(engine);
 
-	engine->context_tag = 0;
+	engine->context_tag = GENMASK(BITS_PER_LONG - 2, 0);
 }
 
 static bool unexpected_starting_state(struct intel_engine_cs *engine)
diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index 04ad21960688..c533f569dd42 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -1280,11 +1280,10 @@ static int oa_get_render_ctx_id(struct i915_perf_stream *stream)
 			((1U << GEN11_SW_CTX_ID_WIDTH) - 1) << (GEN11_SW_CTX_ID_SHIFT - 32);
 		/*
 		 * Pick an unused context id
-		 * 0 - (NUM_CONTEXT_TAG - 1) are used by other contexts
+		 * 0 - BITS_PER_LONG are used by other contexts
 		 * GEN12_MAX_CONTEXT_HW_ID (0x7ff) is used by idle context
 		 */
 		stream->specific_ctx_id = (GEN12_MAX_CONTEXT_HW_ID - 1) << (GEN11_SW_CTX_ID_SHIFT - 32);
-		BUILD_BUG_ON((GEN12_MAX_CONTEXT_HW_ID - 1) < NUM_CONTEXT_TAG);
 		break;
 	}
 
diff --git a/drivers/gpu/drm/i915/selftests/i915_vma.c b/drivers/gpu/drm/i915/selftests/i915_vma.c
index 58b5f40a07dd..af89c7fc8f59 100644
--- a/drivers/gpu/drm/i915/selftests/i915_vma.c
+++ b/drivers/gpu/drm/i915/selftests/i915_vma.c
@@ -173,7 +173,7 @@ static int igt_vma_create(void *arg)
 		}
 
 		nc = 0;
-		for_each_prime_number(num_ctx, 2 * NUM_CONTEXT_TAG) {
+		for_each_prime_number(num_ctx, 2 * BITS_PER_LONG) {
 			for (; nc < num_ctx; nc++) {
 				ctx = mock_context(i915, "mock");
 				if (!ctx)

