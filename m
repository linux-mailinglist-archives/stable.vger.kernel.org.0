Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACDD6C0E82
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 11:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjCTKRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 06:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjCTKRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 06:17:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BE6C66B
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 03:17:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91E4461336
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D7DC433EF;
        Mon, 20 Mar 2023 10:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679307458;
        bh=6+mRlelsgKvaESqIq8/n4G1Qc3Tvb+O4unfnyMt0C54=;
        h=Subject:To:Cc:From:Date:From;
        b=zM2OBKLv2itn5luXiPF6PIg4wNve4ue5PMKK0OYSBL3KCjbwPkBnMiR5wg+umHmFB
         cLpgrlFI3zYzMMwHfjI1+TxEQ197RoSd3PYjq1WgpSPL2pxFmv5cLzYZPseJMNouIV
         Zcg929UC4u9jAQxBhMMNoinFDZ25vjF40sRYVz3Y=
Subject: FAILED: patch "[PATCH] drm/i915/active: Fix misuse of non-idle barriers as fence" failed to apply to 5.10-stable tree
To:     janusz.krzysztofik@linux.intel.com, andi.shyti@linux.intel.com,
        chris@chris-wilson.co.uk, jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 11:17:27 +0100
Message-ID: <167930744720516@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x e0e6b416b25ee14716f3549e0cbec1011b193809
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167930744720516@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

e0e6b416b25e ("drm/i915/active: Fix misuse of non-idle barriers as fence trackers")
ad5c99e02047 ("drm/i915: Remove unused bits of i915_vma/active api")
f6c466b84cfa ("drm/i915: Add support for moving fence waiting")
544460c33821 ("drm/i915: Multi-BB execbuf")
5851387a422c ("drm/i915/guc: Implement no mid batch preemption for multi-lrc")
e5e32171a2cf ("drm/i915/guc: Connect UAPI to GuC multi-lrc interface")
d38a9294491d ("drm/i915/guc: Update debugfs for GuC multi-lrc")
bc955204919e ("drm/i915/guc: Insert submit fences between requests in parent-child relationship")
6b540bf6f143 ("drm/i915/guc: Implement multi-lrc submission")
99b47aaddfa9 ("drm/i915/guc: Implement parallel context pin / unpin functions")
c2aa552ff09d ("drm/i915/guc: Add multi-lrc context registration")
3897df4c0187 ("drm/i915/guc: Introduce context parent-child relationship")
4f3059dc2dbb ("drm/i915: Add logical engine mapping")
1a52faed3131 ("drm/i915/guc: Take GT PM ref when deregistering context")
0ea92ace8b95 ("drm/i915/guc: Move GuC guc_id allocation under submission state sub-struct")
0d8ee5ba8db4 ("drm/i915: Don't back up pinned LMEM context images and rings during suspend")
c56ce9565374 ("drm/i915 Implement LMEM backup and restore for suspend / resume")
0d9388635a22 ("drm/i915/ttm: Implement a function to copy the contents of two TTM-based objects")
68c03c0e985e ("drm/i915/debugfs: Do not report currently active engine when describing objects")
48b096126954 ("drm/i915: Move __i915_gem_free_object to ttm_bo_destroy")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e0e6b416b25ee14716f3549e0cbec1011b193809 Mon Sep 17 00:00:00 2001
From: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Date: Thu, 2 Mar 2023 13:08:20 +0100
Subject: [PATCH] drm/i915/active: Fix misuse of non-idle barriers as fence
 trackers

Users reported oopses on list corruptions when using i915 perf with a
number of concurrently running graphics applications.  Root cause analysis
pointed at an issue in barrier processing code -- a race among perf open /
close replacing active barriers with perf requests on kernel context and
concurrent barrier preallocate / acquire operations performed during user
context first pin / last unpin.

When adding a request to a composite tracker, we try to reuse an existing
fence tracker, already allocated and registered with that composite.  The
tracker we obtain may already track another fence, may be an idle barrier,
or an active barrier.

If the tracker we get occurs a non-idle barrier then we try to delete that
barrier from a list of barrier tasks it belongs to.  However, while doing
that we don't respect return value from a function that performs the
barrier deletion.  Should the deletion ever fail, we would end up reusing
the tracker still registered as a barrier task.  Since the same structure
field is reused with both fence callback lists and barrier tasks list,
list corruptions would likely occur.

Barriers are now deleted from a barrier tasks list by temporarily removing
the list content, traversing that content with skip over the node to be
deleted, then populating the list back with the modified content.  Should
that intentionally racy concurrent deletion attempts be not serialized,
one or more of those may fail because of the list being temporary empty.

Related code that ignores the results of barrier deletion was initially
introduced in v5.4 by commit d8af05ff38ae ("drm/i915: Allow sharing the
idle-barrier from other kernel requests").  However, all users of the
barrier deletion routine were apparently serialized at that time, then the
issue didn't exhibit itself.  Results of git bisect with help of a newly
developed igt@gem_barrier_race@remote-request IGT test indicate that list
corruptions might start to appear after commit 311770173fac ("drm/i915/gt:
Schedule request retirement when timeline idles"), introduced in v5.5.

Respect results of barrier deletion attempts -- mark the barrier as idle
only if successfully deleted from the list.  Then, before proceeding with
setting our fence as the one currently tracked, make sure that the tracker
we've got is not a non-idle barrier.  If that check fails then don't use
that tracker but go back and try to acquire a new, usable one.

v3: use unlikely() to document what outcome we expect (Andi),
  - fix bad grammar in commit description.
v2: no code changes,
  - blame commit 311770173fac ("drm/i915/gt: Schedule request retirement
    when timeline idles"), v5.5, not commit d8af05ff38ae ("drm/i915: Allow
    sharing the idle-barrier from other kernel requests"), v5.4,
  - reword commit description.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6333
Fixes: 311770173fac ("drm/i915/gt: Schedule request retirement when timeline idles")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org # v5.5
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230302120820.48740-1-janusz.krzysztofik@linux.intel.com
(cherry picked from commit 506006055769b10d1b2b4e22f636f3b45e0e9fc7)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index 7412abf166a8..a9fea115f2d2 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -422,12 +422,12 @@ replace_barrier(struct i915_active *ref, struct i915_active_fence *active)
 	 * we can use it to substitute for the pending idle-barrer
 	 * request that we want to emit on the kernel_context.
 	 */
-	__active_del_barrier(ref, node_from_active(active));
-	return true;
+	return __active_del_barrier(ref, node_from_active(active));
 }
 
 int i915_active_add_request(struct i915_active *ref, struct i915_request *rq)
 {
+	u64 idx = i915_request_timeline(rq)->fence_context;
 	struct dma_fence *fence = &rq->fence;
 	struct i915_active_fence *active;
 	int err;
@@ -437,16 +437,19 @@ int i915_active_add_request(struct i915_active *ref, struct i915_request *rq)
 	if (err)
 		return err;
 
-	active = active_instance(ref, i915_request_timeline(rq)->fence_context);
-	if (!active) {
-		err = -ENOMEM;
-		goto out;
-	}
+	do {
+		active = active_instance(ref, idx);
+		if (!active) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		if (replace_barrier(ref, active)) {
+			RCU_INIT_POINTER(active->fence, NULL);
+			atomic_dec(&ref->count);
+		}
+	} while (unlikely(is_barrier(active)));
 
-	if (replace_barrier(ref, active)) {
-		RCU_INIT_POINTER(active->fence, NULL);
-		atomic_dec(&ref->count);
-	}
 	if (!__i915_active_fence_set(active, fence))
 		__i915_active_acquire(ref);
 

