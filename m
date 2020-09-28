Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC4127AF78
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 15:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgI1N4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 09:56:44 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:48749 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbgI1N4o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 09:56:44 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 65CDDFE5;
        Mon, 28 Sep 2020 09:56:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 28 Sep 2020 09:56:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=S+UV5W
        BnOhIjkHkst+rNFZQa+8L91VPmM4goLaYdzV8=; b=Kz/mEONQjubkWi1fTxtrjn
        cTgEwNy4stejWtzLTQtCXvswnCKs455/lUT2HD6bv6/nr2KB47KIAVS3HM1vHJpb
        6pRqYoRT7nXwgb7GEL9/QlIcW+MYwFC1EjnEUePpHIQDqYUJkOCj9TXGT/y2ejHE
        601r9cdGeFZaAIL+YkAu4wt3Ifiz6KKSGq/BWFU9uehN5mju9hzI/CEciYiwVwy3
        FK0YUvVRtojxh5HZERzPJLmEoP/0OIBvWX/YJ5dsgA4pMTB3CQh3Bx0KwGpg8f6K
        4QbQkvFEn3bwhceC9mIHO47F8J05hsR4NKKOvfrWkHdprk09tovX9kDZlnnTy+Xg
        ==
X-ME-Sender: <xms:mutxX8da1N5ECrnqvPjZqZ7Ll9PFQuORVZscEFmHhSEqQEDJ1i7IyQ>
    <xme:mutxX-OMYzM11TQbO9UA8AYmsd_5XH8Rl1kZxKfBPDJN0X_SpYuVTgO0u57LSDrcg
    uEFUc27DfIk3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeigdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:mutxX9hGmwRV3AlYaVN14_IQ9ylw9n_Gq_e-VviafPb0tw4zXCdEtQ>
    <xmx:mutxXx-mxlsUlzJ4JH-bR4-iTLyzhN0SXjEsrMkEldVGZlc7sql7hQ>
    <xmx:mutxX4tZrM8RR1xqDK6_ClE249rB2h6s_bCDV32GVPuRtzpdrvmtFA>
    <xmx:m-txX-1miZbKJlr4zrHGcBhWIXtcYK2beX8J69p6Z0I11EDtM0iaA-6MzpQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 984CB3280059;
        Mon, 28 Sep 2020 09:56:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm: fix bio splitting and its bio completion order for" failed to apply to 5.4-stable tree
To:     snitzer@redhat.com, ming.lei@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Sep 2020 15:56:50 +0200
Message-ID: <1601301410240130@kroah.com>
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

From ee1dfad5325ff1cfb2239e564cd411b3bfe8667a Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@redhat.com>
Date: Mon, 14 Sep 2020 13:04:19 -0400
Subject: [PATCH] dm: fix bio splitting and its bio completion order for
 regular IO

dm_queue_split() is removed because __split_and_process_bio() _must_
handle splitting bios to ensure proper bio submission and completion
ordering as a bio is split.

Otherwise, multiple recursive calls to ->submit_bio will cause multiple
split bios to be allocated from the same ->bio_split mempool at the same
time. This would result in deadlock in low memory conditions because no
progress could be made (only one bio is available in ->bio_split
mempool).

This fix has been verified to still fix the loss of performance, due
to excess splitting, that commit 120c9257f5f1 provided.

Fixes: 120c9257f5f1 ("Revert "dm: always call blk_queue_split() in dm_process_bio()"")
Cc: stable@vger.kernel.org # 5.0+, requires custom backport due to 5.9 changes
Reported-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4a40df8af7d3..d948cd522431 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1724,23 +1724,6 @@ static blk_qc_t __process_bio(struct mapped_device *md, struct dm_table *map,
 	return ret;
 }
 
-static void dm_queue_split(struct mapped_device *md, struct dm_target *ti, struct bio **bio)
-{
-	unsigned len, sector_count;
-
-	sector_count = bio_sectors(*bio);
-	len = min_t(sector_t, max_io_len((*bio)->bi_iter.bi_sector, ti), sector_count);
-
-	if (sector_count > len) {
-		struct bio *split = bio_split(*bio, len, GFP_NOIO, &md->queue->bio_split);
-
-		bio_chain(split, *bio);
-		trace_block_split(md->queue, split, (*bio)->bi_iter.bi_sector);
-		submit_bio_noacct(*bio);
-		*bio = split;
-	}
-}
-
 static blk_qc_t dm_process_bio(struct mapped_device *md,
 			       struct dm_table *map, struct bio *bio)
 {
@@ -1768,14 +1751,12 @@ static blk_qc_t dm_process_bio(struct mapped_device *md,
 	if (current->bio_list) {
 		if (is_abnormal_io(bio))
 			blk_queue_split(&bio);
-		else
-			dm_queue_split(md, ti, &bio);
+		/* regular IO is split by __split_and_process_bio */
 	}
 
 	if (dm_get_md_type(md) == DM_TYPE_NVME_BIO_BASED)
 		return __process_bio(md, map, bio, ti);
-	else
-		return __split_and_process_bio(md, map, bio);
+	return __split_and_process_bio(md, map, bio);
 }
 
 static blk_qc_t dm_submit_bio(struct bio *bio)

