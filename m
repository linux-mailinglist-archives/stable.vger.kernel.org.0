Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC19327D45
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbhCALar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:30:47 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:38579 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232846AbhCALal (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:30:41 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id D6B2A1941470;
        Mon,  1 Mar 2021 06:29:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 06:29:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+CowkP
        8Dc1m0L4xxxAkbgeq64LsZ71UzjKm+DAten3M=; b=eZwCYBL1P3VVQ/dLp812Fs
        xImUQMTY96d+DzNA9yT+vlfWpeLv6SbV2CUoDcuMj5z1cTKoxOuTb7sX7zzwnLnt
        nLOTmre/2/qh5EW2lXsIl2IcOz/qP19IoBZu+JwPyDtmUhe2JNZo/MzHwy/JrKwv
        R1c8PwEK2d+nYbV3vmmaXOx8Y5b7jS+OB0yX9GqoVa6spdU2ZRD86KHQq5Hr6Mt9
        JS+PoRpBFNeVrPAipgPgKsTo5JuZI/yzPzJxlk5DmT3eLcYHIF31d0kzLtlpRntB
        uCmdT3VS0qMrDWV32aGsCCbC0zBhpAzOZEA09U5X5zKNYqJVJ/O9dVugZLWw8BKQ
        ==
X-ME-Sender: <xms:INA8YF-6k0Mm9ZZCjP3TSd_8wugvMebOfLhiSYuxSUArLEzYPVS4Mg>
    <xme:INA8YJvQ4fhkIT7H1qgHP9N-PDPs44A6eVaQqSCeC3aAKKtXdgjCE_9w8doTXsA9M
    QZMJtgfnbyKUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepuddunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:INA8YDBs1YkjT1D998FqYNT1kXCLk-LtKK3PXh0fL2vdPf_XFZ6JoQ>
    <xmx:INA8YJecNRCvqlMPjhBvaBI2od6DijecOofKY0-JhEahMeOyzXVcdw>
    <xmx:INA8YKMa-5olBWETA6y1rSIs6eGJwrqJwi0IXM1ABoe4OBCF_lvQ7Q>
    <xmx:INA8YM0DVekm4pATljpA-BmtIvS3Sl83wjGPtbzFZ_3K1AXx-2yTWQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6C83A1080057;
        Mon,  1 Mar 2021 06:29:36 -0500 (EST)
Subject: FAILED: patch "[PATCH] entry: Explicitly flush pending rcuog wakeup before last" failed to apply to 4.9-stable tree
To:     frederic@kernel.org, mingo@kernel.org, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 12:29:32 +0100
Message-ID: <161459817210158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 47b8ff194c1fd73d58dc339b597d466fe48c8958 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <frederic@kernel.org>
Date: Mon, 1 Feb 2021 00:05:47 +0100
Subject: [PATCH] entry: Explicitly flush pending rcuog wakeup before last
 rescheduling point

Following the idle loop model, cleanly check for pending rcuog wakeup
before the last rescheduling point on resuming to user mode. This
way we can avoid to do it from rcu_user_enter() with the last resort
self-IPI hack that enforces rescheduling.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210131230548.32970-5-frederic@kernel.org

diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index f09cae37ddd5..8442e5c9cfa2 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -184,6 +184,10 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 		 * enabled above.
 		 */
 		local_irq_disable_exit_to_user();
+
+		/* Check if any of the above work has queued a deferred wakeup */
+		rcu_nocb_flush_deferred_wakeup();
+
 		ti_work = READ_ONCE(current_thread_info()->flags);
 	}
 
@@ -197,6 +201,9 @@ static void exit_to_user_mode_prepare(struct pt_regs *regs)
 
 	lockdep_assert_irqs_disabled();
 
+	/* Flush pending rcuog wakeup before the last need_resched() check */
+	rcu_nocb_flush_deferred_wakeup();
+
 	if (unlikely(ti_work & EXIT_TO_USER_MODE_WORK))
 		ti_work = exit_to_user_mode_loop(regs, ti_work);
 
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 4b1e5bd16492..2ebc211fffcb 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -707,13 +707,15 @@ noinstr void rcu_user_enter(void)
 	lockdep_assert_irqs_disabled();
 
 	/*
-	 * We may be past the last rescheduling opportunity in the entry code.
-	 * Trigger a self IPI that will fire and reschedule once we resume to
-	 * user/guest mode.
+	 * Other than generic entry implementation, we may be past the last
+	 * rescheduling opportunity in the entry code. Trigger a self IPI
+	 * that will fire and reschedule once we resume in user/guest mode.
 	 */
 	instrumentation_begin();
-	if (do_nocb_deferred_wakeup(rdp) && need_resched())
-		irq_work_queue(this_cpu_ptr(&late_wakeup_work));
+	if (!IS_ENABLED(CONFIG_GENERIC_ENTRY) || (current->flags & PF_VCPU)) {
+		if (do_nocb_deferred_wakeup(rdp) && need_resched())
+			irq_work_queue(this_cpu_ptr(&late_wakeup_work));
+	}
 	instrumentation_end();
 
 	rcu_eqs_enter(true);

