Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205ED2AB4E6
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 11:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgKIKbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 05:31:15 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:51713 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726176AbgKIKbP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 05:31:15 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 479D6930;
        Mon,  9 Nov 2020 05:31:14 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 09 Nov 2020 05:31:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=9wU07k
        N17XEmuTS2YcD9PKzutB2rAn5aYOAn0imsgPQ=; b=JQjGb5iAdOr2tQH+KcarDm
        TzVWW4JWDg8at2osnMS6B3w1+nP1kgwponT9YryASLCuoJ+DU1UjJZ/hsbk+IXoD
        530QLA/GJa+sF1KynuSijLmnsXn7xzwAHWO+npgq9LDRgEXLN4GMC3wI7GvWSo3x
        U15ANpUBuwgCKtH1hLBAkLNzVVHBppgM0iTN2ZIAxfANmXZrm0uvGSHSwjquWilc
        Ok9LyrW/MMgpED563XIdSRDd7qRHY+L1nVTewV/0iKkXLv6efRJ4vHBeDSgC6xlI
        PVKE6QSa3h2LWLYLszqWBFyKE6U5ZuaTvBf+rx+LY6kyGf9a1oHZ3AyTErKZwibQ
        ==
X-ME-Sender: <xms:cRqpXwqtMyvb7uYRr3Tg3mcLdHyX_VuRXSxx7da2fpc8dlOj38h9wA>
    <xme:cRqpX2rFpUuV2k9_6FU56fNBJoBkWmdjBemvHvoRkRFMMfzqPfn-id5YyUzfinY0I
    k7C08xkoym4iA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduhedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:cRqpX1OiCgZCbmHvinv5U_pkzXfqJ9hWjb0wADWe88NwpYhPg9uDgw>
    <xmx:cRqpX34bxQOVlH2w8Wei-nRyVd0vWtIcAX4rfUHtoKJ223x8GmO8Fw>
    <xmx:cRqpX_6sC4qVKAEFOc1QberfsZM9XDRhDHSEjA4Wod_Pil5nemPzTg>
    <xmx:cRqpXxl1tYBGDj2iSMm8roPJP9ckYNkouGvglP0NOoxn_cHXwsNv-p-YeU8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E1DA5328005D;
        Mon,  9 Nov 2020 05:31:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Use the local HWSP offset during submission" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, joonas.lahtinen@linux.intel.com,
        mika.kuoppala@linux.intel.com, rodrigo.vivi@intel.com,
        stable@vger.kernel.org, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Nov 2020 11:32:13 +0100
Message-ID: <1604917933188136@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 8ce70996f759a37bac92e69ae0addd715227bfd1 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Thu, 22 Oct 2020 07:41:27 +0100
Subject: [PATCH] drm/i915/gt: Use the local HWSP offset during submission

We wrap the timeline on construction of the next request, but there may
still be requests in flight that have not yet finalized the breadcrumb.
(The breadcrumb is delayed as we need engine-local offsets, and for the
virtual engine that is not known until execution.) As such, by the time
we write to the timeline's HWSP offset it may have changed, and we
should use the value we preserved in the request instead.

