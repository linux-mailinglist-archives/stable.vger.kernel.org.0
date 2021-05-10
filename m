Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E437377DF3
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhEJIUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:20:24 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:60759 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230138AbhEJIUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:20:23 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1965C1940BBB;
        Mon, 10 May 2021 04:19:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 10 May 2021 04:19:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=IE7K3L
        sJprrBTMnUhw3SeUa4QPbTP3yh60+ljGTMgXY=; b=s2pqK7bgW6F5oV0asb5SSa
        ExL8tOZJKdNhUDLlD/smTi8/JQASdGtJmP5lKI1VjDGVpyiNzArEcFFFZqOB18sP
        799FpPidXK42ZvlaOK5XjFffsiswIvMZ4+O37BERCd2ORQYND9uN06s/hzZIH84T
        3X1YqzRJ5vM+pV9yodf1FSQH9NVeus1apnFoa5NyQ89KPVvZTWfRGaom9WjjyrJk
        4bmXnLGpwGW8MCjXXBpyUlJAq0ZAcvLuiQi/yo3eluSAxRa1SY2Z6KXsnY8nx3+l
        /T4YB10Jt4bfOwIRuvWHCzw6tv3iyHn6SuQOUIiSdFuINTlvA8RXZ7dJ/lpZyhbA
        ==
X-ME-Sender: <xms:huyYYNM_N0GW3PNrBZBRPrzIyqGuksJEj4M3b9Vs-st-LaieV1r1Ww>
    <xme:huyYYP_aV4CWYKcQxBFlqOUNeY5bLMpQu6Db8IopoymAItOOpaTIbZxbX1s2_RnaM
    lRt38n6-VaPMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:huyYYMSwnZAovm9O0tgI7M98bLoSqmhCuofU734CWCTM8S_g_NwKjA>
    <xmx:huyYYJvHh3HNA7-c7-701IwJSwSw8PT9a-ydHwakos1PAfECLTTsvA>
    <xmx:huyYYFcDTf2sjgUiIBJtWE7KUlUXYXg6kguZ_aAD5Kzwv0HEhTRz0g>
    <xmx:h-yYYFmivgUv-0qK4wtampTGj60TySQlHGbJB6LvLfI5IoB5VQPAyQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:19:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: fix work_exit sqpoll cancellations" failed to apply to 5.11-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:19:08 +0200
Message-ID: <1620634748105107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
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

