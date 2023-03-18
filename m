Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDBE6BFBF3
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 18:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjCRRkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 13:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCRRki (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 13:40:38 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2A7222EE
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:36 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id az3-20020a05600c600300b003ed2920d585so6803197wmb.2
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679161234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9qYnf6bG4t/CZsEfkond99dTvRo5PJ1m29yCx2krtwQ=;
        b=ojXfgb4OwkeQnM8EFrJnV1Yo2i4jXH+w2A6MXO0nnMBHWs64y1nEzQQP+rSn2HIxF1
         F3JwloujHWTv7ic4b+AbzpHZKoKubKa0j8DPu9h/LARxWsi77/QOHs+sZrFIiz8PNyOS
         w5N2+4Dm1lpU1RuXi+INYeq7nMSpkFf0w1Uovgbkx6OT9VIMGWyWWEazmXFj1l0cEd4H
         atUHDkjdSyjhsEozaUcq3Dk57wkjuOHIRAH0sXvCF6PD+6soVCe7gRhEtX0fBvSbSb8/
         YONLJ2N0nyhbD5O4rdj0SLVtNWq06GnYvlWHrRSfYocCZMv/xb1G+peN6WX5IQyqJ+eb
         HEPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679161234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9qYnf6bG4t/CZsEfkond99dTvRo5PJ1m29yCx2krtwQ=;
        b=GvF9c/3KPt3xzUWMIWBkmdod5n4X8WLgUHZbSyNv60PJOtd8YLn8D8B+wJhqbYeMyY
         tJg3AcL/JElf1yPo1VcfYH4Wmx7GkyavVueQ/5om9wJ7xnsiudm1cDUtmcPsR8F/73Hq
         KrFu+Q1xl0bjIOb16LmbEWtZKdWCUyngW4SmaklPvWquHuAiWtvNJdsfAb++M/KX/xZq
         WbWFiriHFqt06K6znb6uJAzQJPlSf0lljoAy2XFi1GuUjk762LceSAXFJ+HVm++4uv+v
         Us505j/gclYM3Iwzcbx8QNhLYPBH9PSn0XEiTXnzN4eB5gk+/8Dkld67jAYok0vXzAOS
         vMuw==
X-Gm-Message-State: AO0yUKVj8UtBUCvYukKemcdK02WdS17EaxyziBneEFook2T02+BX+jbm
        hKPlkLEZLvBc5/Ojc+8WpcKXwuFgnbCH2+G0wWE=
X-Google-Smtp-Source: AK7set/tcJCIupm57DDx9M4CAE/Nv6i3A/Nb1oTIvSl+C/OV3Wwf5yUqOOG/81suclVZilUkJFtB2Q==
X-Received: by 2002:a05:600c:5408:b0:3ea:ecc2:daab with SMTP id he8-20020a05600c540800b003eaecc2daabmr30975605wmb.3.1679161234639;
        Sat, 18 Mar 2023 10:40:34 -0700 (PDT)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id f20-20020a7bcd14000000b003e203681b26sm5313886wmj.29.2023.03.18.10.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 10:40:34 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Yun Hsiang <hsiang023167@gmail.com>
Subject: [PATCH v2 02/10] sched/uclamp: Fix fits_capacity() check in feec()
Date:   Sat, 18 Mar 2023 17:39:35 +0000
Message-Id: <20230318173943.3188213-3-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230318173943.3188213-1-qyousef@layalina.io>
References: <20230318173943.3188213-1-qyousef@layalina.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

commit 244226035a1f9b2b6c326e55ae5188fab4f428cb upstream.

As reported by Yun Hsiang [1], if a task has its uclamp_min >= 0.8 * 1024,
it'll always pick the previous CPU because fits_capacity() will always
return false in this case.

The new util_fits_cpu() logic should handle this correctly for us beside
more corner cases where similar failures could occur, like when using
UCLAMP_MAX.

We open code uclamp_rq_util_with() except for the clamp() part,
util_fits_cpu() needs the 'raw' values to be passed to it.

Also introduce uclamp_rq_{set, get}() shorthand accessors to get uclamp
value for the rq. Makes the code more readable and ensures the right
rules (use READ_ONCE/WRITE_ONCE) are respected transparently.

[1] https://lists.linaro.org/pipermail/eas-dev/2020-July/001488.html

Fixes: 1d42509e475c ("sched/fair: Make EAS wakeup placement consider uclamp restrictions")
Reported-by: Yun Hsiang <hsiang023167@gmail.com>
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-4-qais.yousef@arm.com
(cherry picked from commit 244226035a1f9b2b6c326e55ae5188fab4f428cb)
[Fix trivial conflict in kernel/sched/fair.c due to new automatic
variables in master vs 5.10]
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/core.c  | 10 +++++-----
 kernel/sched/fair.c  | 26 ++++++++++++++++++++++++--
 kernel/sched/sched.h | 42 +++++++++++++++++++++++++++++++++++++++---
 3 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1303a2607f1f..7c151cf7b7c1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -980,7 +980,7 @@ static inline void uclamp_idle_reset(struct rq *rq, enum uclamp_id clamp_id,
 	if (!(rq->uclamp_flags & UCLAMP_FLAG_IDLE))
 		return;
 
-	WRITE_ONCE(rq->uclamp[clamp_id].value, clamp_value);
+	uclamp_rq_set(rq, clamp_id, clamp_value);
 }
 
 static inline
@@ -1158,8 +1158,8 @@ static inline void uclamp_rq_inc_id(struct rq *rq, struct task_struct *p,
 	if (bucket->tasks == 1 || uc_se->value > bucket->value)
 		bucket->value = uc_se->value;
 
-	if (uc_se->value > READ_ONCE(uc_rq->value))
-		WRITE_ONCE(uc_rq->value, uc_se->value);
+	if (uc_se->value > uclamp_rq_get(rq, clamp_id))
+		uclamp_rq_set(rq, clamp_id, uc_se->value);
 }
 
 /*
@@ -1225,7 +1225,7 @@ static inline void uclamp_rq_dec_id(struct rq *rq, struct task_struct *p,
 	if (likely(bucket->tasks))
 		return;
 
-	rq_clamp = READ_ONCE(uc_rq->value);
+	rq_clamp = uclamp_rq_get(rq, clamp_id);
 	/*
 	 * Defensive programming: this should never happen. If it happens,
 	 * e.g. due to future modification, warn and fixup the expected value.
@@ -1233,7 +1233,7 @@ static inline void uclamp_rq_dec_id(struct rq *rq, struct task_struct *p,
 	SCHED_WARN_ON(bucket->value > rq_clamp);
 	if (bucket->value >= rq_clamp) {
 		bkt_clamp = uclamp_rq_max_value(rq, clamp_id, uc_se->value);
-		WRITE_ONCE(uc_rq->value, bkt_clamp);
+		uclamp_rq_set(rq, clamp_id, bkt_clamp);
 	}
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index de7e81cbfed2..642869018e42 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6755,6 +6755,8 @@ compute_energy(struct task_struct *p, int dst_cpu, struct perf_domain *pd)
 static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 {
 	unsigned long prev_delta = ULONG_MAX, best_delta = ULONG_MAX;
+	unsigned long p_util_min = uclamp_is_used() ? uclamp_eff_value(p, UCLAMP_MIN) : 0;
+	unsigned long p_util_max = uclamp_is_used() ? uclamp_eff_value(p, UCLAMP_MAX) : 1024;
 	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
 	unsigned long cpu_cap, util, base_energy = 0;
 	int cpu, best_energy_cpu = prev_cpu;
@@ -6782,6 +6784,8 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 
 	for (; pd; pd = pd->next) {
 		unsigned long cur_delta, spare_cap, max_spare_cap = 0;
+		unsigned long rq_util_min, rq_util_max;
+		unsigned long util_min, util_max;
 		unsigned long base_energy_pd;
 		int max_spare_cap_cpu = -1;
 
@@ -6805,8 +6809,26 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 			 * much capacity we can get out of the CPU; this is
 			 * aligned with schedutil_cpu_util().
 			 */
-			util = uclamp_rq_util_with(cpu_rq(cpu), util, p);
-			if (!fits_capacity(util, cpu_cap))
+			if (uclamp_is_used()) {
+				if (uclamp_rq_is_idle(cpu_rq(cpu))) {
+					util_min = p_util_min;
+					util_max = p_util_max;
+				} else {
+					/*
+					 * Open code uclamp_rq_util_with() except for
+					 * the clamp() part. Ie: apply max aggregation
+					 * only. util_fits_cpu() logic requires to
+					 * operate on non clamped util but must use the
+					 * max-aggregated uclamp_{min, max}.
+					 */
+					rq_util_min = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MIN);
+					rq_util_max = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MAX);
+
+					util_min = max(rq_util_min, p_util_min);
+					util_max = max(rq_util_max, p_util_max);
+				}
+			}
+			if (!util_fits_cpu(util, util_min, util_max, cpu))
 				continue;
 
 			/* Always use prev_cpu as a candidate. */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 3758f98c068c..d4632e50d8b3 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2402,6 +2402,23 @@ static inline void cpufreq_update_util(struct rq *rq, unsigned int flags) {}
 #ifdef CONFIG_UCLAMP_TASK
 unsigned long uclamp_eff_value(struct task_struct *p, enum uclamp_id clamp_id);
 
