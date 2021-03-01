Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F30327E02
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbhCAMOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:14:21 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:40443 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233691AbhCAMOR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 07:14:17 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 517BE1941656;
        Mon,  1 Mar 2021 07:13:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 07:13:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=SCuC0S
        Alo1m/29npS9DXmUfFQzvkwUW5Sjj0n0fkBtQ=; b=C7lcOLwwr6nYVa+xRkGOia
        iDOIBR36CCFf5Mr6LK1zvIaC8utFsAFQHpuW7vQyiGwFt9uXzXxWkfo5sDItf071
        zzFj65YHjIoLRLwTWNrCdrhGx4A2vigTIyn7L08LPAPndntLKdhWSPWBftAn3jw6
        XsaMqd5CIGeWtWM4rPEOZKYMl3Og0KFXLS6zvuPYwFi00n0UY1fkdCtJFrBfMGIx
        oiTl5lmsqqbgCHDGk6x/DOybr8mBKS0rmuJdcCgEnDh67pZZsEtibsY0nikP+WU1
        OP3gnqvk4Q8yw+n/9DJVNwldz4s51qMsLKxgTmfLAJdQ2J1J/t0v5dfQtf+fbr5w
        ==
X-ME-Sender: <xms:TNo8YHu7YR5Lyj9x35RjMBFICb6R8BXRsF4O5AOf7S15upZR9GE2jg>
    <xme:TNo8YIdxZ4U7_bNkokUHyL5PO6YlovEqchDsFGXJoH5ilOqSeX35lEZ3IBjaZr1VU
    XfrM-36MOVW_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:TNo8YKz43m5HDbgvK92Y1pxWPwqTY08uQhXXO6Z8-_h1Zqo8XbTZRw>
    <xmx:TNo8YGPVzTNYkZPZYCVOREGKl7sU2hPye4BMwzJMHa9qWDaU3b70DA>
    <xmx:TNo8YH-R4smtHtF9MO3CIaYyp-jAl_vv1x0MilwsKKDspIgNofFn9w>
    <xmx:TNo8YEH_WbQVi3WPQYb0HEpEe-UL3pb4vKqnGAlXLy6MxHB7BxYH3Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B76DF1080054;
        Mon,  1 Mar 2021 07:12:59 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: wait potential ->release() on resurrect" failed to apply to 5.11-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 13:12:50 +0100
Message-ID: <161460077010694@kroah.com>
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

From 88f171ab7798a1ed0b9e39867ee16f307466e870 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Sat, 20 Feb 2021 18:03:50 +0000
Subject: [PATCH] io_uring: wait potential ->release() on resurrect

There is a short window where percpu_refs are already turned zero, but
we try to do resurrect(). Play nicer and wait for ->release() to happen
in this case and proceed as everything is ok. One downside for ctx refs
is that we can ignore signal_pending() on a rare occasion, but someone
else should check for it later if needed.

Cc: <stable@vger.kernel.org> # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c98b673f0bb1..5cc02226bb38 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1104,6 +1104,21 @@ static inline void io_set_resource_node(struct io_kiocb *req)
 	}
 }
 
+static bool io_refs_resurrect(struct percpu_ref *ref, struct completion *compl)
+{
+	if (!percpu_ref_tryget(ref)) {
+		/* already at zero, wait for ->release() */
+		if (!try_wait_for_completion(compl))
+			synchronize_rcu();
+		return false;
+	}
+
+	percpu_ref_resurrect(ref);
+	reinit_completion(compl);
+	percpu_ref_put(ref);
+	return true;
+}
+
 static bool io_match_task(struct io_kiocb *head,
 			  struct task_struct *task,
 			  struct files_struct *files)
@@ -7329,13 +7344,11 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 		flush_delayed_work(&ctx->rsrc_put_work);
 
 		ret = wait_for_completion_interruptible(&data->done);
-		if (!ret)
+		if (!ret || !io_refs_resurrect(&data->refs, &data->done))
 			break;
 
-		percpu_ref_resurrect(&data->refs);
 		io_sqe_rsrc_set_node(ctx, data, backup_node);
 		backup_node = NULL;
-		reinit_completion(&data->done);
 		mutex_unlock(&ctx->uring_lock);
 		ret = io_run_task_work_sig();
 		mutex_lock(&ctx->uring_lock);
@@ -10070,10 +10083,8 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 
 		mutex_lock(&ctx->uring_lock);
 
-		if (ret) {
-			percpu_ref_resurrect(&ctx->refs);
-			goto out_quiesce;
-		}
+		if (ret && io_refs_resurrect(&ctx->refs, &ctx->ref_comp))
+			return ret;
 	}
 
 	if (ctx->restricted) {
@@ -10165,7 +10176,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	if (io_register_op_must_quiesce(opcode)) {
 		/* bring the ctx back to life */
 		percpu_ref_reinit(&ctx->refs);
-out_quiesce:
 		reinit_completion(&ctx->ref_comp);
 	}
 	return ret;

