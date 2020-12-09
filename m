Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3CB2D45DD
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgLIPx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:53:28 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:58427 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731232AbgLIPxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:53:21 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 441341943921;
        Wed,  9 Dec 2020 03:36:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 03:36:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ssFMmb
        NyJ/v+uYcgmZsye5dQMbKycz7O5VLdV4oDBp8=; b=rfFp2j+t3QVMGiHH3kTTt2
        WNiFjHyqCue6B9HbaeoQpClYxPQ4G6QDm7rJPoQobkPtx+6MQviOmTVVP84zlXv6
        AN70kcF1Kp291FuYRZgfVjzym/X8j9+OEdhA+pW6s5eS45SwGEUHn0NgOuhMVUUp
        imhK3R5INUrMBS6ZRcib+pX1tmt0Ppu75oubH4Osfoaa1kbQzLHGb1Yya2GzL2kB
        J7JxUKKnLvwfuibV9ixUMd0rG4Ep5ntBLpzFGcQQYNr9/FltdoRbgxDS23CInWS9
        HS3h851LWedpB/aw5T6CYCKK3Z8/VBpgMR+2cbT4wLfg35AudGhUknVXET+5eldQ
        ==
X-ME-Sender: <xms:l4zQX6CErwdOzbvp4xEk_gkrF5DpaXBE482ix6TOonxaJC2EfHhaWA>
    <xme:l4zQX0hUWUKtCFY5JZk9OpB3TRNltAGxVSTkDBeUyaCikaCb2Opp_B8flT8RvDkNS
    sjQ4PtcPvHO9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejjedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:l4zQX9nqgZtXqQumva4WrHS0dBME0zNvj2l0pKJlDeKmWtGmTdDvCg>
    <xmx:l4zQX4xgP-JqH9UfbVpIhjZcdbpgbmRAjKV6wWNIslJsEZa-jesAjA>
    <xmx:l4zQX_SnDeuiGhiQqbIaI-rsxN338nj5kc7RFI-UrgFrEXVEC1bOLQ>
    <xmx:l4zQXyPICF8n-Ciruq5ULGZmVANHtNM3W_NpCdcVxdwdfgSJrTne8A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E47EF108005F;
        Wed,  9 Dec 2020 03:36:38 -0500 (EST)
Subject: FAILED: patch "[PATCH] tracing: Fix userstacktrace option for instances" failed to apply to 4.14-stable tree
To:     rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 09:37:53 +0100
Message-ID: <160750307316291@kroah.com>
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

From bcee5278958802b40ee8b26679155a6d9231783e Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Fri, 4 Dec 2020 16:36:16 -0500
Subject: [PATCH] tracing: Fix userstacktrace option for instances

When the instances were able to use their own options, the userstacktrace
option was left hardcoded for the top level. This made the instance
userstacktrace option bascially into a nop, and will confuse users that set
it, but nothing happens (I was confused when it happened to me!)

Cc: stable@vger.kernel.org
Fixes: 16270145ce6b ("tracing: Add trace options for core options to instances")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7d53c5bdea3e..06134189e9a7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -163,7 +163,8 @@ static union trace_eval_map_item *trace_eval_maps;
 #endif /* CONFIG_TRACE_EVAL_MAP_FILE */
 
 int tracing_set_tracer(struct trace_array *tr, const char *buf);
-static void ftrace_trace_userstack(struct trace_buffer *buffer,
+static void ftrace_trace_userstack(struct trace_array *tr,
+				   struct trace_buffer *buffer,
 				   unsigned long flags, int pc);
 
 #define MAX_TRACER_SIZE		100
@@ -2870,7 +2871,7 @@ void trace_buffer_unlock_commit_regs(struct trace_array *tr,
 	 * two. They are not that meaningful.
 	 */
 	ftrace_trace_stack(tr, buffer, flags, regs ? 0 : STACK_SKIP, pc, regs);
-	ftrace_trace_userstack(buffer, flags, pc);
+	ftrace_trace_userstack(tr, buffer, flags, pc);
 }
 
 /*
@@ -3056,13 +3057,14 @@ EXPORT_SYMBOL_GPL(trace_dump_stack);
 static DEFINE_PER_CPU(int, user_stack_count);
 
 static void
-ftrace_trace_userstack(struct trace_buffer *buffer, unsigned long flags, int pc)
+ftrace_trace_userstack(struct trace_array *tr,
+		       struct trace_buffer *buffer, unsigned long flags, int pc)
 {
 	struct trace_event_call *call = &event_user_stack;
 	struct ring_buffer_event *event;
 	struct userstack_entry *entry;
 
-	if (!(global_trace.trace_flags & TRACE_ITER_USERSTACKTRACE))
+	if (!(tr->trace_flags & TRACE_ITER_USERSTACKTRACE))
 		return;
 
 	/*
@@ -3101,7 +3103,8 @@ ftrace_trace_userstack(struct trace_buffer *buffer, unsigned long flags, int pc)
 	preempt_enable();
 }
 #else /* CONFIG_USER_STACKTRACE_SUPPORT */
-static void ftrace_trace_userstack(struct trace_buffer *buffer,
+static void ftrace_trace_userstack(struct trace_array *tr,
+				   struct trace_buffer *buffer,
 				   unsigned long flags, int pc)
 {
 }

