Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4226D2A6347
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 12:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgKDL1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 06:27:54 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:59011 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729136AbgKDL1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 06:27:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604489273; x=1636025273;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KbYxxd7j8soPn+UVsXcTNmhXC4zje9NRo4NJThP5VBI=;
  b=f27IB45wYC8Rjl6d7KBlkr49B8nFHcxrOgPqzQ8ebp4soxJOJoYID3b8
   KjJchdpP/i15WbbnnD3ir8B41UUr/RdqVxP0fRBtICUqCJnwLRfNWsP3n
   sbtGgvVd7ksU8c3o0l1a41iak0CxsqAWIMMcrmdRDQJvEi0b2jfMMQ4ZG
   ZNBVOn1ytrcHircOd936GKL4IRs53ZyUzrZs0l495ErTYWTCcl2eqw5mm
   XgEXEsdBQ0QJn+0sIxd80GA5onm9Vpp7XX2F5Z6HITB0+uape2bbqVkMQ
   +NCoQ9PseJiDOPhX6PBb71FyKMFg0rx4UDGiv0XS4wOjs+rKlM71VO3hd
   Q==;
IronPort-SDR: gp/6Q1L5+IIZ0loRvPaLY0FlKbdqXbQBad7PNbDGzHqXZ5XrcJ5q7Z0HYSR82nF3GuTqDq3W/H
 WRxbO37zrDfUDPcSkZmO6OU4/C4P35b8RN9hvPe5hVOF82Rts91zzU1SUc7NYFANBCA4kcEyNF
 /fbLgQyMWHlczdwuBvpdZgs/jpnx2XdjrJehJvNcG4RPxwnz1taCn1DpsY/Y4Ms1vG/qLWyEm+
 FtesxErkabFQjauIndMf6IWRWSnT+e04/DSFQLPGnVvADGfyKAPSyTmG7DdbM3z3+lQCx3d8Ea
 McQ=
X-IronPort-AV: E=Sophos;i="5.77,450,1596470400"; 
   d="scan'208";a="151681632"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Nov 2020 19:27:52 +0800
IronPort-SDR: qE7LHQQnUVWcSPzuTprM3w4KksH1oquo2fkCUahC7Z7PFWwydyrxmxib5aByfpfI98vLEC6cAQ
 l5Ko330nJGsY3D+q18KlncUk4mboYnPJiZWq8apB5juJjl63qUU0qmn7a8CNGEJbDzHjMJT6fM
 YdGhJTLfC7zECrhxO21bmV0+rBBFc6eftovVDflmBFgIE7OwuNVB4R3lKnmyBoSciFdiPViymp
 pMMHnzD9hhK8bB8frhAqvQ5DR6iveQD037BRYcQqhGpa0xsKaOvosZ7gtQ1ZwXCPjHgVp4gC7e
 XPyBlTuWE6ylO0b3l6IpS0Wb
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 03:14:01 -0800
IronPort-SDR: hBnVBcRPWcYHtMViRes8e4hE2WInAU+zG7US4xSfGhUDkXmB9GyJeq1M5KOG63aVEpqBWo6KeD
 vCZXq9Yqhr7amoznrNbiQjtogp0ygKEt08Ok4Qo7Tw16xSaMIdLRvxT65BBSGKcE4zRrWDvSIZ
 YU6cy0dEy4mHcqOEZE1AsYsAiY0qpi1at5y/PEXNFWFJ1hTGvoLh8RheTKIlkF5bnwnJQxRJ0D
 gGutjqO/K20jmH1MWg9GMTqWvK2xMDIX+S66P9Qn71NvsjiCo/fbgvAvr2tLWWbZKc7AWz7lGy
 Do8=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Nov 2020 03:27:52 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 3/3] null_blk: Fix locking in zoned mode
Date:   Wed,  4 Nov 2020 20:27:47 +0900
Message-Id: <20201104112747.182740-4-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104112747.182740-1-damien.lemoal@wdc.com>
References: <20201104095141.GA1673068@kroah.com>
 <20201104112747.182740-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit aa1c09cb65e2ed17cb8e652bc7ec84e0af1229eb upstream.

