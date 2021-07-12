Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC4D3C4846
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236709AbhGLGhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:37:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236592AbhGLGgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:36:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FAAA601FC;
        Mon, 12 Jul 2021 06:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071581;
        bh=mC9SpIMNdjIXkgAOLrpkfT294wYQRw21/wTtAHQFV/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xZ2watzv/yrML+yg+gLibdqQFymkAm5s/L55RCiXACP+d/y4k28g7yeUWw4GSnk9R
         KQLvkFO6dhzxUR7SDRsyE0y7U6CVFN+OOiTEtmTdwJGNQ8UNGNELpR3RAFwNsIXOQv
         UG77zl6JvYNqu5sUlrbCuJyMUy6mGcodGJHp26y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Odin Ugedal <odin@uged.al>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/593] sched/fair: Fix ascii art by relpacing tabs
Date:   Mon, 12 Jul 2021 08:04:51 +0200
Message-Id: <20210712060857.536900755@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index d6e1c90de570..3d92de7909bf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3141,7 +3141,7 @@ void reweight_task(struct task_struct *p, int prio)
  *
  *                     tg->weight * grq->load.weight
  *   ge->load.weight = -----------------------------               (1)
- *			  \Sum grq->load.weight
+ *                       \Sum grq->load.weight
  *
  * Now, because computing that sum is prohibitively expensive to compute (been
  * there, done that) we approximate it with this average stuff. The average
@@ -3155,7 +3155,7 @@ void reweight_task(struct task_struct *p, int prio)
  *
  *                     tg->weight * grq->avg.load_avg
  *   ge->load.weight = ------------------------------              (3)
- *				tg->load_avg
+ *                             tg->load_avg
  *
  * Where: tg->load_avg ~= \Sum grq->avg.load_avg
  *
@@ -3171,7 +3171,7 @@ void reweight_task(struct task_struct *p, int prio)
  *
  *                     tg->weight * grq->load.weight
  *   ge->load.weight = ----------------------------- = tg->weight   (4)
- *			    grp->load.weight
+ *                         grp->load.weight
  *
  * That is, the sum collapses because all other CPUs are idle; the UP scenario.
  *
@@ -3190,7 +3190,7 @@ void reweight_task(struct task_struct *p, int prio)
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



