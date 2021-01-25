Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9C63032D5
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbhAZEiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:38:54 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:55255 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729258AbhAYORd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 09:17:33 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 3A5EF533;
        Mon, 25 Jan 2021 09:15:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 25 Jan 2021 09:15:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ojXrkm
        ZlL3hzN8Brh52OahB9NkRoYmh9mpCxKQilaxI=; b=Xw6/65DjoIZ/kVugo9H42T
        IbaZyqx3MjmREJszxakasMshGRcHjvGm1/ku9QBOOpP+OvEnga40ql94G79dlqd0
        xUQxbprhXOTajLpFRKp1DCM92/8Sjdpl8JKWP4OaiHTO/XMG4Dk43ir03nTHZcVi
        YE9qdflNnBmTi04Eru8HTJpZDrgEWlLISJzDP86Rs68XyXgXpxhZlowXuxm46bKz
        4OrNUH9VjWWv1t0sVI3XMEeG1f1g79njD0O9D1H5xpECJa5Zm2Drxl3y5h3ZesT4
        kw81/tlqfj1OGp7BQyuR8lwkcBho3vsd1+0jqiS6EaayPBH0H9UL5R74A49b7a2g
        ==
X-ME-Sender: <xms:ntIOYBurPSkEcXFZTpYQvrj1DVTWdhpdMZljPxacjEff1UAm4eP3rg>
    <xme:ntIOYGwJi9_dPtfqetVq0GlcsCFysNdwOKZWZtYNhqtJ_IrOr611XDn-63zHcYYf_
    uITejBPV1UOvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:ntIOYHgUOX9VwCsUu1FSbnJehCGiCkmOjmHdYODXSPmvVlY8WeGSpg>
    <xmx:ntIOYKAm5Tq6gEfbHJFE1GmcpaZECrAn6YbSyj2_F1gjLkwxNlaZ9Q>
    <xmx:ntIOYEsoDoTeO8XQMZdAhF9oYXtnRGwsmF2NVpL9idak38_Zto3-rg>
    <xmx:ntIOYKd8CiR6k4RlN76r8nc6rvc-wQd8J_TyuE7a4siFVwZ2OTEbqqmpi3o>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1CEB5108005F;
        Mon, 25 Jan 2021 09:15:57 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: account io_uring internal files as REQ_F_INFLIGHT" failed to apply to 5.10-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 15:15:55 +0100
Message-ID: <161158415525311@kroah.com>
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

From 02a13674fa0e8dd326de8b9f4514b41b03d99003 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sat, 23 Jan 2021 15:49:31 -0700
Subject: [PATCH] io_uring: account io_uring internal files as REQ_F_INFLIGHT

We need to actively cancel anything that introduces a potential circular
loop, where io_uring holds a reference to itself. If the file in question
is an io_uring file, then add the request to the inflight list.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8a98afed50cd..c07913ec0cca 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1075,8 +1075,11 @@ static bool io_match_task(struct io_kiocb *head,
 		return true;
 
 	io_for_each_link(req, head) {
-		if ((req->flags & REQ_F_WORK_INITIALIZED) &&
-		    (req->work.flags & IO_WQ_WORK_FILES) &&
+		if (!(req->flags & REQ_F_WORK_INITIALIZED))
+			continue;
+		if (req->file && req->file->f_op == &io_uring_fops)
+			return true;
+		if ((req->work.flags & IO_WQ_WORK_FILES) &&
 		    req->work.identity->files == files)
 			return true;
 	}
@@ -1505,11 +1508,14 @@ static bool io_grab_identity(struct io_kiocb *req)
 			return false;
 		atomic_inc(&id->files->count);
 		get_nsproxy(id->nsproxy);
-		req->flags |= REQ_F_INFLIGHT;
 
-		spin_lock_irq(&ctx->inflight_lock);
-		list_add(&req->inflight_entry, &ctx->inflight_list);
-		spin_unlock_irq(&ctx->inflight_lock);
+		if (!(req->flags & REQ_F_INFLIGHT)) {
+			req->flags |= REQ_F_INFLIGHT;
+
+			spin_lock_irq(&ctx->inflight_lock);
+			list_add(&req->inflight_entry, &ctx->inflight_list);
+			spin_unlock_irq(&ctx->inflight_lock);
+		}
 		req->work.flags |= IO_WQ_WORK_FILES;
 	}
 	if (!(req->work.flags & IO_WQ_WORK_MM) &&
@@ -6164,8 +6170,10 @@ static void io_req_drop_files(struct io_kiocb *req)
 	struct io_uring_task *tctx = req->task->io_uring;
 	unsigned long flags;
 
-	put_files_struct(req->work.identity->files);
-	put_nsproxy(req->work.identity->nsproxy);
+	if (req->work.flags & IO_WQ_WORK_FILES) {
+		put_files_struct(req->work.identity->files);
+		put_nsproxy(req->work.identity->nsproxy);
+	}
 	spin_lock_irqsave(&ctx->inflight_lock, flags);
 	list_del(&req->inflight_entry);
 	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
@@ -6450,6 +6458,15 @@ static struct file *io_file_get(struct io_submit_state *state,
 		file = __io_file_get(state, fd);
 	}
 
+	if (file && file->f_op == &io_uring_fops) {
+		io_req_init_async(req);
+		req->flags |= REQ_F_INFLIGHT;
+
+		spin_lock_irq(&ctx->inflight_lock);
+		list_add(&req->inflight_entry, &ctx->inflight_list);
+		spin_unlock_irq(&ctx->inflight_lock);
+	}
+
 	return file;
 }
 
@@ -8860,8 +8877,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
-			if (req->task != task ||
-			    req->work.identity->files != files)
+			if (!io_match_task(req, task, files))
 				continue;
 			found = true;
 			break;

