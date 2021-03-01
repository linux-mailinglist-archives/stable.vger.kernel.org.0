Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADC0327FD6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235676AbhCANqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:46:10 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:38287 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235843AbhCANqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:46:08 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id B83DD1942150;
        Mon,  1 Mar 2021 08:45:14 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 01 Mar 2021 08:45:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=DGisRS
        hA29TIVmJpMQ3GcNnCg9+7LYrRw6Yw+VLEi9A=; b=H4oa5UsD6CzEhKDRKjDPHn
        DtgjGJtl4SJFP1BwzjMpXBwTh1zfJWZoZr5uHrESAzB2mbjzNk4Idv9XVkzxHZjJ
        rFGobLi2tN5m7e8yTw7U8IJ+CePZVHN9iTDZWiW9e65FMNF10GEvOeEijuZaNy+C
        UTwhweOTqEt+WdK8eYBGbbmeJo/4D/Gyb3+dhrxRphLWAuUgKrf1CamPyBec3Cy5
        cZzPJVRPqFCiIAmvjJ6QAB3AGwnEepIGWTNddMOIi7JTo7YoYbFRaB3mCAg+1ea+
        WCz7fhBGefc6Cj0/pL9JWON3esl3QG1dC+DXHDeNjyYVtt9cL/4xz8+Pd7wK80xQ
        ==
X-ME-Sender: <xms:6u88YMd5BqeuQKy1e7RVqoHa2gxBN7iXncTTBMxuYLj88nbjC3LlKw>
    <xme:6u88YFqbcHakUCzBBJbOmKxa91o4Jg8OTSYF3TCMJS5Zf-Io6XYj_Tk1Z1ueh5TQ8
    Ry38rfXg-s1rA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:6u88YK4J-xA5vhUpWotnLWwC0alGleaMGdP3j1C0Ek17VL_W1E-I_A>
    <xmx:6u88YLr2x35vHZ8NA9aAvETcQ_WBcereJp-Z6dFkP7jYJNrNxsUkjw>
    <xmx:6u88YMikqMz2HAO2nj1zcYxUDJYMyhAVhZidTl2ME0_ZabvIZEFy4A>
    <xmx:6u88YNEi3qIZUZSPmFf-eYgQ_k7S-SrcmpCqq1NNdIeOKuO5aX58vA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id F03A31080068;
        Mon,  1 Mar 2021 08:45:13 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm table: fix zoned iterate_devices based device capability" failed to apply to 5.4-stable tree
To:     jefflexu@linux.alibaba.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:45:02 +0100
Message-ID: <161460630241206@kroah.com>
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

From 24f6b6036c9eec21191646930ad42808e6180510 Mon Sep 17 00:00:00 2001
From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Mon, 8 Feb 2021 22:46:38 -0500
Subject: [PATCH] dm table: fix zoned iterate_devices based device capability
 checks

Fix dm_table_supports_zoned_model() and invert logic of both
iterate_devices_callout_fn so that all devices' zoned capabilities are
properly checked.

Add one more parameter to dm_table_any_dev_attr(), which is actually
used as the @data parameter of iterate_devices_callout_fn, so that
dm_table_matches_zone_sectors() can be replaced by
dm_table_any_dev_attr().

Fixes: dd88d313bef02 ("dm table: add zoned block devices validation")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 71f7ec508cf7..77086db8b920 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1316,10 +1316,10 @@ struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector)
  * should use the iteration structure like dm_table_supports_nowait() or
  * dm_table_supports_discards(). Or introduce dm_table_all_devs_attr() that
  * uses an @anti_func that handle semantics of counter examples, e.g. not
- * capable of something. So: return !dm_table_any_dev_attr(t, anti_func);
+ * capable of something. So: return !dm_table_any_dev_attr(t, anti_func, data);
  */
 static bool dm_table_any_dev_attr(struct dm_table *t,
-				  iterate_devices_callout_fn func)
+				  iterate_devices_callout_fn func, void *data)
 {
 	struct dm_target *ti;
 	unsigned int i;
@@ -1328,7 +1328,7 @@ static bool dm_table_any_dev_attr(struct dm_table *t,
 		ti = dm_table_get_target(t, i);
 
 		if (ti->type->iterate_devices &&
-		    ti->type->iterate_devices(ti, func, NULL))
+		    ti->type->iterate_devices(ti, func, data))
 			return true;
         }
 
