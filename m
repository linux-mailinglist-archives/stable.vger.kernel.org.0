Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F400D30A819
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 13:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhBAMzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 07:55:12 -0500
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:32829 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231822AbhBAMzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 07:55:01 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7F9B35EE;
        Mon,  1 Feb 2021 07:54:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Feb 2021 07:54:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=x9LrBF
        40YbwjMH/dRhEhhJyQANcGaDmUV2S3V9TG3iw=; b=IYkNkXhAeaQUzhmKZA5BXs
        5aezBQ7Fl9STqAqNtLIK3DMxISr+h4ad7+YHBVhhmbvuD2+LYo3qAcYHAAORjrmG
        3T0zN6DOZz2/Akpg+gtelnBYry9vi86w+/vqyCuiVXMl7LuxBgeZyH0bYAhxdh4u
        zCi2Klth9vGCC2VDUKZ/4x1GF/yhHP+XbqMd9rH6PrnQuWjmOnD1X1ECIaoSrQDf
        3oKx6bDSz6e204PclDwMw/+2tFRpqAF+mpk7phS7r77DspysEU68YxJZNqdyD7OS
        tavmbHGnAO9YBPfb1ARY3Cs0LzOLLkjkiVaqvT34oMeCUY8/Gjs97EA2MjYhetJA
        ==
X-ME-Sender: <xms:9PkXYGz-JP2erqt-_HtWnSaRNQJe-EsAKGY-K6xqGCb2k_vOSSt6lg>
    <xme:9PkXYCR424AJXx4wRhyzW0c0ZvTVSbETqMqzbycMy9ZqxuyNUWIJ1cPnT2agc_Wph
    Cw1f47BsitDYg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:9PkXYIXX8vtLu-uQJ1qVF3K0on42yg86d6a2IqmwCsLQuj67JQ-r1g>
    <xmx:9PkXYMithr2hCWr1Dal3bNsGd0UjmtPE_hM8EloHjBiCdg4SyFQJsw>
    <xmx:9PkXYIByHZOUUhAc_XabCveCQP9TDIIbg1YQgFSfkmbKLuxy9dh6mQ>
    <xmx:9PkXYDqArzenPW-0oKg3uDT9lajOnIHBim1cAep7DthGs0ujOEQsOh4Oh30>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BF96F1080063;
        Mon,  1 Feb 2021 07:54:11 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: fix __io_uring_files_cancel() with" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Feb 2021 13:54:10 +0100
Message-ID: <1612184050241108@kroah.com>
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

From a1bb3cd58913338e1b627ea6b8c03c2ae82d293f Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Tue, 26 Jan 2021 15:28:26 +0000
Subject: [PATCH] io_uring: fix __io_uring_files_cancel() with
 TASK_UNINTERRUPTIBLE

If the tctx inflight number haven't changed because of cancellation,
__io_uring_task_cancel() will continue leaving the task in
TASK_UNINTERRUPTIBLE state, that's not expected by
__io_uring_files_cancel(). Ensure we always call finish_wait() before
retrying.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2166c469789d..09aada153a71 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9124,16 +9124,15 @@ void __io_uring_task_cancel(void)
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
 
 		/*
-		 * If we've seen completions, retry. This avoids a race where
-		 * a completion comes in before we did prepare_to_wait().
+		 * If we've seen completions, retry without waiting. This
+		 * avoids a race where a completion comes in before we did
+		 * prepare_to_wait().
 		 */
-		if (inflight != tctx_inflight(tctx))
-			continue;
-		schedule();
+		if (inflight == tctx_inflight(tctx))
+			schedule();
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
 
-	finish_wait(&tctx->wait, &wait);
 	atomic_dec(&tctx->in_idle);
 
 	io_uring_remove_task_files(tctx);