Though the window is small and infrequent (at full flow we can expect a
timeline's seqno to wrap once every 30 minutes), the impact of writing
the old seqno into the new HWSP is severe: the old requests are never
completed, and the new requests are completed before they are even
submitted.

Fixes: ebece7539242 ("drm/i915: Keep timeline HWSP allocated until idle across the system")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.2+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201022064127.10159-1-chris@chris-wilson.co.uk
(cherry picked from commit c10f6019d0b2dc8a6a62b55459f3ada5bc4e5e1a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index a32aabce7901..d12861cf0753 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -3547,6 +3547,19 @@ static const struct intel_context_ops execlists_context_ops = {
 	.destroy = execlists_context_destroy,
 };
 
+static u32 hwsp_offset(const struct i915_request *rq)
+{
+	const struct intel_timeline_cacheline *cl;
+
+	/* Before the request is executed, the timeline/cachline is fixed */
+
+	cl = rcu_dereference_protected(rq->hwsp_cacheline, 1);
+	if (cl)
+		return cl->ggtt_offset;
+
+	return rcu_dereference_protected(rq->timeline, 1)->hwsp_offset;
+}
+
 static int gen8_emit_init_breadcrumb(struct i915_request *rq)
 {
 	u32 *cs;
@@ -3569,7 +3582,7 @@ static int gen8_emit_init_breadcrumb(struct i915_request *rq)
 	*cs++ = MI_NOOP;
 
 	*cs++ = MI_STORE_DWORD_IMM_GEN4 | MI_USE_GGTT;
-	*cs++ = i915_request_timeline(rq)->hwsp_offset;
+	*cs++ = hwsp_offset(rq);
 	*cs++ = 0;
 	*cs++ = rq->fence.seqno - 1;
 
@@ -4886,11 +4899,9 @@ gen8_emit_fini_breadcrumb_tail(struct i915_request *request, u32 *cs)
 	return gen8_emit_wa_tail(request, cs);
 }
 
-static u32 *emit_xcs_breadcrumb(struct i915_request *request, u32 *cs)
+static u32 *emit_xcs_breadcrumb(struct i915_request *rq, u32 *cs)
 {
-	u32 addr = i915_request_active_timeline(request)->hwsp_offset;
-
-	return gen8_emit_ggtt_write(cs, request->fence.seqno, addr, 0);
+	return gen8_emit_ggtt_write(cs, rq->fence.seqno, hwsp_offset(rq), 0);
 }
 
 static u32 *gen8_emit_fini_breadcrumb(struct i915_request *rq, u32 *cs)
@@ -4909,7 +4920,7 @@ static u32 *gen8_emit_fini_breadcrumb_rcs(struct i915_request *request, u32 *cs)
 	/* XXX flush+write+CS_STALL all in one upsets gem_concurrent_blt:kbl */
 	cs = gen8_emit_ggtt_write_rcs(cs,
 				      request->fence.seqno,
-				      i915_request_active_timeline(request)->hwsp_offset,
+				      hwsp_offset(request),
 				      PIPE_CONTROL_FLUSH_ENABLE |
 				      PIPE_CONTROL_CS_STALL);
 
@@ -4921,7 +4932,7 @@ gen11_emit_fini_breadcrumb_rcs(struct i915_request *request, u32 *cs)
 {
 	cs = gen8_emit_ggtt_write_rcs(cs,
 				      request->fence.seqno,
-				      i915_request_active_timeline(request)->hwsp_offset,
+				      hwsp_offset(request),
 				      PIPE_CONTROL_CS_STALL |
 				      PIPE_CONTROL_TILE_CACHE_FLUSH |
 				      PIPE_CONTROL_RENDER_TARGET_CACHE_FLUSH |
@@ -4991,7 +5002,7 @@ gen12_emit_fini_breadcrumb_rcs(struct i915_request *request, u32 *cs)
 {
 	cs = gen12_emit_ggtt_write_rcs(cs,
 				       request->fence.seqno,
-				       i915_request_active_timeline(request)->hwsp_offset,
+				       hwsp_offset(request),
 				       PIPE_CONTROL0_HDC_PIPELINE_FLUSH,
 				       PIPE_CONTROL_CS_STALL |
 				       PIPE_CONTROL_TILE_CACHE_FLUSH |
diff --git a/drivers/gpu/drm/i915/gt/intel_timeline.c b/drivers/gpu/drm/i915/gt/intel_timeline.c
index a2f74cefe4c3..7ea94d201fe6 100644
--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -188,10 +188,14 @@ cacheline_alloc(struct intel_timeline_hwsp *hwsp, unsigned int cacheline)
 	return cl;
 }
 
-static void cacheline_acquire(struct intel_timeline_cacheline *cl)
+static void cacheline_acquire(struct intel_timeline_cacheline *cl,
+			      u32 ggtt_offset)
 {
-	if (cl)
-		i915_active_acquire(&cl->active);
+	if (!cl)
+		return;
+
+	cl->ggtt_offset = ggtt_offset;
+	i915_active_acquire(&cl->active);
 }
 
 static void cacheline_release(struct intel_timeline_cacheline *cl)
@@ -340,7 +344,7 @@ int intel_timeline_pin(struct intel_timeline *tl, struct i915_gem_ww_ctx *ww)
 	GT_TRACE(tl->gt, "timeline:%llx using HWSP offset:%x\n",
 		 tl->fence_context, tl->hwsp_offset);
 
-	cacheline_acquire(tl->hwsp_cacheline);
+	cacheline_acquire(tl->hwsp_cacheline, tl->hwsp_offset);
 	if (atomic_fetch_inc(&tl->pin_count)) {
 		cacheline_release(tl->hwsp_cacheline);
 		__i915_vma_unpin(tl->hwsp_ggtt);
@@ -515,7 +519,7 @@ __intel_timeline_get_seqno(struct intel_timeline *tl,
 	GT_TRACE(tl->gt, "timeline:%llx using HWSP offset:%x\n",
 		 tl->fence_context, tl->hwsp_offset);
 
-	cacheline_acquire(cl);
+	cacheline_acquire(cl, tl->hwsp_offset);
 	tl->hwsp_cacheline = cl;
 
 	*seqno = timeline_advance(tl);
@@ -573,9 +577,7 @@ int intel_timeline_read_hwsp(struct i915_request *from,
 	if (err)
 		goto out;
 
-	*hwsp = i915_ggtt_offset(cl->hwsp->vma) +
-		ptr_unmask_bits(cl->vaddr, CACHELINE_BITS) * CACHELINE_BYTES;
-
+	*hwsp = cl->ggtt_offset;
 out:
 	i915_active_release(&cl->active);
 	return err;
diff --git a/drivers/gpu/drm/i915/gt/intel_timeline_types.h b/drivers/gpu/drm/i915/gt/intel_timeline_types.h
index 02181c5020db..4474f487f589 100644
--- a/drivers/gpu/drm/i915/gt/intel_timeline_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_timeline_types.h
@@ -94,6 +94,8 @@ struct intel_timeline_cacheline {
 	struct intel_timeline_hwsp *hwsp;
 	void *vaddr;
 
+	u32 ggtt_offset;
+
 	struct rcu_head rcu;
 };
 

