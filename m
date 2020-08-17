Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59EC9246706
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgHQNKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727931AbgHQNKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 09:10:07 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEF6C061389
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:10:07 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id f9so7664520pju.4
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=nT232oFXSCRJnd22Q/9DirmkyLMP0zVTAD6pA2pDbgw=;
        b=ZkMvOJXOobAE5QAzxM7ZruiEl6VSDgIFof6+MC4Ll/Z3ptq4dHiqzjF9LalbrPGGql
         0o/UDEtoVUi2TqzzHNxb40vEKLYbDNY7WxaERpfhp/g+oXO5ti3Tj47JLhNM31awFRV0
         3nd6k66Fk1uwip3NJ7r90g9t61CQgFPVfmV3s7Qtao1BKXQLVNGzDy51aeRZAQNVanE5
         ubX4hhLY0fpdiXwaPzAk7mXSLC9W6QLK7Qg0wuI78VK/MCQ0yrIUUlXO0JK+yGegfvgL
         dhDv8NUMKe4b3stzj5CCav8xGgTCQYGBrJeXCdIJj+5oP2HnqVbr9i2Uu+gT3rYqzemA
         24lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=nT232oFXSCRJnd22Q/9DirmkyLMP0zVTAD6pA2pDbgw=;
        b=bZN3wJYW2o4IZ/rDNeDF9glWM6N2o2S31dkoPsSq6Bs/aKrZnfoy3Suv391SD7qzJ/
         +U024WYHal4VWkR3rryorEnC/dkqmXIS3KyDS/5DTPm+Up0PJFH+yJG4tn0o5i9HzQkd
         1N46p4EjWRCjwUHbPI6ZElGFW2P0KsGfVONjctCB7Min3EAM0Nlie3f+l77YRP9+4ham
         ZEeMC3sSBgiaE7wya5/O4lS7WWJAiEMsaKJPtYLsSqqgBQDR9gobFkO6/i3gVyI1pInE
         U/q202NWm2D6Yc9UpsBUIO7HtoXOtlWs356MtBEdxA8DDchllH/bJLBnN5sN6nHRcomI
         wJiw==
X-Gm-Message-State: AOAM530yUXk6X/UbHsleW/HCQpCfEy+m7LFcbwDvFDZ5Jkb95PCN22CJ
        c/3cNtYsetjdDEO7HPrE1lFZjURTHa8F1g==
X-Google-Smtp-Source: ABdhPJwdsRIrE/TQO0ejvkCL2nr8Sd9rP5PVxKm9ax1wfQaTbSMK/M9xoSwA3TyQjvbXwSsci43mAw==
X-Received: by 2002:a17:90a:f290:: with SMTP id fs16mr12361596pjb.35.1597669806301;
        Mon, 17 Aug 2020 06:10:06 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ff2c:a74f:a461:daa2? ([2605:e000:100e:8c61:ff2c:a74f:a461:daa2])
        by smtp.gmail.com with ESMTPSA id s8sm17589302pju.54.2020.08.17.06.10.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 06:10:05 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: hold 'ctx' reference around
 task_work queue +" failed to apply to 5.8-stable tree
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <1597661043160117@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6d363f5c-711c-6953-d417-2f9dfbf3dd7a@kernel.dk>
Date:   Mon, 17 Aug 2020 06:10:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1597661043160117@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------698E952C08759A00E275CA36"
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------698E952C08759A00E275CA36
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 8/17/20 3:44 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.8-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's a 5.8 version.

-- 
Jens Axboe


--------------698E952C08759A00E275CA36
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-hold-ctx-reference-around-task_work-queue-e.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io_uring-hold-ctx-reference-around-task_work-queue-e.pa";
 filename*1="tch"

From 4805555b82f6eb78903ee2841ebae13707d9da13 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 11 Aug 2020 08:04:14 -0600
Subject: [PATCH] io_uring: hold 'ctx' reference around task_work queue +
 execute

We're holding the request reference, but we need to go one higher
to ensure that the ctx remains valid after the request has finished.
If the ring is closed with pending task_work inflight, and the
given io_kiocb finishes sync during issue, then we need a reference
to the ring itself around the task_work execution cycle.

Cc: stable@vger.kernel.org # v5.7+
Reported-by: syzbot+9b260fc33297966f5a8e@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3da73e58759e..c7aefd3da135 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4141,6 +4141,8 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	tsk = req->task;
 	req->result = mask;
 	init_task_work(&req->task_work, func);
+	percpu_ref_get(&req->ctx->refs);
+
 	/*
 	 * If this fails, then the task is exiting. When a task exits, the
 	 * work gets canceled, so just cancel this request as well instead
@@ -4225,6 +4227,7 @@ static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
 static void io_poll_task_func(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *nxt = NULL;
 
 	io_poll_task_handler(req, &nxt);
@@ -4235,6 +4238,7 @@ static void io_poll_task_func(struct callback_head *cb)
 		__io_queue_sqe(nxt, NULL);
 		mutex_unlock(&ctx->uring_lock);
 	}
+	percpu_ref_put(&ctx->refs);
 }
 
 static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
@@ -4349,6 +4353,7 @@ static void io_async_task_func(struct callback_head *cb)
 
 	if (io_poll_rewait(req, &apoll->poll)) {
 		spin_unlock_irq(&ctx->completion_lock);
+		percpu_ref_put(&ctx->refs);
 		return;
 	}
 
@@ -4387,6 +4392,7 @@ static void io_async_task_func(struct callback_head *cb)
 		req_set_fail_links(req);
 		io_double_put_req(req);
 	}
+	percpu_ref_put(&ctx->refs);
 }
 
 static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
-- 
2.28.0


--------------698E952C08759A00E275CA36--
