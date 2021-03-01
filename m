Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC17327DFA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbhCAMNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:13:31 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:47135 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232283AbhCAMNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 07:13:25 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 997691941649;
        Mon,  1 Mar 2021 07:12:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 01 Mar 2021 07:12:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ECX4hw
        f6LWxYFfVIxtnuWLIMmEHLgDDmlyjEtksdKfQ=; b=jAtR/opUSr5Y9qW3EMQPFd
        OZ/Ome2p33PCj1Vs3Vp5jPH7P3UzPVjOXKB0jA7ajjtJmxKXuSwo0Jdjq2rYtGCG
        IjttQQLJZj8zDaUPqKeShWrwKJQMJWvdAFfVF2BpDnJjjHtgCoPZyxsREVK7LMxk
        x92A7ZtmSzQIitCeehCMNXiD4aglJxAlBV8YNtG+ijqgubo+hiqufuQ0imoWh4/5
        vMtvqv0oAlO+PXalBrLIUGEvFl+O7rmZarpjxZy0r2C+6Vgh3J7lm40dYbXJA89L
        SnE3UjffqGY86Q7mNXnMlWzARRpcEERgxyK0bBgkrLjVj6nWz7nqix172bt8x+bQ
        ==
X-ME-Sender: <xms:Ndo8YCydKru6FXliuwmGFcsb3_nqoqdPjSBBLXWI80bZC0eMF0-xkQ>
    <xme:Ndo8YBh8aDsFKhRJIh_F5P0U28ezbv5GjcoxW0PYqpF0YZ9rYbBsSL4SLSaC3CBAl
    67lZgPbkX8hqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecuogfuohhrthgvugftvggtihhpvdculdegtddmnecujf
    gurhepuffvhfffkfggtgfgsehtkeertddttdflnecuhfhrohhmpeeoghhrvghgkhhhsehl
    ihhnuhigfhhouhhnuggrthhiohhnrdhorhhgqeenucggtffrrghtthgvrhhnpeeiteevhe
    euvdfhtdfgvdeiieehheefleevveehjeduteevueevledujeejgfetheenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Ndo8YNzp5EnHHICeMNnFCmL2hnVFchODvYqdOKS2oAstqVO6ND4o1A>
    <xmx:Ndo8YEK2xOmt2Ci3b4IGRLxcivkpT1BCl2eS0cKQbEC_UF7AsdQWSQ>
    <xmx:Ndo8YERn6o87K6rrrUsohw8Gp3vcvpbCQltu-pmRpCOsXcOF3tSXEA>
    <xmx:Nto8YKqoJQbGKazjZCxYC76uMdTwrRVMddsSLbByScPDidEwK5IO4g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 71D9B1080054;
        Mon,  1 Mar 2021 07:12:37 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: don't take uring_lock during iowq cancel" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, abaci@linux.alibaba.com, axboe@kernel.dk,
        haoxu@linux.alibaba.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 13:12:36 +0100
Message-ID: <161460075611654@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 792bb6eb862333658bf1bd2260133f0507e2da8d Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Thu, 18 Feb 2021 22:32:51 +0000
Subject: [PATCH] io_uring: don't take uring_lock during iowq cancel

[   97.866748] a.out/2890 is trying to acquire lock:
[   97.867829] ffff8881046763e8 (&ctx->uring_lock){+.+.}-{3:3}, at:
io_wq_submit_work+0x155/0x240
[   97.869735]
[   97.869735] but task is already holding lock:
[   97.871033] ffff88810dfe0be8 (&ctx->uring_lock){+.+.}-{3:3}, at:
__x64_sys_io_uring_enter+0x3f0/0x5b0
[   97.873074]
[   97.873074] other info that might help us debug this:
[   97.874520]  Possible unsafe locking scenario:
[   97.874520]
[   97.875845]        CPU0
[   97.876440]        ----
[   97.877048]   lock(&ctx->uring_lock);
[   97.877961]   lock(&ctx->uring_lock);
[   97.878881]
[   97.878881]  *** DEADLOCK ***
[   97.878881]
[   97.880341]  May be due to missing lock nesting notation
[   97.880341]
[   97.881952] 1 lock held by a.out/2890:
[   97.882873]  #0: ffff88810dfe0be8 (&ctx->uring_lock){+.+.}-{3:3}, at:
__x64_sys_io_uring_enter+0x3f0/0x5b0
[   97.885108]
[   97.885108] stack backtrace:
[   97.890457] Call Trace:
[   97.891121]  dump_stack+0xac/0xe3
[   97.891972]  __lock_acquire+0xab6/0x13a0
[   97.892940]  lock_acquire+0x2c3/0x390
[   97.894894]  __mutex_lock+0xae/0x9f0
[   97.901101]  io_wq_submit_work+0x155/0x240
[   97.902112]  io_wq_cancel_cb+0x162/0x490
[   97.904126]  io_async_find_and_cancel+0x3b/0x140
[   97.905247]  io_issue_sqe+0x86d/0x13e0
[   97.909122]  __io_queue_sqe+0x10b/0x550
[   97.913971]  io_queue_sqe+0x235/0x470
[   97.914894]  io_submit_sqes+0xcce/0xf10
[   97.917872]  __x64_sys_io_uring_enter+0x3fb/0x5b0
[   97.921424]  do_syscall_64+0x2d/0x40
[   97.922329]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

While holding uring_lock, e.g. from inline execution, async cancel
request may attempt cancellations through io_wq_submit_work, which may
try to grab a lock. Delay it to task_work, so we do it from a clean
context and don't have to worry about locking.

Cc: <stable@vger.kernel.org> # 5.5+
Fixes: c07e6719511e ("io_uring: hold uring_lock while completing failed polled io in io_wq_submit_work()")
Reported-by: Abaci <abaci@linux.alibaba.com>
Reported-by: Hao Xu <haoxu@linux.alibaba.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2fdfe5fa00b0..8dab07f42b34 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2337,7 +2337,9 @@ static void io_req_task_cancel(struct callback_head *cb)
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
 	struct io_ring_ctx *ctx = req->ctx;
 
+	mutex_lock(&ctx->uring_lock);
 	__io_req_task_cancel(req, -ECANCELED);
+	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
 }
 
@@ -6426,8 +6428,13 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	if (timeout)
 		io_queue_linked_timeout(timeout);
 
-	if (work->flags & IO_WQ_WORK_CANCEL)
-		ret = -ECANCELED;
+	if (work->flags & IO_WQ_WORK_CANCEL) {
+		/* io-wq is going to take down one */
+		refcount_inc(&req->refs);
+		percpu_ref_get(&req->ctx->refs);
+		io_req_task_work_add_fallback(req, io_req_task_cancel);
+		return;
+	}
 
 	if (!ret) {
 		do {

