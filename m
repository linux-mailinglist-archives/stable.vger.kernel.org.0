Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971523BB387
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbhGDXSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233534AbhGDXOb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B537E6197D;
        Sun,  4 Jul 2021 23:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440207;
        bh=oVUO/BphEoCkynoRb4MuWNMVteXgceEelZdwaJlgJIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CdH3a5WKEINkR9JK1YsxImuDJdVzY2DEUVei9YFbku7p85yQdMlzQPG/P1c/ZRG72
         6yjLda29IGezvA7VXxC6jlMN72a5yAS685c+uBB7yLbypJ2hgTy4qZo69IoLzkXh80
         /VQqpIe9q1CGkyZFiq37JGGl8FMx0CCejSWJB2ktLdFGDcXs/Yn/qLWthNPUGSesVk
         AQdrBAXK/MnXDOqEmVUxZH2czfxpMm1fpyysVbVfxxdkJJGhb+hE2OkiVcMXrXpJRN
         Wo3g5UtUHydJfGjwskc7JpND3F13YtaabjpRh7x2e80ElHCc3ybUi6FC8ftRMte7e7
         StDFSEP1unDBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Odin Ugedal <odin@uged.al>, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 22/50] sched/fair: Fix ascii art by relpacing tabs
Date:   Sun,  4 Jul 2021 19:09:10 -0400
Message-Id: <20210704230938.1490742-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230938.1490742-1-sashal@kernel.org>
References: <20210704230938.1490742-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d3f4113e87de..d2ba080ea742 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2927,7 +2927,7 @@ void reweight_task(struct task_struct *p, int prio)
  *
  *                     tg->weight * grq->load.weight
  *   ge->load.weight = -----------------------------               (1)
- *			  \Sum grq->load.weight
+ *                       \Sum grq->load.weight
  *
  * Now, because computing that sum is prohibitively expensive to compute (been
  * there, done that) we approximate it with this average stuff. The average
@@ -2941,7 +2941,7 @@ void reweight_task(struct task_struct *p, int prio)
  *
  *                     tg->weight * grq->avg.load_avg
  *   ge->load.weight = ------------------------------              (3)
- *				tg->load_avg
+ *                             tg->load_avg
  *
  * Where: tg->load_avg ~= \Sum grq->avg.load_avg
  *
@@ -2957,7 +2957,7 @@ void reweight_task(struct task_struct *p, int prio)
  *
  *                     tg->weight * grq->load.weight
  *   ge->load.weight = ----------------------------- = tg->weight   (4)
- *			    grp->load.weight
+ *                         grp->load.weight
  *
  * That is, the sum collapses because all other CPUs are idle; the UP scenario.
  *
@@ -2976,7 +2976,7 @@ void reweight_task(struct task_struct *p, int prio)
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

