Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6989722F332
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbgG0O7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728852AbgG0O7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 10:59:12 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2072BC0619D2
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 07:59:12 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id e8so9689768pgc.5
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 07:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KlQ3buoF1Jo55GtEebOXg558C+P21qJa1OenK7QPWAE=;
        b=igIIvhXG5qxfs1QxLZAr/QreIX5nhu4QadtngtPxfvIubFaqloswQlr+86HwSOctal
         J1Wp/WNKWvYLxv9sPEARe1BVnvkUQuCIFpzvcgt1d8zimhP+aUeVVxEWS+mdKXcpVVTO
         1KUYLPKEt77J1+XKIgiCOFB45fNyRoKIMKuR37Vuy30tNj4nElmUB9e6G3FklukGmhkI
         jtnj3XwX7XuYAHZwC5cM1eQJshPyDpJWLF2J2LKhmyeOygONUKyD+z98b2j1P6ISDQpC
         hNmkAouzqej9h2dXH1BsIXeGfBxW0hiYqOcIs/+QAdo98rvEnz2TeHGgvwxaeg77lTM1
         0Phg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KlQ3buoF1Jo55GtEebOXg558C+P21qJa1OenK7QPWAE=;
        b=XMNSkw3gr2h+aNAffqa5plTzhWOc37LA5td13WllvGK7usLIMp1qISmiKvWFw2IpEQ
         4MyMYNtYfJ4qAIRpVDR+IS5hhN/jtziDgz2LwgIII8oSvUXmz6vjgBrnfbJD2b31bLgi
         SRmkd2YL2rcfZw8MTVpcUicB05P5DmTGjQzcPXxNArtLBrtIbv9zY3Ib3/GwvPttURUa
         9eloAQaOQZbO9r0i9/iklOKPA30/vk8oM/5tbi2cxRA9F6wQ/DZJor733aZdAVe6461Q
         O09zVKWvQ5ERuTVBr6KoCPo0oglosKGEMZnstI6/0OJ4I4nz/SIci25Kp2gKwZKH+AB3
         Q9Qg==
X-Gm-Message-State: AOAM533wNdUjynkA8MUAYDv29t32qtiPC/m7at1AS625NJbfknBcmtxH
        FvAgoAM8mOp3kbStlvCycGfi4IxGqtQ=
X-Google-Smtp-Source: ABdhPJzbATXhghPGjM3lMHIvi8qjAkXz3toiybuLDDljAVMrzbk6IOlemoJ9uNwcQ6um7IbYQEVaeQ==
X-Received: by 2002:a63:6744:: with SMTP id b65mr20549859pgc.42.1595861951231;
        Mon, 27 Jul 2020 07:59:11 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p11sm14757144pjb.3.2020.07.27.07.59.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 07:59:10 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: ensure double poll additions
 work with both request" failed to apply to 5.7-stable tree
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <159585645969173@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cb5acf7a-31b5-81c4-874b-366dba951f16@kernel.dk>
Date:   Mon, 27 Jul 2020 08:59:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159585645969173@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/27/20 7:27 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.7-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's the 5.7 variant:


commit 807abcb0883439af5ead73f3308310453b97b624
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Jul 17 17:09:27 2020 -0600

    io_uring: ensure double poll additions work with both request types
    
    The double poll additions were centered around doing POLL_ADD on file
    descriptors that use more than one waitqueue (typically one for read,
    one for write) when being polled. However, it can also end up being
    triggered for when we use poll triggered retry. For that case, we cannot
    safely use req->io, as that could be used by the request type itself.
    
    Add a second io_poll_iocb pointer in the structure we allocate for poll
    based retry, and ensure we use the right one from the two paths.
    
    Fixes: 18bceab101ad ("io_uring: allow POLL_ADD with double poll_wait() users")
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 51be3a20ade1..d0d3efaaa4d4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -581,6 +581,7 @@ enum {
 
 struct async_poll {
 	struct io_poll_iocb	poll;
+	struct io_poll_iocb	*double_poll;
 	struct io_wq_work	work;
 };
 
@@ -4220,9 +4221,9 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 	return false;
 }
 
