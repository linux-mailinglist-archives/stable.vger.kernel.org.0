Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE186E66BE
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbjDROKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjDROKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:10:08 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC6A13C27
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:10:07 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id o6-20020a05600c4fc600b003ef6e6754c5so13617933wmq.5
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681827005; x=1684419005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=544uuq3F9dLXA/08+tMENDXO1zPaLb7o7naTx3gxOpw=;
        b=Tr+kGxRJ5RvPw9XOKg6mFAMcsEWA8HiaNQ3JNlJPEHM+Kb7I9EsnMMYeWatGQCQ+iG
         sQMJRbjQSmlgTF+SNa51w7EKAfKlIfIrcogg9JvqlskVSQGxv4eTX5BEs2zQW30wE7w8
         ti+cY+udiWwGxDYzapsfiEzLGhbUIoHztDWUNMEPyRGfLRx2JeZhMN3P/S3SXIJPMbdu
         H6ww2FO8/+c8VlSCve0Mw0M8mQ2Z8bv+eFEPsAl4oaYTR3ctlGDICEWwfOMvFhlSnoNf
         Wkg660ph2RTXve9vWJdy48qK31mqgmJRymNnGZYpLZ27zKbizkxfLfi/0Gj9faNJvOct
         E5XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681827005; x=1684419005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=544uuq3F9dLXA/08+tMENDXO1zPaLb7o7naTx3gxOpw=;
        b=jwZsTW4a5r6tHQfbiiXpgQTyN07Pau8e83VrF1uuUGT5syoYpj+OZBii5BZK+2WQo9
         JIZ7HKK+8ypMo9OBHCn0jcqTM9IGyH7eeynecuEnyJFBB1tLc2y94vhFizhvkumIlZQp
         GpqVtw9KtYj3wGcv8rZ02WsuJQil/WcXa6zwwJkGNsDYiZjgXRT7ye0qsxZ/zzqLHa9B
         qUZRZBxngd/3v4hqwjg6PJXs0CqXusqJhZniEQOZMP94OyUj7N1ccFqGgNfkLESfTK9O
         SvkHUkQHMzOCq4iKeN3jP/X6mEXkeICmcUxF+YSYQ9Uo/DDSvBaisnBSv2JJYHPKWrun
         V/QQ==
X-Gm-Message-State: AAQBX9c3ZZqKN/oX0ysnwN4bJft0ekZfX+bFdoNpkwod2OWtK1m1KjrO
        DPEeI7AYhOTUzHsJW/9Y1Biw2/vKTiZM4pTOU9k=
X-Google-Smtp-Source: AKy350YjuIfMwfgwSHdv93VAaJhsLHX091rXNoKFyVONNg3dkz2aSTSTmamJaxZyj+QKyeoeqnpnLg==
X-Received: by 2002:a7b:cd15:0:b0:3ed:c468:ab11 with SMTP id f21-20020a7bcd15000000b003edc468ab11mr13026440wmj.28.1681827005700;
        Tue, 18 Apr 2023 07:10:05 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id n16-20020a05600c4f9000b003f1712b1402sm7978018wmq.30.2023.04.18.07.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:10:05 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH v2 RESEND 05/10] sched/uclamp: Make cpu_overutilized() use util_fits_cpu()
Date:   Tue, 18 Apr 2023 15:09:38 +0100
Message-Id: <20230418140943.90621-6-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230418140943.90621-1-qyousef@layalina.io>
References: <20230418140943.90621-1-qyousef@layalina.io>
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

commit c56ab1b3506ba0e7a872509964b100912bde165d upstream.

So that it is now uclamp aware.

This fixes a major problem of busy tasks capped with UCLAMP_MAX keeping
the system in overutilized state which disables EAS and leads to wasting
energy in the long run.

Without this patch running a busy background activity like JIT
compilation on Pixel 6 causes the system to be in overutilized state
74.5% of the time.

With this patch this goes down to  9.79%.

It also fixes another problem when long running tasks that have their
UCLAMP_MIN changed while running such that they need to upmigrate to
honour the new UCLAMP_MIN value. The upmigration doesn't get triggered
because overutilized state never gets set in this state, hence misfit
migration never happens at tick in this case until the task wakes up
again.

Fixes: af24bde8df202 ("sched/uclamp: Add uclamp support to energy_compute()")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-7-qais.yousef@arm.com
(cherry picked from commit c56ab1b3506ba0e7a872509964b100912bde165d)
[Conflict in kernel/sched/fair.c: use cpu_util() instead of
cpu_util_cfs()]
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/fair.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b03633bc994f..fdfbed1e9be5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5610,7 +5610,10 @@ static inline unsigned long cpu_util(int cpu);
 
 static inline bool cpu_overutilized(int cpu)
 {
-	return !fits_capacity(cpu_util(cpu), capacity_of(cpu));
+	unsigned long rq_util_min = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MIN);
+	unsigned long rq_util_max = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MAX);
+
+	return !util_fits_cpu(cpu_util(cpu), rq_util_min, rq_util_max, cpu);
 }
 
 static inline void update_overutilized_status(struct rq *rq)
-- 
2.25.1

