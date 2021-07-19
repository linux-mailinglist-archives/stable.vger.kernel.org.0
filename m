Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF6D3CDCB1
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237598AbhGSOx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238401AbhGSOtm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:49:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 075B260FED;
        Mon, 19 Jul 2021 15:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708620;
        bh=cI5LLAM5nefWM04Pfqy3C8ErZrx7Aie9D1pLLstIDS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BfFDM3OXw0IEv2tpxRulumD5KMIgbD5kOSrvMzqe4NzIIaTHu7hSnZU8QKQEKBa3w
         QyW1yL6RaCEGzYShZhsBrrxRyEKWsTUR7BLoufnairM4EpjimKHivFOpju9SDvbUqt
         FgoBsWA8RKqVcZqutvU4HVAy8jfeBGLXHd9+YVCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Odin Ugedal <odin@uged.al>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 062/421] sched/fair: Fix ascii art by relpacing tabs
Date:   Mon, 19 Jul 2021 16:47:53 +0200
Message-Id: <20210719144948.342625703@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Odin Ugedal <odin@uged.al>

[ Upstream commit 08f7c2f4d0e9f4283f5796b8168044c034a1bfcb ]

When using something other than 8 spaces per tab, this ascii art
makes not sense, and the reader might end up wondering what this
advanced equation "is".

Signed-off-by: Odin Ugedal <odin@uged.al>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/20210518125202.78658-4-odin@uged.al
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index acb34e9df551..9cdbc07bb70f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2940,7 +2940,7 @@ void reweight_task(struct task_struct *p, int prio)
  *
  *                     tg->weight * grq->load.weight
  *   ge->load.weight = -----------------------------               (1)
- *			  \Sum grq->load.weight
+ *                       \Sum grq->load.weight
  *
  * Now, because computing that sum is prohibitively expensive to compute (been
  * there, done that) we approximate it with this average stuff. The average
@@ -2954,7 +2954,7 @@ void reweight_task(struct task_struct *p, int prio)
  *
  *                     tg->weight * grq->avg.load_avg
  *   ge->load.weight = ------------------------------              (3)
- *				tg->load_avg
+ *                             tg->load_avg
  *
  * Where: tg->load_avg ~= \Sum grq->avg.load_avg
  *
@@ -2970,7 +2970,7 @@ void reweight_task(struct task_struct *p, int prio)
  *
  *                     tg->weight * grq->load.weight
  *   ge->load.weight = ----------------------------- = tg->weight   (4)
- *			    grp->load.weight
+ *                         grp->load.weight
  *
  * That is, the sum collapses because all other CPUs are idle; the UP scenario.
  *
@@ -2989,7 +2989,7 @@ void reweight_task(struct task_struct *p, int prio)
  *
  *                     tg->weight * grq->load.weight
  *   ge->load.weight = -----------------------------		   (6)
- *				tg_load_avg'
+ *                             tg_load_avg'
  *
  * Where:
  *
-- 
2.30.2



