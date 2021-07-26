Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52DE3D59B0
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 14:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbhGZMDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 08:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbhGZMDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 08:03:48 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD17AC061757
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 05:44:15 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id k14-20020a05600c1c8eb02901f13dd1672aso7643226wms.0
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 05:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o6FeqQl+OH9G5dIh6KJyqyndnXw68ncsy1on/t4LwoM=;
        b=RBYMUqRwE80P8WJBk7KAQ6kZvOCbu2zD057ZItQs2VSweL5jdv+1HV/B3906tulKRo
         J0KWa+/SG2jVlgdx+6FIeDwUyeO5DHo79mFWCwJzXyHv8HmogOUKwI7bnnYyKmLqTyZH
         l3/UM5+ZKphM9NKvQ8QoLI2RcmC4kbmWFTbTK/iE3JtU/0c4RUZUUEo+N/Vp9hFFOaol
         xYwJKTy8168JgPVdQATg+4c/CJOuQlVpZhXLg+jGkMhC0J/6aLYhlTbEZDuphDJpSP20
         wqxxXn4jdeyQ9JFmoxYlBc+b5ZyX2lGEpg9s92Q4uliaboW+iQ3GL/1fwmLFiWrirQXX
         oU+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o6FeqQl+OH9G5dIh6KJyqyndnXw68ncsy1on/t4LwoM=;
        b=kQdPoOXBBiQ1Go1OJ/pAEHGidnFlvqcTXPk888menyOtVPWeomCVBX0FgNyLuyCtDw
         QITOg8TetlFciqyET37o2cfgVmTkOjd6c+qK+yALHsSeaSTtf7oY7Q3dMXI4ImilIgRc
         t3o1NOHmaNT1rYpstZKXarrcuvC0nE9Bahi1xuBlRSKbgfk3Wr9fCSfwb3EWbtZxM3xd
         km0D4UEUnF86VNnOy0105yssrpiApQZKDvDguQ7WKW85kh3d1kyBSlckzNSNFXKzFIp0
         uFmvxH1UbWKzVRWiHtsQEwBMvIoZW0lEQK9T56X0zT1hlAidcmc7f/oZFtRIjimFU3VI
         52uw==
X-Gm-Message-State: AOAM532l8LRkhQzCqRZ2HvU266pnaUVxP90cHTQ6rRwYEg+JgK518cb7
        n7PhweC2ZMVBjl5crT7AUqIPZ+ls4TrsCQ==
X-Google-Smtp-Source: ABdhPJw6Atz0AqL/jHzss/VZ09Md2mKL/ZYCaqwCn8cGhPM/TiUvc/c/+Bh9Qpi3rMW4sebjwY83hQ==
X-Received: by 2002:a05:600c:4982:: with SMTP id h2mr26938277wmp.122.1627303454319;
        Mon, 26 Jul 2021 05:44:14 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id u12sm43383101wrt.50.2021.07.26.05.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 05:44:13 -0700 (PDT)
Date:   Mon, 26 Jul 2021 13:44:12 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: Re: use-after-free" with v5.10.y caused by backport of a298232ee6b9
 ("io_uring: fix link timeout refs")
Message-ID: <YP6uHKj/HWgZsrc1@debian>
References: <YP6OkehtVdkjKikL@debian>
 <d1ff5d9c-2e13-acc2-fd8f-a8f4f180a8bb@gmail.com>
 <YP6Xtjg3Eu4UfTxF@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FG6w6bPYvW4GhxJr"
Content-Disposition: inline
In-Reply-To: <YP6Xtjg3Eu4UfTxF@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FG6w6bPYvW4GhxJr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jul 26, 2021 at 01:08:38PM +0200, Greg Kroah-Hartman wrote:
> On Mon, Jul 26, 2021 at 11:57:22AM +0100, Pavel Begunkov wrote:
> > On 7/26/21 11:29 AM, Sudip Mukherjee wrote:
> > > Hi Pavel,
> > > 
> > > We had been running syzkaller on v5.10.y and a "use after free" is being
> > > reported for v5.10.43+ kernels.
> > 
> > "... # 5.12+", weird, but perhaps due to dependencies.
> > Thanks for letting know.
> > 
> > 
> > Greg, Sasha, should be same as reported for 5.12
> > 
> > https://www.spinics.net/lists/stable/msg485116.html
> > 
> > Can you try to apply it to 5.10 or should I resend?
> 
> I just tried applying those patches and they did not work.  So can you
> provide some new backports?

