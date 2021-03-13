Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3917B339E2C
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 14:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhCMNXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 08:23:41 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:41453 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233633AbhCMNXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 08:23:24 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id B14201941D13;
        Sat, 13 Mar 2021 08:23:23 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 13 Mar 2021 08:23:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=QmAudr
        8HSuaXBCTVwRDMwK1GUoCbN2d1gOsvsm2lcSw=; b=v5p8BPufIIwXZ9yDxSJ62S
        gCqlqBZ2fTJg0gWxB0xF9Z9WdUmwR2q56Qod2we8iPDCweZIZC0TZTIgvBLr7j87
        MtVrscJ2hSmaw7v+jfBSFNGpB6KmLjikydeknux0y+5KwaiLLah6QV5q4o9U+s7R
        MHu9OIKqGJyfb+HNpyGyoWpOia8l6H6uUJgeKXlofBRb0FUth62WkS22RDkCUh37
        gFpIMHr/OHkgbTPbSWPyteDYkHiwjGeeH3drw6GkAdQtwk8hMiYD18ruovHVEQkX
        KbwoFYjUHjVxlqLiUrou3rsawjKtoSYsyaBOAe8sEuEuYfDzV2iIATFE4gFsjSkQ
        ==
X-ME-Sender: <xms:y7xMYHluADQiwRVvlY1x22hgi-MqTNmNMkcHLhuJuRPXQVLP6KQM2A>
    <xme:y7xMYK3b8ZT_Qzs_kI7ZWREccDpgb2v_kRnYi9EDLRJ-QscE5Hn4QdFLKaesAOdd9
    zXqAKjvkSheUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvgedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeekuddtveevheejgefghfdvgfekgfegfeduudevtd
    fggfdvvdethfekffdvveevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdplhhishht
    rdhnvgigthenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:y7xMYNpONDewlHewcyAjchvTctvg-ZD2y3B5Ju45rMzif2OLfbt5mA>
    <xmx:y7xMYPna-IHLAcDPqSlbskIRclCD90uZao3ctroVmu7a7J_Us9PrdQ>
    <xmx:y7xMYF22gPO6pDQSU0RuRwFWHFKHCuLThyjyeHYVh-aQFQl6Fwfmdw>
    <xmx:y7xMYDBSFzCJTTvEzt_Ipu564s70u76U7krhkRV5_4Q_6tRuZ4D_MQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C738024005A;
        Sat, 13 Mar 2021 08:23:22 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: Convert personality_idr to XArray" failed to apply to 5.11-stable tree
To:     willy@infradead.org, asml.silence@gmail.com, axboe@kernel.dk,
        yangerkun@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Mar 2021 14:23:20 +0100
Message-ID: <161564180024072@kroah.com>
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

From 61cf93700fe6359552848ed5e3becba6cd760efa Mon Sep 17 00:00:00 2001
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Mon, 8 Mar 2021 14:16:16 +0000
Subject: [PATCH] io_uring: Convert personality_idr to XArray

You can't call idr_remove() from within a idr_for_each() callback,
but you can call xa_erase() from an xa_for_each() loop, so switch the
entire personality_idr from the IDR to the XArray.  This manifests as a
use-after-free as idr_for_each() attempts to walk the rest of the node
after removing the last entry from it.

Fixes: 071698e13ac6 ("io_uring: allow registering credentials")
Cc: stable@vger.kernel.org # 5.6+
Reported-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
[Pavel: rebased (creds load was moved into io_init_req())]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/7ccff36e1375f2b0ebf73d957f037b43becc0dde.1615212806.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3f6db813d670..84eb499368a4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -406,7 +406,8 @@ struct io_ring_ctx {
 
 	struct idr		io_buffer_idr;
 
-	struct idr		personality_idr;
+	struct xarray		personalities;
+	u32			pers_next;
 
 	struct {
 		unsigned		cached_cq_tail;
@@ -1137,7 +1138,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_completion(&ctx->ref_comp);
 	init_completion(&ctx->sq_thread_comp);
 	idr_init(&ctx->io_buffer_idr);
-	idr_init(&ctx->personality_idr);
+	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
 	spin_lock_init(&ctx->completion_lock);
@@ -6337,7 +6338,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->work.list.next = NULL;
 	personality = READ_ONCE(sqe->personality);
 	if (personality) {
-		req->work.creds = idr_find(&ctx->personality_idr, personality);
+		req->work.creds = xa_load(&ctx->personalities, personality);
 		if (!req->work.creds)
 			return -EINVAL;
 		get_cred(req->work.creds);
@@ -8355,7 +8356,6 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
-	idr_destroy(&ctx->personality_idr);
 
 #if defined(CONFIG_UNIX)
 	if (ctx->ring_sock) {
@@ -8420,7 +8420,7 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 {
 	const struct cred *creds;
 
-	creds = idr_remove(&ctx->personality_idr, id);
+	creds = xa_erase(&ctx->personalities, id);
 	if (creds) {
 		put_cred(creds);
 		return 0;
@@ -8429,14 +8429,6 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 	return -EINVAL;
 }
 
-static int io_remove_personalities(int id, void *p, void *data)
-{
-	struct io_ring_ctx *ctx = data;
-
-	io_unregister_personality(ctx, id);
-	return 0;
-}
-
 static bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
 {
 	struct callback_head *work, *next;
@@ -8526,13 +8518,17 @@ static void io_ring_exit_work(struct work_struct *work)
 
 static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
+	unsigned long index;
+	struct creds *creds;
+
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);
 	/* if force is set, the ring is going away. always drop after that */
 	ctx->cq_overflow_flushed = 1;
 	if (ctx->rings)
 		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
-	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
+	xa_for_each(&ctx->personalities, index, creds)
+		io_unregister_personality(ctx, index);
 	mutex_unlock(&ctx->uring_lock);
 
 	io_kill_timeouts(ctx, NULL, NULL);
@@ -9162,10 +9158,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 }
 
 #ifdef CONFIG_PROC_FS
-static int io_uring_show_cred(int id, void *p, void *data)
+static int io_uring_show_cred(struct seq_file *m, unsigned int id,
+		const struct cred *cred)
 {
-	const struct cred *cred = p;
-	struct seq_file *m = data;
 	struct user_namespace *uns = seq_user_ns(m);
 	struct group_info *gi;
 	kernel_cap_t cap;
@@ -9233,9 +9228,13 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf,
 						(unsigned int) buf->len);
 	}
-	if (has_lock && !idr_is_empty(&ctx->personality_idr)) {
+	if (has_lock && !xa_empty(&ctx->personalities)) {
+		unsigned long index;
+		const struct cred *cred;
+
 		seq_printf(m, "Personalities:\n");
-		idr_for_each(&ctx->personality_idr, io_uring_show_cred, m);
+		xa_for_each(&ctx->personalities, index, cred)
+			io_uring_show_cred(m, index, cred);
 	}
 	seq_printf(m, "PollList:\n");
 	spin_lock_irq(&ctx->completion_lock);
@@ -9564,14 +9563,16 @@ static int io_probe(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 static int io_register_personality(struct io_ring_ctx *ctx)
 {
 	const struct cred *creds;
+	u32 id;
 	int ret;
 
 	creds = get_current_cred();
 
-	ret = idr_alloc_cyclic(&ctx->personality_idr, (void *) creds, 1,
-				USHRT_MAX, GFP_KERNEL);
-	if (ret < 0)
-		put_cred(creds);
+	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
+			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
+	if (!ret)
+		return id;
+	put_cred(creds);
 	return ret;
 }
 

