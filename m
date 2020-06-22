Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB539203EAA
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 20:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbgFVSCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 14:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730080AbgFVSC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 14:02:29 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987F0C061573
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 11:02:29 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t6so697642pgq.1
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 11:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=y2FlN7bmcFoKrZFWoJRXEOZ70PSp+gd52GKb1/ceiRQ=;
        b=xWMQgtc4haIoOOJX4T3BmLbHtKvzyWmD4wDYASBPdlgA7qBqdSorFjTvNxDymJSGJm
         pa1h5kyxcHlHWXVKES17lfRRGXeiRY8TPqS5rRktmWucGCxZA8WafWOyAJ7uF6dG+QSK
         TjgcF1zbRNJrfB5oRRLiXyi293IkrIhbrzR5XBqGBiDzvUDqsWN8+P4zbdzSzd1D2BcI
         d87qJ9JY50HtKDDYOkcq3Kcpc5nYDyOd4+BSQEgJgp7rZR4aEMwCkVAZW1AtA1IlEmCN
         kgT92F7uNwYiwYoQ61D4gzS9sOYekybuz1b1bzQ8xrh/uNcycbLPVLIoYvCHhWpVWypt
         DyLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=y2FlN7bmcFoKrZFWoJRXEOZ70PSp+gd52GKb1/ceiRQ=;
        b=SzTcXc+nq6reYrMrx8jw1PeFg2F34oBnkUVXLZfaWsbMSACkBlna3saDZxyz0A/rrI
         nVCNPTh7tHIIG8ZXUVRw9rl3eEB5+Haw6mSmNZ5VfvhDSRjpLjY3/0SX6U4Kt+2eLqMK
         ocxXs3ryOiYJDK/NlqCvdcgGuk6b0xLV/aFP1NOHI9jVzR4dNN88Yjg1ygtSF6XaJDpM
         pnFkhMPeXjgBFocu+bhuNjrQsC5tUjHQfev1J9tKKq44l2Dk3brhhT1bj/N2E1Kb4JeP
         z20v0M2ro2uFEsCuLuR342gXc6AUiwWM4YpIY2+/f4hE8FmTkvxRzFQ+eF1W6kAhvsQ3
         1MMw==
X-Gm-Message-State: AOAM533vQywg93GV40gxlCrGQxJMYwAtynWAnbaTi+Eam6MW5m0/I3pU
        4S7NunzeBVOhrlRxcgWXW0WzuKVhmcE=
X-Google-Smtp-Source: ABdhPJxFm4TcxagWU8jx8gKcPJ7KTGpcslWGLvf3bF2/9XY10PrtCACWhIHxQaLP5AGEceGupI8o4g==
X-Received: by 2002:a63:f316:: with SMTP id l22mr13385135pgh.291.1592848948795;
        Mon, 22 Jun 2020 11:02:28 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p14sm178632pjf.32.2020.06.22.11.02.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 11:02:27 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: add memory barrier to
 synchronize io_kiocb's result" failed to apply to 5.7-stable tree
To:     gregkh@linuxfoundation.org, xiaoguang.wang@linux.alibaba.com
Cc:     stable@vger.kernel.org
References: <15928481127127@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <436198de-3cba-5587-2f0f-a92185d9ee6f@kernel.dk>
Date:   Mon, 22 Jun 2020 12:02:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <15928481127127@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------7311F84FB604C65BC0E0D39D"
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------7311F84FB604C65BC0E0D39D
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 6/22/20 11:48 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.7-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I took a look at the queue, and here's this one and the next two you
reported that didn't apply.

There's also a few more, I grabbed them as well. So could you just
queue up these 6 for the next 5.7-stable? Thanks!

-- 
Jens Axboe


--------------7311F84FB604C65BC0E0D39D
Content-Type: text/x-patch; charset=UTF-8;
 name="0006-io_uring-fix-possible-race-condition-against-REQ_F_N.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0006-io_uring-fix-possible-race-condition-against-REQ_F_N.pa";
 filename*1="tch"

