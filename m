Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDC1327FCD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbhCANpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:45:09 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:48869 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235804AbhCANpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:45:07 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 32EFB1941FB5;
        Mon,  1 Mar 2021 08:44:16 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:44:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/IOK6m
        h+LmErpCZ0egKxtTQyn+6lzwoLr6klrqiS9q0=; b=sI0aNECrepin4o6ih0vH90
        bP0rnwYJND1vnI5jOgZ3XFsfaIUYop3VKRYU7GIFC0yIswCtN2OUoO9AUpvmVxNd
        ps7z+1XzakGv4094RVQ51V6wutBJ4HwHdN39YQmR/oEYUHGSEL1SLXg9tXaOVp+0
        mZ7ZG0AaoASUj1uXZwAX6EXthXw26UUHRVK3aqOgUgBs/s9Tbw4nhUriJjZUdmn6
        VMnriZUYYANmQRpsgHTL6Tdnb8hTO+wF84uFULoUv4gpw/TVImTg9qMjoFwtMMjV
        9KyBe92izVX/a5v7f0DwpJxSVB5jtdidOQvNNS8MbMSJj+fYq2Wa+/hFTqLv62Hg
        ==
X-ME-Sender: <xms:sO88YNtnF0aAQPjht5OW8TVxlyl0yGrDJm03-bCrnXcIZSUB5glPBw>
    <xme:sO88YGcWIM8WcH_0QwOugxLwWYxwcEJxgWXrpv87Co1ZIL0bseJrRyGMUeQ74K93g
    K2hdcKz1if3aw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:sO88YAxsHvU3GcsGI4yhv2vX_A1tqTrLtbwPb_nsUKljDihRNofViw>
    <xmx:sO88YEM1-vq2yRQ8FdrTDr14H0RZhg8Pvq8J0OrWic8K_J_E_ZTm_A>
    <xmx:sO88YN-jahg_ASV-SgKkGTliF0m_voqvKIyqr_LsRCum3JfilzwpFQ>
    <xmx:sO88YKF-ELj0V_rz9wfcQajKIbnEmGhp5OWmnf71elZ9doIa2TvGRA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CFF1F24005A;
        Mon,  1 Mar 2021 08:44:15 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm table: fix iterate_devices based device capability checks" failed to apply to 4.19-stable tree
To:     jefflexu@linux.alibaba.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:44:11 +0100
Message-ID: <1614606251118245@kroah.com>
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

From a4c8dd9c2d0987cf542a2a0c42684c9c6d78a04e Mon Sep 17 00:00:00 2001
From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Tue, 2 Feb 2021 11:35:28 +0800
Subject: [PATCH] dm table: fix iterate_devices based device capability checks

According to the definition of dm_iterate_devices_fn:
 * This function must iterate through each section of device used by the
 * target until it encounters a non-zero return code, which it then returns.
 * Returns zero if no callout returned non-zero.

For some target type (e.g. dm-stripe), one call of iterate_devices() may
iterate multiple underlying devices internally, in which case a non-zero
return code returned by iterate_devices_callout_fn will stop the iteration
in advance. No iterate_devices_callout_fn should return non-zero unless
device iteration should stop.

Rename dm_table_requires_stable_pages() to dm_table_any_dev_attr() and
elevate it for reuse to stop iterating (and return non-zero) on the
first device that causes iterate_devices_callout_fn to return non-zero.
Use dm_table_any_dev_attr() to properly iterate through devices.

Rename device_is_nonrot() to device_is_rotational() and invert logic
accordingly to fix improper disposition.

Fixes: c3c4555edd10 ("dm table: clear add_random unless all devices have it set")
Fixes: 4693c9668fdc ("dm table: propagate non rotational flag")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 4acf2342f7ad..3e211e64f348 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1295,6 +1295,46 @@ struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector)
 	return &t->targets[(KEYS_PER_NODE * n) + k];
 }
 
