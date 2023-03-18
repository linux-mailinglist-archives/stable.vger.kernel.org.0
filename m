Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CAF6BFBFA
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 18:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjCRRk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 13:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjCRRku (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 13:40:50 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF39EC60
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:48 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id l15-20020a05600c4f0f00b003ed58a9a15eso5118991wmq.5
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679161247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jrNsAsdrKlO++asMCGr/H3HSiaovZlQ1wlXP9Rdc9vk=;
        b=WvOlOBkVk0UJ7K1dvovy7wEAKjcTWWuvQthuNt5UI3xS3OW7NIDo+FTRh2FAy6D0bV
         5OlJwbexoluBP1AKL4ZsZ61XDHZ1qw/LljNJngag5fjPF94qkzL0QuYo4OxVWeq6EoCw
         WOfdqPCVi2GFIHE7hCfgkK1bQi3XFTs14sQo/UzIKZP9hn9KdvuEFysRxINHDYz4x+Ul
         qb2Phy/vF7grVtWnDez+fawLap61foBhCEMxdpmYzve6Ny5U4pdb0cPfhtHuYqpmD6Fe
         cDSIBDyRAUrBOEHTwQcR/OtLG7DarSeTYDoYHKz7HOFHs3kiaENw3/yE+ir0PAWRaTsK
         23CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679161247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jrNsAsdrKlO++asMCGr/H3HSiaovZlQ1wlXP9Rdc9vk=;
        b=XtpP7qK2cl6X7rBbKMjVnNBQWExfNKBADo81g3lmjgbmBoeh5YnSpqm1LlSX7gIInJ
         3FArWXfnxxKC1MX8sw8vPxSdIYYMx0Svk302Si9zYPIgu8fBDIUzlJA+2NtSYJebzdoD
         JwKMbdJUdgxp4nX14C3iyrTmIvwSCaC8Pz4OyUz8OoRYDcUlu4DGSyogsJW0KlWHjL4t
         lBX27MtsBkbI6uHCFhqElF54sbvax5JJ2lXtdFMhSe3FcKYyMJav6AY3GkiVOH2sI8OS
         qofvvv7a/lpkT0fLXzP5Fnui0bMOdmpcgMRGF+OMMAY3tGeOlL074eq0SNSQRJtYJFrJ
         2krA==
X-Gm-Message-State: AO0yUKVB+wF/dbfb91gLOzSebn9uPS4S6qyGtCi35jhYxx+oluuw74Cm
        4mbeMxoi0aV+BRlm5zh6DLtQtNT2Iq3bU46M92I=
X-Google-Smtp-Source: AK7set/AXKOZuiyL4EEp0xv3Ong87x7Zap5FeKttSpg/QFgyIQyCUmK8S4CKozVQx5bBja7F5msS+A==
X-Received: by 2002:a05:600c:45cb:b0:3ed:32bf:c254 with SMTP id s11-20020a05600c45cb00b003ed32bfc254mr12627931wmo.12.1679161247305;
        Sat, 18 Mar 2023 10:40:47 -0700 (PDT)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id f20-20020a7bcd14000000b003e203681b26sm5313886wmj.29.2023.03.18.10.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 10:40:46 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH v2 09/10] sched/uclamp: Fix a uninitialized variable warnings
Date:   Sat, 18 Mar 2023 17:39:42 +0000
Message-Id: <20230318173943.3188213-10-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230318173943.3188213-1-qyousef@layalina.io>
References: <20230318173943.3188213-1-qyousef@layalina.io>
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
[Conflict in kernel/sched/fair.c due to new automatic variable in
master vs 5.10 and new code around for loop]
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/fair.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 67db24a7a5f8..e3910f73ad65 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6799,9 +6799,9 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 		goto unlock;
 
 	for (; pd; pd = pd->next) {
+		unsigned long util_min = p_util_min, util_max = p_util_max;
 		unsigned long cur_delta, spare_cap, max_spare_cap = 0;
 		unsigned long rq_util_min, rq_util_max;
-		unsigned long util_min, util_max;
 		unsigned long base_energy_pd;
 		int max_spare_cap_cpu = -1;
 
@@ -6810,6 +6810,8 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 		base_energy += base_energy_pd;
 
 		for_each_cpu_and(cpu, perf_domain_span(pd), sched_domain_span(sd)) {
+			struct rq *rq = cpu_rq(cpu);
+
 			if (!cpumask_test_cpu(cpu, p->cpus_ptr))
 				continue;
 
@@ -6825,24 +6827,19 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 			 * much capacity we can get out of the CPU; this is
 			 * aligned with schedutil_cpu_util().
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