From 20584c206cf55be72e3e2044d651429b128c09c3 Mon Sep 17 00:00:00 2001
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Date: Thu, 18 Jun 2020 15:01:56 +0800
Subject: [PATCH 6/6] io_uring: fix possible race condition against
 REQ_F_NEED_CLEANUP

In io_read() or io_write(), when io request is submitted successfully,
it'll go through the below sequence:

    kfree(iovec);
    req->flags &= ~REQ_F_NEED_CLEANUP;
    return ret;

But clearing REQ_F_NEED_CLEANUP might be unsafe. The io request may
already have been completed, and then io_complete_rw_iopoll()
and io_complete_rw() will be called, both of which will also modify
req->flags if needed. This causes a race condition, with concurrent
non-atomic modification of req->flags.

To eliminate this race, in io_read() or io_write(), if io request is
submitted successfully, we don't remove REQ_F_NEED_CLEANUP flag. If
REQ_F_NEED_CLEANUP is set, we'll leave __io_req_aux_free() to the
iovec cleanup work correspondingly.

Cc: stable@vger.kernel.org
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 72a740c25223..1829be7f63a3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2614,8 +2614,8 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 		}
 	}
 out_free:
-	kfree(iovec);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (!(req->flags & REQ_F_NEED_CLEANUP))
+		kfree(iovec);
 	return ret;
 }
 
@@ -2737,8 +2737,8 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 		}
 	}
 out_free:
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-	kfree(iovec);
+	if (!(req->flags & REQ_F_NEED_CLEANUP))
+		kfree(iovec);
 	return ret;
 }
 
-- 
2.27.0


--------------7311F84FB604C65BC0E0D39D
Content-Type: text/x-patch; charset=UTF-8;
 name="0005-io_uring-reap-poll-completions-while-waiting-for-ref.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0005-io_uring-reap-poll-completions-while-waiting-for-ref.pa";
 filename*1="tch"

From 8cb51614f1d755b769cd042ce78a13bd6efef447 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Wed, 17 Jun 2020 15:00:04 -0600
Subject: [PATCH 5/6] io_uring: reap poll completions while waiting for refs to
 drop on exit

If we're doing polled IO and end up having requests being submitted
async, then completions can come in while we're waiting for refs to
drop. We need to reap these manually, as nobody else will be looking
for them.

Break the wait into 1/20th of a second time waits, and check for done
poll completions if we time out. Otherwise we can have done poll
completions sitting in ctx->poll_list, which needs us to reap them but
we're just waiting for them.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5e0c25d6a525..72a740c25223 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7404,7 +7404,17 @@ static void io_ring_exit_work(struct work_struct *work)
 	if (ctx->rings)
 		io_cqring_overflow_flush(ctx, true);
 
-	wait_for_completion(&ctx->completions[0]);
+	/*
+	 * If we're doing polled IO and end up having requests being
+	 * submitted async (out-of-line), then completions can come in while
+	 * we're waiting for refs to drop. We need to reap these manually,
+	 * as nobody else will be looking for them.
+	 */
+	while (!wait_for_completion_timeout(&ctx->completions[0], HZ/20)) {
+		io_iopoll_reap_events(ctx);
+		if (ctx->rings)
+			io_cqring_overflow_flush(ctx, true);
+	}
 	io_ring_ctx_free(ctx);
 }
 
-- 
2.27.0


--------------7311F84FB604C65BC0E0D39D
Content-Type: text/x-patch; charset=UTF-8;
 name="0004-io_uring-acquire-mm-for-task_work-for-SQPOLL.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0004-io_uring-acquire-mm-for-task_work-for-SQPOLL.patch"

From b0c4c8fcfaa102427952a67efc8684644847c217 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 16 Jun 2020 18:42:49 -0600
Subject: [PATCH 4/6] io_uring: acquire 'mm' for task_work for SQPOLL

