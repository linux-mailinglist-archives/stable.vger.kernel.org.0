Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91BF2E36C2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgL1LtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:49:08 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:54625 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726263AbgL1LtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:49:08 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id E87297EC;
        Mon, 28 Dec 2020 06:48:21 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:48:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=jqO7Hc
        IEe3pB3owWGd8bo98HetVOD/0DHgpy0TachNQ=; b=KZNjXLxYGg6lcuZSei56pH
        Hswtxxj/JOMoDGDEeVqCrT/qhSIPfwDomfKCVwb1Tz4ezjzcC2zyHebfBcI+j2kt
        JpMNUfAvjAzvRvK5O+F4BfCn7Q3jO1iG4a08dNqM522pa+XBTC1Og7BYVbKZ5sGm
        NdZQMAXvW6D5sBETfvMxhwFO1nwSBHtp19zDDjToZLRGWwpeALvVEFxzl0iRNHUK
        r/YBW5yCCOCb7Mwo93XFGMQHVw4gqZ49af7vs+vBoztu7JqQF4tfOhgMpvYXUiTl
        Nn1yAnLQqGUxe4lC92j5MynWqf5XR/BG1svB+9bcMEGYiZ/jXJRNWEICcaoC4s1w
        ==
X-ME-Sender: <xms:BcbpX8eYKt6KI69t597VdHlxrdFnMe5QEqTNkA3FGXsLsInFA_AxCg>
    <xme:BcbpX-Pyz440a4JmH94CLBPpes-V-3Db8x9POQwaXaU__b9DciyBsdwRdIJlpi2aC
    m4xmLKOJNIAgw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:BcbpX9i0Zl0NEoCjK6GAOLTiJE00PdbgwCBH_is9lz7vJKT0IvJ_4Q>
    <xmx:BcbpXx98OFeZUpDk3cNGT1toi6pvDfw7qPdrLvXs8SSD2DQPWqp1Pw>
    <xmx:BcbpX4t3aG19ziUeaD1KPT_QDQnVOcUVAj1AIVA4WJNDO6rsLALJ5g>
    <xmx:BcbpX0J5Mgs4zVGNW-q7campveFGSZ0ecvl2eEBQtcsI7tKqgDk4OIbwgNY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 08DFC240057;
        Mon, 28 Dec 2020 06:48:20 -0500 (EST)
Subject: FAILED: patch "[PATCH] null_blk: Fix zone size initialization" failed to apply to 5.4-stable tree
To:     damien.lemoal@wdc.com, axboe@kernel.dk, hch@lst.de,
        johannes.thumshirn@wdc.com, naohiro.aota@wdc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:49:36 +0100
Message-ID: <160915617623242@kroah.com>
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
 

