Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8E1282A45
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 12:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgJDKyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 06:54:39 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:40839 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbgJDKyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 06:54:39 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id DFAE31941751;
        Sun,  4 Oct 2020 06:54:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 04 Oct 2020 06:54:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=nLQu2e
        5M22T4BvoU7ZSqh1lktuLbA39pbMGcoyXleTI=; b=nIRtZYVxloDORjWPuwXHWv
        aFA8dOFlxcwZSu5I6thdbvOvE1RESWzSGZA4Y0+v8LGwOaiKwUqpcb+HjRbvu4Ba
        fbD9aiQZigrCCc0xsKlam0uRZAp5yt1WYFVmIsl2U5i4WLbLF+BUUdacDMT9gNTl
        HWMN33aVE32pWNRg4aqUaQSQVoFK6nPZ+Qq15L332JZ6cu746EUbM1TdxSriP8so
        BvFB+sUlddI5Xewy39UFlSvtfT/duSXaUoRJnb+yHXoiywGnboHNSWrq0QwQmNZu
        rGU1yMAzBaZ4Dl0dT2XYtIo6pM3/Opygjr+vhIgETv7fMjKGni+gvBb/CJFaSHjw
        ==
X-ME-Sender: <xms:7al5X650LmzfpEQW-6YjEjX0PpsF4ydPnBvAJ5RWXsCf6B64qL7dOQ>
    <xme:7al5Xz4e-ogj2GuKJyciLB4NSW1ZxxO2G93wO_49Yif0_h1sg0lEexSPzC2qoAqER
    daoLcicCJ_stw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrgedtgdefhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:7al5X5fsMqZgS14r1eyu_rEJzAoqajbx9nETqo7Qj6-U98iw6XXmSQ>
    <xmx:7al5X3LSVdYagMKlvDM4G5R-kE_-hU5o0nLcGjJ7gTcSNEET3K428g>
    <xmx:7al5X-LK-HanMQf6W6RBQbfc5XFIUxZdkGaMKiqmxwWDjhb3KDu1ig>
    <xmx:7al5Xwj6lUJSb7cJGsBD-uuyyCVLnyKcYCWs3bNMC1-WBJnpDmdxpA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7D9473280059;
        Sun,  4 Oct 2020 06:54:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ftrace: Move RCU is watching check after recursion check" failed to apply to 4.9-stable tree
To:     rostedt@goodmis.org, paulmck@kernel.org, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 04 Oct 2020 12:55:16 +0200
Message-ID: <160180891616297@kroah.com>
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

From b40341fad6cc2daa195f8090fd3348f18fff640a Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Tue, 29 Sep 2020 12:40:31 -0400
Subject: [PATCH] ftrace: Move RCU is watching check after recursion check

The first thing that the ftrace function callback helper functions should do
is to check for recursion. Peter Zijlstra found that when
"rcu_is_watching()" had its notrace removed, it caused perf function tracing
to crash. This is because the call of rcu_is_watching() is tested before
function recursion is checked and and if it is traced, it will cause an
infinite recursion loop.

rcu_is_watching() should still stay notrace, but to prevent this should
never had crashed in the first place. The recursion prevention must be the
first thing done in callback functions.

Link: https://lore.kernel.org/r/20200929112541.GM2628@hirez.programming.kicks-ass.net

Cc: stable@vger.kernel.org
Cc: Paul McKenney <paulmck@kernel.org>
Fixes: c68c0fa293417 ("ftrace: Have ftrace_ops_get_func() handle RCU and PER_CPU flags too")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reported-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 603255f5f085..541453927c82 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6993,16 +6993,14 @@ static void ftrace_ops_assist_func(unsigned long ip, unsigned long parent_ip,
 {
 	int bit;
 
-	if ((op->flags & FTRACE_OPS_FL_RCU) && !rcu_is_watching())
-		return;
-
 	bit = trace_test_and_set_recursion(TRACE_LIST_START, TRACE_LIST_MAX);
 	if (bit < 0)
 		return;
 
 	preempt_disable_notrace();
 
-	op->func(ip, parent_ip, op, regs);
+	if (!(op->flags & FTRACE_OPS_FL_RCU) || rcu_is_watching())
+		op->func(ip, parent_ip, op, regs);
 
 	preempt_enable_notrace();
 	trace_clear_recursion(bit);

