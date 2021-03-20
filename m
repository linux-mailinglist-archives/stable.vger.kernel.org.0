Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BDB342BEC
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhCTLQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:16:13 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:38621 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229985AbhCTLQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 07:16:10 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 14F6119409A5;
        Sat, 20 Mar 2021 06:44:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 20 Mar 2021 06:44:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=uvASe8
        q/RrRqTRoX8RAeEK7OIljBWfxmc+8k9jLs0PE=; b=VdseSvpD2t0tBl5K+qW7Qb
        YI9iui5IfM/8Z1MUMFGmPhQ7f9w77ty1n1YOeeISQocbSEs7BqRba2wsqDWDhKwG
        R8qkwtsAFjo++z6HWN1Gv5HC5jblPtKFzpPYvXOHvWoiEETMZbg1kRLgq8i2kMKX
        sNN1Zp7K3RE5pKsmqyK2LeFOe2VtSNpG23D7RpbqWEQ01bgkP0IzsSCljdrVG4k0
        TKSI0JYOWMnKqR11OTBn086QQYQVWzRedNdBFlIB5J4htFvGN01+R+wiPzBSTCRh
        3K0jehIFgs7ukAyqXUCLIEDWpe04L3IRayQPZOedb/U9vfm3omXAxQrGXi8+Ds6Q
        ==
X-ME-Sender: <xms:_9FVYHfpFwctNG59J9jLzOG3s-fjWFkgJW-4slDYJsbKGYANxztS_w>
    <xme:_9FVYNNtmTSKoIiO2ui3XqhIzgDHV-yTswR_lFnKUAjsqzPI0jhp0UuvZEl-i1NEw
    ZYyhftoG7p1Tw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegtddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:_9FVYAit420uKR7ID5acGP7NNFVEWaq7z1GPKaL2pX69-tCbhru6iQ>
    <xmx:_9FVYI9IqQ8ZLE-6v8Ykr3q-ZBQwxMmPNDi6qOP2KzPpWtQHShlmUg>
    <xmx:_9FVYDsjXOQLo2zhM8Vn_K-hy0_06OGvuWH-69PzYrPbug2sKew3Ww>
    <xmx:AdJVYM48FCP9T75GBeRRjp6op3HLdhJR9M-s_xi2rv1ixkw5t1li8g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 95C8F2400DE;
        Sat, 20 Mar 2021 06:44:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: convert io_buffer_idr to XArray" failed to apply to 5.11-stable tree
To:     axboe@kernel.dk, hulkci@huawei.com, willy@infradead.org,
        yangerkun@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 20 Mar 2021 11:44:13 +0100
Message-ID: <1616237053254155@kroah.com>
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

From 9e15c3a0ced5a61f320b989072c24983cb1620c1 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sat, 13 Mar 2021 12:29:43 -0700
Subject: [PATCH] io_uring: convert io_buffer_idr to XArray

Like we did for the personality idr, convert the IO buffer idr to use
XArray. This avoids a use-after-free on removal of entries, since idr
doesn't like doing so from inside an iterator, and it nicely reduces
the amount of code we need to support this feature.

Fixes: 5a2e745d4d43 ("io_uring: buffer registration infrastructure")
Cc: stable@vger.kernel.org
Cc: Matthew Wilcox <willy@infradead.org>
Cc: yangerkun <yangerkun@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 05adc4887ef3..58d62dd9f8e4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -402,7 +402,7 @@ struct io_ring_ctx {
 	struct socket		*ring_sock;
 #endif
 
-	struct idr		io_buffer_idr;
+	struct xarray		io_buffers;
 
 	struct xarray		personalities;
 	u32			pers_next;
@@ -1135,7 +1135,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_waitqueue_head(&ctx->cq_wait);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	init_completion(&ctx->ref_comp);
-	idr_init(&ctx->io_buffer_idr);
+	xa_init_flags(&ctx->io_buffers, XA_FLAGS_ALLOC1);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
@@ -2843,7 +2843,7 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-	head = idr_find(&req->ctx->io_buffer_idr, bgid);
+	head = xa_load(&req->ctx->io_buffers, bgid);
 	if (head) {
 		if (!list_empty(&head->list)) {
 			kbuf = list_last_entry(&head->list, struct io_buffer,
@@ -2851,7 +2851,7 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 			list_del(&kbuf->list);
 		} else {
 			kbuf = head;
-			idr_remove(&req->ctx->io_buffer_idr, bgid);
+			xa_erase(&req->ctx->io_buffers, bgid);
 		}
 		if (*len > kbuf->len)
 			*len = kbuf->len;
@@ -3892,7 +3892,7 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
 	}
 	i++;
 	kfree(buf);
-	idr_remove(&ctx->io_buffer_idr, bgid);
+	xa_erase(&ctx->io_buffers, bgid);
 
 	return i;
 }
@@ -3910,7 +3910,7 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 	lockdep_assert_held(&ctx->uring_lock);
 
 	ret = -ENOENT;
-	head = idr_find(&ctx->io_buffer_idr, p->bgid);
+	head = xa_load(&ctx->io_buffers, p->bgid);
 	if (head)
 		ret = __io_remove_buffers(ctx, head, p->bgid, p->nbufs);
 	if (ret < 0)
@@ -3993,21 +3993,14 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	lockdep_assert_held(&ctx->uring_lock);
 
-	list = head = idr_find(&ctx->io_buffer_idr, p->bgid);
+	list = head = xa_load(&ctx->io_buffers, p->bgid);
 
 	ret = io_add_buffers(p, &head);
-	if (ret < 0)
-		goto out;
-
-	if (!list) {
-		ret = idr_alloc(&ctx->io_buffer_idr, head, p->bgid, p->bgid + 1,
-					GFP_KERNEL);
-		if (ret < 0) {
+	if (ret >= 0 && !list) {
+		ret = xa_insert(&ctx->io_buffers, p->bgid, head, GFP_KERNEL);
+		if (ret < 0)
 			__io_remove_buffers(ctx, head, p->bgid, -1U);
-			goto out;
-		}
 	}
-out:
 	if (ret < 0)
 		req_set_fail_links(req);
 
@@ -8333,19 +8326,13 @@ static int io_eventfd_unregister(struct io_ring_ctx *ctx)
 	return -ENXIO;
 }
 
-static int __io_destroy_buffers(int id, void *p, void *data)
-{
-	struct io_ring_ctx *ctx = data;
-	struct io_buffer *buf = p;
-
-	__io_remove_buffers(ctx, buf, id, -1U);
-	return 0;
-}
-
 static void io_destroy_buffers(struct io_ring_ctx *ctx)
 {
-	idr_for_each(&ctx->io_buffer_idr, __io_destroy_buffers, ctx);
-	idr_destroy(&ctx->io_buffer_idr);
+	struct io_buffer *buf;
+	unsigned long index;
+
+	xa_for_each(&ctx->io_buffers, index, buf)
+		__io_remove_buffers(ctx, buf, index, -1U);
 }
 
 static void io_req_cache_free(struct list_head *list, struct task_struct *tsk)

