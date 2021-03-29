Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7100234C3ED
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 08:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhC2GhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 02:37:02 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:48759 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229873AbhC2Ggs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 02:36:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id D1A7F1940B08;
        Mon, 29 Mar 2021 02:36:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 29 Mar 2021 02:36:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TOMZp5
        xGKMqbpI3zy9Z0VbC3gkhvxNqIMh8eFMsezBE=; b=RalyaC99GgXpVYM1QRP0Og
        /KZ9LzgbA9bY0xFBcfwzwUw0RNj5ialsZJvYIt9W/D3fApmoVoOfTJITPfzCtHSt
        XbugvM1lqcqtWwqSPxA31HoKAnYZA+qnxOlJBtl2ZmZ4O7dTQT4tNzSdUB5bLpoK
        nRmQMh4HqL9DxVTyjVbaJz5O9xVsvp5M2FHAxiiTTCqTxoIaa0cFVCMpUAFkFG7S
        0/QsBk9uLD7jZsYyWF06BUY78Y83JXKXlNFWbiFvkJV56b3JRd+0gdDXfwMaqh/e
        u7dBDicYqbaTC5micK9drXh+ivy6u1dKeCWSS7tYUIDlY1s09qRGOxc1BiSc/dyg
        ==
X-ME-Sender: <xms:f3VhYPiovcO0ztGyVqWrZtY6c19mTLa5QBvnTZ-3YOxn0qdPP4e42Q>
    <xme:f3VhYMDdJdpiabf9iZbIENGlK7A_n0QW0s2X_0pu7mevYktvyTM23iZ4U-eGvs3_W
    ONi_xWdyCJHWg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehjedguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:f3VhYPFCustrvipw3rUYBcVbg6o1l22F0nDcoPVk0M-75kvP5QscBA>
    <xmx:f3VhYMRygg-g5SrazX0W3_3LLBs0cjIZIH-AZ6INF8dBxzXVIF4WuQ>
    <xmx:f3VhYMy5ms5zUwOJbKAg1e7z6lScInyJFySUAcTD-BdYRlSAlwxhKA>
    <xmx:f3VhYJsIIGBhqWLmt4-sJv06MZgZRdgawW6MDxh7tR0iyvw_QS6erA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 81175240057;
        Mon, 29 Mar 2021 02:36:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: ensure SQPOLL startup is triggered before error" failed to apply to 5.10-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Mar 2021 08:36:37 +0200
Message-ID: <1616999797124168@kroah.com>
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

From eb85890b29e4d7ae1accdcfba35ed8b16ba9fb97 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 25 Feb 2021 10:13:29 -0700
Subject: [PATCH] io_uring: ensure SQPOLL startup is triggered before error
 shutdown

syzbot reports the following hang:

INFO: task syz-executor.0:12538 can't die for more than 143 seconds.
task:syz-executor.0  state:D stack:28352 pid:12538 ppid:  8423 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 io_sq_thread_finish+0x96/0x580 fs/io_uring.c:7152
 io_sq_offload_create fs/io_uring.c:7929 [inline]
 io_uring_create fs/io_uring.c:9465 [inline]
 io_uring_setup+0x1fb2/0x2c20 fs/io_uring.c:9550
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

which is due to exiting after the SQPOLL thread has been created, but
hasn't been started yet. Ensure that we always complete the startup
side when waiting for it to exit.

Reported-by: syzbot+c927c937cba8ef66dd4a@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fbc85afa9a87..ef743594d34a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7141,6 +7141,7 @@ static void io_sq_thread_finish(struct io_ring_ctx *ctx)
 	struct io_sq_data *sqd = ctx->sq_data;
 
 	if (sqd) {
+		complete(&sqd->startup);
 		if (sqd->thread) {
 			wait_for_completion(&ctx->sq_thread_comp);
 			io_sq_thread_park(sqd);
@@ -7927,7 +7928,7 @@ static void io_sq_offload_start(struct io_ring_ctx *ctx)
 {
 	struct io_sq_data *sqd = ctx->sq_data;
 
-	if ((ctx->flags & IORING_SETUP_SQPOLL) && sqd->thread)
+	if (ctx->flags & IORING_SETUP_SQPOLL)
 		complete(&sqd->startup);
 }
 

