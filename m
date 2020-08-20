Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6406E24B111
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgHTIcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:32:25 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:35907 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726788AbgHTIcM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 04:32:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id A473A1941FB8;
        Thu, 20 Aug 2020 04:31:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 20 Aug 2020 04:31:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5j6E5s
        Geh4ijco72RMlfh2aPQkba/YwNBsetQ1CeGEk=; b=W5uxC7XF9VRGiurY0K6Xyo
        /o5wx+5RlmzNUbagjZ1AqEUAzfrPokMv8hU5urgwqwSNvHdzIlOyeg/kpGGhiS/f
        ZqoFrC0RMlcP6xMRAMkbQC1EmWAaQyg+G1uGL3ljm/IbOoLhEd/nIGYzD2gGedSV
        gsJgHYdCxigJJV5m42VKCNo78peKE+4K6LiZVVWYC4/TUQwL2IR/PrvFFjIZtQ+0
        bRHBr6g/qtgK+K9Mwi2BsjXU8BTmu1l8WspM4XTBkC5aBghGU3VsFMejp9PiXTCY
        9INBGX5rkU04U9ynDYpC0gGp1w+VDjHGdXd1akPUyv/UfScw5K8tXVaP340OUjPg
        ==
X-ME-Sender: <xms:1TQ-X_oteEOwPltcUy1OWNPtkjn27YztMEtvnPipOIUpRgVgOU5U6A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddutddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpeefnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:1TQ-X5pL6CnyXLDaAsK5OGnEIDoHvaPk-wMD51pZg7vRDz3JTo_Nkg>
    <xmx:1TQ-X8PkLMGfqt0WKKxQr4ZjcvVsNYNLexaeS0HSIwSxW6CgA0-Rmg>
    <xmx:1TQ-Xy4FTNjija34ttM5ARlsDlCtLjTXLeQBUzT0NquJlGQvQ_dkNw>
    <xmx:1TQ-X7WX7LC5vtp0nDQA7ctYgzzfxx0lVu5Hi09W0Oc8Zj5iuQP-TQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 48573306005F;
        Thu, 20 Aug 2020 04:31:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Do not schedule normal requests immediately" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, stable@vger.kernel.org,
        tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 20 Aug 2020 10:31:38 +0200
Message-ID: <159791229817152@kroah.com>
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

From 511b6d9aed417739b6aa49d0b6b4354ad21020f1 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Tue, 26 May 2020 10:07:53 +0100
Subject: [PATCH] drm/i915/gt: Do not schedule normal requests immediately
 along virtual

When we push a virtual request onto the HW, we update the rq->engine to
point to the physical engine. A request that is then submitted by the
user that waits upon the virtual engine, but along the physical engine
in use, will then see that it is due to be submitted to the same engine
and take a shortcut (and be queued without waiting for the completion
fence). However, the virtual request may be preempted (either by higher
priority users, or by timeslicing) and removed from the physical engine
to be migrated over to one of its siblings. The dependent normal request
however is oblivious to the removal of the virtual request and remains
queued to execute on HW, believing that once it reaches the head of its
queue all of its predecessors will have completed executing!

v2: Beware restriction of signal->execution_mask prior to submission.

Fixes: 6d06779e8672 ("drm/i915: Load balancing across a virtual engine")
Testcase: igt/gem_exec_balancer/sliced
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.3+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200526090753.11329-2-chris@chris-wilson.co.uk

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index e64d82f7c830..0d810a62ff46 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -1242,6 +1242,25 @@ i915_request_await_execution(struct i915_request *rq,
 	return 0;
 }
 
+static int
+await_request_submit(struct i915_request *to, struct i915_request *from)
+{
+	/*
+	 * If we are waiting on a virtual engine, then it may be
+	 * constrained to execute on a single engine *prior* to submission.
+	 * When it is submitted, it will be first submitted to the virtual
+	 * engine and then passed to the physical engine. We cannot allow
+	 * the waiter to be submitted immediately to the physical engine
+	 * as it may then bypass the virtual request.
+	 */
+	if (to->engine == READ_ONCE(from->engine))
+		return i915_sw_fence_await_sw_fence_gfp(&to->submit,
+							&from->submit,
+							I915_FENCE_GFP);
+	else
+		return __i915_request_await_execution(to, from, NULL);
+}
+
 static int
 i915_request_await_request(struct i915_request *to, struct i915_request *from)
 {
@@ -1263,10 +1282,8 @@ i915_request_await_request(struct i915_request *to, struct i915_request *from)
 			return ret;
 	}
 
-	if (to->engine == READ_ONCE(from->engine))
-		ret = i915_sw_fence_await_sw_fence_gfp(&to->submit,
-						       &from->submit,
-						       I915_FENCE_GFP);
+	if (is_power_of_2(to->execution_mask | READ_ONCE(from->execution_mask)))
+		ret = await_request_submit(to, from);
 	else
 		ret = emit_semaphore_wait(to, from, I915_FENCE_GFP);
 	if (ret < 0)

