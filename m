Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBE02F0EB4
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 10:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbhAKJCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 04:02:07 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:41741 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728011AbhAKJCG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 04:02:06 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7B42D21D1;
        Mon, 11 Jan 2021 04:01:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 04:01:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Ex8i8Y
        i9nTZaOTUv0TKUh5AsT7HxsUSiQJPFawwXJRc=; b=I2yjFfdnGbWpIncNgK7c9J
        n3ylsfZPK0+ySpf1F9kKgyHHC9xpQw97AdN7oP786d4RDElQ1xIa4v4H03zfUFBG
        RVCYMzDCbF20SU/6blXiEq3ihnDDmL8654EbOYjZD9CBvglPhYsvm59EApNZHqm8
        aNZvhsOuz/KXNO6OpC1RGgfe02JeasPEUrGC2dJj+q/3FWNYfLPQaJi1FWTBPDog
        hWvMt7VpvGoLsq+wVg4C99P9kN7z1LP1WGBGJg6xNO2QHPtm4ugFZresVnNrWpWQ
        zR/s0brZzDPTZZ65gv+aNfADTPuidGQTIRoVVKjCb4J2c9e6yq5IEXhhCnacQi5w
        ==
X-ME-Sender: <xms:zBP8X1HzkkJuN0wq_zHj1j7JEW5tIyUD_VmfuAvrFsBuSKRuKjgulQ>
    <xme:zBP8X6V7zjMySlwUy98001QlS-vM3Po6S-544xTrDgXg2GQccvpLWaS3vsLBTB9XF
    PPiJg656bnFyw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:zBP8X3I7fZuj5lu4KgjPZZz6yvMDop4Y5WmZOrNhP81Aosi2ovWloQ>
    <xmx:zBP8X7EntqWrZV15w66m1712-vttS5FuvusZYMv-dLSGqsfwiaHxrQ>
    <xmx:zBP8X7Wwp4dCqQkzkeePjPGe-wG-2e4_6J_F3RT9raRCYP-gEqsPYw>
    <xmx:zBP8X8eU12Bbhh0dAf8ZfUGIFfqP85AXtsF11B1jmUT-AhsylJmsf1OpWUQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AA9D71080059;
        Mon, 11 Jan 2021 04:00:59 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: synchronise IOPOLL on task_submit fail" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 10:02:12 +0100
Message-ID: <1610355732133171@kroah.com>
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

From 81b6d05ccad4f3d8a9dfb091fb46ad6978ee40e4 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 4 Jan 2021 20:36:35 +0000
Subject: [PATCH] io_uring: synchronise IOPOLL on task_submit fail

io_req_task_submit() might be called for IOPOLL, do the fail path under
uring_lock to comply with IOPOLL synchronisation based solely on it.

Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca46f314640b..5be33fd8b6bc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2126,15 +2126,16 @@ static void io_req_task_cancel(struct callback_head *cb)
 static void __io_req_task_submit(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	bool fail;
 
-	if (!__io_sq_thread_acquire_mm(ctx) &&
-	    !__io_sq_thread_acquire_files(ctx)) {
-		mutex_lock(&ctx->uring_lock);
+	fail = __io_sq_thread_acquire_mm(ctx) ||
+		__io_sq_thread_acquire_files(ctx);
+	mutex_lock(&ctx->uring_lock);
+	if (!fail)
 		__io_queue_sqe(req, NULL);
-		mutex_unlock(&ctx->uring_lock);
-	} else {
+	else
 		__io_req_task_cancel(req, -EFAULT);
-	}
+	mutex_unlock(&ctx->uring_lock);
 }
 
 static void io_req_task_submit(struct callback_head *cb)

