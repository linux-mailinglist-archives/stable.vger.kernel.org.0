Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47B32F0EB3
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 10:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbhAKJCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 04:02:01 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:59781 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727884AbhAKJCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 04:02:01 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 501B62605;
        Mon, 11 Jan 2021 04:00:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 04:00:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oS1ctk
        4eXk0wl0h+b3xjNRtwg9HtbYQXHhFueA6Uako=; b=eVsDJR0AMmaOJk2LBcrNM5
        F9Ebri0ckhqqtZLObfOEwdPxNIB8aUMb/f98o8bGV9Jrm/KzHxkeLqqlqzuvIfR5
        ymPW1HbO4+jwy1gRZtPQHo+PxPWSY/TIvYeZeln/EJ0uGvntr6NBKTwuz1B3y4Wm
        6+hHkByagt/J2rAq1mqPQxFK0VwY8eX93o1iLA8uwsHt03oaoRSm5Ddz64iAKRfj
        4469hdkTj0H+V9A/YEIh0gBS8Mrif9FGx0rRgRjLxJhGpLAkQzTysZgZ325Z2h69
        NgQJ4iya+sfWYJlyr4jKyIKmqZ1LUa/qrGxMIjt1dwX+kqg5a9poqOTjox4xGb1g
        ==
X-ME-Sender: <xms:xhP8X6svFkPBimm36pQeQYPObqzz_L8KuR9s-Fr6PundfyQH1XXfJA>
    <xme:xhP8X_cJ4AK9iGOInqagZognFIF-BAQr9JZC2L9alhq_nVAAt8LAzP9BgYVJ_SpuX
    wKJPA53_sbL4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:xhP8X1yAbNvEGB6ShbVser_5-w8ksP-1wMsr5IpcsItaii_1GIrGLg>
    <xmx:xhP8X1O7OEq0WE1wE4s4criwPDJPLjoPN7Arb2Pih5dApqTNHuDtUw>
    <xmx:xhP8X68YPHkW_HLqVMcC0gguAzSnRlFMOaCft8Av8QEPM2FftFJY6g>
    <xmx:xhP8Xwm-_oiSbGr0RHjbo2YoFZj7XdSeNUzQGgdR-5-Bfj_HSvuRzvdEdvA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9307324005D;
        Mon, 11 Jan 2021 04:00:54 -0500 (EST)
Subject: FAILED: patch "[PATCH] block: fix use-after-free in disk_part_iter_next" failed to apply to 5.10-stable tree
To:     ming.lei@redhat.com, axboe@kernel.dk, hch@lst.de,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 10:01:59 +0100
Message-ID: <161035571922259@kroah.com>
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

