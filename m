Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2BFF518D14
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 21:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238658AbiECTWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 15:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238334AbiECTWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 15:22:30 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090253FBE1;
        Tue,  3 May 2022 12:18:57 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id q14so23211982ljc.12;
        Tue, 03 May 2022 12:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XLpkmFyOpK5Of2qpVy8Hm5z5TQyIrTyYMzHRaxdG4ZA=;
        b=b+Y4sclreDQ22DveYOaWdbKqHMx6qrIYkZQkj+fsbS6nfE7HB1ePp2HavxSBP6gPcS
         5yuckNVAxjWTN/Ww4HOH8GyvOKk8FA54mJSpHFsGM17A8AkD7kRuAPPkPNJZKeCf/zHc
         UiFaO979lOuCsNCniDwdH1Bpz8rI0Mpc8O14m/pGRa6lRz2EqIitsr5JqCLUhwXQLhg8
         Oyky3ej2Ze1EXrPObWcDScT+6J+YO1kaIdu3BVFSScWkXaSPJ9Zu/Xi/P6a0L1dGPUyq
         L2GZmrUY67YCcCLo2VCU9OYMC7mNyrpv2TMXQARJCiQqyupAV33Az4uwOXVctyV4+5xo
         9WuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XLpkmFyOpK5Of2qpVy8Hm5z5TQyIrTyYMzHRaxdG4ZA=;
        b=4yJkK102a2Ziws2WQiz9UJ/E/1s7jIqMibAV/+HCdEgbTujqm+ohoVKjAmW6W6/Vy+
         ItX3nkqmjWY7PbaC1A4b5FrXm7aYpAOiiqUAFAHtQ3MFcWoZh0YekpkvuIEkyk6tZ4Ga
         wuDlkf3i8U/47bLEPgwOFXAJCty2z6oeKpCaEaSgkTLqwOMR3x+3YIFO142OnNJ4W4o9
         IKNhmqbIBPOVpYtDfAthV/VQyuwOIC4wcUXUzhktNmFB8RuVqUUl6VpTv6R0mBHBaZlV
         8bruY+NW5A9kJ6JH6f7RXFbuQxFJl32P/GwRZRE0n8mp2V/pDtftnW/aR4SOh7g9Ebbr
         JLQg==
X-Gm-Message-State: AOAM5333HKkGcQ2ccKUrRvdpsP+YQH0UWzzpuiyaQsC+9wVDgDk+2q4x
        8EtyGXvoA2MknCBHSzoaoH32+QtpNhjwGw==
X-Google-Smtp-Source: ABdhPJyGJGbBYjekouqNrog59Kd+aatzJbQ8k3QUxxEEqOaQrQGTkIWLINxDOFqb4SbT9f71mQCzNQ==
X-Received: by 2002:a2e:9105:0:b0:24f:2558:8787 with SMTP id m5-20020a2e9105000000b0024f25588787mr10771212ljg.65.1651605535382;
        Tue, 03 May 2022 12:18:55 -0700 (PDT)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id w10-20020ac254aa000000b0047255d21194sm1013894lfk.195.2022.05.03.12.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 12:18:54 -0700 (PDT)
From:   "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To:     stable@vger.kernel.org
Cc:     RCU <rcu@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Neeraj Upadhyay <neeraj.iitr10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] rcu: [for 5.10 stable] Apply callbacks processing time limit only on softirq
Date:   Tue,  3 May 2022 21:18:43 +0200
Message-Id: <20220503191843.155363-3-urezki@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220503191843.155363-1-urezki@gmail.com>
References: <20220503191843.155363-1-urezki@gmail.com>
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

