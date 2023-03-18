Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD236BFC76
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 20:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjCRTdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 15:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjCRTdt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 15:33:49 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B2B2194F
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 12:33:47 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id i9so7102518wrp.3
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 12:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679168027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FVmc4O7N6lTFzucegzVlexfmD/ygBi6+v2FQsqfQN6s=;
        b=5gpDuudDANqojWIeC05U1KxnRihUnbV36REbqKWB49TdQqS78d6EY7ToPSWqKi+8kO
         phsxYY2Y69i+3YOgSzmwvNqRtxLryetwgCUi3jWUs4c8pKo9Y4XOTJrO6Id+y40wrP0A
         IdjooCUobeceMTllZRoIOn3Z1lKRtEyMsHP96zXxiz6EldiV7iMBy5XVsiWcYs1vOMhA
         5UJe/CLjflkoAIlmx29JahE2v5lBtKrzisHlSG7XFVwmUn0NmlCd3eLOlWpAA2+RQ5fz
         oWnyCzvG+ehU6vXAoQZ/x5EgLNOtZx0ONSZIGeuakvBnHUlvdRfFJKoUYnD6DLJKZ+By
         HWCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679168027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FVmc4O7N6lTFzucegzVlexfmD/ygBi6+v2FQsqfQN6s=;
        b=WyID36GAniQc2+3XEaNi67Ggan9tzJNwPzOlbbseFchesiuBp2Lapd6JWiJ2dKZwDw
         fCMfqNT53fvYBYH1H3HvBx21hvvjVI4hkx+NlC2XLAJGDdu9aZgzze9sSVgI3RLi2f5V
         RViEqPGgoCDhaWM0Gbt541mVDOQ+ZMZWg5Ib6n/w/M2V2UvJTnOFPLdxFQLufTk5KstX
         1vk4+9d0j30P6ZMMqKKgTwqEl2rG0VsOIC+ON8vcv/lLdZkQxVJCfPsh9cKjQgFdJ4Jo
         +7l8Ztdx7KbHYh/0zhTpCGuXP1V8IBRxHtKQEfa0K/ioQCF8grmEolGRTDbXG3hJycmL
         RH8w==
X-Gm-Message-State: AO0yUKW7wAqA/EyfbGJdUKgngOgSCJUbJCkl1sWC9VPn7mHQM0xWZCqC
        YcJcOZP5tNiW34BeuHdFyFpwcTaUyj1SR8hDDbw=
X-Google-Smtp-Source: AK7set+49HwoSM2c9+PVq0ZGtxShzaBn+S8V96n2JGWE8Gabeon65N+2wS28kKzw9kH035JeVIOpHg==
X-Received: by 2002:adf:dc8c:0:b0:2ce:a7df:c115 with SMTP id r12-20020adfdc8c000000b002cea7dfc115mr11747995wrj.41.1679168027532;
        Sat, 18 Mar 2023 12:33:47 -0700 (PDT)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id o6-20020adfeac6000000b002c71a32394dsm4968696wrn.64.2023.03.18.12.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 12:33:47 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>
Subject: [PATCH RESEND 7/7] sched/fair: Fixes for capacity inversion detection
Date:   Sat, 18 Mar 2023 19:33:02 +0000
Message-Id: <20230318193302.3194615-8-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230318193302.3194615-1-qyousef@layalina.io>
References: <20230318193302.3194615-1-qyousef@layalina.io>
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

