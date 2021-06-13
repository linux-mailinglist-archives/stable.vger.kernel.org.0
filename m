Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F4F3A5893
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhFMNA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 09:00:59 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:36313 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231286AbhFMNA7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 09:00:59 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9EE191940A1B;
        Sun, 13 Jun 2021 08:58:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 13 Jun 2021 08:58:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tkCNzg
        Os0cuGXiumyAOzjizJ40NXsKTVtq7hyV1Ny74=; b=XeeUQ40K3graONBOzrkaKg
        GwWEA9In8F8YiQwPKDkw+VgfBLdRhcJUGLO6j0FMxpE0YCinUTEOl1lAeB6Au3qa
        5j9iQLt4X1vkZ5IJLaBjMbZuBJt/9LkONfH6QmkN3Riw+WUYQzMGkt/w1gM+gJun
        oI3IVjf7Y/1iwIIeM9s5cwuGIX3tkLURRufSs/mQmZPv7ldc/uHwPHTOKDBubbwq
        x9ihq/aM9wrGvGMGd7ouaikjmVs44ujw+JpP4fkylOBoXbC4a00ICmRE4oMBm+SR
        U9bUuMeXlUjNv56WIEcVYllVoc2QUoUNK5ZVLyPATBcsOy1gxliyRvN6oh0MxiEA
        ==
X-ME-Sender: <xms:EQHGYMzjt6MKv-r9rPXe1wxOMo0DozisCZYaA8FIK8Be6rtyxcpMow>
    <xme:EQHGYARi-xvpG80hNSkcdCmW4MsOjUub4zsehOtay5A6hAdVj1VmR-t4NJGhmBwLO
    FrwskzSs04FkA>
X-ME-Received: <xmr:EQHGYOWrKI82Rrz0v7eEllod4AiczgTi-xC-u72RQ_Tov27sucbEFrM3WoblXPPBppDNlx8IcUzu5WxhTPRAIY98Snfgw1MY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:EQHGYKhawNDJf8QgWLki7DmAVx7BoDiGzJIo9gHuFQ0PVd2lveDaPw>
    <xmx:EQHGYOBNfTKIgzuzGrGPOUXvXZZ5pOLxrYxTjr7ccnQLAjnQDNuaiA>
    <xmx:EQHGYLIEuJ4lURQtx5-fQsZl0FUfg3bNKNmfmsSvzI9C-YpH7jxaKA>
    <xmx:EQHGYBM3sHOKI1lQTh9TjT8SAs1NK892q2IPh_-GJpEFHk72Rf6oHA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 08:58:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] sched/fair: Keep load_avg and load_sum synced" failed to apply to 5.4-stable tree
To:     vincent.guittot@linaro.org, odin@uged.al, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 14:58:47 +0200
Message-ID: <16235891275240@kroah.com>
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

From 7c7ad626d9a0ff0a36c1e2a3cfbbc6a13828d5eb Mon Sep 17 00:00:00 2001
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 27 May 2021 14:29:15 +0200
Subject: [PATCH] sched/fair: Keep load_avg and load_sum synced

when removing a cfs_rq from the list we only check _sum value so we must
ensure that _avg and _sum stay synced so load_sum can't be null whereas
load_avg is not after propagating load in the cgroup hierarchy.

Use load_avg to compute load_sum similarly to what is done for util_sum
and runnable_sum.

Fixes: 0e2d2aaaae52 ("sched/fair: Rewrite PELT migration propagation")
Reported-by: Odin Ugedal <odin@uged.al>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Odin Ugedal <odin@uged.al>
Link: https://lkml.kernel.org/r/20210527122916.27683-2-vincent.guittot@linaro.org

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3248e24a90b0..f4795b800841 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3499,10 +3499,9 @@ update_tg_cfs_runnable(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cf
 static inline void
 update_tg_cfs_load(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cfs_rq *gcfs_rq)
 {
-	long delta_avg, running_sum, runnable_sum = gcfs_rq->prop_runnable_sum;
+	long delta, running_sum, runnable_sum = gcfs_rq->prop_runnable_sum;
 	unsigned long load_avg;
 	u64 load_sum = 0;
-	s64 delta_sum;
 	u32 divider;
 
 	if (!runnable_sum)
@@ -3549,13 +3548,13 @@ update_tg_cfs_load(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cfs_rq
 	load_sum = (s64)se_weight(se) * runnable_sum;
 	load_avg = div_s64(load_sum, divider);
 
-	delta_sum = load_sum - (s64)se_weight(se) * se->avg.load_sum;
-	delta_avg = load_avg - se->avg.load_avg;
+	delta = load_avg - se->avg.load_avg;
 
 	se->avg.load_sum = runnable_sum;
 	se->avg.load_avg = load_avg;
-	add_positive(&cfs_rq->avg.load_avg, delta_avg);
-	add_positive(&cfs_rq->avg.load_sum, delta_sum);
+
+	add_positive(&cfs_rq->avg.load_avg, delta);
+	cfs_rq->avg.load_sum = cfs_rq->avg.load_avg * divider;
 }
 
 static inline void add_tg_cfs_propagate(struct cfs_rq *cfs_rq, long runnable_sum)

