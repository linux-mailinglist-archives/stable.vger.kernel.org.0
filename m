Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B9A1A8568
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 18:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407493AbgDNQnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 12:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404908AbgDNQm6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 12:42:58 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E092C061A0C
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 09:42:58 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a32so5523635pje.5
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 09:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G98Ssdo5yqI4C+hwGEf46fE72yBrgSUVODkMDbefblI=;
        b=W7ceBfhO0Ha8pWPN/53aBYJ2s7Uqj+pxuLSy2jTPvkArVyDm7gyIzwUQ26V1uR7r3D
         uaWtNckyDxLUJ2Rqyjc8ydVFBqqO7tuYWsc9HzRmsDl4D/4LeZbHCtD6Og27KOnjffZm
         wMlLLnhIFu4jZqOI1QGzIdaNN6jmXnfgZ8XW4ivjPoCtTUKjc5NWQ/pbpW6qa62mMgIq
         LA6SU0uZcOKHNhLjSruOpdl/q0TkUbM9fmuc+spxSTzMw2ppirj/S548RMx4zGinMVwk
         XUGdFQPpMP07ui4AsDa4ykl5WhTSJGOvtoQ8hfl2Ii1M4s3KtNxLNA9T6HTkjT+oecHL
         DpfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G98Ssdo5yqI4C+hwGEf46fE72yBrgSUVODkMDbefblI=;
        b=Prc+kETrqpAFuPNA+OM2xk2uKVjgQAnPV5g+h7ksMz/7sZdYQl+FQ9I8ixbO0JHVhP
         y0lLo+drkwB6yOdnsE6H/4JRrn7gupBJmdse+/o5BIdCdRHaH0kariDIjsqTEG9sJjTL
         0Lj+FOsUms3VsEIWjzMlSwEkPc3Ig99HizWjvOQG8T3rntG3NxNLbGB/P6G+wCCySM3w
         W++QXY8pRIcIqQwayuCSD4ZCR4cLxFoWDRiwO5JzpoIP96ADC9Y+lwXkhhoqRc/WJJvp
         rDuu/jyopuQh8B58Pz/CzokJIRSrUxWgWMeluHRtQluaco4nhc4ykdXJkWwXYHCfyBMV
         hV9g==
X-Gm-Message-State: AGi0PuauBYo7LNWHxRSaLGKDeAZIfh1oyXrB4vjuD3wOyn1Hcv5FpkDA
        li6ezAzEUQ9dNNM/IUBi4LGuW07eZ2RK8Q==
X-Google-Smtp-Source: APiQypIgrm94uHvEXLgt3GvV3gSiirdL/YyDDVemogwJEYI2Wm6hA9fzYeAwZpEWFTl5mpkwre6GXQ==
X-Received: by 2002:a17:90b:19c9:: with SMTP id nm9mr1181957pjb.86.1586882577347;
        Tue, 14 Apr 2020 09:42:57 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id b11sm11595086pfr.155.2020.04.14.09.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 09:42:56 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: honor original task
 RLIMIT_FSIZE" failed to apply to 5.6-stable tree
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <1586866829230106@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dc4681e4-c884-d2b4-6be1-83412778dbe9@kernel.dk>
Date:   Tue, 14 Apr 2020 10:42:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1586866829230106@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/14/20 6:20 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.6-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

5.6 backport below.

From 4ed734b0d0913e566a9d871e15d24eb240f269f7 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 20 Mar 2020 11:23:41 -0600
Subject: [PATCH] io_uring: honor original task RLIMIT_FSIZE

With the previous fixes for number of files open checking, I added some
debug code to see if we had other spots where we're checking rlimit()
against the async io-wq workers. The only one I found was file size
checking, which we should also honor.

During write and fallocate prep, store the max file size and override
that for the current ask if we're in io-wq worker context.

Cc: stable@vger.kernel.org # 5.1+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bdcffd78fbb9..b2e2de7de035 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -565,6 +565,7 @@ struct io_kiocb {
 	struct list_head	link_list;
 	unsigned int		flags;
 	refcount_t		refs;
+	unsigned long		fsize;
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -2295,6 +2296,8 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
 		return -EBADF;
 
+	req->fsize = rlimit(RLIMIT_FSIZE);
+
 	/* either don't need iovec imported or already have it */
 	if (!req->io || req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
@@ -2367,10 +2370,17 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 		}
 		kiocb->ki_flags |= IOCB_WRITE;
 
+		if (!force_nonblock)
+			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
+
 		if (req->file->f_op->write_iter)
 			ret2 = call_write_iter(req->file, kiocb, &iter);
 		else
 			ret2 = loop_rw_iter(WRITE, req->file, kiocb, &iter);
+
+		if (!force_nonblock)
+			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
+
 		/*
 		 * Raw bdev writes will -EOPNOTSUPP for IOCB_NOWAIT. Just
 		 * retry them without IOCB_NOWAIT.
@@ -2513,8 +2523,10 @@ static void io_fallocate_finish(struct io_wq_work **workptr)
 	if (io_req_cancelled(req))
 		return;
 
+	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
 	ret = vfs_fallocate(req->file, req->sync.mode, req->sync.off,
 				req->sync.len);
+	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
@@ -2532,6 +2544,7 @@ static int io_fallocate_prep(struct io_kiocb *req,
 	req->sync.off = READ_ONCE(sqe->off);
 	req->sync.len = READ_ONCE(sqe->addr);
 	req->sync.mode = READ_ONCE(sqe->len);
+	req->fsize = rlimit(RLIMIT_FSIZE);
 	return 0;
 }

-- 
Jens Axboe

