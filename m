Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC90227AFD5
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 16:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgI1OQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 10:16:56 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:54089 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726281AbgI1OQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 10:16:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 2164CFAE;
        Mon, 28 Sep 2020 10:16:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 28 Sep 2020 10:16:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8uJG2x
        pf/eHqXIauGMh0WwoOouTnZ0RE4ogSmv0P/+4=; b=YxvrFxBMMaRymh/UVV+1a0
        SYMQ3zy4l0cyJRIF01uh1VWGMVmFGGLF3Ef/JV/QX/3ezO/nPe/cCUcbgdqWeoZm
        l1QdNyz/9562EUH2CXzhvof9rqb+FjIKj3YxqanUKMawyC8zPlpDg2xwGPTitscU
        KuDLA6u5JnneNnJizriFfchFQnXGQI3J2hm3A94Gxm6s1KLa194S8Dr89OqjYxAE
        FcfT6jXQJSbUVb1PJtU5rzCxNwWpxP/gEM1Bx8+6jnhhFc3U3xq3My6Gt4ZJ/qqo
        1GDJax3oD5Koi6FKxIMO5pZxo7rwmlcqXdNDzqXbdINVkMhB1oEgZ9p+DYEUCFfw
        ==
X-ME-Sender: <xms:VPBxX3-GTnimYGkfzTRWB2Q2gw0nR1eMFMYQNMFi-cVQ08GMH83BPw>
    <xme:VPBxXzt6Ty2xgaqWJI4juQlwtDq-2foWXmBjw6n-ZHPWr-T3rQ-kmFoO_6IlZYskD
    ZGoAnEgmtsR0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeigdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:VPBxX1BlbIIy0RZIjKGxLexfhgJGOtapBuXrsbzf-y5LX77Dhiyj1w>
    <xmx:VPBxXzdv0PU_eI4SFPE1zOX3mFaMLT9kEE0LUl1FhgqhOMePVdn8FQ>
    <xmx:VPBxX8OIomKKCcrIPf0EceoNBk0xvsqnh_Z6mYs_eZjI49r0rgNp3w>
    <xmx:VPBxX5rTkopTej7w71kZycp9TMlma6HPKHKlHW6Vx-IcOXbXnq29ZN5TLaw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4C8E53064683;
        Mon, 28 Sep 2020 10:16:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] scsi: sd: sd_zbc: Fix ZBC disk initialization" failed to apply to 5.8-stable tree
To:     damien.lemoal@wdc.com, bp@alien8.de, bp@suse.de, hch@lst.de,
        johannes.thumshirn@wdc.com, martin.petersen@oracle.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Sep 2020 16:17:00 +0200
Message-ID: <16013026203615@kroah.com>
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

From 6c5dee18756b4721ac8518c69b22ee8ac0c9c442 Mon Sep 17 00:00:00 2001
From: Damien Le Moal <damien.lemoal@wdc.com>
Date: Tue, 15 Sep 2020 16:33:47 +0900
Subject: [PATCH] scsi: sd: sd_zbc: Fix ZBC disk initialization

Make sure to call sd_zbc_init_disk() when the sdkp->zoned field is known,
that is, once sd_read_block_characteristics() is executed in
sd_revalidate_disk(), so that host-aware disks also get initialized.  To do
so, move sd_zbc_init_disk() call in sd_zbc_revalidate_zones() and make sure
to execute it for all zoned disks, including for host-aware disks used as
regular disks as these disk zoned model may be changed back to BLK_ZONED_HA
when partitions are deleted.

Link: https://lore.kernel.org/r/20200915073347.832424-3-damien.lemoal@wdc.com
Fixes: 5795eb443060 ("scsi: sd_zbc: emulate ZONE_APPEND commands")
Cc: <stable@vger.kernel.org> # v5.8+
Reported-by: Borislav Petkov <bp@alien8.de>
Tested-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 06286b6aeaec..16503e22691e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3410,10 +3410,6 @@ static int sd_probe(struct device *dev)
 	sdkp->first_scan = 1;
 	sdkp->max_medium_access_timeouts = SD_MAX_MEDIUM_TIMEOUTS;
 
