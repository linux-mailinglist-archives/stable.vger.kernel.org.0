Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE4E6B0E85
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjCHQWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjCHQWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:22:39 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA487C1C39
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 08:22:37 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id v16so15999335wrn.0
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 08:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678292556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cHn56iVt2HnwdivXldQ/f2/54UUSj5cl5rbeRHFVuNk=;
        b=DUoTX/Tu2ZOW3VwtzRwjrhqU3KUg11JEtrDS4xKEkfNmMOFTEiRL5gI5ZZ/2YHAu8H
         w8m81ireaXWVEs52tKxy/9iDciOreVvLEyv8dCY3b1G3amg7Ufs2fxsUPNBFg9gWIYK/
         JVuAyaXb8UAXzL3pcmqKWLI1PikAROD75N/eFVh0/Faa2qXH3JKRouHXRftSJj3bl9wA
         IKtEHs3SU0aM+W2ncvu70LlKopvu9E1vIsnMrQst6z1P+8sHNV/qL+VZ1rbXYJgqEO+d
         CPq0H2RGyt77KtFJhn2RZAwTUF1CPZM9t83MCpa9oPrCPnJsrbIjhg2I93VOlKjCc/aA
         PQig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cHn56iVt2HnwdivXldQ/f2/54UUSj5cl5rbeRHFVuNk=;
        b=aRuYfuqQtJk83O1rqRoLWfJJob/UHZyts/3sGjG5M5/8Z2uStsHWiCkcUoN0gHGaxq
         OLl9N43yDqHWlmvwcqjDaFgQKqbvSJCZabNZEbVu5JtVydvtBAZTlCI1us5Dw1mbWdAG
         BwtFnWfzcGqsLCz4fkg5dbWsO73V8TMl4djNjft6BXBWqNKyk40eGF7u8QzUrKwmRh4x
         pXF4B14Re6R62DOqAr27dt1GWmlJvmAvhbmOHd80HVHQanPPPbTmrN6dlbSRRC4aCZUh
         ftstAJJC6UgdLhal0ZHJyCyKNK0hnqZJqCIe+EwRcYACJJrRz3Xuni83fvfVZkg2B4Rq
         ntoA==
X-Gm-Message-State: AO0yUKVHCWF8iYeH03FhO891hH9A4vii8vpGhC8TNpDl7Xgusg+ZAmNr
        Wuwtfz+IJURdDyV8+RMmYAtPda9u9bhkhyVmKec=
X-Google-Smtp-Source: AK7set/H5hiHiXQX4tZa9Sxdx7W7jYmJpsIZWMbGLhiWXu5AvnGeMq5r4TiciEN9WdWm8ixaCWsR2Q==
X-Received: by 2002:a5d:46c8:0:b0:2ca:101e:1056 with SMTP id g8-20020a5d46c8000000b002ca101e1056mr12657581wrs.1.1678292556425;
        Wed, 08 Mar 2023 08:22:36 -0800 (PST)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id r8-20020a5d4e48000000b002c5d3f0f737sm15786015wrt.30.2023.03.08.08.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:22:36 -0800 (PST)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH 6/7] sched/uclamp: Fix a uninitialized variable warnings
Date:   Wed,  8 Mar 2023 16:22:06 +0000
Message-Id: <20230308162207.2886641-7-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230308162207.2886641-1-qyousef@layalina.io>
References: <20230308162207.2886641-1-qyousef@layalina.io>
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

commit e26fd28db82899be71b4b949527373d0a6be1e65 upstream.

Addresses the following warnings:

> config: riscv-randconfig-m031-20221111
> compiler: riscv64-linux-gcc (GCC) 12.1.0
>
> smatch warnings:
> kernel/sched/fair.c:7263 find_energy_efficient_cpu() error: uninitialized symbol 'util_min'.
> kernel/sched/fair.c:7263 find_energy_efficient_cpu() error: uninitialized symbol 'util_max'.

Fixes: 244226035a1f ("sched/uclamp: Fix fits_capacity() check in feec()")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20230112122708.330667-2-qyousef@layalina.io
(cherry picked from commit e26fd28db82899be71b4b949527373d0a6be1e65)
[Conflict in kernel/sched/fair.c due to new automatic variables being
added on master vs 5.15]
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/fair.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a9ae621d58cb..1a78a7882868 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6977,14 +6977,16 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 		goto unlock;
 
 	for (; pd; pd = pd->next) {
+		unsigned long util_min = p_util_min, util_max = p_util_max;
 		unsigned long cur_delta, spare_cap, max_spare_cap = 0;
 		unsigned long rq_util_min, rq_util_max;
-		unsigned long util_min, util_max;
 		bool compute_prev_delta = false;
 		unsigned long base_energy_pd;
 		int max_spare_cap_cpu = -1;
 
 		for_each_cpu_and(cpu, perf_domain_span(pd), sched_domain_span(sd)) {
+			struct rq *rq = cpu_rq(cpu);
+
 			if (!cpumask_test_cpu(cpu, p->cpus_ptr))
 				continue;
 
@@ -7000,24 +7002,19 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 			 * much capacity we can get out of the CPU; this is
 			 * aligned with sched_cpu_util().
 			 */
-			if (uclamp_is_used()) {
-				if (uclamp_rq_is_idle(cpu_rq(cpu))) {
-					util_min = p_util_min;
-					util_max = p_util_max;
-				} else {
-					/*
-					 * Open code uclamp_rq_util_with() except for
-					 * the clamp() part. Ie: apply max aggregation
-					 * only. util_fits_cpu() logic requires to
-					 * operate on non clamped util but must use the
-					 * max-aggregated uclamp_{min, max}.
-					 */
-					rq_util_min = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MIN);
-					rq_util_max = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MAX);
-
-					util_min = max(rq_util_min, p_util_min);
-					util_max = max(rq_util_max, p_util_max);
-				}
+			if (uclamp_is_used() && !uclamp_rq_is_idle(rq)) {
+				/*
+				 * Open code uclamp_rq_util_with() except for
+				 * the clamp() part. Ie: apply max aggregation
+				 * only. util_fits_cpu() logic requires to
+				 * operate on non clamped util but must use the
+				 * max-aggregated uclamp_{min, max}.
+				 */
+				rq_util_min = uclamp_rq_get(rq, UCLAMP_MIN);
+				rq_util_max = uclamp_rq_get(rq, UCLAMP_MAX);
+
+				util_min = max(rq_util_min, p_util_min);
+				util_max = max(rq_util_max, p_util_max);
 			}
 			if (!util_fits_cpu(util, util_min, util_max, cpu))
 				continue;
-- 
2.25.1

