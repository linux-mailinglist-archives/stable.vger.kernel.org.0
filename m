Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD4F2A5018
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 20:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgKCT1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 14:27:20 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:38629 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725957AbgKCT1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 14:27:20 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 40FB41942783;
        Tue,  3 Nov 2020 14:27:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 14:27:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Lr/GAU
        zjfAYs0mOJDizhxXB2uWZHBtQLtUETd9CFJmU=; b=IbFrLkDE8yhhMG5XoVNXCp
        Bni1pnHBDJiIKw/hsR9+wjx7eHLTq5aLlslDBz4gOwQy99gYAaimFSzFKClEMQnh
        L0wFJCeOL/TMQltgfPuNgU3hwlJ2mYb97LlnQshM1W/SNGHyPMjl7HuRu82tm0Ix
        1Neecatbh+SI1LcSzpWGpW2B7Tl3XX4Cs05gdkdBRNYSDiGkEtm3OdV1+St6gfw7
        5erOwkhcikw84/IT7pxRGxpB4DiuCroochUn21KuYhXy+zHo/vO8wM5Q55Yz3CxZ
        XxfV/vfYr5CDSCXpcj1K6R1CkzDKO7xldIcUxfIBAmaPjjlc4frEEjqZMeicloyQ
        ==
X-ME-Sender: <xms:F6-hX8Zs693eKqZouBDuK9v3suDQgq_EDUthKF9zS58EK9-BXe_MEw>
    <xme:F6-hX3ZQdUO_ybIHmtKcuxKwKIInh7gZjIT89EkndAqERC53zDyctQDm0qvms3lZs
    iSlKdRuUgGdfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:F6-hX2-eZZed1Wx18ArucV4ehoFKv138dNlWUqC2rfbQ5P7eom0Ciw>
    <xmx:F6-hX2qb01f-tYkRrNcpip3cl-EanPRYKKKeDBcfYPD7BeZK1pCFEw>
    <xmx:F6-hX3ostvC7udtTbHVT9YXnRnWLZaa0P259p_Ps6TjayAutvhlKbQ>
    <xmx:F6-hX2XSCJurMnBIJIoKO-U9Hw8881yEp4eTg9LE4cQRKprBwar3_A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D115E32800FF;
        Tue,  3 Nov 2020 14:27:18 -0500 (EST)
Subject: FAILED: patch "[PATCH] nbd: don't update block size after device is started" failed to apply to 4.19-stable tree
To:     ming.lei@redhat.com, axboe@kernel.dk, jack@suse.cz,
        josef@toxicpanda.com, lining2020x@163.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 20:27:14 +0100
Message-ID: <160443163459175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b40813ddcd6bf9f01d020804e4cb8febc480b9e4 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Wed, 28 Oct 2020 15:24:34 +0800
Subject: [PATCH] nbd: don't update block size after device is started

Mounted NBD device can be resized, one use case is rbd-nbd.

Fix the issue by setting up default block size, then not touch it
in nbd_size_update() any more. This kind of usage is aligned with loop
which has same use case too.

Cc: stable@vger.kernel.org
Fixes: c8a83a6b54d0 ("nbd: Use set_blocksize() to set device blocksize")
Reported-by: lining <lining2020x@163.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Jan Kara <jack@suse.cz>
Tested-by: lining <lining2020x@163.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 0bed21c0c81b..c4f9ccf5cc2a 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -296,7 +296,7 @@ static void nbd_size_clear(struct nbd_device *nbd)
 	}
 }
 
-static void nbd_size_update(struct nbd_device *nbd)
+static void nbd_size_update(struct nbd_device *nbd, bool start)
 {
 	struct nbd_config *config = nbd->config;
 	struct block_device *bdev = bdget_disk(nbd->disk, 0);
@@ -313,7 +313,8 @@ static void nbd_size_update(struct nbd_device *nbd)
 	if (bdev) {
 		if (bdev->bd_disk) {
 			bd_set_nr_sectors(bdev, nr_sectors);
-			set_blocksize(bdev, config->blksize);
+			if (start)
+				set_blocksize(bdev, config->blksize);
 		} else
 			set_bit(GD_NEED_PART_SCAN, &nbd->disk->state);
 		bdput(bdev);
@@ -328,7 +329,7 @@ static void nbd_size_set(struct nbd_device *nbd, loff_t blocksize,
 	config->blksize = blocksize;
 	config->bytesize = blocksize * nr_blocks;
 	if (nbd->task_recv != NULL)
-		nbd_size_update(nbd);
+		nbd_size_update(nbd, false);
 }
 
 static void nbd_complete_rq(struct request *req)
@@ -1308,7 +1309,7 @@ static int nbd_start_device(struct nbd_device *nbd)
 		args->index = i;
 		queue_work(nbd->recv_workq, &args->work);
 	}
-	nbd_size_update(nbd);
+	nbd_size_update(nbd, true);
 	return error;
 }
 

