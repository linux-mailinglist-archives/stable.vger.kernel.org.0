Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75A33BB368
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbhGDXSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234031AbhGDXOv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0F7D619A0;
        Sun,  4 Jul 2021 23:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440263;
        bh=cI5LLAM5nefWM04Pfqy3C8ErZrx7Aie9D1pLLstIDS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYDRCGYy8fN7+ypwcmXv33P+6hDXQzXwGIbpSCEtalHD7WqD05DfrAOkg5CX20qeV
         ycz/ZTP9oZ/Sy/sGm2SEjad3iFPxkh1qoHjeBxuaeM/9b2pTTogPKwEVzTYAvyY515
         +21i8iyszYSObAADv/RSFvb4rsdFpyUAqXZ7ZQFpqyvFewWUhzlr4N3pvR7Fry6A2p
         N62RzfMPMoKAaqh9Gn7cQG64ry2LhM5zsvfjyh/CBveZapARPko2EIRXNmVAqTIGaa
         ffjisdJYYj1C6oXXn0LzUE0RxJw9rt5f9coXDzLh2ktl8hgQUpfdxBBuGDscVcWkEB
         ZmW08N332roWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Odin Ugedal <odin@uged.al>, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 15/31] sched/fair: Fix ascii art by relpacing tabs
Date:   Sun,  4 Jul 2021 19:10:27 -0400
Message-Id: <20210704231043.1491209-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231043.1491209-1-sashal@kernel.org>
References: <20210704231043.1491209-1-sashal@kernel.org>
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

