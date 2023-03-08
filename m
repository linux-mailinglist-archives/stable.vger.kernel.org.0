Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 671016B0E80
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjCHQW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCHQW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:22:28 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8C0B5B6D
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 08:22:26 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id l1so15891012wry.12
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 08:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678292544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R/6fdzsXzDGrJOcUII6MHSdXOQ4lvMtjdyOdlvFhDvw=;
        b=TnJB1ObJ5UZWcAjLwJ5xenSmrqjLfYTBecVpeJo2shUMP6SR/kxyVd7HrHp/MfPfIc
         2VQZ2Y+uIkZOyLvQwy4UOLk9bSQpJSsUyvinuY4RYsPO00h14Jlydgw85D43U7IMNDas
         mDdDxCBxQVZsFH48lmdgtBhRPPm1p1QcYQoHbN6+tR7rgksn1GAuONzX23Gv4VLRBHwf
         wISsEf/jFqqBIHYeGifsr/K4qeXjuUS7GEHmaVDykYGg5vpiHRh7LaXAzo4Jta4e8i8J
         eQ90rAFj41CXiV4J9WM89l8FWtk/0a9Tw3t+bmJd2/w0JQm3pHLwb2EbIHcwdx8wU2Xd
         xxmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R/6fdzsXzDGrJOcUII6MHSdXOQ4lvMtjdyOdlvFhDvw=;
        b=bgIR5Myxn1Dr8uh7PXC6EH8sU1CDYxfqpXo9v6BqBIlETTNAx6oT4cg6uyJmf2C3YS
         DbqOTT2PROlNNzjryzEVC9dIYHfM2YDBLqhrFZctcMTVLLDS6Tjbu1NIItQWn5K/MKST
         zBHQ2qtHixaP2ZczHi7mftcLmrSnQAAVL19uOZRrBRaDBBDSZErLp/qWAJ95RL3mIRsj
         QoOTNfJPH/2yR4WKTPx8MfYKyetFqB1e29MxPYdqdBIMIGclU7EdlryzE5kt0RJrNLZE
         A7n9b2ot4qjFL3hlUE0njor/YeaBq3RJeP9cYXOqYinjyHjpF6JkSiuplUunbnrrtvaW
         im2A==
X-Gm-Message-State: AO0yUKXwY2wfOEvXAhQY4bCeNvl/kk2eOmPHQ1QbXBXSxxmvym7X90D5
        1LwZcny4r/FgN39rqcQqCuk/lc05aVJIhYWKfsY=
X-Google-Smtp-Source: AK7set+90MwCEqX9PFKPEH1KB7bVOYYyST3JUO21KbBGV27Sax+VOZCf+m7PTwUyzoPCpb4DXKXslA==
X-Received: by 2002:a5d:53c3:0:b0:2c7:658:f835 with SMTP id a3-20020a5d53c3000000b002c70658f835mr12245297wrw.33.1678292544668;
        Wed, 08 Mar 2023 08:22:24 -0800 (PST)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id r8-20020a5d4e48000000b002c5d3f0f737sm15786015wrt.30.2023.03.08.08.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:22:24 -0800 (PST)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Yun Hsiang <hsiang023167@gmail.com>
Subject: [PATCH 1/7] sched/uclamp: Fix fits_capacity() check in feec()
Date:   Wed,  8 Mar 2023 16:22:01 +0000
Message-Id: <20230308162207.2886641-2-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230308162207.2886641-1-qyousef@layalina.io>
References: <20230308162207.2886641-1-qyousef@layalina.io>
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
[Conflict in kernel/sched/fair.c mainly due to new automatic variables
being added on master vs 5.15]
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/core.c  | 10 +++++-----
 kernel/sched/fair.c  | 26 ++++++++++++++++++++++++--
 kernel/sched/sched.h | 42 +++++++++++++++++++++++++++++++++++++++---
 3 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c1458fa8beb3..313d09020161 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1335,7 +1335,7 @@ static inline void uclamp_idle_reset(struct rq *rq, enum uclamp_id clamp_id,
 	if (!(rq->uclamp_flags & UCLAMP_FLAG_IDLE))
 		return;
 
-	WRITE_ONCE(rq->uclamp[clamp_id].value, clamp_value);
+	uclamp_rq_set(rq, clamp_id, clamp_value);
 }
 
 static inline
@@ -1513,8 +1513,8 @@ static inline void uclamp_rq_inc_id(struct rq *rq, struct task_struct *p,
 	if (bucket->tasks == 1 || uc_se->value > bucket->value)
 		bucket->value = uc_se->value;
 
-	if (uc_se->value > READ_ONCE(uc_rq->value))
-		WRITE_ONCE(uc_rq->value, uc_se->value);
+	if (uc_se->value > uclamp_rq_get(rq, clamp_id))
+		uclamp_rq_set(rq, clamp_id, uc_se->value);
 }
 
 /*
@@ -1580,7 +1580,7 @@ static inline void uclamp_rq_dec_id(struct rq *rq, struct task_struct *p,
 	if (likely(bucket->tasks))
 		return;
 
-	rq_clamp = READ_ONCE(uc_rq->value);
+	rq_clamp = uclamp_rq_get(rq, clamp_id);
 	/*
 	 * Defensive programming: this should never happen. If it happens,
 	 * e.g. due to future modification, warn and fixup the expected value.
@@ -1588,7 +1588,7 @@ static inline void uclamp_rq_dec_id(struct rq *rq, struct task_struct *p,
 	SCHED_WARN_ON(bucket->value > rq_clamp);
 	if (bucket->value >= rq_clamp) {
 		bkt_clamp = uclamp_rq_max_value(rq, clamp_id, uc_se->value);
-		WRITE_ONCE(uc_rq->value, bkt_clamp);
+		uclamp_rq_set(rq, clamp_id, bkt_clamp);
 	}
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6648683cd964..1f7db97b531e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6938,6 +6938,8 @@ compute_energy(struct task_struct *p, int dst_cpu, struct perf_domain *pd)
 static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 {
 	unsigned long prev_delta = ULONG_MAX, best_delta = ULONG_MAX;
+	unsigned long p_util_min = uclamp_is_used() ? uclamp_eff_value(p, UCLAMP_MIN) : 0;
+	unsigned long p_util_max = uclamp_is_used() ? uclamp_eff_value(p, UCLAMP_MAX) : 1024;
 	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
 	int cpu, best_energy_cpu = prev_cpu, target = -1;
 	unsigned long cpu_cap, util, base_energy = 0;
@@ -6967,6 +6969,8 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 
 	for (; pd; pd = pd->next) {
 		unsigned long cur_delta, spare_cap, max_spare_cap = 0;
+		unsigned long rq_util_min, rq_util_max;
+		unsigned long util_min, util_max;
 		bool compute_prev_delta = false;
 		unsigned long base_energy_pd;
 		int max_spare_cap_cpu = -1;
@@ -6987,8 +6991,26 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 			 * much capacity we can get out of the CPU; this is
 			 * aligned with sched_cpu_util().
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
 
 			if (cpu == prev_cpu) {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e1f46ed412bc..47d40f8ef1b0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2855,6 +2855,23 @@ static inline void cpufreq_update_util(struct rq *rq, unsigned int flags) {}
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
@@ -2890,12 +2907,12 @@ unsigned long uclamp_rq_util_with(struct rq *rq, unsigned long util,
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
@@ -2941,6 +2958,25 @@ static inline bool uclamp_is_used(void)
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

