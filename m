Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436E12E96DD
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 15:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbhADOKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 09:10:37 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:34525 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726616AbhADOKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 09:10:36 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id DE5751C67;
        Mon,  4 Jan 2021 09:09:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 04 Jan 2021 09:09:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dFx6lA
        h9bhRRo5YmYyzpwfYIGSR/BCCcCXfMcrIrlTU=; b=f4dffG98WPKTrSbQaqOh0v
        2TNcmvpL8YElWAAFbhT2AodEguPXB/uGdRWNP/6RQFVPKjcehCptqWREOdTbmITb
        ERSd7wSnF/VP80+onmt5L2lM9jpuiA5wDyQwTGD+AKuGeOZvTh5ALAzghJAcDJ+p
        w6lzIkjt7tFwPs6a5FXyhixKJikq5xUi86F1O5V+KFWGWVN9VkGXh/v9HISOtvDg
        fHRudjgytkpY34aZLFqXngrSqTbbMUqimjci1KVy/ZkW/6tzzUqV3izXDD/LHenx
        7r9PyMNirpV/LEZZEFqrCvTv39rdWWUuuBzaOerx7XIii7HcD3VK95Xkcd4Hj3iA
        ==
X-ME-Sender: <xms:miHzX6ylpCQww8FRu-QotAicU6RqFmGE52lfnNq8jqZ4LMr6QT16jA>
    <xme:miHzX4R9peU1E-1F_CWJ6Iz6338mDbImOyy15p2E6KJLndMOwnM2QpYjVDn59wWLP
    dmDA3EU1uO3zg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeffedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:miHzX1uKYAwkVD7JZZjAjg9yBF2aQDW7KRJ4xcz68-lk49jPGGdLvg>
    <xmx:miHzXyugcRgr6hfW98_S4pzKHeyUphrIR-1I37AqqdY840O_kNJPWA>
    <xmx:miHzXzzBljHbetL8Hp9LUcNcGQCaxXcBq3BqlBQuNDtcakkjJb5oEA>
    <xmx:miHzXwUhQNOzFTQaX9W4nyKCG0ge0vTVfQMqZQfHF7CV5EFmKbE5ZrIzyUI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D4FD4108005C;
        Mon,  4 Jan 2021 09:09:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] perf: Break deadlock involving exec_update_mutex" failed to apply to 5.10-stable tree
To:     peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jan 2021 15:10:56 +0100
Message-ID: <160976945620871@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 78af4dc949daaa37b3fcd5f348f373085b4e858f Mon Sep 17 00:00:00 2001
From: "peterz@infradead.org" <peterz@infradead.org>
Date: Fri, 28 Aug 2020 14:37:20 +0200
Subject: [PATCH] perf: Break deadlock involving exec_update_mutex

Syzbot reported a lock inversion involving perf. The sore point being
perf holding exec_update_mutex() for a very long time, specifically
across a whole bunch of filesystem ops in pmu::event_init() (uprobes)
and anon_inode_getfile().

This then inverts against procfs code trying to take
exec_update_mutex.

Move the permission checks later, such that we need to hold the mutex
over less code.

Reported-by: syzbot+db9cdf3dd1f64252c6ef@syzkaller.appspotmail.com
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a21b0be2f22c..19ae6c931c52 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11832,24 +11832,6 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_task;
 	}
 
-	if (task) {
-		err = mutex_lock_interruptible(&task->signal->exec_update_mutex);
-		if (err)
-			goto err_task;
-
-		/*
-		 * Preserve ptrace permission check for backwards compatibility.
-		 *
-		 * We must hold exec_update_mutex across this and any potential
-		 * perf_install_in_context() call for this new event to
-		 * serialize against exec() altering our credentials (and the
-		 * perf_event_exit_task() that could imply).
-		 */
-		err = -EACCES;
-		if (!perfmon_capable() && !ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS))
-			goto err_cred;
-	}
-
 	if (flags & PERF_FLAG_PID_CGROUP)
 		cgroup_fd = pid;
 
@@ -11857,7 +11839,7 @@ SYSCALL_DEFINE5(perf_event_open,
 				 NULL, NULL, cgroup_fd);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
-		goto err_cred;
+		goto err_task;
 	}
 
 	if (is_sampling_event(event)) {
@@ -11976,6 +11958,24 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_context;
 	}
 
+	if (task) {
+		err = mutex_lock_interruptible(&task->signal->exec_update_mutex);
+		if (err)
+			goto err_file;
+
+		/*
+		 * Preserve ptrace permission check for backwards compatibility.
+		 *
+		 * We must hold exec_update_mutex across this and any potential
+		 * perf_install_in_context() call for this new event to
+		 * serialize against exec() altering our credentials (and the
+		 * perf_event_exit_task() that could imply).
+		 */
+		err = -EACCES;
+		if (!perfmon_capable() && !ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS))
+			goto err_cred;
+	}
+
 	if (move_group) {
 		gctx = __perf_event_ctx_lock_double(group_leader, ctx);
 
@@ -12151,7 +12151,10 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (move_group)
 		perf_event_ctx_unlock(group_leader, gctx);
 	mutex_unlock(&ctx->mutex);
-/* err_file: */
+err_cred:
+	if (task)
+		mutex_unlock(&task->signal->exec_update_mutex);
+err_file:
 	fput(event_file);
 err_context:
 	perf_unpin_context(ctx);
@@ -12163,9 +12166,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	 */
 	if (!event_file)
 		free_event(event);
-err_cred:
-	if (task)
-		mutex_unlock(&task->signal->exec_update_mutex);
 err_task:
 	if (task)
 		put_task_struct(task);

