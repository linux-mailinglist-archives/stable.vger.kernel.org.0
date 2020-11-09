Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779CA2AB4C4
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 11:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgKIKYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 05:24:39 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:60421 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726176AbgKIKYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 05:24:39 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 56820116E;
        Mon,  9 Nov 2020 05:24:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 09 Nov 2020 05:24:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Edn5pN
        SXr/dru602f3zkCMU5v2L8bukCcUyLHUm5ogA=; b=b26i+MyFKOXnPgnYO2ikOL
        v6tAqi37SmfjvalBMzKK4PPTWVJC6D+J0hnQBg7nJ5fXg9zkX6jGd9op4ag1fzsO
        /X0wp784qBVMGw0HnecqyoroOvM2dZ6OEiA1EhoLQCyn/E+ZKomDhbxBjxLLTN8Z
        kfY6heu6Aah8Ww+F0zPvlJen9ngN7xb4brSFAf+B/QBaLihAe7nfx620RqiXoGWo
        vslxH7xWhjSGUaaOYp1EGQfLkt4WKoL53EsSc4MeZyT66UaQmOEm5sr/mQxh0LQ0
        NEaKXSQrO9RLoZl5A/o1tmpDkd8UfD2wWX1ApvLyeM3flo/kAViwS0OXEk9VGtiw
        ==
X-ME-Sender: <xms:5RipX33SsZQ4RBrBKG_4vuA96M6dqqtlBBBDbD_ci6oQZF3JfDxq6w>
    <xme:5RipX2EJBczO4UwJpcQRiqo8TyBlXWF7jNFMxYnBVizBvLQ8sjR7dEYoXWyArnorK
    l440acxIcrh7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduhedgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:5RipX358Xh8HX8FrPviqLGG1jtnK_HSzmtyxRGERJyKwFwmtCAtn5Q>
    <xmx:5RipX82hH4xmSNH-OrLgGS_QaIfF_yFhfe4nswbF8Swcgi52s46Qfw>
    <xmx:5RipX6HWFUBTDwnrQ7Z_nmtA3WV9YwSYBZsh1OE_V9ME0_lmApQqLg>
    <xmx:5RipX_S2LpR9CR8mKmQNkI4mJJ04c9lFr3JP4wiif1Dg2O1fIIwb9GDXyM0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0ED4B328005D;
        Mon,  9 Nov 2020 05:24:36 -0500 (EST)
Subject: FAILED: patch "[PATCH] null_blk: Fix scheduling in atomic with zoned mode" failed to apply to 5.9-stable tree
To:     damien.lemoal@wdc.com, axboe@kernel.dk, hch@lst.de, lkp@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Nov 2020 11:25:37 +0100
Message-ID: <160491753798199@kroah.com>
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

From e1777d099728a76a8f8090f89649aac961e7e530 Mon Sep 17 00:00:00 2001
From: Damien Le Moal <damien.lemoal@wdc.com>
Date: Fri, 6 Nov 2020 20:01:41 +0900
Subject: [PATCH] null_blk: Fix scheduling in atomic with zoned mode

Commit aa1c09cb65e2 ("null_blk: Fix locking in zoned mode") changed
zone locking to using the potentially sleeping wait_on_bit_io()
function. This is acceptable when memory backing is enabled as the
device queue is in that case marked as blocking, but this triggers a
scheduling while in atomic context with memory backing disabled.

Fix this by relying solely on the device zone spinlock for zone
information protection without temporarily releasing this lock around
null_process_cmd() execution in null_zone_write(). This is OK to do
since when memory backing is disabled, command processing does not
block and the memory backing lock nullb->lock is unused. This solution
avoids the overhead of having to mark a zoned null_blk device queue as
blocking when memory backing is unused.

This patch also adds comments to the zone locking code to explain the
unusual locking scheme.

