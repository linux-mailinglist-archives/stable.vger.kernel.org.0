Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D946BFC72
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 20:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjCRTdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 15:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjCRTdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 15:33:44 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295D218B3E
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 12:33:43 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id i9so7102410wrp.3
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 12:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679168021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0gdivBw0RhYLQnFxVnm0ZOGV4X4RH5TQsXyf9vYN5/o=;
        b=3YkcWafrNxH41nRtHE+Y3CAXMxMzeU3VeTE1satFrnBexUHQrZKjDxZkKtv8TeJsj3
         offMmII9eAjbnU25DgkNcTpJapVsq0yeTctX1hZSs7oV/dJ4To9uday0nlZRyg3u/zzy
         EMiNJTCAPrZpdK3AzIuECTUC769xSoStb92KG48bNrrHhf/hSXNM0JVdjSiOXtmrzCdy
         w/sOGkx4vRPIpexFi0OieCNbA3HuT4c3p2nOBI9sMLJCMP9FUeTt56yFbz3s1Pl+Iprs
         0X+ydbJYiH/9FMIRpldx4xUe1RlGo45bk0n/guIpl2AZFZaTFrMFdwcv1DvEMdTTtxla
         A/3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679168021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0gdivBw0RhYLQnFxVnm0ZOGV4X4RH5TQsXyf9vYN5/o=;
        b=G8p9cXBzSHd68sdSupA7pxN6LMZAC6cubC17wCTDr3IBHSowhIoPInY0HhYt4SakLJ
         4gIjYAefDJQr7nd8iGb66ta/woDS6FY2eisXiSEI4dYHM2VTGzxoLavWn/AgssSN/xT1
         VEgcP/w2FSbAb8/SVBAOsJPFksYLRC5rEqkvn2wYF+NI3voh3rQKnaTT8zZLyLXHAzzh
         PRSJpk11Fh9U855kZoiRjREhwkg6gegbAPjPcSNC8cfLBp6c76JLI6oQCZmsgUGgfLS0
         Ls3RR1gOWtjDDbKpRpC+1RM4K2HB97ccmXrq+qw1FDLDz/gvy8aG4GT0KHfzQQHy6l8n
         yJxg==
X-Gm-Message-State: AO0yUKX50n5bhWnRbFxHMEmFzAD2vsC1qUPrLRD+HL3SERQwv2g05x7E
        XP4ZCMxDokpgfcgnUnD4YU9vnTmpGX7Wdp1a5nI=
X-Google-Smtp-Source: AK7set9f+py9qUs1LRe8GswSyegpxPrzapQB2YUotQB5I2WAwDs/cMxulwPjyKbakenTechaBNFYxg==
X-Received: by 2002:adf:f310:0:b0:2ce:991c:5cc4 with SMTP id i16-20020adff310000000b002ce991c5cc4mr9731154wro.41.1679168021703;
        Sat, 18 Mar 2023 12:33:41 -0700 (PDT)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id o6-20020adfeac6000000b002c71a32394dsm4968696wrn.64.2023.03.18.12.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 12:33:41 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH RESEND 3/7] sched/uclamp: Cater for uclamp in find_energy_efficient_cpu()'s early exit condition
Date:   Sat, 18 Mar 2023 19:32:58 +0000
Message-Id: <20230318193302.3194615-4-qyousef@layalina.io>
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

From: Qais Yousef <qais.yousef@arm.com>

commit d81304bc6193554014d4372a01debdf65e1e9a4d upstream.

If the utilization of the woken up task is 0, we skip the energy
calculation because it has no impact.

But if the task is boosted (uclamp_min != 0) will have an impact on task
placement and frequency selection. Only skip if the util is truly
0 after applying uclamp values.

Change uclamp_task_cpu() signature to avoid unnecessary additional calls
to uclamp_eff_get(). feec() is the only user now.

Fixes: 732cd75b8c920 ("sched/fair: Select an energy-efficient CPU on task wake-up")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-8-qais.yousef@arm.com
(cherry picked from commit d81304bc6193554014d4372a01debdf65e1e9a4d)
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/fair.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cd4eccdf3291..66939333bdd1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3974,14 +3974,16 @@ static inline unsigned long task_util_est(struct task_struct *p)
 }
 
 #ifdef CONFIG_UCLAMP_TASK
-static inline unsigned long uclamp_task_util(struct task_struct *p)
+static inline unsigned long uclamp_task_util(struct task_struct *p,
+					     unsigned long uclamp_min,
+					     unsigned long uclamp_max)
 {
-	return clamp(task_util_est(p),
-		     uclamp_eff_value(p, UCLAMP_MIN),
-		     uclamp_eff_value(p, UCLAMP_MAX));
+	return clamp(task_util_est(p), uclamp_min, uclamp_max);
 }
 #else
-static inline unsigned long uclamp_task_util(struct task_struct *p)
+static inline unsigned long uclamp_task_util(struct task_struct *p,
+					     unsigned long uclamp_min,
+					     unsigned long uclamp_max)
 {
 	return task_util_est(p);
 }
@@ -6967,7 +6969,7 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 	target = prev_cpu;
 
 	sync_entity_load_avg(&p->se);
-	if (!task_util_est(p))
+	if (!uclamp_task_util(p, p_util_min, p_util_max))
 		goto unlock;
 
 	for (; pd; pd = pd->next) {
-- 
2.25.1

