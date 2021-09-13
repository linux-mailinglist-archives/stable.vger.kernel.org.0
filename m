Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F9A4097EE
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242401AbhIMPxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245074AbhIMPxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:53:33 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC62C06114D
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 08:50:39 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id m4so5574943ilj.9
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 08:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language;
        bh=+fwegjO99JY5CnCYjLgHRRKfbO8ql5YpQLZP1iqZ2JU=;
        b=q587p9YxciWw8qnb5k3byN2LSCdU3xAL/UdDFYkAz25CJsKc5vCjJYL6bnm5dRbwnV
         JsjAdGd7ydek5kVa1ffKu9VI9uU0HQE80t1b/MXKl0+VvBR/09Rd1tL/1CzXtqREpcfk
         Yku2ZOL8UYFdotlojRzQ9FSI95G1anGa01OegwhOT9FFb7kdYaqpzwkJVXMSmLu0cvfx
         Vw5yiZR8rFXhkrOIoYoUAScJND+kQ4AFnIyNaKLMjiQvzLZRC3WyMob5KVyrMaYzcsNE
         4l2vyILpgvZr+f8DWslEQim4brI4b8hMu29QbWx+5ZuG1DUP97pPsJOiLs8PaT38Ijzj
         iobw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language;
        bh=+fwegjO99JY5CnCYjLgHRRKfbO8ql5YpQLZP1iqZ2JU=;
        b=qysB1cIM03R6fwtflZekZD/mAEvos8hf2BO/0/m08hJ/X02cmj/RTq53AdbZGpoluL
         vz0D94/Y4hoNK5YsX6hCB9Ia2xYHs5OQk0izGISUqxcq8BcEIrV1xmF+tgHdN1mdhekS
         0Z1HIcXYiObIYjYWz9XvrVJ8O/a6HAuoPvIbDRRlkzr46u+cHhIHUaBPwgokWLMUzHTz
         FOVX0IZikjM0mN5oPnCpDH/en3t0cguk2dHo+l4ngRbx9bj992xuhRa+FAExhhvGGSbr
         c0NBGNwoOapE/WpmuiNM8PQSZmU00ASOo5GtZRB9ZOwpwP1OwEanYljMy4/XLOBZoOAq
         19Ig==
X-Gm-Message-State: AOAM532cebYL+/MiDZ74abLuoOp2xrngvMBs4HWl5LLCo0/c3ZiSxC4U
        6Egax4wkhd4kFe4oPJJ+MdZFkArA5l3DrO4yv9U=
X-Google-Smtp-Source: ABdhPJzgWwvdUawt0HUjdvZly0jL2gOh1FR/GWSxEFgwb1GlGte8bNza5UsSbF+DwKKqFXxsn6LSWw==
X-Received: by 2002:a05:6e02:804:: with SMTP id u4mr8286149ilm.169.1631548238497;
        Mon, 13 Sep 2021 08:50:38 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g19sm5163780ilb.84.2021.09.13.08.50.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 08:50:37 -0700 (PDT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>, stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: 5.14 stable backports
Message-ID: <b8b7d2ae-ac8c-9758-f57a-af1ae54d4743@kernel.dk>
Date:   Mon, 13 Sep 2021 09:50:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------524C3C1DEAF44A089F0F7F38"
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------524C3C1DEAF44A089F0F7F38
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

And here's the 5.14 queue.

-- 
Jens Axboe


--------------524C3C1DEAF44A089F0F7F38
Content-Type: text/x-patch; charset=UTF-8;
 name="0005-io-wq-fix-race-between-adding-work-and-activating-a-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0005-io-wq-fix-race-between-adding-work-and-activating-a-.pa";
 filename*1="tch"

From f2aae97833ca1c94e96381ea8c571234e244839c Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 13 Sep 2021 09:24:07 -0600
Subject: [PATCH 5/5] io-wq: fix race between adding work and activating a free
 worker

commit 94ffb0a282872c2f4b14f757fa1aef2302aeaabb upstream.

The attempt to find and activate a free worker for new work is currently
combined with creating a new one if we don't find one, but that opens
io-wq up to a race where the worker that is found and activated can
put itself to sleep without knowing that it has been selected to perform
this new work.

Fix this by moving the activation into where we add the new work item,
then we can retain it within the wqe->lock scope and elimiate the race
with the worker itself checking inside the lock, but sleeping outside of
it.

Cc: stable@vger.kernel.org
Reported-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 50 ++++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 22ac9806d215..cb5d84f6b769 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -236,9 +236,9 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe)
  * We need a worker. If we find a free one, we're good. If not, and we're
  * below the max number of workers, create one.
  */
