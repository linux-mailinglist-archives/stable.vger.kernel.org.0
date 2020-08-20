Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6BF24B110
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgHTIcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:32:24 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:54651 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726766AbgHTIcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 04:32:08 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id BF7CD1941F54;
        Thu, 20 Aug 2020 04:31:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 20 Aug 2020 04:31:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RjLMNf
        bk0PC/eAKnsDnYTF9CkVkWZer5fcWmCz0BUHA=; b=JeaIlM/aASSsPL6IqrqGob
        wpHixYTVVyXKmYlm6J0PyZmNY31tqjuUgGqcDOHf2O0qE+tvqmRAGV74iz87bnea
        P90fZlhh42nSRZbmki4jJ1pMtxu2/MeHTE/EDi5CBY6Ss8ysWftCPja836BAnEU2
        5R6+JHfYwRrJtHiYDLnFRrKapEuebrZJPaWXGj3xPClnkmXfgIwY+M53fKtixzg0
        jU83h+1ZkXyWbgxRpsdHmR0SbqBNtmg7Aduc7kzTB4HoOQ5Myu8GrV8on3b6Kobj
        8QoRa+afiXwCieLGUOpQyAU2C2GZ/knFyCJczbmtfM10LeNKr19WfBNpqQyxvubQ
        ==
X-ME-Sender: <xms:xDQ-XyMqBYExWa3MGI8Y7z4EUFssnphVcru_Q594qLObar1g3dG6QQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddutddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:xDQ-Xw9_SA2uSI-aK8kJv2SDtPd6l-DvzXRb1HFr8FFhvNMg0hh8KQ>
    <xmx:xDQ-X5TrOeV_V8cF4DRUZzViRaUFDhKO8cRu9C3eYM4LFX7WYzda9w>
    <xmx:xDQ-Xyuyo2yqASr2orTnCyN-_CGelgs44_TsjwF_Ybu7FzdeqKhywQ>
    <xmx:xDQ-XylneaYCrlvt4ub6XEOOxEGfekUJR91Bq4Ic1f1mqFXoqEp5tQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id F0B763280063;
        Thu, 20 Aug 2020 04:30:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Skip signaling a signaled request" failed to apply to 5.7-stable tree
To:     chris@chris-wilson.co.uk, stable@vger.kernel.org,
        tvrtko.ursulin@intel.com, venkata.ramana.nayana@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 20 Aug 2020 10:31:21 +0200
Message-ID: <159791228119551@kroah.com>
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

From 1d9221e9d395c8c80d99d002bea3c9b6dd192d6a Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Mon, 13 Jul 2020 15:16:36 +0100
Subject: [PATCH] drm/i915: Skip signaling a signaled request

Preempt-to-busy introduces various fascinating complications in that the
requests may complete as we are unsubmitting them from HW. As they may
then signal after unsubmission, we may find ourselves having to cleanup
the signaling request from within the signaling callback. This causes us
to recurse onto the same i915_request.lock.

However, if the request is already signaled (as it will be before we
enter the signal callbacks), we know we can skip the signaling of that
request during submission, neatly evading the spinlock recursion.

unsubmit(ve.rq0) # timeslice expiration or other preemption
 -> virtual_submit_request(ve.rq0)
dma_fence_signal(ve.rq0) # request completed before preemption ack
 -> submit_notify(ve.rq1)
   -> virtual_submit_request(ve.rq1) # sees that we have completed ve.rq0
      -> __i915_request_submit(ve.rq0)

