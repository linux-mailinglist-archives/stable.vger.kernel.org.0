Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517CC2E34E4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 09:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgL1ICL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 03:02:11 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:47823 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbgL1ICH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 03:02:07 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 75F5E2FF;
        Mon, 28 Dec 2020 03:01:00 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 03:01:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=BO+LZY
        6YvVXdWrXqgVvmF3MlwJ4bdN84FScrCVCNQwE=; b=iLBueVrfwdkb67AZYtkIM+
        /jnEtQGUfsb7LihDeDyEzvTIHqlmwphIqWHDYKSlS++ucfiJOC4/q/YKG5p0JlfH
        DHsRbLfATAGVhBXJiMbdylz36c8da1zct7p3t/ZPL9CtyKHGmC6txHj5hKWdk7jq
        vvb3jV0OnARYj3CTOV865AVyQcjSso44ypvm+LuaHzRmQOidaRkTLumGCSElihTG
        lOjBKRCRfgn17NwVDeBkF/xT+EAN+5ZnzJlHlXCCMPCtSDHweGkBm7gyroL0g8IY
        AqE3TlHJAk8GkUJsKan0N/aG7VNAFchqa8YIagORsAhCC3H5HmDus1SVaG2bkxRA
        ==
X-ME-Sender: <xms:u5DpX5Ner2DSi3SfebxB4srjJci5qG6ID6jRuI1KpjpywvXVpI1EXQ>
    <xme:u5DpX79yHasqAJJ57DjBXi6k2WMGtVNIm4DJm0ZcnxrXoWPpH5wleeRNUnqPZ6sJJ
    etVacg2aOOuaQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddukedguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:u5DpX4TNFbK87wLbBrb0Lb9nDzubm0CQB4FG8LfMQP1KN_Na6VrpBg>
    <xmx:u5DpX1uFgJw2bYk-96huqfoAqWMCAWh7L75lHGeA_5NjoexgbFQHwQ>
    <xmx:u5DpXxdOsDDuzGCz3-nb87LOrw5K1ljzPrMAat5RdLvssWQd3SKKQQ>
    <xmx:vJDpXxmX1Vd6Gunt6TH3Bfp1xhuL4fNyjLG6Tb4UTDsUDa-f59qgR4eON-A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 578C224005A;
        Mon, 28 Dec 2020 03:00:59 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: close a small race gap for files cancel" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 09:02:23 +0100
Message-ID: <160914254340200@kroah.com>
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

From dfea9fce29fda6f2f91161677e0e0d9b671bc099 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Fri, 18 Dec 2020 13:12:21 +0000
Subject: [PATCH] io_uring: close a small race gap for files cancel

The purpose of io_uring_cancel_files() is to wait for all requests
matching ->files to go/be cancelled. We should first drop files of a
request in io_req_drop_files() and only then make it undiscoverable for
io_uring_cancel_files.

First drop, then delete from list. It's ok to leave req->id->files
dangling, because it's not dereferenced by cancellation code, only
compared against. It would potentially go to sleep and be awaken by
following in io_req_drop_files() wake_up().

Fixes: 0f2122045b946 ("io_uring: don't rely on weak ->files references")
Cc: <stable@vger.kernel.org> # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8cf6f22afc5e..b74957856e68 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6098,15 +6098,15 @@ static void io_req_drop_files(struct io_kiocb *req)
 	struct io_uring_task *tctx = req->task->io_uring;
 	unsigned long flags;
 
+	put_files_struct(req->work.identity->files);
+	put_nsproxy(req->work.identity->nsproxy);
 	spin_lock_irqsave(&ctx->inflight_lock, flags);
 	list_del(&req->inflight_entry);
-	if (atomic_read(&tctx->in_idle))
-		wake_up(&tctx->wait);
 	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	req->flags &= ~REQ_F_INFLIGHT;
-	put_files_struct(req->work.identity->files);
-	put_nsproxy(req->work.identity->nsproxy);
 	req->work.flags &= ~IO_WQ_WORK_FILES;
+	if (atomic_read(&tctx->in_idle))
+		wake_up(&tctx->wait);
 }
 
 static void __io_clean_op(struct io_kiocb *req)