-static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
+static void io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 {
-	bool ret;
+	bool do_create = false, first = false;
 
 	/*
 	 * Most likely an attempt to queue unbounded work on an io_wq that
@@ -247,25 +247,18 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	if (unlikely(!acct->max_workers))
 		pr_warn_once("io-wq is not configured for unbound workers");
 
-	rcu_read_lock();
-	ret = io_wqe_activate_free_worker(wqe);
-	rcu_read_unlock();
-
-	if (!ret) {
-		bool do_create = false, first = false;
-
-		raw_spin_lock_irq(&wqe->lock);
-		if (acct->nr_workers < acct->max_workers) {
-			atomic_inc(&acct->nr_running);
-			atomic_inc(&wqe->wq->worker_refs);
-			if (!acct->nr_workers)
-				first = true;
-			acct->nr_workers++;
-			do_create = true;
-		}
-		raw_spin_unlock_irq(&wqe->lock);
-		if (do_create)
-			create_io_worker(wqe->wq, wqe, acct->index, first);
+	raw_spin_lock_irq(&wqe->lock);
+	if (acct->nr_workers < acct->max_workers) {
+		if (!acct->nr_workers)
+			first = true;
+		acct->nr_workers++;
+		do_create = true;
+	}
+	raw_spin_unlock_irq(&wqe->lock);
+	if (do_create) {
+		atomic_inc(&acct->nr_running);
+		atomic_inc(&wqe->wq->worker_refs);
+		create_io_worker(wqe->wq, wqe, acct->index, first);
 	}
 }
 
@@ -793,7 +786,8 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
-	bool do_wake;
+	unsigned work_flags = work->flags;
+	bool do_create;
 	unsigned long flags;
 
 	/*
@@ -809,12 +803,16 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	raw_spin_lock_irqsave(&wqe->lock, flags);
 	io_wqe_insert_work(wqe, work);
 	wqe->flags &= ~IO_WQE_FLAG_STALLED;
-	do_wake = (work->flags & IO_WQ_WORK_CONCURRENT) ||
-			!atomic_read(&acct->nr_running);
+
+	rcu_read_lock();
+	do_create = !io_wqe_activate_free_worker(wqe);
+	rcu_read_unlock();
+
 	raw_spin_unlock_irqrestore(&wqe->lock, flags);
 
-	if (do_wake)
-		io_wqe_wake_worker(wqe, acct);
+	if (do_create && ((work_flags & IO_WQ_WORK_CONCURRENT) ||
+	    !atomic_read(&acct->nr_running)))
+		io_wqe_create_worker(wqe, acct);
 }
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
-- 
2.33.0


--------------524C3C1DEAF44A089F0F7F38
Content-Type: text/x-patch; charset=UTF-8;
 name="0004-io-wq-fix-wakeup-race-when-adding-new-work.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0004-io-wq-fix-wakeup-race-when-adding-new-work.patch"

From 91e5ca518691d8783db0580cc64f487acf8cde4a Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 13 Sep 2021 09:20:44 -0600
Subject: [PATCH 4/5] io-wq: fix wakeup race when adding new work

commit 87df7fb922d18e96992aa5e824aa34b2065fef59 upstream.

When new work is added, io_wqe_enqueue() checks if we need to wake or
create a new worker. But that check is done outside the lock that
otherwise synchronizes us with a worker going to sleep, so we can end
up in the following situation:

CPU0				CPU1
lock
insert work
unlock
atomic_read(nr_running) != 0
				lock
				atomic_dec(nr_running)
no wakeup needed

Hold the wqe lock around the "need to wakeup" check. Then we can also get
rid of the temporary work_flags variable, as we know the work will remain
valid as long as we hold the lock.

Cc: stable@vger.kernel.org
Reported-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 2cc7f75ff24d..22ac9806d215 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -793,7 +793,7 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
-	int work_flags;
+	bool do_wake;
 	unsigned long flags;
 
 	/*
@@ -806,14 +806,14 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 		return;
 	}
 
-	work_flags = work->flags;
 	raw_spin_lock_irqsave(&wqe->lock, flags);
 	io_wqe_insert_work(wqe, work);
 	wqe->flags &= ~IO_WQE_FLAG_STALLED;
+	do_wake = (work->flags & IO_WQ_WORK_CONCURRENT) ||
+			!atomic_read(&acct->nr_running);
 	raw_spin_unlock_irqrestore(&wqe->lock, flags);
 
-	if ((work_flags & IO_WQ_WORK_CONCURRENT) ||
-	    !atomic_read(&acct->nr_running))
+	if (do_wake)
 		io_wqe_wake_worker(wqe, acct);
 }
 
-- 
2.33.0


--------------524C3C1DEAF44A089F0F7F38
Content-Type: text/x-patch; charset=UTF-8;
 name="0003-io_uring-fix-io_try_cancel_userdata-race-for-iowq.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-io_uring-fix-io_try_cancel_userdata-race-for-iowq.patch"

From fc6a0e5227afc2f4af2f1d4019a27b9cf772417a Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 13 Sep 2021 09:18:44 -0600
Subject: [PATCH 3/5] io_uring: fix io_try_cancel_userdata race for iowq

commit dadebc350da2bef62593b1df007a6e0b90baf42a upstream.

WARNING: CPU: 1 PID: 5870 at fs/io_uring.c:5975 io_try_cancel_userdata+0x30f/0x540 fs/io_uring.c:5975
CPU: 0 PID: 5870 Comm: iou-wrk-5860 Not tainted 5.14.0-rc6-next-20210820-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_try_cancel_userdata+0x30f/0x540 fs/io_uring.c:5975
Call Trace:
 io_async_cancel fs/io_uring.c:6014 [inline]
 io_issue_sqe+0x22d5/0x65a0 fs/io_uring.c:6407
 io_wq_submit_work+0x1dc/0x300 fs/io_uring.c:6511
 io_worker_handle_work+0xa45/0x1840 fs/io-wq.c:533
 io_wqe_worker+0x2cc/0xbb0 fs/io-wq.c:582
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

io_try_cancel_userdata() can be called from io_async_cancel() executing
in the io-wq context, so the warning fires, which is there to alert
anyone accessing task->io_uring->io_wq in a racy way. However,
io_wq_put_and_exit() always first waits for all threads to complete,
so the only detail left is to zero tctx->io_wq after the context is
removed.

note: one little assumption is that when IO_WQ_WORK_CANCEL, the executor
won't touch ->io_wq, because io_wq_destroy() might cancel left pending
requests in such a way.

Cc: stable@vger.kernel.org
Reported-by: syzbot+b0c9d1588ae92866515f@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/dfdd37a80cfa9ffd3e59538929c99cdd55d8699e.1629721757.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0481654767a5..c5d4638f6d7f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6310,6 +6310,7 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	if (timeout)
 		io_queue_linked_timeout(timeout);
 
+	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
 	if (work->flags & IO_WQ_WORK_CANCEL)
 		ret = -ECANCELED;
 
@@ -9137,8 +9138,8 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 		 * Must be after io_uring_del_task_file() (removes nodes under
 		 * uring_lock) to avoid race with io_uring_try_cancel_iowq().
 		 */
-		tctx->io_wq = NULL;
 		io_wq_put_and_exit(wq);
+		tctx->io_wq = NULL;
 	}
 }
 
