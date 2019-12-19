Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC4C1260A2
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 12:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfLSLRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 06:17:38 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:53215 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726656AbfLSLRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 06:17:38 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 825FF5CA;
        Thu, 19 Dec 2019 06:17:36 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 19 Dec 2019 06:17:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=GNHsFh
        zxh4dare4UzqUEHZI9gD70TL3g+ni3B5NTgsA=; b=fsVyFZgMBb9LzFZCP3V6oy
        XU4jLAX9oj8C9OlXKHaaKrgBR8NnRafydlQ7AxZ30ZLHnJZn/Uy6IxhXHPUwkLf2
        joKA5kcRGzPcNxuziRPy93IzVEs1GN4NnE2TGJLltW0NGz6Ep5irGdw7fguV2+Ld
        8PYyEMJss8vIZspDsWkMl5cJT1xkg8lqPzDqLSYumwGdlE3eJ9WsHNwDJ4ltnF5K
        bR1qUvYNcRSZ9FwinaNg1QrO0xo3Avu4a07Z2zZ8Lqx7W1YgpCgq75+3H3mvBl52
        hGekRWmsBLJmFRj9moA0d/N4gka8R87m1STlln7ND2ArGe9ZRl/LKJOc9nTPvi7w
        ==
X-ME-Sender: <xms:T1z7XZ8P6Q8xGt2uD62OmTC5tljC1ofuCAHMA7tZnsMbRlv7GOwa_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdduuddgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:T1z7XUP2ZGR3kGAYP2hLnRxeqHslBR4A6FBbPzGIRClG7YL8lT2OAw>
    <xmx:T1z7XaOt_fJw73c5R5OI767CK5iQ3oijmTEbnyjDEL8cMdb8_6sROA>
    <xmx:T1z7XXf1pwreDYLZvRUfXiOAW2qnGEej909ZgvaawVTCRY5Fnr_yMQ>
    <xmx:UFz7XcbWvx-13eCAPP7y_KAUn34pamfEDWbpYfnhZkuMfhqrYoo-4g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1EF258005B;
        Thu, 19 Dec 2019 06:17:35 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Detect if we miss WaIdleLiteRestore" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, joonas.lahtinen@linux.intel.com,
        mika.kuoppala@linux.intel.com, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 19 Dec 2019 12:17:33 +0100
Message-ID: <1576754253218173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From f26a9e959a7b1588c59f7a919b41b67175b211d8 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Mon, 9 Dec 2019 02:32:15 +0000
Subject: [PATCH] drm/i915/gt: Detect if we miss WaIdleLiteRestore

In order to avoid confusing the HW, we must never submit an empty ring
during lite-restore, that is we should always advance the RING_TAIL
before submitting to stay ahead of the RING_HEAD.

Normally this is prevented by keeping a couple of spare NOPs in the
request->wa_tail so that on resubmission we can advance the tail. This
relies on the request only being resubmitted once, which is the normal
condition as it is seen once for ELSP[1] and then later in ELSP[0]. On
preemption, the requests are unwound and the tail reset back to the
normal end point (as we know the request is incomplete and therefore its
RING_HEAD is even earlier).

However, if this w/a should fail we would try and resubmit the request
with the RING_TAIL already set to the location of this request's wa_tail
potentially causing a GPU hang. We can spot when we do try and
incorrectly resubmit without advancing the RING_TAIL and spare any
embarrassment by forcing the context restore.

In the case of preempt-to-busy, we leave the requests running on the HW
while we unwind. As the ring is still live, we cannot rewind our
rq->tail without forcing a reload so leave it set to rq->wa_tail and
only force a reload if we resubmit after a lite-restore. (Normally, the
forced reload will be a part of the preemption event.)

