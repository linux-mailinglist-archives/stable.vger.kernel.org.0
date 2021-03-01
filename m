Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0289327E06
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbhCAMO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:14:58 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:60033 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233437AbhCAMOw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 07:14:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2A050194162E;
        Mon,  1 Mar 2021 07:14:04 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 07:14:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=e8rcBS
        pz4uI5Z+88lusL8EF50JA3gDUg6g0Bbt6ibwI=; b=KbPjSvACH3k58q+mus1dQF
        ieaWfBKy7dk2CFQVIYgU1K7cw38XruCeyNGj2XFoMdRUjLJYkqJ9qDeeyoTqpeYh
        +7fnQ67dWGFMuH3oGVo6THssSY52eJ+WElDOXpAPwXbJnBCIt5W8Yxv365QB+ZN0
        qCwFmVbUZXFw5cJUHF298I5g/AeJtv9dTCvHzTP2C69Pt/+UFySunY7V9B5YcNB9
        U8SkwLmYEK1F1FdJHHQjmdo5GMiwyXKT2ojcjuNsH4jRNN77RbdHKbaRziAQ2YNo
        W5/X6EcpyImhlHQR29WbwxIHFkCy+4VcuO6BcPmgpO/FqVTNjnvjD8PXFFJkKJaQ
        ==
X-ME-Sender: <xms:i9o8YDo4GKBlERla_txBnnvMUdfyntP8-6_ytVT85KKo45lnZCQuUg>
    <xme:i9o8YNooQlYlXIEYXmXIOVx0Nd4z2ZOrDkZu_6aJcukgqf_w1GJJ8pG_KNadKMJOq
    ILMZjZ3Ae0EjQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:i9o8YAOZN9d6kPEySBFp7Gii5GQExti6PQPXxMGh6NKnPlf6KRKvnQ>
    <xmx:i9o8YG5EzIOi4OljQqKDkF9G0ovpeUQmKiWJRIZ6DouEHhVuW2Ooag>
    <xmx:i9o8YC67H1mcoHYfQNGYb3si-ONh-U6QwASItPHQ-AHCI02Z3ekrxg>
    <xmx:jNo8YPXcLPMf5-m-N81oQjsfVC1pNvHrMvcaEncntHMOMdqDGkK9hA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8FE5224005B;
        Mon,  1 Mar 2021 07:14:03 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: don't attempt IO reissue from the ring exit path" failed to apply to 5.11-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 13:14:01 +0100
Message-ID: <161460084192117@kroah.com>
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

From 7c977a58dc83366e488c217fd88b1469d242bee5 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 23 Feb 2021 19:17:35 -0700
Subject: [PATCH] io_uring: don't attempt IO reissue from the ring exit path

If we're exiting the ring, just let the IO fail with -EAGAIN as nobody
will care anyway. It's not the right context to reissue from.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf9ad810c621..275ad84e8227 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2839,6 +2839,13 @@ static bool io_rw_reissue(struct io_kiocb *req)
 		return false;
 	if ((req->flags & REQ_F_NOWAIT) || io_wq_current_is_worker())
 		return false;
+	/*
+	 * If ref is dying, we might be running poll reap from the exit work.
+	 * Don't attempt to reissue from that path, just let it fail with
+	 * -EAGAIN.
+	 */
+	if (percpu_ref_is_dying(&req->ctx->refs))
+		return false;
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 

