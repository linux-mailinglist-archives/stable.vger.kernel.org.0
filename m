Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E1B17F4E1
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 11:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgCJKSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 06:18:44 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48971 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726164AbgCJKSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 06:18:44 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id F3F7C21B7C;
        Tue, 10 Mar 2020 06:18:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 10 Mar 2020 06:18:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=P0s77t
        tExCWjSoHbuFhDHQ+Y9MLi2zdXL4YYwT2WqFQ=; b=IAfDGaipBx3xg2omXZdTOR
        uU27DPBgXnjJFdfGF0uznjyGZ5ygIQQu4WHK8yjtxJlB2MbSiXQIQYeukOTfJUbK
        ZpGCuqpgjZ4q9THEzGv6wCMvO4ktmdcoCurVbhgjBtRxxuGQJSmUXZBzVscKA0M6
        IFhhcpZGE+pnd2KYDon4ArcWcfj9Hp/VemvMrSfRJjjwZIbr+F7LHgZP88lP6+8L
        rpvKCLxbEni/kuYjU8po7stp31nHCnxvLRT0pO9x8PG/XUqkSHQpfKCq4L7POhMJ
        6ME8LDU/uvgibGHm0GU9w55YXwplN6GNmMk+M2c0fKkNFXPJm+ihMJmuL5CbqXvw
        ==
X-ME-Sender: <xms:gmlnXuYsw2XEPPjhzSbMBp6IgaqnnwSeIml4dzdxGo6Afbw39qjqjA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddvtddgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:gmlnXpK1_jX6OOygtfbkxuMdULR5LiYfdkyyApfOuZRTyO6TQnKTig>
    <xmx:gmlnXnihnra9rmP_6upcWnuGxZSAYd6rH51s4X5G9FdNqadBEdf4kw>
    <xmx:gmlnXq-Rzyp16ddLxafNfM-ZrRNYwz33OE3Z_cJhpcznK_ByY1uM4g>
    <xmx:gmlnXnbv4jCt3O2lFsMgPylzds034f86EzMKcyi3KiE_LdCfMV39Xw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D624D3061393;
        Tue, 10 Mar 2020 06:18:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Drop the timeline->mutex as we wait for" failed to apply to 5.5-stable tree
To:     chris@chris-wilson.co.uk, jani.nikula@intel.com,
        mika.kuoppala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Mar 2020 11:18:39 +0100
Message-ID: <1583835519253137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 169c0aa4bc17d37370f55188d9327b99d60fd9d7 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Tue, 3 Mar 2020 14:00:09 +0000
Subject: [PATCH] drm/i915/gt: Drop the timeline->mutex as we wait for
 retirement

As we have pinned the timeline (using tl->active_count), we can safely
drop the tl->mutex as we wait for what we believe to be the final
request on that timeline. This is useful for ensuring that we do not
block the engine heartbeat by hogging the kernel_context's timeline on a
dead GPU.

References: https://gitlab.freedesktop.org/drm/intel/issues/1364
Fixes: 058179e72e09 ("drm/i915/gt: Replace hangcheck by heartbeats")
Fixes: f33a8a51602c ("drm/i915: Merge wait_for_timelines with retire_request")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200303140009.1494819-1-chris@chris-wilson.co.uk
(cherry picked from commit 82126e596d8519baac416aee83cad938f1d23cf8)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_gt_requests.c b/drivers/gpu/drm/i915/gt/intel_gt_requests.c
index 8a5054f21bf8..24c99d0838af 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_requests.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_requests.c
@@ -147,24 +147,32 @@ long intel_gt_retire_requests_timeout(struct intel_gt *gt, long timeout)
 
 			fence = i915_active_fence_get(&tl->last_request);
 			if (fence) {
+				mutex_unlock(&tl->mutex);
+
 				timeout = dma_fence_wait_timeout(fence,
 								 interruptible,
 								 timeout);
 				dma_fence_put(fence);
+
+				/* Retirement is best effort */
+				if (!mutex_trylock(&tl->mutex)) {
+					active_count++;
+					goto out_active;
+				}
 			}
 		}
 
 		if (!retire_requests(tl) || flush_submission(gt))
 			active_count++;
+		mutex_unlock(&tl->mutex);
 
-		spin_lock(&timelines->lock);
+out_active:	spin_lock(&timelines->lock);
 
-		/* Resume iteration after dropping lock */
+		/* Resume list iteration after reacquiring spinlock */
 		list_safe_reset_next(tl, tn, link);
 		if (atomic_dec_and_test(&tl->active_count))
 			list_del(&tl->link);
 
-		mutex_unlock(&tl->mutex);
 
 		/* Defer the final release to after the spinlock */
 		if (refcount_dec_and_test(&tl->kref.refcount)) {

