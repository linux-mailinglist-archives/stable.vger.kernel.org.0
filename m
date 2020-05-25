Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D681E10D2
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 16:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404112AbgEYOmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 10:42:52 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:42649 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404123AbgEYOmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 10:42:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 600791943AEB;
        Mon, 25 May 2020 10:42:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 25 May 2020 10:42:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=gSCe3y
        +oxs4OdFfbW6KyxIOJ8Lo1dJ5VvaBwoHeGS6s=; b=LlgYwSB0CT4g06gflfLa4y
        rVqCeriySObQ6VxSRW3jFoZV2Hk4qXv/QmMKwtjnQ5qOjANH6PnC3p1vNKdOby3y
        JJURoDlwZVb+T+ecI5wne4ynQnwFUH26zTtbc/++7JK4Pv2p76tYRLm0P1JOP5Mc
        lqGvvTOqG0niCBLDLcd7jIVDESR4IIAHJEfoeRo++D7p11f7F9e3l3xV7jR8sOcq
        h+h2eTdd+VWVagHf4RhAdU3bp+K66NOMI4Q56Rm7NmqwEsm5k7lKuO/B27MEGiFt
        DgcP4K3vM7bJIwPbEm2EmChIyQLAr01ajnK7cn8LJYe1RafynaR+nffbdhDSU9GA
        ==
X-ME-Sender: <xms:atnLXs1M00aFEKrmBqy8nigv7SCHAUwakYcu0Z7ionhNz2KjT8KtWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvtddgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:atnLXnH96dnGie-hqr5QAtiawatwozsErHFVVZycXmv6o4ZKd1C9Jw>
    <xmx:atnLXk7H4Jtoc-HvGG6pfowk8_nRRXh6Aa_auwE5f5Wjn3r-ZIqe4Q>
    <xmx:atnLXl1ckPaxEMH1Mur7gov0SFj_O_lZ47XDOXwsNVv01zg-Ei6bMA>
    <xmx:a9nLXkQgeCFRX7NmymtpbfxbWuXFOKgR8oKXTRa8Do6vHhp36vyZDg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A812D306656C;
        Mon, 25 May 2020 10:42:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for leaf_cfs_rq list" failed to apply to 5.4-stable tree
To:     vincent.guittot@linaro.org, bsegall@google.com, pauld@redhat.com,
        peterz@infradead.org, zohooouoto@zoho.com.cn
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 May 2020 16:42:49 +0200
Message-ID: <159041776924279@kroah.com>
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

From 39f23ce07b9355d05a64ae303ce20d1c4b92b957 Mon Sep 17 00:00:00 2001
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 13 May 2020 15:55:28 +0200
Subject: [PATCH] sched/fair: Fix unthrottle_cfs_rq() for leaf_cfs_rq list

Although not exactly identical, unthrottle_cfs_rq() and enqueue_task_fair()
are quite close and follow the same sequence for enqueuing an entity in the
cfs hierarchy. Modify unthrottle_cfs_rq() to use the same pattern as
enqueue_task_fair(). This fixes a problem already faced with the latter and
add an optimization in the last for_each_sched_entity loop.

Fixes: fe61468b2cb (sched/fair: Fix enqueue_task_fair warning)
Reported-by Tao Zhou <zohooouoto@zoho.com.cn>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Reviewed-by: Ben Segall <bsegall@google.com>
Link: https://lkml.kernel.org/r/20200513135528.4742-1-vincent.guittot@linaro.org

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c6d57c334d51..538ba5d94e99 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4774,7 +4774,6 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	struct rq *rq = rq_of(cfs_rq);
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 	struct sched_entity *se;
-	int enqueue = 1;
 	long task_delta, idle_task_delta;
 
 	se = cfs_rq->tg->se[cpu_of(rq)];
@@ -4798,26 +4797,44 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	idle_task_delta = cfs_rq->idle_h_nr_running;
 	for_each_sched_entity(se) {
 		if (se->on_rq)
-			enqueue = 0;
+			break;
+		cfs_rq = cfs_rq_of(se);
+		enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);
 
+		cfs_rq->h_nr_running += task_delta;
+		cfs_rq->idle_h_nr_running += idle_task_delta;
+
+		/* end evaluation on encountering a throttled cfs_rq */
+		if (cfs_rq_throttled(cfs_rq))
+			goto unthrottle_throttle;
+	}
+
+	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
-		if (enqueue) {
-			enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);
-		} else {
-			update_load_avg(cfs_rq, se, 0);
-			se_update_runnable(se);
-		}
+
+		update_load_avg(cfs_rq, se, UPDATE_TG);
+		se_update_runnable(se);
 
 		cfs_rq->h_nr_running += task_delta;
 		cfs_rq->idle_h_nr_running += idle_task_delta;
 
+
+		/* end evaluation on encountering a throttled cfs_rq */
 		if (cfs_rq_throttled(cfs_rq))
-			break;
+			goto unthrottle_throttle;
+
+		/*
+		 * One parent has been throttled and cfs_rq removed from the
+		 * list. Add it back to not break the leaf list.
+		 */
+		if (throttled_hierarchy(cfs_rq))
+			list_add_leaf_cfs_rq(cfs_rq);
 	}
 
-	if (!se)
-		add_nr_running(rq, task_delta);
+	/* At this point se is NULL and we are at root level*/
+	add_nr_running(rq, task_delta);
 
+unthrottle_throttle:
 	/*
 	 * The cfs_rq_throttled() breaks in the above iteration can result in
 	 * incomplete leaf list maintenance, resulting in triggering the
@@ -4826,7 +4843,8 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 
-		list_add_leaf_cfs_rq(cfs_rq);
+		if (list_add_leaf_cfs_rq(cfs_rq))
+			break;
 	}
 
 	assert_list_leaf_cfs_rq(rq);

