Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEB8377DF2
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhEJIUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:20:16 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:50863 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230157AbhEJIUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:20:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id EF5A51940BBB;
        Mon, 10 May 2021 04:19:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 10 May 2021 04:19:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fks96I
        X7Av02GmPka7cLpfEy+Nb6IzJIg1aX+XfeDX4=; b=Mq9B6jyYARTpeDPBewQ6X2
        A2M8Rr8RFiNELPZxS/wPKvmpMEmYZHdwrIWY97+eXrLiBv3Jsn8E78Yd+/jq5VW9
        PS5REDFsi51Cmtmr0vYqOYg3/1nk/bNDOT/dDxPWXK2DI2BmIZ5C5zBH45L93Tgy
        Hd9EMqmG4exIhk8VZQ/yyzD4NbC6z9+uMkpdNwAedpWhV7hKYlVsvUDRF4X3wdTG
        O56u9ZbNgSQOWArLQWbc8TXSShGeXe0pQkkV41VEOLnOlTbbu9V9yoKAwLwFw7nw
        STi+QxLxeSCi9h8Z/DSvJZMYo8OT9gZCCK+rwHtUzReYo/ROSVI3DsMF6JQOCQXw
        ==
X-ME-Sender: <xms:feyYYLyFPrHFiEj2POwo3xQLf_lHpHHEN7e9RBlZAsntOYJgY_UecQ>
    <xme:feyYYDT1Cz2752J-rxpMYa5qaF0B826m7Hm178YwqDf99TP6YhjmwIxg2iGafqHpF
    7ZU3pxmg-g2kA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:feyYYFV3tNcTmcEZWa--GD9blXdHwAYVpCyHIs43Z6HKQmcDz4YrEQ>
    <xmx:feyYYFiZTPibawCqbLHWiXC4GsYMJO6her1CylML9t7kHNLDviYepA>
    <xmx:feyYYNAexnPnMElVO6SPeE9bKx6UrJPnJYsaxAG4HpUbDQ6lC8hyGw>
    <xmx:feyYYApK9xZaB2ymG8U8RwWNAec-golVZeNu-wTf3SJhxW6wPhpVvw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:19:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: fix work_exit sqpoll cancellations" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:19:07 +0200
Message-ID: <1620634747239154@kroah.com>
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

From 28090c133869b461c5366195a856d73469ab87d9 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Sun, 25 Apr 2021 23:34:45 +0100
Subject: [PATCH] io_uring: fix work_exit sqpoll cancellations

After closing an SQPOLL ring, io_ring_exit_work() kicks in and starts
doing cancellations via io_uring_try_cancel_requests(). It will go
through io_uring_try_cancel_iowq(), which uses ctx->tctx_list, but as
SQPOLL task don't have a ctx note, its io-wq won't be reachable and so
is left not cancelled.

It will eventually cancelled when one of the tasks dies, but if a thread
group survives for long and changes rings, it will spawn lots of
unreclaimed resources and live locked works.

Cancel SQPOLL task's io-wq separately in io_ring_exit_work().

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/a71a7fe345135d684025bb529d5cb1d8d6b46e10.1619389911.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 577520445fa0..f20622bd963b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8679,6 +8679,13 @@ static void io_tctx_exit_cb(struct callback_head *cb)
 	complete(&work->completion);
 }
 
+static bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
+{
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+
+	return req->ctx == data;
+}
+
 static void io_ring_exit_work(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
@@ -8695,6 +8702,17 @@ static void io_ring_exit_work(struct work_struct *work)
 	 */
 	do {
 		io_uring_try_cancel_requests(ctx, NULL, NULL);
+		if (ctx->sq_data) {
+			struct io_sq_data *sqd = ctx->sq_data;
+			struct task_struct *tsk;
+
+			io_sq_thread_park(sqd);
+			tsk = sqd->thread;
+			if (tsk && tsk->io_uring && tsk->io_uring->io_wq)
+				io_wq_cancel_cb(tsk->io_uring->io_wq,
+						io_cancel_ctx_cb, ctx, true);
+			io_sq_thread_unpark(sqd);
+		}
 
 		WARN_ON_ONCE(time_after(jiffies, timeout));
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
@@ -8844,13 +8862,6 @@ static bool io_cancel_defer_files(struct io_ring_ctx *ctx,
 	return true;
 }
 
-static bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
-{
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-
-	return req->ctx == data;
-}
-
 static bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 {
 	struct io_tctx_node *node;

