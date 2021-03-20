Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36030342BEB
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhCTLQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:16:15 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:57291 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229756AbhCTLQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 07:16:10 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7BBC21940738;
        Sat, 20 Mar 2021 06:44:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 20 Mar 2021 06:44:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=uaUlvs
        oIQwmEEbWgX0xKZ5BAa1r2470ag7ujqitYLcI=; b=IcR6wP9uc6RWyTP5dQ93yf
        PGXEehoLUg4ff3OgpYmF7fab2RFRrq4lsNdpdved0Nmou0XVxR8Kicyq2mcsv1B0
        yWRCuJw02uDAzXpg1zvM4FQ224soeF7M0ivUXYjwxoapMca4/5CTrMYK5Nd3h4JR
        0k2GdTSVezTNLB5HsZtLubakw6f0DjtobHWf780yEiIf2frPtPf6jSjuvY0PNCyd
        XV0DlZioZOXesRW9rwGFAaSVLSUk4c9BdPMwTNAmDGbrHAy4qoT58vGG4AmNGCaX
        AjT8f/dvNQqPYMmH1Df9GBS12/VmDOsVdW1flMhkn1tWXRguese4Dkvovq0CU2nw
        ==
X-ME-Sender: <xms:CNJVYLFoM5VLUIr0EbdapUamOtr_kNMi7nvGiWzt-T4RXZ9muEKB9g>
    <xme:CNJVYIW1FABnQ2i_dWa0y9xOQ4rJrY3sQPfBE61XRAN8xuR-rlahckjNpfIDVQ2qR
    5GLbjI9PtoCzw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegtddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:CNJVYNIf40drh7FC8YZOWrKIY5BD13z-HqaRRyUWo3jk8E1spWWNMw>
    <xmx:CNJVYJGkxmBGWbw-ayHmmxDfKUVIdwu9OyIg2h-v-9GFPrMcHAkOIA>
    <xmx:CNJVYBUcXlxKZ3a5UfeLwWJ4eSpflIelsbBzJPBuEIYtPxKBNWitnw>
    <xmx:CNJVYOi2ZjKkWVxD2abvdRYTBIDSx6G8mBDC1JEPedcyT5ir1ghQjA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 26852108005F;
        Sat, 20 Mar 2021 06:44:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: convert io_buffer_idr to XArray" failed to apply to 5.10-stable tree
To:     axboe@kernel.dk, hulkci@huawei.com, willy@infradead.org,
        yangerkun@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 20 Mar 2021 11:44:14 +0100
Message-ID: <1616237054143227@kroah.com>
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