Fixes: aa1c09cb65e2 ("null_blk: Fix locking in zoned mode")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/block/null_blk.h b/drivers/block/null_blk.h
index cfd00ad40355..c24d9b5ad81a 100644
--- a/drivers/block/null_blk.h
+++ b/drivers/block/null_blk.h
@@ -47,7 +47,7 @@ struct nullb_device {
 	unsigned int nr_zones_closed;
 	struct blk_zone *zones;
 	sector_t zone_size_sects;
-	spinlock_t zone_dev_lock;
+	spinlock_t zone_lock;
 	unsigned long *zone_locks;
 
 	unsigned long size; /* device size in MB */
diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index 8775acbb4f8f..beb34b4f76b0 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -46,11 +46,20 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 	if (!dev->zones)
 		return -ENOMEM;
 
-	spin_lock_init(&dev->zone_dev_lock);
-	dev->zone_locks = bitmap_zalloc(dev->nr_zones, GFP_KERNEL);
-	if (!dev->zone_locks) {
-		kvfree(dev->zones);
-		return -ENOMEM;
+	/*
+	 * With memory backing, the zone_lock spinlock needs to be temporarily
+	 * released to avoid scheduling in atomic context. To guarantee zone
+	 * information protection, use a bitmap to lock zones with
+	 * wait_on_bit_lock_io(). Sleeping on the lock is OK as memory backing
+	 * implies that the queue is marked with BLK_MQ_F_BLOCKING.
+	 */
+	spin_lock_init(&dev->zone_lock);
+	if (dev->memory_backed) {
+		dev->zone_locks = bitmap_zalloc(dev->nr_zones, GFP_KERNEL);
+		if (!dev->zone_locks) {
+			kvfree(dev->zones);
+			return -ENOMEM;
+		}
 	}
 
 	if (dev->zone_nr_conv >= dev->nr_zones) {
@@ -137,12 +146,17 @@ void null_free_zoned_dev(struct nullb_device *dev)
 
 static inline void null_lock_zone(struct nullb_device *dev, unsigned int zno)
 {
-	wait_on_bit_lock_io(dev->zone_locks, zno, TASK_UNINTERRUPTIBLE);
+	if (dev->memory_backed)
+		wait_on_bit_lock_io(dev->zone_locks, zno, TASK_UNINTERRUPTIBLE);
+	spin_lock_irq(&dev->zone_lock);
 }
 
 static inline void null_unlock_zone(struct nullb_device *dev, unsigned int zno)
 {
-	clear_and_wake_up_bit(zno, dev->zone_locks);
+	spin_unlock_irq(&dev->zone_lock);
+
+	if (dev->memory_backed)
+		clear_and_wake_up_bit(zno, dev->zone_locks);
 }
 
 int null_report_zones(struct gendisk *disk, sector_t sector,
@@ -322,7 +336,6 @@ static blk_status_t null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 		return null_process_cmd(cmd, REQ_OP_WRITE, sector, nr_sectors);
 
 	null_lock_zone(dev, zno);
-	spin_lock(&dev->zone_dev_lock);
 
 	switch (zone->cond) {
 	case BLK_ZONE_COND_FULL:
@@ -375,9 +388,17 @@ static blk_status_t null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 	if (zone->cond != BLK_ZONE_COND_EXP_OPEN)
 		zone->cond = BLK_ZONE_COND_IMP_OPEN;
 
-	spin_unlock(&dev->zone_dev_lock);
+	/*
+	 * Memory backing allocation may sleep: release the zone_lock spinlock
+	 * to avoid scheduling in atomic context. Zone operation atomicity is
+	 * still guaranteed through the zone_locks bitmap.
+	 */
+	if (dev->memory_backed)
+		spin_unlock_irq(&dev->zone_lock);
 	ret = null_process_cmd(cmd, REQ_OP_WRITE, sector, nr_sectors);
-	spin_lock(&dev->zone_dev_lock);
+	if (dev->memory_backed)
+		spin_lock_irq(&dev->zone_lock);
+
 	if (ret != BLK_STS_OK)
 		goto unlock;
 
@@ -392,7 +413,6 @@ static blk_status_t null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 	ret = BLK_STS_OK;
 
 unlock:
-	spin_unlock(&dev->zone_dev_lock);
 	null_unlock_zone(dev, zno);
 
 	return ret;
@@ -516,9 +536,7 @@ static blk_status_t null_zone_mgmt(struct nullb_cmd *cmd, enum req_opf op,
 			null_lock_zone(dev, i);
 			zone = &dev->zones[i];
 			if (zone->cond != BLK_ZONE_COND_EMPTY) {
-				spin_lock(&dev->zone_dev_lock);
 				null_reset_zone(dev, zone);
-				spin_unlock(&dev->zone_dev_lock);
 				trace_nullb_zone_op(cmd, i, zone->cond);
 			}
 			null_unlock_zone(dev, i);
@@ -530,7 +548,6 @@ static blk_status_t null_zone_mgmt(struct nullb_cmd *cmd, enum req_opf op,
 	zone = &dev->zones[zone_no];
 
 	null_lock_zone(dev, zone_no);
-	spin_lock(&dev->zone_dev_lock);
 
 	switch (op) {
 	case REQ_OP_ZONE_RESET:
@@ -550,8 +567,6 @@ static blk_status_t null_zone_mgmt(struct nullb_cmd *cmd, enum req_opf op,
 		break;
 	}
 
-	spin_unlock(&dev->zone_dev_lock);
-
 	if (ret == BLK_STS_OK)
 		trace_nullb_zone_op(cmd, zone_no, zone->cond);
 

