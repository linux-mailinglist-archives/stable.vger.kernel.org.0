Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BE8377E97
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhEJIvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:51:20 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:58571 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230146AbhEJIvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:51:20 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6148D1940B6A;
        Mon, 10 May 2021 04:50:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 10 May 2021 04:50:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/Vs+z6
        aniXABS0lNxK6KshshQ8Dx2ofbpuQk/oqS/ys=; b=lTtLjWWuNEu5uBod4HRtJt
        Eh1jhbCgysq2o16U09ZfpSWKLPJM6MC726L68v4f2pm3Wjslw4pM2+fewPpRxrBi
        Gp2vofE8HM+XXF18n+9B4p0XSvPpZhGGgwakCIDi4WaxnPTAiZym7gKWA0LjzV0b
        eF47L1xsS+/kLeQGMqkHhaD91LWV+8TJQXfina3PxQQ2/sXHyYtqp6C2e8I39pXc
        9xetdH/YmjaxGoduurdbXNR0mK6gKVd5UgU/Ex78M+nCVjDt4h4eX/Rw9vWnuxdv
        Xkfxad8baT+jhEGUUBB+fLdQKtkx9VEp+zYFb/hmcyJX/8NI6QCRkZRSyphGSHVg
        ==
X-ME-Sender: <xms:x_OYYNw1Q86whqTw3fAryWLETyabI1Y_5KAdas18KY07avtZ8D4ntg>
    <xme:x_OYYNSyx-taSBo69PZdyageO9niSo1K2N4fJEsXh8bSmhL5CleBePT_5OwuvaqUN
    H1jXtpDH8tVoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:x_OYYHX0gXlFlup307wHbv8DwMrEkM_4v-dx8B5mkytxJgdLyR6nQA>
    <xmx:x_OYYPiftZRya783du8Ynbhx-JihEWGk8zYGJRYGAyBKR6lKvhipJw>
    <xmx:x_OYYPCw8UMXtoroFht96eOLT_538v2Unog0nPRDycwM8QQxSetQLQ>
    <xmx:x_OYYC_sN2GarhG3QiB-Lxi9YhLJDYbdQ9oPZa3tVghYVp8kArZqtw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:50:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tracing: Map all PIDs to command lines" failed to apply to 4.4-stable tree
To:     rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:50:13 +0200
Message-ID: <16206366136166@kroah.com>
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

From 785e3c0a3a870e72dc530856136ab4c8dd207128 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Tue, 27 Apr 2021 11:32:07 -0400
Subject: [PATCH] tracing: Map all PIDs to command lines

The default max PID is set by PID_MAX_DEFAULT, and the tracing
infrastructure uses this number to map PIDs to the comm names of the
tasks, such output of the trace can show names from the recorded PIDs in
the ring buffer. This mapping is also exported to user space via the
"saved_cmdlines" file in the tracefs directory.

But currently the mapping expects the PIDs to be less than
PID_MAX_DEFAULT, which is the default maximum and not the real maximum.
Recently, systemd will increases the maximum value of a PID on the system,
and when tasks are traced that have a PID higher than PID_MAX_DEFAULT, its
comm is not recorded. This leads to the entire trace to have "<...>" as
the comm name, which is pretty useless.

Instead, keep the array mapping the size of PID_MAX_DEFAULT, but instead
of just mapping the index to the comm, map a mask of the PID
(PID_MAX_DEFAULT - 1) to the comm, and find the full PID from the
map_cmdline_to_pid array (that already exists).

This bug goes back to the beginning of ftrace, but hasn't been an issue
until user space started increasing the maximum value of PIDs.

Link: https://lkml.kernel.org/r/20210427113207.3c601884@gandalf.local.home

Cc: stable@vger.kernel.org
Fixes: bc0c38d139ec7 ("ftrace: latency tracer infrastructure")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 66a4ad93b5e9..e28d08905124 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2390,14 +2390,13 @@ static void tracing_stop_tr(struct trace_array *tr)
 
 static int trace_save_cmdline(struct task_struct *tsk)
 {
-	unsigned pid, idx;
+	unsigned tpid, idx;
 
 	/* treat recording of idle task as a success */
 	if (!tsk->pid)
 		return 1;
 
-	if (unlikely(tsk->pid > PID_MAX_DEFAULT))
-		return 0;
+	tpid = tsk->pid & (PID_MAX_DEFAULT - 1);
 
 	/*
 	 * It's not the end of the world if we don't get
@@ -2408,26 +2407,15 @@ static int trace_save_cmdline(struct task_struct *tsk)
 	if (!arch_spin_trylock(&trace_cmdline_lock))
 		return 0;
 
-	idx = savedcmd->map_pid_to_cmdline[tsk->pid];
+	idx = savedcmd->map_pid_to_cmdline[tpid];
 	if (idx == NO_CMDLINE_MAP) {
 		idx = (savedcmd->cmdline_idx + 1) % savedcmd->cmdline_num;
 
-		/*
-		 * Check whether the cmdline buffer at idx has a pid
-		 * mapped. We are going to overwrite that entry so we
-		 * need to clear the map_pid_to_cmdline. Otherwise we
-		 * would read the new comm for the old pid.
-		 */
-		pid = savedcmd->map_cmdline_to_pid[idx];
-		if (pid != NO_CMDLINE_MAP)
-			savedcmd->map_pid_to_cmdline[pid] = NO_CMDLINE_MAP;
-
-		savedcmd->map_cmdline_to_pid[idx] = tsk->pid;
-		savedcmd->map_pid_to_cmdline[tsk->pid] = idx;
-
+		savedcmd->map_pid_to_cmdline[tpid] = idx;
 		savedcmd->cmdline_idx = idx;
 	}
 
+	savedcmd->map_cmdline_to_pid[idx] = tsk->pid;
 	set_cmdline(idx, tsk->comm);
 
 	arch_spin_unlock(&trace_cmdline_lock);
@@ -2438,6 +2426,7 @@ static int trace_save_cmdline(struct task_struct *tsk)
 static void __trace_find_cmdline(int pid, char comm[])
 {
 	unsigned map;
+	int tpid;
 
 	if (!pid) {
 		strcpy(comm, "<idle>");
@@ -2449,16 +2438,16 @@ static void __trace_find_cmdline(int pid, char comm[])
 		return;
 	}
 
-	if (pid > PID_MAX_DEFAULT) {
-		strcpy(comm, "<...>");
-		return;
+	tpid = pid & (PID_MAX_DEFAULT - 1);
+	map = savedcmd->map_pid_to_cmdline[tpid];
+	if (map != NO_CMDLINE_MAP) {
+		tpid = savedcmd->map_cmdline_to_pid[map];
+		if (tpid == pid) {
+			strlcpy(comm, get_saved_cmdlines(map), TASK_COMM_LEN);
+			return;
+		}
 	}
-
-	map = savedcmd->map_pid_to_cmdline[pid];
-	if (map != NO_CMDLINE_MAP)
-		strlcpy(comm, get_saved_cmdlines(map), TASK_COMM_LEN);
-	else
-		strcpy(comm, "<...>");
+	strcpy(comm, "<...>");
 }
 
 void trace_find_cmdline(int pid, char comm[])

