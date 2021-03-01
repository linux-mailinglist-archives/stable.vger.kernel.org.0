Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B59327FDF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235863AbhCANqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:46:34 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:38287 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235856AbhCANqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:46:32 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6C09B1942166;
        Mon,  1 Mar 2021 08:46:10 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 01 Mar 2021 08:46:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=e2P6Rm
        3iF+tA+S0IRZ5EhvEyScTvBtngEQjlVRCztL0=; b=r0FJg+A4Lz/mQLDtNqazXQ
        qt3X3KlQDzJVUDBwyYT5WIU53QkecKMJe0Ng98KEWMN13C/gP9GWOYg0MHoZ0zA7
        5szWVTb/8LRHspVMd+EnNFB5APpR1yBYj77+Cm/DcYH9k1yiGWhygXVZJ/CI+3VO
        fJ0c8k+HSwX7f9E7IFzXjFHohZcQcpvVj2D88gIsUnkTNo9z540EQPqi94fGZ4Fg
        Yt+RP/5pcngMkMA2Eez24PC+70BKa6EkFKcJtUDb+puWr7Ilgfe3mHrb3Kv2t8nJ
        KcBZXCXwhBHfaSSeaMFQTHYRk0+hjP4U6pQpPf/QTSPPyYLak1FiHtF2WFPlNHTA
        ==
X-ME-Sender: <xms:IvA8YCyp2ly_cTeCeRogBJL43ToZY40RdmoY1tK6ATKzkOkbq4cPng>
    <xme:IvA8YJwiuryO3aFjZ1qz9EJ8iB3rvvOAeM_jekTshhklOk_0GbBSlpgFucB8P5RBM
    p98q8QZJA8-EA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:IvA8YKwOykshzSlTyBCx2odmjj5e3poD5hsQelWvtult2mKonvouEQ>
    <xmx:IvA8YDaE3LEtx04UQkWEW2GgPrj6krooA8DYlCDLsbZJTMi5JAO8Lw>
    <xmx:IvA8YLUocZM6WLQPjWWA22HL-jvshwXAfhr-9L5ak05z2ZbeHgmGuA>
    <xmx:IvA8YIaJ-Ff8ryZj8yrXL2SW0egX3AlO5UYpuLZbXLAVcFV-o7Jo6g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E442A1080063;
        Mon,  1 Mar 2021 08:46:09 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm writecache: fix writing beyond end of underlying device" failed to apply to 4.14-stable tree
To:     mpatocka@redhat.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:46:07 +0100
Message-ID: <161460636718471@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

