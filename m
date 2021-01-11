Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481F32F0EB2
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 10:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbhAKJBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 04:01:54 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:57235 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727963AbhAKJBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 04:01:54 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 46AC4260F;
        Mon, 11 Jan 2021 04:00:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 04:00:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+Ux8kF
        KIrilzCgwGGMBbChFXbc3y1Q6csKaYKDD32WI=; b=BS1bBY2gN0YsgGazbl9J9b
        ZAaXdU/0djEh/O8RidZcLO6G6zvRhtqv1qEo5nI9dDNUVu16poMnPR316F3WxtaZ
        2jxP1CVV+xwk5K/g4Q9zn1j3dTQfgvlIrbtP6zDq/CoZY/HMb87yvrJ6zDLorI4m
        vHHNyq38vVK0xANiP299bevMmV/TfgbVHDPFupSHJNKpLEA5Umh6f48NAVNlQhVT
        +LgxGfcdcq7lkfv82ADf3+4efFpjrLcIAbLVm0JfSOjZe1IUyxPscoSeVYrqtS/L
        6V8KII5Xlt6e47rtuLw1RS5J+3DXkBgRAFzUouc2HY7GvfLw+iDWE4frGDqUGdxQ
        ==
X-ME-Sender: <xms:vhP8X2xOHtLE0eBi4Yhwcllqy5csFmmQTsY-k6mUHc5jPCaCVakiVA>
    <xme:vhP8XySI4uy20dZIu4I7e3PnQBY8HR1AD2K51Ptb7RIgjSgzT1F2Ci2M4K31R-w3p
    STGy7BdSa18mQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:vhP8X4WnVBNdrMIOd3cMviuGPRd9TtMnHrM-JjzKWRVTRVN5vnMqbg>
    <xmx:vhP8X8g9DFPifneCNy-QQCjgMb2gPAnnHTdDf7LCb0kvDcWfJysMPA>
    <xmx:vhP8X4DCW_x42OB-x9-QWHeQm4PVWd1Mz0_JLV4cC0HRgTSERL4x3Q>
    <xmx:vxP8Xx46MpCBVqJF-bUXSu8VQgIDzTAcjkwc2B7v-3KpfAiKx7zXHjo8KeA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 81F4C1080059;
        Mon, 11 Jan 2021 04:00:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] block: fix use-after-free in disk_part_iter_next" failed to apply to 5.4-stable tree
To:     ming.lei@redhat.com, axboe@kernel.dk, hch@lst.de,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 10:01:58 +0100
Message-ID: <16103557181240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aebf5db917055b38f4945ed6d621d9f07a44ff30 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Mon, 21 Dec 2020 12:33:35 +0800
Subject: [PATCH] block: fix use-after-free in disk_part_iter_next

Make sure that bdgrab() is done on the 'block_device' instance before
referring to it for avoiding use-after-free.

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+825f0f9657d4e528046e@syzkaller.appspotmail.com
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/genhd.c b/block/genhd.c
index 73faec438e49..419548e92d82 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -246,15 +246,18 @@ struct block_device *disk_part_iter_next(struct disk_part_iter *piter)
 		part = rcu_dereference(ptbl->part[piter->idx]);
 		if (!part)
 			continue;
+		piter->part = bdgrab(part);
+		if (!piter->part)
+			continue;
 		if (!bdev_nr_sectors(part) &&
 		    !(piter->flags & DISK_PITER_INCL_EMPTY) &&
 		    !(piter->flags & DISK_PITER_INCL_EMPTY_PART0 &&
-		      piter->idx == 0))
+		      piter->idx == 0)) {
+			bdput(piter->part);
+			piter->part = NULL;
 			continue;
+		}
 
-		piter->part = bdgrab(part);
-		if (!piter->part)
-			continue;
 		piter->idx += inc;
 		break;
 	}

