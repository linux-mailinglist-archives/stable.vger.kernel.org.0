Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BE8394C5B
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 15:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhE2NuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 09:50:23 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:44621 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229681AbhE2NuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 09:50:23 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id BF2851940EF9;
        Sat, 29 May 2021 09:48:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 29 May 2021 09:48:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=dqoknD
        Ra+SafVgW2rYVqNVXJ6oJAlmyYDwblaNLDGjo=; b=AV0iG6vbgnwRCybkSmZtSa
        3P+u8F8wLJcYwMLa9N/a1ObP/r68o6ULa4lyPaEXc7AFM7w40eYlHvA9lpAhaHcC
        5/MaYixTeQ7Ex9xa/1k2mN7OeSotWDY3A0me6RXV8jti2tgmgzA7EVdO71XcOC2P
        6J6irumwJMNPXL/nVXkAFhyX6+SoJfcq1o+XuPvm+3NpZ4cRwOPMmcLIV1u9g9Mk
        lxj+R416W8mRPFEdJFkHaQ+VbwYK1QMXzoL+aa9YsXDtepLMPQ4CUoUOOmvBkFbZ
        wPBuwqVxga6oKCTgelTd7X4EVCHzFTMXkRUlzgyDtNAJS60SL+wHkeYTIHlF/buA
        ==
X-ME-Sender: <xms:PkayYIDtg9qoWHCJHQ2j8ioHP1Zo3PWWjtdcxH0tkU7dbQfANSHo0A>
    <xme:PkayYKg7g8uCU2fCLvRWSmU3CmxWwHbS3nvhnzP74tYo3DKFzKTVCkweodpETii33
    H3ElXwXzBUS9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:PkayYLmuuTRaYx_VIR5ZsZUEAnM49D_SMaAKu8MHI2jxxVm8fW1CBg>
    <xmx:PkayYOwGeQvcuVUYAsD5nBIHM7ADjMjnqlAqkK9dv9m8iIoF_PZoeQ>
    <xmx:PkayYNS-k-SmNgTSONH4ciMYY2asT3MvHS3xQItx7EowrKnKGaQ5bw>
    <xmx:PkayYO6Jfm8Pd2xDm41_cDhm-F2_trF_o4zGkAwjazayhHbBTyXqBA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 09:48:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring/io-wq: close io-wq full-stop gap" failed to apply to 5.12-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 15:48:44 +0200
Message-ID: <16222961241674@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 17a91051fe63b40ec651b80097c9fff5b093fdc5 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Sun, 23 May 2021 15:48:39 +0100
Subject: [PATCH] io_uring/io-wq: close io-wq full-stop gap

There is an old problem with io-wq cancellation where requests should be
killed and are in io-wq but are not discoverable, e.g. in @next_hashed
or @linked vars of io_worker_handle_work(). It adds some unreliability
to individual request canellation, but also may potentially get
__io_uring_cancel() stuck. For instance:

1) An __io_uring_cancel()'s cancellation round have not found any
   request but there are some as desribed.
2) __io_uring_cancel() goes to sleep
3) Then workers wake up and try to execute those hidden requests
   that happen to be unbound.

As we already cancel all requests of io-wq there, set IO_WQ_BIT_EXIT
in advance, so preventing 3) from executing unbound requests. The
workers will initially break looping because of getting a signal as they
are threads of the dying/exec()'ing user task.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/abfcf8c54cb9e8f7bfbad7e9a0cc5433cc70bdc2.1621781238.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 5361a9b4b47b..de9b7ba3ba01 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -979,13 +979,16 @@ static bool io_task_work_match(struct callback_head *cb, void *data)
 	return cwd->wqe->wq == data;
 }
 
+void io_wq_exit_start(struct io_wq *wq)
+{
+	set_bit(IO_WQ_BIT_EXIT, &wq->state);
+}
+
 static void io_wq_exit_workers(struct io_wq *wq)
 {
 	struct callback_head *cb;
 	int node;
 
-	set_bit(IO_WQ_BIT_EXIT, &wq->state);
-
 	if (!wq->task)
 		return;
 
@@ -1020,8 +1023,6 @@ static void io_wq_destroy(struct io_wq *wq)
 
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
 
-	io_wq_exit_workers(wq);
-
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 		struct io_cb_cancel_data match = {
@@ -1036,16 +1037,13 @@ static void io_wq_destroy(struct io_wq *wq)
 	kfree(wq);
 }
 
-void io_wq_put(struct io_wq *wq)
-{
-	if (refcount_dec_and_test(&wq->refs))
-		io_wq_destroy(wq);
-}
-
 void io_wq_put_and_exit(struct io_wq *wq)
 {
+	WARN_ON_ONCE(!test_bit(IO_WQ_BIT_EXIT, &wq->state));
+
 	io_wq_exit_workers(wq);
-	io_wq_put(wq);
+	if (refcount_dec_and_test(&wq->refs))
+		io_wq_destroy(wq);
 }
 
 static bool io_wq_worker_affinity(struct io_worker *worker, void *data)
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 0e6d310999e8..af2df0680ee2 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -122,7 +122,7 @@ struct io_wq_data {
 };
 
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data);
-void io_wq_put(struct io_wq *wq);
+void io_wq_exit_start(struct io_wq *wq);
 void io_wq_put_and_exit(struct io_wq *wq);
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5f82954004f6..6af8ca0cb01c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9078,6 +9078,9 @@ static void io_uring_cancel_sqpoll(struct io_sq_data *sqd)
 
 	if (!current->io_uring)
 		return;
+	if (tctx->io_wq)
+		io_wq_exit_start(tctx->io_wq);
+
 	WARN_ON_ONCE(!sqd || sqd->thread != current);
 
 	atomic_inc(&tctx->in_idle);
@@ -9112,6 +9115,9 @@ void __io_uring_cancel(struct files_struct *files)
 	DEFINE_WAIT(wait);
 	s64 inflight;
 
+	if (tctx->io_wq)
+		io_wq_exit_start(tctx->io_wq);
+
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
 	do {

