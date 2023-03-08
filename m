Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C776B0E5C
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjCHQRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbjCHQQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:16:59 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79CAC2228
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 08:16:36 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id g3so15910930wri.6
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 08:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678292195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=17j4Exk2Jb84C17Wpej1k19ljyW0hLgDgfMeqdB5duQ=;
        b=pUS2Ht4fyMqXKy56oEyAdCxZ59xlwFqHFIi0BAGZpmrMHd2rLofCuDQDa28aoeDxjf
         6A+fDemDKMd6T0buk+wS32oLaCxRfyNE+ADz6+U4SqofUPrSCtRX9oH+7pbQoogfJZ/5
         scWqm1pJHOx6Lb9evFwKHzFL0BYyjtpzrK0cR1OjxJOP9juSDt81wz4LjJXvQZ+9mPrd
         BYARGQguz1l3yD3K+eJ/6l1uBgc+JHvlKM6D4oNPJ5EgV9Pxq0Wp83Q/XpHh+yVdcOa+
         gDLDEN+B663eSiLB3GI1vQj4IBqjjgUAVH/T70urzhq0TYtimB8LlJ9IRkwKupuPNHzV
         UYzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=17j4Exk2Jb84C17Wpej1k19ljyW0hLgDgfMeqdB5duQ=;
        b=cLeGkWwqdRARdhmfOpkbijC37nhADtnpnhPy4gHivgxvkXeaSD5gA/QgjH14HXcQ7z
         pd9kqG3eUrua19fR04pxKSMg/Zu6RIh9VL24JwKDm7HUg8tt+jOpAuTl4F/PrqkUVamo
         IcECjsLUrlmRPOnKPudVNo0G5qF2yaHx8mBZpCazHSzDq43U0TB2YL6nLwt8d4ZDJ6Iq
         03YbBn5c4yX7cXsTHIrDHMohLJMMfqrla8cvJfB//V9+3GLyI9xbQdwRWmCXO0jf3SHk
         8i4j8YuPwDAHv/ox9m6gsmCfIkbssNRYv5m8PvQ1KgSIsv19ocJCFvq3ktbqfh1MJMdg
         2OmQ==
X-Gm-Message-State: AO0yUKXVZLLqeR3v0zNeRzuXpfUtAP5alyyeSKnyIfsvlT+USKEjr7L0
        Rk91dm5mSj2KAn0TbRhju+5fpze/nn4Y01YV/Qg=
X-Google-Smtp-Source: AK7set/g24u9Lp5g4JtDHW9f4pYNkbBH/3wfdchRvt69eNthe9cJ+dwPePMh5P5lDafi4GTIyhQySQ==
X-Received: by 2002:a5d:408f:0:b0:2ca:ad16:de8 with SMTP id o15-20020a5d408f000000b002caad160de8mr9999776wrp.71.1678292195437;
        Wed, 08 Mar 2023 08:16:35 -0800 (PST)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id w7-20020a5d6087000000b002c567b58e9asm15862379wrt.56.2023.03.08.08.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:16:35 -0800 (PST)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH 04/10] sched/uclamp: Make asym_fits_capacity() use util_fits_cpu()
Date:   Wed,  8 Mar 2023 16:15:52 +0000
Message-Id: <20230308161558.2882972-5-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230308161558.2882972-2-qyousef@layalina.io>
References: <20230308161558.2882972-2-qyousef@layalina.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

commit a2e7f03ed28fce26c78b985f87913b6ce3accf9d upstream.

Use the new util_fits_cpu() to ensure migration margin and capacity
pressure are taken into account correctly when uclamp is being used
otherwise we will fail to consider CPUs as fitting in scenarios where
they should.

s/asym_fits_capacity/asym_fits_cpu/ to better reflect what it does now.

Fixes: b4c9c9f15649 ("sched/fair: Prefer prev cpu in asymmetric wakeup path")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-6-qais.yousef@arm.com
(cherry picked from commit a2e7f03ed28fce26c78b985f87913b6ce3accf9d)
[Conflict in kernel/sched/fair.c due different name of static key
wrapper function and slightly different if condition block in one of the
asym_fits_cpu() call sites]
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/fair.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index efbd1cdce508..b03633bc994f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6375,10 +6375,13 @@ select_idle_capacity(struct task_struct *p, struct sched_domain *sd, int target)
 	return best_cpu;
 }
 
-static inline bool asym_fits_capacity(unsigned long task_util, int cpu)
+static inline bool asym_fits_cpu(unsigned long util,
+				 unsigned long util_min,
+				 unsigned long util_max,
+				 int cpu)
 {
 	if (static_branch_unlikely(&sched_asym_cpucapacity))
-		return fits_capacity(task_util, capacity_of(cpu));
+		return util_fits_cpu(util, util_min, util_max, cpu);
 
 	return true;
 }
@@ -6389,7 +6392,7 @@ static inline bool asym_fits_capacity(unsigned long task_util, int cpu)
 static int select_idle_sibling(struct task_struct *p, int prev, int target)
 {
 	struct sched_domain *sd;
-	unsigned long task_util;
+	unsigned long task_util, util_min, util_max;
 	int i, recent_used_cpu;
 
 	/*
@@ -6398,11 +6401,13 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	 */
 	if (static_branch_unlikely(&sched_asym_cpucapacity)) {
 		sync_entity_load_avg(&p->se);
-		task_util = uclamp_task_util(p);
+		task_util = task_util_est(p);
+		util_min = uclamp_eff_value(p, UCLAMP_MIN);
+		util_max = uclamp_eff_value(p, UCLAMP_MAX);
 	}
 
 	if ((available_idle_cpu(target) || sched_idle_cpu(target)) &&
-	    asym_fits_capacity(task_util, target))
+	    asym_fits_cpu(task_util, util_min, util_max, target))
 		return target;
 
 	/*
@@ -6410,7 +6415,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	 */
 	if (prev != target && cpus_share_cache(prev, target) &&
 	    (available_idle_cpu(prev) || sched_idle_cpu(prev)) &&
-	    asym_fits_capacity(task_util, prev))
+	    asym_fits_cpu(task_util, util_min, util_max, prev))
 		return prev;
 
 	/*
@@ -6425,7 +6430,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	    in_task() &&
 	    prev == smp_processor_id() &&
 	    this_rq()->nr_running <= 1 &&
-	    asym_fits_capacity(task_util, prev)) {
+	    asym_fits_cpu(task_util, util_min, util_max, prev)) {
 		return prev;
 	}
 
@@ -6436,7 +6441,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	    cpus_share_cache(recent_used_cpu, target) &&
 	    (available_idle_cpu(recent_used_cpu) || sched_idle_cpu(recent_used_cpu)) &&
 	    cpumask_test_cpu(p->recent_used_cpu, p->cpus_ptr) &&
-	    asym_fits_capacity(task_util, recent_used_cpu)) {
+	    asym_fits_cpu(task_util, util_min, util_max, recent_used_cpu)) {
 		/*
 		 * Replace recent_used_cpu with prev as it is a potential
 		 * candidate for the next wake:
-- 
2.25.1