When the zoned mode is enabled in null_blk, Serializing read, write
and zone management operations for each zone is necessary to protect
device level information for managing zone resources (zone open and
closed counters) as well as each zone condition and write pointer
position. Commit 35bc10b2eafb ("null_blk: synchronization fix for
zoned device") introduced a spinlock to implement this serialization.
However, when memory backing is also enabled, GFP_NOIO memory
allocations are executed under the spinlock, resulting in might_sleep()
warnings. Furthermore, the zone_lock spinlock is locked/unlocked using
spin_lock_irq/spin_unlock_irq, similarly to the memory backing code with
the nullb->lock spinlock. This nested use of irq locks wrecks the irq
enabled/disabled state.

Fix all this by introducing a bitmap for per-zone lock, with locking
implemented using wait_on_bit_lock_io() and clear_and_wake_up_bit().
This locking mechanism allows keeping a zone locked while executing
null_process_cmd(), serializing all operations to the zone while
allowing to sleep during memory backing allocation with GFP_NOIO.
Device level zone resource management information is protected using
a spinlock which is not held while executing null_process_cmd();

Fixes: 35bc10b2eafb ("null_blk: synchronization fix for zoned device")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/null_blk.h       |   2 +-
 drivers/block/null_blk_zoned.c | 133 ++++++++++++++++++++++++---------
 2 files changed, 98 insertions(+), 37 deletions(-)

diff --git a/drivers/block/null_blk.h b/drivers/block/null_blk.h
index 28099be50395..206309ecc7e4 100644
--- a/drivers/block/null_blk.h
+++ b/drivers/block/null_blk.h
@@ -44,7 +44,7 @@ struct nullb_device {
 	unsigned int nr_zones;
 	struct blk_zone *zones;
 	sector_t zone_size_sects;
-	spinlock_t zone_lock;
+	unsigned long *zone_locks;
 
 	unsigned long size; /* device size in MB */
 	unsigned long completion_nsec; /* time in ns to complete a request */
diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index 0342696db0ce..495713d6c989 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/vmalloc.h>
+#include <linux/bitmap.h>
 #include "null_blk.h"
 
 #define CREATE_TRACE_POINTS
@@ -45,7 +46,12 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 	if (!dev->zones)
 		return -ENOMEM;
 
-	spin_lock_init(&dev->zone_lock);
+	dev->zone_locks = bitmap_zalloc(dev->nr_zones, GFP_KERNEL);
+	if (!dev->zone_locks) {
+		kvfree(dev->zones);
+		return -ENOMEM;
+	}
+
 	if (dev->zone_nr_conv >= dev->nr_zones) {
 		dev->zone_nr_conv = dev->nr_zones - 1;
 		pr_info("changed the number of conventional zones to %u",
@@ -106,15 +112,26 @@ int null_register_zoned_dev(struct nullb *nullb)
 
 void null_free_zoned_dev(struct nullb_device *dev)
 {
+	bitmap_free(dev->zone_locks);
 	kvfree(dev->zones);
 }
 
+static inline void null_lock_zone(struct nullb_device *dev, unsigned int zno)
+{
+	wait_on_bit_lock_io(dev->zone_locks, zno, TASK_UNINTERRUPTIBLE);
+}
+
+static inline void null_unlock_zone(struct nullb_device *dev, unsigned int zno)
+{
+	clear_and_wake_up_bit(zno, dev->zone_locks);
+}
+
 int null_report_zones(struct gendisk *disk, sector_t sector,
 		unsigned int nr_zones, report_zones_cb cb, void *data)
 {
 	struct nullb *nullb = disk->private_data;
 	struct nullb_device *dev = nullb->dev;
-	unsigned int first_zone, i;
+	unsigned int first_zone, i, zno;
 	struct blk_zone zone;
 	int error;
 
@@ -125,17 +142,17 @@ int null_report_zones(struct gendisk *disk, sector_t sector,
 	nr_zones = min(nr_zones, dev->nr_zones - first_zone);
 	trace_nullb_report_zones(nullb, nr_zones);
 
-	for (i = 0; i < nr_zones; i++) {
+	zno = first_zone;
+	for (i = 0; i < nr_zones; i++, zno++) {
 		/*
 		 * Stacked DM target drivers will remap the zone information by
 		 * modifying the zone information passed to the report callback.
 		 * So use a local copy to avoid corruption of the device zone
 		 * array.
 		 */
-		spin_lock_irq(&dev->zone_lock);
-		memcpy(&zone, &dev->zones[first_zone + i],
-		       sizeof(struct blk_zone));
-		spin_unlock_irq(&dev->zone_lock);
+		null_lock_zone(dev, zno);
+		memcpy(&zone, &dev->zones[zno], sizeof(struct blk_zone));
+		null_unlock_zone(dev, zno);
 
 		error = cb(&zone, i, data);
 		if (error)
@@ -145,6 +162,10 @@ int null_report_zones(struct gendisk *disk, sector_t sector,
 	return nr_zones;
 }
 
+/*
+ * This is called in the case of memory backing from null_process_cmd()
+ * with the target zone already locked.
+ */
 size_t null_zone_valid_read_len(struct nullb *nullb,
 				sector_t sector, unsigned int len)
 {
@@ -176,10 +197,13 @@ static blk_status_t null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
 		return null_process_cmd(cmd, REQ_OP_WRITE, sector, nr_sectors);
 
+	null_lock_zone(dev, zno);
+
 	switch (zone->cond) {
 	case BLK_ZONE_COND_FULL:
 		/* Cannot write to a full zone */
-		return BLK_STS_IOERR;
+		ret = BLK_STS_IOERR;
+		break;
 	case BLK_ZONE_COND_EMPTY:
 	case BLK_ZONE_COND_IMP_OPEN:
 	case BLK_ZONE_COND_EXP_OPEN:
@@ -197,68 +221,96 @@ static blk_status_t null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 			else
 				cmd->rq->__sector = sector;
 		} else if (sector != zone->wp) {
-			return BLK_STS_IOERR;
+			ret = BLK_STS_IOERR;
+			break;
 		}
 
-		if (zone->wp + nr_sectors > zone->start + zone->capacity)
-			return BLK_STS_IOERR;
+		if (zone->wp + nr_sectors > zone->start + zone->capacity) {
+			ret = BLK_STS_IOERR;
+			break;
+		}
 
 		if (zone->cond != BLK_ZONE_COND_EXP_OPEN)
 			zone->cond = BLK_ZONE_COND_IMP_OPEN;
 
 		ret = null_process_cmd(cmd, REQ_OP_WRITE, sector, nr_sectors);
 		if (ret != BLK_STS_OK)
-			return ret;
+			break;
 
 		zone->wp += nr_sectors;
 		if (zone->wp == zone->start + zone->capacity)
 			zone->cond = BLK_ZONE_COND_FULL;
-		return BLK_STS_OK;
+		ret = BLK_STS_OK;
+		break;
 	default:
 		/* Invalid zone condition */
-		return BLK_STS_IOERR;
+		ret = BLK_STS_IOERR;
 	}
+
+	null_unlock_zone(dev, zno);
+
+	return ret;
 }
 
 static blk_status_t null_zone_mgmt(struct nullb_cmd *cmd, enum req_opf op,
 				   sector_t sector)
 {
 	struct nullb_device *dev = cmd->nq->dev;
-	unsigned int zone_no = null_zone_no(dev, sector);
-	struct blk_zone *zone = &dev->zones[zone_no];
+	unsigned int zone_no;
+	struct blk_zone *zone;
+	blk_status_t ret = BLK_STS_OK;
 	size_t i;
 
-	switch (op) {
-	case REQ_OP_ZONE_RESET_ALL:
+	if (op == REQ_OP_ZONE_RESET_ALL) {
 		for (i = dev->zone_nr_conv; i < dev->nr_zones; i++) {
+			null_lock_zone(dev, i);
 			zone = &dev->zones[i];
 			if (zone->cond != BLK_ZONE_COND_EMPTY) {
 				zone->cond = BLK_ZONE_COND_EMPTY;
 				zone->wp = zone->start;
 				trace_nullb_zone_op(cmd, i, zone->cond);
 			}
+			null_unlock_zone(dev, i);
 		}
 		return BLK_STS_OK;
+	}
+
+	zone_no = null_zone_no(dev, sector);
+	zone = &dev->zones[zone_no];
+
+	null_lock_zone(dev, zone_no);
+
+	switch (op) {
 	case REQ_OP_ZONE_RESET:
-		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
-			return BLK_STS_IOERR;
+		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL) {
+			ret = BLK_STS_IOERR;
+			break;
+		}
 
 		zone->cond = BLK_ZONE_COND_EMPTY;
 		zone->wp = zone->start;
 		break;
 	case REQ_OP_ZONE_OPEN:
-		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
-			return BLK_STS_IOERR;
-		if (zone->cond == BLK_ZONE_COND_FULL)
-			return BLK_STS_IOERR;
+		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL) {
+			ret = BLK_STS_IOERR;
+			break;
+		}
+		if (zone->cond == BLK_ZONE_COND_FULL) {
+			ret = BLK_STS_IOERR;
+			break;
+		}
 
 		zone->cond = BLK_ZONE_COND_EXP_OPEN;
 		break;
 	case REQ_OP_ZONE_CLOSE:
-		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
-			return BLK_STS_IOERR;
-		if (zone->cond == BLK_ZONE_COND_FULL)
-			return BLK_STS_IOERR;
+		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL) {
+			ret = BLK_STS_IOERR;
+			break;
+		}
+		if (zone->cond == BLK_ZONE_COND_FULL) {
+			ret = BLK_STS_IOERR;
+			break;
+		}
 
 		if (zone->wp == zone->start)
 			zone->cond = BLK_ZONE_COND_EMPTY;
@@ -266,27 +318,35 @@ static blk_status_t null_zone_mgmt(struct nullb_cmd *cmd, enum req_opf op,
 			zone->cond = BLK_ZONE_COND_CLOSED;
 		break;
 	case REQ_OP_ZONE_FINISH:
-		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
-			return BLK_STS_IOERR;
+		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL) {
+			ret = BLK_STS_IOERR;
+			break;
+		}
 
 		zone->cond = BLK_ZONE_COND_FULL;
 		zone->wp = zone->start + zone->len;
+		ret = BLK_STS_OK;
 		break;
 	default:
-		return BLK_STS_NOTSUPP;
+		ret = BLK_STS_NOTSUPP;
+		break;
 	}
 
-	trace_nullb_zone_op(cmd, zone_no, zone->cond);
-	return BLK_STS_OK;
+	if (ret == BLK_STS_OK)
+		trace_nullb_zone_op(cmd, zone_no, zone->cond);
+
+	null_unlock_zone(dev, zone_no);
+
+	return ret;
 }
 
 blk_status_t null_process_zoned_cmd(struct nullb_cmd *cmd, enum req_opf op,
 				    sector_t sector, sector_t nr_sectors)
 {
-	blk_status_t sts;
 	struct nullb_device *dev = cmd->nq->dev;
+	unsigned int zno = null_zone_no(dev, sector);
+	blk_status_t sts;
 
-	spin_lock_irq(&dev->zone_lock);
 	switch (op) {
 	case REQ_OP_WRITE:
 		sts = null_zone_write(cmd, sector, nr_sectors, false);
@@ -302,9 +362,10 @@ blk_status_t null_process_zoned_cmd(struct nullb_cmd *cmd, enum req_opf op,
 		sts = null_zone_mgmt(cmd, op, sector);
 		break;
 	default:
+		null_lock_zone(dev, zno);
 		sts = null_process_cmd(cmd, op, sector, nr_sectors);
+		null_unlock_zone(dev, zno);
 	}
-	spin_unlock_irq(&dev->zone_lock);
 
 	return sts;
 }
-- 
2.26.2

