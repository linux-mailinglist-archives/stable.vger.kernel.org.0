Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7146E669F
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjDROGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbjDROGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:06:03 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200F713866
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:06:02 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id d8-20020a05600c3ac800b003ee6e324b19so14895275wms.1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681826760; x=1684418760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0gdivBw0RhYLQnFxVnm0ZOGV4X4RH5TQsXyf9vYN5/o=;
        b=R02cVS86a4tmJVIt7zhaSwTROjop3fOLarMoQWnLJuhoLUUvsxk7zxWaYr1n15zZzp
         8PtDX2z9GeJOgumZQfVxuXPJsnciAPsx+qjJVSBuvW3lM8Bu7oEReL5VWEIjPxXWqcwW
         XAI0vvXHo023ttktLpb0ZGziVNYJVO2eKfWrWQu9xkyZT8kySxJqmrr1ugkZ93uD2H6H
         4k/DstnB2im9VMFW2FStDrZ+nlnc6gl70Elub1MtVg9wR3c/Z245VVrRqslHUGGWxMuD
         /e6DME4/WRzyq6T+ilLsBtYTPAOLMyimBCToQAHiFf3oosCQp5GV1h9Lc/5tSM9rS7ta
         9iDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826760; x=1684418760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0gdivBw0RhYLQnFxVnm0ZOGV4X4RH5TQsXyf9vYN5/o=;
        b=cIiRVGIUJlsPlAk0PlkukxfPkzJ0k+4RBb/iqAKBhsrBPfdKEJykrqNQqloyWGcctt
         J05KixYyueOdXDMnYyGMrEahTnpOSw2/F3F4votp6tLzWm2HP/8D/BUshcEZ18saR86C
         MDfWavnfayfKadaMTdth1ZCaUSad3QWEr+pIGJIaQtrv9RRNhpWQwU9YBwgeRrJIoAuG
         MguT+Bl8Mn2MaeuBMFiWgnub4xOfZj5Znd9l7xUf7Eb8Dajz2hkzHGSGzijGEz2uiRPk
         HNwBXiGelmDpg2L+eEqQNFotMzOWxSgFz1U/Sf8QW+wH7s8LW6XEEDyK3aARUQW+46O2
         vEsw==
X-Gm-Message-State: AAQBX9ekOC/UKTQe4Nm97lekqw267Eahy6J/ZpSftvqJ27enYxSZQtQ5
        ilVSnr4lnvS9GiBhO5lMeqAIWBNOYMHc+IlEUjU=
X-Google-Smtp-Source: AKy350aqqOUTHdSzqzZD9FG3hGdmzCr0gyQzyImdgxK+1R98+96qRGlTFSPNt6caiV5Zdbuc/pDyPg==
X-Received: by 2002:a05:600c:2241:b0:3f1:7a44:317c with SMTP id a1-20020a05600c224100b003f17a44317cmr1575637wmm.24.1681826760590;
        Tue, 18 Apr 2023 07:06:00 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id u9-20020a05600c210900b003f17c1384c4sm571420wml.12.2023.04.18.07.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:06:00 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH RESEND 3/7] sched/uclamp: Cater for uclamp in find_energy_efficient_cpu()'s early exit condition
Date:   Tue, 18 Apr 2023 15:05:43 +0100
Message-Id: <20230418140547.88035-4-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230418140547.88035-1-qyousef@layalina.io>
References: <20230418140547.88035-1-qyousef@layalina.io>
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

