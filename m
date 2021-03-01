Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99FC1327FEE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbhCANsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:48:15 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:59029 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235905AbhCANsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:48:14 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id ECD1C1942085;
        Mon,  1 Mar 2021 08:47:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:47:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=FazOiO
        P7i78Wnsp0JB+j6aVKCkovtjZUFncxX0bxvfM=; b=scxlnYF3eexxIvp8rH1MZx
        30dMESsisHTEcDRVDdJCFBhzjWLofvnAABbqb725KX/GUSuY7epWMDCmZbLaSEqW
        8n64PBhg0HCWTh60JNYOMuEWmy8QYHqBvIgkiCyWcix2dIKzHXwEvXy8JK7eajdJ
        c5Fh0VApkQ4aNykz9RMDhaK1HaCneqMU7K7mAktaDZ9SCajJoBEcZ9RuA7QlHTuK
        piHH0HXdWP7NxFj9WMVoUEWGNi846e/dBcHCBENxeyqtI1XKAyZT+LNd7CVI6y81
        4bBcv4/siINAaczsZBVvJ9ajTA/Gmvkr9fMSVzx4RWVzvpQnLErE/9lmnxuKYW6g
        ==
X-ME-Sender: <xms:b_A8YOm0Y08jgx176APodqChqzm3nKnsDDBhF4G6shLKC5vvfblGzw>
    <xme:b_A8YF15v35rE3UY0Z4ZD3s1yp9eHvthqlFsWfNmluxedlSNFZhj55x7RWma7HX_P
    WoJryCvdY9DIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:b_A8YMqSrH3AIogJiyLdBRuO0zBdL3XJL0OZuEM4bf_qi_24Cy0nZg>
    <xmx:b_A8YClod1G08Gh_K_CGE5rdh1_oaXBqTVxWmRpQHs2Kujfti7KQ3w>
    <xmx:b_A8YM3ze8e4TURdl52REcYBr2WjAa8SZeACl1AIb_kWoAQd2E4R6w>
    <xmx:b_A8YB9_6Tca0YzfLD9XB3HFHMP9jLRACy3lNJfdwehHcu2O299BmA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7F8B21080063;
        Mon,  1 Mar 2021 08:47:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm era: Update in-core bitset after committing the metadata" failed to apply to 4.14-stable tree
To:     ntsironis@arrikto.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:47:24 +0100
Message-ID: <1614606444226251@kroah.com>
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

From 2099b145d77c1d53f5711f029c37cc537897cee6 Mon Sep 17 00:00:00 2001
From: Nikos Tsironis <ntsironis@arrikto.com>
Date: Fri, 22 Jan 2021 17:19:31 +0200
Subject: [PATCH] dm era: Update in-core bitset after committing the metadata

In case of a system crash, dm-era might fail to mark blocks as written
in its metadata, although the corresponding writes to these blocks were
passed down to the origin device and completed successfully.

Consider the following sequence of events:

1. We write to a block that has not been yet written in the current era
2. era_map() checks the in-core bitmap for the current era and sees
   that the block is not marked as written.
3. The write is deferred for submission after the metadata have been
   updated and committed.
4. The worker thread processes the deferred write
   (process_deferred_bios()) and marks the block as written in the
   in-core bitmap, **before** committing the metadata.
5. The worker thread starts committing the metadata.
6. We do more writes that map to the same block as the write of step (1)
7. era_map() checks the in-core bitmap and sees that the block is marked
   as written, **although the metadata have not been committed yet**.
8. These writes are passed down to the origin device immediately and the
   device reports them as completed.
9. The system crashes, e.g., power failure, before the commit from step
   (5) finishes.

When the system recovers and we query the dm-era target for the list of
written blocks it doesn't report the aforementioned block as written,
although the writes of step (6) completed successfully.

The issue is that era_map() decides whether to defer or not a write
based on non committed information. The root cause of the bug is that we
update the in-core bitmap, **before** committing the metadata.

Fix this by updating the in-core bitmap **after** successfully
committing the metadata.

Fixes: eec40579d84873 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 854b1be8b452..62f679faf9e7 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -134,7 +134,7 @@ static int writeset_test_and_set(struct dm_disk_bitset *info,
 {
 	int r;
 
-	if (!test_and_set_bit(block, ws->bits)) {
+	if (!test_bit(block, ws->bits)) {
 		r = dm_bitset_set_bit(info, ws->md.root, block, &ws->md.root);
 		if (r) {
 			/* FIXME: fail mode */
@@ -1226,8 +1226,10 @@ static void process_deferred_bios(struct era *era)
 	int r;
 	struct bio_list deferred_bios, marked_bios;
 	struct bio *bio;
+	struct blk_plug plug;
 	bool commit_needed = false;
 	bool failed = false;
+	struct writeset *ws = era->md->current_writeset;
 
 	bio_list_init(&deferred_bios);
 	bio_list_init(&marked_bios);
@@ -1237,9 +1239,11 @@ static void process_deferred_bios(struct era *era)
 	bio_list_init(&era->deferred_bios);
 	spin_unlock(&era->deferred_lock);
 
+	if (bio_list_empty(&deferred_bios))
+		return;
+
 	while ((bio = bio_list_pop(&deferred_bios))) {
-		r = writeset_test_and_set(&era->md->bitset_info,
-					  era->md->current_writeset,
+		r = writeset_test_and_set(&era->md->bitset_info, ws,
 					  get_block(era, bio));
 		if (r < 0) {
 			/*
@@ -1247,7 +1251,6 @@ static void process_deferred_bios(struct era *era)
 			 * FIXME: finish.
 			 */
 			failed = true;
-
 		} else if (r == 0)
 			commit_needed = true;
 
@@ -1263,9 +1266,19 @@ static void process_deferred_bios(struct era *era)
 	if (failed)
 		while ((bio = bio_list_pop(&marked_bios)))
 			bio_io_error(bio);
-	else
-		while ((bio = bio_list_pop(&marked_bios)))
+	else {
+		blk_start_plug(&plug);
+		while ((bio = bio_list_pop(&marked_bios))) {
+			/*
+			 * Only update the in-core writeset if the on-disk one
+			 * was updated too.
+			 */
+			if (commit_needed)
+				set_bit(get_block(era, bio), ws->bits);
 			submit_bio_noacct(bio);
+		}
+		blk_finish_plug(&plug);
+	}
 }
 
 static void process_rpc_calls(struct era *era)

