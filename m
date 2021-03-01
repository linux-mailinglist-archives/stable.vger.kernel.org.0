Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FBD327FDE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbhCANqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:46:40 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:50309 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235866AbhCANqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:46:39 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1017019412C2;
        Mon,  1 Mar 2021 08:46:18 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 01 Mar 2021 08:46:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8Ul5hc
        LnoiGFUE4kbygosTtQ426hMT9qm8YQ2lE2Kj0=; b=VceHIK2EU4dMqyUJSsMoSD
        A1iUBnjA+MN/d4YkZw6mbrZHPToxXWPxZv9EgIF7uPLXjZua6rVBxVcsRKSbFQv5
        G1aPSmriZxwAl/g6oUTwB3OClogyPoseooHKzfuZki962KeWZQAZ45e9o76R5lBd
        /QcKqYWtxysgOtq1hiZlkqZkfqtGhL1j6tDN8uJZ7B8INSnDlmgnDZgmLrOH9i3P
        Q5ddCDSQUxjKM6XBB1V2rBndWdUGCd7iqo4Gp9LJD56sabUBQy9ZhQS1W7M/jFcq
        HqwcZzLSk7iRB9ODppOO//TNMDsGK2j+iuJyzxyghxKgDZe9uoTS5sZSo7JTgS9g
        ==
X-ME-Sender: <xms:KvA8YBIuPqpqRai-H5MNhr4KQ8YUV1LiVsdwfkoUbsOZ9oxsBq_0fQ>
    <xme:KvA8YDhI4MAyfpNJ28ssHshrUUgO_sfvs0TwVRSaXbxkFGuGosw4T1z1ED0uqVt10
    xbTMQHrTZaW8g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:KvA8YF8x8UC6muNVtofo-85jh0UP6G-EOpHBOQiMu_nDrTTB38gv0w>
    <xmx:KvA8YAP_DqRAHvXcnsUmTWLkSTNZ9JoDYTDS3vNK0DV2U5VXOE940w>
    <xmx:KvA8YBBRLZ1w5P_jhD8VlTKk10--o9RaziIOOVW4cvuuGktm9pDH4g>
    <xmx:KvA8YOH7uv3_QqYh1aN7vGqIleqsTIISKlaoMS_WEviq_cehmNGj_Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C4DDB108005C;
        Mon,  1 Mar 2021 08:46:17 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm writecache: fix writing beyond end of underlying device" failed to apply to 4.19-stable tree
To:     mpatocka@redhat.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:46:08 +0100
Message-ID: <1614606368115248@kroah.com>
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

From 4134455f2aafdfeab50cabb4cccb35e916034b93 Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Tue, 9 Feb 2021 10:56:20 -0500
Subject: [PATCH] dm writecache: fix writing beyond end of underlying device
 when shrinking

Do not attempt to write any data beyond the end of the underlying data
device while shrinking it.

The DM writecache device must be suspended when the underlying data
device is shrunk.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index e8382d73c73c..baf5a9ce2b25 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -148,6 +148,7 @@ struct dm_writecache {
 	size_t metadata_sectors;
 	size_t n_blocks;
 	uint64_t seq_count;
+	sector_t data_device_sectors;
 	void *block_start;
 	struct wc_entry *entries;
 	unsigned block_size;
@@ -977,6 +978,8 @@ static void writecache_resume(struct dm_target *ti)
 
 	wc_lock(wc);
 
+	wc->data_device_sectors = i_size_read(wc->dev->bdev->bd_inode) >> SECTOR_SHIFT;
+
 	if (WC_MODE_PMEM(wc)) {
 		persistent_memory_invalidate_cache(wc->memory_map, wc->memory_map_size);
 	} else {
@@ -1646,6 +1649,10 @@ static bool wc_add_block(struct writeback_struct *wb, struct wc_entry *e, gfp_t
 	void *address = memory_data(wc, e);
 
 	persistent_memory_flush_cache(address, block_size);
+
+	if (unlikely(bio_end_sector(&wb->bio) >= wc->data_device_sectors))
+		return true;
+
 	return bio_add_page(&wb->bio, persistent_memory_page(address),
 			    block_size, persistent_memory_page_offset(address)) != 0;
 }
@@ -1717,6 +1724,9 @@ static void __writecache_writeback_pmem(struct dm_writecache *wc, struct writeba
 		if (writecache_has_error(wc)) {
 			bio->bi_status = BLK_STS_IOERR;
 			bio_endio(bio);
+		} else if (unlikely(!bio_sectors(bio))) {
+			bio->bi_status = BLK_STS_OK;
+			bio_endio(bio);
 		} else {
 			submit_bio(bio);
 		}
@@ -1760,6 +1770,14 @@ static void __writecache_writeback_ssd(struct dm_writecache *wc, struct writebac
 			e = f;
 		}
 
+		if (unlikely(to.sector + to.count > wc->data_device_sectors)) {
+			if (to.sector >= wc->data_device_sectors) {
+				writecache_copy_endio(0, 0, c);
+				continue;
+			}
+			from.count = to.count = wc->data_device_sectors - to.sector;
+		}
+
 		dm_kcopyd_copy(wc->dm_kcopyd, &from, 1, &to, 0, writecache_copy_endio, c);
 
 		__writeback_throttle(wc, wbl);

