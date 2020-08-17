Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1992467AC
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbgHQNs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbgHQNs3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 09:48:29 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF4FC061389
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:48:29 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id 2so7844083pjx.5
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=aVS+xQZCAFsbU4ejqL/vfTxjsd13wOJpXTEmnKCT4Ow=;
        b=Hc9nT+S0GoC/OZLYksUy426BcThNasUkt0c1U2cSm1odefuQj4vt/PRRSRDVp2IBVY
         cD07cbxbcwPul1pPOLT8oaRo+elHhdfcVDERwWatQJvJR7KOEiwMCHdMYpx1KSavls9C
         prYFbTi9yc5zBeAhxSH6/N5fLO9LFYaQkZXW0P8GFA30EBWXNRAispKBiKQux2clj+Z4
         J5kOfLf+Sp2kNxz21dO7Xf4AebiJOmbHX9BPmdyfPnkQ+D2Nsk1gSdJXNOxSqPHKsNGJ
         JIkTumlHlSEgu7JacXi5pb32bRjAhzVER/aAUbNpRiOOSTwkKMBh1vthRQvFXLUgyUGw
         flrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=aVS+xQZCAFsbU4ejqL/vfTxjsd13wOJpXTEmnKCT4Ow=;
        b=TAKCwJfPLo6CEYGFXR1mwijn74KKqrZHj2L4HI1jMgfxmNYc3aE4sjLb7WlU/2qnay
         vl4FVsqgw1v2RqLP6wFT0ZnofyWxXvve466RV9jWh68Hrklz/uqBeOcBFJVg3GnzqEHm
         Dmb2Pdg1GPQqkl662Pa7DqldlZjRjAtTxLiQblN7k2fAJkDJygRJ+j/KtarKWXbyowk6
         mE6Se+ncP5BVECOqj9J+vU8w4eVzpFXfYd1hBpm4SYGo7XeO21du9CElpCb7TaBr5ltL
         P1OZNNJxNpZTw54eCYNuKk9rvjpbmscp4q2lcC1ulKEhfopAMSGXD4BbzcOhX/ZGddjr
         jo4A==
X-Gm-Message-State: AOAM532fIfiEd+s1L2yPkYC/6jTnzoAyFxPo5u32GpAi0otGJBE//g/8
        i33lRld9uGaRMAvPulL8MuA3X+dWnfnaOQ==
X-Google-Smtp-Source: ABdhPJxJL8LVFTDcksHFKiNIx4LIzgAQzvxWO9sKtIiwc1XgA6qXSp9qPOk5Zziwyi7n/EkFz6+/gg==
X-Received: by 2002:a17:902:7d84:: with SMTP id a4mr11353964plm.44.1597672108436;
        Mon, 17 Aug 2020 06:48:28 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ff2c:a74f:a461:daa2? ([2605:e000:100e:8c61:ff2c:a74f:a461:daa2])
        by smtp.gmail.com with ESMTPSA id u62sm19976641pfb.4.2020.08.17.06.48.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 06:48:27 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: hold 'ctx' reference around
 task_work queue +" failed to apply to 5.8-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <1597661043160117@kroah.com>
 <6d363f5c-711c-6953-d417-2f9dfbf3dd7a@kernel.dk>
 <20200817131341.GA208556@kroah.com>
 <da8acd62-2312-1baf-8562-d2085c78e062@kernel.dk>
 <20200817134412.GE359148@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cd794f40-ba84-0766-a68e-d6f0cb8c77e2@kernel.dk>
Date:   Mon, 17 Aug 2020 06:48:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200817134412.GE359148@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------804DBEDE38F289816F502ED7"
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------804DBEDE38F289816F502ED7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 8/17/20 6:44 AM, Greg KH wrote:
> On Mon, Aug 17, 2020 at 06:21:02AM -0700, Jens Axboe wrote:
>> On 8/17/20 6:13 AM, Greg KH wrote:
>>> On Mon, Aug 17, 2020 at 06:10:04AM -0700, Jens Axboe wrote:
>>>> On 8/17/20 3:44 AM, gregkh@linuxfoundation.org wrote:
>>>>>
>>>>> The patch below does not apply to the 5.8-stable tree.
>>>>> If someone wants it applied there, or to any other stable or longterm
>>>>> tree, then please email the backport, including the original git commit
>>>>> id to <stable@vger.kernel.org>.
>>>>
>>>> Here's a 5.8 version.
>>>
>>> Applied, thanks!
>>>
>>> Looks like it applies to 5.7 too, want me to take this for that as well?
>>
>> Heh, didn't see this email, just going through this by kernel revision.
>> Either one should work, sent a specific set for that too.
> 
> Oops, it did not build on 5.7, so I still need a working backport for
> that.

Maybe I missed that, in any case, here it is. This one is for 5.7, to be
specific.

>> commit ebf0d100df0731901c16632f78d78d35f4123bc4
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Thu Aug 13 09:01:38 2020 -0600
>>
>>     task_work: only grab task signal lock when needed
>>
>> as well, to avoid a perf regression with the TWA_SIGNAL change? Thanks!
> 
> Also now queued up, thanks.

Thanks!

-- 
Jens Axboe


--------------804DBEDE38F289816F502ED7
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-hold-ctx-reference-around-task_work-queue-e.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io_uring-hold-ctx-reference-around-task_work-queue-e.pa";
 filename*1="tch"

From bf96cb6381c6765e8ae84aef546ea0b3f970599a Mon Sep 17 00:00:00 2001
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
index 5e6bbcb60fc4..2e7cbe61f64c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4202,6 +4202,8 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	tsk = req->task;
 	req->result = mask;
 	init_task_work(&req->task_work, func);
+	percpu_ref_get(&req->ctx->refs);
+
 	/*
 	 * If this fails, then the task is exiting. When a task exits, the
 	 * work gets canceled, so just cancel this request as well instead
@@ -4301,6 +4303,7 @@ static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
 static void io_poll_task_func(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *nxt = NULL;
 
 	io_poll_task_handler(req, &nxt);
@@ -4311,6 +4314,7 @@ static void io_poll_task_func(struct callback_head *cb)
 		__io_queue_sqe(nxt, NULL);
 		mutex_unlock(&ctx->uring_lock);
 	}
+	percpu_ref_put(&ctx->refs);
 }
 
 static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
@@ -4427,6 +4431,7 @@ static void io_async_task_func(struct callback_head *cb)
 
 	if (io_poll_rewait(req, &apoll->poll)) {
 		spin_unlock_irq(&ctx->completion_lock);
+		percpu_ref_put(&ctx->refs);
 		return;
 	}
 
@@ -4465,6 +4470,7 @@ static void io_async_task_func(struct callback_head *cb)
 
 	kfree(apoll->double_poll);
 	kfree(apoll);
+	percpu_ref_put(&ctx->refs);
 }
 
 static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
-- 
2.28.0


--------------804DBEDE38F289816F502ED7--
