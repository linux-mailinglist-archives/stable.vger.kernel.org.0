Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2F5327D49
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbhCALbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:31:16 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:47457 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233707AbhCALbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:31:08 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id B72101941486;
        Mon,  1 Mar 2021 06:29:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 06:29:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fG+la+
        ZrDc2UsHsTDk5vB85J0SmnHveipzqTYV4ONiw=; b=Xg1WfnxnMMxyph30myDY15
        9pL3YLCh+Sibys6JI0a2+vuaWk0gdwsq2MAza13LXQiFJN2qJXPNgfZzrKmcGNDL
        YbOFK2zdThiCHiHV2BHBCjVX6yMWoU5KyRnBnJZ6b1kFdN9zS5COI77/8BGkg5xA
        YQ5XFm6MzEfyOQY429nJiuyn1tl96Q/JPwZVq3Owp2vcoTjhSVkYe47rGE8MLXsC
        33uI3hsrGqf7et2CxoS04XK5vLl50Y3LkkmfuYSGQJfcYCNZyklWUCGbvl4YnNjm
        4imtHB08E6RTzp6C4Th92kaviM87VqPms4kiAxCe77qdboWEShqwqQN2rFTRKgHg
        ==
X-ME-Sender: <xms:ItA8YKjuCT0Ye2eVu4K-mRNIhcetfx3C3ddkdshXoZrHZofQAOptQQ>
    <xme:ItA8YLCpe-T7LegTWlnhqXMW_R7GQxTfUu-1pMVVYOQrg8Pssc82jd2qJ5hD6oLTb
    k4L9Oh-tNQ1Fw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepuddunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ItA8YCG4u2iYhM4pD1qtklQ-JIMT5Et2P38qgXDEy8qzvdxTC4jjpQ>
    <xmx:ItA8YDR4quB85dy9G-MOGdh4coT7GRebR-sEB3nYpgzrfLg2znJYDg>
    <xmx:ItA8YHyqx_S5adZkZ_CL65pR4It4ZTCyCDyaKeULcRYuVmcpB_sMug>
    <xmx:ItA8YArWfJ0lqfUexQyN9n2g4iJkoQLs4aB9d7WJVq-2yzusynm9mg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 47CEC1080057;
        Mon,  1 Mar 2021 06:29:38 -0500 (EST)
Subject: FAILED: patch "[PATCH] entry: Explicitly flush pending rcuog wakeup before last" failed to apply to 4.19-stable tree
To:     frederic@kernel.org, mingo@kernel.org, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 12:29:33 +0100
Message-ID: <1614598173233102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

