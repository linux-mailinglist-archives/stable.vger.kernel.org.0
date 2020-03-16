Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A46186A08
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 12:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730738AbgCPL0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 07:26:22 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:34057 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730734AbgCPL0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 07:26:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 366567F3;
        Mon, 16 Mar 2020 07:26:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 16 Mar 2020 07:26:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=cgYtwv
        KXA+kw2/rT6qmWkN71yRzkUfe1iJW3KjF9hoU=; b=os4KgKXCQdQdq9ffvLPk0a
        taKp1LxTvskd9WqbMNSFtumWYtILq4CCQU15jIVmvMsgo7pv87brk9+NhHk48kdV
        Fvi/YuzzLM30dkXMiMJ0pRuERlKH7t8OA9jw5Yl0QzeiYf7rqmwT3T6UgJKJi2vk
        kFOvOPyUilSRWxVSRbuKw9TGArkR9Y5ccswmqVTWewSVNsShKeUVrXFA+yprAALU
        D/jIgtDdIF5Xejgcz9/zaNEVeie8AICc/jCtulSN3mL6mOfudOAxyiCTDjvJGBuh
        vUJgsCwm3wHxuZPAFaQ8vwnqA9zhRfINW7OfMOFzJSbda1OWRqBZ17S3qEpSOVbg
        ==
X-ME-Sender: <xms:XGJvXmatSCa960nFUalEzKvqVoEEQTXpLjdBcIM-w-lEerrHLGKYMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:XGJvXuQL_bNeRSrcP0A3m2N3rD9bV3HjA2rXDM0FYYZYInlzykNR_A>
    <xmx:XGJvXjVocIJ9Ds8Ntls8tH8vBmL8S9zfEkUW7yDiw6UL_DUvH8v3ww>
    <xmx:XGJvXmqjTPRlPeHtD9v25X7M46AS2EcZcIA_XP2-viVNX3zhEVEOqw>
    <xmx:XGJvXi2wHHzFRKH-FcErRXQcEfeFcLcKJ6jhrkNL_W2rq_zKduzd-w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EE7E13061CB6;
        Mon, 16 Mar 2020 07:26:19 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/execlists: Enable timeslice on partial virtual" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, jani.nikula@intel.com,
        mika.kuoppala@linux.intel.com, stable@vger.kernel.org,
        tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Mar 2020 12:26:18 +0100
Message-ID: <158435797880161@kroah.com>
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

From eafc2aa20fba319b6e791a1b0c45a91511eccb6b Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Fri, 6 Mar 2020 11:30:10 +0000
Subject: [PATCH] drm/i915/execlists: Enable timeslice on partial virtual
 engine dequeue

If we stop filling the ELSP due to an incompatible virtual engine
request, check if we should enable the timeslice on behalf of the queue.

This fixes the case where we are inspecting the last->next element when
we know that the last element is the last request in the execution queue,
and so decided we did not need to enable timeslicing despite the intent
to do so!

Fixes: 8ee36e048c98 ("drm/i915/execlists: Minimalistic timeslicing")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.4+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200306113012.3184606-1-chris@chris-wilson.co.uk
(cherry picked from commit 3df2deed411e0f1b7312baf0139aab8bba4c0410)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index fe8a59aaa629..940e7f7df69a 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1679,11 +1679,9 @@ need_timeslice(struct intel_engine_cs *engine, const struct i915_request *rq)
 	if (!intel_engine_has_timeslices(engine))
 		return false;
 
-	if (list_is_last(&rq->sched.link, &engine->active.requests))
-		return false;
-
-	hint = max(rq_prio(list_next_entry(rq, sched.link)),
-		   engine->execlists.queue_priority_hint);
+	hint = engine->execlists.queue_priority_hint;
+	if (!list_is_last(&rq->sched.link, &engine->active.requests))
+		hint = max(hint, rq_prio(list_next_entry(rq, sched.link)));
 
 	return hint >= effective_prio(rq);
 }
@@ -1725,6 +1723,18 @@ static void set_timeslice(struct intel_engine_cs *engine)
 	set_timer_ms(&engine->execlists.timer, active_timeslice(engine));
 }
 
+static void start_timeslice(struct intel_engine_cs *engine)
+{
+	struct intel_engine_execlists *execlists = &engine->execlists;
+
+	execlists->switch_priority_hint = execlists->queue_priority_hint;
+
+	if (timer_pending(&execlists->timer))
+		return;
+
+	set_timer_ms(&execlists->timer, timeslice(engine));
+}
+
 static void record_preemption(struct intel_engine_execlists *execlists)
 {
 	(void)I915_SELFTEST_ONLY(execlists->preempt_hang.count++);
@@ -1888,11 +1898,7 @@ static void execlists_dequeue(struct intel_engine_cs *engine)
 				 * Even if ELSP[1] is occupied and not worthy
 				 * of timeslices, our queue might be.
 				 */
-				if (!execlists->timer.expires &&
-				    need_timeslice(engine, last))
-					set_timer_ms(&execlists->timer,
-						     timeslice(engine));
-
+				start_timeslice(engine);
 				return;
 			}
 		}
@@ -1927,7 +1933,8 @@ static void execlists_dequeue(struct intel_engine_cs *engine)
 
 			if (last && !can_merge_rq(last, rq)) {
 				spin_unlock(&ve->base.active.lock);
-				return; /* leave this for another */
+				start_timeslice(engine);
+				return; /* leave this for another sibling */
 			}
 
 			ENGINE_TRACE(engine,

