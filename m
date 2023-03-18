Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13666BFBF8
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 18:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjCRRkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 13:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjCRRkq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 13:40:46 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9972EC60
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:44 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id p34so41674wms.3
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679161243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q24O4BD2dVEr7VO5beUoq9ZFwQaAu20X1FAEJurk2vU=;
        b=P5ZZw3cR6v2HCH2X0BtT1UEcBT+idMBjRQp1GKZaLWfPPNn912hUQkvSc2Nx7T/6iK
         UpusY8QmU0Cbyl6etGqJP9Feuf8vkpXnFehKDsi4ZAoqNNB2Ft1viw2G/XQI96iPcHVL
         UG1FAPRjCckAVdbj5NWPKR6RpsQpS1MdgTWKl79WnDVMg7JvheU9/JBFvPm6y5/VAQn6
         i1+wrg/wX7+JfYqAG5aXH11YiNMtp7HmS8US8rimqy+X9G6QMg/hiGmm+uWWcMpLS99U
         zdB2ZfMKpU9a4k3hGipl+gaxUEMcEMWw9IMN70zROi51q89KA6gFh0Vgu5EgEqCDb7aI
         AR9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679161243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q24O4BD2dVEr7VO5beUoq9ZFwQaAu20X1FAEJurk2vU=;
        b=ck5CLZjxpA7AjJzn9gyAMTEPIidie8+RD1453NQ8aWibx+ru167CqkqFQrgl8FmW0/
         IVfJZgFiDLlm+MttkpJdpcFXyIaKAjshAs2XuD2s+sLDJq5W6qD1YbcFW0fvywXhCq/J
         slsgA3p0DvG+KizbGb5Ul42aeCj7pKbq/InGiTF5KKLf9XFBWWDoZ3JrAyKucYLmugZh
         kNNczVVy+GnSbEcdn6rn/1+iIaTYerOfK4KNB5uG+1QmPeeRki6pd16mBcvWLL+qhI1u
         nxXrDud+9UZTJWRSV0fihI2bqzricIoZdZW+KZ4azdRKyu+INP077v6TeuIir6m5LSXO
         VP/w==
X-Gm-Message-State: AO0yUKWFk/sTxacPdS2OqBHkjgmc98zbPjOD2HMIwZrNY5CL3Y40otuC
        DGT9igfDjPPVXWNTaS7rDmN7n5I2PSMzMgJ+rZY=
X-Google-Smtp-Source: AK7set/3+5nS5YSQm9CNvEjSWgrEdiKYIEnqFpYBVX7d2HjoDaT3s/gxGFcee+N14dT+msT1RrJZ2Q==
X-Received: by 2002:a7b:ca58:0:b0:3ed:9a37:acc2 with SMTP id m24-20020a7bca58000000b003ed9a37acc2mr3756570wml.1.1679161243510;
        Sat, 18 Mar 2023 10:40:43 -0700 (PDT)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id f20-20020a7bcd14000000b003e203681b26sm5313886wmj.29.2023.03.18.10.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 10:40:43 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH v2 07/10] sched/fair: Detect capacity inversion
Date:   Sat, 18 Mar 2023 17:39:40 +0000
Message-Id: <20230318173943.3188213-8-qyousef@layalina.io>
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

commit: 44c7b80bffc3a657a36857098d5d9c49d94e652b upstream.

Check each performance domain to see if thermal pressure is causing its
capacity to be lower than another performance domain.

We assume that each performance domain has CPUs with the same
capacities, which is similar to an assumption made in energy_model.c

We also assume that thermal pressure impacts all CPUs in a performance
domain equally.

If there're multiple performance domains with the same capacity_orig, we
will trigger a capacity inversion if the domain is under thermal
pressure.

