Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8EA6518D10
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 21:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238600AbiECTU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 15:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238334AbiECTU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 15:20:56 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9413FBC2;
        Tue,  3 May 2022 12:17:22 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id w19so31897394lfu.11;
        Tue, 03 May 2022 12:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ollE0YgBSeKK0M+GXPq6R93NOGmAH64AhXP+NS3GzJ0=;
        b=Qitz8Gpgf1PtS2bmSjFpfXIlePrNy4VjTQjR1UlxFmaw1+cMzxYaNhHA4slSQdVAjm
         kK+o0tUUc2iHv2LlMfMbJkCbLLzb+VsE3odU/IchDUwcDKruLSIdZ8JxAe+HVISA5sCW
         JH7ilDRDufw79FgB/L0cc+kwIgEILmVArYLbpUAv/DJeGOtMmDP0lXV5UJDbr2lr3AdM
         tSQ1h+atUBwdeYjHxtHlz17Bs5zwpo0G7QFDoZ9lCaIlANFfVSqVBSzipuztlPagQA2t
         HF8vyJq5nR3wubXgkTuEnBZBmNT3YFKjasOw3tbnyTNRppEfQp9Gd3moexSxYOIPH5JB
         T+rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ollE0YgBSeKK0M+GXPq6R93NOGmAH64AhXP+NS3GzJ0=;
        b=KUAQdqnnhqYjP1XloE+P17hgJQKbRGedOh38zhBtSgAJKq8NpIpCnK1TVz1ZKSUpkK
         9zlWvc1gIvYxoguPJPIBELlwzNA6OREFx8YWnPXM79xIt0iCd/Won7+jmwcpX7BNbL/a
         zTV1FB8IpQ+4QuRIsz1skoxCA4UQKJ+vxt4XuAWTYIAOT7sBQ4K8GRzKWpxHN+5KJLff
         eVJuxLBB0Nt4bjDfr+H9EfOEutD2rhxV3+cot9CrDDAon3rV/HpAyXTSQUuSlBAyzoCu
         S+pYlDtSVQMP9wHi2jlGTMh2rZYTA6q9RqH5WvbEWq+GmOwBhUy7b0yX9seT8r+OEksT
         uYpQ==
X-Gm-Message-State: AOAM532Vds12p3IL+eEZ1pInztukTtnyIJsIU3l5XHlctcBpl78CnK16
        gjOYgsBOm1vX7Q0hDrxgckOGw01qqcqwmQ==
X-Google-Smtp-Source: ABdhPJyoe7B6TaFgTxEyRQCUGDy5hVAmmySR3C3GyimM8qdvkYYL8AiAnuGL6sTpXvJMj/CnYnck4A==
X-Received: by 2002:ac2:4c46:0:b0:472:23f6:a3d8 with SMTP id o6-20020ac24c46000000b0047223f6a3d8mr12095298lfk.203.1651605440905;
        Tue, 03 May 2022 12:17:20 -0700 (PDT)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id f13-20020ac2532d000000b0047255d211bfsm1014094lfh.238.2022.05.03.12.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 12:17:20 -0700 (PDT)
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
Subject: [PATCH 1/2] rcu: [for 5.15 stable] Fix callbacks processing time limit retaining cond_resched()
Date:   Tue,  3 May 2022 21:17:08 +0200
Message-Id: <20220503191709.155266-2-urezki@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220503191709.155266-1-urezki@gmail.com>
References: <20220503191709.155266-1-urezki@gmail.com>
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

commit 3e61e95e2d095e308616cba4ffb640f95a480e01 upstream.

The callbacks processing time limit makes sure we are not exceeding a
given amount of time executing the queue.

However its "continue" clause bypasses the cond_resched() call on
rcuc and NOCB kthreads, delaying it until we reach the limit, which can
be very long...

Make sure the scheduler has a higher priority than the time limit.

Motivation of backport:
-----------------------

1. The cfcdef5e30469 ("rcu: Allow rcu_do_batch() to dynamically adjust batch sizes")
broke the default behaviour of "offloading rcu callbacks" setup. In that scenario
after each callback the caller context was used to check if it has to be rescheduled
giving a CPU time for others. After that change an "offloaded" setup can switch to
time-based RCU callbacks processing, what can be long for latency sensitive workloads
and SCHED_FIFO processes, i.e. callbacks are invoked for a long time with keeping
preemption off and without checking cond_resched().

