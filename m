Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D61203E54
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 19:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgFVRtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 13:49:02 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:43111 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729886AbgFVRtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 13:49:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 3796A118A;
        Mon, 22 Jun 2020 13:49:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 22 Jun 2020 13:49:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=EOTXI3
        x27LWnRrqcbIGaCXTft7gF3Zi4gFuQ3d1vd2c=; b=kIot7NjuzdOEiF6w6ur6qm
        oflvz3U3NkuLbGo1O1YB/XA0yE0jTuu+2TK8k+AiCbUYYUOkIrUK3tBtGBH2s2ZV
        wDG2CD397PqOoBNGZFd0j5GCGzuR+c/igOEfZMGI2Bdmt9KObGc4SLWlGu+AovXN
        kgYmi0WALA87RKV9QbXrJfo7uju1obCl0itt9hLixih/HlfDSliJBgZyZUc54ajR
        sEh0RHijpX8pKp8OeTLK/sdpN7s3WBdvKUZQAChJJ4imVTk1X77Zhlr56a/uYdy3
        0ZYmzu1oqHUg37iL6RvBMfrvZkFsCkpNNV0vRE9MZ1rv8mU7thZKVE8GCK3oT1gA
        ==
X-ME-Sender: <xms:DO_wXpjuuJ9-dyo7gJ6QFBxlFsZmfuOR2EWLyL4yxadeagwCT0FAGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekvddguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhs
    thgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:DO_wXuBCMDQMfuPIRgegseTfW_5f8N_w8ENkFEZW11GgZYDuLzHtRQ>
    <xmx:DO_wXpERgnKsxHJJru6EXBULYFPmK7lmLJbuHvTVCf3bX17bWyi0hw>
    <xmx:DO_wXuQsudEgef-bOUlPxtkvQFPpbwNmYDwWLjTaj5zTWl0SvsZdeg>
    <xmx:DO_wXl-UT-Nx3b1GcCkwaM01bY6YyyFjwaBYdjyur1AG-egU-etthN-p1kw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 72CA63280067;
        Mon, 22 Jun 2020 13:49:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: acquire 'mm' for task_work for SQPOLL" failed to apply to 5.7-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Jun 2020 19:48:55 +0200
Message-ID: <159284813596252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9d8426a09195e2dcf2aa249de2aaadd792d491c7 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 16 Jun 2020 18:42:49 -0600
Subject: [PATCH] io_uring: acquire 'mm' for task_work for SQPOLL

If we're unlucky with timing, we could be running task_work after
having dropped the memory context in the sq thread. Since dropping
the context requires a runnable task state, we cannot reliably drop
it as part of our check-for-work loop in io_sq_thread(). Instead,
abstract out the mm acquire for the sq thread into a helper, and call
it from the async task work handler.

Cc: stable@vger.kernel.org # v5.7
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9d2ae9aa8b45..98c83fbf4f88 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4256,6 +4256,28 @@ static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
 	__io_queue_proc(&pt->req->apoll->poll, pt, head);
 }
 
+static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
+{
+	struct mm_struct *mm = current->mm;
+
+	if (mm) {
+		kthread_unuse_mm(mm);
+		mmput(mm);
+	}
+}
+
+static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
+				   struct io_kiocb *req)
+{
+	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
+		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
+			return -EFAULT;
+		kthread_use_mm(ctx->sqo_mm);
+	}
+
+	return 0;
+}
+
 static void io_async_task_func(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
@@ -4290,11 +4312,16 @@ static void io_async_task_func(struct callback_head *cb)
 
 	if (!canceled) {
 		__set_current_state(TASK_RUNNING);
+		if (io_sq_thread_acquire_mm(ctx, req)) {
+			io_cqring_add_event(req, -EFAULT);
+			goto end_req;
+		}
 		mutex_lock(&ctx->uring_lock);
 		__io_queue_sqe(req, NULL);
 		mutex_unlock(&ctx->uring_lock);
 	} else {
 		io_cqring_ev_posted(ctx);
+end_req:
 		req_set_fail_links(req);
 		io_double_put_req(req);
 	}
@@ -5841,11 +5868,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
 
-	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
-		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
-			return -EFAULT;
-		kthread_use_mm(ctx->sqo_mm);
-	}
+	if (unlikely(io_sq_thread_acquire_mm(ctx, req)))
+		return -EFAULT;
 
 	sqe_flags = READ_ONCE(sqe->flags);
 	/* enforce forwards compatibility on users */
@@ -5954,16 +5978,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	return submitted;
 }
 
-static inline void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
-{
-	struct mm_struct *mm = current->mm;
-
-	if (mm) {
-		kthread_unuse_mm(mm);
-		mmput(mm);
-	}
-}
-
 static int io_sq_thread(void *data)
 {
 	struct io_ring_ctx *ctx = data;

