Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1888B327D4C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhCALbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:31:22 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:54323 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232710AbhCALbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:31:20 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2FD6E19414D4;
        Mon,  1 Mar 2021 06:30:06 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 06:30:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=H7Z42t
        R/FocGUvC5c3AP7PHG2LrTJWsIROlfT/bLPO8=; b=o3Dckx7WtAz31nH2oX/Bhy
        J03fOdUN85jIGl1ufdW+BfAnRVbcs0fGf98gHx5hV53ocnGtrpuL9c5/YQwp26xN
        1awvN0ZbJaQpTukBS4UtCdLO3QQTWUbBCp5oFXgms5GiuHoyIH0evYnE72Cqr9t2
        nF4/lTQwCUl3CN3A1dX9w1CndfZHyCk/N2rJw76tYJZil5yEMwJTR4AXKdlHYYMG
        tu65rHEzmaCEAsih2cp1CugXTVKNlOULWrMqHfGfg5oNsZqY00uFNCecK0O4ATfc
        EYkH9RBQXdJQsVhm6mS6bZiuInTpG2aawyErrFgn8N9O/QL9wwZ/oPl49njKNPnQ
        ==
X-ME-Sender: <xms:PtA8YCX9ma8cq6Uj8bw3rGX8wN8Nas9zuA1Nti1VLdKcXRkwtc_j-w>
    <xme:PtA8YOkiEtocAXJm4amrDhgF8VZe2G4qiNhkLlGmprXqt34TDPhuRhsYcWfz4R8Ue
    foSgp85Fb-mxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudeinecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:PtA8YGaLQlkuMsaDC4ZLw1f-ftRMHoLxJ6cUtd3KQi6IhujIJQijkQ>
    <xmx:PtA8YJVqfgW_MadR9a3q5yXSn3MOkVxDZlet9dPHUeV4ZcelRa2vBg>
    <xmx:PtA8YMkDNZ79IoqjLCOQ_cAMmIC842kzLtY8YI5qAExIPFjgKqdUSQ>
    <xmx:PtA8YItTXkfuG-1fy4pyJ3jOsZlFQUCvlxsCHJqBcZCP3pZwebalmw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1E7921080064;
        Mon,  1 Mar 2021 06:30:04 -0500 (EST)
Subject: FAILED: patch "[PATCH] entry/kvm: Explicitly flush pending rcuog wakeup before last" failed to apply to 4.9-stable tree
To:     frederic@kernel.org, mingo@kernel.org, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 12:30:00 +0100
Message-ID: <16145982005117@kroah.com>
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

From 4ae7dc97f726ea95c58ac58af71cc034ad22d7de Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <frederic@kernel.org>
Date: Mon, 1 Feb 2021 00:05:48 +0100
Subject: [PATCH] entry/kvm: Explicitly flush pending rcuog wakeup before last
 rescheduling point

Following the idle loop model, cleanly check for pending rcuog wakeup
before the last rescheduling point upon resuming to guest mode. This
way we can avoid to do it from rcu_user_enter() with the last resort
self-IPI hack that enforces rescheduling.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210131230548.32970-6-frederic@kernel.org

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1b404e4d7dd8..b967c1c774a1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1782,6 +1782,7 @@ EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
 
 bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
 {
+	xfer_to_guest_mode_prepare();
 	return vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu) ||
 		xfer_to_guest_mode_work_pending();
 }
diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
index 9b93f8584ff7..8b2b1d68b954 100644
--- a/include/linux/entry-kvm.h
+++ b/include/linux/entry-kvm.h
@@ -46,6 +46,20 @@ static inline int arch_xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu,
  */
 int xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu);
 
+/**
+ * xfer_to_guest_mode_prepare - Perform last minute preparation work that
+ *				need to be handled while IRQs are disabled
+ *				upon entering to guest.
+ *
+ * Has to be invoked with interrupts disabled before the last call
+ * to xfer_to_guest_mode_work_pending().
+ */
+static inline void xfer_to_guest_mode_prepare(void)
+{
+	lockdep_assert_irqs_disabled();
+	rcu_nocb_flush_deferred_wakeup();
+}
+
 /**
  * __xfer_to_guest_mode_work_pending - Check if work is pending
  *
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 2ebc211fffcb..ce17b8477442 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -678,9 +678,10 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
 
 #ifdef CONFIG_NO_HZ_FULL
 
+#if !defined(CONFIG_GENERIC_ENTRY) || !defined(CONFIG_KVM_XFER_TO_GUEST_WORK)
 /*
  * An empty function that will trigger a reschedule on
- * IRQ tail once IRQs get re-enabled on userspace resume.
+ * IRQ tail once IRQs get re-enabled on userspace/guest resume.
  */
 static void late_wakeup_func(struct irq_work *work)
 {
@@ -689,6 +690,37 @@ static void late_wakeup_func(struct irq_work *work)
 static DEFINE_PER_CPU(struct irq_work, late_wakeup_work) =
 	IRQ_WORK_INIT(late_wakeup_func);
 
+/*
+ * If either:
+ *
+ * 1) the task is about to enter in guest mode and $ARCH doesn't support KVM generic work
+ * 2) the task is about to enter in user mode and $ARCH doesn't support generic entry.
+ *
+ * In these cases the late RCU wake ups aren't supported in the resched loops and our
+ * last resort is to fire a local irq_work that will trigger a reschedule once IRQs
+ * get re-enabled again.
+ */
+noinstr static void rcu_irq_work_resched(void)
+{
+	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
+
+	if (IS_ENABLED(CONFIG_GENERIC_ENTRY) && !(current->flags & PF_VCPU))
+		return;
+
+	if (IS_ENABLED(CONFIG_KVM_XFER_TO_GUEST_WORK) && (current->flags & PF_VCPU))
+		return;
+
+	instrumentation_begin();
+	if (do_nocb_deferred_wakeup(rdp) && need_resched()) {
+		irq_work_queue(this_cpu_ptr(&late_wakeup_work));
+	}
+	instrumentation_end();
+}
+
+#else
+static inline void rcu_irq_work_resched(void) { }
+#endif
+
 /**
  * rcu_user_enter - inform RCU that we are resuming userspace.
  *
@@ -702,8 +734,6 @@ static DEFINE_PER_CPU(struct irq_work, late_wakeup_work) =
  */
 noinstr void rcu_user_enter(void)
 {
-	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
-
 	lockdep_assert_irqs_disabled();
 
 	/*
@@ -711,13 +741,7 @@ noinstr void rcu_user_enter(void)
 	 * rescheduling opportunity in the entry code. Trigger a self IPI
 	 * that will fire and reschedule once we resume in user/guest mode.
 	 */
-	instrumentation_begin();
-	if (!IS_ENABLED(CONFIG_GENERIC_ENTRY) || (current->flags & PF_VCPU)) {
-		if (do_nocb_deferred_wakeup(rdp) && need_resched())
-			irq_work_queue(this_cpu_ptr(&late_wakeup_work));
-	}
-	instrumentation_end();
-
+	rcu_irq_work_resched();
 	rcu_eqs_enter(true);
 }
 
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 384856e4d13e..cdc1b7651c03 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2197,6 +2197,7 @@ void rcu_nocb_flush_deferred_wakeup(void)
 {
 	do_nocb_deferred_wakeup(this_cpu_ptr(&rcu_data));
 }
+EXPORT_SYMBOL_GPL(rcu_nocb_flush_deferred_wakeup);
 
 void __init rcu_init_nohz(void)
 {

