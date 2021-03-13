Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573E9339E34
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 14:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbhCMNZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 08:25:32 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:44023 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233188AbhCMNZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 08:25:19 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id BA1B31941DB7;
        Sat, 13 Mar 2021 08:25:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 13 Mar 2021 08:25:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=o5R3V+
        4/VypcOzEjwhyPhY0FpAvqLb5mcNcUrfY1z5A=; b=PUhA+Uvm9izxJGeL2zLdGI
        GjxnE5TdpXiaoDMtJlZeg888DgobzArwnjAIg6ed+JZA0Ip3+Vzd0bb3JEGUxxN5
        nZ9FhYQFZetM/XdwBHiG0uKtzNKsxOKZMhChq569NtrBDirRwDdh7AAJkUNHpsTd
        HlnBRT0h/MlbvHtR26HMbJ3RQQl1yH9HBii12PW0+CI+0eYLF7x6Kiwp0EDmyT1a
        XqiUe2LdqBAZgPD+za+ewwSyNxjrOqn9GEmhpnrJyAN3FKpPmzEAb61E+56pzFXB
        rPep7o1YEo9x4tm9zarmOyebYgUj1noEpUbTbZWaJzSYH75dzDu6FqDE58zVoiSg
        ==
X-ME-Sender: <xms:Pr1MYADD_HVzO3AIN3GKAfxa05_5aCGBGzQvC6jsYE3dT59w7rBSYQ>
    <xme:Pr1MYCgjx19ML6JcSscWHU6Kjc88Glvl1cN8wLb2Sn_EX-Dmxa4zajRRvg6OCZCMB
    E1rqbsNiU4HEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvgedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Pr1MYDlAoMGkKTv0tB8uwQoE0Hsot2nFxePVZ6wYcohT86x3ScaVfw>
    <xmx:Pr1MYGz6XVKGh_gWTScq8WH6FaCAuJCZHg7C_5ysEs7E-ninTyiTqQ>
    <xmx:Pr1MYFRs1EC_jZFGDYHPyuFkO2VySxvxfRQnddCdgbGG-TYcVbKMZg>
    <xmx:Pr1MYAcwmduwLrX4hKBZFmx85fu3V2J4_jK7lJTVqFH5et1WoG8gPA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 64B4424005A;
        Sat, 13 Mar 2021 08:25:18 -0500 (EST)
Subject: FAILED: patch "[PATCH] block: Discard page cache of zone reset target range" failed to apply to 4.14-stable tree
To:     shinichiro.kawasaki@wdc.com, axboe@kernel.dk, hch@lst.de,
        johannes.thumshirn@wdc.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Mar 2021 14:25:07 +0100
Message-ID: <1615641907171138@kroah.com>
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

From e5113505904ea1c1c0e1f92c1cfa91fbf4da1694 Mon Sep 17 00:00:00 2001
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Date: Thu, 11 Mar 2021 16:25:46 +0900
Subject: [PATCH] block: Discard page cache of zone reset target range

When zone reset ioctl and data read race for a same zone on zoned block
devices, the data read leaves stale page cache even though the zone
reset ioctl zero clears all the zone data on the device. To avoid
non-zero data read from the stale page cache after zone reset, discard
page cache of reset target zones in blkdev_zone_mgmt_ioctl(). Introduce
the helper function blkdev_truncate_zone_range() to discard the page
cache. Ensure the page cache discarded by calling the helper function
before and after zone reset in same manner as fallocate does.

This patch can be applied back to the stable kernel version v5.10.y.
Rework is needed for older stable kernels.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")
Cc: <stable@vger.kernel.org> # 5.10+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20210311072546.678999-1-shinichiro.kawasaki@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 8b9f3fc5a690..c0276b42d9fb 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -318,6 +318,22 @@ int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
 	return 0;
 }
 
+static int blkdev_truncate_zone_range(struct block_device *bdev, fmode_t mode,
+				      const struct blk_zone_range *zrange)
+{
+	loff_t start, end;
+
+	if (zrange->sector + zrange->nr_sectors <= zrange->sector ||
+	    zrange->sector + zrange->nr_sectors > get_capacity(bdev->bd_disk))
+		/* Out of range */
+		return -EINVAL;
+
+	start = zrange->sector << SECTOR_SHIFT;
+	end = ((zrange->sector + zrange->nr_sectors) << SECTOR_SHIFT) - 1;
+
+	return truncate_bdev_range(bdev, mode, start, end);
+}
+
 /*
  * BLKRESETZONE, BLKOPENZONE, BLKCLOSEZONE and BLKFINISHZONE ioctl processing.
  * Called from blkdev_ioctl.
@@ -329,6 +345,7 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
 	struct request_queue *q;
 	struct blk_zone_range zrange;
 	enum req_opf op;
+	int ret;
 
 	if (!argp)
 		return -EINVAL;
@@ -352,6 +369,11 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
 	switch (cmd) {
 	case BLKRESETZONE:
 		op = REQ_OP_ZONE_RESET;
+
+		/* Invalidate the page cache, including dirty pages. */
+		ret = blkdev_truncate_zone_range(bdev, mode, &zrange);
+		if (ret)
+			return ret;
 		break;
 	case BLKOPENZONE:
 		op = REQ_OP_ZONE_OPEN;
@@ -366,8 +388,20 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
 		return -ENOTTY;
 	}
 
-	return blkdev_zone_mgmt(bdev, op, zrange.sector, zrange.nr_sectors,
-				GFP_KERNEL);
+	ret = blkdev_zone_mgmt(bdev, op, zrange.sector, zrange.nr_sectors,
+			       GFP_KERNEL);
+
+	/*
+	 * Invalidate the page cache again for zone reset: writes can only be
+	 * direct for zoned devices so concurrent writes would not add any page
+	 * to the page cache after/during reset. The page cache may be filled
+	 * again due to concurrent reads though and dropping the pages for
+	 * these is fine.
+	 */
+	if (!ret && cmd == BLKRESETZONE)
+		ret = blkdev_truncate_zone_range(bdev, mode, &zrange);
+
+	return ret;
 }
 
 static inline unsigned long *blk_alloc_zone_bitmap(int node,

