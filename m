Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BD31E10D1
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 16:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404109AbgEYOms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 10:42:48 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:39743 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404123AbgEYOms (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 10:42:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id D95A41943A86;
        Mon, 25 May 2020 10:42:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 25 May 2020 10:42:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=dNGUtJ
        S7XiM13NtLZfDwbbL5gQHEhza5LO4VOszLt6o=; b=fDxf0b7ipQijhofrOkNZpQ
        TefnmvupCVJ1L05Ho6VBSER5JoGjR+qP8q9W5wSD0LYKwaS1fjeTXZDmO9iEh1WI
        gFYFucq3LactlWl5hcleLBnGRkp4csf1O4wfcu4ILIX8zRyAbxvirXlICcZMz/Te
        j7LH57u5PI3pqxBULtqh371X0+S3VazONXNQh4oLBCLi9Qzb9fmI6nISo/ca5TQ3
        dlKuZHYucs/Dh5YgOzQwvHBMeZXmiYoF/Z7g40y1iFU0UHIjjl25job1SGq0prFo
        NXXlY2LDAlJVfu8HhcZQw/DdJSviR4/F+kIkbSPUnq1pnpj34YoyIBOvETjGjESg
        ==
X-ME-Sender: <xms:ZtnLXr2m7dThbjq0Zr1MySuKQStdELemJqbF7OujPX8kicUB6bjJnA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvtddgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ZtnLXqHoLxGIwZfIfpERtzdL6LYnCyN1l6NLxNLA_3ywp80EvkuFaQ>
    <xmx:ZtnLXr4KM2Y3GFnmMcU60zm8Jgt_gUlfGqGrdNzAoNte7a9DipakQw>
    <xmx:ZtnLXg2zbU8xaJOwRVhNmo8JjKkh15W4QYv1ntsbJxMhPfWUjAO70Q>
    <xmx:ZtnLXgMzkW7_UloSRmLlK7UxKupHJoc5qaqB3St5_5PundroqMcF6Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 79EA6328005D;
        Mon, 25 May 2020 10:42:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] sched/fair: Fix enqueue_task_fair() warning some more" failed to apply to 5.6-stable tree
To:     pauld@redhat.com, dietmar.eggemann@arm.com, peterz@infradead.org,
        vincent.guittot@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 May 2020 16:42:36 +0200
Message-ID: <1590417756152233@kroah.com>
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

From b34cb07dde7c2346dec73d053ce926aeaa087303 Mon Sep 17 00:00:00 2001
From: Phil Auld <pauld@redhat.com>
Date: Tue, 12 May 2020 09:52:22 -0400
Subject: [PATCH] sched/fair: Fix enqueue_task_fair() warning some more

sched/fair: Fix enqueue_task_fair warning some more

The recent patch, fe61468b2cb (sched/fair: Fix enqueue_task_fair warning)
did not fully resolve the issues with the rq->tmp_alone_branch !=
&rq->leaf_cfs_rq_list warning in enqueue_task_fair. There is a case where
the first for_each_sched_entity loop exits due to on_rq, having incompletely
updated the list.  In this case the second for_each_sched_entity loop can
further modify se. The later code to fix up the list management fails to do
what is needed because se does not point to the sched_entity which broke out
of the first loop. The list is not fixed up because the throttled parent was
already added back to the list by a task enqueue in a parallel child hierarchy.

Address this by calling list_add_leaf_cfs_rq if there are throttled parents
while doing the second for_each_sched_entity loop.

Fixes: fe61468b2cb ("sched/fair: Fix enqueue_task_fair warning")
Suggested-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Phil Auld <pauld@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/20200512135222.GC2201@lorien.usersys.redhat.com

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 02f323b85b6d..c6d57c334d51 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5479,6 +5479,13 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		/* end evaluation on encountering a throttled cfs_rq */
 		if (cfs_rq_throttled(cfs_rq))
 			goto enqueue_throttle;
+
+               /*
+                * One parent has been throttled and cfs_rq removed from the
+                * list. Add it back to not break the leaf list.
+                */
+               if (throttled_hierarchy(cfs_rq))
+                       list_add_leaf_cfs_rq(cfs_rq);
 	}
 
 enqueue_throttle:

