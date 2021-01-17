Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23342F92E1
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 15:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbhAQO10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 09:27:26 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:55563 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727967AbhAQO1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 09:27:25 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 90E0C1980FCF;
        Sun, 17 Jan 2021 09:26:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 17 Jan 2021 09:26:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5heAlo
        O3SjBTJV1aX422ZV4G56tkK33YPrrhpENEknc=; b=ChDFL9OV4m1q8s6alJX5xt
        sI7IJyY9Yr0Fxdys9vg+z3bnbzoMQSaTqd4csaOCNiY6PnMvuu4ssigVbfdd22fe
        tUfjynaEGsrJgemSK1nedgw0SP+XVG+L5/NWjaLijgFiBGkqGQfJj6Zvf/XNb9AY
        1OuMBXYR6MUbowC11sM2MhG03PtRhfOOzAz0lf+aS7FMRH+qbx/2xOSb1ti9XzFL
        e0VEgrGlACMEJE+rgpurm1pzLXA5NSm0h3X0UfHIA43Dn1QK7A/rohKoUjCPBDzD
        zUSy8hYcTSbXcS4FHEmXoO1rBcMeEQs1Pay2BbYfw1psQem0v5ZnD36P8eBt+96Q
        ==
X-ME-Sender: <xms:CkkEYA0Rmn9JYKp3bY1-BYLc4DDJcPjfL_0FTFlk7Zf8iTGfPk9Z0A>
    <xme:CkkEYLEM3QU5u7c-WfU_avKm0pZTc2YckSr-l0kip3MhzfHvLBYCAdZliVnwSiVY_
    8rhe3kCCxWEiQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:CkkEYI7FEUFuP5kXdR_M_AzYw4Sl6lfL7NHmA-7_S5Uc-Bml5amleA>
    <xmx:CkkEYJ0d2jNQbvOhjst0TK__YiHIIjadQHFC2TY1H1M331nP5CQ2-A>
    <xmx:CkkEYDFuebmg0sMXTEsKSnxbAryxliLJjXcGoHLlxqP6QNN_AZ1GoQ>
    <xmx:CkkEYJNfig3ZS_iBrBUwwlqBmE8RrhIHXdVG6eEwHKiyBDfMPOMW1A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3FFF3240057;
        Sun, 17 Jan 2021 09:26:18 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm integrity: fix flush with external metadata device" failed to apply to 4.19-stable tree
To:     mpatocka@redhat.com, lukasstraub2@web.de, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 17 Jan 2021 15:26:08 +0100
Message-ID: <161089356815125@kroah.com>
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

From 9b5948267adc9e689da609eb61cf7ed49cae5fa8 Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Fri, 8 Jan 2021 11:15:56 -0500
Subject: [PATCH] dm integrity: fix flush with external metadata device

With external metadata device, flush requests are not passed down to the
data device.

Fix this by submitting the flush request in dm_integrity_flush_buffers. In
order to not degrade performance, we overlap the data device flush with
the metadata device flush.

Reported-by: Lukas Straub <lukasstraub2@web.de>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 9c1a86bde658..fce4cbf9529d 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1534,6 +1534,12 @@ sector_t dm_bufio_get_device_size(struct dm_bufio_client *c)
 }
 EXPORT_SYMBOL_GPL(dm_bufio_get_device_size);
 
+struct dm_io_client *dm_bufio_get_dm_io_client(struct dm_bufio_client *c)
+{
+	return c->dm_io;
+}
+EXPORT_SYMBOL_GPL(dm_bufio_get_dm_io_client);
+
 sector_t dm_bufio_get_block_number(struct dm_buffer *b)
 {
 	return b->block;
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 5a7a1b90e671..11c7c538f7a9 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1379,12 +1379,52 @@ static int dm_integrity_rw_tag(struct dm_integrity_c *ic, unsigned char *tag, se
 #undef MAY_BE_HASH
 }
 
-static void dm_integrity_flush_buffers(struct dm_integrity_c *ic)
+struct flush_request {
+	struct dm_io_request io_req;
+	struct dm_io_region io_reg;
+	struct dm_integrity_c *ic;
+	struct completion comp;
+};
+
+static void flush_notify(unsigned long error, void *fr_)
+{
+	struct flush_request *fr = fr_;
+	if (unlikely(error != 0))
+		dm_integrity_io_error(fr->ic, "flusing disk cache", -EIO);
+	complete(&fr->comp);
+}
+
+static void dm_integrity_flush_buffers(struct dm_integrity_c *ic, bool flush_data)
 {
 	int r;
+
+	struct flush_request fr;
+
+	if (!ic->meta_dev)
+		flush_data = false;
+	if (flush_data) {
+		fr.io_req.bi_op = REQ_OP_WRITE,
+		fr.io_req.bi_op_flags = REQ_PREFLUSH | REQ_SYNC,
+		fr.io_req.mem.type = DM_IO_KMEM,
+		fr.io_req.mem.ptr.addr = NULL,
+		fr.io_req.notify.fn = flush_notify,
+		fr.io_req.notify.context = &fr;
+		fr.io_req.client = dm_bufio_get_dm_io_client(ic->bufio),
+		fr.io_reg.bdev = ic->dev->bdev,
+		fr.io_reg.sector = 0,
+		fr.io_reg.count = 0,
+		fr.ic = ic;
+		init_completion(&fr.comp);
+		r = dm_io(&fr.io_req, 1, &fr.io_reg, NULL);
+		BUG_ON(r);
+	}
+
 	r = dm_bufio_write_dirty_buffers(ic->bufio);
 	if (unlikely(r))
 		dm_integrity_io_error(ic, "writing tags", r);
+
+	if (flush_data)
+		wait_for_completion(&fr.comp);
 }
 
 static void sleep_on_endio_wait(struct dm_integrity_c *ic)
@@ -2110,7 +2150,7 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 
 	if (unlikely(dio->op == REQ_OP_DISCARD) && likely(ic->mode != 'D')) {
 		integrity_metadata(&dio->work);
-		dm_integrity_flush_buffers(ic);
+		dm_integrity_flush_buffers(ic, false);
 
 		dio->in_flight = (atomic_t)ATOMIC_INIT(1);
 		dio->completion = NULL;
@@ -2195,7 +2235,7 @@ static void integrity_commit(struct work_struct *w)
 	flushes = bio_list_get(&ic->flush_bio_list);
 	if (unlikely(ic->mode != 'J')) {
 		spin_unlock_irq(&ic->endio_wait.lock);
-		dm_integrity_flush_buffers(ic);
+		dm_integrity_flush_buffers(ic, true);
 		goto release_flush_bios;
 	}
 
@@ -2409,7 +2449,7 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned write_start,
 	complete_journal_op(&comp);
 	wait_for_completion_io(&comp.comp);
 
-	dm_integrity_flush_buffers(ic);
+	dm_integrity_flush_buffers(ic, true);
 }
 
 static void integrity_writer(struct work_struct *w)
@@ -2451,7 +2491,7 @@ static void recalc_write_super(struct dm_integrity_c *ic)
 {
 	int r;
 
-	dm_integrity_flush_buffers(ic);
+	dm_integrity_flush_buffers(ic, false);
 	if (dm_integrity_failed(ic))
 		return;
 
@@ -2654,7 +2694,7 @@ static void bitmap_flush_work(struct work_struct *work)
 	unsigned long limit;
 	struct bio *bio;
 
-	dm_integrity_flush_buffers(ic);
+	dm_integrity_flush_buffers(ic, false);
 
 	range.logical_sector = 0;
 	range.n_sectors = ic->provided_data_sectors;
@@ -2663,9 +2703,7 @@ static void bitmap_flush_work(struct work_struct *work)
 	add_new_range_and_wait(ic, &range);
 	spin_unlock_irq(&ic->endio_wait.lock);
 
-	dm_integrity_flush_buffers(ic);
-	if (ic->meta_dev)
-		blkdev_issue_flush(ic->dev->bdev, GFP_NOIO);
+	dm_integrity_flush_buffers(ic, true);
 
 	limit = ic->provided_data_sectors;
 	if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
@@ -2934,11 +2972,11 @@ static void dm_integrity_postsuspend(struct dm_target *ti)
 		if (ic->meta_dev)
 			queue_work(ic->writer_wq, &ic->writer_work);
 		drain_workqueue(ic->writer_wq);
-		dm_integrity_flush_buffers(ic);
+		dm_integrity_flush_buffers(ic, true);
 	}
 
 	if (ic->mode == 'B') {
-		dm_integrity_flush_buffers(ic);
+		dm_integrity_flush_buffers(ic, true);
 #if 1
 		/* set to 0 to test bitmap replay code */
 		init_journal(ic, 0, ic->journal_sections, 0);
diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
index 29d255fdd5d6..90bd558a17f5 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -150,6 +150,7 @@ void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned n);
 
 unsigned dm_bufio_get_block_size(struct dm_bufio_client *c);
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c);
+struct dm_io_client *dm_bufio_get_dm_io_client(struct dm_bufio_client *c);
 sector_t dm_bufio_get_block_number(struct dm_buffer *b);
 void *dm_bufio_get_block_data(struct dm_buffer *b);
 void *dm_bufio_get_aux_data(struct dm_buffer *b);

