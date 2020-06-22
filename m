Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50278203E51
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 19:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbgFVRsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 13:48:40 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:58465 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729886AbgFVRsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 13:48:40 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 3A3CE10EA;
        Mon, 22 Jun 2020 13:48:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 22 Jun 2020 13:48:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=C0tnAO
        3KZwW7NU33U2szZMjsrBfY3iMDBDSwmP5JRfo=; b=XY+37nDr1S4tW8qQdo8A40
        48mGldf5IK1wvAfjuDWoClgwWIzILlUkC/IGohs+OFzkYrvIl8jwGTO2k9BnfnGw
        d5bK8dcOvX9P03BJlIIEbpi9Uwoitc0ZGqj6G2VypFxu2u/nStBiRdHH9HVXoKYa
        ZrG+YN2IvMSaJGbcZAPRLhTuoGnQqJAgfOYLwusTfHPvEWUc29zZ2JzgVsvQE32P
        UukDHs7xRl3FCewjeeGHVGGpvGXWIDSnusnmM1ctqtvbtVZ5/fkZh2/0yBupuWFq
        mAV9FaPpaZT1LiusHBsA2H/Veh/nNo06mieYzdPhfnMU++HXScfS/CodnnIs3rqg
        ==
X-ME-Sender: <xms:9u7wXgi7w6gyKq8k82LsV5RofNv84R_Vp95wFJwsdVYyZ1uZFvQgGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekvddguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:9u7wXpDutVgv03wcaLt4D8IBkfG2YjRf-6In2DFOO30KTUWoC4bpPA>
    <xmx:9u7wXoFL7P1KWBCRWm6C8JA8jeAh8-QgZPqtWGUnqnFpr6MUNb7ehQ>
    <xmx:9u7wXhR4QSfVOwSYZ6p-Jb8XlRKSOe1sRY_d9xt6LOSqNbZ02Arfwg>
    <xmx:9u7wXmtjM8lHd-GyASz8CaYO2zcl1XtuiCh3XHHN3_SWQ1ioRhd2LSNyxBY>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0287C30673C9;
        Mon, 22 Jun 2020 13:48:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: add memory barrier to synchronize io_kiocb's result" failed to apply to 5.7-stable tree
To:     xiaoguang.wang@linux.alibaba.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Jun 2020 19:48:32 +0200
Message-ID: <15928481127127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bbde017a32b32d2fa8d5fddca25fade20132abf8 Mon Sep 17 00:00:00 2001
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Date: Tue, 16 Jun 2020 02:06:38 +0800
Subject: [PATCH] io_uring: add memory barrier to synchronize io_kiocb's result
 and iopoll_completed

In io_complete_rw_iopoll(), stores to io_kiocb's result and iopoll
completed are two independent store operations, to ensure that once
iopoll_completed is ture and then req->result must been perceived by
the cpu executing io_do_iopoll(), proper memory barrier should be used.

And in io_do_iopoll(), we check whether req->result is EAGAIN, if it is,
we'll need to issue this io request using io-wq again. In order to just
issue a single smp_rmb() on the completion side, move the re-submit work
to io_iopoll_complete().

Cc: stable@vger.kernel.org
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
[axboe: don't set ->iopoll_completed for -EAGAIN retry]
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index eb3797714539..9d2ae9aa8b45 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1742,6 +1742,18 @@ static int io_put_kbuf(struct io_kiocb *req)
 	return cflags;
 }
 
+static void io_iopoll_queue(struct list_head *again)
+{
+	struct io_kiocb *req;
+
+	do {
+		req = list_first_entry(again, struct io_kiocb, list);
+		list_del(&req->list);
+		refcount_inc(&req->refs);
+		io_queue_async_work(req);
+	} while (!list_empty(again));
+}
+
 /*
  * Find and free completed poll iocbs
  */
@@ -1750,12 +1762,21 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 {
 	struct req_batch rb;
 	struct io_kiocb *req;
+	LIST_HEAD(again);
+
+	/* order with ->result store in io_complete_rw_iopoll() */
+	smp_rmb();
 
 	rb.to_free = rb.need_iter = 0;
 	while (!list_empty(done)) {
 		int cflags = 0;
 
 		req = list_first_entry(done, struct io_kiocb, list);
+		if (READ_ONCE(req->result) == -EAGAIN) {
+			req->iopoll_completed = 0;
+			list_move_tail(&req->list, &again);
+			continue;
+		}
 		list_del(&req->list);
 
 		if (req->flags & REQ_F_BUFFER_SELECTED)
@@ -1773,18 +1794,9 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	if (ctx->flags & IORING_SETUP_SQPOLL)
 		io_cqring_ev_posted(ctx);
 	io_free_req_many(ctx, &rb);
-}
-
-static void io_iopoll_queue(struct list_head *again)
-{
-	struct io_kiocb *req;
 
-	do {
-		req = list_first_entry(again, struct io_kiocb, list);
-		list_del(&req->list);
-		refcount_inc(&req->refs);
-		io_queue_async_work(req);
-	} while (!list_empty(again));
+	if (!list_empty(&again))
+		io_iopoll_queue(&again);
 }
 
 static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
@@ -1792,7 +1804,6 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 {
 	struct io_kiocb *req, *tmp;
 	LIST_HEAD(done);
-	LIST_HEAD(again);
 	bool spin;
 	int ret;
 
@@ -1818,13 +1829,6 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		if (!list_empty(&done))
 			break;
 
-		if (req->result == -EAGAIN) {
-			list_move_tail(&req->list, &again);
-			continue;
-		}
-		if (!list_empty(&again))
-			break;
-
 		ret = kiocb->ki_filp->f_op->iopoll(kiocb, spin);
 		if (ret < 0)
 			break;
@@ -1837,9 +1841,6 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	if (!list_empty(&done))
 		io_iopoll_complete(ctx, nr_events, &done);
 
-	if (!list_empty(&again))
-		io_iopoll_queue(&again);
-
 	return ret;
 }
 
@@ -1990,9 +1991,13 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 
 	if (res != -EAGAIN && res != req->result)
 		req_set_fail_links(req);
-	req->result = res;
-	if (res != -EAGAIN)
+
+	WRITE_ONCE(req->result, res);
+	/* order with io_poll_complete() checking ->result */
+	if (res != -EAGAIN) {
+		smp_wmb();
 		WRITE_ONCE(req->iopoll_completed, 1);
+	}
 }
 
 /*