-- 
2.33.0


--------------524C3C1DEAF44A089F0F7F38
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-add-splice_fd_in-checks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-io_uring-add-splice_fd_in-checks.patch"

From dea7e70df7662387b96d3c48e00832b8fb386f4e Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 13 Sep 2021 09:17:19 -0600
Subject: [PATCH 2/5] io_uring: add ->splice_fd_in checks

commit 26578cda3db983b17cabe4e577af26306beb9987 upstream.

->splice_fd_in is used only by splice/tee, but no other request checks
it for validity. Add the check for most of request types excluding
reads/writes/sends/recvs, we don't want overhead for them and can leave
them be as is until the field is actually used.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f44bc2acd6777d932de3d71a5692235b5b2b7397.1629451684.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 52 +++++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 05004042a7b5..0481654767a5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3484,7 +3484,7 @@ static int io_renameat_prep(struct io_kiocb *req,
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -3535,7 +3535,8 @@ static int io_unlinkat_prep(struct io_kiocb *req,
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index)
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -3581,8 +3582,8 @@ static int io_shutdown_prep(struct io_kiocb *req,
 #if defined(CONFIG_NET)
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->addr || sqe->rw_flags ||
-	    sqe->buf_index)
+	if (unlikely(sqe->ioprio || sqe->off || sqe->addr || sqe->rw_flags ||
+		     sqe->buf_index || sqe->splice_fd_in))
 		return -EINVAL;
 
 	req->shutdown.how = READ_ONCE(sqe->len);
@@ -3730,7 +3731,8 @@ static int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
+		     sqe->splice_fd_in))
 		return -EINVAL;
 
 	req->sync.flags = READ_ONCE(sqe->fsync_flags);
