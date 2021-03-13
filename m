Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C31339E33
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 14:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbhCMNZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 08:25:31 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:46085 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232999AbhCMNZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 08:25:17 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8D6851941DB0;
        Sat, 13 Mar 2021 08:25:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 13 Mar 2021 08:25:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Bmc4H5
        wlTDQePE8SGOk3w1xu7Qw2c9DftcpHVMXe9Qw=; b=gTqU/v5oGMGI3NlSpGS0lI
        cRYyATJt9C9cg6bbu6ZNs9CLwmDEfN9QuUBPYFXW6CIuUkv/8JTxc6opTCksDWPG
        GuXRiAiibPbwUiDwy0QipFfCa/6EIfOG8L1sKyVPuHgKVG3DxWt3lWxQCSw+xYVa
        gXoGtOia2WK5eKQhesi8eocSXsY4PVI0xTIf2Fmf9rXjiBnedF+HnbUEOt/IqJfd
        DLCtHVFjN0/5eQcf52gN21cfVtY58PZt9cVRFRnU7f2H83LnREzU85aRxx/L/3GP
        CeB1tIGfTFgCqzGa1+wS9nvvew4eszGKW4wn0Eqn4uNuuHU1thqUA10p1lfb1aBg
        ==
X-ME-Sender: <xms:PL1MYLkm3uOhCIxrQkc0EQsC08bEUT7wt1hZLS0T9mPyNWiIHWtVCQ>
    <xme:PL1MYO3O4gT04w1_kNTZLjVtZHHZhHV4quUbSNoeN5yZmXvwDYaGjsWmSfT62x_dm
    xfBjVP_V-CApQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvgedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:PL1MYBphVxpL-QJD1F1AaEc2U45Aiqnb1ugypVzAtQYP3BN1GIz4tA>
    <xmx:PL1MYDkgTQ0lKkqY4D0L0ITDW7HIcwAlZnRolMZ3zPwkpkJHWYOG8A>
    <xmx:PL1MYJ2ymVPHEbYP6VUMBYwLTmLf2obzh3x6eggRJQiu1qkONdd-HA>
    <xmx:PL1MYHCWO01jCrc_2ymSEqbfiBiWwZUfNNCzB-Dw6CpAspzZQamUvw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D1851080063;
        Sat, 13 Mar 2021 08:25:16 -0500 (EST)
Subject: FAILED: patch "[PATCH] block: Discard page cache of zone reset target range" failed to apply to 4.19-stable tree
To:     shinichiro.kawasaki@wdc.com, axboe@kernel.dk, hch@lst.de,
        johannes.thumshirn@wdc.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Mar 2021 14:25:06 +0100
Message-ID: <1615641906212232@kroah.com>
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