+/*
+ * type->iterate_devices() should be called when the sanity check needs to
+ * iterate and check all underlying data devices. iterate_devices() will
+ * iterate all underlying data devices until it encounters a non-zero return
+ * code, returned by whether the input iterate_devices_callout_fn, or
+ * iterate_devices() itself internally.
+ *
+ * For some target type (e.g. dm-stripe), one call of iterate_devices() may
+ * iterate multiple underlying devices internally, in which case a non-zero
+ * return code returned by iterate_devices_callout_fn will stop the iteration
+ * in advance.
+ *
+ * Cases requiring _any_ underlying device supporting some kind of attribute,
+ * should use the iteration structure like dm_table_any_dev_attr(), or call
+ * it directly. @func should handle semantics of positive examples, e.g.
+ * capable of something.
+ *
+ * Cases requiring _all_ underlying devices supporting some kind of attribute,
+ * should use the iteration structure like dm_table_supports_nowait() or
+ * dm_table_supports_discards(). Or introduce dm_table_all_devs_attr() that
+ * uses an @anti_func that handle semantics of counter examples, e.g. not
+ * capable of something. So: return !dm_table_any_dev_attr(t, anti_func);
+ */
+static bool dm_table_any_dev_attr(struct dm_table *t,
+				  iterate_devices_callout_fn func)
+{
+	struct dm_target *ti;
+	unsigned int i;
+
+	for (i = 0; i < dm_table_get_num_targets(t); i++) {
+		ti = dm_table_get_target(t, i);
+
+		if (ti->type->iterate_devices &&
+		    ti->type->iterate_devices(ti, func, NULL))
+			return true;
+        }
+
+	return false;
+}
+
 static int count_device(struct dm_target *ti, struct dm_dev *dev,
 			sector_t start, sector_t len, void *data)
 {
@@ -1595,12 +1635,12 @@ static int dm_table_supports_dax_write_cache(struct dm_table *t)
 	return false;
 }
 
-static int device_is_nonrot(struct dm_target *ti, struct dm_dev *dev,
-			    sector_t start, sector_t len, void *data)
+static int device_is_rotational(struct dm_target *ti, struct dm_dev *dev,
+				sector_t start, sector_t len, void *data)
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 
-	return q && blk_queue_nonrot(q);
+	return q && !blk_queue_nonrot(q);
 }
 
 static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
@@ -1611,23 +1651,6 @@ static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
 	return q && !blk_queue_add_random(q);
 }
 
-static bool dm_table_all_devices_attribute(struct dm_table *t,
-					   iterate_devices_callout_fn func)
-{
-	struct dm_target *ti;
-	unsigned i;
-
-	for (i = 0; i < dm_table_get_num_targets(t); i++) {
-		ti = dm_table_get_target(t, i);
-
-		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, func, NULL))
-			return false;
-	}
-
-	return true;
-}
-
 static int device_not_write_same_capable(struct dm_target *ti, struct dm_dev *dev,
 					 sector_t start, sector_t len, void *data)
 {
@@ -1779,27 +1802,6 @@ static int device_requires_stable_pages(struct dm_target *ti,
 	return q && blk_queue_stable_writes(q);
 }
 
-/*
- * If any underlying device requires stable pages, a table must require
- * them as well.  Only targets that support iterate_devices are considered:
- * don't want error, zero, etc to require stable pages.
- */
-static bool dm_table_requires_stable_pages(struct dm_table *t)
-{
-	struct dm_target *ti;
-	unsigned i;
-
-	for (i = 0; i < dm_table_get_num_targets(t); i++) {
-		ti = dm_table_get_target(t, i);
-
-		if (ti->type->iterate_devices &&
-		    ti->type->iterate_devices(ti, device_requires_stable_pages, NULL))
-			return true;
-	}
-
-	return false;
-}
-
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits)
 {
@@ -1849,10 +1851,10 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		dax_write_cache(t->md->dax_dev, true);
 
 	/* Ensure that all underlying devices are non-rotational. */
-	if (dm_table_all_devices_attribute(t, device_is_nonrot))
-		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
-	else
+	if (dm_table_any_dev_attr(t, device_is_rotational))
 		blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
+	else
+		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
 
 	if (!dm_table_supports_write_same(t))
 		q->limits.max_write_same_sectors = 0;
@@ -1864,8 +1866,11 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	/*
 	 * Some devices don't use blk_integrity but still want stable pages
 	 * because they do their own checksumming.
+	 * If any underlying device requires stable pages, a table must require
+	 * them as well.  Only targets that support iterate_devices are considered:
+	 * don't want error, zero, etc to require stable pages.
 	 */
-	if (dm_table_requires_stable_pages(t))
+	if (dm_table_any_dev_attr(t, device_requires_stable_pages))
 		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, q);
 	else
 		blk_queue_flag_clear(QUEUE_FLAG_STABLE_WRITES, q);
@@ -1876,7 +1881,7 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	 * Clear QUEUE_FLAG_ADD_RANDOM if any underlying device does not
 	 * have it set.
 	 */
-	if (blk_queue_add_random(q) && dm_table_all_devices_attribute(t, device_is_not_random))
+	if (blk_queue_add_random(q) && dm_table_any_dev_attr(t, device_is_not_random))
 		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
 
 	/*

