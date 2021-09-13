Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE414097E6
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235334AbhIMPx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245530AbhIMPxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:53:18 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B548C06121D
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 08:49:08 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id i13so10585525ilm.4
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 08:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language;
        bh=C2byiOCKk/5GsaJzAKK9Vv7lHUIwoAfVPt6VmG45Zms=;
        b=mNC1PJpW1bJfOQHi0Jw/+iwnl3Vfa0a3efotx/2SZjLW2Saxr4o6yDY1HoI+LEjW3H
         F7rviy5KOGI3IAgdbQgaBxssEHFzTwH7iaPVLxCqF782u12HBNSg44Z7zRge2QLKYKuk
         A3bHT0kpLnoGExBrjIOpJOU+4+T3IFheyhlqIteugSVMcNrCLb9ogD6Wqae7hxKfMXK2
         CPB5KoD/8vvBQ1ccedjJEiod6HGmpbHyLDTCP3MqqFLd0MHDdJ0Kt6nN+vRQy6xpwIgt
         D5vLjeyz5pjJjvMPZCMuqzYbVvz+GRy+GyF2UjXVaAVV8P2tSoV8IZzw8dUDIIAjtdbJ
         6spQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language;
        bh=C2byiOCKk/5GsaJzAKK9Vv7lHUIwoAfVPt6VmG45Zms=;
        b=fzcTa/GtEetoMhcSsoPsPWQcSGigOVqH4CEfXtGXegtDEjtCnntIKxUtgBZplFXG/Y
         VPjUiC9496CQI5BBhoyYjwFr7Nku55lcNodZs7fRa5CbbcKCLlzmqk6pcXu7M2lGxdHM
         C0CVbxQYBL2lS/kPg1W1YilMQcqmlY5yqtL89rQAbpHh7Vp1s/F/Sh11bol8G4AdWWQ1
         eYmHchz95ON6ubrjp/ypdmmkb7l/e9ZtAE/bCTtk4Sybn9wmabY7lYN81DJrRWv0tJ9r
         yQ4cfsTr9OOJmGLLqNLce1GDTm16H4RxTUXMJA1jz0jpFRjppcajwOizjQaFh5VFtUZT
         ZAbQ==
X-Gm-Message-State: AOAM532fjkIHTxcZk2vfYK1h4G1XGd1/8dJX3zyCEAPdG8jDAdjd+y4w
        X1p7EYib8G6sB5qSETgkJBsHhQ==
