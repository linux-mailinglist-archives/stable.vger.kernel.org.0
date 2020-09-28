Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E69927AFD1
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 16:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgI1OQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 10:16:44 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:34747 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726281AbgI1OQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 10:16:44 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 11F9DFAE;
        Mon, 28 Sep 2020 10:16:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 28 Sep 2020 10:16:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=UbEg3D
        Yt48mgUZYyKPuaniv3YVqmXKrzOG+I0AQMTWw=; b=LAt6WN6FK1oGY1QkqIrJ74
        sc71NRglcCc4bTGYwuM6H8VNTUGaarR+JJkbucfF9eeGRGo91s+hXWuTgyW/jIWG
        y6RNQGfED9nbgGToZuo/aso0YhYf6whO7dJiUreKZix9yYsaIB84FUiv3S/G8uZS
        FDkB0A+ia0PhqMLYYaaquca5Nftoz3tZryXE8fSXoR+AfwCCTTS+8lyhGGaRZnof
        oeUDs2PcD1hRPNU+pzNj2ZzwNJHsj4uMifjE+9v+yEnI2nkfznzcDFYneXvElNDk
        Jp34ms345iYeywXyV8YSQKSOi40XY1KGQN+0ccICzAcoMNQkPd6q7E8gmDOfgKoQ
        ==
X-ME-Sender: <xms:SfBxX62AUhDKgN0MvtLayOikruhDYs7YNAIti_ldGxeebRxEpBId7Q>
    <xme:SfBxX9FTLgBIk504cNcsFCHJ3AEyYCq_i-VRciBQHVujLamrYIjepLmJlHTe3pFed
    HsKRVvCRciPww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeigdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:SfBxXy7OEy1q59zo2fGFAsqcpypQmvUcC1IPx8gdbnLiVx6HCxuyrQ>
    <xmx:SfBxX72J9zcqNdZx7uIBaCRsqswWmQ6vcStIKFKorrbhc8KC4vrwWg>
    <xmx:SfBxX9E3pVbDCBOwaDKV5OsmW8fe52JFdf0xgg3-pRxu16EjMvrmIw>
    <xmx:SvBxXxhGYrpGnoZWjbxBRnIKAp1duUWHedOaigPHYTBMxVm-X4g9CpIa3sU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 526AB328005A;
        Mon, 28 Sep 2020 10:16:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] scsi: sd: sd_zbc: Fix handling of host-aware ZBC disks" failed to apply to 5.8-stable tree
To:     damien.lemoal@wdc.com, bp@alien8.de, hch@infradead.org, hch@lst.de,
        johannes.thumshirn@wdc.com, martin.petersen@oracle.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Sep 2020 16:16:49 +0200
Message-ID: <1601302609229102@kroah.com>
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

From 27ba3e8ff3ab86449e63d38a8d623053591e65fa Mon Sep 17 00:00:00 2001
From: Damien Le Moal <damien.lemoal@wdc.com>
Date: Tue, 15 Sep 2020 16:33:46 +0900
Subject: [PATCH] scsi: sd: sd_zbc: Fix handling of host-aware ZBC disks

When CONFIG_BLK_DEV_ZONED is disabled, allow using host-aware ZBC disks as
regular disks. In this case, ensure that command completion is correctly
executed by changing sd_zbc_complete() to return good_bytes instead of 0
and causing a hang during device probe (endless retries).

When CONFIG_BLK_DEV_ZONED is enabled and a host-aware disk is detected to
have partitions, it will be used as a regular disk. In this case, make sure
to not do anything in sd_zbc_revalidate_zones() as that triggers warnings.

Since all these different cases result in subtle settings of the disk queue
zoned model, introduce the block layer helper function
blk_queue_set_zoned() to generically implement setting up the effective
zoned model according to the disk type, the presence of partitions on the
disk and CONFIG_BLK_DEV_ZONED configuration.

Link: https://lore.kernel.org/r/20200915073347.832424-2-damien.lemoal@wdc.com
Fixes: b72053072c0b ("block: allow partitions on host aware zone devices")
Cc: <stable@vger.kernel.org>
Reported-by: Borislav Petkov <bp@alien8.de>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 76a7e03bcd6c..34b721a2743a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -801,6 +801,52 @@ bool blk_queue_can_use_dma_map_merging(struct request_queue *q,
 }
 EXPORT_SYMBOL_GPL(blk_queue_can_use_dma_map_merging);
 
