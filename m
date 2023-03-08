Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00916B0E86
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjCHQWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCHQWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:22:41 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2530B7DBB
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 08:22:39 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id e13so15912997wro.10
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 08:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678292558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FVmc4O7N6lTFzucegzVlexfmD/ygBi6+v2FQsqfQN6s=;
        b=gRWeTzeHcUGMojJLAOWtWL++JZQAKttcpFk7qtfr1EGoop8yhuSShbpIcc93sjRUc5
         nKgSc7b3xkQO57CE+G8C9DS1dutFTX8qjvUK+pIOmdZTtYnCaJlv1UbEm0/us/7cxdC+
         cyEDs6YwsZgjV/4a70rX2qM054EwXc+UoORzbppwan3lgdqYtYxhTLF0+KviR8EbRCd9
         KOAiueNsJKoFutUWbIibQGE2kpQjQCe0xP0QzxruuPHcar0HarprjlhlS30HZGcnzAub
         lZF35L3LZhfd4zGWsX0MxqB/VHAhfc1RPGVyODuhZju65DN7m7cFD/SYO/jf/Iz9H4/c
         lqyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FVmc4O7N6lTFzucegzVlexfmD/ygBi6+v2FQsqfQN6s=;
        b=eJfJqheIryaEO7fjhXg2Dwqa5KBi80x96GxL2PbGBWxPaLbaCIO72BWxDlfHHBUG3F
         iXrwVpFVUQ38CuW/dHJdWMBmxXK1TT7J7BAsC9YkNXL8cGzOBejuaYkOBxR38zE4y29q
         GxbPFkPzdOwkwT6y2vRa0YUe99iFx00aDAFb/z0oPKWs90JOj/bCFR2I5e0Q7FlIY9Qp
         /17L2uaPhkA2kRiD6jRCFRJ3VWmJm4BKBeX50jid8GOWirthybaQNZR6n0LrDHsBvcBN
         bQMEEeXoct9sGB8+TJKwax8xRgQHPp7lBcFV9VU4g1seaToSqbN7v1BAnZ7yRFQtjii5
         bA6A==
X-Gm-Message-State: AO0yUKWpEeb7N5Khm5mSpXWITDeX7pAHYeGV12C8WWvje09zR2YEbG72
        bbHnelPm2OMlDO/Ezj/VRIkDAY56mGSKCrSJ3YY=
X-Google-Smtp-Source: AK7set+0TZFwGm4FiXqS7oz7CmLur4BwOEI2K1mdd8ki7wU6OfW7PFh6RLCLLiDBJAPTkqimGjxW4w==
X-Received: by 2002:a5d:6512:0:b0:2c5:5687:5ed5 with SMTP id x18-20020a5d6512000000b002c556875ed5mr10875119wru.18.1678292558427;
        Wed, 08 Mar 2023 08:22:38 -0800 (PST)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id r8-20020a5d4e48000000b002c5d3f0f737sm15786015wrt.30.2023.03.08.08.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:22:38 -0800 (PST)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>
Subject: [PATCH 7/7] sched/fair: Fixes for capacity inversion detection
Date:   Wed,  8 Mar 2023 16:22:07 +0000
Message-Id: <20230308162207.2886641-8-qyousef@layalina.io>
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

commit da07d2f9c153e457e845d4dcfdd13568d71d18a4 upstream.

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
index 1a78a7882868..5a050c827113 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8605,16 +8605,23 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
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
 
@@ -8639,6 +8646,8 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 				break;
 			}
 		}
+
+		rcu_read_unlock();
 	}
 
 	trace_sched_cpu_capacity_tp(rq);
-- 
2.25.1