X-Google-Smtp-Source: ABdhPJxEOJvClAxxHatG/O2/fU5X2kbzd6ZGUG7PcacQxKv2FO3Hd65schaIQfMLq8Qrr7gsgvv3AA==
X-Received: by 2002:a92:d382:: with SMTP id o2mr226958ilo.67.1631548147889;
        Mon, 13 Sep 2021 08:49:07 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a14sm4753164iol.24.2021.09.13.08.49.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 08:49:06 -0700 (PDT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: 5.10 stable backports
Message-ID: <81a1f0ea-d875-8cce-6ac1-3307a656bb92@kernel.dk>
Date:   Mon, 13 Sep 2021 09:49:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------B9A62DF32A5A8E8C1327DE5F"
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------B9A62DF32A5A8E8C1327DE5F
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi Greg,

Looked over the 5.10/13/14 stable failures, and here's the queue for
5.10. I'll be sending 5.13 and 5.14 after this.

-- 
Jens Axboe


--------------B9A62DF32A5A8E8C1327DE5F
Content-Type: text/x-patch; charset=UTF-8;
 name="0005-io-wq-fix-wakeup-race-when-adding-new-work.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0005-io-wq-fix-wakeup-race-when-adding-new-work.patch"

From ae58d41926480c2d1ab4be66821f5b87342ce2be Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 13 Sep 2021 09:20:44 -0600
Subject: [PATCH 5/5] io-wq: fix wakeup race when adding new work

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
index 8bb17b6d4de3..3d5fc76b92d0 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -895,7 +895,7 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
-	int work_flags;
+	bool do_wake;
 	unsigned long flags;
 
 	/*
@@ -909,14 +909,14 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
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


--------------B9A62DF32A5A8E8C1327DE5F
Content-Type: text/x-patch; charset=UTF-8;
 name="0004-io_uring-fail-links-of-cancelled-timeouts.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0004-io_uring-fail-links-of-cancelled-timeouts.patch"

From a1159e56c3cc4ff006b948f112d348e288b5d150 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 13 Sep 2021 09:45:41 -0600
Subject: [PATCH 4/5] io_uring: fail links of cancelled timeouts

commit 2ae2eb9dde18979b40629dd413b9adbd6c894cdf upstream.

When we cancel a timeout we should mark it with REQ_F_FAIL, so
linked requests are cancelled as well, but not queued for further
execution.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/fff625b44eeced3a5cae79f60e6acf3fbdf8f990.1631192135.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dd847d8e79e6..6978a42fa39b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1498,6 +1498,8 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 
 	ret = hrtimer_try_to_cancel(&io->timer);
 	if (ret != -1) {
+		if (status)
+			req_set_fail_links(req);
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-- 
2.33.0


--------------B9A62DF32A5A8E8C1327DE5F
Content-Type: text/x-patch; charset=UTF-8;
 name="0003-io_uring-add-splice_fd_in-checks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003-io_uring-add-splice_fd_in-checks.patch"

From fc5457ea3350543334960bfc4d0d45563d6e6f7d Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 13 Sep 2021 09:42:47 -0600
Subject: [PATCH 3/5] io_uring: add ->splice_fd_in checks

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
 fs/io_uring.c | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 195e26a78597..dd847d8e79e6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3746,7 +3746,8 @@ static int io_prep_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
+		     sqe->splice_fd_in))
 		return -EINVAL;
 
 	req->sync.flags = READ_ONCE(sqe->fsync_flags);
@@ -3779,7 +3780,8 @@ static int io_fsync(struct io_kiocb *req, bool force_nonblock)
 static int io_fallocate_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
-	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags)
+	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -3810,7 +3812,7 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	const char __user *fname;
 	int ret;
 
-	if (unlikely(sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->ioprio || sqe->buf_index || sqe->splice_fd_in))
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -3926,7 +3928,8 @@ static int io_remove_buffers_prep(struct io_kiocb *req,
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
-	if (sqe->ioprio || sqe->rw_flags || sqe->addr || sqe->len || sqe->off)
+	if (sqe->ioprio || sqe->rw_flags || sqe->addr || sqe->len || sqe->off ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 
 	tmp = READ_ONCE(sqe->fd);
@@ -4002,7 +4005,7 @@ static int io_provide_buffers_prep(struct io_kiocb *req,
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
-	if (sqe->ioprio || sqe->rw_flags)
+	if (sqe->ioprio || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
 
 	tmp = READ_ONCE(sqe->fd);
@@ -4095,7 +4098,7 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_EPOLL)
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL)))
 		return -EINVAL;
@@ -4141,7 +4144,7 @@ static int io_epoll_ctl(struct io_kiocb *req, bool force_nonblock,
 static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
-	if (sqe->ioprio || sqe->buf_index || sqe->off)
+	if (sqe->ioprio || sqe->buf_index || sqe->off || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4176,7 +4179,7 @@ static int io_madvise(struct io_kiocb *req, bool force_nonblock)
 
 static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	if (sqe->ioprio || sqe->buf_index || sqe->addr)
+	if (sqe->ioprio || sqe->buf_index || sqe->addr || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4214,7 +4217,7 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
@@ -4261,7 +4264,7 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
-	    sqe->rw_flags || sqe->buf_index)
+	    sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
@@ -4317,7 +4320,8 @@ static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
+		     sqe->splice_fd_in))
 		return -EINVAL;
 
 	req->sync.off = READ_ONCE(sqe->off);
@@ -4760,7 +4764,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index)
+	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 
 	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -4801,7 +4805,8 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags)
+	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 
 	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -5553,7 +5558,8 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->timeout_flags)
+	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->timeout_flags |
+	    sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->timeout_rem.addr = READ_ONCE(sqe->addr);
@@ -5590,7 +5596,8 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len != 1)
+	if (sqe->ioprio || sqe->buf_index || sqe->len != 1 ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 	if (off && is_timeout_link)
 		return -EINVAL;
@@ -5734,7 +5741,8 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags)
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->cancel.addr = READ_ONCE(sqe->addr);
-- 
2.33.0


--------------B9A62DF32A5A8E8C1327DE5F
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-limit-fixed-table-size-by-RLIMIT_NOFILE.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io_uring-limit-fixed-table-size-by-RLIMIT_NOFILE.patch"

From b04cf18255722339e4d1f51389bd842991322b73 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 13 Sep 2021 09:35:35 -0600
Subject: [PATCH 1/5] io_uring: limit fixed table size by RLIMIT_NOFILE

Limit the number of files in io_uring fixed tables by RLIMIT_NOFILE,
that's the first and the simpliest restriction that we should impose.

Cc: stable@vger.kernel.org
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b2756c340aed7d6c0b302c26dab50c6c5907f4ce.1629451684.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2009d1cda606..0db463599b00 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7579,6 +7579,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (nr_args > IORING_MAX_FIXED_FILES)
 		return -EMFILE;
+	if (nr_args > rlimit(RLIMIT_NOFILE))
+		return -EMFILE;
 
 	file_data = kzalloc(sizeof(*ctx->file_data), GFP_KERNEL);
 	if (!file_data)
-- 
2.33.0


--------------B9A62DF32A5A8E8C1327DE5F
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-place-fixed-tables-under-memcg-limits.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-io_uring-place-fixed-tables-under-memcg-limits.patch"

From c9601223060822df70df4014e339faff21b20eb6 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 13 Sep 2021 09:37:00 -0600
Subject: [PATCH 2/5] io_uring: place fixed tables under memcg limits

commit 0bea96f59ba40e63c0ae93ad6a02417b95f22f4d upstream.

Fixed tables may be large enough, place all of them together with
allocated tags under memcg limits.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b3ac9f5da9821bb59837b5fe25e8ef4be982218c.1629451684.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0db463599b00..195e26a78597 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7383,7 +7383,7 @@ static int io_sqe_alloc_file_tables(struct fixed_file_data *file_data,
 
 		this_files = min(nr_files, IORING_MAX_FILES_TABLE);
 		table->files = kcalloc(this_files, sizeof(struct file *),
-					GFP_KERNEL);
+					GFP_KERNEL_ACCOUNT);
 		if (!table->files)
 			break;
 		nr_files -= this_files;
@@ -7582,7 +7582,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (nr_args > rlimit(RLIMIT_NOFILE))
 		return -EMFILE;
 
-	file_data = kzalloc(sizeof(*ctx->file_data), GFP_KERNEL);
+	file_data = kzalloc(sizeof(*ctx->file_data), GFP_KERNEL_ACCOUNT);
 	if (!file_data)
 		return -ENOMEM;
 	file_data->ctx = ctx;
@@ -7592,7 +7592,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
 	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
-				   GFP_KERNEL);
+				   GFP_KERNEL_ACCOUNT);
 	if (!file_data->table)
 		goto out_free;
 
-- 
2.33.0


--------------B9A62DF32A5A8E8C1327DE5F--