-static void io_poll_remove_double(struct io_kiocb *req)
+static void io_poll_remove_double(struct io_kiocb *req, void *data)
 {
-	struct io_poll_iocb *poll = (struct io_poll_iocb *) req->io;
+	struct io_poll_iocb *poll = data;
 
 	lockdep_assert_held(&req->ctx->completion_lock);
 
@@ -4242,7 +4243,7 @@ static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_poll_remove_double(req);
+	io_poll_remove_double(req, req->io);
 	req->poll.done = true;
 	io_cqring_fill_event(req, error ? error : mangle_poll(mask));
 	io_commit_cqring(ctx);
@@ -4285,21 +4286,21 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 			       int sync, void *key)
 {
 	struct io_kiocb *req = wait->private;
-	struct io_poll_iocb *poll = (struct io_poll_iocb *) req->io;
+	struct io_poll_iocb *poll = req->apoll->double_poll;
 	__poll_t mask = key_to_poll(key);
 
 	/* for instances that support it check for an event match first: */
 	if (mask && !(mask & poll->events))
 		return 0;
 
-	if (req->poll.head) {
+	if (poll && poll->head) {
 		bool done;
 
-		spin_lock(&req->poll.head->lock);
-		done = list_empty(&req->poll.wait.entry);
+		spin_lock(&poll->head->lock);
+		done = list_empty(&poll->wait.entry);
 		if (!done)
-			list_del_init(&req->poll.wait.entry);
-		spin_unlock(&req->poll.head->lock);
+			list_del_init(&poll->wait.entry);
+		spin_unlock(&poll->head->lock);
 		if (!done)
 			__io_async_wake(req, poll, mask, io_poll_task_func);
 	}
@@ -4319,7 +4320,8 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
 }
 
 static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
-			    struct wait_queue_head *head)
+			    struct wait_queue_head *head,
+			    struct io_poll_iocb **poll_ptr)
 {
 	struct io_kiocb *req = pt->req;
 
@@ -4330,7 +4332,7 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 	 */
 	if (unlikely(poll->head)) {
 		/* already have a 2nd entry, fail a third attempt */
-		if (req->io) {
+		if (*poll_ptr) {
 			pt->error = -EINVAL;
 			return;
 		}
@@ -4342,7 +4344,7 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 		io_init_poll_iocb(poll, req->poll.events, io_poll_double_wake);
 		refcount_inc(&req->refs);
 		poll->wait.private = req;
-		req->io = (void *) poll;
+		*poll_ptr = poll;
 	}
 
 	pt->error = 0;
@@ -4354,8 +4356,9 @@ static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
 			       struct poll_table_struct *p)
 {
 	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
+	struct async_poll *apoll = pt->req->apoll;
 
-	__io_queue_proc(&pt->req->apoll->poll, pt, head);
+	__io_queue_proc(&apoll->poll, pt, head, &apoll->double_poll);
 }
 
 static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
@@ -4409,6 +4412,7 @@ static void io_async_task_func(struct callback_head *cb)
 	memcpy(&req->work, &apoll->work, sizeof(req->work));
 
 	if (canceled) {
+		kfree(apoll->double_poll);
 		kfree(apoll);
 		io_cqring_ev_posted(ctx);
 end_req:
@@ -4426,6 +4430,7 @@ static void io_async_task_func(struct callback_head *cb)
 	__io_queue_sqe(req, NULL);
 	mutex_unlock(&ctx->uring_lock);
 
+	kfree(apoll->double_poll);
 	kfree(apoll);
 }
 
@@ -4497,7 +4502,6 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
 	__poll_t mask, ret;
-	bool had_io;
 
 	if (!req->file || !file_can_poll(req->file))
 		return false;
@@ -4509,10 +4513,10 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 	if (unlikely(!apoll))
 		return false;
+	apoll->double_poll = NULL;
 
 	req->flags |= REQ_F_POLLED;
 	memcpy(&apoll->work, &req->work, sizeof(req->work));
-	had_io = req->io != NULL;
 
 	get_task_struct(current);
 	req->task = current;
@@ -4531,12 +4535,10 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
 	if (ret) {
-		ipt.error = 0;
-		/* only remove double add if we did it here */
-		if (!had_io)
-			io_poll_remove_double(req);
+		io_poll_remove_double(req, apoll->double_poll);
 		spin_unlock_irq(&ctx->completion_lock);
 		memcpy(&req->work, &apoll->work, sizeof(req->work));
+		kfree(apoll->double_poll);
 		kfree(apoll);
 		return false;
 	}
@@ -4567,11 +4569,13 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 	bool do_complete;
 
 	if (req->opcode == IORING_OP_POLL_ADD) {
-		io_poll_remove_double(req);
+		io_poll_remove_double(req, req->io);
 		do_complete = __io_poll_remove_one(req, &req->poll);
 	} else {
 		struct async_poll *apoll = req->apoll;
 
+		io_poll_remove_double(req, apoll->double_poll);
+
 		/* non-poll requests have submit ref still */
 		do_complete = __io_poll_remove_one(req, &apoll->poll);
 		if (do_complete) {
@@ -4582,6 +4586,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 			 * final reference.
 			 */
 			memcpy(&req->work, &apoll->work, sizeof(req->work));
+			kfree(apoll->double_poll);
 			kfree(apoll);
 		}
 	}
@@ -4682,7 +4687,7 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 {
 	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
 
-	__io_queue_proc(&pt->req->poll, pt, head);
+	__io_queue_proc(&pt->req->poll, pt, head, (struct io_poll_iocb **) &pt->req->io);
 }
 
 static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)

-- 
Jens Axboe

