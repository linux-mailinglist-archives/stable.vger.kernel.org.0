Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AD1211282
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 20:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732851AbgGASYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 14:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732836AbgGASYT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 14:24:19 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5387EC08C5C1
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 11:24:19 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id w2so11315200pgg.10
        for <stable@vger.kernel.org>; Wed, 01 Jul 2020 11:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=+1i83bV9dUzPHPtvQm+qVG+MzTh7HwHZQ9E1krWh9OM=;
        b=v5P/Hj566P6OiJuwDMX8lQl6GoE1wVlIwI2gkeozFD9AeF02jpRUdQT3wY5el83yO8
         DEKKyYr6Ctud3dxoEWO93+E8r0V4f+Jb+7FPvuCNqCAcbtPaVpwk6sIj6b0kyZ0eQAEo
         FI1aFL/AiUU86e7jwW2VsTD3Ml6eM3puZbR19ovBL+EqQ0zdX1OtImojztk7foNYVfoN
         EcWSNSOz3ydihuMxvzcPDqoDxymHqik0CjN8rcJRJ1j+WET1vcnEC4U+9C7xkHHKg/GH
         oqoOb6rezJuhCbHSDp+4tgoqRXl0LL+NtqBppTJVk8Mtc1cFLVqcqLevghErIhFHUHmq
         9g4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=+1i83bV9dUzPHPtvQm+qVG+MzTh7HwHZQ9E1krWh9OM=;
        b=hN0r+aFlzJJ1um1yd8HohKap7rsQq8+JPyAzN4rrdJ0JNa3N/gQs4955tpSP25cuii
         ldwb0CCGzUQTrZY1nHmkErInTNBdNzfD920mTdyVR0z2oylHYaW26EeZuUcZ3kZ/W4db
         EO6+TcJmySRQ4eGxCvC8fxhls5KIjycTMOKO0hFGNdnVklS7bSkIbYq50qQXHmfWZkWN
         gxdOt/sBQAmtB2nj8JXK2OEuHRosfYui5YgOCSDJzbvGjP4xPX47ezE0MSLIqY1Oz2iP
         hKhSMULEx4dsQMRUK1+3b/xZejjFx5fWPlnm7hFnYZt7wB6eAvwqZw4eoeWrDRB/cGKi
         2gkA==
X-Gm-Message-State: AOAM533j0HOVHcDuD7cGitng2IQU4XYWjtMTTbSnXsSA9fHxkTQ0WEZx
        JowY6a7qj6lyTr3o0/sPyWSv7w==
X-Google-Smtp-Source: ABdhPJx5RrxLGU4bOkDZUG9Z6hLuocZqRXuf0R8+5SmawWwIUuP62blK0j6n2wW72pe2Yg1EdrgUMA==
X-Received: by 2002:a63:d912:: with SMTP id r18mr21095781pgg.358.1593627858811;
        Wed, 01 Jul 2020 11:24:18 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ab5a:d4e:a03a:d89? ([2605:e000:100e:8c61:ab5a:d4e:a03a:d89])
        by smtp.gmail.com with ESMTPSA id y10sm6386265pfn.121.2020.07.01.11.24.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 11:24:18 -0700 (PDT)
To:     stable@vger.kernel.org
Cc:     "Agarwal, Anchal" <anchalag@amazon.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: Request for patch inclusion for 5.4-stable
Message-ID: <dff7fc38-d2b3-1f7c-88c6-085fb93c7f11@kernel.dk>
Date:   Wed, 1 Jul 2020 12:24:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

There's no upstream variant of this, as that would require backporting
all the io-wq changes from 5.5 and on. Hence I made a one-off that
ensures that we don't leak memory if we have async work items that
need active cancelation (like socket IO).

Can we get this queued up for 5.4? I've tested it and the original
reporter has as well.

From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: make sure async workqueue is canceled on exit

Track async work items that we queue, so we can safely cancel them
if the ring is closed or the process exits. Newer kernels handle
this automatically with io-wq, but the old workqueue based setup needs
a bit of special help to get there.

