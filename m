Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61F8B15556D
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 11:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgBGKQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 05:16:30 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35963 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726954AbgBGKQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 05:16:29 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4671120067;
        Fri,  7 Feb 2020 05:16:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 07 Feb 2020 05:16:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=s3/xF9
        ujMX6dVnZCNsoKDTbKl9TEJ7pf7NX682ck6I4=; b=HITqWS2KG2F76ectn+8Ae7
        M7Jx7zWlbSR0efZPwQfvBFKReeV4N4RIlK0n6NclIj3mDd34A8IiYM0Wq3DqgVoq
        /N4OJMAqLf/lfMHk57o1+BK4w3BUY35FQLXbi08bKbkM4/nXu94lHT1a/Ktt1SEJ
        Hj/HLOyQDqnnifMwbtCpprBk3oBYAHFGUGSLiNAN7pQBmMgow9RHJhSWuFbf/xA9
        8RGcaSJx4U76b2q6xmSf9g64WcAceGB2OYbS8chgXRmUh3RCykI8B0uMSEZzvc6d
        omE98yS2m6SiJGxHKD2MrSljcK2u/TZT9qcZ4XRFpkIymInAIdDqwNzDtJkYyiIg
        ==
X-ME-Sender: <xms:_Tg9XlqxIMSBVY05AeAokNd9hy1QOmgjVkBZsgNFGStd3f17HULTIQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheehgddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:_Tg9XjFxg2sR0STZ8rpYOdg1cjq5MTyTz4YW-1w2n4mx5DnGFoKhYA>
    <xmx:_Tg9Xg5exgWcaK9wjzBk-uqhYrV5C1ymWgzR-D0xoIlvzSwRZYr7zQ>
    <xmx:_Tg9XuDOgN9-MXDlPkGvIgkEVLeXNthOk9hfI6c2zAnXMIW0RqZyfg>
    <xmx:_Tg9Xmwwj9qSYSmI2S_HyOvHC4ldg4pakm2rsXn90ebWGssLJLzDjA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DB680328005A;
        Fri,  7 Feb 2020 05:16:28 -0500 (EST)
Subject: FAILED: patch "[PATCH] ftrace: Protect ftrace_graph_hash with ftrace_sync" failed to apply to 4.19-stable tree
To:     rostedt@goodmis.org, joel@joelfernandes.org, paulmck@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Feb 2020 11:16:17 +0100
Message-ID: <15810705775143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 54a16ff6f2e50775145b210bcd94d62c3c2af117 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Wed, 5 Feb 2020 09:20:32 -0500
Subject: [PATCH] ftrace: Protect ftrace_graph_hash with ftrace_sync

As function_graph tracer can run when RCU is not "watching", it can not be
protected by synchronize_rcu() it requires running a task on each CPU before
it can be freed. Calling schedule_on_each_cpu(ftrace_sync) needs to be used.

Link: https://lore.kernel.org/r/20200205131110.GT2935@paulmck-ThinkPad-P72

Cc: stable@vger.kernel.org
Fixes: b9b0c831bed26 ("ftrace: Convert graph filter to use hash tables")
Reported-by: "Paul E. McKenney" <paulmck@kernel.org>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 481ede3eac13..3f7ee102868a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5867,8 +5867,15 @@ ftrace_graph_release(struct inode *inode, struct file *file)
 
 		mutex_unlock(&graph_lock);
 
-		/* Wait till all users are no longer using the old hash */
-		synchronize_rcu();
+		/*
+		 * We need to do a hard force of sched synchronization.
+		 * This is because we use preempt_disable() to do RCU, but
+		 * the function tracers can be called where RCU is not watching
+		 * (like before user_exit()). We can not rely on the RCU
+		 * infrastructure to do the synchronization, thus we must do it
+		 * ourselves.
+		 */
+		schedule_on_each_cpu(ftrace_sync);
 
 		free_ftrace_hash(old_hash);
 	}
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8c52f5de9384..3c75d29bd861 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -979,6 +979,7 @@ static inline int ftrace_graph_addr(struct ftrace_graph_ent *trace)
 	 * Have to open code "rcu_dereference_sched()" because the
 	 * function graph tracer can be called when RCU is not
 	 * "watching".
+	 * Protected with schedule_on_each_cpu(ftrace_sync)
 	 */
 	hash = rcu_dereference_protected(ftrace_graph_hash, !preemptible());
 
@@ -1031,6 +1032,7 @@ static inline int ftrace_graph_notrace_addr(unsigned long addr)
 	 * Have to open code "rcu_dereference_sched()" because the
 	 * function graph tracer can be called when RCU is not
 	 * "watching".
+	 * Protected with schedule_on_each_cpu(ftrace_sync)
 	 */
 	notrace_hash = rcu_dereference_protected(ftrace_graph_notrace_hash,
 						 !preemptible());

