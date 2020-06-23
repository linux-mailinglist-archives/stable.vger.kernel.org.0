Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B984C204B86
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 09:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731521AbgFWHsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 03:48:21 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:50757 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731245AbgFWHsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 03:48:20 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 5E2A1E26;
        Tue, 23 Jun 2020 03:48:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 23 Jun 2020 03:48:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=fJD4N6
        1S9yR3kKYfXgOnmBDsUr2oZXD7FDllbI3CixU=; b=i/GvRLIyTzb1oy0crd6uoK
        9aD9DkbLjOgRZkVrut5IwQx2TuzEky4AjY4tF33sCjBjqXJ93WP/cO4qAQxS4HTG
        x/+EhN4AMqkruHs9NtkpEKYBy6genQds6oIoIDYuzRGUNhHTTx0+BFgr8akD5QF0
        uswcBa+i1lD6LDbOA4cDDdI023ZHSwSl5uIYB5v/daKyUJVcPCu5UywppSDyVfdl
        jak6QnnBq4bujYegjGl4rdIOA0Qsytg4Hc+nRRf5Vy15jtc8+9MsrfCr9wXIgsJi
        fJYpLYUhK0J3F/lESL5RdQF+jFxwQAWFWV/kyT/BPhvhomnztxnQrwtGrJFx+HSA
        ==
X-ME-Sender: <xms:w7PxXq6apANRoktuibgPaW8vVYd6QdqFF4dSdRi2J-ZTmFvS6TAkoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekfedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtud
    eujefhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhr
    ghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepgeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:w7PxXj5MbDQhdvMeIDkIbUQSZFE52F2-SMJyh5scDd6mF95uIk-ckw>
    <xmx:w7PxXpeCJKMJDum3_1WGgDlU-NvwwkNigJyU7FJDI88ly6pJeVO7xg>
    <xmx:w7PxXnKw9t2prYqQwYiq42aCmDgIWCIG5Zl2ak27gshxSQSd4Girjw>
    <xmx:xLPxXoy78IUHmkGRmmYFraC0i1iwQfffh2D1VDLoUIO0F2zKg1pSqeo0cqM>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 85DBC328005A;
        Tue, 23 Jun 2020 03:48:19 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Do not schedule normal requests immediately" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, joonas.lahtinen@linux.intel.com,
        stable@vger.kernel.org, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 09:48:04 +0200
Message-ID: <159289848420245@kroah.com>
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

From 631a6582b75ffac82bee76a65217caa856fafb5e Mon Sep 17 00:00:00 2001
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
(cherry picked from commit 511b6d9aed417739b6aa49d0b6b4354ad21020f1)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 33bbad623e02..0b07ccc7e9bc 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -1237,6 +1237,25 @@ i915_request_await_execution(struct i915_request *rq,
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
@@ -1258,10 +1277,8 @@ i915_request_await_request(struct i915_request *to, struct i915_request *from)
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

