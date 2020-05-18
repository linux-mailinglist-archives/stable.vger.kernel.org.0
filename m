Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731ED1D79F1
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 15:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgERNfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 09:35:05 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:57989 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727876AbgERNfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 09:35:04 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9F3C919409ED;
        Mon, 18 May 2020 09:35:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 18 May 2020 09:35:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KpemSx
        md0dbpytSyA3Y4+A7NJrcKEAOp8M8TFbjmgpU=; b=hFuemElTX2pTvQx4KGJmxM
        ynmSra2nCU7goeEtxkUAkiDDSIXQsoUH/io2neTzBeCEufpT+2H7RaCrZuMgxosk
        LavYdJ5vxSPST6lQTv4TE2vQwjlYcpY6OO1Unb+Vze5GU5hCqYG3cfJNAaquAT/w
        KufxEut7jTnnqv7pdge8Cw+8XPus63IDbHEFHdiqyu0Y0YnLMlTiSI3iMORu2fyM
        x9mHfG4nTkl0mTRwH9oba7QKq7mVP+3gscAR76Nj1ipPkK97llq/7ffKxY/qiHrF
        arBDrBnEjLAQ2dIldToJceONYuVSQF2aptW5CuUoJ1L+6/JyMvEy3KxnRjpJ5Hcg
        ==
X-ME-Sender: <xms:BY_CXjLP1tvC9r52WDZ_ZakEiv69E0P2cVEyjrYtfOTHtnRhlVspBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:BY_CXnJAqz7HZl-aGD-tAEP8baOUhzByqKGW3J77uxhtjw6WR_2xFQ>
    <xmx:BY_CXrs0Scfum_8xz0FS850wTav9ev0S1hb9C1D3gXe8V1y5Doc8sA>
    <xmx:BY_CXsbh0qoxDoYQFUofvVBl_b0CRb3LemKjIabwHOV8V-5oChA68g>
    <xmx:Bo_CXjAOhBRUzRiyw-LLTZw6OwxKGX4K8G83gZlkQG4lVSnMrmCKiQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 269F930663F5;
        Mon, 18 May 2020 09:35:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/execlists: Avoid reusing the same logical CCID" failed to apply to 5.6-stable tree
To:     chris@chris-wilson.co.uk, mika.kuoppala@linux.intel.com,
        rodrigo.vivi@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 May 2020 15:34:59 +0200
Message-ID: <1589808899123105@kroah.com>
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

From 53b2622e774681943230fb9f31096512fff99fe7 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Tue, 28 Apr 2020 19:47:49 +0100
Subject: [PATCH] drm/i915/execlists: Avoid reusing the same logical CCID

The bspec is confusing on the nature of the upper 32bits of the LRC
descriptor. Once upon a time, it said that it uses the upper 32b to
decide if it should perform a lite-restore, and so we must ensure that
each unique context submitted to HW is given a unique CCID [for the
duration of it being on the HW]. Currently, this is achieved by using
a small circular tag, and assigning every context submitted to HW a
new id. However, this tag is being cleared on repinning an inflight
context such that we end up re-using the 0 tag for multiple contexts.

