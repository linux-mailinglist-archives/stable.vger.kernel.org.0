Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B707E2E36C3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgL1LtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:49:20 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51471 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726263AbgL1LtU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:49:20 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 3678F77B;
        Mon, 28 Dec 2020 06:48:14 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:48:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=WGzopA
        QTDFrLPHNIbUg+NWKVFuLHtjWUsanNFx8PJys=; b=mob20YeHS07THY4xGOR+B5
        s6Owhu4EJaFZzYiWisHi/SY9CRONIptnqIeG+5PY1973uM5jRfosInYLyV3GHFTm
        s7oQhylh3k75Uozo0xh9CZ52oa7E0t56FFjglfRjt//iaccS2FLvEt4xb3vzG3+s
        OkuomTjUKqMKnUd8iwRPMTVmLb/mgLOt2rP3MZRfHriF2yv+/PByYvcUXttowX6R
        TpvkFnQHp6H01CY9obKcesLgxuZz+guXgmzzf8ndbiBTUM8EchxN6cvORNjajXt6
        odpTmFxXjTTQ3Y4EozqplglLHcd9mgwnYRAVan7/bwjTHX0LaQoMdYqmXz3HAWeQ
        ==
X-ME-Sender: <xms:_MXpXwpNUgYYbezj-tR9-BAVQjmmYm8FMsSVzJPae28CcQP6yz9tTw>
    <xme:_MXpX2rlb5tdmuf5s9IHsXe67xMhzdpuk7xVEofMQS4IxmlvXUhFFhyROUGMRKsvJ
    sRa9bcmj9vTxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:_MXpX1NC2hfJ4NLr5zLatoozNvuh4MPKx6P3ZaojSDLAzPEY1l04qQ>
    <xmx:_MXpX3477KJQfE_V0_vbP8Aa0hBMY8FmLT1Io-MMmQqpHtBp60XCHA>
    <xmx:_MXpX_5MdPS6efsRqlOwYvPODpnQuAWWKtVdD1qFvY37PUH8rJj7dQ>
    <xmx:_cXpXxmVZQD6I9GeQIxarGQUL8IsjKgQp8APxDk11vmiFtAkZ13xrg76PWc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1E9261080064;
        Mon, 28 Dec 2020 06:48:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] null_blk: Fix zone size initialization" failed to apply to 4.19-stable tree
To:     damien.lemoal@wdc.com, axboe@kernel.dk, hch@lst.de,
        johannes.thumshirn@wdc.com, naohiro.aota@wdc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:49:35 +0100
Message-ID: <160915617556175@kroah.com>
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

From 0ebcdd702f49aeb0ad2e2d894f8c124a0acc6e23 Mon Sep 17 00:00:00 2001
From: Damien Le Moal <damien.lemoal@wdc.com>
Date: Fri, 20 Nov 2020 10:55:11 +0900
Subject: [PATCH] null_blk: Fix zone size initialization

For a null_blk device with zoned mode enabled is currently initialized
with a number of zones equal to the device capacity divided by the zone
size, without considering if the device capacity is a multiple of the
zone size. If the zone size is not a divisor of the capacity, the zones
end up not covering the entire capacity, potentially resulting is out
of bounds accesses to the zone array.

Fix this by adding one last smaller zone with a size equal to the
remainder of the disk capacity divided by the zone size if the capacity
is not a multiple of the zone size. For such smaller last zone, the zone
capacity is also checked so that it does not exceed the smaller zone
size.

Reported-by: Naohiro Aota <naohiro.aota@wdc.com>
Fixes: ca4b2a011948 ("null_blk: add zone support")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index beb34b4f76b0..1d0370d91fe7 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -6,8 +6,7 @@
 #define CREATE_TRACE_POINTS
 #include "null_blk_trace.h"
 
-/* zone_size in MBs to sectors. */
-#define ZONE_SIZE_SHIFT		11
+#define MB_TO_SECTS(mb) (((sector_t)mb * SZ_1M) >> SECTOR_SHIFT)
 
 static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
 {
@@ -16,7 +15,7 @@ static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
 
 int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 {
-	sector_t dev_size = (sector_t)dev->size * 1024 * 1024;
+	sector_t dev_capacity_sects, zone_capacity_sects;
 	sector_t sector = 0;
 	unsigned int i;
 
@@ -38,9 +37,13 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 		return -EINVAL;
 	}
 
-	dev->zone_size_sects = dev->zone_size << ZONE_SIZE_SHIFT;
-	dev->nr_zones = dev_size >>
-				(SECTOR_SHIFT + ilog2(dev->zone_size_sects));
+	zone_capacity_sects = MB_TO_SECTS(dev->zone_capacity);
+	dev_capacity_sects = MB_TO_SECTS(dev->size);
+	dev->zone_size_sects = MB_TO_SECTS(dev->zone_size);
+	dev->nr_zones = dev_capacity_sects >> ilog2(dev->zone_size_sects);
+	if (dev_capacity_sects & (dev->zone_size_sects - 1))
+		dev->nr_zones++;
+
 	dev->zones = kvmalloc_array(dev->nr_zones, sizeof(struct blk_zone),
 			GFP_KERNEL | __GFP_ZERO);
 	if (!dev->zones)
@@ -101,8 +104,12 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 		struct blk_zone *zone = &dev->zones[i];
 
 		zone->start = zone->wp = sector;
-		zone->len = dev->zone_size_sects;
-		zone->capacity = dev->zone_capacity << ZONE_SIZE_SHIFT;
+		if (zone->start + dev->zone_size_sects > dev_capacity_sects)
+			zone->len = dev_capacity_sects - zone->start;
+		else
+			zone->len = dev->zone_size_sects;
+		zone->capacity =
+			min_t(sector_t, zone->len, zone_capacity_sects);
 		zone->type = BLK_ZONE_TYPE_SEQWRITE_REQ;
 		zone->cond = BLK_ZONE_COND_EMPTY;
 