The new cpu_in_capacity_inversion() should help users to know when
information about capacity_orig are not reliable and can opt in to use
the inverted capacity as the 'actual' capacity_orig.

Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-9-qais.yousef@arm.com
(cherry picked from commit 44c7b80bffc3a657a36857098d5d9c49d94e652b)
[Trivial conflict in kernel/sched/fair.c and sched.h due to code shuffling]
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/fair.c  | 63 +++++++++++++++++++++++++++++++++++++++++---
 kernel/sched/sched.h | 19 +++++++++++++
 2 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d25c6122e243..b22f6e80ed62 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8332,16 +8332,73 @@ static unsigned long scale_rt_capacity(int cpu)
 
 static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 {
+	unsigned long capacity_orig = arch_scale_cpu_capacity(cpu);
 	unsigned long capacity = scale_rt_capacity(cpu);
 	struct sched_group *sdg = sd->groups;
+	struct rq *rq = cpu_rq(cpu);
 
-	cpu_rq(cpu)->cpu_capacity_orig = arch_scale_cpu_capacity(cpu);
+	rq->cpu_capacity_orig = capacity_orig;
 
 	if (!capacity)
 		capacity = 1;
 
-	cpu_rq(cpu)->cpu_capacity = capacity;
-	trace_sched_cpu_capacity_tp(cpu_rq(cpu));
+	rq->cpu_capacity = capacity;
+
+	/*
+	 * Detect if the performance domain is in capacity inversion state.
+	 *
+	 * Capacity inversion happens when another perf domain with equal or
+	 * lower capacity_orig_of() ends up having higher capacity than this
+	 * domain after subtracting thermal pressure.
+	 *
+	 * We only take into account thermal pressure in this detection as it's
+	 * the only metric that actually results in *real* reduction of
+	 * capacity due to performance points (OPPs) being dropped/become
+	 * unreachable due to thermal throttling.
+	 *
+	 * We assume:
+	 *   * That all cpus in a perf domain have the same capacity_orig
+	 *     (same uArch).
+	 *   * Thermal pressure will impact all cpus in this perf domain
+	 *     equally.
+	 */
+	if (static_branch_unlikely(&sched_asym_cpucapacity)) {
+		unsigned long inv_cap = capacity_orig - thermal_load_avg(rq);
+		struct perf_domain *pd = rcu_dereference(rq->rd->pd);
+
+		rq->cpu_capacity_inverted = 0;
+
+		for (; pd; pd = pd->next) {
+			struct cpumask *pd_span = perf_domain_span(pd);
+			unsigned long pd_cap_orig, pd_cap;
+
+			cpu = cpumask_any(pd_span);
+			pd_cap_orig = arch_scale_cpu_capacity(cpu);
+
+			if (capacity_orig < pd_cap_orig)
+				continue;
+
+			/*
+			 * handle the case of multiple perf domains have the
+			 * same capacity_orig but one of them is under higher
+			 * thermal pressure. We record it as capacity
+			 * inversion.
+			 */
+			if (capacity_orig == pd_cap_orig) {
+				pd_cap = pd_cap_orig - thermal_load_avg(cpu_rq(cpu));
+
+				if (pd_cap > inv_cap) {
+					rq->cpu_capacity_inverted = inv_cap;
+					break;
+				}
+			} else if (pd_cap_orig > inv_cap) {
+				rq->cpu_capacity_inverted = inv_cap;
+				break;
+			}
+		}
+	}
+
+	trace_sched_cpu_capacity_tp(rq);
 
 	sdg->sgc->capacity = capacity;
 	sdg->sgc->min_capacity = capacity;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d4632e50d8b3..852e856eed48 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -973,6 +973,7 @@ struct rq {
 
 	unsigned long		cpu_capacity;
 	unsigned long		cpu_capacity_orig;
+	unsigned long		cpu_capacity_inverted;
 
 	struct callback_head	*balance_callback;
 
@@ -2539,6 +2540,24 @@ static inline unsigned long capacity_orig_of(int cpu)
 {
 	return cpu_rq(cpu)->cpu_capacity_orig;
 }
+
+/*
+ * Returns inverted capacity if the CPU is in capacity inversion state.
+ * 0 otherwise.
+ *
+ * Capacity inversion detection only considers thermal impact where actual
+ * performance points (OPPs) gets dropped.
+ *
+ * Capacity inversion state happens when another performance domain that has
+ * equal or lower capacity_orig_of() becomes effectively larger than the perf
+ * domain this CPU belongs to due to thermal pressure throttling it hard.
+ *
+ * See comment in update_cpu_capacity().
+ */
+static inline unsigned long cpu_in_capacity_inversion(int cpu)
+{
+	return cpu_rq(cpu)->cpu_capacity_inverted;
+}
 #endif
 
 /**
-- 
2.25.1

