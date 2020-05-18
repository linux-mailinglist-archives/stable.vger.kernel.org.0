Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BAD1D79F8
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 15:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgERNf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 09:35:26 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:60335 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726775AbgERNf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 09:35:26 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 87D8819409EF;
        Mon, 18 May 2020 09:35:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 18 May 2020 09:35:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8Lb6jM
        CNXMcg/wcRN2FOdXjvAdh8099lAipMw8DGMzM=; b=2p6eQjcYkmKFdntQsNJ9f5
        onWqv1PJzRksKnIksXmC3yp/HB+xdsyejbBVWlRICkhHREXyQU4tC4EBrQXY72Ed
        4iG8V9IlzltDmFTap9kqIit5emhAC8t/a41sLFdEd/0uYjixJdRxVcULsAORb6kg
        DqOurhC+wmtameLnC0qXSSNDLV/O6fhjv7oBB6xt7RSxoB0i6fw8SFueFxnEcooN
        wMStwKusGF0p2ucR8SHmPVxSQRsNp9uod4UOHANMOi66CfRXgRFl3pARxxPJpfW7
        9w0Mak97PuUhuzUg+pynZ2ZajAUg92XpyCo+Lxa1a5LnJ0kgQIkKGO27xYH+otHg
        ==
X-ME-Sender: <xms:HI_CXrrxvVVHN-wnhWRdzfkQHddX1RcS2jkEd7iBwMbrIQ0eKQTI0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:HI_CXloke5QAwPYm8VsU1U6MxfZGtoEWZT-ftRjqk-m0sUxEZc1Ixg>
    <xmx:HI_CXoOub2HbU40lh31TmEAvQLYE_f28_fL3joWGhcZY3HKA-JF76w>
    <xmx:HI_CXu5r_pK3CteuNGtMlV9ZzIWJeeMs0UgIzy0NBCpJxKoJPhojGg>
    <xmx:HI_CXvj4BKuT6qpYt-wFh-MwRcUn3bQbr26nDJ9QvfxWMc6MGqMb-A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1BCEF3280068;
        Mon, 18 May 2020 09:35:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/execlists: Track inflight CCID" failed to apply to 5.6-stable tree
To:     chris@chris-wilson.co.uk, mika.kuoppala@linux.intel.com,
        rodrigo.vivi@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 May 2020 15:35:21 +0200
Message-ID: <1589808921247149@kroah.com>
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

From 1bc6a60143a4f9264cc6e09ceb9919f4e813a872 Mon Sep 17 00:00:00 2001
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
(cherry picked from commit 5c4a53e3b1cbc38d0906e382f1037290658759bb)
(cherry picked from commit 134711240307d5586ae8e828d2699db70a8b74f2)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index 8dd210a2c340..0be674ae1cf6 100644
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
index e8b02f84aa3d..77420372d813 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1239,13 +1239,17 @@ __execlists_schedule_in(struct i915_request *rq)
 
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
@@ -1289,7 +1293,8 @@ static void kick_siblings(struct i915_request *rq, struct intel_context *ce)
 
 static inline void
 __execlists_schedule_out(struct i915_request *rq,
-			 struct intel_engine_cs * const engine)
+			 struct intel_engine_cs * const engine,
+			 unsigned int ccid)
 {
 	struct intel_context * const ce = rq->context;
 
@@ -1307,6 +1312,14 @@ __execlists_schedule_out(struct i915_request *rq,
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
@@ -1332,15 +1345,17 @@ execlists_schedule_out(struct i915_request *rq)
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
@@ -3556,7 +3571,7 @@ static void enable_execlists(struct intel_engine_cs *engine)
 
 	enable_error_interrupt(engine);
 
-	engine->context_tag = 0;
+	engine->context_tag = GENMASK(BITS_PER_LONG - 2, 0);
 }
 
 static bool unexpected_starting_state(struct intel_engine_cs *engine)
diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index b5030192be3e..cf2c01f17da8 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -1327,11 +1327,10 @@ static int oa_get_render_ctx_id(struct i915_perf_stream *stream)
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

