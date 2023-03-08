Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698CA6B0E5E
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjCHQRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbjCHQRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:17:03 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4827C4883
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 08:16:41 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id j2so15903284wrh.9
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 08:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678292200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oL/SZKj4sy5TbUYwqAtD83DRN3/SqY86+LNlauIFk24=;
        b=psb2Dvzghv3i5z83/0gGupWKwKm1LVQzmtX08KjIBYCeWubh7IcE13LSNUs62/RMbp
         +24JoYTAbrBjb84h3ptNniE/NtkBCDv4Y4milJZnNOGg+KKkjcK2TGD4wxUtRU6x+MNy
         RA0eJaQ+ix50FO0r8WZgpc7F55rxDgh28ct1dSIm1iuQlfon8qvWt7NvA+xwayDEwX/Z
         gGlmsh/1hy0uq95LAa1X7XJ1KXMWOlYLejWI9xDTQNJ1UJ1YnHc6W+qfx1x6wyo2Rs9U
         xx3UBIIb2VBeDztsEqGVCcYtwTfdBe3stgsRxbI+AtHxoaFVieTexq3xFDIj/IdpkeSr
         S0QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oL/SZKj4sy5TbUYwqAtD83DRN3/SqY86+LNlauIFk24=;
        b=6zGlq6ZZ5bU05q1Uofwgs6h4PpSqJd5xxQfDSl2pfwtANRYRiCjR20vNO6nQ5LigrB
         a1RWhlRUFvryzWS2bhnjBJ3gh8+sGHee5BEHE+RCziQ/fz1ZhGunEKoWkGVX9kyS5gEm
         /DlsAPGCFdOlLZTszATvEDm/QDPJWWnMjpR3+aAHYQLtat2+kJ990I7+cEqkoBQUM05A
         myECu6QnXHgteTiV1DSmr2ZviE+m1dtzAV3u5G+pFnFXcJTxv/+GjoWbZjao70Nm5/n+
         nRwzJ/x2JZLw40KQzb+V6/ULKZmMgWfmMM2tlVbcHezZloaHCCqg0x3kh7SXfW9RKOPI
         ERvg==
X-Gm-Message-State: AO0yUKUlSU7rsBWLU4+gnsjeRFSwqdj+FAIsxXTstz7/6Zj2H+pG4ZWF
        NdDNYO5lOq71ThlgQHvulrO3W+io2YBHwRDoIDA=
X-Google-Smtp-Source: AK7set+xy0bEwOo9pRYz9slH5VgkZUXPRozSccS34giOMsTeMXevQ8lmL+z1AUs6+Rd3YbmnxM6Hsg==
X-Received: by 2002:a05:6000:104b:b0:2c7:13e4:2094 with SMTP id c11-20020a056000104b00b002c713e42094mr11816068wrx.42.1678292200211;
        Wed, 08 Mar 2023 08:16:40 -0800 (PST)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id w7-20020a5d6087000000b002c567b58e9asm15862379wrt.56.2023.03.08.08.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:16:39 -0800 (PST)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH 06/10] sched/uclamp: Cater for uclamp in find_energy_efficient_cpu()'s early exit condition
Date:   Wed,  8 Mar 2023 16:15:54 +0000
Message-Id: <20230308161558.2882972-7-qyousef@layalina.io>
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
index fdfbed1e9be5..d25c6122e243 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3928,14 +3928,16 @@ static inline unsigned long task_util_est(struct task_struct *p)
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
@@ -6789,7 +6791,7 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 		goto fail;
 
 	sync_entity_load_avg(&p->se);
-	if (!task_util_est(p))
+	if (!uclamp_task_util(p, p_util_min, p_util_max))
 		goto unlock;
 
 	for (; pd; pd = pd->next) {
-- 
2.25.1

