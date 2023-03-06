Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E673E6ABD5B
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 11:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjCFKvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 05:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjCFKvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 05:51:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E3826CEC
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 02:50:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B33260DE9
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 10:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E39FC433D2;
        Mon,  6 Mar 2023 10:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678099832;
        bh=l3HoJtgk1uoKpA0Iu6Ym7B11VyJ9AgQqxlolSuX45uI=;
        h=Subject:To:Cc:From:Date:From;
        b=BgtESQFzcfESIINffFIRsRecakc9yGX8rsXApbOWOG2157N0EPTgj1ZCMdhoOMhwU
         Wo/mnvb5QMD5Bp1W9/Ly9L99z0GmfupGyqi/cQ11LJo8r1xOuDhnWJdTx8KnENbMwj
         dqAh8NIGwrOw0wWRjwuqzCUE5sC70WvvH0G5BVxs=
Subject: FAILED: patch "[PATCH] io_uring/poll: allow some retries for poll triggering" failed to apply to 5.10-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 11:50:21 +0100
Message-ID: <167809982125422@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x c16bda37594f83147b167d381d54c010024efecf
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167809982125422@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

c16bda37594f ("io_uring/poll: allow some retries for poll triggering spuriously")
9b797a37c4bd ("io_uring: add abstraction around apoll cache")
9da7471ed10d ("io_uring: move apoll cache to poll.c")
5204aa8c43bd ("io_uring: add a helper for apoll alloc")
d9b57aa3cfc7 ("io_uring: move opcode table to opdef.c")
f3b44f92e59a ("io_uring: move read/write related opcodes to its own file")
c98817e6cd44 ("io_uring: move remaining file table manipulation to filetable.c")
735729844819 ("io_uring: move rsrc related data, core, and commands")
3b77495a9723 ("io_uring: split provided buffers handling into its own file")
7aaff708a768 ("io_uring: move cancelation into its own file")
329061d3e2f9 ("io_uring: move poll handling into its own file")
cfd22e6b3319 ("io_uring: add opcode name to io_op_defs")
92ac8beaea1f ("io_uring: include and forward-declaration sanitation")
c9f06aa7de15 ("io_uring: move io_uring_task (tctx) helpers into its own file")
a4ad4f748ea9 ("io_uring: move fdinfo helpers to its own file")
e5550a1447bf ("io_uring: use io_is_uring_fops() consistently")
17437f311490 ("io_uring: move SQPOLL related handling into its own file")
59915143e89f ("io_uring: move timeout opcodes and handling into its own file")
e418bbc97bff ("io_uring: move our reference counting into a header")
36404b09aa60 ("io_uring: move msg_ring into its own file")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c16bda37594f83147b167d381d54c010024efecf Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sat, 25 Feb 2023 12:53:53 -0700
Subject: [PATCH] io_uring/poll: allow some retries for poll triggering
 spuriously

If we get woken spuriously when polling and fail the operation with
-EAGAIN again, then we generally only allow polling again if data
had been transferred at some point. This is indicated with
REQ_F_PARTIAL_IO. However, if the spurious poll triggers when the socket
was originally empty, then we haven't transferred data yet and we will
fail the poll re-arm. This either punts the socket to io-wq if it's
blocking, or it fails the request with -EAGAIN if not. Neither condition
is desirable, as the former will slow things down, while the latter
will make the application confused.

We want to ensure that a repeated poll trigger doesn't lead to infinite
work making no progress, that's what the REQ_F_PARTIAL_IO check was
for. But it doesn't protect against a loop post the first receive, and
it's unnecessarily strict if we started out with an empty socket.

Add a somewhat random retry count, just to put an upper limit on the
potential number of retries that will be done. This should be high enough
that we won't really hit it in practice, unless something needs to be
aborted anyway.

Cc: stable@vger.kernel.org # v5.10+
Link: https://github.com/axboe/liburing/issues/364
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 8339a92b4510..a82d6830bdfd 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -650,6 +650,14 @@ static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
 	__io_queue_proc(&apoll->poll, pt, head, &apoll->double_poll);
 }
 
+/*
+ * We can't reliably detect loops in repeated poll triggers and issue
+ * subsequently failing. But rather than fail these immediately, allow a
+ * certain amount of retries before we give up. Given that this condition
+ * should _rarely_ trigger even once, we should be fine with a larger value.
+ */
+#define APOLL_MAX_RETRY		128
+
 static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 					     unsigned issue_flags)
 {
@@ -665,14 +673,18 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 		if (entry == NULL)
 			goto alloc_apoll;
 		apoll = container_of(entry, struct async_poll, cache);
+		apoll->poll.retries = APOLL_MAX_RETRY;
 	} else {
 alloc_apoll:
 		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 		if (unlikely(!apoll))
 			return NULL;
+		apoll->poll.retries = APOLL_MAX_RETRY;
 	}
 	apoll->double_poll = NULL;
 	req->apoll = apoll;
+	if (unlikely(!--apoll->poll.retries))
+		return NULL;
 	return apoll;
 }
 
@@ -694,8 +706,6 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 		return IO_APOLL_ABORTED;
 	if (!file_can_poll(req->file))
 		return IO_APOLL_ABORTED;
-	if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
-		return IO_APOLL_ABORTED;
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
 		mask |= EPOLLONESHOT;
 
diff --git a/io_uring/poll.h b/io_uring/poll.h
index 5f3bae50fc81..b2393b403a2c 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -12,6 +12,7 @@ struct io_poll {
 	struct file			*file;
 	struct wait_queue_head		*head;
 	__poll_t			events;
+	int				retries;
 	struct wait_queue_entry		wait;
 };
 