To avoid accidentally clearing the CCID in the upper 32bits of the LRC
descriptor, split the descriptor into two dwords so we can update the
GGTT address separately from the CCID.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1796
Fixes: 2935ed5339c4 ("drm/i915: Remove logical HW ID")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200428184751.11257-1-chris@chris-wilson.co.uk
(cherry picked from commit 2632f174a2e1a5fd40a70404fa8ccfd0b1f79ebd)
(cherry picked from commit a4b70fcc587860f4b972f68217d8ebebe295ec15)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_context_types.h b/drivers/gpu/drm/i915/gt/intel_context_types.h
index 07cb83a0d017..ca0d4f4f3615 100644
--- a/drivers/gpu/drm/i915/gt/intel_context_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_context_types.h
@@ -69,7 +69,13 @@ struct intel_context {
 #define CONTEXT_NOPREEMPT		7
 
 	u32 *lrc_reg_state;
-	u64 lrc_desc;
+	union {
+		struct {
+			u32 lrca;
+			u32 ccid;
+		};
+		u64 desc;
+	} lrc;
 	u32 tag; /* cookie passed to HW to track this context on submission */
 
 	/* Time on GPU as tracked by the hw. */
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index 763f8f530ded..8dd210a2c340 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -156,6 +156,11 @@ struct intel_engine_execlists {
 	 */
 	struct i915_priolist default_priolist;
 
+	/**
+	 * @ccid: identifier for contexts submitted to this engine
+	 */
+	u32 ccid;
+
 	/**
 	 * @yield: CCID at the time of the last semaphore-wait interrupt.
 	 *
diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index a21b962c736f..e8b02f84aa3d 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -456,10 +456,10 @@ assert_priority_queue(const struct i915_request *prev,
  * engine info, SW context ID and SW counter need to form a unique number
  * (Context ID) per lrc.
  */
-static u64
+static u32
 lrc_descriptor(struct intel_context *ce, struct intel_engine_cs *engine)
 {
-	u64 desc;
+	u32 desc;
 
 	desc = INTEL_LEGACY_32B_CONTEXT;
 	if (i915_vm_is_4lvl(ce->vm))
@@ -470,21 +470,7 @@ lrc_descriptor(struct intel_context *ce, struct intel_engine_cs *engine)
 	if (IS_GEN(engine->i915, 8))
 		desc |= GEN8_CTX_L3LLC_COHERENT;
 
-	desc |= i915_ggtt_offset(ce->state); /* bits 12-31 */
-	/*
-	 * The following 32bits are copied into the OA reports (dword 2).
-	 * Consider updating oa_get_render_ctx_id in i915_perf.c when changing
-	 * anything below.
-	 */
-	if (INTEL_GEN(engine->i915) >= 11) {
-		desc |= (u64)engine->instance << GEN11_ENGINE_INSTANCE_SHIFT;
-								/* bits 48-53 */
-
-		desc |= (u64)engine->class << GEN11_ENGINE_CLASS_SHIFT;
-								/* bits 61-63 */
-	}
-
-	return desc;
+	return i915_ggtt_offset(ce->state) | desc;
 }
 
 static inline unsigned int dword_in_page(void *addr)
@@ -1192,7 +1178,7 @@ static void reset_active(struct i915_request *rq,
 	__execlists_update_reg_state(ce, engine, head);
 
 	/* We've switched away, so this should be a no-op, but intent matters */
-	ce->lrc_desc |= CTX_DESC_FORCE_RESTORE;
+	ce->lrc.desc |= CTX_DESC_FORCE_RESTORE;
 }
 
 static u32 intel_context_get_runtime(const struct intel_context *ce)
@@ -1251,18 +1237,19 @@ __execlists_schedule_in(struct i915_request *rq)
 	if (IS_ENABLED(CONFIG_DRM_I915_DEBUG_GEM))
 		execlists_check_context(ce, engine);
 
-	ce->lrc_desc &= ~GENMASK_ULL(47, 37);
 	if (ce->tag) {
 		/* Use a fixed tag for OA and friends */
-		ce->lrc_desc |= (u64)ce->tag << 32;
+		ce->lrc.ccid = ce->tag;
 	} else {
 		/* We don't need a strict matching tag, just different values */
-		ce->lrc_desc |=
-			(u64)(++engine->context_tag % NUM_CONTEXT_TAG) <<
-			GEN11_SW_CTX_ID_SHIFT;
+		ce->lrc.ccid =
+			(++engine->context_tag % NUM_CONTEXT_TAG) <<
+			(GEN11_SW_CTX_ID_SHIFT - 32);
 		BUILD_BUG_ON(NUM_CONTEXT_TAG > GEN12_MAX_CONTEXT_HW_ID);
 	}
 
+	ce->lrc.ccid |= engine->execlists.ccid;
+
 	__intel_gt_pm_get(engine->gt);
 	execlists_context_status_change(rq, INTEL_CONTEXT_SCHEDULE_IN);
 	intel_engine_context_in(engine);
@@ -1361,7 +1348,7 @@ execlists_schedule_out(struct i915_request *rq)
 static u64 execlists_update_context(struct i915_request *rq)
 {
 	struct intel_context *ce = rq->context;
-	u64 desc = ce->lrc_desc;
+	u64 desc = ce->lrc.desc;
 	u32 tail, prev;
 
 	/*
@@ -1400,7 +1387,7 @@ static u64 execlists_update_context(struct i915_request *rq)
 	 */
 	wmb();
 
-	ce->lrc_desc &= ~CTX_DESC_FORCE_RESTORE;
+	ce->lrc.desc &= ~CTX_DESC_FORCE_RESTORE;
 	return desc;
 }
 
@@ -1785,7 +1772,7 @@ timeslice_yield(const struct intel_engine_execlists *el,
 	 * safe, yield if it might be stuck -- it will be given a fresh
 	 * timeslice in the near future.
 	 */
-	return upper_32_bits(rq->context->lrc_desc) == READ_ONCE(el->yield);
+	return rq->context->lrc.ccid == READ_ONCE(el->yield);
 }
 
 static bool
@@ -3071,7 +3058,7 @@ __execlists_context_pin(struct intel_context *ce,
 	if (IS_ERR(vaddr))
 		return PTR_ERR(vaddr);
 
-	ce->lrc_desc = lrc_descriptor(ce, engine) | CTX_DESC_FORCE_RESTORE;
+	ce->lrc.lrca = lrc_descriptor(ce, engine) | CTX_DESC_FORCE_RESTORE;
 	ce->lrc_reg_state = vaddr + LRC_STATE_PN * PAGE_SIZE;
 	__execlists_update_reg_state(ce, engine, ce->ring->tail);
 
@@ -3100,7 +3087,7 @@ static void execlists_context_reset(struct intel_context *ce)
 				 ce, ce->engine, ce->ring, true);
 	__execlists_update_reg_state(ce, ce->engine, ce->ring->tail);
 
-	ce->lrc_desc |= CTX_DESC_FORCE_RESTORE;
+	ce->lrc.desc |= CTX_DESC_FORCE_RESTORE;
 }
 
 static const struct intel_context_ops execlists_context_ops = {
@@ -3781,7 +3768,7 @@ static void __execlists_reset(struct intel_engine_cs *engine, bool stalled)
 		     head, ce->ring->tail);
 	__execlists_reset_reg_state(ce, engine);
 	__execlists_update_reg_state(ce, engine, head);
-	ce->lrc_desc |= CTX_DESC_FORCE_RESTORE; /* paranoid: GPU was reset! */
+	ce->lrc.desc |= CTX_DESC_FORCE_RESTORE; /* paranoid: GPU was reset! */
 
 unwind:
 	/* Push back any incomplete requests for replay after the reset. */
@@ -4548,6 +4535,11 @@ int intel_execlists_submission_setup(struct intel_engine_cs *engine)
 	else
 		execlists->csb_size = GEN11_CSB_ENTRIES;
 
+	if (INTEL_GEN(engine->i915) >= 11) {
+		execlists->ccid |= engine->instance << (GEN11_ENGINE_INSTANCE_SHIFT - 32);
+		execlists->ccid |= engine->class << (GEN11_ENGINE_CLASS_SHIFT - 32);
+	}
+
 	reset_csb_pointers(engine);
 
 	/* Finally, take ownership and responsibility for cleanup! */
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index fe7778c28d2d..aa6d56e25a10 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -217,7 +217,7 @@ static void guc_wq_item_append(struct intel_guc *guc,
 static void guc_add_request(struct intel_guc *guc, struct i915_request *rq)
 {
 	struct intel_engine_cs *engine = rq->engine;
-	u32 ctx_desc = lower_32_bits(rq->context->lrc_desc);
+	u32 ctx_desc = rq->context->lrc.ccid;
 	u32 ring_tail = intel_ring_set_tail(rq->ring, rq->tail) / sizeof(u64);
 
 	guc_wq_item_append(guc, engine->guc_id, ctx_desc,
diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/gvt/scheduler.c
index cb11c3184085..6eb6710b35e9 100644
--- a/drivers/gpu/drm/i915/gvt/scheduler.c
+++ b/drivers/gpu/drm/i915/gvt/scheduler.c
@@ -290,7 +290,7 @@ static void
 shadow_context_descriptor_update(struct intel_context *ce,
 				 struct intel_vgpu_workload *workload)
 {
-	u64 desc = ce->lrc_desc;
+	u64 desc = ce->lrc.desc;
 
 	/*
 	 * Update bits 0-11 of the context descriptor which includes flags
@@ -300,7 +300,7 @@ shadow_context_descriptor_update(struct intel_context *ce,
 	desc |= (u64)workload->ctx_desc.addressing_mode <<
 		GEN8_CTX_ADDRESSING_MODE_SHIFT;
 
-	ce->lrc_desc = desc;
+	ce->lrc.desc = desc;
 }
 
 static int copy_workload_to_ring_buffer(struct intel_vgpu_workload *workload)
diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index 66a46e41d5ef..b5030192be3e 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -1310,8 +1310,7 @@ static int oa_get_render_ctx_id(struct i915_perf_stream *stream)
 			 * dropped by GuC. They won't be part of the context
 			 * ID in the OA reports, so squash those lower bits.
 			 */
-			stream->specific_ctx_id =
-				lower_32_bits(ce->lrc_desc) >> 12;
+			stream->specific_ctx_id = ce->lrc.lrca >> 12;
 
 			/*
 			 * GuC uses the top bit to signal proxy submission, so

