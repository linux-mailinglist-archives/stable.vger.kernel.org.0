Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B2B54E62F
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 17:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377428AbiFPPjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 11:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbiFPPjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 11:39:49 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB8724BFD
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 08:39:47 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id s1so1205520ilj.0
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 08:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KfRNo/YwIwNda2KEaxY7ZASDtmqyGAhDFFd/w93Iq8A=;
        b=uxL6QHJuc4aDVQRFoepCzMGwWTr/glxsu25G21BHX8fkeIqydk0ocnhFo0bchmRqFo
         krMLtEXG6SPWO7ajj8rz6dQRyunOyKMT0iPwPJUDTjlVEUGxlMx27dyq63oTNioFZ3RY
         2LxkBDLOroNwazblz5l6XpAeD9zetjxEvywBvLopD1VErGf33D1XtGQAbh0GU1G5JVhS
         UOovDpGhKLnx7SNLFbXAu50NySVJ+s8526Xa1Pdp10OpgHYM2REm/sBByHqyWfmxqQxw
         VzwmzyY4X1H8PGaj0b8NqlGNixZVdKiODNbnW75zyQhP8pjsotpwPcR/IkxLYfZ/dA2W
         rl0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KfRNo/YwIwNda2KEaxY7ZASDtmqyGAhDFFd/w93Iq8A=;
        b=4FJBTPjSqfMXgP8+iIchCvtwu1Ch3sj9ez9sBgnZgOcRad0xDPCl3c89FjpCOF9wGC
         Da2fogQgCemCmxZXcM6HjHg3dQxCSXxpuQRNgHuGDpijm1SgslSjwNUo/roIG29beHlP
         z1vsSCAnmKGxJTbKSKW7TFlBoDTBTyftVAtmEyqlTzqkKpW5duhqLvtd4XANf9S0cZwF
         IcWBgFEYfRwFkgzaHTfUZxvXbFD8O+7eTeCkCrOwDVtM00yv1HZ5clNod+v2/a9B6h5i
         GMKdHc6WA/Zx/MK8Q/7ShHanJ7c1ETMj2JRdT94LAv1xGBO7X7AK/wpJref6/Ay7OBsi
         auow==
X-Gm-Message-State: AJIora+8b/Eso2G0QjFPPQP5IO3XFE9tbeauDnCeYMtvX7sPrgM20rev
        oRzpQlBQjKEuegIeV3mbKPfN2GVGwYGaEg==
X-Google-Smtp-Source: AGRyM1vnX3EFjyTFaX/ht+drxwO+kA87rJSFWYYch2/wcwGMx4UvpUXSErl6qM09Mj/YRY3WFkiGVA==
X-Received: by 2002:a05:6e02:792:b0:2d7:ae5d:e2fd with SMTP id q18-20020a056e02079200b002d7ae5de2fdmr3207921ils.315.1655393986930;
        Thu, 16 Jun 2022 08:39:46 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q81-20020a6b8e54000000b006657596977fsm1305966iod.4.2022.06.16.08.39.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 08:39:46 -0700 (PDT)
Message-ID: <7a0b40ae-4b1a-a512-1fdc-abfd8ffc56e8@kernel.dk>
Date:   Thu, 16 Jun 2022 09:39:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: FAILED: patch "[PATCH] io_uring: reinstate the inflight tracking"
 failed to apply to 5.18-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <1655384994105244@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1655384994105244@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/16/22 7:09 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.18-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's the stable backport, thanks.


commit db647876ffdec5d2c3d0f4bfd92b9fe81cf1f231
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Jun 16 09:37:57 2022 -0600

    io_uring: reinstate the inflight tracking
    
    commit 9cae36a094e7e9d6e5fe8b6dcd4642138b3eb0c7 upstream
    
    After some debugging, it was realized that we really do still need the
    old inflight tracking for any file type that has io_uring_fops assigned.
    If we don't, then trivial circular references will mean that we never get
    the ctx cleaned up and hence it'll leak.
    
    Just bring back the inflight tracking, which then also means we can
    eliminate the conditional dropping of the file when task_work is queued.
    
    Fixes: d5361233e9ab ("io_uring: drop the old style inflight file tracking")
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9e247335e70d..3582db014aad 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -111,7 +111,8 @@
 			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
-				REQ_F_POLLED | REQ_F_CREDS | REQ_F_ASYNC_DATA)
+				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
+				REQ_F_ASYNC_DATA)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
@@ -493,6 +494,7 @@ struct io_uring_task {
 	const struct io_ring_ctx *last;
 	struct io_wq		*io_wq;
 	struct percpu_counter	inflight;
+	atomic_t		inflight_tracked;
 	atomic_t		in_idle;
 
 	spinlock_t		task_lock;
@@ -1186,8 +1188,6 @@ static void io_clean_op(struct io_kiocb *req);
 static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 					     unsigned issue_flags);
 static inline struct file *io_file_get_normal(struct io_kiocb *req, int fd);
-static void io_drop_inflight_file(struct io_kiocb *req);
-static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags);
 static void __io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
 