-	error = sd_zbc_init_disk(sdkp);
-	if (error)
-		goto out_free_index;
-
 	sd_revalidate_disk(gd);
 
 	gd->flags = GENHD_FL_EXT_DEVT;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 7251434100e6..a3aad608bc38 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -215,7 +215,6 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
 
 #ifdef CONFIG_BLK_DEV_ZONED
 
-int sd_zbc_init_disk(struct scsi_disk *sdkp);
 void sd_zbc_release_disk(struct scsi_disk *sdkp);
 int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
 int sd_zbc_revalidate_zones(struct scsi_disk *sdkp);
@@ -231,11 +230,6 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 
 #else /* CONFIG_BLK_DEV_ZONED */
 
-static inline int sd_zbc_init_disk(struct scsi_disk *sdkp)
-{
-	return 0;
-}
-
 static inline void sd_zbc_release_disk(struct scsi_disk *sdkp) {}
 
 static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index a739456dea02..cf07b7f93579 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -651,6 +651,28 @@ static void sd_zbc_print_zones(struct scsi_disk *sdkp)
 			  sdkp->zone_blocks);
 }
 
+static int sd_zbc_init_disk(struct scsi_disk *sdkp)
+{
+	sdkp->zones_wp_offset = NULL;
+	spin_lock_init(&sdkp->zones_wp_offset_lock);
+	sdkp->rev_wp_offset = NULL;
+	mutex_init(&sdkp->rev_mutex);
+	INIT_WORK(&sdkp->zone_wp_offset_work, sd_zbc_update_wp_offset_workfn);
+	sdkp->zone_wp_update_buf = kzalloc(SD_BUF_SIZE, GFP_KERNEL);
+	if (!sdkp->zone_wp_update_buf)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void sd_zbc_release_disk(struct scsi_disk *sdkp)
+{
+	kvfree(sdkp->zones_wp_offset);
+	sdkp->zones_wp_offset = NULL;
+	kfree(sdkp->zone_wp_update_buf);
+	sdkp->zone_wp_update_buf = NULL;
+}
+
 static void sd_zbc_revalidate_zones_cb(struct gendisk *disk)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
@@ -667,6 +689,19 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	u32 max_append;
 	int ret = 0;
 
+	/*
+	 * For all zoned disks, initialize zone append emulation data if not
+	 * already done. This is necessary also for host-aware disks used as
+	 * regular disks due to the presence of partitions as these partitions
+	 * may be deleted and the disk zoned model changed back from
+	 * BLK_ZONED_NONE to BLK_ZONED_HA.
+	 */
+	if (sd_is_zoned(sdkp) && !sdkp->zone_wp_update_buf) {
+		ret = sd_zbc_init_disk(sdkp);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * There is nothing to do for regular disks, including host-aware disks
 	 * that have partitions.
@@ -768,28 +803,3 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 
 	return ret;
 }
-
-int sd_zbc_init_disk(struct scsi_disk *sdkp)
-{
-	if (!sd_is_zoned(sdkp))
-		return 0;
-
-	sdkp->zones_wp_offset = NULL;
-	spin_lock_init(&sdkp->zones_wp_offset_lock);
-	sdkp->rev_wp_offset = NULL;
-	mutex_init(&sdkp->rev_mutex);
-	INIT_WORK(&sdkp->zone_wp_offset_work, sd_zbc_update_wp_offset_workfn);
-	sdkp->zone_wp_update_buf = kzalloc(SD_BUF_SIZE, GFP_KERNEL);
-	if (!sdkp->zone_wp_update_buf)
-		return -ENOMEM;
-
-	return 0;
-}
-
-void sd_zbc_release_disk(struct scsi_disk *sdkp)
-{
-	kvfree(sdkp->zones_wp_offset);
-	sdkp->zones_wp_offset = NULL;
-	kfree(sdkp->zone_wp_update_buf);
-	sdkp->zone_wp_update_buf = NULL;
-}

