Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281886E66BD
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjDROKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjDROKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:10:07 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC019EC7
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:10:05 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id o6-20020a05600c4fc600b003ef6e6754c5so13617877wmq.5
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681827004; x=1684419004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=17j4Exk2Jb84C17Wpej1k19ljyW0hLgDgfMeqdB5duQ=;
        b=wAi4VWS7MTleU9aD7dyttSZfEJJsXQKX/SESqLwytk0i+c7ct3LycRSriWR+cih0ej
         rudjT8PPtIfjwp9mLMg2VYho4Tce98RIbKlmREsPSw7xEIyNWtbP0eCV5ihz1uROG3H2
         +M03HOAdHukkUOk21XNEN79i1GqmdLVv5Z4aGGHFpQIgr/J49GBnGOR2azwOKRxYW7mt
         bjXG91lAIlN3VWulUDx0UIfLQafZINMZBKnVjWPPlrFzjeKvOMdmt59UD3tK8QT6Ur3w
         AYcNKnguRHlX9L4DMdSKROIZofqkJXCovJuKWZ1TixwUpkAwn+dz4YK2F7K7cs6OoteA
         +eSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681827004; x=1684419004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=17j4Exk2Jb84C17Wpej1k19ljyW0hLgDgfMeqdB5duQ=;
        b=U2TWNkOhrwWKI+s9V3aZGL/u/8wJlK6Tu+rz7I6z3UvvTlCShqKc46hgA1YvmNwfUb
         miX+Bfsb3GAnGe3qkAHDWlNodPtmIpbt7GTf0RAZvkdHZ0L6VSdgUlNAuKJ2cGog183R
         hMOPTRrN1DBjmOfxV/zsjIeepvU0Xdq9nYv5mC+4V0RMZ/muyl9wnJ4NrnjlwEMtkTk7
         dZwOgMDE2jTMKD8+2K6XS5dkKO2Bbw77XmL/mTCaQgmjutAFcg1UgKBKQEXZpvK5kJP7
         SWeyhwNpQssvRbSUBqCvbcRbmr0ehzdnXqIpr6uyLczFPmuPr7uRBcZN33anvQkT4JQN
         rZtQ==
X-Gm-Message-State: AAQBX9eSjmCHHlxyFY3QkjQAQVTlo5ESV7q5BN4VaiES5uEFHlVMRVFN
        GbkWUwENN4PP0kbXU27JuT9nHAhSY7Dbjw8xRVA=
X-Google-Smtp-Source: AKy350YjU2xIKK11AQpgtRo2hPufhOIDA4fK5ZopxBaWDSpdv2FSV2u3U4E2nXSALpizqtBVCEWCkg==
X-Received: by 2002:a05:600c:3646:b0:3ed:bc83:3745 with SMTP id y6-20020a05600c364600b003edbc833745mr13406812wmq.25.1681827004203;
        Tue, 18 Apr 2023 07:10:04 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id n16-20020a05600c4f9000b003f1712b1402sm7978018wmq.30.2023.04.18.07.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:10:03 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH v2 RESEND 04/10] sched/uclamp: Make asym_fits_capacity() use util_fits_cpu()
Date:   Tue, 18 Apr 2023 15:09:37 +0100
Message-Id: <20230418140943.90621-5-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230418140943.90621-1-qyousef@layalina.io>
References: <20230418140943.90621-1-qyousef@layalina.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

