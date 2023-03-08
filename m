Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99DD6B0E64
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjCHQRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbjCHQRX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:17:23 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0689BDD1A
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 08:17:03 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id bw19so15895315wrb.13
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 08:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678292222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jrNsAsdrKlO++asMCGr/H3HSiaovZlQ1wlXP9Rdc9vk=;
        b=OeqW4RIzu1yMOos/f4ejbRVBY0GXiJo1JDlq4kBl3OPpn0NTshb7tDXZrCpXTDXTet
         A0P+4P3gv3TxfWbQkIeVG8rS4WXRv8ekMdUqHoX2dYSrQEmW+yL2amoR337yYN9domtf
         LjebViNu65fHnE7RuyWC87gD30D65uWNjTN24/J+hmVmbBIc08I2JABEY6wapOMUIu+8
         mwAsfmutfaImNiubigCbJ61zU7nFLoNbQ8Y2GYhw/7muegVkNUqN6K1gBlGVjSnixXvS
         lpmPKT3YKrtWsuPalkjuH0+cEPOx7rsfyBfUSnAK/R2Z2SXpzNK9WHwAFxcJrUfCbbMW
         Bg3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jrNsAsdrKlO++asMCGr/H3HSiaovZlQ1wlXP9Rdc9vk=;
        b=7gPt82gJavIMdSDEsD/jRoQVaWTDb9EBkCseLdGsPZBqyXF9LGAlyCIXQOj0ZiJVip
         GTfTEbFnWxImSWj7rcTbLM2sq3JmudRgC35VebDRlwdXx3Mn/UWrZA9iGSE1uaB+iM29
         O0MTGK7DcNLpP+HEkLDrfuk4M3RfNakZ4WGiYB9TYdlGb7nTbu7cxPwGG6Mban4hU54i
         OYLvvmjGEvmXx6kWOP3ErYshhPcjuZ0tjs54Tv1b9/3KBPKlF60N4S5etLz2rI0uLxtl
         gJNH9DbXsc1Vu+7wBoAUKPc93jPC1oMyxwqO3VIzRC34CPbNcoFBFFSXpqy+IOuebwVL
         UXhg==
X-Gm-Message-State: AO0yUKXVsSoveboT/ApKIRdsZ0e9ltkWWI2R27LLD2/mz4tPFb6TRZ1y
        73H7qBr3oB7PKjK5HOsYdiuyz2FGupqeF5qNAHY=
X-Google-Smtp-Source: AK7set+ekwyt4BiGveJzc1k+HI6TKAhLIPVm+LWVZwXr7dLZxJDPp3B+P5qjlXsPtTzU1wKG+tBRjw==
X-Received: by 2002:a05:6000:1289:b0:2c7:1524:eb07 with SMTP id f9-20020a056000128900b002c71524eb07mr10971252wrx.67.1678292222434;
        Wed, 08 Mar 2023 08:17:02 -0800 (PST)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id w7-20020a5d6087000000b002c567b58e9asm15862379wrt.56.2023.03.08.08.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:17:02 -0800 (PST)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH 09/10] sched/uclamp: Fix a uninitialized variable warnings
Date:   Wed,  8 Mar 2023 16:15:57 +0000
Message-Id: <20230308161558.2882972-10-qyousef@layalina.io>
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

