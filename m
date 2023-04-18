Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A7B6E669A
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjDROFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjDROFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:05:20 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F2513C1C
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:05:19 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id ay3-20020a05600c1e0300b003f17289710aso3525619wmb.5
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681826718; x=1684418718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nR29gJTEdgkhzcjWePAo1HDoMpqsxrlON8E2nbKYHY4=;
        b=Ju4xDsJidLaYax2aB3+vumRp8gm8YEBXs9AHESscAZoSuQeeWE2kk0uboW3iiFb5bB
         JSvL+UficTIcN5gCmvI3bimmy8Y/czWJbg/wyEiZS+M3XD9rLwMbgJth+A3G7f0D/Xsz
         QQx/Eluet5dOEMUZoGOtGFW4xN/SB+kqj8u7yI4lSCmq4y1aJC6avL7nIKMsQi7QAsx3
         l3lXzOYrQvQSmK+nWq+nVdJ2+8xud2Wcc2Zykxw2OKI6cSv1lsAE+0+8ijfXR4NTDVPs
         bqOYHR8FZggdb1FqppXetdyNDC6RVkHhXWKD9UCmijfk+l0ihyRbytFb1hykouxNTX2/
         8fIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826718; x=1684418718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nR29gJTEdgkhzcjWePAo1HDoMpqsxrlON8E2nbKYHY4=;
        b=IcINML4M4SK3lyB12fCvZVdveYZZVSlf3N/m2o6ADVPKyvs1mHU3XtaIydF/BZaEVh
         QC+/OnPYdxljKsHKy8PLAOV26aneu6pPPa7zjWL69TdiOxiHfxP3Nl97pEvMD1anQvVi
         uXLa3lbDUnTI4Ev2heYb6tThdVYaG9OkoXcOQ6XkPr8Wk4BLgWvSekjpkxjYL/AjHVji
         rNX+KO6PiyfUf51X6tgaXcw+P4A/tBetCTk9g6G3CduqqsGP91Y/mlLf3W/VtGyY1Fmw
         KpknKl+8TZmcVSwkm0pnkyfWVqEmwJNG/z1JF279q3HbRfco/LzgcinSVUb5eLFlBke9
         cWZw==
X-Gm-Message-State: AAQBX9e6SzLc8RZbYlrJeUhch7VWLTYlFSr3bdIqkpmJrM8PRohi++WX
        jMBgvJ/EfS2IrtSeytvIWGAiRcBDuCFbcV9PnbU=
X-Google-Smtp-Source: AKy350bLgddYEAWY5Y5oVOJIVdG5IH/EdCKb0L/g2DzdXNzpdaAWxe7MUPDpgCWE4pTJN6Ljprp6cQ==
X-Received: by 2002:a7b:cc81:0:b0:3f1:72d4:b271 with SMTP id p1-20020a7bcc81000000b003f172d4b271mr6362869wma.3.1681826717946;
        Tue, 18 Apr 2023 07:05:17 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id e16-20020a5d4e90000000b002f2782978d8sm13101943wru.20.2023.04.18.07.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:05:17 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>
Subject: [PATCH 3/3] sched/fair: Fixes for capacity inversion detection
Date:   Tue, 18 Apr 2023 15:04:54 +0100
Message-Id: <20230418140454.87367-4-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230418140454.87367-1-qyousef@layalina.io>
References: <20230418140454.87367-1-qyousef@layalina.io>
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

commit: da07d2f9c153e457e845d4dcfdd13568d71d18a4 upstream.

Traversing the Perf Domains requires rcu_read_lock() to be held and is
conditional on sched_energy_enabled(). Ensure right protections applied.

Also skip capacity inversion detection for our own pd; which was an
error.

Fixes: 44c7b80bffc3 ("sched/fair: Detect capacity inversion")
Reported-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20230112122708.330667-3-qyousef@layalina.io
(cherry picked from commit da07d2f9c153e457e845d4dcfdd13568d71d18a4)
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/fair.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1de54a6c2176..32d1859a037f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8900,16 +8900,23 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 	 *   * Thermal pressure will impact all cpus in this perf domain
 	 *     equally.
 	 */
-	if (static_branch_unlikely(&sched_asym_cpucapacity)) {
+	if (sched_energy_enabled()) {
 		unsigned long inv_cap = capacity_orig - thermal_load_avg(rq);
-		struct perf_domain *pd = rcu_dereference(rq->rd->pd);
+		struct perf_domain *pd;
+
+		rcu_read_lock();
 
+		pd = rcu_dereference(rq->rd->pd);
 		rq->cpu_capacity_inverted = 0;
 
 		for (; pd; pd = pd->next) {
 			struct cpumask *pd_span = perf_domain_span(pd);
 			unsigned long pd_cap_orig, pd_cap;
 
+			/* We can't be inverted against our own pd */
+			if (cpumask_test_cpu(cpu_of(rq), pd_span))
+				continue;
+
 			cpu = cpumask_any(pd_span);
 			pd_cap_orig = arch_scale_cpu_capacity(cpu);
 
@@ -8934,6 +8941,8 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 				break;
 			}
 		}
+
+		rcu_read_unlock();
 	}
 
 	trace_sched_cpu_capacity_tp(rq);
-- 
2.25.1

