Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD5C1E135B
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 19:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389569AbgEYRY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 13:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389428AbgEYRY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 13:24:27 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B116C061A0E
        for <stable@vger.kernel.org>; Mon, 25 May 2020 10:24:27 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id h4so616104wmb.4
        for <stable@vger.kernel.org>; Mon, 25 May 2020 10:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=IU0CqAfstg13dbE3unxIbquymTSekIEpyKSQDN7kLos=;
        b=tToF5Thk2RmYfGKM26dmy+ubTsRhSAkSO32SC6GDKXC1WP1ms4U8LBOR/N8l7vRkSa
         zrsDTeWorpfUWktYWh66dUwEPn6Q5pBS/vh+hhLILiD9C2iaPEKeOrUl9MrVzK66RVhp
         Tm21+GM1N1+SycVKLOo2X2rcGnwHg//i+7fdZjgAjRZImaL8++o8zIQkcd8hrdYI8l1N
         ghLTHAs17zKbuBhjeMLlRXrpRvb+DiGnJiKavMpjnmY4kEF1I5dG923X0MC600blXCMp
         NpTuAtcbOKJ+wAZDHVX5RLCKy0AIjwrRjGdxWho/zFtFqZUTwRPteatfRpyI1Juzsjpq
         j8sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=IU0CqAfstg13dbE3unxIbquymTSekIEpyKSQDN7kLos=;
        b=ryRKXhvJm9nsmtx3TE6Sl/0ABJ9wT1mH1kSnIToMD1Xv3unq97MKbvPGptE3CbPe2S
         fuCf7eKrw3Y/EWfBAYnPR0gupWhGcqhy64P7/iamV+Nh+FJZLBtwOm7oa54+8JYqAhR/
         7YXZ4tuUG0QP898kYnuTfP+uWoybj1Q2GIW7pTUAAQRy1lSl+cB2OWOxasOiV1oBRaPl
         rvMzSqH47DjFZ7Bxa/Zs46lVa/+N5t14j1n7bCyduyVQOEEzftX4QLRqYy1tRN7x0fq5
         /kbLtqqZk+Jr/cnSsNjy7dzfaBd++hNwF9/1tqL4bi6qF+70p1+CuW6poUX+Png8jhRd
         EaXg==
X-Gm-Message-State: AOAM530/NOc/zTOiPa6HUA8h2do8eLr8qu0ceoKE1N+g+CyGs0GaLZZN
        uAW42vDWbJZBusdp3PUkAfTE/Q==
X-Google-Smtp-Source: ABdhPJxykK9NafgEBWbrdPMTvTYIkdMVdrc3mk1E4/g5gmAmYcKuPxs9DFyascz4JFzYuXlmV30H+A==
X-Received: by 2002:a1c:62d6:: with SMTP id w205mr7166093wmb.97.1590427465724;
        Mon, 25 May 2020 10:24:25 -0700 (PDT)
Received: from vingu-book ([2a01:e0a:f:6020:4472:94ba:76c5:5d9f])
        by smtp.gmail.com with ESMTPSA id c14sm7861604wme.8.2020.05.25.10.24.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 May 2020 10:24:24 -0700 (PDT)
Date:   Mon, 25 May 2020 19:24:23 +0200
From:   Vincent Guittot <vincent.guittot@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     bsegall@google.com, pauld@redhat.com, peterz@infradead.org,
        zohooouoto@zoho.com.cn, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.6-stable tree
Message-ID: <20200525172423.GA7427@vingu-book>
References: <159041776914106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <159041776914106@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le lundi 25 mai 2020 à 16:42:49 (+0200), gregkh@linuxfoundation.org a écrit :
> 
> The patch below does not apply to the 5.6-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 

This patch needs  commit
    b34cb07dde7c ("sched/fair: Fix enqueue_task_fair() warning some more")
to be applied first. But then, it will not apply. The backport is :


[ Upstream commit 39f23ce07b9355d05a64ae303ce20d1c4b92b957 upstream ]

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
---
 kernel/sched/fair.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7cd86641b44b..b579546670e3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4590,7 +4590,6 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	struct rq *rq = rq_of(cfs_rq);
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 	struct sched_entity *se;
-	int enqueue = 1;
 	long task_delta, idle_task_delta;
 
 	se = cfs_rq->tg->se[cpu_of(rq)];
@@ -4614,21 +4613,41 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	idle_task_delta = cfs_rq->idle_h_nr_running;
 	for_each_sched_entity(se) {
 		if (se->on_rq)
-			enqueue = 0;
+			break;
+		cfs_rq = cfs_rq_of(se);
+		enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);
+
+		cfs_rq->h_nr_running += task_delta;
+		cfs_rq->idle_h_nr_running += idle_task_delta;
 
+		/* end evaluation on encountering a throttled cfs_rq */
+		if (cfs_rq_throttled(cfs_rq))
+			goto unthrottle_throttle;
+	}
+
+	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
-		if (enqueue)
-			enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);
+
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
@@ -4637,7 +4656,8 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 
-		list_add_leaf_cfs_rq(cfs_rq);
+		if (list_add_leaf_cfs_rq(cfs_rq))
+			break;
 	}
 
 	assert_list_leaf_cfs_rq(rq);
-- 
2.17.1