Here is the backport for v5.10.y. I have also tested these with the
syzkaller repro and the issue is fixed.

--
Regards
Sudip

--FG6w6bPYvW4GhxJr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-io_uring-put-link-timeout-req-consistently.patch"

From bd136e16d2f1b5480c60f4e78f18727d568c7d86 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Thu, 1 Apr 2021 15:43:59 +0100
Subject: [PATCH 1/2] io_uring: put link timeout req consistently

commit df9727affa058f4f18e388b30247650f8ae13cd8 upstream

Don't put linked timeout req in io_async_find_and_cancel() but do it in
io_link_timeout_fn(), so we have only one point for that and won't have
to do it differently as it's now (put vs put_deferred). Btw, improve a
bit io_async_find_and_cancel()'s locking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/d75b70957f245275ab7cba83e0ac9c1b86aae78a.1617287883.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/io_uring.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 42153106b7bc..a6c9c55ca3a3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5697,12 +5697,9 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	int ret;
 
 	ret = io_async_cancel_one(ctx, (void *) (unsigned long) sqe_addr);
-	if (ret != -ENOENT) {
-		spin_lock_irqsave(&ctx->completion_lock, flags);
-		goto done;
-	}
-
 	spin_lock_irqsave(&ctx->completion_lock, flags);
+	if (ret != -ENOENT)
+		goto done;
 	ret = io_timeout_cancel(ctx, sqe_addr);
 	if (ret != -ENOENT)
 		goto done;
@@ -5717,7 +5714,6 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req(req);
 }
 
 static int io_async_cancel_prep(struct io_kiocb *req,
@@ -6263,8 +6259,8 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 		io_put_req_deferred(req, 1);
 	} else {
 		io_cqring_add_event(req, -ETIME, 0);
-		io_put_req_deferred(req, 1);
 	}
+	io_put_req_deferred(req, 1);
 	return HRTIMER_NORESTART;
 }
 
-- 
2.30.2


--FG6w6bPYvW4GhxJr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-io_uring-fix-link-timeout-refs.patch"

From b901fb09894731c4ad84a359509508eff50a4920 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Fri, 7 May 2021 21:06:38 +0100
Subject: [PATCH 2/2] io_uring: fix link timeout refs

commit a298232ee6b9a1d5d732aa497ff8be0d45b5bd82 upstream

WARNING: CPU: 0 PID: 10242 at lib/refcount.c:28 refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
RIP: 0010:refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
Call Trace:
 __refcount_sub_and_test include/linux/refcount.h:283 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 io_put_req fs/io_uring.c:2140 [inline]
 io_queue_linked_timeout fs/io_uring.c:6300 [inline]
 __io_queue_sqe+0xbef/0xec0 fs/io_uring.c:6354
 io_submit_sqe fs/io_uring.c:6534 [inline]
 io_submit_sqes+0x2bbd/0x7c50 fs/io_uring.c:6660
 __do_sys_io_uring_enter fs/io_uring.c:9240 [inline]
 __se_sys_io_uring_enter+0x256/0x1d60 fs/io_uring.c:9182

io_link_timeout_fn() should put only one reference of the linked timeout
request, however in case of racing with the master request's completion
first io_req_complete() puts one and then io_put_req_deferred() is
called.

Cc: stable@vger.kernel.org # 5.12+
Fixes: 9ae1f8dd372e0 ("io_uring: fix inconsistent lock state")
Reported-by: syzbot+a2910119328ce8e7996f@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/ff51018ff29de5ffa76f09273ef48cb24c720368.1620417627.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a6c9c55ca3a3..1a5951fbc763 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6260,7 +6260,6 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	} else {
 		io_cqring_add_event(req, -ETIME, 0);
 	}
-	io_put_req_deferred(req, 1);
 	return HRTIMER_NORESTART;
 }
 
-- 
2.30.2


--FG6w6bPYvW4GhxJr--
