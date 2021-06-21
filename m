Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9043AE760
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhFUKni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:43:38 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:50129 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229710AbhFUKnh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:43:37 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7DCE8194030F;
        Mon, 21 Jun 2021 06:41:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 21 Jun 2021 06:41:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=YcmXse
        Snrciadyy+S1MtyZZp3ydLK6t6ziTgiCo2b5I=; b=naH3x0nNz3WMVj9narXUYK
        OTMUd64q2gqHUNNh8kL9E/r5GrB2WAEPfcMNTvs6J1Xq20+8s4nOKxi3Y2hccblW
        29XhRjP/OUH1ySw5DyNqGEd1igRuEuuLCIqenmtEaDY3FDWHwEpU8il+FiEl3Mae
        gJRtJs/EY8gJIph9nNke72BOXQasYTv5VkVK07roY6nuGf/KUxiGEDOQL0aEdA+P
        BCqAL7mF2l/KDY9E32qAs64ZPoLvUYWXr7l10qRATWNR9+RjlRKxkH8C59DBYYwc
        kjgo9j05IkZDAnQMfCDxazz+Bja1rJirwsm23Ra63YpVr6rxgxLvaID0cDadW7EA
        ==
X-ME-Sender: <xms:02zQYPwrALV8md-JwLmHAsumRGXAckEnAc7wTjwSDmVtLVUrSV4AVQ>
    <xme:02zQYHQ-3ZSEPUuSUUUZTaLJoVhAAlt3hx-weA7pvpf0RUfQLjCRoS3ROdip09WkB
    Gf0OJDTs3u35w>
X-ME-Received: <xmr:02zQYJUnoEp1zWPCc3MIgpxbo_46IMdKq750zBLsH4Kqile_wZY1jBdG_9pQGJXC214DNuhQLO-Uw_iEz1cX-Pa5NNZyg7z5>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:02zQYJgkAKLakAY9KiUe_kSYIYseeNYX2W9_3u2iFkL_Rh3nXSD5Vg>
    <xmx:02zQYBDpU-MBK707jnJd62xoZIi8HJInGZ5twAyc7GMggRi4Yj3sTQ>
    <xmx:02zQYCI4xWkBXtyTTaN1HfJZGJazjdMbxVZxLB79G9WHeK1o12i3ig>
    <xmx:02zQYErCEIORTFdlM8JlLsskWs1WbeLkeVpLHIrbkjBz9DzbXDaJAQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 06:41:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tracing: Do not stop recording comms if the trace file is" failed to apply to 4.9-stable tree
To:     rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 12:41:21 +0200
Message-ID: <1624272081106153@kroah.com>
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

