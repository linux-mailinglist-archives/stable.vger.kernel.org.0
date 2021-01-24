Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A80B301C44
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbhAXNe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:34:59 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:34181 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726398AbhAXNe7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:34:59 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id BFDE8E2F;
        Sun, 24 Jan 2021 08:33:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:33:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=XEEujJ
        R0rcvgPmpbbMWRtL3K66ovayb7ZGn4ODoCP/o=; b=OFMctk83SLo5rmH6Ew45G7
        sAjqGnZxzjN0qNAekI11ZIE9mihcNKtY9fR0EpC9ro1WCkXamQxyHdUoCe4q6VD4
        XJGHs9ur/+UocquYHziB9Qp1oLEoRIeDFNHBrZA+FdmX+FMMimjRaz4J7aiUrZ4h
        zDqy1TEXLMcCS5qNonJYG4u1HKtKOv5HwLqH3SZMLFrkd35QkRYFlCTSE6DkXhVZ
        stHxJYLoq/M7PMf21YbRCn7a2jHj68mc1EUtmPvoB7QsNQ0mpWVNfHx+I7b4OCtu
        nNnyKuGFmu85B4JihRGeX5ZIMF+KdHkOauy8icLlwwEp1kIRYz3w4QigcHVoLXYw
        ==
X-ME-Sender: <xms:QHcNYLWGlTDW1vxBCZMzm-0TIwfPgzZ95dEkq8RS7gFi7qfhqhhj0A>
    <xme:QHcNYDkVg3OmF6sUFhbcktsBN8-gbIiMpOZtAXPyxhPlalx9uIwTffSpDWh5TLSQi
    pZ6ZHRMWHx7sA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtudeuje
    fhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:QHcNYHaXzekE1vi6Fi4zLaaQlGTo9x7Tz6q1M_8k3-xt8qCo2OXL9Q>
    <xmx:QHcNYGXtSHyjIHmcPXgQ-Ekmah-7Hx_u1g5gNMo1tuVdsfc5MvHC4g>
    <xmx:QHcNYFmWtRsSeq8A0J5fZLXrMVkleiw5zeQ8529OVdUoSLwMar7L4Q>
    <xmx:QHcNYFtgyHbgxYbLFm5le-gOJfxKm7Qfdx_xpe8txAfheiv6qjrvrjEj1ug>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 176B824005A;
        Sun, 24 Jan 2021 08:33:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915: Check for rq->hwsp validity after acquiring RCU" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, jani.nikula@intel.com,
        stable@vger.kernel.org, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:33:51 +0100
Message-ID: <1611495231189205@kroah.com>
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

From 45db630e5f7ec83817c57c8ae387fe219bd42adf Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Mon, 18 Jan 2021 10:17:55 +0000
Subject: [PATCH] drm/i915: Check for rq->hwsp validity after acquiring RCU
 lock

Since we allow removing the timeline map at runtime, there is a risk
that rq->hwsp points into a stale page. To control that risk, we hold
the RCU read lock while reading *rq->hwsp, but we missed a couple of
important barriers. First, the unpinning / removal of the timeline map
must be after all RCU readers into that map are complete, i.e. after an
rcu barrier (in this case courtesy of call_rcu()). Secondly, we must
make sure that the rq->hwsp we are about to dereference under the RCU
lock is valid. In this case, we make the rq->hwsp pointer safe during
i915_request_retire() and so we know that rq->hwsp may become invalid
only after the request has been signaled. Therefore is the request is
not yet signaled when we acquire rq->hwsp under the RCU, we know that
rq->hwsp will remain valid for the duration of the RCU read lock.

This is a very small window that may lead to either considering the
request not completed (causing a delay until the request is checked
again, any wait for the request is not affected) or dereferencing an
invalid pointer.

Fixes: 3adac4689f58 ("drm/i915: Introduce concept of per-timeline (context) HWSP")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.1+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201218122421.18344-1-chris@chris-wilson.co.uk
(cherry picked from commit 9bb36cf66091ddf2d8840e5aa705ad3c93a6279b)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210118101755.476744-1-chris@chris-wilson.co.uk

diff --git a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
index a24cc1ff08a0..0625cbb3b431 100644
--- a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
+++ b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
@@ -134,11 +134,6 @@ static bool remove_signaling_context(struct intel_breadcrumbs *b,
 	return true;
 }
 