If we're unlucky with timing, we could be running task_work after
having dropped the memory context in the sq thread. Since dropping
the context requires a runnable task state, we cannot reliably drop
it as part of our check-for-work loop in io_sq_thread(). Instead,
abstract out the mm acquire for the sq thread into a helper, and call
it from the async task work handler.

Cc: stable@vger.kernel.org # v5.7
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 53a06e41f960..5e0c25d6a525 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4302,6 +4302,28 @@ static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
 	__io_queue_proc(&pt->req->apoll->poll, pt, head);
 }
 
+static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
+{
+	struct mm_struct *mm = current->mm;
+
+	if (mm) {
+		unuse_mm(mm);
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
+		use_mm(ctx->sqo_mm);
+	}
+
+	return 0;
+}
+
 static void io_async_task_func(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
@@ -4333,12 +4355,17 @@ static void io_async_task_func(struct callback_head *cb)
 	if (canceled) {
 		kfree(apoll);
 		io_cqring_ev_posted(ctx);
+end_req:
 		req_set_fail_links(req);
 		io_double_put_req(req);
 		return;
 	}
 
 	__set_current_state(TASK_RUNNING);
+	if (io_sq_thread_acquire_mm(ctx, req)) {
+		io_cqring_add_event(req, -EFAULT);
+		goto end_req;
+	}
 	mutex_lock(&ctx->uring_lock);
 	__io_queue_sqe(req, NULL);
 	mutex_unlock(&ctx->uring_lock);
@@ -5897,11 +5924,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
 
-	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
-		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
-			return -EFAULT;
-		use_mm(ctx->sqo_mm);
-	}
+	if (unlikely(io_sq_thread_acquire_mm(ctx, req)))
+		return -EFAULT;
 
 	sqe_flags = READ_ONCE(sqe->flags);
 	/* enforce forwards compatibility on users */
@@ -6011,16 +6035,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	return submitted;
 }
 
