Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE09381D9F
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 11:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbhEPJTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 05:19:03 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:52021 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231287AbhEPJTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 05:19:03 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id D10C210A5;
        Sun, 16 May 2021 05:17:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 16 May 2021 05:17:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=amypqn
        rgSg4sd+fTU9E4eKH5rDU4caw55OQEgnrIAlQ=; b=rpWkTj0ZLayhjeb1Z16gtp
        tBU8Uk1BLsEEA9EQc6ZHmebGDvt+QIAg+Q4RwR+jxFdxqSDrZ5Wi/owilwROT2lz
        PWm35VdCzCTCmHuLh3ydqiArUs8XQaZhvDIfv5b/NGWvgp5HrRh5x1xdOF39JoIv
        IA9i2DFacjR08w6U8N41j4Je1S0Nv75F3UXU4fQWriG37Y3Y0e/FeHUFsFtjeb5J
        85VVq9UsYgdt3JbT7rqMvmnaaE3Yqfeppbxqt8vCf7A9+LOE4JyT03wrzKuaS9uY
        7tYQP3gF7/hyhV3j3oKkTcxvuP8VvYNPfZsEMbSCzRxi65Q1OtU6+G6pm40dDWBA
        ==
X-ME-Sender: <xms:POOgYHyiI9ghrr_wsmuCRUqSV45QWkt9HuYWJoqmmejIVYG0fDnLTQ>
    <xme:POOgYPSybaUeR5IObMqLfoWMdrQI8ooV5qHGs5x3P9tDC0IHc09Y5dSAfFHjiJpDl
    Oqd_PV3SWVaMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeifedguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:POOgYBXCzIZHdHhW1wlmKXnFA-PkUv5n6FU_YBUqU84iC_rhbkJ2iw>
    <xmx:POOgYBjtzMG3K7CE4BZVzPbguSNoFGvwfhI3AoZkGhSO0iKAvxMpMw>
    <xmx:POOgYJBHqD-iVibU4Q_5SxKeliIaBkl-ThVbS0tLJuaGvXYiTVELEQ>
    <xmx:POOgYG6De4oyDvTcVwMxUj4YiAzMeJTLWI3-onqWGLxBs5DccCu91rD6eEc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 16 May 2021 05:17:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] blk-iocost: fix weight updates of inner active iocgs" failed to apply to 5.4-stable tree
To:     tj@kernel.org, axboe@kernel.dk, dschatzberg@fb.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 May 2021 11:17:46 +0200
Message-ID: <16211566667029@kroah.com>
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

From e9f4eee9a0023ba22db9560d4cc6ee63f933dae8 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 11 May 2021 21:38:36 -0400
Subject: [PATCH] blk-iocost: fix weight updates of inner active iocgs

When the weight of an active iocg is updated, weight_updated() is called
which in turn calls __propagate_weights() to update the active and inuse
weights so that the effective hierarchical weights are update accordingly.

The current implementation is incorrect for inner active nodes. For an
active leaf iocg, inuse can be any value between 1 and active and the
difference represents how much the iocg is donating. When weight is updated,
as long as inuse is clamped between 1 and the new weight, we're alright and
this is what __propagate_weights() currently implements.

However, that's not how an active inner node's inuse is set. An inner node's
inuse is solely determined by the ratio between the sums of inuse's and
active's of its children - ie. they're results of propagating the leaves'
active and inuse weights upwards. __propagate_weights() incorrectly applies
the same clamping as for a leaf when an active inner node's weight is
updated. Consider a hierarchy which looks like the following with saturating
workloads in AA and BB.

     R
   /   \
  A     B
  |     |
 AA     BB

1. For both A and B, active=100, inuse=100, hwa=0.5, hwi=0.5.

2. echo 200 > A/io.weight

3. __propagate_weights() update A's active to 200 and leave inuse at 100 as
   it's already between 1 and the new active, making A:active=200,
   A:inuse=100. As R's active_sum is updated along with A's active,
   A:hwa=2/3, B:hwa=1/3. However, because the inuses didn't change, the
   hwi's remain unchanged at 0.5.

4. The weight of A is now twice that of B but AA and BB still have the same
   hwi of 0.5 and thus are doing the same amount of IOs.

Fix it by making __propgate_weights() always calculate the inuse of an
active inner iocg based on the ratio of child_inuse_sum to child_active_sum.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dan Schatzberg <dschatzberg@fb.com>
Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Cc: stable@vger.kernel.org # v5.4+
Link: https://lore.kernel.org/r/YJsxnLZV1MnBcqjj@slm.duckdns.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index e0c4baa01857..c2d6bc88d3f1 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1069,7 +1069,17 @@ static void __propagate_weights(struct ioc_gq *iocg, u32 active, u32 inuse,
 
 	lockdep_assert_held(&ioc->lock);
 
-	inuse = clamp_t(u32, inuse, 1, active);
+	/*
+	 * For an active leaf node, its inuse shouldn't be zero or exceed
+	 * @active. An active internal node's inuse is solely determined by the
+	 * inuse to active ratio of its children regardless of @inuse.
+	 */
+	if (list_empty(&iocg->active_list) && iocg->child_active_sum) {
+		inuse = DIV64_U64_ROUND_UP(active * iocg->child_inuse_sum,
+					   iocg->child_active_sum);
+	} else {
+		inuse = clamp_t(u32, inuse, 1, active);
+	}
 
 	iocg->last_inuse = iocg->inuse;
 	if (save)
@@ -1086,7 +1096,7 @@ static void __propagate_weights(struct ioc_gq *iocg, u32 active, u32 inuse,
 		/* update the level sums */
 		parent->child_active_sum += (s32)(active - child->active);
 		parent->child_inuse_sum += (s32)(inuse - child->inuse);
-		/* apply the udpates */
+		/* apply the updates */
 		child->active = active;
 		child->inuse = inuse;
 

