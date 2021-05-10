Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB1F377E9B
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhEJIvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:51:50 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:42615 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhEJIvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:51:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 417271940BAA;
        Mon, 10 May 2021 04:50:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 10 May 2021 04:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=DutQ+X
        4/9L6J1/S4QZExrGktYioTOlgdRGHSpjHxwDg=; b=F80nuA64+MZWBF3muyHj1m
        juRB3bCOGmayRHFsAzI2d8BVrhPVz1L5l+hDlmvdQmtqA8nNvHeGrYLu/07uMb0C
        6MUFa/bAaUmf5Y5F08Y8xRIJd8nkow7r9XdbBOAmJLHVOXYj04uy7yt1Gng3y0ys
        iklbESzxxQUqsIVhzPvrOZ8KYAsryT5XeSxvXeLL20uTqMmVW40LrEuSKRX8fKUS
        FV8/RTMKDGFlNlU03mk+iqsduKnnjEFRVaIzfIqEbVY9CRucbRGq02d+60Yvnh/v
        EpbpmubAooj80oZNpkj8mULK+mJzkDgCjnDxQyBI6uLiEGqxYa1dsWnpBCp5lm8A
        ==
X-ME-Sender: <xms:5POYYAbUs34x-zyv11n4axwgmdSjucnTLPZsSRUTVhWcEcaivN_7fA>
    <xme:5POYYLbGjHQrqA5qENM5VCJ1YsDbUkv27oMP9z2IhlRms0W9AqRqTA6Ngv7EGo4CV
    ove-jwJZFXUkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:5POYYK93oBWp-XD_h2ALT_QXhx2in2_t21MUHmEqoDubIstWlkg9yA>
    <xmx:5POYYKqbEb0VoCIUAByueZYe4T-vZlWrbgCK7K_GGHcXYBqr0SbcFg>
    <xmx:5POYYLrHVXt0RM7MOp9LaJpAdWCrsZ_fBwuiNM5WUDPtImlYkMUplw>
    <xmx:5fOYYECy3H9LV6cNQ23Q2OWnTTPrkRif1PjyyzRQBWgARDAx0Y0isQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:50:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tracing: Restructure trace_clock_global() to never block" failed to apply to 4.9-stable tree
To:     rostedt@goodmis.org, hi-angel@yandex.ru,
        todd.e.brandt@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:50:41 +0200
Message-ID: <16206366416963@kroah.com>
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

From aafe104aa9096827a429bc1358f8260ee565b7cc Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Fri, 30 Apr 2021 12:17:58 -0400
Subject: [PATCH] tracing: Restructure trace_clock_global() to never block

It was reported that a fix to the ring buffer recursion detection would
cause a hung machine when performing suspend / resume testing. The
following backtrace was extracted from debugging that case:

Call Trace:
 trace_clock_global+0x91/0xa0
 __rb_reserve_next+0x237/0x460
 ring_buffer_lock_reserve+0x12a/0x3f0
 trace_buffer_lock_reserve+0x10/0x50
 __trace_graph_return+0x1f/0x80
 trace_graph_return+0xb7/0xf0
 ? trace_clock_global+0x91/0xa0
 ftrace_return_to_handler+0x8b/0xf0
 ? pv_hash+0xa0/0xa0
 return_to_handler+0x15/0x30
 ? ftrace_graph_caller+0xa0/0xa0
 ? trace_clock_global+0x91/0xa0
 ? __rb_reserve_next+0x237/0x460
 ? ring_buffer_lock_reserve+0x12a/0x3f0
 ? trace_event_buffer_lock_reserve+0x3c/0x120
 ? trace_event_buffer_reserve+0x6b/0xc0
 ? trace_event_raw_event_device_pm_callback_start+0x125/0x2d0
 ? dpm_run_callback+0x3b/0xc0
 ? pm_ops_is_empty+0x50/0x50
 ? platform_get_irq_byname_optional+0x90/0x90
 ? trace_device_pm_callback_start+0x82/0xd0
 ? dpm_run_callback+0x49/0xc0

With the following RIP:

RIP: 0010:native_queued_spin_lock_slowpath+0x69/0x200

Since the fix to the recursion detection would allow a single recursion to
happen while tracing, this lead to the trace_clock_global() taking a spin
lock and then trying to take it again:

ring_buffer_lock_reserve() {
  trace_clock_global() {
    arch_spin_lock() {
      queued_spin_lock_slowpath() {
        /* lock taken */
        (something else gets traced by function graph tracer)
          ring_buffer_lock_reserve() {
            trace_clock_global() {
              arch_spin_lock() {
                queued_spin_lock_slowpath() {
                /* DEAD LOCK! */

Tracing should *never* block, as it can lead to strange lockups like the
above.

Restructure the trace_clock_global() code to instead of simply taking a
lock to update the recorded "prev_time" simply use it, as two events
happening on two different CPUs that calls this at the same time, really
doesn't matter which one goes first. Use a trylock to grab the lock for
updating the prev_time, and if it fails, simply try again the next time.
If it failed to be taken, that means something else is already updating
it.

Link: https://lkml.kernel.org/r/20210430121758.650b6e8a@gandalf.local.home

Cc: stable@vger.kernel.org
Tested-by: Konstantin Kharlamov <hi-angel@yandex.ru>
Tested-by: Todd Brandt <todd.e.brandt@linux.intel.com>
Fixes: b02414c8f045 ("ring-buffer: Fix recursion protection transitions between interrupt context") # started showing the problem
Fixes: 14131f2f98ac3 ("tracing: implement trace_clock_*() APIs") # where the bug happened
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=212761
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index aaf6793ededa..c1637f90c8a3 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -95,33 +95,49 @@ u64 notrace trace_clock_global(void)
 {
 	unsigned long flags;
 	int this_cpu;
-	u64 now;
+	u64 now, prev_time;
 
 	raw_local_irq_save(flags);
 
 	this_cpu = raw_smp_processor_id();
-	now = sched_clock_cpu(this_cpu);
+
 	/*
-	 * If in an NMI context then dont risk lockups and return the
-	 * cpu_clock() time:
+	 * The global clock "guarantees" that the events are ordered
+	 * between CPUs. But if two events on two different CPUS call
+	 * trace_clock_global at roughly the same time, it really does
+	 * not matter which one gets the earlier time. Just make sure
+	 * that the same CPU will always show a monotonic clock.
+	 *
+	 * Use a read memory barrier to get the latest written
+	 * time that was recorded.
 	 */
-	if (unlikely(in_nmi()))
-		goto out;
+	smp_rmb();
+	prev_time = READ_ONCE(trace_clock_struct.prev_time);
+	now = sched_clock_cpu(this_cpu);
 
-	arch_spin_lock(&trace_clock_struct.lock);
+	/* Make sure that now is always greater than prev_time */
+	if ((s64)(now - prev_time) < 0)
+		now = prev_time + 1;
 
 	/*
-	 * TODO: if this happens often then maybe we should reset
-	 * my_scd->clock to prev_time+1, to make sure
-	 * we start ticking with the local clock from now on?
+	 * If in an NMI context then dont risk lockups and simply return
+	 * the current time.
 	 */
-	if ((s64)(now - trace_clock_struct.prev_time) < 0)
-		now = trace_clock_struct.prev_time + 1;
+	if (unlikely(in_nmi()))
+		goto out;
 
-	trace_clock_struct.prev_time = now;
+	/* Tracing can cause strange recursion, always use a try lock */
+	if (arch_spin_trylock(&trace_clock_struct.lock)) {
+		/* Reread prev_time in case it was already updated */
+		prev_time = READ_ONCE(trace_clock_struct.prev_time);
+		if ((s64)(now - prev_time) < 0)
+			now = prev_time + 1;
 
-	arch_spin_unlock(&trace_clock_struct.lock);
+		trace_clock_struct.prev_time = now;
 
+		/* The unlock acts as the wmb for the above rmb */
+		arch_spin_unlock(&trace_clock_struct.lock);
+	}
  out:
 	raw_local_irq_restore(flags);
 