-static inline bool __request_completed(const struct i915_request *rq)
-{
-	return i915_seqno_passed(__hwsp_seqno(rq), rq->fence.seqno);
-}
-
 __maybe_unused static bool
 check_signal_order(struct intel_context *ce, struct i915_request *rq)
 {
@@ -257,7 +252,7 @@ static void signal_irq_work(struct irq_work *work)
 		list_for_each_entry_rcu(rq, &ce->signals, signal_link) {
 			bool release;
 
-			if (!__request_completed(rq))
+			if (!__i915_request_is_complete(rq))
 				break;
 
 			if (!test_and_clear_bit(I915_FENCE_FLAG_SIGNAL,
@@ -379,7 +374,7 @@ static void insert_breadcrumb(struct i915_request *rq)
 	 * straight onto a signaled list, and queue the irq worker for
 	 * its signal completion.
 	 */
-	if (__request_completed(rq)) {
+	if (__i915_request_is_complete(rq)) {
 		if (__signal_request(rq) &&
 		    llist_add(&rq->signal_node, &b->signaled_requests))
 			irq_work_queue(&b->irq_work);
diff --git a/drivers/gpu/drm/i915/gt/intel_timeline.c b/drivers/gpu/drm/i915/gt/intel_timeline.c
index 7ea94d201fe6..8015964043eb 100644
--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -126,6 +126,10 @@ static void __rcu_cacheline_free(struct rcu_head *rcu)
 	struct intel_timeline_cacheline *cl =
 		container_of(rcu, typeof(*cl), rcu);
 
+	/* Must wait until after all *rq->hwsp are complete before removing */
+	i915_gem_object_unpin_map(cl->hwsp->vma->obj);
+	__idle_hwsp_free(cl->hwsp, ptr_unmask_bits(cl->vaddr, CACHELINE_BITS));
+
 	i915_active_fini(&cl->active);
 	kfree(cl);
 }
@@ -133,11 +137,6 @@ static void __rcu_cacheline_free(struct rcu_head *rcu)
 static void __idle_cacheline_free(struct intel_timeline_cacheline *cl)
 {
 	GEM_BUG_ON(!i915_active_is_idle(&cl->active));
-
-	i915_gem_object_unpin_map(cl->hwsp->vma->obj);
-	i915_vma_put(cl->hwsp->vma);
-	__idle_hwsp_free(cl->hwsp, ptr_unmask_bits(cl->vaddr, CACHELINE_BITS));
-
 	call_rcu(&cl->rcu, __rcu_cacheline_free);
 }
 
@@ -179,7 +178,6 @@ cacheline_alloc(struct intel_timeline_hwsp *hwsp, unsigned int cacheline)
 		return ERR_CAST(vaddr);
 	}
 
-	i915_vma_get(hwsp->vma);
 	cl->hwsp = hwsp;
 	cl->vaddr = page_pack_bits(vaddr, cacheline);
 
diff --git a/drivers/gpu/drm/i915/i915_request.h b/drivers/gpu/drm/i915/i915_request.h
index 620b6fab2c5c..92adfee30c7c 100644
--- a/drivers/gpu/drm/i915/i915_request.h
+++ b/drivers/gpu/drm/i915/i915_request.h
@@ -434,7 +434,7 @@ static inline u32 hwsp_seqno(const struct i915_request *rq)
 
 static inline bool __i915_request_has_started(const struct i915_request *rq)
 {
-	return i915_seqno_passed(hwsp_seqno(rq), rq->fence.seqno - 1);
+	return i915_seqno_passed(__hwsp_seqno(rq), rq->fence.seqno - 1);
 }
 
 /**
@@ -465,11 +465,19 @@ static inline bool __i915_request_has_started(const struct i915_request *rq)
  */
 static inline bool i915_request_started(const struct i915_request *rq)
 {
+	bool result;
+
 	if (i915_request_signaled(rq))
 		return true;
 
-	/* Remember: started but may have since been preempted! */
-	return __i915_request_has_started(rq);
+	result = true;
+	rcu_read_lock(); /* the HWSP may be freed at runtime */
+	if (likely(!i915_request_signaled(rq)))
+		/* Remember: started but may have since been preempted! */
+		result = __i915_request_has_started(rq);
+	rcu_read_unlock();
+
+	return result;
 }
 
 /**
@@ -482,10 +490,16 @@ static inline bool i915_request_started(const struct i915_request *rq)
  */
 static inline bool i915_request_is_running(const struct i915_request *rq)
 {
+	bool result;
+
 	if (!i915_request_is_active(rq))
 		return false;
 
-	return __i915_request_has_started(rq);
+	rcu_read_lock();
+	result = __i915_request_has_started(rq) && i915_request_is_active(rq);
+	rcu_read_unlock();
+
+	return result;
 }
 
 /**
@@ -509,12 +523,25 @@ static inline bool i915_request_is_ready(const struct i915_request *rq)
 	return !list_empty(&rq->sched.link);
 }
 
+static inline bool __i915_request_is_complete(const struct i915_request *rq)
+{
+	return i915_seqno_passed(__hwsp_seqno(rq), rq->fence.seqno);
+}
+
 static inline bool i915_request_completed(const struct i915_request *rq)
 {
+	bool result;
+
 	if (i915_request_signaled(rq))
 		return true;
 
-	return i915_seqno_passed(hwsp_seqno(rq), rq->fence.seqno);
+	result = true;
+	rcu_read_lock(); /* the HWSP may be freed at runtime */
+	if (likely(!i915_request_signaled(rq)))
+		result = __i915_request_is_complete(rq);
+	rcu_read_unlock();
+
+	return result;
 }
 
 static inline void i915_request_mark_complete(struct i915_request *rq)

