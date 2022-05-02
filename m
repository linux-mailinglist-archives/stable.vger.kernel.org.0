Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE33D517729
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 21:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbiEBTMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 15:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiEBTMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 15:12:15 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7429DE9A;
        Mon,  2 May 2022 12:08:45 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id j4so26855716lfh.8;
        Mon, 02 May 2022 12:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XLpkmFyOpK5Of2qpVy8Hm5z5TQyIrTyYMzHRaxdG4ZA=;
        b=n/SUUEBaS/ciUptnBMV2D5Cxm6st2A2v2VYk0uBNjz8i+Sbm0UCCMZoRzMKlLHiPlX
         FyG9yFEfsCRsC8EK083+zZf1bvqTJ5iV+MSTkf7FQ1qYLWTzFcKfSvwW9CzCUtb72iKG
         x1MO8btookevjkvyB1BkVUuyN+UiJJMf79scmTV+89e7+6zTBZHUJf03FTco5eVr51ik
         6Szoz+/vxsBhYtq+UjJEo1nRaUh/WWpbUdYKjguhp3pU7P8OrjDaDwTe55aR6/xZIclm
         Vs4VggexUFFgkGy00rz4HW7ozP8HzzVRgJYaRnAoH5Cqu+q2XFtlbBwtUCQRG3ljfFhF
         6DXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XLpkmFyOpK5Of2qpVy8Hm5z5TQyIrTyYMzHRaxdG4ZA=;
        b=eEC0I/+0kbZAbvecN6k77vLetD1IsMGTmuaLIkrrhY9gtrDQP/Zt2xcr2vIUAU8Uhs
         J9rBebNuddzJTTFyY7ZmrZiX1X2o6IHj3y6aOST/z3MUzaIcvjXRV/p1mdu5+DTFDU03
         xPw55KAmABdLkh3dEfbg7bRcf2tW9DZUoPnN/hloEcy6+QRYBYy/2ulYhf8nQzO/ZkJC
         18+4cgzS9vJpIPWflkeud3a3LXzpiPiAW39L4GYgO+qqg3AAucLdj35SZhFPBCpxfGfO
         6L3pWXOE83xVagm7pUZ7fzTz+YsYCdmsbokYxZN/kypLJ5SjcP/rxPDOAsMhKqAxgCri
         eU7A==
X-Gm-Message-State: AOAM533DHwnL6YdwhGGxufP7QLGjX1QfrGZuevxCRJeDGw0Sl2yS7sR2
        nCeiAG1j4FWuEcwmSYLPPCmoOCyxTaNP+w==
X-Google-Smtp-Source: ABdhPJym97GlEb5e/09qQd+2l6lcXuanfJCeWy9ZpRy7oMTmPxhHFbMuVPmQzlRBrGrd1fdILyjxSg==
X-Received: by 2002:a05:6512:6cb:b0:472:5e24:de05 with SMTP id u11-20020a05651206cb00b004725e24de05mr6991612lff.542.1651518524003;
        Mon, 02 May 2022 12:08:44 -0700 (PDT)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id bj39-20020a2eaaa7000000b0024f3d1daeadsm1131483ljb.53.2022.05.02.12.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 12:08:43 -0700 (PDT)
From:   "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To:     stable@vger.kernel.org
Cc:     RCU <rcu@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: [PATCH 2/2] rcu: Apply callbacks processing time limit only on softirq
Date:   Mon,  2 May 2022 21:08:33 +0200
Message-Id: <20220502190833.3352-3-urezki@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220502190833.3352-1-urezki@gmail.com>
References: <20220502190833.3352-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

commit a554ba288845fd3f6f12311fd76a51694233458a upstream.

Time limit only makes sense when callbacks are serviced in softirq mode
because:

_ In case we need to get back to the scheduler,
  cond_resched_tasks_rcu_qs() is called after each callback.

_ In case some other softirq vector needs the CPU, the call to
  local_bh_enable() before cond_resched_tasks_rcu_qs() takes care about
  them via a call to do_softirq().

Therefore, make sure the time limit only applies to softirq mode.

Fixes: cfcdef5e30469 ("rcu: Allow rcu_do_batch() to dynamically adjust batch sizes")
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Tested-by: Valentin Schneider <valentin.schneider@arm.com>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
[UR: backport to 5.10-stable]
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 kernel/rcu/tree.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index f340df6ebd86..b41009a283ca 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2456,7 +2456,7 @@ static void rcu_do_batch(struct rcu_data *rdp)
 	div = READ_ONCE(rcu_divisor);
 	div = div < 0 ? 7 : div > sizeof(long) * 8 - 2 ? sizeof(long) * 8 - 2 : div;
 	bl = max(rdp->blimit, pending >> div);
-	if (unlikely(bl > 100)) {
+	if (in_serving_softirq() && unlikely(bl > 100)) {
 		long rrn = READ_ONCE(rcu_resched_ns);
 
 		rrn = rrn < NSEC_PER_MSEC ? NSEC_PER_MSEC : rrn > NSEC_PER_SEC ? NSEC_PER_SEC : rrn;
@@ -2494,6 +2494,18 @@ static void rcu_do_batch(struct rcu_data *rdp)
 			if (-rcl.len >= bl && (need_resched() ||
 					(!is_idle_task(current) && !rcu_is_callbacks_kthread())))
 				break;
+
+			/*
+			 * Make sure we don't spend too much time here and deprive other
+			 * softirq vectors of CPU cycles.
+			 */
+			if (unlikely(tlimit)) {
+				/* only call local_clock() every 32 callbacks */
+				if (likely((-rcl.len & 31) || local_clock() < tlimit))
+					continue;
+				/* Exceeded the time limit, so leave. */
+				break;
+			}
 		} else {
 			local_bh_enable();
 			lockdep_assert_irqs_enabled();
@@ -2501,18 +2513,6 @@ static void rcu_do_batch(struct rcu_data *rdp)
 			lockdep_assert_irqs_enabled();
 			local_bh_disable();
 		}
-
-		/*
-		 * Make sure we don't spend too much time here and deprive other
-		 * softirq vectors of CPU cycles.
-		 */
-		if (unlikely(tlimit)) {
-			/* only call local_clock() every 32 callbacks */
-			if (likely((-rcl.len & 31) || local_clock() < tlimit))
-				continue;
-			/* Exceeded the time limit, so leave. */
-			break;
-		}
 	}
 
 	local_irq_save(flags);
-- 
2.30.2

