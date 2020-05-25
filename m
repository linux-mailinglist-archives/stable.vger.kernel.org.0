Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0621E1361
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 19:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391324AbgEYR1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 13:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389605AbgEYR1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 13:27:13 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52E9C061A0E
        for <stable@vger.kernel.org>; Mon, 25 May 2020 10:27:12 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id r7so1042329wro.1
        for <stable@vger.kernel.org>; Mon, 25 May 2020 10:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=x2S+x/if4e2yvxZGOayuIopWpnk7HnG2vcQFQEtId8Y=;
        b=QLkIY+tc+iYyOSSjqZQQl8mg/01ecJnncgxpOkCeG90OKcZtkcCANO8LpCWkED6hNG
         n3ojKeyBQmt8anSjzERV9vPpJrRPso+N8GeoYqEdlolfdoED66B6jaUSqyyArH8mP7yr
         ebouQY6hnIwDnmc3Q2QegLEAYLX4cJO0PAMNfx8Qbre4kFLa2zbWVtJFpl+QTDphAAnL
         NBi+Xr2871JWFTUH4OrSdV6QMGZF0zwoR17DQ7ls7+/uRcd3XMxJJKctZhcsGu92Y2+m
         vz2hiksHYYEivwHAB6KxLmeDItiWixJ/rschh1jyTlZYPwZYJU0VJHoLEl8DKkAo2ovF
         /RFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=x2S+x/if4e2yvxZGOayuIopWpnk7HnG2vcQFQEtId8Y=;
        b=f0Xucfw9KdLyZzBVkDEAmr7fLXpB6j3ZyE1pi9XVg7c3XthQKrN/kTiYPh+JY/pAkr
         T55JZ2K7MZWDx7qXKmlSjzUd76JvuJ9quiVoY56ctQJjh7FW7e60B8RrTqZ1CSJniks7
         oD7Cl8na3ugmBufg0bLO08rs2+aefntZvV2PJNTg6y21GjGLjiOtzd9B1gJ/0/rjALEW
         ZBiQ0+e/KG6UhChLbLMpd7pIQFbtkwqT1rYyO7wXsiLeB18/Bh2OMCXPPxnsC4+r0+9K
         aWtkJTl5TwBcCZRUPA4+6+JTVSAQrcwHfQ1HPZaWrn95sSS+Iy8AU17RKAZdTLi76DIh
         Pu3Q==
X-Gm-Message-State: AOAM531kvt0jckIJOvmwLYiXFSG2+njeX+2gNwKoG8Dn/KOqx/cfjKI5
        48jvKHQA2yBkuKYRqaGV5k4bvA==
X-Google-Smtp-Source: ABdhPJylqIoLdVhQbm2SuH2p1dYYQ0HqZllDuu6xkjIh4KestuGvhhZuEilRrgkazHaqY4PT/p2MEw==
X-Received: by 2002:adf:fec3:: with SMTP id q3mr9994264wrs.123.1590427631510;
        Mon, 25 May 2020 10:27:11 -0700 (PDT)
Received: from vingu-book ([2a01:e0a:f:6020:4472:94ba:76c5:5d9f])
        by smtp.gmail.com with ESMTPSA id z25sm5615567wmf.10.2020.05.25.10.27.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 May 2020 10:27:10 -0700 (PDT)
Date:   Mon, 25 May 2020 19:27:09 +0200
From:   Vincent Guittot <vincent.guittot@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     bsegall@google.com, pauld@redhat.com, peterz@infradead.org,
        zohooouoto@zoho.com.cn, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
Message-ID: <20200525172709.GB7427@vingu-book>
References: <159041776924279@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <159041776924279@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le lundi 25 mai 2020 à 16:42:49 (+0200), gregkh@linuxfoundation.org a écrit :
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This patch needs  commit
    b34cb07dde7c ("sched/fair: Fix enqueue_task_fair() warning some more")
to be applied first. But then, it will not apply. The backport is :

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
index 193b6ab74d7f..36e3bb990845 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4560,7 +4560,6 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	struct rq *rq = rq_of(cfs_rq);
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 	struct sched_entity *se;
-	int enqueue = 1;
 	long task_delta, idle_task_delta;

 	se = cfs_rq->tg->se[cpu_of(rq)];
@@ -4584,21 +4583,41 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
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
@@ -4607,7 +4626,8 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);

-		list_add_leaf_cfs_rq(cfs_rq);
+		if (list_add_leaf_cfs_rq(cfs_rq))
+			break;
 	}

 	assert_list_leaf_cfs_rq(rq);
--
2.17.1
 