+static inline unsigned long uclamp_rq_get(struct rq *rq,
+					  enum uclamp_id clamp_id)
+{
+	return READ_ONCE(rq->uclamp[clamp_id].value);
+}
+
+static inline void uclamp_rq_set(struct rq *rq, enum uclamp_id clamp_id,
+				 unsigned int value)
+{
+	WRITE_ONCE(rq->uclamp[clamp_id].value, value);
+}
+
+static inline bool uclamp_rq_is_idle(struct rq *rq)
+{
+	return rq->uclamp_flags & UCLAMP_FLAG_IDLE;
+}
+
 /**
  * uclamp_rq_util_with - clamp @util with @rq and @p effective uclamp values.
  * @rq:		The rq to clamp against. Must not be NULL.
@@ -2437,12 +2454,12 @@ unsigned long uclamp_rq_util_with(struct rq *rq, unsigned long util,
 		 * Ignore last runnable task's max clamp, as this task will
 		 * reset it. Similarly, no need to read the rq's min clamp.
 		 */
-		if (rq->uclamp_flags & UCLAMP_FLAG_IDLE)
+		if (uclamp_rq_is_idle(rq))
 			goto out;
 	}
 
-	min_util = max_t(unsigned long, min_util, READ_ONCE(rq->uclamp[UCLAMP_MIN].value));
-	max_util = max_t(unsigned long, max_util, READ_ONCE(rq->uclamp[UCLAMP_MAX].value));
+	min_util = max_t(unsigned long, min_util, uclamp_rq_get(rq, UCLAMP_MIN));
+	max_util = max_t(unsigned long, max_util, uclamp_rq_get(rq, UCLAMP_MAX));
 out:
 	/*
 	 * Since CPU's {min,max}_util clamps are MAX aggregated considering
@@ -2488,6 +2505,25 @@ static inline bool uclamp_is_used(void)
 {
 	return false;
 }
+
+static inline unsigned long uclamp_rq_get(struct rq *rq,
+					  enum uclamp_id clamp_id)
+{
+	if (clamp_id == UCLAMP_MIN)
+		return 0;
+
+	return SCHED_CAPACITY_SCALE;
+}
+
+static inline void uclamp_rq_set(struct rq *rq, enum uclamp_id clamp_id,
+				 unsigned int value)
+{
+}
+
+static inline bool uclamp_rq_is_idle(struct rq *rq)
+{
+	return false;
+}
 #endif /* CONFIG_UCLAMP_TASK */
 
 #ifdef arch_scale_freq_capacity
-- 
2.25.1

