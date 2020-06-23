Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D349204BB4
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 09:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731041AbgFWHuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 03:50:08 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:56423 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731158AbgFWHuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 03:50:07 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 82D42E24;
        Tue, 23 Jun 2020 03:50:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 23 Jun 2020 03:50:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Rig3vk
        no66UIstLdOFIf4UVahNisb/bHd3kH2/i5ki4=; b=OFBeuuRZ6uZJ1ZH7pSx8M+
        dt7lTb+Pj0oTRt6C9QiLHZBs5EVokkzoIsR46CKNbqEKCWK95wQNEldQrG/rw84r
        YauHmufVY0rny7W3VRgWXFeRfx7oiNXWVBni5ZvyewxFfCbWQHDQhg8MxfNoRJij
        buw2m/de9Vh5EHDg6Er40aBGsq/hTZVRYswsJWTe0gNQhtyEXU53b3OD/JV6aBrj
        jc6Idpnbf8NZJIX/1S5lFBYfOsVfp7sZgxCO3Lz3b5cQjS81wntfR2oj+qRxbvn+
        1lsQiLuQWE0IV+IvHZ6Ik6YFhiexgaBrEBZsxNEBzpa/X//OBGNml+xr+rI3rutQ
        ==
X-ME-Sender: <xms:LbTxXmHhrHBYmKZVygsRg9Q93duzryxUwby-56g3GAxeDj3Xo-6p4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekfedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpedvffegjeejiedtieffjeeijeffgfehvdeiudejhe
    efgeevhffhvedvfeeuheekleenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhr
    ghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:LbTxXnU4e3egEBwm7dKVkW7yb6cvtI8jCLTPZUDo1X2BOappiAVecQ>
    <xmx:LbTxXgKAbA2Ra_7zNMXI03olGBy6vAniHAvDSU25gCYWHMIMBw0IeQ>
    <xmx:LbTxXgG57zR02HuIZELO7tejPq2Jv8_giPSMkzGwCS0E04OU8YPWlQ>
    <xmx:LrTxXneDSi7_uKFf_PBQzke9Byg8CF7kU6NWe6fFj50GyYHSOGmGifGFPEI>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6827B3067499;
        Tue, 23 Jun 2020 03:50:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Incrementally check for rewinding" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, joonas.lahtinen@linux.intel.com,
        mika.kuoppala@linux.intel.com, stable@vger.kernel.org,
        yu.bruce.chang@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 09:50:00 +0200
Message-ID: <1592898600199250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 8ab3a3812aa90e488813e719308ffd807b865624 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Tue, 9 Jun 2020 16:17:23 +0100
Subject: [PATCH] drm/i915/gt: Incrementally check for rewinding

