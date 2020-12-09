Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A172D4622
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731424AbgLIPyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:54:51 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:41047 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728826AbgLIPyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:54:51 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 12FD7194399D;
        Wed,  9 Dec 2020 03:42:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 03:42:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Voc4Oo
        ITFyMRDbyjjKyDwRCzAWb46iPvavHbUBXzi58=; b=YdtMf5Xie4Py+gWHkNKCLl
        +faitDCGePhb6B/IY36t0prgtC6qkeb6GaebOChTIEFqMwEZGapt1x+hJnHcFh1n
        moJjtX2Y0CvdPF7kdOl+FnFnEQcF5UG+F1czcOo7Q1pN7wHzxnKluRM5fuC7zzBS
        hAzY5RnWDUUAACYiaw/GqEEdd522E65SVDJVbX5COn8ThJF6R2otvO1iIIpfm5ya
        erkhfiPwsbAD+Zfd9FfRjRuLOEbZ0p4dt/gDjzhLcbTXLFWnYaRxkus24G6UTrc1
        N7C6YbVzkBdln/qG9REfChC8nezHUuqmJWbavtic3atL5yQRiLJMqU/tPcs+z76g
        ==
X-ME-Sender: <xms:-I3QXzgL7IxGmcTL68bNxYw2oKs1LaoPy142Uq8wW9r-PxrYJFmg8w>
    <xme:-I3QXwAzK0KgRDdLfWz7SM-yujWI38xpFWr_oTA02I-okacIXHRAOFXhbN2TeWFUf
    O2PyASUNtHAaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejjedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:-I3QXzEPl_dce7m_5Z8JSVgBlkGQ4gl7KyW8g7M5Er7pZUuFE0FvWA>
    <xmx:-I3QXwTqBufHGJbP7ekJOWqVM2z7bK6s-uNrkxpmhDb3xFXsayA0AQ>
    <xmx:-I3QXwwAJQTnouljdHVzYLvoOsuiXJl-aXUHrZQHIvoOcqcBlUox5A>
    <xmx:-Y3QX89OGeJ4al0crFKqF3pnOpwh1MkAmDjwGYzEXnHpOEovwdjAZw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B81CB240064;
        Wed,  9 Dec 2020 03:42:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm: fix IO splitting" failed to apply to 5.9-stable tree
To:     snitzer@redhat.com, axboe@kernel.dk, bjohnsto@redhat.com,
        jdorminy@redhat.com, ktkhai@virtuozzo.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 09:43:49 +0100
Message-ID: <160750342912147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3ee16db390b42b8a21f2ad2ea2518f3469c6e532 Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@redhat.com>
Date: Mon, 30 Nov 2020 10:57:43 -0500
Subject: [PATCH] dm: fix IO splitting

Commit 882ec4e609c1 ("dm table: stack 'chunk_sectors' limit to account
for target-specific splitting") caused a couple regressions:
1) Using lcm_not_zero() when stacking chunk_sectors was a bug because
   chunk_sectors must reflect the most limited of all devices in the
   IO stack.
2) DM targets that set max_io_len but that do _not_ provide an
   .iterate_devices method no longer had there IO split properly.