Fixes: 22b7a426bbe1 ("drm/i915/execlists: Preempt-to-busy")
Closes: https://gitlab.freedesktop.org/drm/intel/issues/673
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: stable@kernel.vger.org
Link: https://patchwork.freedesktop.org/patch/msgid/20191209023215.3519970-1-chris@chris-wilson.co.uk
(cherry picked from commit 82c69bf58650e644c61aa2bf5100b63a1070fd2f)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 17bb52aeff19..75dd0e0367b7 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -845,12 +845,6 @@ static const u8 *reg_offsets(const struct intel_engine_cs *engine)
 	}
 }
 
-static void unwind_wa_tail(struct i915_request *rq)
-{
-	rq->tail = intel_ring_wrap(rq->ring, rq->wa_tail - WA_TAIL_BYTES);
-	assert_ring_tail_valid(rq->ring, rq->tail);
-}
-
 static struct i915_request *
 __unwind_incomplete_requests(struct intel_engine_cs *engine)
 {
@@ -863,12 +857,10 @@ __unwind_incomplete_requests(struct intel_engine_cs *engine)
 	list_for_each_entry_safe_reverse(rq, rn,
 					 &engine->active.requests,
 					 sched.link) {
-
 		if (i915_request_completed(rq))
 			continue; /* XXX */
 
 		__i915_request_unsubmit(rq);
-		unwind_wa_tail(rq);
 
 		/*
 		 * Push the request back into the queue for later resubmission.
@@ -1161,13 +1153,29 @@ execlists_schedule_out(struct i915_request *rq)
 	i915_request_put(rq);
 }
 
-static u64 execlists_update_context(const struct i915_request *rq)
+static u64 execlists_update_context(struct i915_request *rq)
 {
 	struct intel_context *ce = rq->hw_context;
-	u64 desc;
+	u64 desc = ce->lrc_desc;
+	u32 tail;
 
-	ce->lrc_reg_state[CTX_RING_TAIL] =
-		intel_ring_set_tail(rq->ring, rq->tail);
+	/*
+	 * WaIdleLiteRestore:bdw,skl
+	 *
+	 * We should never submit the context with the same RING_TAIL twice
+	 * just in case we submit an empty ring, which confuses the HW.
+	 *
+	 * We append a couple of NOOPs (gen8_emit_wa_tail) after the end of
+	 * the normal request to be able to always advance the RING_TAIL on
+	 * subsequent resubmissions (for lite restore). Should that fail us,
+	 * and we try and submit the same tail again, force the context
+	 * reload.
+	 */
+	tail = intel_ring_set_tail(rq->ring, rq->tail);
+	if (unlikely(ce->lrc_reg_state[CTX_RING_TAIL] == tail))
+		desc |= CTX_DESC_FORCE_RESTORE;
+	ce->lrc_reg_state[CTX_RING_TAIL] = tail;
+	rq->tail = rq->wa_tail;
 
 	/*
 	 * Make sure the context image is complete before we submit it to HW.
@@ -1186,13 +1194,11 @@ static u64 execlists_update_context(const struct i915_request *rq)
 	 */
 	mb();
 
-	desc = ce->lrc_desc;
-	ce->lrc_desc &= ~CTX_DESC_FORCE_RESTORE;
-
 	/* Wa_1607138340:tgl */
 	if (IS_TGL_REVID(rq->i915, TGL_REVID_A0, TGL_REVID_A0))
 		desc |= CTX_DESC_FORCE_RESTORE;
 
+	ce->lrc_desc &= ~CTX_DESC_FORCE_RESTORE;
 	return desc;
 }
 
@@ -1703,16 +1709,6 @@ static void execlists_dequeue(struct intel_engine_cs *engine)
 
 				return;
 			}
-
-			/*
-			 * WaIdleLiteRestore:bdw,skl
-			 * Apply the wa NOOPs to prevent
-			 * ring:HEAD == rq:TAIL as we resubmit the
-			 * request. See gen8_emit_fini_breadcrumb() for
-			 * where we prepare the padding after the
-			 * end of the request.
-			 */
-			last->tail = last->wa_tail;
 		}
 	}
 