@@ -3763,7 +3765,8 @@ static int io_fsync(struct io_kiocb *req, unsigned int issue_flags)
 static int io_fallocate_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
-	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags)
+	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -3794,7 +3797,7 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	const char __user *fname;
 	int ret;
 
-	if (unlikely(sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->ioprio || sqe->buf_index || sqe->splice_fd_in))
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -3918,7 +3921,8 @@ static int io_remove_buffers_prep(struct io_kiocb *req,
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
-	if (sqe->ioprio || sqe->rw_flags || sqe->addr || sqe->len || sqe->off)
+	if (sqe->ioprio || sqe->rw_flags || sqe->addr || sqe->len || sqe->off ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 
 	tmp = READ_ONCE(sqe->fd);
@@ -3989,7 +3993,7 @@ static int io_provide_buffers_prep(struct io_kiocb *req,
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
-	if (sqe->ioprio || sqe->rw_flags)
+	if (sqe->ioprio || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
 
 	tmp = READ_ONCE(sqe->fd);
@@ -4076,7 +4080,7 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_EPOLL)
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4122,7 +4126,7 @@ static int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
 static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
-	if (sqe->ioprio || sqe->buf_index || sqe->off)
+	if (sqe->ioprio || sqe->buf_index || sqe->off || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4157,7 +4161,7 @@ static int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	if (sqe->ioprio || sqe->buf_index || sqe->addr)
+	if (sqe->ioprio || sqe->buf_index || sqe->addr || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4195,7 +4199,7 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
@@ -4231,7 +4235,7 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
-	    sqe->rw_flags || sqe->buf_index)
+	    sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
@@ -4292,7 +4296,8 @@ static int io_sfr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
+		     sqe->splice_fd_in))
 		return -EINVAL;
 
 	req->sync.off = READ_ONCE(sqe->off);
@@ -4719,7 +4724,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index)
+	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 
 	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -4767,7 +4772,8 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags)
+	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 
 	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -5375,7 +5381,7 @@ static int io_poll_update_prep(struct io_kiocb *req,
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	flags = READ_ONCE(sqe->len);
 	if (flags & ~(IORING_POLL_UPDATE_EVENTS | IORING_POLL_UPDATE_USER_DATA |
@@ -5610,7 +5616,7 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len)
+	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->splice_fd_in)
 		return -EINVAL;
 
 	tr->addr = READ_ONCE(sqe->addr);
@@ -5669,7 +5675,8 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len != 1)
+	if (sqe->ioprio || sqe->buf_index || sqe->len != 1 ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 	if (off && is_timeout_link)
 		return -EINVAL;
@@ -5820,7 +5827,8 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags)
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->cancel.addr = READ_ONCE(sqe->addr);
@@ -5877,7 +5885,7 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
 {
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->rw_flags)
+	if (sqe->ioprio || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->rsrc_update.offset = READ_ONCE(sqe->off);
-- 
2.33.0


--------------524C3C1DEAF44A089F0F7F38
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-place-fixed-tables-under-memcg-limits.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io_uring-place-fixed-tables-under-memcg-limits.patch"

From 02197f21848a054152e64f4bdcf1cdc0b29564b4 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 13 Sep 2021 09:31:43 -0600
Subject: [PATCH 1/5] io_uring: place fixed tables under memcg limits

commit 0bea96f59ba40e63c0ae93ad6a02417b95f22f4d upstream.

Fixed tables may be large enough, place all of them together with
allocated tags under memcg limits.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b3ac9f5da9821bb59837b5fe25e8ef4be982218c.1629451684.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 14bebc62db2d..05004042a7b5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7126,14 +7126,14 @@ static void **io_alloc_page_table(size_t size)
 	size_t init_size = size;
 	void **table;
 
-	table = kcalloc(nr_tables, sizeof(*table), GFP_KERNEL);
+	table = kcalloc(nr_tables, sizeof(*table), GFP_KERNEL_ACCOUNT);
 	if (!table)
 		return NULL;
 
 	for (i = 0; i < nr_tables; i++) {
 		unsigned int this_size = min_t(size_t, size, PAGE_SIZE);
 
-		table[i] = kzalloc(this_size, GFP_KERNEL);
+		table[i] = kzalloc(this_size, GFP_KERNEL_ACCOUNT);
 		if (!table[i]) {
 			io_free_page_table(table, init_size);
 			return NULL;
-- 
2.33.0


--------------524C3C1DEAF44A089F0F7F38--