And commit 5091cdec56fa ("dm: change max_io_len() to use
blk_max_size_offset()") also caused a regression where DM no longer
supported varied (per target) IO splitting. The implication being the
potential for severely reduced performance for IO stacks that use a DM
target like dm-cache to hide performance limitations of a slower
device (e.g. one that requires 4K IO splitting).

Coming full circle: Fix all these issues by discontinuing stacking
chunk_sectors up using ti->max_io_len in dm_calculate_queue_limits(),
add optional chunk_sectors override argument to blk_max_size_offset()
and update DM's max_io_len() to pass ti->max_io_len to its
blk_max_size_offset() call.

Passing in an optional chunk_sectors override to blk_max_size_offset()
allows for code reuse of block's centralized calculation for max IO
size based on provided offset and split boundary.

Fixes: 882ec4e609c1 ("dm table: stack 'chunk_sectors' limit to account for target-specific splitting")
Fixes: 5091cdec56fa ("dm: change max_io_len() to use blk_max_size_offset()")
Cc: stable@vger.kernel.org
Reported-by: John Dorminy <jdorminy@redhat.com>
Reported-by: Bruce Johnston <bjohnsto@redhat.com>
Reported-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Reviewed-by: John Dorminy <jdorminy@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk-merge.c b/block/blk-merge.c
index bcf5e4580603..97b7c2821565 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -144,7 +144,7 @@ static struct bio *blk_bio_write_same_split(struct request_queue *q,
 static inline unsigned get_max_io_size(struct request_queue *q,
 				       struct bio *bio)
 {
-	unsigned sectors = blk_max_size_offset(q, bio->bi_iter.bi_sector);
+	unsigned sectors = blk_max_size_offset(q, bio->bi_iter.bi_sector, 0);
 	unsigned max_sectors = sectors;
 	unsigned pbs = queue_physical_block_size(q) >> SECTOR_SHIFT;
 	unsigned lbs = queue_logical_block_size(q) >> SECTOR_SHIFT;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 2073ee8d18f4..7eeb7c4169c9 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -18,7 +18,6 @@
 #include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/atomic.h>
-#include <linux/lcm.h>
 #include <linux/blk-mq.h>
 #include <linux/mount.h>
 #include <linux/dax.h>
@@ -1449,10 +1448,6 @@ int dm_calculate_queue_limits(struct dm_table *table,
 			zone_sectors = ti_limits.chunk_sectors;
 		}
 
-		/* Stack chunk_sectors if target-specific splitting is required */
-		if (ti->max_io_len)
-			ti_limits.chunk_sectors = lcm_not_zero(ti->max_io_len,
-							       ti_limits.chunk_sectors);
 		/* Set I/O hints portion of queue limits */
 		if (ti->type->io_hints)
 			ti->type->io_hints(ti, &ti_limits);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 98866e725f25..f7eb3d2964f3 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1039,15 +1039,18 @@ static sector_t max_io_len(struct dm_target *ti, sector_t sector)
 	sector_t max_len;
 
 	/*
-	 * Does the target need to split even further?
-	 * - q->limits.chunk_sectors reflects ti->max_io_len so
-	 *   blk_max_size_offset() provides required splitting.
-	 * - blk_max_size_offset() also respects q->limits.max_sectors
+	 * Does the target need to split IO even further?
+	 * - varied (per target) IO splitting is a tenet of DM; this
+	 *   explains why stacked chunk_sectors based splitting via
+	 *   blk_max_size_offset() isn't possible here. So pass in
+	 *   ti->max_io_len to override stacked chunk_sectors.
 	 */
-	max_len = blk_max_size_offset(ti->table->md->queue,
-				      target_offset);
-	if (len > max_len)
-		len = max_len;
+	if (ti->max_io_len) {
+		max_len = blk_max_size_offset(ti->table->md->queue,
+					      target_offset, ti->max_io_len);
+		if (len > max_len)
+			len = max_len;
+	}
 
 	return len;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 639cae2c158b..24ae504cf77d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1073,11 +1073,12 @@ static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
  * file system requests.
  */
 static inline unsigned int blk_max_size_offset(struct request_queue *q,
-					       sector_t offset)
+					       sector_t offset,
+					       unsigned int chunk_sectors)
 {
-	unsigned int chunk_sectors = q->limits.chunk_sectors;
-
-	if (!chunk_sectors)
+	if (!chunk_sectors && q->limits.chunk_sectors)
+		chunk_sectors = q->limits.chunk_sectors;
+	else
 		return q->limits.max_sectors;
 
 	if (likely(is_power_of_2(chunk_sectors)))
@@ -1101,7 +1102,7 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
 	    req_op(rq) == REQ_OP_SECURE_ERASE)
 		return blk_queue_get_max_sectors(q, req_op(rq));
 
-	return min(blk_max_size_offset(q, offset),
+	return min(blk_max_size_offset(q, offset, 0),
 			blk_queue_get_max_sectors(q, req_op(rq)));
 }
 

