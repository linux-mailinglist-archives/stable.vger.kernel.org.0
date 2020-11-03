Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0421C2A501A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 20:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbgKCT1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 14:27:25 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:57579 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725957AbgKCT1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 14:27:25 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7896C1942C1F;
        Tue,  3 Nov 2020 14:27:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 14:27:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=vJ2wPh
        N7dRMs+GDzLGe1mYUa4CWZ8aPbovU8cqKcwJg=; b=ZDNSml91T/Z4z+eBP3ilbb
        vknApFlBMY0mEEfo6zrt33BywspkO6PPOZfvTbC8hop1X8tXKJH5SJZTk5Vub+qJ
        GPXyBrtIaGr491xis0Z0PyQGfkqBt1PzW1gg2HUwwQZjGi8ztVhJOxbrfVqs3/Nb
        AXYmeHQou+Z6D4TO9iSe7r/Zos4Uz8rGNHEkZ7/yIvs6sIB3LMZNsZic/5kSnXEN
        9OCJeJt/kyG9enJxjtaH+6FtyZTSvpsgjuYyDQSR8Wh8+rHD1nQ7Dm8Q0jwhkRHK
        koS5gLgGWLIYKz4hqpfz3EvAX+bbwFOyg3PupcDHym8uxmxfT9a8u4Ud4g9VgGEg
        ==
X-ME-Sender: <xms:HK-hX5e9Kq1Wf1WFBwHfn_MbMBDn2d6neh436hvDUOi7GU1PboOsrw>
    <xme:HK-hX3N_siKJzTFNCevZ9hO9iavSY88Z4J2JQ5rH7sL1IK8-2rxB-kSfioVP3eLKS
    amZYUmddN-7sg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:HK-hXyju5VPFIiT01kIXZQ7nJVtSf9ioYC9T3EutsECmNzIBxbosBA>
    <xmx:HK-hXy_Doc7aDxbGnfSthhmaKGrr0Q_y3Id0uksxu87-lKowOEcu_g>
    <xmx:HK-hX1sZ1D1vS7laGGK5qcoSDWp402HOSH2xA-tpNE2BnPiozf4tow>
    <xmx:HK-hX9JgRKsutlEdYmwbZD7fdQRuHfBThbyZlWR9cLALN4fGYvw8Iw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0108032800FF;
        Tue,  3 Nov 2020 14:27:23 -0500 (EST)
Subject: FAILED: patch "[PATCH] nbd: don't update block size after device is started" failed to apply to 4.9-stable tree
To:     ming.lei@redhat.com, axboe@kernel.dk, jack@suse.cz,
        josef@toxicpanda.com, lining2020x@163.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 20:27:16 +0100
Message-ID: <160443163673123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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
 

