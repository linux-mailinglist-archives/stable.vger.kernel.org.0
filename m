Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0801A3A5892
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhFMNAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 09:00:54 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:38177 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231286AbhFMNAy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 09:00:54 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id C4A7C1940A2B;
        Sun, 13 Jun 2021 08:58:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 13 Jun 2021 08:58:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=V4N80/
        QF26xD5VFBWYaV4r/Bvt5hqnlEnvjZVjGOnH0=; b=fftzwEHx83LhWZsI/odm/H
        ym2DnJ1lYcalcJvqN2sFhlfCyqw9INWXl59trewQLM0pnM6hv7fwgGl0cu4XAa/j
        uVvOUq25MECeZaZVdIseG/Z/O3aOzUUsPdUq2EJiYE4fRUgKAtKBgmga8ciCvIOY
        tyq4flWCTlP+lTS+evsn8+B+Evhv5jMcCWOBsuy955DZT9p0GDI/Ar02x5xG+21i
        qOzsq4IeF8VmrC1CO2rbKj2WW/gnujZhTZH2HCo3uL2RcXgWGCcoeVB2CKfDJNIG
        yeshmlkI2yyJApvhyLeA+VY9mUMkbaPJf1DGz7Cb6WSLA0A4En0MPzvOADjZ9irw
        ==
X-ME-Sender: <xms:CgHGYN1fGzBNOMcst5qMTlr5sIUZ9DjtgukZm-lYFM8EK5fbElbnlg>
    <xme:CgHGYEF7emGPa5YBZdwWYyu8D_BPRqbLWy1EyMUlDJPBZST-6AGghoQp_sYsb-R51
    kbmCTTW_8c0lA>
X-ME-Received: <xmr:CgHGYN44L4HauJLyeXr_LZaBT1Mzttbya9pupPIBNcPnJ9exq490IM9KSxfuB9I2CaQaQi2_-K1BLXdRe8_PflK64qZjrsrY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:CgHGYK0WvqPujRFwuiIYuJwwQhu9w3x_vLPlhJku-40hsUKi1P6Pcw>
    <xmx:CgHGYAHaDqrKojw4zFiFeK5hvfQo7LAIADPpZwscOQ92ZbguOuKOzg>
    <xmx:CgHGYL9UAhirYkaSgeP7XRLurirlcw5F98gcyHDfE1OewwMz5BIB6A>
    <xmx:CgHGYFTGQAPeXop6XEZFHquTFfcwAUlk2NcomnBWtjB1Q-QdVPphUA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 08:58:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] sched/fair: Keep load_avg and load_sum synced" failed to apply to 4.19-stable tree
To:     vincent.guittot@linaro.org, odin@uged.al, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 14:58:46 +0200
Message-ID: <162358912624445@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

