Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFE82D461D
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730934AbgLIPwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:52:35 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:49711 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727526AbgLIPwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:52:30 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4441919436AB;
        Wed,  9 Dec 2020 03:36:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 03:36:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7LJWu5
        s8jIVlXz/05g9U0I7bYANp18ocaq17jWw46Xc=; b=ThHqhm7oXaKfE39DQoQOG0
        7N49U+dHqVGahdy5P9tB2H2J0HQBeZUK8nmgiT6i1/pP+bSR8XBV2D1jtdwWYv7D
        yQj4jr8ixY9QjmHMUEleRSFkuIGM0z1y2FeIgL4XsF23LNy4LWf+j7Kv32/6CIcS
        4UcgKeL5WmKQHtO8jw4K7h69z9+VlDaXIIyM1DToyPTPRoSLAkatIo5F6HPkJWfk
        lRwd/KDxC74wQ2JuRXczW+dqrkkiVDBzOTqEvgJ12L3ibxn9gZPgYSn2s13aNfvq
        mQHLq21UaoHdj6YWNHKZ+n/iQfZcQBuPaRxKKSVvBuWeHO8iBzWn8MlGEwamK4jQ
        ==
X-ME-Sender: <xms:kYzQX3S33lA-3PVbLYI4BCb71mXexryURIp-vm3GkJYCOby3M4Gy2Q>
    <xme:kYzQX4xwjIbqqzWFfEjZb704xnEaYka6GeiD58T4cJBlYP_if9VbhntfdTVBmsjYZ
    n1QvRLxwHuR_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejjedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:kYzQX80LWpc92l1TqTTCGXB4slf1_-mCciNzSlZYPgunWlqQhKuqkw>
    <xmx:kYzQX3Cg0EPtnF0Par928o2OJJsNOf-rLR-wOBSPRFNdZyzipLkKdg>
    <xmx:kYzQXwi0fJOxEDKaayLzcfO7YAG0_O24KvNW0siYbwj5JdNvHy_c-Q>
    <xmx:kozQX-eoATqX6qqB6ZXkcCjZbNpfNYSkYRy76YN9sJXBobHW3-vjWQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AADCF24005A;
        Wed,  9 Dec 2020 03:36:33 -0500 (EST)
Subject: FAILED: patch "[PATCH] tracing: Fix userstacktrace option for instances" failed to apply to 4.4-stable tree
To:     rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 09:37:51 +0100
Message-ID: <16075030712612@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