@@ -1435,9 +1435,29 @@ static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 			  bool cancel_all)
 	__must_hold(&req->ctx->timeout_lock)
 {
+	struct io_kiocb *req;
+
 	if (task && head->task != task)
 		return false;
-	return cancel_all;
+	if (cancel_all)
+		return true;
+
+	io_for_each_link(req, head) {
+		if (req->flags & REQ_F_INFLIGHT)
+			return true;
+	}
+	return false;
+}
+
+static bool io_match_linked(struct io_kiocb *head)
+{
+	struct io_kiocb *req;
+
+	io_for_each_link(req, head) {
+		if (req->flags & REQ_F_INFLIGHT)
+			return true;
+	}
+	return false;
 }
 
 /*
@@ -1447,9 +1467,24 @@ static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 static bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			       bool cancel_all)
 {
+	bool matched;
+
 	if (task && head->task != task)
 		return false;
-	return cancel_all;
+	if (cancel_all)
+		return true;
+
+	if (head->flags & REQ_F_LINK_TIMEOUT) {
+		struct io_ring_ctx *ctx = head->ctx;
+
+		/* protect against races with linked timeouts */
+		spin_lock_irq(&ctx->timeout_lock);
+		matched = io_match_linked(head);
+		spin_unlock_irq(&ctx->timeout_lock);
+	} else {
+		matched = io_match_linked(head);
+	}
+	return matched;
 }
 
 static inline bool req_has_async_data(struct io_kiocb *req)
@@ -1608,6 +1643,14 @@ static inline bool io_req_ffs_set(struct io_kiocb *req)
 	return req->flags & REQ_F_FIXED_FILE;
 }
 
+static inline void io_req_track_inflight(struct io_kiocb *req)
+{
+	if (!(req->flags & REQ_F_INFLIGHT)) {
+		req->flags |= REQ_F_INFLIGHT;
+		atomic_inc(&current->io_uring->inflight_tracked);
+	}
+}
+
 static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
 {
 	if (WARN_ON_ONCE(!req->link))
@@ -2516,8 +2559,6 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 
 	WARN_ON_ONCE(!tctx);
 
-	io_drop_inflight_file(req);
-
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	if (priority)
 		wq_list_add_tail(&req->io_task_work.node, &tctx->prior_task_list);
@@ -5869,10 +5910,6 @@ static int io_poll_check_events(struct io_kiocb *req, bool locked)
 
 		if (!req->result) {
 			struct poll_table_struct pt = { ._key = req->apoll_events };
-			unsigned flags = locked ? 0 : IO_URING_F_UNLOCKED;
-
-			if (unlikely(!io_assign_file(req, flags)))
-				return -EBADF;
 			req->result = vfs_poll(req->file, &pt) & req->apoll_events;
 		}
 
@@ -7097,6 +7134,11 @@ static void io_clean_op(struct io_kiocb *req)
 		kfree(req->apoll);
 		req->apoll = NULL;
 	}
+	if (req->flags & REQ_F_INFLIGHT) {
+		struct io_uring_task *tctx = req->task->io_uring;
+
+		atomic_dec(&tctx->inflight_tracked);
+	}
 	if (req->flags & REQ_F_CREDS)
 		put_cred(req->creds);
 	if (req->flags & REQ_F_ASYNC_DATA) {
@@ -7393,19 +7435,6 @@ static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 	return file;
 }
 
-/*
- * Drop the file for requeue operations. Only used of req->file is the
- * io_uring descriptor itself.
- */
-static void io_drop_inflight_file(struct io_kiocb *req)
-{
-	if (unlikely(req->flags & REQ_F_INFLIGHT)) {
-		fput(req->file);
-		req->file = NULL;
-		req->flags &= ~REQ_F_INFLIGHT;
-	}
-}
-
 static struct file *io_file_get_normal(struct io_kiocb *req, int fd)
 {
 	struct file *file = fget(fd);
@@ -7414,7 +7443,7 @@ static struct file *io_file_get_normal(struct io_kiocb *req, int fd)
 
 	/* we don't allow fixed io_uring files */
 	if (file && file->f_op == &io_uring_fops)
-		req->flags |= REQ_F_INFLIGHT;
+		io_req_track_inflight(req);
 	return file;
 }
 
@@ -9211,6 +9240,7 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
 	xa_init(&tctx->xa);
 	init_waitqueue_head(&tctx->wait);
 	atomic_set(&tctx->in_idle, 0);
+	atomic_set(&tctx->inflight_tracked, 0);
 	task->io_uring = tctx;
 	spin_lock_init(&tctx->task_lock);
 	INIT_WQ_LIST(&tctx->task_list);
@@ -10402,7 +10432,7 @@ static __cold void io_uring_clean_tctx(struct io_uring_task *tctx)
 static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 {
 	if (tracked)
-		return 0;
+		return atomic_read(&tctx->inflight_tracked);
 	return percpu_counter_sum(&tctx->inflight);
 }
 

-- 
Jens Axboe

