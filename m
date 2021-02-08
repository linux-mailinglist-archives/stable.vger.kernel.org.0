Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA3F312F72
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhBHKt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:49:26 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:43805 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232608AbhBHKqe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:46:34 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 72CB9A03;
        Mon,  8 Feb 2021 05:45:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 05:45:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=d6dHpF
        ez3ZUFLFQiUGxQ1fyxBRbcqgA6YQ6GD1BQW6Y=; b=Untm4uTVhBgFr/7nIaAQ3N
        hyn2UOiS06O8qzZDzrWyR1wwJYPCL2AEJkjKomemfneBS8Qxh2S6TAEQU8UfqZPy
        VymgB9u3ZAZ1CCBqzfGg/JQKUnRe+VEhQqD2ItsU4W2fUUfXZmHTQ9rE4m4srSel
        EJ12TNrQR1I/mJDrECx3L+ctj/3nznk9uoUPl0AC1Q5A9SpcWysRsZgG4/Z7jM9z
        WULWoFJ3elW66Jiyy05Ca/a9TB/sjNrXJF1vX3aken5MpE8TEWStyO4iaQhZ/BLJ
        xYe1tl6ZlxtzvTcH4TtOyoOWqZ/2E3JKYPHBQx+sEp9f6Nmb9Z4+aeLeTdFV4k8Q
        ==
X-ME-Sender: <xms:RhYhYHSZt6oxeHFjEJRJCxRez15s_5MSj_osQTIZvVOhadhi5Qo9UQ>
    <xme:RhYhYIyq8PpzK4TEjYTfL6q6mbmh9V0C_K1Z3Vj1pOIWEN1B791JctBPemZcGd-Yp
    Mqk84MEdako_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:RhYhYM29IqqTWrHxL_mMn5_TOm1VcyQeoEz1A2P5nrmqBgCuNO2jyg>
    <xmx:RhYhYHBqMKvBpvKj0fBtX0EXlmF6AiGjZzLUvUR-R0xyCJaVEZVu1w>
    <xmx:RhYhYAi2wd6E5pzMMmNl1lBw9uw401QOWqUeHwU7MHBBKn7_dchBNw>
    <xmx:RxYhYILnSmwm7_WTz2n9VRnftLA5ffa_mXMJhGYWslRDuIT8WXtdcch3PDk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8F1BD24005D;
        Mon,  8 Feb 2021 05:45:26 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: drop mm/files between task_work_submit" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:45:24 +0100
Message-ID: <16127811248476@kroah.com>
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

From aec18a57edad562d620f7d19016de1fc0cc2208c Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Thu, 4 Feb 2021 19:22:46 +0000
Subject: [PATCH] io_uring: drop mm/files between task_work_submit

Since SQPOLL task can be shared and so task_work entries can be a mix of
them, we need to drop mm and files before trying to issue next request.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5d3348d66f06..1f68105a41ed 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2205,6 +2205,9 @@ static void __io_req_task_submit(struct io_kiocb *req)
 	else
 		__io_req_task_cancel(req, -EFAULT);
 	mutex_unlock(&ctx->uring_lock);
+
+	if (ctx->flags & IORING_SETUP_SQPOLL)
+		io_sq_thread_drop_mm_files();
 }
 
 static void io_req_task_submit(struct callback_head *cb)