-static inline void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
-{
-	struct mm_struct *mm = current->mm;
-
-	if (mm) {
-		unuse_mm(mm);
-		mmput(mm);
-	}
-}
-
 static int io_sq_thread(void *data)
 {
 	struct io_ring_ctx *ctx = data;
-- 
2.27.0


--------------7311F84FB604C65BC0E0D39D
Content-Type: text/x-patch; charset=UTF-8;
 name="0003-io_uring-add-memory-barrier-to-synchronize-io_kiocb-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-io_uring-add-memory-barrier-to-synchronize-io_kiocb-.pa";
 filename*1="tch"

From 2520fd36e8f584318ffcdef624e3541e440d0319 Mon Sep 17 00:00:00 2001
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Date: Tue, 16 Jun 2020 02:06:38 +0800
Subject: [PATCH 3/6] io_uring: add memory barrier to synchronize io_kiocb's
 result and iopoll_completed

In io_complete_rw_iopoll(), stores to io_kiocb's result and iopoll
completed are two independent store operations, to ensure that once
iopoll_completed is ture and then req->result must been perceived by
the cpu executing io_do_iopoll(), proper memory barrier should be used.

And in io_do_iopoll(), we check whether req->result is EAGAIN, if it is,
we'll need to issue this io request using io-wq again. In order to just
issue a single smp_rmb() on the completion side, move the re-submit work
to io_iopoll_complete().

Cc: stable@vger.kernel.org
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
[axboe: don't set ->iopoll_completed for -EAGAIN retry]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 53 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9cac93ab9a88..53a06e41f960 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1690,6 +1690,18 @@ static int io_put_kbuf(struct io_kiocb *req)
 	return cflags;
 }
 
+static void io_iopoll_queue(struct list_head *again)
+{
+	struct io_kiocb *req;
+
+	do {
+		req = list_first_entry(again, struct io_kiocb, list);
+		list_del(&req->list);
+		refcount_inc(&req->refs);
+		io_queue_async_work(req);
+	} while (!list_empty(again));
+}
+
 /*
  * Find and free completed poll iocbs
  */
@@ -1698,12 +1710,21 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 {
 	struct req_batch rb;
 	struct io_kiocb *req;
+	LIST_HEAD(again);
+
+	/* order with ->result store in io_complete_rw_iopoll() */
+	smp_rmb();
 
 	rb.to_free = rb.need_iter = 0;
 	while (!list_empty(done)) {
 		int cflags = 0;
 
 		req = list_first_entry(done, struct io_kiocb, list);
+		if (READ_ONCE(req->result) == -EAGAIN) {
+			req->iopoll_completed = 0;
+			list_move_tail(&req->list, &again);
+			continue;
+		}
 		list_del(&req->list);
 
 		if (req->flags & REQ_F_BUFFER_SELECTED)
@@ -1721,18 +1742,9 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	if (ctx->flags & IORING_SETUP_SQPOLL)
 		io_cqring_ev_posted(ctx);
 	io_free_req_many(ctx, &rb);
-}
-
-static void io_iopoll_queue(struct list_head *again)
-{
-	struct io_kiocb *req;
 
-	do {
-		req = list_first_entry(again, struct io_kiocb, list);
-		list_del(&req->list);
-		refcount_inc(&req->refs);
-		io_queue_async_work(req);
-	} while (!list_empty(again));
+	if (!list_empty(&again))
+		io_iopoll_queue(&again);
 }
 
 static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
@@ -1740,7 +1752,6 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 {
 	struct io_kiocb *req, *tmp;
 	LIST_HEAD(done);
-	LIST_HEAD(again);
 	bool spin;
 	int ret;
 
@@ -1766,13 +1777,6 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		if (!list_empty(&done))
 			break;
 
-		if (req->result == -EAGAIN) {
-			list_move_tail(&req->list, &again);
-			continue;
-		}
-		if (!list_empty(&again))
-			break;
-
 		ret = kiocb->ki_filp->f_op->iopoll(kiocb, spin);
 		if (ret < 0)
 			break;
@@ -1785,9 +1789,6 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	if (!list_empty(&done))
 		io_iopoll_complete(ctx, nr_events, &done);
 
-	if (!list_empty(&again))
-		io_iopoll_queue(&again);
-
 	return ret;
 }
 
@@ -1938,9 +1939,13 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 
 	if (res != -EAGAIN && res != req->result)
 		req_set_fail_links(req);
-	req->result = res;
-	if (res != -EAGAIN)
+
+	WRITE_ONCE(req->result, res);
+	/* order with io_poll_complete() checking ->result */
+	if (res != -EAGAIN) {
+		smp_wmb();
 		WRITE_ONCE(req->iopoll_completed, 1);
+	}
 }
 
 /*
-- 
2.27.0


--------------7311F84FB604C65BC0E0D39D
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-don-t-fail-links-for-EAGAIN-error-in-IOPOLL.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-io_uring-don-t-fail-links-for-EAGAIN-error-in-IOPOLL.pa";
 filename*1="tch"

From 0dabf1589b423c126118c6bb81adfa6fcd4b9da9 Mon Sep 17 00:00:00 2001
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Date: Tue, 16 Jun 2020 02:06:37 +0800
Subject: [PATCH 2/6] io_uring: don't fail links for EAGAIN error in IOPOLL
 mode

In IOPOLL mode, for EAGAIN error, we'll try to submit io request
again using io-wq, so don't fail rest of links if this io request
has links.

Cc: stable@vger.kernel.org
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ed79f92184ff..9cac93ab9a88 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1936,7 +1936,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
 
-	if (res != req->result)
+	if (res != -EAGAIN && res != req->result)
 		req_set_fail_links(req);
 	req->result = res;
 	if (res != -EAGAIN)
-- 
2.27.0


--------------7311F84FB604C65BC0E0D39D
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-fix-io_kiocb.flags-modification-race-in-IOP.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io_uring-fix-io_kiocb.flags-modification-race-in-IOP.pa";
 filename*1="tch"

From 1061792a4314299195d9e183320f85c860d61e38 Mon Sep 17 00:00:00 2001
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Date: Thu, 11 Jun 2020 23:39:36 +0800
Subject: [PATCH 1/6] io_uring: fix io_kiocb.flags modification race in IOPOLL
 mode

While testing io_uring in arm, we found sometimes io_sq_thread() keeps
polling io requests even though there are not inflight io requests in
block layer. After some investigations, found a possible race about
io_kiocb.flags, see below race codes:
  1) in the end of io_write() or io_read()
    req->flags &= ~REQ_F_NEED_CLEANUP;
    kfree(iovec);
    return ret;

  2) in io_complete_rw_iopoll()
    if (res != -EAGAIN)
        req->flags |= REQ_F_IOPOLL_COMPLETED;

In IOPOLL mode, io requests still maybe completed by interrupt, then
above codes are not safe, concurrent modifications to req->flags, which
is not protected by lock or is not atomic modifications. I also had
disassemble io_complete_rw_iopoll() in arm:
   req->flags |= REQ_F_IOPOLL_COMPLETED;
   0xffff000008387b18 <+76>:    ldr     w0, [x19,#104]
   0xffff000008387b1c <+80>:    orr     w0, w0, #0x1000
   0xffff000008387b20 <+84>:    str     w0, [x19,#104]

Seems that the "req->flags |= REQ_F_IOPOLL_COMPLETED;" is  load and
modification, two instructions, which obviously is not atomic.

To fix this issue, add a new iopoll_completed in io_kiocb to indicate
whether io request is completed.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2698e9b08490..ed79f92184ff 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -513,7 +513,6 @@ enum {
 	REQ_F_INFLIGHT_BIT,
 	REQ_F_CUR_POS_BIT,
 	REQ_F_NOWAIT_BIT,
-	REQ_F_IOPOLL_COMPLETED_BIT,
 	REQ_F_LINK_TIMEOUT_BIT,
 	REQ_F_TIMEOUT_BIT,
 	REQ_F_ISREG_BIT,
@@ -556,8 +555,6 @@ enum {
 	REQ_F_CUR_POS		= BIT(REQ_F_CUR_POS_BIT),
 	/* must not punt to workers */
 	REQ_F_NOWAIT		= BIT(REQ_F_NOWAIT_BIT),
-	/* polled IO has completed */
-	REQ_F_IOPOLL_COMPLETED	= BIT(REQ_F_IOPOLL_COMPLETED_BIT),
 	/* has linked timeout */
 	REQ_F_LINK_TIMEOUT	= BIT(REQ_F_LINK_TIMEOUT_BIT),
 	/* timeout request */
@@ -618,6 +615,8 @@ struct io_kiocb {
 	int				cflags;
 	bool				needs_fixed_file;
 	u8				opcode;
+	/* polled IO has completed */
+	u8				iopoll_completed;
 
 	u16				buf_index;
 
@@ -1760,7 +1759,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		 * If we find a request that requires polling, break out
 		 * and complete those lists first, if we have entries there.
 		 */
-		if (req->flags & REQ_F_IOPOLL_COMPLETED) {
+		if (READ_ONCE(req->iopoll_completed)) {
 			list_move_tail(&req->list, &done);
 			continue;
 		}
@@ -1941,7 +1940,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 		req_set_fail_links(req);
 	req->result = res;
 	if (res != -EAGAIN)
-		req->flags |= REQ_F_IOPOLL_COMPLETED;
+		WRITE_ONCE(req->iopoll_completed, 1);
 }
 
 /*
@@ -1974,7 +1973,7 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 	 * For fast devices, IO may have already completed. If it has, add
 	 * it to the front so we find it first.
 	 */
-	if (req->flags & REQ_F_IOPOLL_COMPLETED)
+	if (READ_ONCE(req->iopoll_completed))
 		list_add(&req->list, &ctx->poll_list);
 	else
 		list_add_tail(&req->list, &ctx->poll_list);
@@ -2098,6 +2097,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->result = 0;
+		req->iopoll_completed = 0;
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;
-- 
2.27.0


--------------7311F84FB604C65BC0E0D39D--