2. Our devices which run Android and 5.10 kernel have some critical areas which
are sensitive to latency. It is a low latency audio, 8k video, UI stack and so on.
For example below is a trace that illustrates a delay of "irq/396-5-0072" RT task
to complete IRQ processing:

<snip>
 rcuop/6-54  [000] d.h2  183.752989: irq_handler_entry:    irq=85 name=i2c_geni
 rcuop/6-54  [000] d.h5  183.753007: sched_waking:         comm=irq/396-5-0072 pid=12675 prio=49 target_cpu=000
 rcuop/6-54  [000] dNh6  183.753014: sched_wakeup:         irq/396-5-0072:12675 [49] success=1 CPU:000
 rcuop/6-54  [000] dNh2  183.753015: irq_handler_exit:     irq=85 ret=handled
 rcuop/6-54  [000] .N..  183.753018: rcu_invoke_callback:  rcu_preempt rhp=0xffffff88ffd440b0 func=__d_free.cfi_jt
 rcuop/6-54  [000] .N..  183.753020: rcu_invoke_callback:  rcu_preempt rhp=0xffffff892ffd8400 func=inode_free_by_rcu.cfi_jt
 rcuop/6-54  [000] .N..  183.753021: rcu_invoke_callback:  rcu_preempt rhp=0xffffff89327cd708 func=i_callback.cfi_jt
 ...
 rcuop/6-54  [000] .N..  183.755941: rcu_invoke_callback:  rcu_preempt rhp=0xffffff8993c5a968 func=i_callback.cfi_jt
 rcuop/6-54  [000] .N..  183.755942: rcu_invoke_callback:  rcu_preempt rhp=0xffffff8993c4bd20 func=__d_free.cfi_jt
 rcuop/6-54  [000] dN..  183.755944: rcu_batch_end:        rcu_preempt CBs-invoked=2112 idle=>c<>c<>c<>c<
 rcuop/6-54  [000] dN..  183.755946: rcu_utilization:      Start context switch
 rcuop/6-54  [000] dN..  183.755946: rcu_utilization:      End context switch
 rcuop/6-54  [000] d..2  183.755959: sched_switch:         rcuop/6:54 [120] R ==> migration/0:16 [0]
 ...
 migratio-16 [000] d..2  183.756021: sched_switch:         migration/0:16 [0] S ==> irq/396-5-0072:12675 [49]
<snip>

The "irq/396-5-0072:12675" was delayed for ~3 milliseconds due to introduced side effect.
Please note, on our Android devices we get ~70 000 callbacks registered to be invoked by
the "rcuop/x" workers. This is during 1 seconds time interval and regular handset usage.
Latencies bigger that 3 milliseconds affect our high-resolution audio streaming over the
LDAC/Bluetooth stack.

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
[UR: backport to 5.15-stable + commit update]
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 kernel/rcu/tree.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 4ca6d5b199e8..a968cc67b2bd 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2513,10 +2513,22 @@ static void rcu_do_batch(struct rcu_data *rdp)
 		/*
 		 * Stop only if limit reached and CPU has something to do.
 		 */
-		if (count >= bl && !offloaded &&
-		    (need_resched() ||
-		     (!is_idle_task(current) && !rcu_is_callbacks_kthread())))
-			break;
+		if (in_serving_softirq()) {
+			if (count >= bl && (need_resched() ||
+					(!is_idle_task(current) && !rcu_is_callbacks_kthread())))
+				break;
+		} else {
+			local_bh_enable();
+			lockdep_assert_irqs_enabled();
+			cond_resched_tasks_rcu_qs();
+			lockdep_assert_irqs_enabled();
+			local_bh_disable();
+		}
+
+		/*
+		 * Make sure we don't spend too much time here and deprive other
+		 * softirq vectors of CPU cycles.
+		 */
 		if (unlikely(tlimit)) {
 			/* only call local_clock() every 32 callbacks */
 			if (likely((count & 31) || local_clock() < tlimit))
@@ -2524,13 +2536,6 @@ static void rcu_do_batch(struct rcu_data *rdp)
 			/* Exceeded the time limit, so leave. */
 			break;
 		}
-		if (!in_serving_softirq()) {
-			local_bh_enable();
-			lockdep_assert_irqs_enabled();
-			cond_resched_tasks_rcu_qs();
-			lockdep_assert_irqs_enabled();
-			local_bh_disable();
-		}
 	}
 
 	local_irq_save(flags);
-- 
2.30.2

