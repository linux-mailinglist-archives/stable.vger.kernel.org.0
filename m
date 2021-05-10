Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6197A377DEE
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhEJIT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:19:28 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:51405 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhEJITZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:19:25 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 48FCE1940360;
        Mon, 10 May 2021 04:18:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 10 May 2021 04:18:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=iinR/C
        cFnlHE4kO3sOTzftmHBXjUZ871QEsPtRobRdg=; b=aUy6AOLqetC2IfmlyP30sI
        eHF3KnjaNAr+Sa2ds+DrGiYza6KZLPe9WxYgU7hae/4yA79q3Fku8I8oh1fGbK63
        5UNzdJns0emMdZ2HUTtojJUb1ZhKVVt1B2Vuo1P6hgMuZJ9DwWvQeSElHrW0nPaE
        OwNCR/Rr2Yo5qFYoNOdJ8X6F0LPRB2kU6MhBWqmnNnn42K7bx+Qe2oingKK9maEt
        cIznVOb6w+JLZk75VgHUI233lJogTRT05pyrH2zWmIeRVsOrJYX1XopeDP42hlhI
        xQkd5eNufqUIBKDAHcwvEppiKsCF17uw0WUliWGiflI7DUqVzoHbquykZE6VUOgw
        ==
X-ME-Sender: <xms:S-yYYJDi2Ed0aAxJa44xnAUwhlbJmSL-dVTFzwMrlmkPTXYW0-dQNw>
    <xme:S-yYYHjzm3fLSZVeWYHcOR0jmFJE5QDqDuDVAw3XfkEdBKtWIGA7AAwnJx2GnhHHz
    w4ItyaIa3mwlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:S-yYYEnSJIRNm7Bxpe1JH3XbKID8I0w7VQeM1ytDW7mkfAvPFMLqfw>
    <xmx:S-yYYDyLysbzGEsFjAGWUiiIn_hwuDloTPK887SJaYmJY8VinODAqQ>
    <xmx:S-yYYOT06Dx67nCPPVMNqGh0rE8Z-7w7D2ZnmLSDHYMJn3vObE6mDA>
    <xmx:TOyYYH6PNMvucGPRWjPCsK_p1v4gvqAaIyGh0sYJa6TYE2AB2ivJcA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:18:19 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: remove extra sqpoll submission halting" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:18:18 +0200
Message-ID: <162063469839197@kroah.com>
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

From 3b763ba1c77da5806e4fdc5684285814fe970c98 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Sun, 18 Apr 2021 14:52:08 +0100
Subject: [PATCH] io_uring: remove extra sqpoll submission halting

SQPOLL task won't submit requests for a context that is currently dying,
so no need to remove ctx from sqd_list prior the main loop of
io_ring_exit_work(). Kill it, will be removed by io_sq_thread_finish()
and only brings confusion and lockups.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f220c2b786ba0f9499bebc9f3cd9714d29efb6a5.1618752958.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e491b815df8c..4fc54cd40470 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6750,6 +6750,10 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		if (!list_empty(&ctx->iopoll_list))
 			io_do_iopoll(ctx, &nr_events, 0);
 
+		/*
+		 * Don't submit if refs are dying, good for io_uring_register(),
+		 * but also it is relied upon by io_ring_exit_work()
+		 */
 		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)) &&
 		    !(ctx->flags & IORING_SETUP_R_DISABLED))
 			ret = io_submit_sqes(ctx, to_submit);
@@ -8540,14 +8544,6 @@ static void io_ring_exit_work(struct work_struct *work)
 	struct io_tctx_node *node;
 	int ret;
 
-	/* prevent SQPOLL from submitting new requests */
-	if (ctx->sq_data) {
-		io_sq_thread_park(ctx->sq_data);
-		list_del_init(&ctx->sqd_list);
-		io_sqd_update_thread_idle(ctx->sq_data);
-		io_sq_thread_unpark(ctx->sq_data);
-	}
-
 	/*
 	 * If we're doing polled IO and end up having requests being
 	 * submitted async (out-of-line), then completions can come in while

