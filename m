Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22AC327DF7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhCAMNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:13:08 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:41551 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232818AbhCAMNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 07:13:06 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E94BA194164E;
        Mon,  1 Mar 2021 07:12:19 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 07:12:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8vuJII
        CrT+y41dAexaeNXbnHjlzLnW5+S4TS1WtOpiM=; b=QIENVba7kBBMAZ+jwp6lVf
        cSDX8qObufyv8LRpEaUQaLJBPp2gstNQ6rksZOGPzqXx3+O6PNDMIbo/L6yB4A24
        1p9FzQZFkE4gM9cH0kziOFIGkyiTQNxzNUV3J7+KunN9JpkOV+7bhdh7AFZ3vWre
        /M2DKOn7FTL6Dg/3M5bb0qh7NphON953wqENFq7fIlaywg9Noio1xaJtYgk5IpeU
        xJ5y65d1pHCAXp7ha6v7CVWVunBR9WDmIhJFz38NWdXvx1LLInP5fUjCm88hjEeu
        8GYJjHL/zpnSzMnhWej2ud3wsXo4NMgDVCzyLWip2Rcz3ztmVLES3u00rW0Dug6A
        ==
X-ME-Sender: <xms:I9o8YAH8sshMLbtpGRxvBzFpeXDwLuvbXWe0vILPpFsL8_BGBMAAXA>
    <xme:I9o8YJVOgLnjZTAE5xkFrkb7zrTuMrDoF4dqmWkvGVLvTjPsJwUiFAtPazsHwrJ_V
    5MDzqdZXD9Q-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:I9o8YKKr9-CnT7PwK2E0Wn6spIRQj3PjwTmtdEjkZNi5TQpC9-jPpg>
    <xmx:I9o8YCEM40cFo7arMAJZwCk5TtH4OYPnSIaocZHxzPDmEwN08YYfQA>
    <xmx:I9o8YGWUQaEpD5H7KuLjZp6N6oIoTzVTdXet8LRkSMd-KWoMbEDboQ>
    <xmx:I9o8YPfaPWjDAjfffYt7JX6bYXfA5863d4eVQMRhxxi71hFfePlsPA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 832281080054;
        Mon,  1 Mar 2021 07:12:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: unpark SQPOLL thread for cancelation" failed to apply to 5.11-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 13:12:17 +0100
Message-ID: <161460073740145@kroah.com>
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
 