In commit 5ba32c7be81e ("drm/i915/execlists: Always force a context
reload when rewinding RING_TAIL"), we placed the check for rewinding a
context on actually submitting the next request in that context. This
was so that we only had to check once, and could do so with precision
avoiding as many forced restores as possible. For example, to ensure
that we can resubmit the same request a couple of times, we include a
small wa_tail such that on the next submission, the ring->tail will
appear to move forwards when resubmitting the same request. This is very
common as it will happen for every lite-restore to fill the second port
after a context switch.

However, intel_ring_direction() is limited in precision to movements of
upto half the ring size. The consequence being that if we tried to
unwind many requests, we could exceed half the ring and flip the sense
of the direction, so missing a force restore. As no request can be
greater than half the ring (i.e. 2048 bytes in the smallest case), we
can check for rollback incrementally. As we check against the tail that
would be submitted, we do not lose any sensitivity and allow lite
restores for the simple case. We still need to double check upon
submitting the context, to allow for multiple preemptions and
resubmissions.

Fixes: 5ba32c7be81e ("drm/i915/execlists: Always force a context reload when rewinding RING_TAIL")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.4+
Reviewed-by: Bruce Chang <yu.bruce.chang@intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200609151723.12971-1-chris@chris-wilson.co.uk
(cherry picked from commit e36ba817fa966f81fb1c8d16f3721b5a644b2fa9)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index da5b61085257..8691eb61e185 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -646,7 +646,7 @@ static int engine_setup_common(struct intel_engine_cs *engine)
 struct measure_breadcrumb {
 	struct i915_request rq;
 	struct intel_ring ring;
-	u32 cs[1024];
+	u32 cs[2048];
 };
 
 static int measure_breadcrumb_dw(struct intel_context *ce)
@@ -668,6 +668,8 @@ static int measure_breadcrumb_dw(struct intel_context *ce)
 
 	frame->ring.vaddr = frame->cs;
 	frame->ring.size = sizeof(frame->cs);
+	frame->ring.wrap =
+		BITS_PER_TYPE(frame->ring.size) - ilog2(frame->ring.size);
 	frame->ring.effective_size = frame->ring.size;
 	intel_ring_update_space(&frame->ring);
 	frame->rq.ring = &frame->ring;
diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 1858331e423e..7c3d8ef4a47c 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1134,6 +1134,13 @@ __unwind_incomplete_requests(struct intel_engine_cs *engine)
 			list_move(&rq->sched.link, pl);
 			set_bit(I915_FENCE_FLAG_PQUEUE, &rq->fence.flags);
 
+			/* Check in case we rollback so far we wrap [size/2] */
+			if (intel_ring_direction(rq->ring,
+						 intel_ring_wrap(rq->ring,
+								 rq->tail),
+						 rq->ring->tail) > 0)
+				rq->context->lrc.desc |= CTX_DESC_FORCE_RESTORE;
+
 			active = rq;
 		} else {
 			struct intel_engine_cs *owner = rq->context->engine;
@@ -1498,8 +1505,9 @@ static u64 execlists_update_context(struct i915_request *rq)
 	 * HW has a tendency to ignore us rewinding the TAIL to the end of
 	 * an earlier request.
 	 */
+	GEM_BUG_ON(ce->lrc_reg_state[CTX_RING_TAIL] != rq->ring->tail);
+	prev = rq->ring->tail;
 	tail = intel_ring_set_tail(rq->ring, rq->tail);
-	prev = ce->lrc_reg_state[CTX_RING_TAIL];
 	if (unlikely(intel_ring_direction(rq->ring, tail, prev) <= 0))
 		desc |= CTX_DESC_FORCE_RESTORE;
 	ce->lrc_reg_state[CTX_RING_TAIL] = tail;
@@ -4758,6 +4766,14 @@ static int gen12_emit_flush(struct i915_request *request, u32 mode)
 	return 0;
 }
 
+static void assert_request_valid(struct i915_request *rq)
+{
+	struct intel_ring *ring __maybe_unused = rq->ring;
+
+	/* Can we unwind this request without appearing to go forwards? */
+	GEM_BUG_ON(intel_ring_direction(ring, rq->wa_tail, rq->head) <= 0);
+}
+
 /*
  * Reserve space for 2 NOOPs at the end of each request to be
  * used as a workaround for not being allowed to do lite
@@ -4770,6 +4786,9 @@ static u32 *gen8_emit_wa_tail(struct i915_request *request, u32 *cs)
 	*cs++ = MI_NOOP;
 	request->wa_tail = intel_ring_offset(request, cs);
 
+	/* Check that entire request is less than half the ring */
+	assert_request_valid(request);
+
 	return cs;
 }
 
diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/gt/intel_ring.c
index 8cda1b7e17ba..bdb324167ef3 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring.c
@@ -315,3 +315,7 @@ int intel_ring_cacheline_align(struct i915_request *rq)
 	GEM_BUG_ON(rq->ring->emit & (CACHELINE_BYTES - 1));
 	return 0;
 }
+
+#if IS_ENABLED(CONFIG_DRM_I915_SELFTEST)
+#include "selftest_ring.c"
+#endif
diff --git a/drivers/gpu/drm/i915/gt/selftest_mocs.c b/drivers/gpu/drm/i915/gt/selftest_mocs.c
index 8831ffee2061..63f87d8608c3 100644
--- a/drivers/gpu/drm/i915/gt/selftest_mocs.c
+++ b/drivers/gpu/drm/i915/gt/selftest_mocs.c
@@ -18,6 +18,20 @@ struct live_mocs {
 	void *vaddr;
 };
 