[  264.210142] BUG: spinlock recursion on CPU#2, sample_multi_tr/2093
[  264.210150]  lock: 0xffff9efd6ac55080, .magic: dead4ead, .owner: sample_multi_tr/2093, .owner_cpu: 2
[  264.210155] CPU: 2 PID: 2093 Comm: sample_multi_tr Tainted: G     U
[  264.210158] Hardware name: Intel Corporation CoffeeLake Client Platform/CoffeeLake S UDIMM RVP, BIOS CNLSFWR1.R00.X212.B01.1909060036 09/06/2019
[  264.210160] Call Trace:
[  264.210167]  dump_stack+0x98/0xda
[  264.210174]  spin_dump.cold+0x24/0x3c
[  264.210178]  do_raw_spin_lock+0x9a/0xd0
[  264.210184]  _raw_spin_lock_nested+0x6a/0x70
[  264.210314]  __i915_request_submit+0x10a/0x3c0 [i915]
[  264.210415]  virtual_submit_request+0x9b/0x380 [i915]
[  264.210516]  submit_notify+0xaf/0x14c [i915]
[  264.210602]  __i915_sw_fence_complete+0x8a/0x230 [i915]
[  264.210692]  i915_sw_fence_complete+0x2d/0x40 [i915]
[  264.210762]  __dma_i915_sw_fence_wake+0x19/0x30 [i915]
[  264.210767]  dma_fence_signal_locked+0xb1/0x1c0
[  264.210772]  dma_fence_signal+0x29/0x50
[  264.210871]  i915_request_wait+0x5cb/0x830 [i915]
[  264.210876]  ? dma_resv_get_fences_rcu+0x294/0x5d0
[  264.210974]  i915_gem_object_wait_fence+0x2f/0x40 [i915]
[  264.211084]  i915_gem_object_wait+0xce/0x400 [i915]
[  264.211178]  i915_gem_wait_ioctl+0xff/0x290 [i915]

Fixes: 22b7a426bbe1 ("drm/i915/execlists: Preempt-to-busy")
References: 6d06779e8672 ("drm/i915: Load balancing across a virtual engine")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: "Nayana, Venkata Ramana" <venkata.ramana.nayana@intel.com>
Cc: <stable@vger.kernel.org> # v5.4+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200713141636.29326-1-chris@chris-wilson.co.uk

diff --git a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
index d907d538176e..91786310c114 100644
--- a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
+++ b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
@@ -314,13 +314,18 @@ bool i915_request_enable_breadcrumb(struct i915_request *rq)
 {
 	lockdep_assert_held(&rq->lock);
 
+	if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &rq->fence.flags))
+		return true;
+
 	if (test_bit(I915_FENCE_FLAG_ACTIVE, &rq->fence.flags)) {
 		struct intel_breadcrumbs *b = &rq->engine->breadcrumbs;
 		struct intel_context *ce = rq->context;
 		struct list_head *pos;
 
 		spin_lock(&b->irq_lock);
-		GEM_BUG_ON(test_bit(I915_FENCE_FLAG_SIGNAL, &rq->fence.flags));
+
+		if (test_bit(I915_FENCE_FLAG_SIGNAL, &rq->fence.flags))
+			goto unlock;
 
 		if (!__intel_breadcrumbs_arm_irq(b))
 			goto unlock;
diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 3bb7320249ae..0b2fe55e6194 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -560,22 +560,25 @@ bool __i915_request_submit(struct i915_request *request)
 	engine->serial++;
 	result = true;
 
-xfer:	/* We may be recursing from the signal callback of another i915 fence */
-	spin_lock_nested(&request->lock, SINGLE_DEPTH_NESTING);
-
+xfer:
 	if (!test_and_set_bit(I915_FENCE_FLAG_ACTIVE, &request->fence.flags)) {
 		list_move_tail(&request->sched.link, &engine->active.requests);
 		clear_bit(I915_FENCE_FLAG_PQUEUE, &request->fence.flags);
-		__notify_execute_cb(request);
 	}
-	GEM_BUG_ON(!llist_empty(&request->execute_cb));
 
-	if (test_bit(DMA_FENCE_FLAG_ENABLE_SIGNAL_BIT, &request->fence.flags) &&
-	    !test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &request->fence.flags) &&
-	    !i915_request_enable_breadcrumb(request))
-		intel_engine_signal_breadcrumbs(engine);
+	/* We may be recursing from the signal callback of another i915 fence */
+	if (!i915_request_signaled(request)) {
+		spin_lock_nested(&request->lock, SINGLE_DEPTH_NESTING);
+
+		__notify_execute_cb(request);
+		if (test_bit(DMA_FENCE_FLAG_ENABLE_SIGNAL_BIT,
+			     &request->fence.flags) &&
+		    !i915_request_enable_breadcrumb(request))
+			intel_engine_signal_breadcrumbs(engine);
 
-	spin_unlock(&request->lock);
+		spin_unlock(&request->lock);
+		GEM_BUG_ON(!llist_empty(&request->execute_cb));
+	}
 
 	return result;
 }