@@ -1371,13 +1371,13 @@ bool dm_table_has_no_data_devices(struct dm_table *table)
 	return true;
 }
 
-static int device_is_zoned_model(struct dm_target *ti, struct dm_dev *dev,
-				 sector_t start, sector_t len, void *data)
+static int device_not_zoned_model(struct dm_target *ti, struct dm_dev *dev,
+				  sector_t start, sector_t len, void *data)
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 	enum blk_zoned_model *zoned_model = data;
 
-	return q && blk_queue_zoned_model(q) == *zoned_model;
+	return !q || blk_queue_zoned_model(q) != *zoned_model;
 }
 
 static bool dm_table_supports_zoned_model(struct dm_table *t,
@@ -1394,37 +1394,20 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
 			return false;
 
 		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, device_is_zoned_model, &zoned_model))
+		    ti->type->iterate_devices(ti, device_not_zoned_model, &zoned_model))
 			return false;
 	}
 
 	return true;
 }
 
-static int device_matches_zone_sectors(struct dm_target *ti, struct dm_dev *dev,
-				       sector_t start, sector_t len, void *data)
+static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *dev,
+					   sector_t start, sector_t len, void *data)
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 	unsigned int *zone_sectors = data;
 
-	return q && blk_queue_zone_sectors(q) == *zone_sectors;
-}
-
-static bool dm_table_matches_zone_sectors(struct dm_table *t,
-					  unsigned int zone_sectors)
-{
-	struct dm_target *ti;
-	unsigned i;
-
-	for (i = 0; i < dm_table_get_num_targets(t); i++) {
-		ti = dm_table_get_target(t, i);
-
-		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, device_matches_zone_sectors, &zone_sectors))
-			return false;
-	}
-
-	return true;
+	return !q || blk_queue_zone_sectors(q) != *zone_sectors;
 }
 
 static int validate_hardware_zoned_model(struct dm_table *table,
@@ -1444,7 +1427,7 @@ static int validate_hardware_zoned_model(struct dm_table *table,
 	if (!zone_sectors || !is_power_of_2(zone_sectors))
 		return -EINVAL;
 
-	if (!dm_table_matches_zone_sectors(table, zone_sectors)) {
+	if (dm_table_any_dev_attr(table, device_not_matches_zone_sectors, &zone_sectors)) {
 		DMERR("%s: zone sectors is not consistent across all devices",
 		      dm_device_name(table->md));
 		return -EINVAL;
@@ -1830,11 +1813,11 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	else
 		blk_queue_flag_clear(QUEUE_FLAG_DAX, q);
 
-	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled))
+	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled, NULL))
 		dax_write_cache(t->md->dax_dev, true);
 
 	/* Ensure that all underlying devices are non-rotational. */
-	if (dm_table_any_dev_attr(t, device_is_rotational))
+	if (dm_table_any_dev_attr(t, device_is_rotational, NULL))
 		blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
 	else
 		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
@@ -1853,7 +1836,7 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	 * them as well.  Only targets that support iterate_devices are considered:
 	 * don't want error, zero, etc to require stable pages.
 	 */
-	if (dm_table_any_dev_attr(t, device_requires_stable_pages))
+	if (dm_table_any_dev_attr(t, device_requires_stable_pages, NULL))
 		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, q);
 	else
 		blk_queue_flag_clear(QUEUE_FLAG_STABLE_WRITES, q);
@@ -1864,7 +1847,8 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	 * Clear QUEUE_FLAG_ADD_RANDOM if any underlying device does not
 	 * have it set.
 	 */
-	if (blk_queue_add_random(q) && dm_table_any_dev_attr(t, device_is_not_random))
+	if (blk_queue_add_random(q) &&
+	    dm_table_any_dev_attr(t, device_is_not_random, NULL))
 		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
 
 	/*

