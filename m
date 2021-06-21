Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0B23AE761
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhFUKnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:43:46 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:45329 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230061AbhFUKnq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:43:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id EB06E19403F7;
        Mon, 21 Jun 2021 06:41:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 21 Jun 2021 06:41:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=dLWB1/
        LmAXU2HyKisxFYkFh1G825JXIpSIcvz48yjqM=; b=aQSOsgUG6jAxqt1oVC4ncU
        baOY6IifBc1m6TKfoz8E1JsIwiThzBv0TgHWQmsAmBTX4WZMwiQf06wF/UXp9Eg2
        3blIDy36z8hyd9QTvd4qjhG6zOgcBHOi87UBQ7nGFhmyMdj8naZqgWvUqikIEsQT
        VdCQIlHZKqeF7zqe3V9IPyALtLpsBRu6XLTwY3GT5GbNM6oEv/cmLUarP9wjYUEm
        ZF6gl2wsz/eluGGmq/WDXLDX6COfq7b7pGsvkhqkKJuKJyyZx/UoV9pdz03Mp7OS
        CuqUV587uoy1Bv8S8wtuMoqaez9G1EGIfvAZ41e2Ql4vzNALM5Hd+By6t1m4f0yg
        ==
X-ME-Sender: <xms:22zQYIsnIJEsGA_Lpqc-CJ12RcHZn5kPFfBcKYiHGvjli0PkIjQwcg>
    <xme:22zQYFfUUfQXPFDOaUcJpsG227LKh2002-EKgBF0mSyF2E45jwBnHrUVm8i8VHtfs
    -AZ3CYre2zbSQ>
X-ME-Received: <xmr:22zQYDzrMbU5_uDNTHQE2zGH0mVVwCiRTEtkLXfENOE_EVO-Hhcpd3u5FENkbSQTVogL2osFSQMuq-JAqo8jvkqefaz8Obf1>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:22zQYLN8zCcQgCMuP7l5a8Z-Dfvzdo7vx6CGOen2wJvmINb1BJo3HA>
    <xmx:22zQYI-uYRWXKnM00sxnNz9y3KFPAd5bILZDPT0FD9A83-ZBmPQxLw>
    <xmx:22zQYDVpJkwXVsIVUNYQMw8oFiT3joqHk08naV9jsmkT6gIfSGC-PQ>
    <xmx:22zQYNGzgsglopuIpv8C9bIB1cDvC1yyedYGq_nKxzNsyb2lAZ97yA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 06:41:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tracing: Do not stop recording comms if the trace file is" failed to apply to 4.4-stable tree
To:     rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 12:41:21 +0200
Message-ID: <162427208166207@kroah.com>
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

From 4fdd595e4f9a1ff6d93ec702eaecae451cfc6591 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Thu, 17 Jun 2021 14:32:34 -0400
Subject: [PATCH] tracing: Do not stop recording comms if the trace file is
 being read

A while ago, when the "trace" file was opened, tracing was stopped, and
code was added to stop recording the comms to saved_cmdlines, for mapping
of the pids to the task name.

Code has been added that only records the comm if a trace event occurred,
and there's no reason to not trace it if the trace file is opened.

Cc: stable@vger.kernel.org
Fixes: 7ffbd48d5cab2 ("tracing: Cache comms only after an event occurred")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e220b37e29c6..d23a09d3eb37 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2198,9 +2198,6 @@ struct saved_cmdlines_buffer {
 };
 static struct saved_cmdlines_buffer *savedcmd;
 
-/* temporary disable recording */
-static atomic_t trace_record_taskinfo_disabled __read_mostly;
-
 static inline char *get_saved_cmdlines(int idx)
 {
 	return &savedcmd->saved_cmdlines[idx * TASK_COMM_LEN];
@@ -3996,9 +3993,6 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 		return ERR_PTR(-EBUSY);
 #endif
 
-	if (!iter->snapshot)
-		atomic_inc(&trace_record_taskinfo_disabled);
-
 	if (*pos != iter->pos) {
 		iter->ent = NULL;
 		iter->cpu = 0;
@@ -4041,9 +4035,6 @@ static void s_stop(struct seq_file *m, void *p)
 		return;
 #endif
 
-	if (!iter->snapshot)
-		atomic_dec(&trace_record_taskinfo_disabled);
-
 	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
 }