+/**
+ * blk_queue_set_zoned - configure a disk queue zoned model.
+ * @disk:	the gendisk of the queue to configure
+ * @model:	the zoned model to set
+ *
+ * Set the zoned model of the request queue of @disk according to @model.
+ * When @model is BLK_ZONED_HM (host managed), this should be called only
+ * if zoned block device support is enabled (CONFIG_BLK_DEV_ZONED option).
+ * If @model specifies BLK_ZONED_HA (host aware), the effective model used
+ * depends on CONFIG_BLK_DEV_ZONED settings and on the existence of partitions
+ * on the disk.
+ */
+void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
+{
+	switch (model) {
+	case BLK_ZONED_HM:
+		/*
+		 * Host managed devices are supported only if
+		 * CONFIG_BLK_DEV_ZONED is enabled.
+		 */
+		WARN_ON_ONCE(!IS_ENABLED(CONFIG_BLK_DEV_ZONED));
+		break;
+	case BLK_ZONED_HA:
+		/*
+		 * Host aware devices can be treated either as regular block
+		 * devices (similar to drive managed devices) or as zoned block
+		 * devices to take advantage of the zone command set, similarly
+		 * to host managed devices. We try the latter if there are no
+		 * partitions and zoned block device support is enabled, else
+		 * we do nothing special as far as the block layer is concerned.
+		 */
+		if (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) ||
+		    disk_has_partitions(disk))
+			model = BLK_ZONED_NONE;
+		break;
+	case BLK_ZONED_NONE:
+	default:
+		if (WARN_ON_ONCE(model != BLK_ZONED_NONE))
+			model = BLK_ZONED_NONE;
+		break;
+	}
+
+	disk->queue->limits.zoned = model;
+}
+EXPORT_SYMBOL_GPL(blk_queue_set_zoned);
+
 static int __init blk_settings_init(void)
 {
 	blk_max_low_pfn = max_low_pfn - 1;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 95018e650f2d..06286b6aeaec 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2964,26 +2964,32 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 
 	if (sdkp->device->type == TYPE_ZBC) {
 		/* Host-managed */
-		q->limits.zoned = BLK_ZONED_HM;
+		blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HM);
 	} else {
 		sdkp->zoned = (buffer[8] >> 4) & 3;
-		if (sdkp->zoned == 1 && !disk_has_partitions(sdkp->disk)) {
+		if (sdkp->zoned == 1) {
 			/* Host-aware */
-			q->limits.zoned = BLK_ZONED_HA;
+			blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HA);
 		} else {
-			/*
-			 * Treat drive-managed devices and host-aware devices
-			 * with partitions as regular block devices.
-			 */
-			q->limits.zoned = BLK_ZONED_NONE;
-			if (sdkp->zoned == 2 && sdkp->first_scan)
-				sd_printk(KERN_NOTICE, sdkp,
-					  "Drive-managed SMR disk\n");
+			/* Regular disk or drive managed disk */
+			blk_queue_set_zoned(sdkp->disk, BLK_ZONED_NONE);
 		}
 	}
-	if (blk_queue_is_zoned(q) && sdkp->first_scan)
+
+	if (!sdkp->first_scan)
+		goto out;
+
+	if (blk_queue_is_zoned(q)) {
 		sd_printk(KERN_NOTICE, sdkp, "Host-%s zoned block device\n",
 		      q->limits.zoned == BLK_ZONED_HM ? "managed" : "aware");
+	} else {
+		if (sdkp->zoned == 1)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Host-aware SMR disk used as regular disk\n");
+		else if (sdkp->zoned == 2)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Drive-managed SMR disk\n");
+	}
 
  out:
 	kfree(buffer);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 4933e7daf17d..7251434100e6 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -259,7 +259,7 @@ static inline blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
 static inline unsigned int sd_zbc_complete(struct scsi_cmnd *cmd,
 			unsigned int good_bytes, struct scsi_sense_hdr *sshdr)
 {
-	return 0;
+	return good_bytes;
 }
 
 static inline blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd,
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 0e94ff056bff..a739456dea02 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -667,7 +667,11 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	u32 max_append;
 	int ret = 0;
 
-	if (!sd_is_zoned(sdkp))
+	/*
+	 * There is nothing to do for regular disks, including host-aware disks
+	 * that have partitions.
+	 */
+	if (!blk_queue_is_zoned(q))
 		return 0;
 
 	/*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bb5636cc17b9..868e11face00 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -352,6 +352,8 @@ struct queue_limits {
 typedef int (*report_zones_cb)(struct blk_zone *zone, unsigned int idx,
 			       void *data);
 
+void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model);
+
 #ifdef CONFIG_BLK_DEV_ZONED
 
 #define BLK_ALL_ZONES  ((unsigned int)-1)

