Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D8D1E10D3
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 16:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404111AbgEYOnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 10:43:00 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:57437 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404078AbgEYOnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 10:43:00 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3D4211943B66;
        Mon, 25 May 2020 10:42:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 25 May 2020 10:42:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=CNUj+W
        9QgmAvC8AT+EcQVuzZdWRqaIJGO7HpGSFJj2o=; b=m+ViHJYK7+JGw0Dk3+G6lu
        zP9WSSl8UDFPmj6oekbVkUyGlM6hrfsDnKQq/PfhJku1rkTfmgczYwDItjsWXsmI
        0kiOc5I1t1gqiSByyJe6vIfnw9e58aexQR7X6hHcMANHnkmTKodlS8BDLEI6nmTg
        bVbaaSRwMSCAvKNagsb6RSgLxQFQFfXVv8rhjOd6ONG/2Lj/usG1vrx5lCFhJQnF
        ly/FSJ/R/UsXrkw2AxOQ8QCPNOaLwqRlvaXcbHHw80d9AWEOzpWGeOQRxtBRjblA
        zJNdi3y6aEythE3HymmHOc3WXX+ntTV1jE0/cJvah6nor5Au+k8vHlayi69dx9Kw
        ==
X-ME-Sender: <xms:c9nLXnM9LgvTC_4SOjy8DVWeD4AEu_VVAaxgRwAGrvOQz9kOqnWzXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvtddgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:c9nLXh-Y3_WJrdfecJjxHf1iydgT88tieu74YdE6XLJgxRiWqEVgEA>
    <xmx:c9nLXmT306i_Ch-YGNIXPix4VLylsJ8QCyT1cE-_AT_IPthw9U-wUA>
    <xmx:c9nLXruZl19KgmTNVSQW9FvViKOB0Ai-eT_D2wMDYz_-gxYOuVO9FQ>
    <xmx:c9nLXgoQt47ATJuo7F-tR819PDzRP3_PxFmqOu0ddHlN_CrqHT7Y0w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C8ACF306656D;
        Mon, 25 May 2020 10:42:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for leaf_cfs_rq list" failed to apply to 5.6-stable tree
To:     vincent.guittot@linaro.org, bsegall@google.com, pauld@redhat.com,
        peterz@infradead.org, zohooouoto@zoho.com.cn
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 May 2020 16:42:49 +0200
Message-ID: <159041776914106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
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

