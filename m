Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AAE30A81E
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 13:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhBAM4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 07:56:00 -0500
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:49741 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230016AbhBAMz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 07:55:59 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 0D5AD6B7;
        Mon,  1 Feb 2021 07:54:37 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Feb 2021 07:54:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=QmmwXd
        2FE8c7qOmjiAedMKJbPRkJP42o070t7nxBFBE=; b=hcc/gpuCXb/N2+Jws0ywwB
        5q9Dwv2Z9xDsLmF7U5p+6ShVw5XNqaur2Rj5Pa0AGbQxzKkFf1c/u5/ya9Ffnjtd
        PN2gzNB6cwLXfTGrSVztphOxoI3RYwx+G60lPGwXBMg6+d2OKYUHqbJK6m5xbbuz
        wAtuS3YwD6OisUBB5k/M+7gVZlvBn7h6L5118fv3k+KzHf3Cnz2j8Cw67SonP5Pr
        +nKanFdrLKT1lQzJfSLdfiMKpqlQos0C/moKAAV9to9viDkqjWg9VkQAZMQxIpBo
        TeWfGE3e6Fn0OPmpMUFnFSUk1DYDq8GLJWDT52VwfLilQzwmC13oJ3er8VLBTvcg
        ==
X-ME-Sender: <xms:DfoXYNIuWG5qOQEM1F0pjnET5-Hip5QbavJW9WOzLNSC0DwikomDqA>
    <xme:DfoXYJK3KsNH1YCZknwM1ideejAeyGB6S4mJ1GvOAIzTwnU13UJ7teJyzvhLG4Gz-
    vBl8xCT5zlXng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:DfoXYFutFUiQNmM44TElgif0lqPo30NUYQFrXM4DQTUttb_bmtvW-w>
    <xmx:DfoXYOb9wSkL-uthvLxbuThb35CzMfJHFMs9bLnq24Uf7VRaZbOKyQ>
    <xmx:DfoXYEaDAdIRDHo2Lb4Fsn3pmMMOog7qg3Tr2LWfm5UA8sK1KfNE3w>
    <xmx:DfoXYND66nzu5rPivGbXyVWANAeLw21JXSdgmOzR5-PLnhlHj7PE2OWrDdI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5DA591080057;
        Mon,  1 Feb 2021 07:54:37 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: reinforce cancel on flush during exit" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Feb 2021 13:54:36 +0100
Message-ID: <1612184076193225@kroah.com>
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

From 3a7efd1ad269ccaf9c1423364d97c9661ba6dafa Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Thu, 28 Jan 2021 23:23:42 +0000
Subject: [PATCH] io_uring: reinforce cancel on flush during exit

What 84965ff8a84f0 ("io_uring: if we see flush on exit, cancel related tasks")
really wants is to cancel all relevant REQ_F_INFLIGHT requests reliably.
That can be achieved by io_uring_cancel_files(), but we'll miss it
calling io_uring_cancel_task_requests(files=NULL) from io_uring_flush(),
because it will go through __io_uring_cancel_task_requests().

Just always call io_uring_cancel_files() during cancel, it's good enough
for now.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 12bf7180c0f1..38c6cbe1ab38 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8976,10 +8976,9 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	io_cancel_defer_files(ctx, task, files);
 	io_cqring_overflow_flush(ctx, true, task, files);
 
+	io_uring_cancel_files(ctx, task, files);
 	if (!files)
 		__io_uring_cancel_task_requests(ctx, task);
-	else
-		io_uring_cancel_files(ctx, task, files);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);

