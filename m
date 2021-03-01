Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15695327DFC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbhCAMNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:13:38 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:36727 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232283AbhCAMNf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 07:13:35 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id CE0DF1941648;
        Mon,  1 Mar 2021 07:12:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 01 Mar 2021 07:12:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EwtUN0
        Tvmxqx5nXXKqa/GA4aYuXy+jkZc6v5tDsp5ZU=; b=F70T77U+LVUuW1hQrotOf1
        P4Mt5DzUroF388Z3YLB2jgiD/oP1UvUoontlg0/JwDx1U0Wr5Krc2PnlMBbBi32O
        3j7oYHzBQUrQfP2q7b/uvB2VQFupq3LimpU/xljpb3q/PvXNaeapbJsN7+1mhdTw
        ij/nWz3C8sswqagV4naiqWyAzADKaTTtVGK7TB9B1RDCNGFtI2znkG1vaV4bqibl
        SiiMwPVELKPScUFaUhLIuLn7MNn3Cq0r5Twpv9ccSMB3avNNC0iAkYznsiGHfLz+
        TcQA+/Ot0Bk8kPkt7cShmfbzX5Mm781w6HlVZTqGptRaPBa9qgX2s3mOm1UrK7lw
        ==
X-ME-Sender: <xms:LNo8YKVqKllaSjbQq0X-W-7JDyeKdJBB7phFrYNncoinNntTUTFRqQ>
    <xme:LNo8YEKCP2QLnRu5G7vcoibNmo9xbZanYlPHlCMDl7UbdlZaDOkdH2i169eFFEOA7
    2OCmnMaeLns1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:LNo8YE0wmZ3E_pUpGxFU_YOaYJFkbdBDMAOHDb5Qnwukz7-YhRqcGw>
    <xmx:LNo8YC6TT1CXQ_hx5D6WZ7vHsMaTZ9j1ytaoH-3mNZWT5AKzZNtPiQ>
    <xmx:LNo8YF9e0pTkyDYfXH0dqQf8kPjpkZ7AVwCwv0Ugn-VxydZ3ZhFPcw>
    <xmx:LNo8YJypLGePS_upyE0YVbj43JpMPq9pyZHqZ0X4TZoz6dLyyXevFA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 234B824005D;
        Mon,  1 Mar 2021 07:12:28 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: unpark SQPOLL thread for cancelation" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 13:12:18 +0100
Message-ID: <161460073811784@kroah.com>
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

From 34343786ecc5ff493ca4d1f873b4386759ba52ee Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Wed, 10 Feb 2021 11:45:42 +0000
Subject: [PATCH] io_uring: unpark SQPOLL thread for cancelation

We park SQPOLL task before going into io_uring_cancel_files(), so the
task won't run task_works including those that might be important for
the cancellation passes. In this case it's io_poll_remove_one(), which
frees requests via io_put_req_deferred().

Unpark it for while waiting, it's ok as we disable submissions
beforehand, so no new requests will be generated.

INFO: task syz-executor893:8493 blocked for more than 143 seconds.
Call Trace:
 context_switch kernel/sched/core.c:4327 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
 schedule+0xcf/0x270 kernel/sched/core.c:5157
 io_uring_cancel_files fs/io_uring.c:8912 [inline]
 io_uring_cancel_task_requests+0xe70/0x11a0 fs/io_uring.c:8979
 __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9067
 io_uring_files_cancel include/linux/io_uring.h:51 [inline]
 do_exit+0x2fe/0x2ae0 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Cc: stable@vger.kernel.org # 5.5+
Reported-by: syzbot+695b03d82fa8e4901b06@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7a1e4ecf5f94..9ed79509f389 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9047,11 +9047,16 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			break;
 
 		io_uring_try_cancel_requests(ctx, task, files);
+
+		if (ctx->sq_data)
+			io_sq_thread_unpark(ctx->sq_data);
 		prepare_to_wait(&task->io_uring->wait, &wait,
 				TASK_UNINTERRUPTIBLE);
 		if (inflight == io_uring_count_inflight(ctx, task, files))
 			schedule();
 		finish_wait(&task->io_uring->wait, &wait);
+		if (ctx->sq_data)
+			io_sq_thread_park(ctx->sq_data);
 	}
 }
 

