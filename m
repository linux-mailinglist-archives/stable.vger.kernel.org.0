Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A297377DED
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhEJITQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:19:16 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:42521 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230163AbhEJITQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:19:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7189C1940BCB;
        Mon, 10 May 2021 04:18:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 10 May 2021 04:18:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=guyPtc
        QQ8AfyjjsbM2hwIVyIEVXgJUDE/zcMJQgdf+M=; b=s8UN/YklvSH6LJmdLVkBnr
        dqHL+8NmgAQLYAi0/gTpPFI0nhSULtPxxgjl5WufeDUR1N5bYQznR+uCRHj91ECW
        oISXJVObdIlMbiCiA6IxmTmIiazgNPsJcgnNzR8UahrA/BBNt9QrPyO4HpB3/a2N
        uluIn2rvurBMczE/eTXgFKPqjg7XjdqMmQskhHPAYfOsy1LGK1QjwYsFX4j649+S
        T0FmIc7qjSwXeva3ubgveDtY5wDz4O7tBn7DxOFEqg3F623b5lcOlF0CW2bD/3KB
        WLqdiCmy1PhoD7dikPtYx2oPXFBhAs16K24O4Ipp6agnBNuXqWbsh/bvG7aOpCnA
        ==
X-ME-Sender: <xms:Q-yYYC1MGx1nTlCAJLycW2q29PiuzBOOULs2YzO1K6gEClNCqIYh0Q>
    <xme:Q-yYYFH5gXJV48hSare5AFNMOBvOipi0EPQGP5S7ffBFaapbRGOMscDXMNHn4T7RW
    1XwgH0KUhX9_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Q-yYYK5FYpM6pE2xHDCh-RZQFVpdE7HDWVsjtiOO8v1wwp6Lc0HSng>
    <xmx:Q-yYYD1rvXDqc2AMTYOILUN4dJCvFG_kzB4FA4yHmuM0XGX-SG_W9g>
    <xmx:Q-yYYFE7fy0y9TK1oDvIpTlEu6Sj-jw8Npmxq_iZF5byFtrsrMm3DA>
    <xmx:Q-yYYIMqZVWPIhyP_uf75txg6m9G__Z06dHWc62Mg1oVT-vHWMfa7A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:18:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: fix leaking reg files on exit" failed to apply to 5.12-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:17:59 +0200
Message-ID: <1620634679220152@kroah.com>
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

From 084804002e512427bfe52b448cb7cac0d4209b64 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Tue, 13 Apr 2021 02:58:38 +0100
Subject: [PATCH] io_uring: fix leaking reg files on exit

If io_sqe_files_unregister() faults on io_rsrc_ref_quiesce(), it will
fail to do unregister leaving files referenced. And that may well happen
because of a strayed signal or just because it does allocations inside.

In io_ring_ctx_free() do an unsafe version of unregister, as it's
guaranteed to not have requests by that point and so quiesce is useless.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/e696e9eade571b51997d0dc1d01f144c6d685c05.1618278933.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8564c7908126..1af8bb5f7d56 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7089,6 +7089,10 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 			fput(file);
 	}
 #endif
+	io_free_file_tables(&ctx->file_table, ctx->nr_user_files);
+	kfree(ctx->file_data);
+	ctx->file_data = NULL;
+	ctx->nr_user_files = 0;
 }
 
 static inline void io_rsrc_ref_lock(struct io_ring_ctx *ctx)
@@ -7195,21 +7199,14 @@ static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx,
 
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
-	struct io_rsrc_data *data = ctx->file_data;
 	int ret;
 
-	if (!data)
+	if (!ctx->file_data)
 		return -ENXIO;
-	ret = io_rsrc_ref_quiesce(data, ctx);
-	if (ret)
-		return ret;
-
-	__io_sqe_files_unregister(ctx);
-	io_free_file_tables(&ctx->file_table, ctx->nr_user_files);
-	kfree(data);
-	ctx->file_data = NULL;
-	ctx->nr_user_files = 0;
-	return 0;
+	ret = io_rsrc_ref_quiesce(ctx->file_data, ctx);
+	if (!ret)
+		__io_sqe_files_unregister(ctx);
+	return ret;
 }
 
 static void io_sq_thread_unpark(struct io_sq_data *sqd)
@@ -7659,7 +7656,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 
 	ret = io_sqe_files_scm(ctx);
 	if (ret) {
-		io_sqe_files_unregister(ctx);
+		__io_sqe_files_unregister(ctx);
 		return ret;
 	}
 
@@ -8460,7 +8457,11 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	}
 
 	mutex_lock(&ctx->uring_lock);
-	io_sqe_files_unregister(ctx);
+	if (ctx->file_data) {
+		if (!atomic_dec_and_test(&ctx->file_data->refs))
+			wait_for_completion(&ctx->file_data->done);
+		__io_sqe_files_unregister(ctx);
+	}
 	if (ctx->rings)
 		__io_cqring_overflow_flush(ctx, true);
 	mutex_unlock(&ctx->uring_lock);

