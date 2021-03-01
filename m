Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14967327D32
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbhCAL2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:28:44 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:56727 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232252AbhCAL2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:28:43 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5638919413B9;
        Mon,  1 Mar 2021 06:27:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 06:27:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=MmOE1n
        Y539CzLSaDrppAYSQWeEFZa5DrlK0c+87qfT0=; b=wXa7L4aMQZTrPwy8L0fCsk
        60zRH29Xb7+mpB2K2ZqUcrJcojf/pFnnrvzH5oFpv9YJvdqVIuPwEWt+wnOMaqqf
        7bJqGILV+YC6V53Dv9UepYLeDFZ/aDYfayGRt/jdsZeALPXvsiyPjuM+4E3qFTXq
        5vepI832PZ/8IF7fs0DE4+DIoG6MAO9SEyL/yFXUJPtQlRK6HvOG0lB6NsPM0ciJ
        WY5pf2dplEaylvLRtvLpWh3MtMmeTlQpJKbXIv1QHPAUg/lAuoAfkKhvqdYEXNsL
        Ddyww+3yU5OypG07O6hPgiTn8YRpJNZNpu1LGYz2a+xn7El76Xqu25HqsrB4IrIA
        ==
X-ME-Sender: <xms:vM88YCVZdU7gJcB5cHxJ6Jb5wppfVYrpjL9_JQ64sAOXKFL4wkMF6A>
    <xme:vM88YFeui4QA7n5NQ-_YeCEeBm9vQg_Epv4Py4OMjWLD6nGlw9IRmXx2J2N3EIInQ
    eulFqGfTFAH5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:vM88YDXm4CLIjvqriJDrqbGpFFlveBvvNFUAD3OB0EoZ-CDHmrAX5A>
    <xmx:vM88YGesRIWDeulun_z5h6XCwTXkSk9I2enougGV7NIZaQqhz9URiQ>
    <xmx:vM88YHOyRBX5DNe8UrI0k8iX_GCtuuS_X5lVfaHJf9WJMiabdJsOow>
    <xmx:vM88YFNi0JpE4cXv80QZHj2axR8CBKHGUu4Yw15oXpHKwIHY_glDlQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 187EB24005A;
        Mon,  1 Mar 2021 06:27:56 -0500 (EST)
Subject: FAILED: patch "[PATCH] rcu/nocb: Perform deferred wake up before last idle's" failed to apply to 4.14-stable tree
To:     frederic@kernel.org, mingo@kernel.org, paulmck@kernel.org,
        peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 12:27:51 +0100
Message-ID: <1614598071131184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

