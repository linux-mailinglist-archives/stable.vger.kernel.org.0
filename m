Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255682C0268
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 10:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgKWJlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 04:41:39 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:60509 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725275AbgKWJlj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 04:41:39 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 00B875EB;
        Mon, 23 Nov 2020 04:41:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 04:41:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=rgAsO/
        gorxicbifR/wo7Rg93VYD9ciFzV3ekwYSNyBE=; b=fjDWhnukpSNnvwpOFox+yW
        JZKkspXB6nLnCkDfL8YMH8jfbERCa1K+RawafE9/K2gQJvy8yUFacigvEnxoWESd
        n5H1epzRIut+TG9yBS3NbiSlNANiY4/Sj1rx+VP8Y8+q2RD/HLbA6PrzTaGhVfjy
        ogNREIS5HbBV6JwByziYsCkEwSE9sdyYDJ0U/80YmHnigBGzSDRgPKmRRQtt4GUG
        N7p0zFf3DSSVmHhVFJ7Bt6iUfnXMWpq9d15zrYFckl6Cj6wkNB2ZjCQlKtXqF2cr
        GV1JJFWnajBIU8JQF/jSOqd4M+CntXUxuhm7ncO+Waxq6m+SLPPKFEJUuFUQQ2lg
        ==
X-ME-Sender: <xms:0YO7X4HOlfJyVCMXrZqk-BdhL_grLwCKLwTrgUYxA8R9uOo9Jn2WGQ>
    <xme:0YO7XxXvMmZhCg9hu6KE96Dx-Lzl0jWuPANV_zhjXNPB95QBEBlwu596vPPUMfZHX
    s4bSaAW0bY6VA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudegiedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:0YO7XyICOdteBv0eKkR1X0ufxzhp1S6CfjPmlgDJckIHyLUliXJ2Bw>
    <xmx:0YO7X6Hga0fyQg2ua91T7sva4kIGgcuR4WEddDbt5qQ9CdfiBaUpxQ>
    <xmx:0YO7X-UOb0NyB7mq2xOcqkJmg0JR4DAfc0dqgpSjyb4Pu9ymnQ84gg>
    <xmx:0YO7X3eB4z8_mi42161Rt1-hUCiN2yql0_PCsaPrlt_Ae017PkwvcrCUS20>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E00B23280066;
        Mon, 23 Nov 2020 04:41:36 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: order refnode recycling" failed to apply to 5.9-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 10:42:48 +0100
Message-ID: <16061245683720@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e297822b20e7fe683e107aea46e6402adcf99c70 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Wed, 18 Nov 2020 14:56:26 +0000
Subject: [PATCH] io_uring: order refnode recycling

Don't recycle a refnode until we're done with all requests of nodes
ejected before.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5cb194ca4fce..7d4b755ab451 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -205,6 +205,7 @@ struct fixed_file_ref_node {
 	struct list_head		file_list;
 	struct fixed_file_data		*file_data;
 	struct llist_node		llist;
+	bool				done;
 };
 
 struct fixed_file_data {
@@ -7323,10 +7324,6 @@ static void __io_file_put_work(struct fixed_file_ref_node *ref_node)
 		kfree(pfile);
 	}
 
-	spin_lock(&file_data->lock);
-	list_del(&ref_node->node);
-	spin_unlock(&file_data->lock);
-
 	percpu_ref_exit(&ref_node->refs);
 	kfree(ref_node);
 	percpu_ref_put(&file_data->refs);
@@ -7353,17 +7350,32 @@ static void io_file_put_work(struct work_struct *work)
 static void io_file_data_ref_zero(struct percpu_ref *ref)
 {
 	struct fixed_file_ref_node *ref_node;
+	struct fixed_file_data *data;
 	struct io_ring_ctx *ctx;
-	bool first_add;
+	bool first_add = false;
 	int delay = HZ;
 
 	ref_node = container_of(ref, struct fixed_file_ref_node, refs);
-	ctx = ref_node->file_data->ctx;
+	data = ref_node->file_data;
+	ctx = data->ctx;
+
+	spin_lock(&data->lock);
+	ref_node->done = true;
+
+	while (!list_empty(&data->ref_list)) {
+		ref_node = list_first_entry(&data->ref_list,
+					struct fixed_file_ref_node, node);
+		/* recycle ref nodes in order */
+		if (!ref_node->done)
+			break;
+		list_del(&ref_node->node);
+		first_add |= llist_add(&ref_node->llist, &ctx->file_put_llist);
+	}
+	spin_unlock(&data->lock);
 
-	if (percpu_ref_is_dying(&ctx->file_data->refs))
+	if (percpu_ref_is_dying(&data->refs))
 		delay = 0;
 
-	first_add = llist_add(&ref_node->llist, &ctx->file_put_llist);
 	if (!delay)
 		mod_delayed_work(system_wq, &ctx->file_put_work, 0);
 	else if (first_add)
@@ -7387,6 +7399,7 @@ static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->file_list);
 	ref_node->file_data = ctx->file_data;
+	ref_node->done = false;
 	return ref_node;
 }
 
@@ -7482,7 +7495,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 
 	file_data->node = ref_node;
 	spin_lock(&file_data->lock);
-	list_add(&ref_node->node, &file_data->ref_list);
+	list_add_tail(&ref_node->node, &file_data->ref_list);
 	spin_unlock(&file_data->lock);
 	percpu_ref_get(&file_data->refs);
 	return ret;
@@ -7641,7 +7654,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	if (needs_switch) {
 		percpu_ref_kill(&data->node->refs);
 		spin_lock(&data->lock);
-		list_add(&ref_node->node, &data->ref_list);
+		list_add_tail(&ref_node->node, &data->ref_list);
 		data->node = ref_node;
 		spin_unlock(&data->lock);
 		percpu_ref_get(&ctx->file_data->refs);

