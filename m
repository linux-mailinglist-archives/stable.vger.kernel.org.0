Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCA227AF7D
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 15:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgI1N4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 09:56:55 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:55745 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbgI1N4w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 09:56:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id C852010D3;
        Mon, 28 Sep 2020 09:56:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 28 Sep 2020 09:56:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=X4zs3r
        16uuTfJQZybA3n8b0NsiklDCjmuI3QXKbaRzI=; b=a7aUFe9y/4SX6Rv1z6lGBE
        zwMkFi3wZsOrSWllf/DGFdDSaVHsfL/WFvmggNuuItsedg24l3JR+4es/dSWFma0
        o0HbWKte8z9jJAickSj463dBOlMIJGSCcG8aYhtOFzqkNiqEYmlopVxSDn/QcIRz
        8Gwo5A/AwjoJnlUdtuM5Q4NsQYXMb3Cvlo8RLL8LusYkVmkmhVztUvlDQ9jtfvlw
        sLzRQ8JuDNje0ATgM27ic+NIu7hw2g158IqC1n38sG2uyU9ak29IAs2jqtGbGfhc
        jCoN3fqHZmqGBu7DNN9WHhYbCg10iTzVZLupvxe5dPbIuC1Xcmzm+Sybbbwoxyxg
        ==
X-ME-Sender: <xms:o-txXxehv3ZN61-sWc0pPILK3upvUQk8GFPdR6At_gI8nScbaIbMWg>
    <xme:o-txX_NcfHX243ZOC9c20u_hBAZggJn5r7mXfAfd28Dr6S0323u_NFx5iefcRHo_k
    U91kAFvKa5c0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeigdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:o-txX6g92iJ8nynVTHMEtmE6OwlSLvO6fq7Sgsi6RbwerkXiS6gIgw>
    <xmx:o-txX6-cFLYGrrr_y0LghkN--bK52d-fpHU5zGztpk4Y-BtDhXeIWg>
    <xmx:o-txX9u0I3uBjkl9VxiWFt2YWB9HQ-xnxCQbq6qax6q4JMiY9b8DhA>
    <xmx:o-txX71nAnQ0_Khgmasi1IwtrabIwErmQeDI9UnumqpA8uuWXYC1Akeq9P8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E45ED3064686;
        Mon, 28 Sep 2020 09:56:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm: fix bio splitting and its bio completion order for" failed to apply to 5.8-stable tree
To:     snitzer@redhat.com, ming.lei@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Sep 2020 15:56:51 +0200
Message-ID: <160130141116536@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
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

