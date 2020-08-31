Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAD6257AAE
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 15:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgHaNq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 09:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbgHaNpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 09:45:52 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A4DC061573
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 06:45:52 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z25so3167692iol.10
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 06:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qxXV9ZcL54aNZuwbgjSyyXkAXCGuNSyDoN2L3+5W6ZQ=;
        b=ojgTSU88duZSH8P9h7VAcCot+yN3AqJuWf2S95Ak07iMExNArzjBweoGF4BkqBH6Tt
         VUCRiTgj9FQ7ip01F9Ol370qnM1rGP/yZpmTkrqKtHGTXEOVV9TShRvSb/9CEiqZtAPW
         bnDecPTlzBA+zuv9dS1e3NBUziDHKVa9Yv4MdJNDGYLQE9ZgOY6SZrSrrh/g9cn89mJQ
         /TEcH249TpzzSbQbRlgaRNRLGUGL+z2Lf+qMX2JFy6NdriWOFMDUzOrSBFNlQDihp1Ns
         jiMohLU37MHe60bkhagZWzj/wyQTMuYaWG914zaykRV/CLfr8781qfgeSzKPiUSVnxOE
         8OOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qxXV9ZcL54aNZuwbgjSyyXkAXCGuNSyDoN2L3+5W6ZQ=;
        b=IHM5vKbjHvM8bmnjbsu6cIKi9ldo6N79ly7hoyP1OiTEph0N0gO06UlQT4lIel5DCC
         YYj9nnGhuezkqSPjczjBPahp4MG5EbfzXq9lfLH3MYqXRHN4s8+8tpGRECV/7AZUHUPv
         FM28prMpK3C2gp924B9q1bTJMwu1APiEYTcDv347XzDJlQgyLSB9qByq6F5EuItMPkoK
         A9XbCwIbA5Ph9EZs+DmX57+JQp3lBVk861vXJoa5AjIxdpssWcdBUSV1IVmJoYaLlBDs
         BA76klNKS1Z14sqiHcJDvLbHqQciyX0XTT9fodkohPyP4PxIZROys6St7ZCnctWLk4Sm
         5xgA==
X-Gm-Message-State: AOAM533vihoON+Ub3KAtawEXIKjGI5QGTjil4qK0A+O880Mx6kM3bOqI
        kezHbYfl0pWOTMBcsD/JhgIaeP2CU0i8Iom+
X-Google-Smtp-Source: ABdhPJyLD9BuLKRYHxX649HutAz+EAJelTUKN+w6Nhw6+B5qkXtjEicaPK1zbAVOtEndH3VCiFGSrQ==
X-Received: by 2002:a5d:841a:: with SMTP id i26mr1299765ion.144.1598881550881;
        Mon, 31 Aug 2020 06:45:50 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n11sm2973867ioh.23.2020.08.31.06.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 06:45:50 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: don't recurse on
 tsk->sighand->siglock with" failed to apply to 5.8-stable tree
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <1598867905173168@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c1700041-1d6d-030e-b249-7c67cc96ac0e@kernel.dk>
Date:   Mon, 31 Aug 2020 07:45:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1598867905173168@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/31/20 3:58 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.8-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's a backport:


From c73b786f4acbac1724c3fe749f0b4697692bbbbe Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sun, 23 Aug 2020 11:00:37 -0600
Subject: [PATCH 1/3] io_uring: don't recurse on tsk->sighand->siglock with
 signalfd

If an application is doing reads on signalfd, and we arm the poll handler
because there's no data available, then the wakeup can recurse on the
tasks sighand->siglock as the signal delivery from task_work_add() will
use TWA_SIGNAL and that attempts to lock it again.

We can detect the signalfd case pretty easily by comparing the poll->head
wait_queue_head_t with the target task signalfd wait queue. Just use
normal task wakeup for this case.

Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b966e2b8a77d..c384caad6466 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4114,7 +4114,8 @@ struct io_poll_table {
 	int error;
 };
 
-static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
+static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb,
+				bool twa_signal_ok)
 {
 	struct task_struct *tsk = req->task;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -4127,7 +4128,7 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
 	 * will do the job.
 	 */
 	notify = 0;
-	if (!(ctx->flags & IORING_SETUP_SQPOLL))
+	if (!(ctx->flags & IORING_SETUP_SQPOLL) && twa_signal_ok)
 		notify = TWA_SIGNAL;
 
 	ret = task_work_add(tsk, cb, notify);
@@ -4141,6 +4142,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 			   __poll_t mask, task_work_func_t func)
 {
 	struct task_struct *tsk;
+	bool twa_signal_ok;
 	int ret;
 
 	/* for instances that support it check for an event match first: */
@@ -4156,13 +4158,21 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	init_task_work(&req->task_work, func);
 	percpu_ref_get(&req->ctx->refs);
 
+	/*
+	 * If we using the signalfd wait_queue_head for this wakeup, then
+	 * it's not safe to use TWA_SIGNAL as we could be recursing on the
+	 * tsk->sighand->siglock on doing the wakeup. Should not be needed
+	 * either, as the normal wakeup will suffice.
+	 */
+	twa_signal_ok = (poll->head != &req->task->sighand->signalfd_wqh);
+
 	/*
 	 * If this fails, then the task is exiting. When a task exits, the
 	 * work gets canceled, so just cancel this request as well instead
 	 * of executing it. We can't safely execute it anyway, as we may not
 	 * have the needed state needed for it anyway.
 	 */
-	ret = io_req_task_work_add(req, &req->task_work);
+	ret = io_req_task_work_add(req, &req->task_work, twa_signal_ok);
 	if (unlikely(ret)) {
 		WRITE_ONCE(poll->canceled, true);
 		tsk = io_wq_get_task(req->ctx->io_wq);
-- 
2.28.0


-- 
Jens Axboe

