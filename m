Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0726BFBF5
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 18:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjCRRkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 13:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjCRRkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 13:40:42 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85798222E5
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:39 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id u11-20020a05600c19cb00b003edcc414997so261480wmq.3
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679161238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=17j4Exk2Jb84C17Wpej1k19ljyW0hLgDgfMeqdB5duQ=;
        b=ZLnKWvpretrVfatlbjtVKOsSSFNy+CfpKCohOj1BwaN2YcroCW0MwIkGJJkuQIMa7b
         6bDlytKRc8F3xinbefX0e1Z2fu1ofdWhHecanRjkBPZsODQqJx8V8HWJmbGAs4W/wMNr
         r245h8oUD+53q8YkCNCk60uOceVlkCdzLfZCI8voCxIGz53uWh9zI8ltnXC0v1NllYkx
         KyEBKStdwvM5GdV+LLfCoXbOWb8zj69AJ4CnhRuTOzCgGs5B59zucHn140ScXMPfZ+YC
         nDrPg5SpJTUoOsIkGGOcBM73JGkmLhm8QSUCeAPzCgJrV0T4QlrciwUj4JdRf9OynWDS
         PL2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679161238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=17j4Exk2Jb84C17Wpej1k19ljyW0hLgDgfMeqdB5duQ=;
        b=KTltKeswixyyi1mOrUS3w5acAH0DCSfeJgG5JYPRXbsb02aWg4ED02MNBwVbTalx7k
         6R8JoH9EJvJMDMu8ya/ibvmcIgEjmxHqWiz653fHAnu9EusxDa+DqTRknKm2mqrl7c1C
         qJ36V8mVk1Dz131RDxHOH50Z2OMZ+fhYbFdtqr8QnQ0VI+0pue4GAR5obM7FY45Ze4Ki
         lyEwtog/Ri7n+ImPwMEPsJZrkCSrhHy9Ldc1xRl6yauXCdjVbSGNKFHPaOCbdWB0SboK
         MTCMUWu8E0a0Pgn5IkvUFephZxcQGml2wWP+WcMaWb3iB9bHBgOuQvIs8lHzQeu9tK5q
         0QDw==
X-Gm-Message-State: AO0yUKWbWEn8cDxNwrL3UX3dtO91AQpb18Bn5LbVxDWzMtgFwyUEwMtr
        7Y4X9jqx3Qw3Gh9fG7/WOqfnl6XnFtTIBwhbjmE=
X-Google-Smtp-Source: AK7set/qgtM93Wfk6ak9Ysp7nlAEV5nc+P3AGWqyL4RR4eGiN6L+S27Q8HVo3BQPPpp3hzWT3Sj5mA==
X-Received: by 2002:a05:600c:3ba1:b0:3ed:2eb5:c2e8 with SMTP id n33-20020a05600c3ba100b003ed2eb5c2e8mr14890644wms.10.1679161238081;
        Sat, 18 Mar 2023 10:40:38 -0700 (PDT)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id f20-20020a7bcd14000000b003e203681b26sm5313886wmj.29.2023.03.18.10.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 10:40:37 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH v2 04/10] sched/uclamp: Make asym_fits_capacity() use util_fits_cpu()
Date:   Sat, 18 Mar 2023 17:39:37 +0000
Message-Id: <20230318173943.3188213-5-qyousef@layalina.io>
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

