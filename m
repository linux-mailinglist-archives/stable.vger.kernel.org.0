Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A9630A81A
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 13:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbhBAMzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 07:55:22 -0500
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:52785 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231703AbhBAMzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 07:55:10 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id EBE5B60D;
        Mon,  1 Feb 2021 07:54:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Feb 2021 07:54:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6pFQqa
        Oz0CG2uuRKwDPtbqwhQYTRyYVJD5XeSQNyW/8=; b=UFN4/FhIiCRFriGs4nXION
        IyESGPW4q8pw1AM8JO35Q+3fIlJGYhCzEP2MvSp3njUyPluhx0w3pn1qeWqMYdKM
        CqtO1xMyFp3zN9F6gPjrW9oMLpBbThFKtd8phNDlxrEHNNUGmcLjhjfJZZT3/WDI
        pgAN/oy1uPfnp65RIq1wRZHwHl3JIf44lzmmj10RPN5FD/bGYJuutucvzojnV5h1
        4YfXG+s6KXn40f4HgOHKdvOec9hRHUGBZNaeer0fXWF26YIeA6F5nDwcfRPxhlrm
        BPmVLELR+7gpWrUPZytKcH6knqVbJMjh3ev6YKqWg3Bt2OKr/DvlaEozamK422tg
        ==
X-ME-Sender: <xms:-_kXYNvxnEAnmD93krpVwK_PyFoV8UWBa6dogl9Zu3wzu3J3yVFdAw>
    <xme:-_kXYGfY96vlsCXz5LrB6kxiOZF_BVi5MMu-ksiqgKsbVTLbcX0wSiYQpGYLHIexZ
    9_0azhEXcVXEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:-_kXYAwGSK3UynTRTkGmJ8t8ARfnN6-f9uTIR-8xhtuH6dMZAnNvUQ>
    <xmx:-_kXYEPHDL3yVjZX2rkOS5ura5YZplRxkesuRrAFUmZzl-J6ZrvQoA>
    <xmx:-_kXYN_NfgGzKM7UfNRCrlirgBXVLgOyZG7tPlRanqYdAnzxfkFAvg>
    <xmx:-_kXYKFYE45-3qbsLfaasyAKS5P5hpLR0d5RIb4LU0D40AkvkwpgFMNEg1M>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0DF2124005D;
        Mon,  1 Feb 2021 07:54:18 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: fix cancellation taking mutex while" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Feb 2021 13:54:17 +0100
Message-ID: <161218405715580@kroah.com>
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

From ca70f00bed6cb255b7a9b91aa18a2717c9217f70 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Tue, 26 Jan 2021 15:28:27 +0000
Subject: [PATCH] io_uring: fix cancellation taking mutex while
 TASK_UNINTERRUPTIBLE

do not call blocking ops when !TASK_RUNNING; state=2 set at
	[<00000000ced9dbfc>] prepare_to_wait+0x1f4/0x3b0
	kernel/sched/wait.c:262
WARNING: CPU: 1 PID: 19888 at kernel/sched/core.c:7853
	__might_sleep+0xed/0x100 kernel/sched/core.c:7848
RIP: 0010:__might_sleep+0xed/0x100 kernel/sched/core.c:7848
Call Trace:
 __mutex_lock_common+0xc4/0x2ef0 kernel/locking/mutex.c:935
 __mutex_lock kernel/locking/mutex.c:1103 [inline]
 mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:1118
 io_wq_submit_work+0x39a/0x720 fs/io_uring.c:6411
 io_run_cancel fs/io-wq.c:856 [inline]
 io_wqe_cancel_pending_work fs/io-wq.c:990 [inline]
 io_wq_cancel_cb+0x614/0xcb0 fs/io-wq.c:1027
 io_uring_cancel_files fs/io_uring.c:8874 [inline]
 io_uring_cancel_task_requests fs/io_uring.c:8952 [inline]
 __io_uring_files_cancel+0x115d/0x19e0 fs/io_uring.c:9038
 io_uring_files_cancel include/linux/io_uring.h:51 [inline]
 do_exit+0x2e6/0x2490 kernel/exit.c:780
 do_group_exit+0x168/0x2d0 kernel/exit.c:922
 get_signal+0x16b5/0x2030 kernel/signal.c:2770
 arch_do_signal_or_restart+0x8e/0x6a0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0xac/0x1e0 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x48/0x190 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Rewrite io_uring_cancel_files() to mimic __io_uring_task_cancel()'s
counting scheme, so it does all the heavy work before setting
TASK_UNINTERRUPTIBLE.

Cc: stable@vger.kernel.org # 5.9+
Reported-by: syzbot+f655445043a26a7cfab8@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
[axboe: fix inverted task check]
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 09aada153a71..bb0270eeb8cb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8873,30 +8873,31 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 	}
 }
 
+static int io_uring_count_inflight(struct io_ring_ctx *ctx,
+				   struct task_struct *task,
+				   struct files_struct *files)
+{
+	struct io_kiocb *req;
+	int cnt = 0;
+
+	spin_lock_irq(&ctx->inflight_lock);
+	list_for_each_entry(req, &ctx->inflight_list, inflight_entry)
+		cnt += io_match_task(req, task, files);
+	spin_unlock_irq(&ctx->inflight_lock);
+	return cnt;
+}
+
 static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct task_struct *task,
 				  struct files_struct *files)
 {
 	while (!list_empty_careful(&ctx->inflight_list)) {
 		struct io_task_cancel cancel = { .task = task, .files = files };
-		struct io_kiocb *req;
 		DEFINE_WAIT(wait);
-		bool found = false;
-
-		spin_lock_irq(&ctx->inflight_lock);
-		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
-			if (!io_match_task(req, task, files))
-				continue;
-			found = true;
-			break;
-		}
-		if (found)
-			prepare_to_wait(&task->io_uring->wait, &wait,
-					TASK_UNINTERRUPTIBLE);
-		spin_unlock_irq(&ctx->inflight_lock);
+		int inflight;
 
-		/* We need to keep going until we don't find a matching req */
-		if (!found)
+		inflight = io_uring_count_inflight(ctx, task, files);
+		if (!inflight)
 			break;
 
 		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
@@ -8905,7 +8906,11 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 		io_cqring_overflow_flush(ctx, true, task, files);
 		/* cancellations _may_ trigger task work */
 		io_run_task_work();
-		schedule();
+
+		prepare_to_wait(&task->io_uring->wait, &wait,
+				TASK_UNINTERRUPTIBLE);
+		if (inflight == io_uring_count_inflight(ctx, task, files))
+			schedule();
 		finish_wait(&task->io_uring->wait, &wait);
 	}
 }

