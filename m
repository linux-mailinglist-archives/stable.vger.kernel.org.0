Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EC8312EB1
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhBHKP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:15:28 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:50963 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232128AbhBHKNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:13:10 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 1BCB89F0;
        Mon,  8 Feb 2021 05:12:23 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 05:12:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/MYzAd
        yTPKqpvoD+L3UBvxhQYB1QJj5ZZW/mwzvnPnw=; b=XTrddH+7SOovB+r/5NBv/p
        dKf5TSnTFcpdLAG2sRBWNNeN4icGADv61+3wR/CrWAveXdaLb2G2GitHwOts5WE1
        NaIRXQYEuM+H7jlWJJH/2Bz0MBRwDhlmermLnLMoIW2dCF3XrPhibwf4e/3kUdUM
        ecF4vY0sfp26/ZbKC7hear5V4Qo0s607ymhvfU7HHGqHoC/HjovK8Jx7iCJvfoDk
        iZQfkirnDohoIwvWaXcC728jcl13Qqfvy09PF2VHXC3ZIDgeE4G9JTJoap9PeBXs
        oO+UZWfqB9+u625KtPA39a2gGrEgg9xfjcK+DEfNmduz8KxpZjtVEy1S+2v9ox1w
        ==
X-ME-Sender: <xms:hg4hYNLbH8dZHtogLXcWc8Aelaa2LqqJqfgoV9lH9m1vPx6WP3AWIg>
    <xme:hg4hYJJgnXGmGW2F8YOL8LpPnnEq9tRzrl1AQfuTqF4JEZUyZvVuLuPQNLB7iirYl
    eFYG_A08ivBYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:hg4hYFuivV6eypavdMorWwzBfcHLh02PPffPYRUOEE5K7G-pDSVubw>
    <xmx:hg4hYOZOY5FlwzE7G04sgykgtFwco_QY-P6q7m9gssKX9tlbKewG0A>
    <xmx:hg4hYEYAd4yLuIxF4EXkgSS_-mOzDrqRYK_rub4QBTxMpe2QY_pB2w>
    <xmx:hg4hYK1TIncNkShPbyq12puC1VOq1wi5cOWDOq67-0pCGxkAAYpdOZOSpvU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5B19C24005C;
        Mon,  8 Feb 2021 05:12:22 -0500 (EST)
Subject: FAILED: patch "[PATCH] fgraph: Initialize tracing_graph_pause at task creation" failed to apply to 4.19-stable tree
To:     rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:12:15 +0100
Message-ID: <1612779135196131@kroah.com>
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

From 7e0a9220467dbcfdc5bc62825724f3e52e50ab31 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Fri, 29 Jan 2021 10:13:53 -0500
Subject: [PATCH] fgraph: Initialize tracing_graph_pause at task creation

On some archs, the idle task can call into cpu_suspend(). The cpu_suspend()
will disable or pause function graph tracing, as there's some paths in
bringing down the CPU that can have issues with its return address being
modified. The task_struct structure has a "tracing_graph_pause" atomic
counter, that when set to something other than zero, the function graph
tracer will not modify the return address.

The problem is that the tracing_graph_pause counter is initialized when the
function graph tracer is enabled. This can corrupt the counter for the idle
task if it is suspended in these architectures.

   CPU 1				CPU 2
   -----				-----
  do_idle()
    cpu_suspend()
      pause_graph_tracing()
          task_struct->tracing_graph_pause++ (0 -> 1)

				start_graph_tracing()
				  for_each_online_cpu(cpu) {
				    ftrace_graph_init_idle_task(cpu)
				      task-struct->tracing_graph_pause = 0 (1 -> 0)

      unpause_graph_tracing()
          task_struct->tracing_graph_pause-- (0 -> -1)

The above should have gone from 1 to zero, and enabled function graph
tracing again. But instead, it is set to -1, which keeps it disabled.

There's no reason that the field tracing_graph_pause on the task_struct can
not be initialized at boot up.

Cc: stable@vger.kernel.org
Fixes: 380c4b1411ccd ("tracing/function-graph-tracer: append the tracing_graph_flag")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=211339
Reported-by: pierre.gondois@arm.com
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/init/init_task.c b/init/init_task.c
index 8a992d73e6fb..3711cdaafed2 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -198,7 +198,8 @@ struct task_struct init_task
 	.lockdep_recursion = 0,
 #endif
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	.ret_stack	= NULL,
+	.ret_stack		= NULL,
+	.tracing_graph_pause	= ATOMIC_INIT(0),
 #endif
 #if defined(CONFIG_TRACING) && defined(CONFIG_PREEMPTION)
 	.trace_recursion = 0,
diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
index 73edb9e4f354..29a6ebeebc9e 100644
--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -394,7 +394,6 @@ static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
 		}
 
 		if (t->ret_stack == NULL) {
-			atomic_set(&t->tracing_graph_pause, 0);
 			atomic_set(&t->trace_overrun, 0);
 			t->curr_ret_stack = -1;
 			t->curr_ret_depth = -1;
@@ -489,7 +488,6 @@ static DEFINE_PER_CPU(struct ftrace_ret_stack *, idle_ret_stack);
 static void
 graph_init_task(struct task_struct *t, struct ftrace_ret_stack *ret_stack)
 {
-	atomic_set(&t->tracing_graph_pause, 0);
 	atomic_set(&t->trace_overrun, 0);
 	t->ftrace_timestamp = 0;
 	/* make curr_ret_stack visible before we add the ret_stack */

