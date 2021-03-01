Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC06327D36
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbhCAL3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:29:05 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:49651 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233055AbhCAL3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:29:04 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id D521119413E2;
        Mon,  1 Mar 2021 06:27:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 06:27:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=k8xE1t
        xsQPeLzqedUYgcaMY40ee5PqYwlCE99Q8IJok=; b=Btl6mGGV1ziaf89R06o03J
        GStr0tuWCoJ7NTbhrIEwnc5Hyb9TuBeHwnG8oovio1i1eDZ6ntpmz9ofLgEP/Ge5
        v7wlm1XIO75/rVsb6KCegC+11S2ijOsgagLLArZdQ7c+FZoeVpLZb0/Z22HJrMLB
        Rs+PN2U6h13Lj9oGw9y/RmMpbvIW+GhaG9zenGGLXMP3L2+siqUM20tQQpbbRxYV
        EbQqOOBVfwqIyS2YeiTSCdfw4jWU5u72ACKrUI3adDb1cjqP5c8eMrFvDZCSFxyK
        DOMSVoh+jcc3X/FcZ5T3UKy2Tx980KLmyD4RpaIASkhAJr2hluvJUFJ0EF3H2vxQ
        ==
X-ME-Sender: <xms:vc88YF8glMOu14JGU-2XACtlb46Lka6ZXueR2GUe7nn2tjwW_EilUg>
    <xme:vc88YNj2b9w2Y4UHpYbrxO4TEkd7BDw77p7UkenfqjCpYSf5Ifv5bR8PhrRuIWTr2
    WAHe4LKnYJh0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:vc88YMGJ36Sp4NjxaC4YqWKVuX7lRqAEbobTRYz8VmKhT1krFYbbZg>
    <xmx:vc88YM9ot9jYtCX_juwnN9XPHpt2G5uOYgC3hEn9nfjSOLsMSXjVSw>
    <xmx:vc88YDyVfr0-1Svt7_IjACt54ytlwYEnwuwQvTItoFefD9F2HbqdiQ>
    <xmx:vc88YOCUlwkVeb8vLf4wrVP-HSXUFjnzfpoUVmswRMiiU1nfDYn63w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 98B3224005D;
        Mon,  1 Mar 2021 06:27:57 -0500 (EST)
Subject: FAILED: patch "[PATCH] rcu/nocb: Perform deferred wake up before last idle's" failed to apply to 4.19-stable tree
To:     frederic@kernel.org, mingo@kernel.org, paulmck@kernel.org,
        peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 12:27:52 +0100
Message-ID: <161459807256115@kroah.com>
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

From 43789ef3f7d61aa7bed0cb2764e588fc990c30ef Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <frederic@kernel.org>
Date: Mon, 1 Feb 2021 00:05:45 +0100
Subject: [PATCH] rcu/nocb: Perform deferred wake up before last idle's
 need_resched() check

Entering RCU idle mode may cause a deferred wake up of an RCU NOCB_GP
kthread (rcuog) to be serviced.

Usually a local wake up happening while running the idle task is handled
in one of the need_resched() checks carefully placed within the idle
loop that can break to the scheduler.

Unfortunately the call to rcu_idle_enter() is already beyond the last
generic need_resched() check and we may halt the CPU with a resched
request unhandled, leaving the task hanging.

Fix this with splitting the rcuog wakeup handling from rcu_idle_enter()
and place it before the last generic need_resched() check in the idle
loop. It is then assumed that no call to call_rcu() will be performed
after that in the idle loop until the CPU is put in low power mode.

Fixes: 96d3fd0d315a (rcu: Break call_rcu() deadlock involving scheduler and perf)
Reported-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210131230548.32970-3-frederic@kernel.org

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index fd02c5fa60cb..36c2119de702 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -110,8 +110,10 @@ static inline void rcu_user_exit(void) { }
 
 #ifdef CONFIG_RCU_NOCB_CPU
 void rcu_init_nohz(void);
+void rcu_nocb_flush_deferred_wakeup(void);
 #else /* #ifdef CONFIG_RCU_NOCB_CPU */
 static inline void rcu_init_nohz(void) { }
+static inline void rcu_nocb_flush_deferred_wakeup(void) { }
 #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
 
 /**
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 63032e5620b9..82838e93b498 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -671,10 +671,7 @@ static noinstr void rcu_eqs_enter(bool user)
  */
 void rcu_idle_enter(void)
 {
-	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
-
 	lockdep_assert_irqs_disabled();
-	do_nocb_deferred_wakeup(rdp);
 	rcu_eqs_enter(false);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 7e291ce0a1d6..d5b38c28abd1 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2187,6 +2187,11 @@ static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
 		do_nocb_deferred_wakeup_common(rdp);
 }
 
+void rcu_nocb_flush_deferred_wakeup(void)
+{
+	do_nocb_deferred_wakeup(this_cpu_ptr(&rcu_data));
+}
+
 void __init rcu_init_nohz(void)
 {
 	int cpu;
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 305727ea0677..7199e6f23789 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -285,6 +285,7 @@ static void do_idle(void)
 		}
 
 		arch_cpu_idle_enter();
+		rcu_nocb_flush_deferred_wakeup();
 
 		/*
 		 * In poll mode we reenable interrupts and spin. Also if we