Reported-by: Agarwal, Anchal <anchalag@amazon.com>
Tested-by: Agarwal, Anchal <anchalag@amazon.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7fa3cd3fff4d..e0200406765c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -267,6 +267,9 @@ struct io_ring_ctx {
 #if defined(CONFIG_UNIX)
 	struct socket		*ring_sock;
 #endif
+
+	struct list_head	task_list;
+	spinlock_t		task_lock;
 };
 
 struct sqe_submit {
@@ -331,14 +334,18 @@ struct io_kiocb {
 #define REQ_F_ISREG		2048	/* regular file */
 #define REQ_F_MUST_PUNT		4096	/* must be punted even for NONBLOCK */
 #define REQ_F_TIMEOUT_NOSEQ	8192	/* no timeout sequence */
+#define REQ_F_CANCEL		16384	/* cancel request */
 	unsigned long		fsize;
 	u64			user_data;
 	u32			result;
 	u32			sequence;
+	struct task_struct	*task;
 
 	struct fs_struct	*fs;
 
 	struct work_struct	work;
+	struct task_struct	*work_task;
+	struct list_head	task_list;
 };
 
 #define IO_PLUG_THRESHOLD		2
@@ -425,6 +432,8 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->cancel_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
+	INIT_LIST_HEAD(&ctx->task_list);
+	spin_lock_init(&ctx->task_lock);
 	return ctx;
 }
 
@@ -492,6 +501,7 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 static inline void io_queue_async_work(struct io_ring_ctx *ctx,
 				       struct io_kiocb *req)
 {
+	unsigned long flags;
 	int rw = 0;
 
 	if (req->submit.sqe) {
@@ -503,6 +513,13 @@ static inline void io_queue_async_work(struct io_ring_ctx *ctx,
 		}
 	}
 
+	req->task = current;
+
+	spin_lock_irqsave(&ctx->task_lock, flags);
+	list_add(&req->task_list, &ctx->task_list);
+	req->work_task = NULL;
+	spin_unlock_irqrestore(&ctx->task_lock, flags);
+
 	queue_work(ctx->sqo_wq[rw], &req->work);
 }
 
@@ -2201,6 +2218,8 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 
 	old_cred = override_creds(ctx->creds);
 	async_list = io_async_list_from_sqe(ctx, req->submit.sqe);
+
+	allow_kernel_signal(SIGINT);
 restart:
 	do {
 		struct sqe_submit *s = &req->submit;
@@ -2232,6 +2251,12 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 		}
 
 		if (!ret) {
+			req->work_task = current;
+			if (req->flags & REQ_F_CANCEL) {
+				ret = -ECANCELED;
+				goto end_req;
+			}
+
 			s->has_user = cur_mm != NULL;
 			s->needs_lock = true;
 			do {
@@ -2246,6 +2271,12 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 					break;
 				cond_resched();
 			} while (1);
+end_req:
+			if (!list_empty(&req->task_list)) {
+				spin_lock_irq(&ctx->task_lock);
+				list_del_init(&req->task_list);
+				spin_unlock_irq(&ctx->task_lock);
+			}
 		}
 
 		/* drop submission reference */
@@ -2311,6 +2342,7 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 	}
 
 out:
+	disallow_signal(SIGINT);
 	if (cur_mm) {
 		set_fs(old_fs);
 		unuse_mm(cur_mm);
@@ -3675,12 +3707,32 @@ static int io_uring_fasync(int fd, struct file *file, int on)
 	return fasync_helper(fd, file, on, &ctx->cq_fasync);
 }
 
+static void io_cancel_async_work(struct io_ring_ctx *ctx,
+				 struct task_struct *task)
+{
+	if (list_empty(&ctx->task_list))
+		return;
+
+	spin_lock_irq(&ctx->task_lock);
+	while (!list_empty(&ctx->task_list)) {
+		struct io_kiocb *req;
+
+		req = list_first_entry(&ctx->task_list, struct io_kiocb, task_list);
+		list_del_init(&req->task_list);
+		req->flags |= REQ_F_CANCEL;
+		if (req->work_task && (!task || req->task == task))
+			send_sig(SIGINT, req->work_task, 1);
+	}
+	spin_unlock_irq(&ctx->task_lock);
+}
+
 static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);
 	mutex_unlock(&ctx->uring_lock);
 
+	io_cancel_async_work(ctx, NULL);
 	io_kill_timeouts(ctx);
 	io_poll_remove_all(ctx);
 	io_iopoll_reap_events(ctx);
@@ -3688,6 +3740,16 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	io_ring_ctx_free(ctx);
 }
 
+static int io_uring_flush(struct file *file, void *data)
+{
+	struct io_ring_ctx *ctx = file->private_data;
+
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
+		io_cancel_async_work(ctx, current);
+
+	return 0;
+}
+
 static int io_uring_release(struct inode *inode, struct file *file)
 {
 	struct io_ring_ctx *ctx = file->private_data;
@@ -3792,6 +3854,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 
 static const struct file_operations io_uring_fops = {
 	.release	= io_uring_release,
+	.flush		= io_uring_flush,
 	.mmap		= io_uring_mmap,
 	.poll		= io_uring_poll,
 	.fasync		= io_uring_fasync,


-- 
Jens Axboe

