Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775CC327FD4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbhCANpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:45:52 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:39657 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235807AbhCANpv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:45:51 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id A80ED194213F;
        Mon,  1 Mar 2021 08:44:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:44:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+7qd/w
        SRCCgMVAv3Dq5IE7QNRCjHSbhsjcwpT2dRA5c=; b=IWO9u6tOe2c9SXeXzIxbSZ
        AUS3GZetsDBBgHS2nYbRiRnVsuFcTnR1Kd0yC4vJgY7OWgTCUs5DeoYhgeAWQ9+F
        q5bh/sx4JyaFycP7AGu8/NoNYzb+bElerrWuiSRU6yfADDmELoL1nSBdBZ7E9GWs
        RUaSJdjyzwA7DsNrOnW/e2iN3hsVEvkWB+zDIqnHzXpqTIacEdFOTA8H6yLtsMyE
        ybBlh2ektv1F3eo5j+XoypwlSDAJ4d9Jr/W5e6TMPF4aRclgwaFoNMIY/ESYC/0R
        Xjqm3Rp5HKCUJcZoCLer/sRQkruV/0toTqqK3MIUVJFX+CEAS4ObcMV6c3+LuniQ
        ==
X-ME-Sender: <xms:0-88YPMXGqYZdt2aY1PK6paWq4YuJBSwXhPLAF4e11cJMe765tvQuQ>
    <xme:0-88YKn0h1kF5n-R3_wnwK1UwYJTNsRQ3oA_gFgKz8STs9xvkbA-NdIo3Cle96Kg3
    qCf-0Mp6WsxbA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:0-88YJbRELX3dHmMedW7iWZxAeiIGc0QmZXmwDV03Xwdeysy5XRpCQ>
    <xmx:0-88YIQLaZkfWELUo1_XLBBo_7aUCQ0TnDlGOftZduT89ojJQyMJVA>
    <xmx:0-88YLXedXsvntXKNG-G_4AheWqPMVLEsP3-Y_lbDYe4U1KPved_OQ>
    <xmx:0-88YGB7xSw2HVkntBVhBxYtvFaLTUJ7JObM4-U2MBJ0SQ9Sr5jT_A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3209224005C;
        Mon,  1 Mar 2021 08:44:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm table: fix DAX iterate_devices based device capability" failed to apply to 4.19-stable tree
To:     jefflexu@linux.alibaba.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:44:41 +0100
Message-ID: <1614606281251142@kroah.com>
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

From 5b0fab508992c2e120971da658ce80027acbc405 Mon Sep 17 00:00:00 2001
From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Mon, 8 Feb 2021 22:34:36 -0500
Subject: [PATCH] dm table: fix DAX iterate_devices based device capability
 checks

Fix dm_table_supports_dax() and invert logic of both
iterate_devices_callout_fn so that all devices' DAX capabilities are
properly checked.

Fixes: 545ed20e6df6 ("dm: add infrastructure for DAX support")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3e211e64f348..71f7ec508cf7 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -820,24 +820,24 @@ void dm_table_set_type(struct dm_table *t, enum dm_queue_mode type)
 EXPORT_SYMBOL_GPL(dm_table_set_type);
 
 /* validate the dax capability of the target device span */
-int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
+int device_not_dax_capable(struct dm_target *ti, struct dm_dev *dev,
 			sector_t start, sector_t len, void *data)
 {
 	int blocksize = *(int *) data, id;
 	bool rc;
 
 	id = dax_read_lock();
-	rc = dax_supported(dev->dax_dev, dev->bdev, blocksize, start, len);
+	rc = !dax_supported(dev->dax_dev, dev->bdev, blocksize, start, len);
 	dax_read_unlock(id);
 
 	return rc;
 }
 
 /* Check devices support synchronous DAX */
-static int device_dax_synchronous(struct dm_target *ti, struct dm_dev *dev,
-				  sector_t start, sector_t len, void *data)
+static int device_not_dax_synchronous_capable(struct dm_target *ti, struct dm_dev *dev,
+					      sector_t start, sector_t len, void *data)
 {
-	return dev->dax_dev && dax_synchronous(dev->dax_dev);
+	return !dev->dax_dev || !dax_synchronous(dev->dax_dev);
 }
 
 bool dm_table_supports_dax(struct dm_table *t,
@@ -854,7 +854,7 @@ bool dm_table_supports_dax(struct dm_table *t,
 			return false;
 
 		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, iterate_fn, blocksize))
+		    ti->type->iterate_devices(ti, iterate_fn, blocksize))
 			return false;
 	}
 
@@ -925,7 +925,7 @@ static int dm_table_determine_type(struct dm_table *t)
 verify_bio_based:
 		/* We must use this table as bio-based */
 		t->type = DM_TYPE_BIO_BASED;
-		if (dm_table_supports_dax(t, device_supports_dax, &page_size) ||
+		if (dm_table_supports_dax(t, device_not_dax_capable, &page_size) ||
 		    (list_empty(devices) && live_md_type == DM_TYPE_DAX_BIO_BASED)) {
 			t->type = DM_TYPE_DAX_BIO_BASED;
 		}
@@ -1618,23 +1618,6 @@ static int device_dax_write_cache_enabled(struct dm_target *ti,
 	return false;
 }
 
-static int dm_table_supports_dax_write_cache(struct dm_table *t)
-{
-	struct dm_target *ti;
-	unsigned i;
-
-	for (i = 0; i < dm_table_get_num_targets(t); i++) {
-		ti = dm_table_get_target(t, i);
-
-		if (ti->type->iterate_devices &&
-		    ti->type->iterate_devices(ti,
-				device_dax_write_cache_enabled, NULL))
-			return true;
-	}
-
-	return false;
-}
-
 static int device_is_rotational(struct dm_target *ti, struct dm_dev *dev,
 				sector_t start, sector_t len, void *data)
 {
@@ -1839,15 +1822,15 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	}
 	blk_queue_write_cache(q, wc, fua);
 
-	if (dm_table_supports_dax(t, device_supports_dax, &page_size)) {
+	if (dm_table_supports_dax(t, device_not_dax_capable, &page_size)) {
 		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
-		if (dm_table_supports_dax(t, device_dax_synchronous, NULL))
+		if (dm_table_supports_dax(t, device_not_dax_synchronous_capable, NULL))
 			set_dax_synchronous(t->md->dax_dev);
 	}
 	else
 		blk_queue_flag_clear(QUEUE_FLAG_DAX, q);
 
-	if (dm_table_supports_dax_write_cache(t))
+	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled))
 		dax_write_cache(t->md->dax_dev, true);
 
 	/* Ensure that all underlying devices are non-rotational. */
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 65b21159a7a6..64fda1429e39 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1133,7 +1133,7 @@ static bool dm_dax_supported(struct dax_device *dax_dev, struct block_device *bd
 	if (!map)
 		goto out;
 
-	ret = dm_table_supports_dax(map, device_supports_dax, &blocksize);
+	ret = dm_table_supports_dax(map, device_not_dax_capable, &blocksize);
 
 out:
 	dm_put_live_table(md, srcu_idx);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index fffe1e289c53..b441ad772c18 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -73,7 +73,7 @@ void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
 bool dm_table_supports_dax(struct dm_table *t, iterate_devices_callout_fn fn,
 			   int *blocksize);
-int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
+int device_not_dax_capable(struct dm_target *ti, struct dm_dev *dev,
 			   sector_t start, sector_t len, void *data);
 
 void dm_lock_md_type(struct mapped_device *md);