+static struct intel_context *mocs_context_create(struct intel_engine_cs *engine)
+{
+	struct intel_context *ce;
+
+	ce = intel_context_create(engine);
+	if (IS_ERR(ce))
+		return ce;
+
+	/* We build large requests to read the registers from the ring */
+	ce->ring = __intel_context_ring_size(SZ_16K);
+
+	return ce;
+}
+
 static int request_add_sync(struct i915_request *rq, int err)
 {
 	i915_request_get(rq);
@@ -301,7 +315,7 @@ static int live_mocs_clean(void *arg)
 	for_each_engine(engine, gt, id) {
 		struct intel_context *ce;
 
-		ce = intel_context_create(engine);
+		ce = mocs_context_create(engine);
 		if (IS_ERR(ce)) {
 			err = PTR_ERR(ce);
 			break;
@@ -395,7 +409,7 @@ static int live_mocs_reset(void *arg)
 	for_each_engine(engine, gt, id) {
 		struct intel_context *ce;
 
-		ce = intel_context_create(engine);
+		ce = mocs_context_create(engine);
 		if (IS_ERR(ce)) {
 			err = PTR_ERR(ce);
 			break;
diff --git a/drivers/gpu/drm/i915/gt/selftest_ring.c b/drivers/gpu/drm/i915/gt/selftest_ring.c
new file mode 100644
index 000000000000..2a8c534dc125
--- /dev/null
+++ b/drivers/gpu/drm/i915/gt/selftest_ring.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright © 2020 Intel Corporation
+ */
+
+static struct intel_ring *mock_ring(unsigned long sz)
+{
+	struct intel_ring *ring;
+
+	ring = kzalloc(sizeof(*ring) + sz, GFP_KERNEL);
+	if (!ring)
+		return NULL;
+
+	kref_init(&ring->ref);
+	ring->size = sz;
+	ring->wrap = BITS_PER_TYPE(ring->size) - ilog2(sz);
+	ring->effective_size = sz;
+	ring->vaddr = (void *)(ring + 1);
+	atomic_set(&ring->pin_count, 1);
+
+	intel_ring_update_space(ring);
+
+	return ring;
+}
+
+static void mock_ring_free(struct intel_ring *ring)
+{
+	kfree(ring);
+}
+
+static int check_ring_direction(struct intel_ring *ring,
+				u32 next, u32 prev,
+				int expected)
+{
+	int result;
+
+	result = intel_ring_direction(ring, next, prev);
+	if (result < 0)
+		result = -1;
+	else if (result > 0)
+		result = 1;
+
+	if (result != expected) {
+		pr_err("intel_ring_direction(%u, %u):%d != %d\n",
+		       next, prev, result, expected);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int check_ring_step(struct intel_ring *ring, u32 x, u32 step)
+{
+	u32 prev = x, next = intel_ring_wrap(ring, x + step);
+	int err = 0;
+
+	err |= check_ring_direction(ring, next, next,  0);
+	err |= check_ring_direction(ring, prev, prev,  0);
+	err |= check_ring_direction(ring, next, prev,  1);
+	err |= check_ring_direction(ring, prev, next, -1);
+
+	return err;
+}
+
+static int check_ring_offset(struct intel_ring *ring, u32 x, u32 step)
+{
+	int err = 0;
+
+	err |= check_ring_step(ring, x, step);
+	err |= check_ring_step(ring, intel_ring_wrap(ring, x + 1), step);
+	err |= check_ring_step(ring, intel_ring_wrap(ring, x - 1), step);
+
+	return err;
+}
+
+static int igt_ring_direction(void *dummy)
+{
+	struct intel_ring *ring;
+	unsigned int half = 2048;
+	int step, err = 0;
+
+	ring = mock_ring(2 * half);
+	if (!ring)
+		return -ENOMEM;
+
+	GEM_BUG_ON(ring->size != 2 * half);
+
+	/* Precision of wrap detection is limited to ring->size / 2 */
+	for (step = 1; step < half; step <<= 1) {
+		err |= check_ring_offset(ring, 0, step);
+		err |= check_ring_offset(ring, half, step);
+	}
+	err |= check_ring_step(ring, 0, half - 64);
+
+	/* And check unwrapped handling for good measure */
+	err |= check_ring_offset(ring, 0, 2 * half + 64);
+	err |= check_ring_offset(ring, 3 * half, 1);
+
+	mock_ring_free(ring);
+	return err;
+}
+
+int intel_ring_mock_selftests(void)
+{
+	static const struct i915_subtest tests[] = {
+		SUBTEST(igt_ring_direction),
+	};
+
+	return i915_subtests(tests, NULL);
+}
diff --git a/drivers/gpu/drm/i915/selftests/i915_mock_selftests.h b/drivers/gpu/drm/i915/selftests/i915_mock_selftests.h
index 6a2be7d0dd95..6090ce35226b 100644
--- a/drivers/gpu/drm/i915/selftests/i915_mock_selftests.h
+++ b/drivers/gpu/drm/i915/selftests/i915_mock_selftests.h
@@ -21,6 +21,7 @@ selftest(fence, i915_sw_fence_mock_selftests)
 selftest(scatterlist, scatterlist_mock_selftests)
 selftest(syncmap, i915_syncmap_mock_selftests)
 selftest(uncore, intel_uncore_mock_selftests)
+selftest(ring, intel_ring_mock_selftests)
 selftest(engine, intel_engine_cs_mock_selftests)
 selftest(timelines, intel_timeline_mock_selftests)
 selftest(requests, i915_request_mock_selftests)

