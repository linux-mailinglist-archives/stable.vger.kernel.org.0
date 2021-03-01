Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C137327D35
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbhCAL3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:29:03 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:32829 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232199AbhCAL3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:29:01 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id C371D19413C4;
        Mon,  1 Mar 2021 06:27:54 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 06:27:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=D43yBE
        rS0EhmPpU6YFrqmpvedRordcoLc7q+efF+3lY=; b=H20gyyKWgo6XMcP0AlAeT3
        TzEi1iyqNNIQa1c8Fzk9ea++DbAIusY1PVQ8MhalYN4PZau97hbonTvYMUdsFJs5
        tRMz9kCVePUAGhA0M9ooM5kvaGaKasMYmIJDCinD0fPTg26uCZPT9Hs/NMtsHb32
        EN99ZOXFufv6UQD3myDSIZemapoP5N74o+5vMEf5Mczx2hIuOY3/ECiqKJ9QZwcb
        MSGCph0qIx3SrJ5pyKAMPHxkHo8Kkg6/hNgBDMAGzLJnHPjw8luwJICB21W7rU8F
        7CXfURbPdkL1MeGt9qO9X5DcmESFS2LLIcPbGobKzqjxz0xxnUNhKahXMlQydvtA
        ==
X-ME-Sender: <xms:us88YPuA8FNbOyXTvXjOhkB6Hp8hLV80VkdR7wbYdxzKUERIIExc_Q>
    <xme:us88YAeJoqp4JfilKhgKi1him7CDJDW3V69K9x1iGQn1sYec8ragb0nT4E9937SVW
    oQjZhVkm_payw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:us88YCz6JAqFUtLqT7U1iqEs7zCvGZXNkw_q1F58bJ-ppMbdLTZTNA>
    <xmx:us88YON49ZfEhhL_Idnk4R4Pxc6OlarWmEpCVAwMWzX3sjIdh0V-Dw>
    <xmx:us88YP8uqMUtbt63i6Qtu4-lAmWDKJa1JQ_t0T8Qt3YS4NNCUmOWBA>
    <xmx:us88YBJ9hNhzDhbsalLQOFNZb9WoT3QzC5sjq2FE19Dm51oIwcYEbw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0DB03240065;
        Mon,  1 Mar 2021 06:27:53 -0500 (EST)
Subject: FAILED: patch "[PATCH] rcu/nocb: Perform deferred wake up before last idle's" failed to apply to 4.9-stable tree
To:     frederic@kernel.org, mingo@kernel.org, paulmck@kernel.org,
        peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 12:27:50 +0100
Message-ID: <1614598070159165@kroah.com>
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

